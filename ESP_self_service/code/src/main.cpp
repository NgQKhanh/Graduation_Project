/*
 * White: TX
 * Green: RX
 */

#include <SPI.h>
#include <MFRC522.h>

#define SS_PIN  5  
#define RST_PIN 27 
#define BUZZER_PIN 0

MFRC522 rfid(SS_PIN, RST_PIN);

void setup() {
  Serial.begin(115200);
  
  SPI.begin(); // init SPI bus
  rfid.PCD_Init(); // init MFRC522

  pinMode(BUZZER_PIN, OUTPUT); 
  digitalWrite(BUZZER_PIN, LOW);
}

void loop() {
  if (rfid.PICC_IsNewCardPresent()) { // new tag is available
    if (rfid.PICC_ReadCardSerial()) { // NUID has been readed
      MFRC522::PICC_Type piccType = rfid.PICC_GetType(rfid.uid.sak);

      // print UID in Serial Monitor in the hex format
      for (int i = 0; i < rfid.uid.size; i++) {
        Serial.print(rfid.uid.uidByte[i], HEX);
      }
      Serial.println();

      // Bật còi
      digitalWrite(BUZZER_PIN, HIGH);
      delay(300); 
      digitalWrite(BUZZER_PIN, LOW);

      rfid.PICC_HaltA(); // halt PICC
      rfid.PCD_StopCrypto1(); // stop encryption on PCD
    }
  }
}
