/*
  Name: Abdul Samad Gomda
   Date: 07/08/2021
   Description: This is a rover built using arduino as my Intro to Interactive Media final
   there are two modes, the manual control mode and the self driving mode which can me controlled with the potentiometer
*/

#include <Servo.h>
#define NOTE_D3  147 // note to play when obstacle is encountered
#define echo 2              // HC-SR04 echo pin
#define trig 3              // HC-SR04 trig pin
const int MAX_SPEED = 100;

const int potPin = A0; // pin for the potentiometer
const int buzzPin = 9; // pin for piezzo buzzer
const int LDR = A1; // pin for the light dependent resistor
const int servoPin = A2;

// pins for rgb light
const int RED = 11;
const int GREEN = 12;
const int BLUE = 13;

// pins for motor driver
const int ain1Pin = 4;
const int ain2Pin = 10;
const int pwmAPin = 5;

const int bin1Pin = 7;
const int bin2Pin = 8;
const int pwmBPin = 6;

char serialVal;

Servo servoMotor;
bool Mapping = false; // boolean for when the rover should stop for mapping

int potValue; // variable for potentiometer value

char heading; // variable for movement direction

char selfD;

int LDRState; // variable for the LDR Value

int mapValue;
// processing code should have a means of changing the potValue


void setup() {

  Serial.begin(9600);
  pinMode(ain1Pin, OUTPUT);
  pinMode(ain2Pin, OUTPUT);
  pinMode(pwmAPin, OUTPUT);

  pinMode(bin1Pin, OUTPUT);
  pinMode(bin2Pin, OUTPUT);
  pinMode(pwmBPin, OUTPUT);

  pinMode(RED, OUTPUT);
  pinMode(GREEN, OUTPUT);
  pinMode(BLUE, OUTPUT);

  pinMode(trig, OUTPUT);
  pinMode(echo, INPUT);

  // servo initialization
  servoMotor.attach(servoPin);
  servoMotor.write(115);

  delay(5000);
  // wrinting so the buffer can stop
}

void loop() {
  // 0-3 = selfDriving, 7-10 = manual contron, 4 - 6 = stop
  LightsOn();// calling the function to check the brightness of the room
  potValue = map(analogRead(potPin), 0, 1023, 0, 10); // getting the potentiometer value and deciding between self-Driving and manual modes
  mapping();
  if (potValue <= 3) { // this is used to control the rover
    selfDrivingMode();
  } else if (potValue >= 7) {
    manualControlMode();
    delay(50);
  } else {
    brake();
  }
}

void LightsOn() {
  LDRState = analogRead(LDR); // reading the brightness of the room
  //Serial.println(LDRState);
  // brighting the LED if the environment is dark
  if (LDRState < 500) {
    digitalWrite(RED, HIGH);
    digitalWrite(BLUE, HIGH);
    digitalWrite(GREEN, HIGH);

  } else {
    digitalWrite(RED, LOW);
    digitalWrite(BLUE, LOW);
    digitalWrite(GREEN, LOW);
  }
}

