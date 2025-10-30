#include <Wire.h>
#include <LiquidCrystal_I2C.h>

#define LDR_PIN 8        // OUT pin of LDR module
#define BIT_DELAY 200    // Must match your Flutter app delay

LiquidCrystal_I2C lcd(0x27, 16, 2);

String duration = "";
unsigned long lastSignalTime = 0;

// Message map
struct Message {
  String code;
  String text;
};

Message messages[] = {
  {"001", "Hi"},
  {"0001", "Hello"},
  {"00001", "How are you?"},
  {"000001", "I am fine"},
  {"0000001", "Ok"},
  {"00000001", "Good morning"},
  {"000000001", "Good afternoon"},
  {"0000000001", "Good evening"},
  {"00000000001", "Thank you"},
  {"000000000001", "Sorry"},
  {"0000000000001", "Welcome"},
  {"00000000000001", "What's up?"},
  {"000000000000001", "I'm busy"},
  {"0000000000000001", "Call me"},
  {"00000000000000001", "Miss you"},
  {"000000000000000001", "See you soon"},
  {"0000000000000000001", "Take care"},
  {"00000000000000000001", "Happy birthday"},
  {"000000000000000000001", "Congrats"},
  {"0000000000000000000001", "Good night"}
};

int numMessages = sizeof(messages) / sizeof(messages[0]);

void setup() {
  Serial.begin(9600);
  lcd.init();
  lcd.backlight();
  lcd.clear();
  lcd.print("Li-Fi Receiver");
  delay(2000);
  lcd.clear();
  pinMode(LDR_PIN, INPUT);
}

void loop() {
  int bitValue = digitalRead(LDR_PIN);
  unsigned long currentTime = millis();

  if (currentTime - lastSignalTime >= BIT_DELAY) {
    duration += String(bitValue);
    lastSignalTime = currentTime;

    // Detect idle period (end of transmission)
    static unsigned long lastLightTime = 0;
    if (bitValue == 0) lastLightTime = millis();

    if (millis() - lastLightTime > 600 && duration.length() > 0) {
      processMessage(duration);
      duration = "";
    }
  }
}

void processMessage(String binaryCode) {
  Serial.print("Received binary: ");
  Serial.println(binaryCode);

  String decoded = "";
  for (int i = 0; i < numMessages; i++) {
    if (messages[i].code == binaryCode) {
      decoded = messages[i].text;
      break;
    }
  }

  lcd.clear();
  if (decoded != "") {
    lcd.print(decoded);
    Serial.print("Decoded: ");
    Serial.println(decoded);
  } else {
    lcd.print("Unknown Msg");
    Serial.println("Unknown message");
  }
}
