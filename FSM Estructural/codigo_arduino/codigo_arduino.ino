const int signal_Arduino = 8;

void setup() {
  pinMode(signal_Arduino, INPUT_PULLUP); // Usa el pull-up interno
  Serial.begin(9600);
  Serial.println("Iniciando programa...");
}

void loop() {
  for (int i = 0; i < 16; i++) {
    while (digitalRead(signal_Arduino) == HIGH) {
      Serial.println("Esperando signal_Arduino en HIGH...");
      delay(200);
    }

    Serial.print("Enviando: ");
    Serial.println(i, HEX);
    Serial.write(i);
    delay(500);

    if (Serial.available()) {
      int respuesta = Serial.read();
      Serial.print("FPGA respondió: ");
      Serial.println(respuesta, HEX);
    }
    delay(1000);
  }
  Serial.println("Fin de la secuencia.");
  while (1);
}