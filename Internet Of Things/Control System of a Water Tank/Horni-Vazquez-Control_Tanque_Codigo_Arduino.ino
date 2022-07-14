// TP FINAL
// INSTRUMENTACION VIRTUAL 2022
// MANUEL HORNI PERALTA
// LEONARDO DAVID VAZQUEZ
// Control and Monitoring System of a Water Tank");
#include <SoftwareSerial.h>
SoftwareSerial mySerial(10, 11); // RX, TX
// Definitions
String inputString="";
String nameid="IDCMWTS  ";
unsigned long delta_t=1000;
bool state=false;
bool engine_lock = true ;
int engine_status = 0;
bool gate_status = false;
bool habil= true;
long before,now;
int th_min=200,th_max=900,thcr_min=100,thcr_max=1000;
int LED=5;
int ENGINE =13;
int ENGINE_CONTROL = 4;
int GATE = 3;
int measure;
int Buzz=2;

// Void Setup
void setup() {
  Serial.begin(9600);   //baud rate
  mySerial.begin(9600); // comunicación directa al Modulo.
  pinMode(LED, OUTPUT);
  pinMode(ENGINE, OUTPUT);
  pinMode(ENGINE_CONTROL,INPUT);
  pinMode(GATE,INPUT);
  pinMode(Buzz,OUTPUT);
}

// Void loop (The main loop)
void loop() {
  gate_status = digitalRead(GATE);
  serialEvent();
  measure = analogRead(0);
  engine_status = digitalRead(ENGINE_CONTROL);
  if (state == true)
  {
  automatic_engcontrol();
  }
  else if (state == false)
  {
    digitalWrite(ENGINE,LOW);
    digitalWrite(Buzz,LOW);
  }  
  if((measure >= th_max)||(measure >= thcr_max))
  {
    digitalWrite(ENGINE,LOW);
    digitalWrite(Buzz,LOW);
    }
  
  
  now=millis();
  if ((now-before>=delta_t) && state)
  {  
    send_messages();
    before=now;
  }
}

// Serial Event
void serialEvent(void)
{
  while(Serial.available())
  {
    char inChar=(char)Serial.read();
    inputString+=inChar;
    if(inChar=='\n')
    {
      decode_commands();
      inputString="";
    }
  }
    while(mySerial.available())
  {
    char inChar=(char)mySerial.read();
    inputString+=inChar;
    if(inChar=='\n')
    {
      decode_commands();
      inputString="";
    }
  }
}

// Decode Commands
void decode_commands(void)
{
  if(inputString.substring(0,4)=="IDEN")   //Control and Monitoring System of a Water Tank");
  {
    Serial.println(nameid); 
    mySerial.println(nameid);
  }
    if(inputString.substring(0,3)=="ID2")   //Control and Monitoring System of a Water Tank");
  {
    nameid=inputString.substring(3,20);
  }
  else if(inputString.substring(0,5)=="ONOFF") 
  {
    system_onoff();
    }
    
  else if (inputString.substring(0,5)=="ENGIN") //Engine Control
  {
        if (state == 1)
    {
       engine_control();
 
    }
    else if (state == 0)
    {
       Serial.println("SYS"+String(state));
       mySerial.println("SYS"+String(state));
    }  
  }  
  else if (inputString.substring(0,5)=="MEASR") // Measurements;
  {
    if (state == 1)
    {
      analog_measure();  
    }
    else if (state == 0)
    {
       Serial.println("SYS"+String(state));
       mySerial.println("SYS"+String(state));
    }
    }
    else if (inputString.substring(0,5)=="HABIL") // Measurements;
  {
    if (state == 1)
    {
      habilitate(); 
    }
    else if (state == 0)
    {
       Serial.println("SYS"+String(state));
       mySerial.println("SYS"+String(state));
    }
    }
    
  else if (inputString.substring(0,6)=="CONFIG") // Threshold Configurations;
  {
    if (state == 1)
    {
      threshold_config();  
    }
    else if (state == 0)
    {
      Serial.println("SYS"+String(state));
      mySerial.println("SYS"+String(state));
    }
    }
    
  else if (inputString.substring(0,6)=="THRQRY") //Threshold query
  {
    threshold_query();
    }
    
  else if (inputString.substring(0,6)=="THRRES") //Threshold reset
  {
        if (state == 1)
    {
       threshold_reset(); 
    }
    else if (state == 0)
    {
     Serial.println("SYS"+String(state));
     mySerial.println("SYS"+String(state));
    }
   }
     else if (inputString.substring(0,5)=="ALARM") //Alarm
  {
        if (state == 1)
    {
       alarm(); 
    }
    else if (state == 0)
    {
     Serial.println("SYS"+String(state));
     mySerial.println("SYS"+String(state));
    }
   }
  
}

