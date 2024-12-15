#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

// Service name to the broadcasted to outside world
#define PERIPHERAL_NAME "Pseudo-bieznia"
#define SERVICE_UUID "CD9CFC21-0ECC-42E5-BF22-48AA715CA112"
#define CHARACTERISTIC_INPUT_UUID "66E5FFCE-AA96-4DC9-90C3-C62BBCCD29AC"
#define CHARACTERISTIC_OUTPUT_UUID "142F29DD-B1F0-4FA8-8E55-5A2D5F3E2471"

// Output characteristic is used to send the response back to the connected phone
BLECharacteristic *pOutputChar;

//treadmill control
#define single_rotation_distance 130.31 // in mm
#define km_to_mm (1000 * 100 * 10)
#define h_to_ms (60 * 60 * 1000)

#define potentiometer_min_value 1000
#define potentiometer_max_value 110
#define treadmill_min_incline 0.0
#define treadmill_max_incline 10.0

int potentiometerPin = 15; // reading of the treadmill inclination potentiometer
int upPin = 1;            // pick up the treadmill
int downPin = 3;          // pick down the treadmill
int motorPwmPin = 26;      // PWM pin for speed regulation
int speedReadPin = 12;     
int ledPin = 2;           // internal devboard led

unsigned long startTime;     
int pwmValue = 0;            // current pwm value
int targetValue = 255 * 0.3; // max PWM value (30% of 255)
String incomingCommand = "";
int single_rotation_duration = 0;
unsigned long lastInterruptTime = 0;
unsigned long interruptInterval = 0;

enum motor {
  speedUp = 0,
  slowDown = 1,
  m_standby = 2,
  turnOff = 3,
  turnOn = 4,
};

enum state {
  rising = 0,
  lowering = 1,
  standby = 2,
};

struct incline {
  int givenValue;
  state givenState;
  incline(int gv = 0, state rising = state::standby)
      : givenValue(gv), givenState(rising) {}
};

void get_rotation_time_from_speed(double speed) {
  if (speed == 0) {

    return;
  }
  if (speed < 1 || speed > 16) {
    return;
  }
  double mm_per_h = speed * km_to_mm;
  double mm_per_ms = mm_per_h / h_to_ms;
  single_rotation_duration = single_rotation_distance / mm_per_ms;
  Serial.print("Ustawiono interwał na: ");
  Serial.println(single_rotation_duration);
}

incline givenIncline(potentiometer_min_value, state::standby);

void set_potentiometr_value_for_incline(double incline) {
  if (incline < 0 || incline > 10) {
    // wartość nachylenia z poza zakresu
    return;
  }
  // funkcja zamienia kąt którą potencjometr ma osiągnąć

  if (incline == 0) {
    givenIncline.givenValue = potentiometer_min_value;
  } else {
    givenIncline.givenValue =
        int((incline - treadmill_min_incline) *
                (potentiometer_max_value - potentiometer_min_value) /
                (treadmill_max_incline - treadmill_min_incline) +
            potentiometer_min_value);
  }
  if (givenIncline.givenValue > analogRead(potentiometerPin) &&
      givenIncline.givenValue > potentiometer_min_value) {
    givenIncline.givenState = state::rising;
  } else if (givenIncline.givenValue < analogRead(potentiometerPin) &&
             givenIncline.givenValue < potentiometer_max_value) {
    givenIncline.givenState = state::lowering;
  } else {
    givenIncline.givenState = state::standby;
  }
}

void change_incline() {
  if (givenIncline.givenState == state::lowering) {

    if (givenIncline.givenValue > analogRead(potentiometerPin)) {
      digitalWrite(downPin, LOW);
      digitalWrite(upPin, LOW);
      givenIncline.givenState = state::standby;
    } else {
      digitalWrite(downPin, HIGH);
      digitalWrite(upPin, LOW);
    }
  } else if (givenIncline.givenState == state::rising) {

    if (givenIncline.givenValue < analogRead(potentiometerPin)) {
      digitalWrite(downPin, LOW);
      digitalWrite(upPin, LOW);
      givenIncline.givenState = state::standby;
    } else {
      digitalWrite(downPin, LOW);
      digitalWrite(upPin, HIGH);
    }
  } else { // givenIncline.givenState==state::standby
    digitalWrite(downPin, LOW);
    digitalWrite(upPin, LOW);
  }
}