// function to transmit mapping data to processing
void mapping() {
  int distance;

  if (Serial.available())
  { // If data is available to read,
    serialVal = Serial.read(); // read it and store it in val
  }
  if (serialVal == 'M')//if data transmitted is 'M' initiate mapping
  { brake();
    for (int angle = 0; angle <= 180; angle += 5) {
      servoMotor.write(angle);
      delay(5);
      distance = constrain(round(getDuration()), 0, 120);
      delay(5);
      // writing the values to the serial port
      Serial.print(angle);
      Serial.print(",");
      Serial.println(distance);
      delay(200); // delaying for 1/5 of a second
    }
  }
  //bringing the servo to default position
  servoMotor.write(115);
  Mapping = false;

}
void selfDrivingMode() {
  float distance = getDuration();// reading the distace
  Serial.println(distance);
  int rightDistance = 0;
  int leftDistance = 0;
  delay(20);
  // code to move rover
  if (distance <= 5) {
    brake();
    delay(10);
    moveBackward();
    delay(15);
    brake();
    delay(10);
    rightDistance = lookRight();
    leftDistance = lookLeft();
    delay(10);

    // checking which direction to move

    if (rightDistance >= leftDistance) {
      moveRight();
      brake();
    } else {
      moveLeft();
      brake();
    }

  } else {
    moveForward();
  }

}
//Moving forward in manual mode
void manualForward() {
  float distance = getDuration();// reading the distace
  if (Serial.available())
  { // If data is available to read,
    serialVal = Serial.read(); // read it and store it in val
  }
  if (serialVal == 'F')//if data transmitted is 'F' move wheels in same direction forward
  {
    if (distance >= 5) {
      analogWrite(pwmAPin, MAX_SPEED);
      digitalWrite(ain1Pin, HIGH);
      digitalWrite(ain2Pin, LOW);

      analogWrite(pwmBPin, MAX_SPEED);
      digitalWrite(bin1Pin, HIGH);
      digitalWrite(bin2Pin, LOW);
    } else {
      tone(buzzPin, NOTE_D3, 3000); // playing tone
    }

  }
}


//moving backwards in manual mode
void manualBackward() {
  if (Serial.available())
  { // If data is available to read,
    serialVal = Serial.read(); // read it and store it in val
  }
  if (serialVal == 'B')//if data transmitted is 'B' move wheels in same direction backwards
  {
    analogWrite(pwmAPin, MAX_SPEED);
    digitalWrite(ain1Pin, LOW);
    digitalWrite(ain2Pin, HIGH);

    analogWrite(pwmBPin, MAX_SPEED);
    digitalWrite(bin1Pin, LOW);
    digitalWrite(bin2Pin, HIGH);
  }
}

//Turning Right in manual mode
void manualRight() {

  if (Serial.available())
  { // If data is available to read,
    serialVal = Serial.read(); // read it and store it in val
  }
  if (serialVal == 'R')//if data transmitted is 'R' move left wheels in same direction forward
  {
    // turning right
    digitalWrite(ain1Pin, HIGH);
    digitalWrite(ain2Pin, LOW);
    digitalWrite(bin1Pin, LOW);
    digitalWrite(bin2Pin, LOW);
    analogWrite(pwmAPin, MAX_SPEED);
    analogWrite(pwmBPin, MAX_SPEED);
  }
}

//Turning Left in manual mode
void manualLeft() {

  if (Serial.available())
  { // If data is available to read,
    serialVal = Serial.read(); // read it and store it in val
  }
  if (serialVal == 'L')//if data transmitted is 'L' move right wheels in same direction forward
  {

    // turning left
    digitalWrite(ain1Pin, LOW);
    digitalWrite(ain2Pin, LOW);
    digitalWrite(bin1Pin, HIGH);
    digitalWrite(bin2Pin, LOW);
    analogWrite(pwmAPin, MAX_SPEED);
    analogWrite(pwmBPin, MAX_SPEED);

  }

}

//Stopping robot
void manualbrake() {

  if (Serial.available())
  { // If data is available to read,
    serialVal = Serial.read(); // read it and store it in val
  }
  if (serialVal == 'S')//if data transmitted is 'S' turn off all wheels
  {
    analogWrite(pwmAPin, MAX_SPEED);
    digitalWrite(ain1Pin, LOW);
    digitalWrite(ain2Pin, LOW);

    analogWrite(pwmBPin, MAX_SPEED);
    digitalWrite(bin1Pin, LOW);
    digitalWrite(bin2Pin, LOW);
  }

}

// function to read serial value
char serialReader() {
  char value;
  if (Serial.available()) {
    char value = Serial.read(); // reading the serial value
  }
  return value;
}

