#include <ESP8266WiFi.h>
//Definicja pinów
int potentiometerPin = A0; // Pin do odczytu potencjometru
int upPin=D1;   //Pin do podnoszenia bieżni
int downPin=D3; //Pin do obniżania bieżni
int motorPwmPin = D2; // Pin, na którym będzie generowany PWM
int speedReadPin = D4; // Pin D4 do przerwania
int ledPin = D0;  // Wbudowana dioda LED na pinie D0
String incomingCommand = "";


//zmienne pomocnicze
unsigned long startTime; // Czas rozpoczęcia
int pwmValue = 0; // Wartość PWM, która będzie się zmieniać
int targetValue = 255 * 0.3; // Docelowa wartość PWM (30% z 255)


#define potentiometer_min_value 1100
#define potentiometer_max_value 110
#define treadmill_min_incline 0.0
#define treadmill_max_incline 10.0

enum state{
  rising=0,
  lowering=1,
  standby=2,
};

struct incline{
  int givenValue;
  state givenState;
  incline(int gv = 0, state rising = state::standby) : givenValue(gv), givenState(rising) {}
};

incline givenIncline(potentiometer_min_value,state::standby);

void set_potentiometr_value_for_incline(double incline){
  if(incline<0||incline>10){
    //wartość nachylenia z poza zakresu
    return;
  }
  //funkcja zamienia kąt którą potencjometr ma osiągnąć

if(incline==0){
  givenIncline.givenValue=potentiometer_min_value;
}
else{
  givenIncline.givenValue = int( (incline - treadmill_min_incline) * (potentiometer_max_value - potentiometer_min_value) / (treadmill_max_incline - treadmill_min_incline) + potentiometer_min_value);
}
  if (givenIncline.givenValue>analogRead(potentiometerPin)){
    givenIncline.givenState  = state::rising;
  }
  else if(givenIncline.givenValue<analogRead(potentiometerPin) ){
     givenIncline.givenState= state::lowering;
  }
  else {
    givenIncline.givenState= state::standby;
  }

}

void change_incline(){
if(givenIncline.givenState==state::lowering){

  if(givenIncline.givenValue>analogRead(potentiometerPin)){
  digitalWrite(downPin, LOW);
  digitalWrite(upPin, LOW);
  givenIncline.givenState= state::standby;
  }
  else{
  digitalWrite(downPin, HIGH);
  digitalWrite(upPin, LOW);}
}
else if(givenIncline.givenState==state::rising){

  if(givenIncline.givenValue<analogRead(potentiometerPin)){
  digitalWrite(downPin, LOW);
  digitalWrite(upPin, LOW);
  givenIncline.givenState= state::standby;
  }
  else{
  digitalWrite(downPin, LOW);
  digitalWrite(upPin, HIGH);}
}else{//givenIncline.givenState==state::standby
  digitalWrite(downPin, LOW);
  digitalWrite(upPin, LOW);}
}

// Funkcja obsługująca przerwanie
ICACHE_RAM_ATTR void handleInterrupt() {
  digitalWrite(ledPin, HIGH);  // Włącz LED               // Czekaj 100 ms
  digitalWrite(ledPin, LOW);   // Wyłącz LED
}

void setup() {
Serial.begin(9600);
  while (!Serial) {
    ; // czekaj na połączenie z portem szeregowym
  }
pinMode(ledPin, OUTPUT);    // Ustawienie pinu D0 jako wyjście (LED)

attachInterrupt(digitalPinToInterrupt(speedReadPin), handleInterrupt, FALLING);

  analogWriteFreq(10000);  
  pinMode(motorPwmPin, OUTPUT);
  pinMode(upPin, OUTPUT);     
  pinMode(downPin, OUTPUT);    
  digitalWrite(upPin, LOW);
  digitalWrite(downPin, LOW);


  startTime = millis();
set_potentiometr_value_for_incline(0);
//stopniowo rozpędź silnik
  while (true) {
    unsigned long elapsedTime = millis() - startTime;
    
    if (elapsedTime > 10000) {
      break;  // Zakończenie pętli po 10 sekundach
    }

    pwmValue = map(elapsedTime, 0, 10000, 0, targetValue);  // Mapa czasu na zakres od 0 do docelowego PWM
    analogWrite(motorPwmPin, pwmValue);  // Ustaw PWM na pinie
    
    ESP.wdtFeed();  // Feed the watchdog timer
  }
}

void loop() {
recive_serial_command();

change_incline();

}

void recive_serial_command(){
  if (Serial.available() > 0) {
    char receivedChar = Serial.read();  // Read a single character
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
    }
    else {
      incomingCommand += receivedChar;
    }

  }
}

void handle_serial_command(String name, double param) {
    if (name == "incline") {
        set_potentiometr_value_for_incline(param);
    }

}

