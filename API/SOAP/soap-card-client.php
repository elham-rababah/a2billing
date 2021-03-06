<?php
/***************************************************************************
 *
 * soap-card-client.php : PHP A2Billing - Test Services
 * Written for PHP 4.x & PHP 5.X versions.
 *
 * A2Billing -- Asterisk billing solution.
 * Copyright (C) 2004, 2007 Belaid Arezqui <areski _atl_ gmail com>
 *
 * See http://www.asterisk2billing.org for more information about
 * the A2Billing project. 
 * Please submit bug reports, patches, etc to <areski _atl_ gmail com>
 *
 * This software is released under the terms of the GNU Lesser General Public License v2.1
 * A copy of which is available from http://www.gnu.org/copyleft/lesser.html
 *
 ****************************************************************************/

/***************************************************************************
 *
 * USAGE : http://domainname/A2Billing_UI/api/SOAP/soap-card-client.php
 *
 * http://localhost/~areski/svn/a2billing/trunk/A2Billing_UI/api/SOAP/soap-card-client.php
 *
 ****************************************************************************/
 
include ("../../lib/defines.php");
require('SOAP/Client.php');


$security_key = API_SECURITY_KEY;
$endpoint = 'http://localhost/~areski/svn/asterisk2billing/trunk/A2Billing_UI/api/SOAP/soap-card-server.php';
// ADD ON THE SPEC SECURITY KEY
$card = new SOAP_Client($endpoint);


//	#############   Reservation_Card   #############   

echo "<hr>#############   Reservation_Card : $ans[2]  #############   </hr>";
$method = 'Reservation_Card';   

$params = array('security_key' => md5($security_key), 'transaction_code' => 'mytransaction_code', 'card_id' => '', 'cardnumber' => '8995713909' );

$ans = $card->call($method, $params);

print_r($ans);
exit;

//	#############   Activation_Card   #############   

echo "<hr>#############   Activation_CARD : $ans[2]  #############   </hr>";
$method = 'Activation_Card';   
//Activation_Card($security_key, $transaction_code, $card_id, $cardnumber)
$params = array('security_key' => md5($security_key), 'transaction_code' => 'mytransaction_code', 'card_id' => '', 'cardnumber' => '8995713909' );

$ans = $card->call($method, $params);

print_r($ans);
exit;


//	#############  Batch_Activation_Card   #############   

echo "<hr>#############   Batch_Activation_Card : $ans[2]  #############   </hr>";
$method = 'Batch_Activation_Card';   

$params = array('security_key' => md5($security_key), 'transaction_code' => 'mytransaction_code', 'begin_card_id' => '2', 
				'end_card_id' => '4');

$ans = $card->call($method, $params);

print_r($ans);
exit;













//	#############   CREATE_CARD   #############   

echo "<hr>#############   CREATE_CARD   #############   </hr>";
$method = 'Create_Card';   

$params = array('security_key' => md5($security_key), 'transaction_code' => 'mytransaction_code', 'account_number' => 'myaccount_number', 'tariff' => '1', 'uipass' => '', 'credit' => '10', 'language' => 'en', 
'activated' => '1', 'status' => '2' , 'simultaccess' => '0', 'currency' => 'USD', 'runservice' => '0', 'typepaid' => '1', 'creditlimit' => '0', 
'enableexpire' => '0', 'expirationdate' => '', 'expiredays' => '0', 'lastname' => 'Areski', 'firstname' => 'Areski', 'address' => 'my address', 
'city' => 'mycity', 'state' => 'mystate', 'country' => 'mycoutry', 'zipcode' => '1000', 'phone' => '646486411', 'fax' => '', 
'callerid_list' => '21345114', 'iax_friend' => '1', 'sip_friend' => '0');

$ans = $card->call($method, $params);

print_r($ans);
exit;
//	#############   REMOVE_CARD   #############   

echo "<hr>#############   REMOVE_CARD : $ans[2]  #############   </hr>";
$method = 'Remove_Card';   

$params = array('security_key' => md5($security_key), 'transaction_code' => 'mytransaction_code', 'account_number' => 'myaccount_number', 
				'cardnumber' => $ans[2]);

$ans = $card->call($method, $params);

print_r($ans);
exit;
?>