void manualControlMode() {
  // calling the manual control functions
  manualForward();
  manualBackward();
  manualRight();
  manualLeft();
  manualbrake();

}


void moveForward() {
  int speedControl = 0; // variable to slowly increase speed
  // moving both tires forward

  digitalWrite(ain1Pin, HIGH);
  digitalWrite(ain2Pin, LOW);
  digitalWrite(bin1Pin, HIGH);
  digitalWrite(bin2Pin, LOW);

  // slowly increasing the speed
  for (speedControl = 0; speedControl < MAX_SPEED; speedControl += 2) {
    analogWrite(pwmAPin, speedControl);
    analogWrite(pwmBPin, speedControl);
    delay(5);
  }
}

void moveBackward() {
  int speedControl = 0; // variable to slowly increase speed

  // moving both tires backward
  digitalWrite(ain1Pin, LOW);
  digitalWrite(ain2Pin, HIGH);
  digitalWrite(bin1Pin, LOW);
  digitalWrite(bin2Pin, HIGH);

  // slowly moving backwards
  for (speedControl = 0; speedControl < MAX_SPEED; speedControl += 2) {
    analogWrite(pwmAPin, speedControl);
    analogWrite(pwmBPin, speedControl);
    delay(5);
  }
}

void moveLeft() {
  int speedControl = 0; // variable to slowly increase speed


  // turning left
  digitalWrite(ain1Pin, LOW);
  digitalWrite(ain2Pin, LOW);
  digitalWrite(bin1Pin, HIGH);
  digitalWrite(bin2Pin, LOW);
  

  // slowly moving left
  for (speedControl = 0; speedControl < MAX_SPEED; speedControl += 2) {
    analogWrite(pwmAPin, speedControl);
    analogWrite(pwmBPin, speedControl);
    delay(5);
  }

}

void moveRight() {
  int speedControl = 0; // variable to slowly increase speed

  // turning right
  digitalWrite(ain1Pin, HIGH);
  digitalWrite(ain2Pin, LOW);
  digitalWrite(bin1Pin, LOW);
  digitalWrite(bin2Pin, LOW);
  

  // slowly moving right
  for (speedControl = 0; speedControl < MAX_SPEED; speedControl += 2) {
    analogWrite(pwmAPin, speedControl);
    analogWrite(pwmBPin, speedControl);
    delay(5);
  }
}

void brake() {

  // stoping the movement
  analogWrite(pwmAPin, MAX_SPEED);
  digitalWrite(ain1Pin, LOW);
  digitalWrite(ain2Pin, LOW);

  analogWrite(pwmBPin, MAX_SPEED);
  digitalWrite(bin1Pin, LOW);
  digitalWrite(bin2Pin, LOW);

}

float lookLeft() {
  servoMotor.write(30); // moving the servo left
  delay(500);
  float distance = getDuration();
  delay(100);
  servoMotor.write(115); // bringing the servo back to forward position
  delay(100);
  return distance;

}

float lookRight() {
  servoMotor.write(170); // moving the servo left
  delay(500);
  float distance = getDuration();
  delay(100);
  servoMotor.write(115); // bringing the servo back to forward position
  delay(100);
  return distance;

}


// function to get distance from the Ultrasonic Distance Sensor
float getDuration() {
  float echoTime;                   //variable to store the time it takes for a ping to bounce off an object
  float calculatedDistance;         //variable to store the distance calculated from the echo time

  //send out an ultrasonic pulse that's 10ms long
  digitalWrite(trig, HIGH);
  delayMicroseconds(10);
  digitalWrite(trig, LOW);

  echoTime = pulseIn(echo, HIGH);      //use the pulsein command to see how long it takes for the
  //pulse to bounce back to the sensor

  calculatedDistance = echoTime / 148.0;  //calculate the distance of the object that reflected the pulse (half the bounce time multiplied by the speed of sound)

  return calculatedDistance;              //send back the distance that was calculated
}
