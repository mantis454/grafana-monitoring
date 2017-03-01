<?php
chdir(__DIR__);
// script to get stats from Mikrotik switch
// this script is cron'ed once a minute, but logs multiple times a minute
$perMinute = 3;
$count = 0;
require('routeros_api.class.php');
$router = new RouterosAPI();
if ($router->connect('192.168.77.99', 'admin', 'mantis454'))
{
	while($count < $perMinute)
//	while($count < 3)
	{
		$router->write('/interface/getall');
		$read = $router->read(false);
		$data = $router->parseResponse($read);
		$api = "";
		foreach($data as $d)
		{
			$api .= "cloudswitch,switch=home,port=$d[name],stat=byte,direction=rx value=" . $d['rx-byte'] . "\n";
			$api .= "cloudswitch,switch=home,port=$d[name],stat=byte,direction=tx value=" . $d['tx-byte'] . "\n";
			$api .= "cloudswitch,switch=home,port=$d[name],stat=packet,direction=rx value=" . $d['rx-packet'] . "\n";
			$api .= "cloudswitch,switch=home,port=$d[name],stat=packet,direction=tx value=" . $d['tx-packet'] . "\n";
		}
		//print $api;
		// post to grafana
		$url = "http://localhost:8086/write?db=home";
		$options = array(
			'http' => array(
			    'header'  => "Content-type: text/plain\r\n",
			    'method'  => 'POST',
			    'content' => "$api"
			),
		);
		$context  = stream_context_create($options);
		$result = file_get_contents($url, false, $context);
    // maybe fire more than once a minute
		$count++;
		sleep(60 / $perMinute);
//		sleep(18);
	}
	$router->disconnect();
}
