#include <SPI.h>
#include <MFRC522.h>

#define RST_PIN 9   // Pinul de reset
#define SS_PIN 10   // Pinul de Slave Select

MFRC522 mfrc522(SS_PIN, RST_PIN);  // Creează obiectul MFRC522

// UID-urile permise și nepermise
byte allowedUIDs[2][4] = {
  { 0xC3, 0xAD, 0xDC, 0x24 }, // UID permis 1
  { 0x43, 0xF4, 0xFB, 0x2C }  // UID permis 2
};

byte deniedUIDs[2][4] = {
  { 0x13, 0x8B, 0xFD, 0x0D }, // UID nepermis 1
  { 0x25, 0x90, 0x43, 0x02 }  // UID nepermis 2
};

void setup() {
  Serial.begin(9600);   // Inițializează comunicarea serială
  SPI.begin();          // Inițializează SPI
  mfrc522.PCD_Init();   // Inițializează modulul MFRC522
  Serial.println("Ready to scan cards...");
}

void loop() {
  // Verifică dacă un card este aproape
  if (mfrc522.PICC_IsNewCardPresent()) {
    // Citirea UID-ului cardului
    if (mfrc522.PICC_ReadCardSerial()) {
      Serial.print("Card UID: ");

      // Transmite UID-ul către Raspberry Pi
      for (byte i = 0; i < mfrc522.uid.size; i++) {
        if (mfrc522.uid.uidByte[i] < 0x10) {
          Serial.print("0");  // Adaugă zero înaintea valorii dacă este mai mică de 16
        }
        Serial.print(mfrc522.uid.uidByte[i], HEX);
        if (i < mfrc522.uid.size - 1) {
          Serial.print(":");  // Separator între bytes
        }
      }
      Serial.println();  // Trimite linia completă către Raspberry Pi

      // Verifică accesul
      if (isUIDAllowed(mfrc522.uid.uidByte)) {
        Serial.println("Access Granted!");  // Trimite statusul către Raspberry Pi
      } else if (isUIDDenied(mfrc522.uid.uidByte)) {
        Serial.println("Access Denied!");  // Trimite statusul către Raspberry Pi
      } else {
        Serial.println("UID Unknown!");    // Trimite statusul către Raspberry Pi
      }

      // Oprește citirea cardului pentru a preveni citirea repetată
      mfrc522.PICC_HaltA();
    }
  }
}

// Funcția care verifică dacă UID-ul citit este permis
bool isUIDAllowed(byte* uid) {
  for (int i = 0; i < 2; i++) {
    if (compareUID(uid, allowedUIDs[i])) {
      return true;
    }
  }
  return false;
}

// Funcția care verifică dacă UID-ul citit este nepermis
bool isUIDDenied(byte* uid) {
  for (int i = 0; i < 2; i++) {
    if (compareUID(uid, deniedUIDs[i])) {
      return true;
    }
  }
  return false;
}

// Funcția care compară două UID-uri
bool compareUID(byte* uid1, byte* uid2) {
  for (byte i = 0; i < 4; i++) {
    if (uid1[i] != uid2[i]) {
      return false; // Dacă un byte nu se potrivește, returnează false
    }
  }
  return true; // UID-urile se potrivesc
}
