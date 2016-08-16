/*
Read a One-Wire temperature sensor and send the result to an InfluxDB database using UDP for graphing with Grafana
 */
#include <SPI.h>            // needed for Arduino versions later than 0018
#include <Ethernet.h>
#include <EthernetUdp.h>    // UDP library from: bjoern@cs.stanford.edu 12/30/2008
#include <DallasTemperature.h>
#include <OneWire.h>
#define SIZE 25
#define ONE_WIRE_BUS 7      //1-wire on pin 7

// Enter a MAC address and IP address for your controller below.
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
IPAddress ip(192, 168, 77, 174);

unsigned int localPort = 8888;              // local port to listen on
byte host[] = {192, 168, 77, 80};           // InfluxDB host
int port = 8888;                            // InfluxDB port for UDP data
char packetBuffer[UDP_TX_PACKET_MAX_SIZE];  //buffer to hold incoming packet,
char  ReplyBuffer[SIZE];                    // a string to send back
float currentTemp;
long interval = 60000;                      //measure temperature every 60 seconds
long prevMillis = 0;

EthernetUDP Udp;            // An EthernetUDP instance to let us send and receive packets over UDP

// Set up 1-wire network
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);
DeviceAddress insideThermometer = { 0x28, 0xA7, 0x4A, 0xC9, 0x02, 0x00, 0x00, 0x76 };   // temperature sensor address

void setup() {
  // start the Ethernet and UDP:
  Ethernet.begin(mac, ip);
  Udp.begin(localPort);
  Serial.begin(9600);
}

void printTemperature(DeviceAddress deviceAddress) // don't think I even use this???
{
  float tempC = sensors.getTempC(deviceAddress);
  if (tempC == -127.00) {
    Serial.print("Error getting temperature");
  } else {
    Serial.print("C: ");
    Serial.print(tempC);
//    Serial.print(" F: ");
//    Serial.print(DallasTemperature::toFahrenheit(tempC));
  }
}

void loop() {

  unsigned long currentMillis = millis();

  if(currentMillis - prevMillis > interval){
      prevMillis = currentMillis;
      sensors.requestTemperatures();
      
      currentTemp = sensors.getTempC(insideThermometer);  // read temperature
      String line, temperature;
     
      delay(1000);                                        // wait 1 sec for some reason
      Serial.print(currentTemp);

      temperature = String(currentTemp, 2);               // get the current temperature from the sensor, to 2 decimal places
      line = String("temperature value=" + temperature);  // concatenate the temperature into the line protocol
    
      // send a UDP packed to InfluxDB
      Udp.beginPacket(host, port);
      Udp.print(line);
      Udp.endPacket();
      
      delay(10);      // another mystery delay
  }  
}


