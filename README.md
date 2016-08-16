# grafana-monitoring

A bunch of scripts to send data to InfluxDB, so it can be graphed with Grafana

Mostly stole idea's from:
https://denlab.io/setup-a-wicked-grafana-dashboard-to-monitor-practically-anything/
https://influxdata.com/blog/how-to-send-sensor-data-to-influxdb-from-an-arduino-uno/
https://gist.github.com/mwegner/c7bc69dd4d04ac354ef4b0a041cf8123

Get CPU usage and datastore info from Esxi using SNMP, memory usage from a script.
Get CPU usage and ZFS pool free space from Freenas using SNMP, CPU and disk temperature from a script.
Use SNMP to get temp of Mikrotik switch.
Use an Arduino with ethernet shield to get temperature from a 1-wire sensor and push to InfluxDB using UDP.
Another arduino script to submit data to InfluxDB via HTTP.
