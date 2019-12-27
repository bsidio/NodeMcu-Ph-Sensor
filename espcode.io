/* Ph by B Siddhartha
 *  https://bsid.io
 *  Calibrate the values before using
*/
#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <SoftwareSerial.h>
SoftwareSerial s(D9,D10);
float b, phValue=0;

const char* ssid     = "sid";
const char* password = "11112222";
 
ESP8266WebServer server(80);

String webString="";     // String to display

 
void handle_root() {
  server.send(200, "text/plain", "Hello from the ph esp8266, read from /ph ");
  delay(100);
  
}
 
void setup(void)
{
  // You can open the Arduino IDE Serial Monitor window to see what the code is doing
s.begin(9600);
Serial.begin(9600);  // Serial connection from ESP-01 via 3.3v console cable
Serial.println("Ready");         
 
  // Connect to WiFi network
  WiFi.begin(ssid, password);
  Serial.print("\n\r \n\rWorking to connect");
 
  // Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("PH Server");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
   
  server.on("/", handle_root);
  
  server.on("/ph", [](){  // if you add this subdirectory to your webserver call, you get text below :)
    getph();       // read sensor
    webString="Ph Value: "+String((float)phValue)+" ";   // Arduino has a hard time with float to string
    server.send(200, "text/plain", webString);            // send to someones browser when asked
  });
 
 
  
  server.begin();
  Serial.println("HTTP server started");
}
 
void loop(void)
{
  server.handleClient();
    float x;
    while (s.available() > 0) {
    String Data = s.readStringUntil('\n');
    x = Data.toFloat();
    Serial.println(x, 8);
}
  
 
} 
 
void getph() {
 
 
    float x;
    while (Serial.available() > 0) {
    String Data = Serial.readStringUntil('\n');
    x = Data.toFloat();
    Serial.println(x, 2);
    phValue=x;
}
  

}
