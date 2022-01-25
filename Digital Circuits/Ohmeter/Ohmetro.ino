#include <TimerOne.h>


#define RESISTENCIA  10000     // Valor de la resistencia para los cálculos


uint32_t R;
uint32_t VR;
uint32_t V0;
volatile uint8_t mostrar = 0;

void setup() {
  
    pinMode(10, OUTPUT);
  digitalWrite(10, HIGH);
    Serial.begin(115200);
    /*
     * Configuramos el Timer 1 con interrupciones cada 1 segundo
     * para actualizar los datos en pantalla.
     */
    Timer1.initialize(1000000);
    Timer1.attachInterrupt(timer_isr);
}

void loop() {

  VR = analogRead(A0) ;
  V0 = analogRead(A1) ;
  R = RESISTENCIA*(V0-VR)/VR ;

  if (mostrar == 1)   // Si pasó 1 segundo, actualizamos datos en pantalla
  {

    Serial.print(" Vin=: " );
    Serial.print(((float)V0/1024)*5);
    Serial.print(" v" );
    Serial.print(" VR = " );
    Serial.print(((float)VR/1024)*5);
    Serial.print(" v" );
    Serial.print(" Resistencia: " );
  


  
  if (R < 980)   // Autorango. 
  {
       Serial.print(R);  
       Serial.println(" Ohms");
  } 
    if (R >= 980 && R <1000000)   // Autorango
  {
       Serial.print((float)R/1000);  // Convierto a float y divido por 1000 para sacar el factor de escala
       Serial.println(" KOhms");
  } 
      if (R >= 1000000)   // Autorango. Si es mayor a 0,98uF muestro en uF. Sino muestro en nF
  {
       Serial.print((float)R/1000000);  // Convierto a float y divido por 1000 para sacar el factor de escala
       Serial.println(" MOhms");
  } 
   
   
    Serial.println();
    mostrar = 0;
  }
 
}

/*
 * Interrupción del Timer 1 cada 1 segundo para actualizar los datos en la pantalla
 */

void timer_isr(void)
{
  mostrar = 1;
}
