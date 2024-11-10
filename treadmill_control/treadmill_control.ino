#include <ESP8266WiFi.h>
//Definicja pinów
int potentiometerPin = A0; // Pin do odczytu potencjometru
int upPin=D1;   //Pin do podnoszenia bieżni
int downPin=D3; //Pin do obniżania bieżni
int motorPwmPin = D2; // Pin, na którym będzie generowany PWM
int speedReadPin = D4; // Pin D4 do przerwania
int ledPin = D0;  // Wbudowana dioda LED na pinie D0
int givenSpeed=0;


//zmienne pomocnicze
unsigned long startTime; // Czas rozpoczęcia
int pwmValue = 0; // Wartość PWM, która będzie się zmieniać
int targetValue = 255 * 0.3; // Docelowa wartość PWM (30% z 255)
int potentiometerValue = 0; // Zmienna do przechowywania wartości potencjometru


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

incline givenIncline(0,state::standby);
int currentIncline=0;

#define potentiometer_min_value 99
#define potentiometer_max_value 1100
#define treadmill_min_incline 0.0
#define treadmill_max_incline 10.0
void get_treadmill_incline(double incline){
  //funkcja zamienia kąt na wartość potencjometru do osiągnięcia
  givenIncline.givenValue = int( (incline - treadmill_min_incline) * (potentiometer_max_value - potentiometer_min_value) / (treadmill_max_incline - treadmill_min_incline) + potentiometer_min_value);
  if (givenIncline.givenValue>currentIncline){
    givenIncline.givenState  = state::rising;
  }
  else if(givenIncline.givenValue<currentIncline ){
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
  digitalWrite(upPin, LOW);}
  else{
  digitalWrite(downPin, HIGH);
  digitalWrite(upPin, LOW);}
}
else if(givenIncline.givenState==state::rising){

  if(givenIncline.givenValue<analogRead(potentiometerPin)){
  digitalWrite(downPin, LOW);
  digitalWrite(upPin, LOW);}
  else{
  digitalWrite(downPin, LOW);
  digitalWrite(upPin, HIGH);}
}else{
  digitalWrite(downPin, LOW);
  digitalWrite(upPin, LOW);}
}

// Funkcja obsługująca przerwanie
ICACHE_RAM_ATTR void handleInterrupt() {
  digitalWrite(ledPin, HIGH);  // Włącz LED
  delay(100);                   // Czekaj 100 ms
  digitalWrite(ledPin, LOW);   // Wyłącz LED
}

void setup() {

pinMode(ledPin, OUTPUT);    // Ustawienie pinu D0 jako wyjście (LED)

attachInterrupt(digitalPinToInterrupt(speedReadPin), handleInterrupt, FALLING);

  analogWriteFreq(10000);  
  pinMode(motorPwmPin, OUTPUT);
  pinMode(upPin, OUTPUT);     
  pinMode(downPin, OUTPUT);    
  digitalWrite(upPin, LOW);
  digitalWrite(downPin, LOW);


  startTime = millis();

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

change_incline();

}
