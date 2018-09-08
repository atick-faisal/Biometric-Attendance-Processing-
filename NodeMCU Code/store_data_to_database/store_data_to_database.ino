#include <Adafruit_Fingerprint.h>
#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>

#define FIREBASE_HOST "nodemcu-data-logging.firebaseio.com"
#define FIREBASE_AUTH "74VVVprVqzrYFTjyuRhbzgxb31yWzo8a8r3hotJN"
#define WIFI_SSID "Free WiFi"
#define WIFI_PASSWORD "1988acca"

SoftwareSerial mySerial(14, 12, false, 256);

Adafruit_Fingerprint finger = Adafruit_Fingerprint(&mySerial);

String data = "";
String roll = "Roll_no_";

void setup() {
  Serial.begin(115200);
  while(!Serial);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());
  
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  finger.begin(57600);
  delay(1000);
}

uint8_t downloadFingerprintTemplate(uint16_t id) {
  uint8_t p = finger.loadModel(id);
  delay(100);
  p = finger.getModel();
  roll = roll + id;
  uint8_t bytesReceived[534];
  memset(bytesReceived, 0xff, 534);
  uint32_t starttime = millis();
  int i = 0;
  while (i < 534 && (millis() - starttime) < 20000) {
      if (mySerial.available()) {
          bytesReceived[i++] = mySerial.read();
      }
      delay(1);
  }
  uint8_t fingerTemplate[512];
  memset(fingerTemplate, 0xff, 512);
  int uindx = 9, index = 0;
  while (index < 534) {
      while (index < uindx) ++index;
      uindx += 256;
      while (index < uindx) {
          fingerTemplate[index++] = bytesReceived[index];
      }
      uindx += 2;
      while (index < uindx) ++index;
      uindx = index + 9;
  }
  for (int i = 0; i < 512; ++i) {
      printHex(fingerTemplate[i], 2);
  }
  Firebase.setString(roll, data);
  data = "";
  roll = "Roll_no_";
  Serial.println();
}



void printHex(int num, int precision) {
    char tmp[16];
    char format[128];
    sprintf(format, "%%.%dX", precision);
    sprintf(tmp, format, num);
    Serial.print(tmp);
    data = data + tmp;
}

void loop() {
  for (int finger = 1; finger < 6; finger++) {
    downloadFingerprintTemplate(finger);
    delay(1000);
  }
  delay(100000);
}
