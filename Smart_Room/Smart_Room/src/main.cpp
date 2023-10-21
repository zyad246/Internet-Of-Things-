#include <Arduino.h>
#if defined(ESP32) || defined(ARDUINO_RASPBERRY_PI_PICO_W)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#endif
#include <WiFiUdp.h>
#include <NTPClient.h>               
#include <TimeLib.h>     
#include <Firebase_ESP_Client.h>  
#include <LiquidCrystal.h>
LiquidCrystal lcd(22, 23, 5, 18, 19, 21);
// Provide the token generation process info.
#include <addons/TokenHelper.h>

// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>

#include <Keypad.h>

// Define the keypad layout
const byte ROWS = 1;
const byte COLS = 4;
char keys[ROWS][COLS] = {
{'1', '2', '3', 'A'}

};
byte rowPins[ROWS] = {33};
byte colPins[COLS] = {12, 13, 14, 15}; 
Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);


String getPass() {
  String pass = "";
  Serial.println("Enter Password:");
  while (true) {
    char customKey = keypad.getKey();
    if (customKey) {
      if (customKey == '3') { // '3' indicates the end of angle input
        break;
      } else if (customKey == '*') { // '*' cancels the input and returns -1
        pass = "";
        break;
      } else {
        pass += customKey;
        Serial.print(customKey);
      }
    }
  }

  return pass;
}
/* 1. Define the WiFi credentials */
#define WIFI_SSID "MHM2023"
#define WIFI_PASSWORD "123mhm123"

/** 2. Define the API key
 *
 * The API key (required) can be obtained since you created the project and set up
 * the Authentication in Firebase console. Then you will get the API key from
 * Firebase project Web API key in Project settings, on General tab should show the
 * Web API Key.
 *
 * You may need to enable the Identity provider at https://console.cloud.google.com/customer-identity/providers
 * Select your project, click at ENABLE IDENTITY PLATFORM button.
 * The API key also available by click at the link APPLICATION SETUP DETAILS.
 *
 */
#define API_KEY "AIzaSyCC70yblGuDF3JSTgejhlXHlMtiK737YrA"
#define DATABASE_URL "https://ass5-q2-default-rtdb.firebaseio.com/"

/* 3. Define the user Email and password that already registerd or added in your project */
#define USER_EMAIL "beo@gmail.com"
#define USER_PASSWORD getPass()

/* 4. If work with RTDB, define the RTDB URL */
// #define DATABASE_URL "URL" //<databaseName>.firebase

/** 5. Define the database secret (optional)
 *
 * This database secret needed only for this example to modify the database rules
 *
 * If you edit the database rules yourself, this is not required.
 */

/* 6. Define the Firebase Data object */
FirebaseData fbdo;

/* 7. Define the FirebaseAuth data for authentication data */
FirebaseAuth auth;

/* 8. Define the FirebaseConfig data for config data */
FirebaseConfig config;

unsigned long dataMillis = 0;
int count = 0;
unsigned long sendDataPreMillis = 0;
int irData = 0;

#if defined(ARDUINO_RASPBERRY_PI_PICO_W)
WiFiMulti multi;
#endif
// arduino B
#include <ESP32Servo.h>
Servo myservo;
int IR=32;
int servopin=4;
int value; // end of arduino B
//Arduino Flame Sensor
const int buzzerPin = 25;
const int flamePin = 26;
int Flame;
int redled = 2;
int led = 27;
int new_led = 0;
int servo_angle;
int fire;
int new_angle;
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "asia.pool.ntp.org", 10800,60000);
char Time[ ] = "TIME:04:00:00";
char Date[ ] = "DATE:06/07/2003";
byte last_second, second_, minute_, hour_, day_, month_;
int year_;
void setup()
{

    Serial.begin(115200);
    // arduino B
    lcd.begin(16, 2);
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print(Time);
    lcd.setCursor(0, 1);
    lcd.print(Date);
    // end of up to date
    myservo.attach(servopin);
    pinMode(IR,INPUT); 
    pinMode(buzzerPin, OUTPUT);
    pinMode(redled, OUTPUT);
    pinMode(flamePin, INPUT);
    pinMode(led, OUTPUT);  // end of arduino B

#if defined(ARDUINO_RASPBERRY_PI_PICO_W)
    multi.addAP(WIFI_SSID, WIFI_PASSWORD);
    multi.run();
#else
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
#endif

    Serial.print("Connecting to Wi-Fi");
    unsigned long ms = millis();
    while (WiFi.status() != WL_CONNECTED)
    {
        Serial.print(".");
        delay(90);
#if defined(ARDUINO_RASPBERRY_PI_PICO_W)
        if (millis() - ms > 10000)
            break;
#endif
    }
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());
    Serial.println();

    Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

    /* Assign the api key (required) */
    config.api_key = API_KEY;
    /* Assign the RTDB URL */
    config.database_url = DATABASE_URL;
    /* Assign the user sign in credentials */
    auth.user.email = USER_EMAIL;
    auth.user.password = USER_PASSWORD;
  
    // The WiFi credentials are required for Pico W
    // due to it does not have reconnect feature.
