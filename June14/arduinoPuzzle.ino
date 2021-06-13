/*
  Name: Abdul Samad Gomda
  Description: Arduino push switch control
  Date: 14th June 2021
*/

// digital pin 3 has a pushSwitches attached to it.
const int pushSwitchRed = A2;
const int pushSwitchGreen = 4;
const int pushSwitchYellow = 6;
const int yellowLedPin = 8;
const int redLedPin = 11;
const int blueLedPin = 2;

// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  // make the pushbutton's pin an input:
  pinMode(pushSwitchRed, INPUT);
  pinMode(pushSwitchGreen, INPUT);
  pinMode(redLedPin, OUTPUT);
  pinMode(yellowLedPin, OUTPUT);
  pinMode(pushSwitchYellow, INPUT);
  pinMode(blueLedPin, OUTPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input pin:
  int switchRedState = digitalRead(pushSwitchRed);
  int switchGreenState = digitalRead(pushSwitchGreen);
  int switchYellowState = digitalRead(pushSwitchYellow);
  // making the puzzle with the leds

  if (switchRedState == HIGH && switchGreenState == HIGH) { // pressing the red button and green button
    // making red led blink
    digitalWrite(redLedPin, HIGH);
    delay(1000);
    digitalWrite(redLedPin, LOW);
    delay(500);

    // making blue pin blink
    digitalWrite(blueLedPin, HIGH);
    delay(500);
    digitalWrite(blueLedPin, LOW);
    delay(1000);

    // making red led blink
    digitalWrite(redLedPin, HIGH);
    delay(500);
    digitalWrite(redLedPin, LOW);
    delay(500);

    //making yellow Led blink
    digitalWrite(yellowLedPin, HIGH);
    delay(100);
    digitalWrite(yellowLedPin, LOW);
    delay(500);

  }  if (switchGreenState == HIGH && switchYellowState == HIGH) { // pressing the green button and yellow button
    // making the yellow led blink
    digitalWrite(yellowLedPin, HIGH);
    delay(500);
    digitalWrite(yellowLedPin, LOW);
    delay(500);

    // making the yellow led blink again
    digitalWrite(yellowLedPin, HIGH);
    delay(500);
    digitalWrite(yellowLedPin, LOW);
    delay(1000);

    // making red led blink
    digitalWrite(redLedPin, HIGH);
    delay(500);
    digitalWrite(redLedPin, LOW);
    delay(500);

    // making the blue led blink
    digitalWrite(blueLedPin, HIGH);
    delay(200);
    digitalWrite(blueLedPin, LOW);
    delay(200);

  } if (switchYellowState == HIGH && switchRedState == HIGH) {// pressing the yellow button and red button
    // making the blue led blink
    digitalWrite(blueLedPin, HIGH);
    delay(500);
    digitalWrite(blueLedPin, LOW);
    delay(500);

    // making red led blink
    digitalWrite(redLedPin, HIGH);
    delay(500);
    digitalWrite(redLedPin, LOW);
    delay(500);

    // making the yellow led blink
    digitalWrite(yellowLedPin, HIGH);
    delay(500);
    digitalWrite(yellowLedPin, LOW);
    delay(1000);

    // making the blue led blink
    digitalWrite(blueLedPin, HIGH);
    delay(500);
    digitalWrite(blueLedPin, LOW);
    delay(500);

    // making red led blink again for a shorter time
    digitalWrite(redLedPin, HIGH);
    delay(200);
    digitalWrite(redLedPin, LOW);
    delay(200);

  }

  delay(1);        // delay in between reads for stability
}