// ONOFF System 
void system_onoff(void)
{
  int value = inputString.substring(5,6).toInt();
     switch (value) {
    case 0:
      state = false;
      digitalWrite(LED,LOW);
      Serial.println("SYS"+String(state));
      mySerial.println("SYS"+String(state));
      break;
    case 1:
      state = true;
      digitalWrite(LED,HIGH);
      Serial.println("SYS"+String(state));
      mySerial.println("SYS"+String(state));
      break;
    case 2:
       Serial.println("SYS"+String(state));
       mySerial.println("SYS"+String(state));
       break;
    default:
      break; 
     }
}


// habilitate

void habilitate(void)
{
  int value = inputString.substring(5,6).toInt();
  switch (value) {
    case 0:
          habil = false;
          break;
    case 1:
      habil =true;
      break;
    default:
      break; 
     } 

  
  }

// Engine Control
void engine_control(void)
{
    int value = inputString.substring(5,6).toInt();
    Serial.println("MODE"+String(value));
    mySerial.println("MODE"+String(value));
     switch (value) {
    case 0:
      digitalWrite(ENGINE,LOW);
      engine_lock = true;
      break;
    case 1:
      if((measure >= th_max)||(measure >= thcr_max))
      {
         digitalWrite(ENGINE,LOW);
      }
      else 
      {
      digitalWrite(ENGINE,HIGH);
      }
      engine_lock = true;
      break;
    case 2:
      engine_lock = false;
      break;
    default:
      break; 
     } 
}

// Automatic Engine Control

void automatic_engcontrol(void)
{
  if (engine_lock == false)
  {
  if ((measure >= th_max)||(measure >= thcr_max))
  {
    digitalWrite(ENGINE, LOW);
    } 
  else if ((measure <= th_min)||(measure <= thcr_min))
  {
    digitalWrite(ENGINE,HIGH);
  }
  }
}


// Analog Measurements
void analog_measure(void)
{ 
  int channel = inputString.substring(5,6).toInt();
  int data = analogRead(channel);
  Serial.println("AMSR"+String(channel)+String(data));
  mySerial.println("AMSR"+String(channel)+String(data));
}

// Threshold configurations
void threshold_config(void)
{
  int th_value = inputString.substring(6,7).toInt();
  int value = inputString.substring(7,11).toInt();
  switch (th_value) {
    case 0:
      th_min = value;
      break;
    case 1:
      th_max = value;
      break;
   case 2:
      thcr_min = value;
      break;
   case 3:
      thcr_max = value;
      break;
   default:
      break; 
     }
  if ((thcr_min > th_min) || (thcr_max < th_max) || (th_min > th_max)||(th_min<0)||(thcr_min<0)||(th_max>1024)||(thcr_max>1024))
  {
      threshold_reset();
  }
}

// Threshold reset
void threshold_reset(void)
{
  thcr_min = 100;
  th_min = 200;
  th_max = 900;
  thcr_max = 1000;
  }

//Threshold query
void threshold_query(void)
{
  Serial.println("UMB"+String(th_min)+","+String(th_max)+";"+String(thcr_min)+":"+String(thcr_max));
  mySerial.println("UMB"+String(th_min)+","+String(th_max)+";"+String(thcr_min)+":"+String(thcr_max));
  }

// Send messages

void send_messages(void)
{ 
  if (habil == true)
  {
  Serial.println("MSG"+String(engine_status)+String(gate_status)+String(measure));
  mySerial.println("MSG"+String(engine_status)+String(gate_status)+String(measure));
  }
}

void alarm(void)
{
  int value = inputString.substring(5,6).toInt();
     switch (value) {
    case 0:
      digitalWrite(Buzz,LOW);
      break;
    case 1:
      digitalWrite(Buzz,HIGH);
      break;
    default:
      break; 
     }
  }

 
