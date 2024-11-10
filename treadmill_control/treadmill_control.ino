#include <ESP8266WiFi.h>
//Definicja pinów
int potentiometerPin = A0; // Pin do odczytu potencjometru
int upPin=D1;   //Pin do podnoszenia bieżni
int downPin=D3; //Pin do obniżania bieżni
int motorPwmPin = D2; // Pin, na którym będzie generowany PWM


//zmienne pomocnicze
unsigned long startTime; // Czas rozpoczęcia
int pwmValue = 0; // Wartość PWM, która będzie się zmieniać
int targetValue = 255 * 0.3; // Docelowa wartość PWM (30% z 255)
int potentiometerValue = 0; // Zmienna do przechowywania wartości potencjometru



void setup() {

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

potentiometerValue = analogRead(potentiometerPin); 
if (potentiometerValue < 110) {
digitalWrite(downPin, LOW);
delay(5000);
digitalWrite(upPin, HIGH);
}
else if (potentiometerValue > 950) {
digitalWrite(upPin, LOW);
delay(5000);
digitalWrite(downPin, HIGH);
}

}
