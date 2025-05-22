const int csPin = 8;  // Pin de Chip Select (CS)

void setup() {
  Serial.begin(9600);       // Velocidad UART
  pinMode(csPin, OUTPUT);   // Configurar el pin CS como salida
  digitalWrite(csPin, HIGH); // Inicialmente deshabilitado (HIGH)
}

void loop() {
  for (int i = 0; i < 16; i++) {
    digitalWrite(csPin, LOW);
    Serial.write(i);
    delay(3000);  // Esperar a que FPGA responda

    // Verificar si hay respuesta de la FPGA
    if (Serial.available()) {
      int respuesta = Serial.read();
      Serial.print("FPGA respondió: ");
      Serial.println(respuesta, HEX);  // Mostrar en hexadecimal
    }

    digitalWrite(csPin, HIGH);
    delay(1000);
  }
}