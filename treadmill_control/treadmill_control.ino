#include <ESP8266WiFi.h>
// Definicja pinów
int potentiometerPin = A0; // Pin do odczytu potencjometru
int upPin = D1;            // Pin do podnoszenia bieżni
int downPin = D3;          // Pin do obniżania bieżni
int motorPwmPin = D2;      // Pin, na którym będzie generowany PWM
int speedReadPin = D4;     // Pin D4 do przerwania
int ledPin = D0;           // Wbudowana dioda LED na pinie D0

// zmienne pomocnicze
unsigned long startTime;     // Czas rozpoczęcia
int pwmValue = 5;            // Wartość PWM, która będzie się zmieniać
int targetValue = 255 * 0.3; // Docelowa wartość PWM (30% z 255)
String incomingCommand = "";
int single_rotation_duration = 0; // czas będzie przechowywany w milisekundach

unsigned long lastInterruptTime = 0; // Czas, ostatniego pomiaru
unsigned long interruptInterval = 0; // Czas, ostatniego pomiaru

enum motor {
  speedUp = 0,
  slowDown = 1,
  m_standby = 2,
  turnOff = 3,
  turnOn = 4,
};

#define single_rotation_distance 130.31 // in mm
#define km_to_mm (1000 * 100 * 10)
#define h_to_ms (60 * 60 * 1000)
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

#define potentiometer_min_value 1000
#define potentiometer_max_value 110
#define treadmill_min_incline 0.0
#define treadmill_max_incline 10.0

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

void setup() {
  Serial.begin(9600);
  while (!Serial) {
    ; // czekaj na połączenie z portem szeregowym
  }
  pinMode(ledPin, OUTPUT); // Ustawienie pinu D0 jako wyjście (LED)

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
}

void loop() {
  recive_serial_command();

  change_incline();
}

void recive_serial_command() {
  if (Serial.available() > 0) {
    char receivedChar = Serial.read(); // Read a single character
    if (receivedChar == '\n') {
      // Newline received, process the command
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