// Funkcja obsługująca przerwanie
ICACHE_RAM_ATTR void handleInterrupt() {

  unsigned long currentInterruptTime =
      millis(); // Zapisz czas obecnego przerwania
  interruptInterval = currentInterruptTime -
                      lastInterruptTime; // Oblicz czas od ostatniego przerwania
  lastInterruptTime =
      currentInterruptTime; // Zaktualizuj czas ostatniego przerwania

  if (interruptInterval > single_rotation_duration) {
    // Serial.println("zwiekszenie predkosci");
    pwmValue += 1;
    analogWrite(motorPwmPin, pwmValue);
  } else if (interruptInterval < single_rotation_duration) {
    if (pwmValue > 10) {
      pwmValue -= 1;
      analogWrite(motorPwmPin, pwmValue);
    }
  }
}

void parse_command(){
      Serial.print("Odebrano komendę: ");
      Serial.println(incomingCommand);
      int spaceIndex = incomingCommand.indexOf(' ');
      if (spaceIndex > 0) {
        // Extract command name and parameter from the incoming command
        String commandName = incomingCommand.substring(0, spaceIndex);
        String parameterString = incomingCommand.substring(spaceIndex + 1);
        double parameterValue = parameterString.toDouble();
        Serial.print("Command: ");
        Serial.println(commandName);
        Serial.print("Parameter: ");
        Serial.println(parameterValue);
        handle_serial_command(commandName, parameterValue);
      }
      incomingCommand = "";
}

//communication 
void recive_serial_command() {
  if (Serial.available() > 0) {
    char receivedChar = Serial.read(); // Read a single character
    if (receivedChar == '\n') {
      // Newline received, process the command
      parse_command();
    } else {
      incomingCommand += receivedChar;
    }
  }
}

void handle_serial_command(String name, double param) {
  if (name == "incline") {
    set_potentiometr_value_for_incline(param);
  }
  if (name == "speed") {
    get_rotation_time_from_speed(param);
  }
}

// Class defines methods called when a device connects and disconnects from the service
class ServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
        Serial.println("BLE Client Connected");
    }
    void onDisconnect(BLEServer* pServer) {
        BLEDevice::startAdvertising();
        Serial.println("BLE Client Disconnected");
    }
};

class InputReceivedCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharWriteState) {
        std::string inputValue = pCharWriteState->getValue();
        if (inputValue.length() > 0) {
          Serial.print("Received Value: ");
          Serial.println(inputValue.c_str());
          incomingCommand = inputValue.c_str();
          parse_command();
          // Send data to client
          delay(1000);
          std::string outputData = "Last received: " + inputValue;
          pOutputChar->setValue(outputData);
          pOutputChar->notify();
        }
    }
};

void setup() {
  //treadmill setup
  pinMode(motorPwmPin, OUTPUT);
  digitalWrite(motorPwmPin, LOW);
  attachInterrupt(digitalPinToInterrupt(speedReadPin), handleInterrupt,
                  FALLING);

  analogWriteFreq(10000);
  pinMode(motorPwmPin, OUTPUT);
  pinMode(upPin, OUTPUT);
  pinMode(downPin, OUTPUT);
  digitalWrite(upPin, LOW);
  digitalWrite(downPin, LOW);

  startTime = millis();
  set_potentiometr_value_for_incline(0);
  // stopniowo rozpędź silnik
  analogWrite(motorPwmPin, pwmValue);

  get_rotation_time_from_speed(1);

//bluetooth setup
  Serial.begin(115200);
while (!Serial) {}
  // Initialize BLE
  BLEDevice::init(PERIPHERAL_NAME);

  // Create the server
  BLEServer *pServer = BLEDevice::createServer();
  
  // Create the service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Handle inputs (sent from app)
  BLECharacteristic *pInputChar 
      = pService->createCharacteristic(
                    CHARACTERISTIC_INPUT_UUID,                                        
                    BLECharacteristic::PROPERTY_WRITE_NR |
                    BLECharacteristic::PROPERTY_WRITE);

  pOutputChar = pService->createCharacteristic(
                        CHARACTERISTIC_OUTPUT_UUID,
                        BLECharacteristic::PROPERTY_READ |
                        BLECharacteristic::PROPERTY_NOTIFY);

  pServer->setCallbacks(new ServerCallbacks());                  
  pInputChar->setCallbacks(new InputReceivedCallbacks());
  
  // Start service
  pService->start();

  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  BLEDevice::startAdvertising();
}

void loop() { 
recive_serial_command();

change_incline();
}


