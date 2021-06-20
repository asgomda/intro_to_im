/*
 Name: Abdul Samad Gomda
 Date: 19 June 2021
 Description: arduino musical instrument
 
 */
 
#include "pitches.h"        // file for pitch information
#include <Servo.h>          // importing Servo header file

#define buzzPin 4         // pin for Piezo buzzer
#define servoPin A2          // pin for Servo

#define greenButton 11      // increase frequency button

#define echo 6              // HC-SR04 echo pin
#define trig 7              // HC-SR04 trig pin

//#define potPin A5              // potentiometer pin

#define LDR A0              // pin for LDR


// notes to play, when the LDR is shaded or not
int lightNotes[] = {NOTE_A6, NOTE_B6, NOTE_C6, NOTE_D6, NOTE_E6, NOTE_F6, NOTE_C7, NOTE_D7,  NOTE_A7, NOTE_B7, NOTE_C7, NOTE_D7, NOTE_E7, NOTE_F7, NOTE_C8, NOTE_D8}; // 0-7 corresponds to a lower pitch, 8-16 corresponds to a higher pitch

int darkNotes[] = {NOTE_C4, NOTE_D4, NOTE_E4, NOTE_F4, NOTE_G4, NOTE_A4, NOTE_B4, NOTE_C5,   NOTE_C5, NOTE_D5, NOTE_E5, NOTE_F5, NOTE_G5, NOTE_A5, NOTE_B5, NOTE_C6};


int lightNotesStart, darkNotesStart, toneValue = 0;
int servoIncrement = 5;
int greenButtonState, LDRState, potState;
Servo servo;

void setup() {
  // put your setup code here, to run once:
  pinMode(greenButton, INPUT);
  pinMode(buzzPin, OUTPUT);
  pinMode(echo, INPUT);
  pinMode(trig, OUTPUT);

  pinMode(LDR, INPUT);
  // servo initialization
  servo.attach(servoPin);
  servo.write(0);
  Serial.begin(9600);
  

}

void loop() {
  // put your main code here, to run repeatedly
  //servo.write(servoIncrement++); // writing to the servo
  
  
  greenButtonState = digitalRead(greenButton); 
  LDRState = analogRead(LDR);
  
  
  // controlling the green button 
  if (greenButtonState == HIGH){
    lightNotesStart = 8;
    darkNotesStart = 8;
  } else {
    lightNotesStart = 0;
    darkNotesStart = 0;
  }

  // get servo's current angle
  int angle = servo.read();

  /// controlling the buzzer
  toneValue = map(getDuration(), 100, 2000, lightNotesStart, lightNotesStart+8); // mapping to the corresponding tone
  
  Serial.println(getDuration());
  delay(1);

  // alternating servo rotation (clockwise and anti-clockwise)
  if (angle + servoIncrement > 180 || angle + servoIncrement < 0) {
    servoIncrement = -servoIncrement;
  }

  int servoValue = angle + servoIncrement;
  servo.write(servoValue); // writing the angle
  delay(10);

  // playing buzzer tone depending on LDR value
  tone(buzzPin, LDRState > 600 ? lightNotes[toneValue] : darkNotes[toneValue]);
  
}




// function to get distance from the Ultrasonic Distance Sensor 
int getDuration() {
  digitalWrite(trig, LOW);   // for safety of the sensor
  delayMicroseconds(2);

  digitalWrite(trig, HIGH);   // sending an 8-cycle sonic burst from trig
  delayMicroseconds(10);      // delay for 10 microseconds
  digitalWrite(trig, LOW);

  // reading pulse on echo so we get the duration between sound wave striking on an object and returning back
  int duration = pulseIn(echo, HIGH);

  // to stay within boundaries
  duration = constrain(duration, 100, 2000);

  return duration;
}
