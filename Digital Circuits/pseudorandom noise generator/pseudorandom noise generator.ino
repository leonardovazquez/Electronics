
/* Generador pseudoaleatorio con registro de desplazamiento
 * Leonardo David Vazquez - Juan Arenas Ferreira
*/
int registro[13];  //Registro de desplazamiento con 13 elementos
int secuencia[0]; //Secuencia de salida
void setup() {
  Serial.begin(9600);  //Velocidad en Baudios
  pinMode(10, OUTPUT); //Pin de salida
}
void loop() {
registro[0]=1;   //Inicializacion de registro
for (int i = 1;i < 8000 ;i++){     // Loop de la secuencia. Idealmente deberia ser 2^n-1, con n=13
    for (int j = 13; j> 0;j--){
        registro[j]=registro[j-1];} //Desplazamiento de bits en el registro, desde n=13 a n=0    
    if ((registro[10]) != (registro[1])){ //Algoritmo Xor entre los bits 10 y 1
      secuencia[0] = 1;    }
    else {
      secuencia[0] = 0;      } 
    registro[0]=secuencia[0]; //Bit de salida al primer elemento del registro
    // Serial.println(secuencia[0]); // Impresion de la secuencia por el puerto serie
    int sensorValue = analogRead(A0); //Lectura del pin analógico: Salida del filtro RC con fc en 80 Hz aproximadamente
    Serial.println(sensorValue); // Impresion de datos del sensor: 0-1024, mediante el puerto serie. 
    if (secuencia[0] == 1){  // Escritura de la secuencia mediante la salida digital: 0 == 0V ; 1 == 5V
      digitalWrite(10,HIGH);    }
    else if (secuencia[0] == 0){
      digitalWrite(10,LOW);    }
   delay(0.625); // Retencion de los valores, se interpreta como el periodo de reloj: fclock = 1600Hz
   if ((registro[0] == 0) & (registro[1] == 0) & (registro[2] == 0) & (registro[3] == 0) & (registro[4] == 0) & (registro[5] == 0) & (registro[6] == 0) & (registro[7] == 0) & (registro[8] == 0) & (registro[9] == 0) & (registro[10] == 0) & (registro[11] == 0) & (registro[12] == 0)) {
        registro[0] = 1; }// Condicion forzada para que siga la secuencia pseudoaleatoria             
}}
