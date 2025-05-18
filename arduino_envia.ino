const int csPin = 8;  // Pin de Chip Select (CS)

void setup() {
  Serial.begin(9600);       // Velocidad UART
  pinMode(csPin, OUTPUT);   // Configurar el pin CS como salida
  digitalWrite(csPin, HIGH); // Inicialmente deshabilitado (HIGH)
}

void loop() {
  for (int i = 0; i < 16; i++) {
    digitalWrite(csPin, LOW);   // Habilitar comunicación (CS activo bajo)
    Serial.write(i);            // Enviar número binario de 0 a 15
    delay(500);                 // Mantener CS activo un tiempo visible
    digitalWrite(csPin, HIGH);  // Deshabilitar comunicación (CS desactivado)
    delay(1000);                // Espera de 1 segundo
  }
}
