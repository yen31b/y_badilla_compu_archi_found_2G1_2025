void setup() {
  Serial.begin(9600);  // velocidad UART
}

void loop() {
  for (int i = 0; i < 16; i++) {
    Serial.write(i);   // enviar número binario de 0 a 15
    delay(1000);       // espera de 1 segundo
  }
}