#if defined(ARDUINO_RASPBERRY_PI_PICO_W)
    config.wifi.clearAP();
    config.wifi.addAP(WIFI_SSID, WIFI_PASSWORD);
#endif

    Firebase.reconnectWiFi(true);
    fbdo.setResponseSize(4096);


    /* Assign the callback function for the long running token generation task */
    config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

    /* Initialize the library with the Firebase authen and config */
    Firebase.begin(&config, &auth);
    timeClient.begin();
}

void loop()
{
    // Firebase.ready() should be called repeatedly to handle authentication tasks.

    if (millis() - dataMillis > 5000 && Firebase.ready())
    {
        dataMillis = millis();
    
    if(Firebase.RTDB.getInt(&fbdo,"Sensor/led")){
      new_led=fbdo.to<int>();
    Serial.println("Successful");
    Serial.println(new_led);
  if(new_led == 1){
    digitalWrite(led, HIGH);
  }
    if(new_led == 0){
        digitalWrite(led, LOW);
    }
    else{
      digitalWrite(led, HIGH);
    }
    }
     Flame = digitalRead(flamePin);

  if (Flame == HIGH)
  {
    digitalWrite(buzzerPin, HIGH);
    digitalWrite(redled, HIGH);
    fire = 1;
  Firebase.RTDB.setInt(&fbdo,"Sensor/fire_stat", fire);
  }
  
  else
  {
    digitalWrite(buzzerPin, LOW);
    digitalWrite(redled, LOW);
    fire = 0;
    Firebase.RTDB.setInt(&fbdo,"Sensor/fire_stat", fire);
  }
    timeClient.update();
  unsigned long unix_epoch = timeClient.getEpochTime();    // Get Unix epoch time from the NTP serve5r
// up to date time
  second_ = second(unix_epoch);
  if (last_second != second_) {
 
    minute_ = minute(unix_epoch);
    hour_   = hour(unix_epoch);
    day_    = day(unix_epoch);
    month_  = month(unix_epoch);
    year_   = year(unix_epoch);

    Time[12] = second_ % 10 + 48;
    Time[11] = second_ / 10 + 48;
    Time[9]  = minute_ % 10 + 48;
    Time[8]  = minute_ / 10 + 48;
    Time[6]  = hour_   % 10 + 48;
    Time[5]  = hour_   / 10 + 48;

    Date[5]  = day_   / 10 + 48;
    Date[6]  = day_   % 10 + 48;
    Date[8]  = month_  / 10 + 48;
    Date[9]  = month_  % 10 + 48;
    Date[13] = (year_   / 10) % 10 + 48;
    Date[14] = year_   % 10 % 10 + 48;

    Serial.println(Time);
    Serial.println(Date);

    lcd.setCursor(0, 0);
    lcd.print(Time);
    lcd.setCursor(0, 1);
    lcd.print(Date);
    last_second = second_;
  }
 
    // send sensor data
    irData = analogRead(IR);
    value =map(irData, 0, 4095, 0, 25);
    if(Firebase.RTDB.setInt(&fbdo,"Sensor/ir_data", value)){
      Serial.println("Successful");
    }

  if(value < 7){
      myservo.write(160);
      servo_angle = 180; 
      Firebase.RTDB.setInt(&fbdo,"Sensor/door_stat", servo_angle);
       delay(10000);
  }
  else{
        myservo.write(33); 
        servo_angle = 0; 
        Firebase.RTDB.setInt(&fbdo,"Sensor/door_stat", servo_angle);
}
}
  }