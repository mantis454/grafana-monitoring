/*
 UDPSendReceiveString:
 This sketch receives UDP message strings, prints them to the serial port
 and sends an "acknowledge" string back to the sender

 A Processing sketch is included at the end of file that can be used to send
 and received messages for testing with a computer.

 created 21 Aug 2010
 by Michael Margolis

 This code is in the public domain.
 */
#include <SPI.h>            // needed for Arduino versions later than 0018
#include <Ethernet.h>
#include <EthernetUdp.h>    // UDP library from: bjoern@cs.stanford.edu 12/30/2008
#include <DallasTemperature.h>
#include <OneWire.h>
#define SIZE 25

// Enter a MAC address and IP address for your controller below.
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
IPAddress ip(192, 168, 77, 174);

unsigned int localPort = 8888;      // local port to listen on
byte host[] = {192, 168, 77, 80};   // InfluxDB host
int port = 8888;                    // InfluxDB port for UDP data
char packetBuffer[UDP_TX_PACKET_MAX_SIZE];  //buffer to hold incoming packet,
char  ReplyBuffer[SIZE];       // a string to send back
float currentTemp;
long interval = 60000;    //measure temperature every 60 seconds
long prevMillis = 0;

// An EthernetUDP instance to let us send and receive packets over UDP
EthernetUDP Udp;

// Set up 1-wire network
#define ONE_WIRE_BUS 7                //1-wire on pin 7
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);
DeviceAddress insideThermometer = { 0x28, 0xA7, 0x4A, 0xC9, 0x02, 0x00, 0x00, 0x76 };   // temperature sensor address

void setup() {
  // start the Ethernet and UDP:
  Ethernet.begin(mac, ip);
  Udp.begin(localPort);

  Serial.begin(9600);
}

void printTemperature(DeviceAddress deviceAddress)
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
//      Serial.print("Getting temperatures...\n\r");
      sensors.requestTemperatures();
//      Serial.print("Inside temperature is: ");
//      printTemperature(insideThermometer);
//      Serial.print("\n\r");
      
      currentTemp = sensors.getTempC(insideThermometer);
  
  String line, temperature;
 
  delay(1000);
  temperature = String(currentTemp, 2);               // get the current temperature from the sensor, to 2 decimal places
  line = String("temperature value=" + temperature);  // concatenate the temperature into the line protocol
//  Serial.println(line);

    // send a reply to the IP address and port that sent us the packet we received
    Udp.beginPacket(host, port);
    Udp.print(line);
    Udp.endPacket();
  
  delay(10);
}
}


