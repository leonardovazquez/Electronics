// ADC for FSK demodulator

int analogPin = A0; 
uint32_t val      ;         // variable to store the value read

void setup() {
  Serial.begin(9600) ;           //  setup serial
  pinMode(13, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(9, OUTPUT) ;
}

void loop() {
  
  val = analogRead(analogPin);  // read the input pin
  Serial.println(val);          // debug value
  Serial.println(((float)val/1023)*5);
  delay(10);

  if (val >= 100 && val <170)      // values between 0,75 v & 1,1 v
  {
    digitalWrite(13, HIGH);
    digitalWrite(12,LOW)  ;
    digitalWrite(11, LOW) ;
    digitalWrite(10, LOW) ;
    digitalWrite(9, LOW)  ;
    }

    if (val >= 200 && val <280)      // values between 1,1 v & 1,4 v
  {
    digitalWrite(13, LOW);
    digitalWrite(12,HIGH);
    digitalWrite(11, LOW);
    digitalWrite(10, LOW);
    digitalWrite(9, LOW) ;
    }

      if (val >290 && val <350)      // values between 1,4 v & 1.7 v
  {
    digitalWrite(13, LOW) ;
    digitalWrite(12,LOW)  ;
    digitalWrite(11, HIGH);
    digitalWrite(10, LOW) ;
    digitalWrite(9, LOW) ;
    }

      if (val >= 355 && val <430)      // values between 1.7 v & 2,1 v
  {
    digitalWrite(13, LOW);
    digitalWrite(12,LOW) ;
    digitalWrite(11, LOW);
    digitalWrite(10,HIGH);
    digitalWrite(9, LOW) ;
    }

      if (val >= 435 && val <512)      // values between 2,1 v & 2.5 v
  {
    digitalWrite(13, LOW);
    digitalWrite(12,LOW) ;
    digitalWrite(11, LOW);
    digitalWrite(10, LOW);
    digitalWrite(9, HIGH);
    }
   
    
    
    if ((!(val >= 100 && val <170))||(!(val >= 200 && val <280))||(!(val >290 && val <350))||(!(val >= 355 && val <430))||(!(val >= 435 && val <512)))     // nul values
  {
    digitalWrite(13, LOW);
    digitalWrite(12,LOW) ;
    digitalWrite(11, LOW);
    digitalWrite(10, LOW);
    digitalWrite(9, LOW) ;
    }
   
 
  }
  
