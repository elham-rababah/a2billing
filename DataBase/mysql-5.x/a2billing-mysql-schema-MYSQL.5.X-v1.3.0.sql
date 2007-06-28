--
-- A2Billing database script - Create user & create database for MYSQL 5.X
--

-- Usage:
-- mysql -u root -p"root password" < a2billing-mysql-schema-MYSQL.5.X-v1.2.0.sql 


--
-- A2Billing database - Create database schema
--
 



CREATE TABLE cc_didgroup (
    id 								BIGINT NOT NULL AUTO_INCREMENT,
    iduser 							INT DEFAULT 0 NOT NULL,
    didgroupname 					CHAR(50) NOT NULL,    
    creationdate   					TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;


CREATE TABLE cc_did_use (
    id 								BIGINT NOT NULL AUTO_INCREMENT,
    id_cc_card 						BIGINT ,
    id_did 							BIGINT NOT NULL,
    reservationdate 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    releasedate 					TIMESTAMP,
    activated 						INT	DEFAULT 0,
    month_payed 					INT DEFAULT 0,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;

CREATE TABLE cc_did (
    id 								BIGINT NOT NULL AUTO_INCREMENT,	
    id_cc_didgroup 					BIGINT NOT NULL,
    id_cc_country 					INT NOT NULL,    
    activated 						INT DEFAULT '1' NOT NULL,
    reserved 						INT DEFAULT '0',
    iduser 							INT DEFAULT '0' NOT NULL,
    did 							CHAR(50) NOT NULL,
    creationdate  					TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    startingdate  					TIMESTAMP,
    expirationdate 					TIMESTAMP,
    description 					MEDIUMTEXT,
    secondusedreal 					INT DEFAULT 0,
    billingtype 					INT DEFAULT 0,
    fixrate 						FLOAT DEFAULT 0 NOT NULL,
    PRIMARY KEY (id),
    UNIQUE cons_cc_did_did (did)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;


-- billtype: 0 = fix per month + dialoutrate, 1= fix per month, 2 = dialoutrate, 3 = free



CREATE TABLE cc_did_destination (
    id 									BIGINT NOT NULL AUTO_INCREMENT,	
    destination 						CHAR(50) NOT NULL,
    priority 							INT DEFAULT 0 NOT NULL,
    id_cc_card 							BIGINT NOT NULL,
    id_cc_did 							BIGINT NOT NULL,	
    creationdate  						TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    activated 							INT DEFAULT 1 NOT NULL,
    secondusedreal 						INT DEFAULT 0,	
    voip_call 							INT DEFAULT 0,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;




CREATE TABLE cc_charge (
    id 									BIGINT NOT NULL AUTO_INCREMENT,
    id_cc_card 							BIGINT NOT NULL,
    iduser 								INT DEFAULT '0' NOT NULL,
    creationdate 						TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount 								FLOAT DEFAULT 0 NOT NULL,
	currency 							CHAR(3) DEFAULT 'USD',
    chargetype 							INT DEFAULT 0,    
    description 						MEDIUMTEXT,
    id_cc_did 							BIGINT DEFAULT 0,
	id_cc_subscription_fee				BIGINT DEFAULT 0,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;

CREATE INDEX ind_cc_charge_id_cc_card				ON cc_charge (id_cc_card);
CREATE INDEX ind_cc_charge_id_cc_subscription_fee 	ON cc_charge (id_cc_subscription_fee);
CREATE INDEX ind_cc_charge_creationdate 			ON cc_charge (creationdate);



CREATE TABLE cc_paypal (
    id 								INT (11) NOT NULL AUTO_INCREMENT,
    payer_id 						VARCHAR(60) DEFAULT NULL,
    payment_date 					VARCHAR(50) DEFAULT NULL,
    txn_id 							VARCHAR(50) DEFAULT NULL,
    first_name 						VARCHAR(50) DEFAULT NULL,
    last_name 						VARCHAR(50) DEFAULT NULL,
    payer_email 					VARCHAR(75) DEFAULT NULL,
    payer_status 					VARCHAR(50) DEFAULT NULL,
    payment_type 					VARCHAR(50) DEFAULT NULL,
    memo 							TINYTEXT,
    item_name 						VARCHAR(127) DEFAULT NULL,
    item_number 					VARCHAR(127) DEFAULT NULL,
    quantity 						INT (11) NOT NULL DEFAULT '0',
    mc_gross 						DECIMAL(9,2) DEFAULT NULL,
    mc_fee 							DECIMAL(9,2) DEFAULT NULL,
    tax 							DECIMAL(9,2) DEFAULT NULL,
    mc_currency 					CHAR(3) DEFAULT NULL,
    address_name 					VARCHAR(255) NOT NULL DEFAULT '',
    address_street 					VARCHAR(255) NOT NULL DEFAULT '',
    address_city 					VARCHAR(255) NOT NULL DEFAULT '',
    address_state 					VARCHAR(255) NOT NULL DEFAULT '',
    address_zip 					VARCHAR(255) NOT NULL DEFAULT '',
    address_country 				VARCHAR(255) NOT NULL DEFAULT '',
    address_status 					VARCHAR(255) NOT NULL DEFAULT '',
    payer_business_name 			VARCHAR(255) NOT NULL DEFAULT '',
    payment_status					VARCHAR(255) NOT NULL DEFAULT '',
    pending_reason 					VARCHAR(255) NOT NULL DEFAULT '',
    reason_code 					VARCHAR(255) NOT NULL DEFAULT '',
    txn_type 						VARCHAR(255) NOT NULL DEFAULT '',
    PRIMARY KEY  (id),
    UNIQUE KEY txn_id (txn_id),
    KEY txn_id_2 (txn_id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;



CREATE TABLE cc_voucher (
    id 										BIGINT NOT NULL AUTO_INCREMENT,   
    creationdate 							TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usedate 								TIMESTAMP,
    expirationdate 							TIMESTAMP,
    voucher 								CHAR(50) NOT NULL,
    usedcardnumber 							CHAR(50),
    tag 									CHAR(50),
    credit 									FLOAT DEFAULT 0 NOT NULL,
    activated 								CHAR(1) DEFAULT 'f' NOT NULL,
    used 									INT DEFAULT 0,    
    currency 								CHAR(3) DEFAULT 'USD',
    PRIMARY KEY (id),
    UNIQUE cons_cc_voucher_voucher (voucher)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;



CREATE TABLE cc_service (
    id 										BIGINT NOT NULL AUTO_INCREMENT,	
    name 									CHAR(100) NOT NULL, 
    amount 									FLOAT NOT NULL,	
    period 									INT NOT NULL DEFAULT '1',	
    rule 									INT NOT NULL DEFAULT '0',
    daynumber 								INT NOT NULL DEFAULT '0',
    stopmode 								INT NOT NULL DEFAULT '0',
    maxnumbercycle 							INT NOT NULL DEFAULT '0',	
    status 									INT NOT NULL DEFAULT '0',	
    numberofrun 							INT NOT NULL DEFAULT '0',	
    datecreate 								TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    datelastrun 							TIMESTAMP,
    emailreport 							CHAR(100) NOT NULL,
    totalcredit 							FLOAT NOT NULL DEFAULT '0',
    totalcardperform 						INT NOT NULL DEFAULT '0',
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;
	


CREATE TABLE cc_service_report (
    id 										BIGINT NOT NULL AUTO_INCREMENT,
    cc_service_id 							BIGINT NOT NULL,
    daterun 								TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    totalcardperform 						INT ,
    totalcredit 							FLOAT ,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;



CREATE TABLE cc_callerid (
    id 										BIGINT NOT NULL AUTO_INCREMENT,
    cid 									CHAR(100) NULL,
    id_cc_card 								BIGINT NOT NULL,
    activated 								CHAR(1) DEFAULT 't' NOT NULL,
    PRIMARY KEY (id),
    UNIQUE cons_cc_callerid_cid (cid)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;


CREATE TABLE cc_ui_authen (
    userid 									BIGINT NOT NULL AUTO_INCREMENT,
    login 									CHAR(50) NOT NULL,
    password 								CHAR(50) NOT NULL,
    groupid 								INT ,
    perms 									INT ,
    confaddcust 							INT ,
    name 									CHAR(50),
    direction 								CHAR(80),
    zipcode 								CHAR(20),
    state 									CHAR(20),
    phone 									CHAR(30),
    fax 									CHAR(30),
    datecreation 							TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (userid),
    UNIQUE cons_cc_ui_authen_login (login)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;



CREATE TABLE cc_call (
    id 									bigINT (20) NOT NULL AUTO_INCREMENT,
    sessionid 							char(40) NOT NULL,
    uniqueid 							char(30) NOT NULL,
    username 							char(40) NOT NULL,
    nasipaddress 						char(30) DEFAULT NULL,
    starttime 							timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    stoptime 							timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
    sessiontime 						INT (11) DEFAULT NULL,
    calledstation 						char(30) DEFAULT NULL,
    startdelay 							INT (11) DEFAULT NULL,
    stopdelay 							INT (11) DEFAULT NULL,
    terminatecause 						char(20) DEFAULT NULL,
    usertariff 							char(20) DEFAULT NULL,
    calledprovider 						char(20) DEFAULT NULL,
    calledcountry 						char(30) DEFAULT NULL,
    calledsub 							char(20) DEFAULT NULL,
    calledrate 							FLOAT DEFAULT NULL,
    sessionbill 						FLOAT DEFAULT NULL,
    destination 						char(40) DEFAULT NULL,
    id_tariffgroup 						INT (11) DEFAULT NULL,
    id_tariffplan 						INT (11) DEFAULT NULL,
    id_ratecard 						INT (11) DEFAULT NULL,
    id_trunk 							INT (11) DEFAULT NULL,
    sipiax 								INT (11) DEFAULT '0',
    src 								char(40) DEFAULT NULL,
    id_did 								INT (11) DEFAULT NULL,
    buyrate 							DECIMAL(15,5) DEFAULT 0,
    buycost 							DECIMAL(15,5) DEFAULT 0,
	id_card_package_offer 				INT (11) DEFAULT 0,
    PRIMARY KEY  (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;


CREATE TABLE cc_templatemail (
    mailtype 						CHAR(50),
    fromemail 						CHAR(70),
    fromname 						CHAR(70),
    subject 						CHAR(70),
    messagetext 					LONGTEXT,
    messagehtml 					LONGTEXT,
    UNIQUE cons_cc_templatemail_mailtype (mailtype)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;




CREATE TABLE cc_tariffgroup (
    id 								INT NOT NULL AUTO_INCREMENT,
    iduser 							INT DEFAULT 0 NOT NULL,
    idtariffplan 					INT DEFAULT 0 NOT NULL,
    tariffgroupname 				CHAR(50) NOT NULL,
    lcrtype 						INT DEFAULT 0 NOT NULL,
    creationdate  					TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    removeinterprefix 				INT DEFAULT 0 NOT NULL,
	id_cc_package_offer 			BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;


CREATE TABLE cc_tariffgroup_plan (
    idtariffgroup 					INT NOT NULL,
    idtariffplan 					INT NOT NULL,
    PRIMARY KEY (idtariffgroup, idtariffplan)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;


CREATE TABLE cc_tariffplan (
    id 								INT NOT NULL AUTO_INCREMENT,
    iduser 							INT DEFAULT 0 NOT NULL,
    tariffname 						CHAR(50) NOT NULL,
    creationdate 					TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    startingdate 					TIMESTAMP,
    expirationdate 					TIMESTAMP,
    description 					MEDIUMTEXT,
    id_trunk 						INT DEFAULT 0,
    secondusedreal 					INT DEFAULT 0,
    secondusedcarrier 				INT DEFAULT 0,
    secondusedratecard 				INT DEFAULT 0,
    reftariffplan 					INT DEFAULT 0,
    idowner 						INT DEFAULT 0,
    dnidprefix 						CHAR(30) NOT NULL DEFAULT 'all',
	calleridprefix 					CHAR(30) NOT NULL DEFAULT 'all',
    PRIMARY KEY (id),
    UNIQUE cons_cc_tariffplan_iduser_tariffname (iduser,tariffname)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;


CREATE TABLE cc_card (
    id 								BIGINT NOT NULL AUTO_INCREMENT,
    creationdate 					TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    firstusedate 					TIMESTAMP,
    expirationdate 					TIMESTAMP,
    enableexpire 					INT DEFAULT 0,
    expiredays 						INT DEFAULT 0,
    username 						CHAR(50) NOT NULL,
    useralias 						CHAR(50) NOT NULL,
    userpass 						CHAR(50) NOT NULL,
    uipass 							CHAR(50),
    credit 							DECIMAL(15,5) DEFAULT 0 NOT NULL,
    tariff 							INT DEFAULT 0,
    id_didgroup 					INT DEFAULT 0,
    activated 						CHAR(1) DEFAULT 'f' NOT NULL,
    lastname 						CHAR(50),
    firstname 						CHAR(50),
    address 						CHAR(100),
    city 							CHAR(40),
    state 							CHAR(40),
    country 						CHAR(40),
    zipcode 						CHAR(20),
    phone 							CHAR(20),
    email 							CHAR(70),
    fax 							CHAR(20),
    inuse 							INT DEFAULT 0,
    simultaccess 					INT DEFAULT 0,
    currency 						CHAR(3) DEFAULT 'USD',
    lastuse  						TIMESTAMP,
    nbused 							INT DEFAULT 0,
    typepaid 						INT DEFAULT 0,
    creditlimit 					INT DEFAULT 0,
    voipcall 						INT DEFAULT 0,
    sip_buddy 						INT DEFAULT 0,
    iax_buddy 						INT DEFAULT 0,
    language 						CHAR(5) DEFAULT 'en',
    redial 							CHAR(50),
    runservice 						INT DEFAULT 0,
	nbservice 						INT DEFAULT 0,
    id_campaign						INT DEFAULT 0,
    num_trials_done 				BIGINT DEFAULT 0,
    callback 						CHAR(50),
	vat 							FLOAT DEFAULT 0 NOT NULL,
	servicelastrun 					TIMESTAMP,
	initialbalance 					DECIMAL(15,5) DEFAULT 0 NOT NULL,
	invoiceday 						INT DEFAULT 1,
	autorefill 						INT DEFAULT 0,
    loginkey 						CHAR(40),
    activatedbyuser 				CHAR(1) DEFAULT 't' NOT NULL,
	id_subscription_fee 			INT DEFAULT 0,
	mac_addr						CHAR(17) DEFAULT '00-00-00-00-00-00' NOT NULL,
    PRIMARY KEY (id),
    UNIQUE cons_cc_card_username (username),
    UNIQUE cons_cc_card_useralias (useralias)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;


CREATE TABLE cc_ratecard (
    id 								INT NOT NULL AUTO_INCREMENT,
    idtariffplan 					INT DEFAULT 0 NOT NULL,
    dialprefix 						CHAR(30) NOT NULL,
    destination 					CHAR(50) NOT NULL,
    buyrate 						FLOAT DEFAULT 0 NOT NULL,
    buyrateinitblock 				INT DEFAULT 0 NOT NULL,
    buyrateincrement 				INT DEFAULT 0 NOT NULL,
    rateinitial 					FLOAT DEFAULT 0 NOT NULL,
    initblock 						INT DEFAULT 0 NOT NULL,
    billingblock 					INT DEFAULT 0 NOT NULL,
    connectcharge 					FLOAT DEFAULT 0 NOT NULL,
    disconnectcharge 				FLOAT DEFAULT 0 NOT NULL,
    stepchargea 					FLOAT DEFAULT 0 NOT NULL,
    chargea 						FLOAT DEFAULT 0 NOT NULL,
    timechargea 					INT DEFAULT 0 NOT NULL,
    billingblocka 					INT DEFAULT 0 NOT NULL,
    stepchargeb 					FLOAT DEFAULT 0 NOT NULL,
    chargeb 						FLOAT DEFAULT 0 NOT NULL,
    timechargeb 					INT DEFAULT 0 NOT NULL,
    billingblockb 					INT DEFAULT 0 NOT NULL,
    stepchargec 					FLOAT DEFAULT 0 NOT NULL,
    chargec 						FLOAT DEFAULT 0 NOT NULL,
    timechargec 					INT DEFAULT 0 NOT NULL,
    billingblockc 					INT DEFAULT 0 NOT NULL,
    startdate 						TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    stopdate 						TIMESTAMP,
    starttime 						SMALLINT (5) unsigned DEFAULT '0',
    endtime 						SMALLINT (5) unsigned DEFAULT '10079',
    id_trunk 						INT DEFAULT -1,
    musiconhold 					CHAR(100) NOT NULL,
	freetimetocall_package_offer 	INT NOT NULL DEFAULT 0,
	id_outbound_cidgroup INT DEFAULT -1,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;
CREATE INDEX ind_cc_ratecard_dialprefix ON cc_ratecard (dialprefix);


CREATE TABLE cc_logrefill (
    id 								INT NOT NULL AUTO_INCREMENT,
    date 							TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    credit 							FLOAT NOT NULL,
    card_id 						BIGINT NOT NULL,
    reseller_id 					BIGINT ,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;


CREATE TABLE cc_logpayment (
    id 								INT NOT NULL AUTO_INCREMENT,
    date 							TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    payment 						FLOAT NOT NULL,
    card_id 						BIGINT NOT NULL,
    reseller_id 					BIGINT ,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;



CREATE TABLE cc_trunk (
    id_trunk 						INT NOT NULL AUTO_INCREMENT,
    trunkcode 						CHAR(20) NOT NULL,
    trunkprefix 					CHAR(20),
    providertech 					CHAR(20) NOT NULL,
    providerip 						CHAR(80) NOT NULL,
    removeprefix 					CHAR(20),
    secondusedreal 					INT DEFAULT 0,
    secondusedcarrier 				INT DEFAULT 0,
    secondusedratecard 				INT DEFAULT 0,
    creationdate 					TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    failover_trunk 					INT ,
    addparameter 					CHAR(120),
    id_provider 					INT ,
    PRIMARY KEY (id_trunk)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;




CREATE TABLE cc_sip_buddies (
    id 								INT NOT NULL AUTO_INCREMENT,
    id_cc_card 						INT DEFAULT 0 NOT NULL,
    name 							CHAR(80) DEFAULT '' NOT NULL,
    accountcode 					CHAR(20),
    regexten 						CHAR(20),
    amaflags 						CHAR(7),
    callgroup 						CHAR(10),
    callerid 						CHAR(80),
    canreinvite 					CHAR(3) DEFAULT 'yes',
    context 						CHAR(80),
    DEFAULTip 						CHAR(15),
    dtmfmode 						CHAR(7)  DEFAULT 'RFC2833' NOT NULL,	 
    fromuser 						CHAR(80),
    fromdomain 						CHAR(80),
    host 							CHAR(31) DEFAULT '' NOT NULL,
    insecure 						CHAR(4),
    language 						CHAR(2),
    mailbox 						CHAR(50),
    md5secret 						CHAR(80),
    nat 							CHAR(3) DEFAULT 'yes',
    permit 							CHAR(95),
    deny 							CHAR(95),
    mask 							CHAR(95),
    pickupgroup 					CHAR(10),
    port 							CHAR(5) DEFAULT '' NOT NULL,
    qualify 						CHAR(7) DEFAULT 'yes',
    restrictcid 					CHAR(1),
    rtptimeout 						CHAR(3),
    rtpholdtimeout 					CHAR(3),
    secret 							CHAR(80),
    type 							CHAR(6) DEFAULT 'friend' NOT NULL,
    username 						CHAR(80) DEFAULT '' NOT NULL,
    disallow 						CHAR(100) DEFAULT 'all',
    allow 							CHAR(100) DEFAULT 'gsm,ulaw,alaw',
    musiconhold 					CHAR(100),
    regseconds 						INT DEFAULT 0 NOT NULL,
    ipaddr 							CHAR(15) DEFAULT '' NOT NULL,
    cancallforward 					CHAR(3) DEFAULT 'yes',
    fullcontact 					VARCHAR(80) DEFAULT NULL,
    setvar 							VARCHAR(100) NOT NULL DEFAULT '',
    PRIMARY KEY (id),
    UNIQUE cons_cc_sip_buddies_name (name)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;


CREATE TABLE cc_iax_buddies (
    id 										INT NOT NULL AUTO_INCREMENT,
    id_cc_card 								INT DEFAULT 0 NOT NULL,
    name 									CHAR(80) DEFAULT '' NOT NULL,
    accountcode 							CHAR(20),
    regexten 								CHAR(20),
    amaflags 								CHAR(7),
    callgroup 								CHAR(10),
    callerid 								CHAR(80),
    canreinvite 							CHAR(3) DEFAULT 'yes',
    context 								CHAR(80),
    DEFAULTip 								CHAR(15),
    dtmfmode 								CHAR(7)  DEFAULT 'RFC2833' NOT NULL,	 
    fromuser 								CHAR(80),
    fromdomain 								CHAR(80),
    host 									CHAR(31) DEFAULT '' NOT NULL,
    insecure 								CHAR(4),
    language 								CHAR(2),
    mailbox 								CHAR(50),
    md5secret 								CHAR(80),
    nat 									CHAR(3) DEFAULT 'yes',
    permit 									CHAR(95),
    deny 									CHAR(95),
    mask 									CHAR(95),
    pickupgroup 							CHAR(10),
    port 									CHAR(5) DEFAULT '' NOT NULL,
    qualify 								CHAR(7) DEFAULT 'yes',
    restrictcid 							CHAR(1),
    rtptimeout 								CHAR(3),
    rtpholdtimeout 							CHAR(3),
    secret 									CHAR(80),
    type 									CHAR(6) DEFAULT 'friend' NOT NULL,
    username 								CHAR(80) DEFAULT '' NOT NULL,
    disallow 								CHAR(100) DEFAULT 'all',
    allow 									CHAR(100) DEFAULT 'gsm,ulaw,alaw',
    musiconhold 							CHAR(100),
    regseconds 								INT DEFAULT 0 NOT NULL,
    ipaddr 									CHAR(15) DEFAULT '' NOT NULL,
    cancallforward 							CHAR(3) DEFAULT 'yes',
    PRIMARY KEY (id),
    UNIQUE cons_cc_iax_buddies_name (name)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;


INSERT INTO cc_ui_authen VALUES (2, 'admin', 'mypassword', 0, 32767, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2005-02-26 21:14:05.391501-05');
INSERT INTO cc_ui_authen VALUES (1, 'root', 'myroot', 0, 32767, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2005-02-26 20:33:27.691314-05');

INSERT INTO cc_templatemail VALUES ('signup', 'info@call-labs.com', 'Call-Labs', 'SIGNUP CONFIRMATION', '
Thank you for registering with us

Please click on below link to activate your account.

http://call-labs.com/A2Billing_UI/signup/activate.php?key$loginkey

Please make sure you active your account by making payment to us either by
credit card, wire transfer, money order, cheque, and western union money
transfer, money Gram, and Pay pal.


Kind regards,
Call Labs
', '');
INSERT INTO cc_templatemail VALUES ('reminder', 'info@call-labs.com', 'Call-Labs', 'REMINDER', '
Our record indicates that you have less than $min_credit usd in your "$card_gen" account.

We hope this message provides you with enough notice to refill your account.
We value your business, but our system can disconnect you automatically
when you reach your pre-paid balance.
Please login to your account through our website to check your account
details. Plus,
you can pay by credit card, on demand.
http://call-labs.com/A2BCustomer_UI/

If you believe this information to be incorrect please contact
info@call-labs.com
immediately.


Kind regards,
Call Labs
', '');

INSERT INTO cc_templatemail VALUES ('forgetpassword', 'info@call-labs.com', 'Call-Labs', 'Login Information', 'Your login information is as below:

Your account is $card_gen

Your password is $password

Your cardalias is $cardalias

http://call-labs.com/A2BCustomer_UI/

Kind regards,
Call Labs
', '');

INSERT INTO cc_templatemail VALUES ('signupconfirmed', 'info@call-labs.com', 'Call-Labs', 'SIGNUP CONFIRMATION', 'Thank you for registering with us

Please make sure you active your account by making payment to us either by
credit card, wire transfer, money order, cheque, and western union money
transfer, money Gram, and Pay pal.

Your account is $card_gen

Your password is $password

To go to your account :
http://call-labs.com/A2BCustomer_UI/

Kind regards,
Call Labs
', '');

INSERT INTO cc_templatemail VALUES ('epaymentverify', 'info@call-labs.com', 'Call-Labs', 'Epayment Gateway Security Verification Failed', 'Dear Administrator

Please check the Epayment Log, System has logged a Epayment Security failure. that may be a possible attack on epayment processing.

Time of Transaction: $time
Payment Gateway: $paymentgateway
Amount: $amount



Kind regards,
Call Labs
', '');


INSERT INTO cc_templatemail VALUES ('payment', 'info@call-labs.com', 'Call-Labs', 'PAYMENT CONFIRMATION', 'Thank you for shopping at Call-Labs.

Shopping details is as below.

Item Name = <b>$itemName</b>
Item ID = <b>$itemID</b>
Amount = <b>$itemAmount</b>
Payment Method = <b>$paymentMethod</b>
Status = <b>$paymentStatus</b>


Kind regards,
Call Labs
', '');

INSERT INTO cc_templatemail VALUES ('invoice', 'info@call-labs.com', 'Call-Labs', 'A2BILLING INVOICE', 'Dear Customer.

Attached is the invoice.

Kind regards,
Call Labs
', '');

INSERT INTO cc_trunk VALUES (1, 'DEFAULT', '011', 'IAX2', 'kiki@switch-2.kiki.net', '', 0, 0, 0, '2005-03-14 01:01:36', 0, '', NULL);




--
-- Country table : Store the iso country list
--

CREATE TABLE cc_country (
    id 								BIGINT NOT NULL AUTO_INCREMENT,
    countrycode 					CHAR(80) NOT NULL,
    countryprefix 					CHAR(80) NOT NULL,
    countryname 					CHAR(80) NOT NULL,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;

INSERT INTO cc_country VALUES (1, 'AFG' ,'93', 'Afghanistan');
INSERT INTO cc_country VALUES (2, 'ALB' ,'355',  'Albania');
INSERT INTO cc_country VALUES (3, 'DZA' ,'213',  'Algeria');
INSERT INTO cc_country VALUES (4, 'ASM' ,'684',  'American Samoa');
INSERT INTO cc_country VALUES (5, 'AND' ,'376',  'Andorra');
INSERT INTO cc_country VALUES (6, 'AGO' ,'244',  'Angola');
INSERT INTO cc_country VALUES (7, 'AIA' ,'1264',  'Anguilla');
INSERT INTO cc_country VALUES (8, 'ATA' ,'672',  'Antarctica');
INSERT INTO cc_country VALUES (9, 'ATG' ,'1268',  'Antigua And Barbuda');
INSERT INTO cc_country VALUES (10, 'ARG' ,'54',  'Argentina');
INSERT INTO cc_country VALUES (11, 'ARM' ,'374',  'Armenia');
INSERT INTO cc_country VALUES (12, 'ABW' ,'297', 'Aruba');
INSERT INTO cc_country VALUES (13, 'AUS' ,'61',  'Australia');
INSERT INTO cc_country VALUES (14, 'AUT' ,'43',  'Austria');
INSERT INTO cc_country VALUES (15, 'AZE' ,'994',  'Azerbaijan');
INSERT INTO cc_country VALUES (16, 'BHS' ,'1242',  'Bahamas');
INSERT INTO cc_country VALUES (17, 'BHR' ,'973',  'Bahrain');
INSERT INTO cc_country VALUES (18, 'BGD' ,'880',  'Bangladesh');
INSERT INTO cc_country VALUES (19, 'BRB' ,'1246',  'Barbados');
INSERT INTO cc_country VALUES (20, 'BLR' ,'375',  'Belarus');
INSERT INTO cc_country VALUES (21, 'BEL' ,'32',  'Belgium');
INSERT INTO cc_country VALUES (22, 'BLZ' ,'501',  'Belize');
INSERT INTO cc_country VALUES (23, 'BEN' ,'229',  'Benin');
INSERT INTO cc_country VALUES (24, 'BMU' ,'1441', 'Bermuda');
INSERT INTO cc_country VALUES (25,  'BTN' ,'975', 'Bhutan');
INSERT INTO cc_country VALUES (26,  'BOL' ,'591', 'Bolivia');
INSERT INTO cc_country VALUES (27,  'BIH' ,'387', 'Bosnia And Herzegovina');
INSERT INTO cc_country VALUES (28,  'BWA' ,'267', 'Botswana');
INSERT INTO cc_country VALUES (29,  'BV' ,'0', 'Bouvet Island');
INSERT INTO cc_country VALUES (30,  'BRA' ,'55', 'Brazil');
INSERT INTO cc_country VALUES (31,  'IO' ,'1284', 'British Indian Ocean Territory');
INSERT INTO cc_country VALUES (32,  'BRN' ,'673', 'Brunei Darussalam');
INSERT INTO cc_country VALUES (33,  'BGR' ,'359', 'Bulgaria');
INSERT INTO cc_country VALUES (34,  'BFA' ,'226', 'Burkina Faso');
INSERT INTO cc_country VALUES (35,  'BDI' ,'257', 'Burundi');
INSERT INTO cc_country VALUES (36,  'KHM' ,'855', 'Cambodia');
INSERT INTO cc_country VALUES (37,  'CMR' ,'237', 'Cameroon');
INSERT INTO cc_country VALUES (38,  'CAN' ,'1', 'Canada');
INSERT INTO cc_country VALUES (39, 'CPV' ,'238',  'Cape Verde');
INSERT INTO cc_country VALUES (40, 'CYM' ,'1345',  'Cayman Islands');
INSERT INTO cc_country VALUES (41, 'CAF' ,'236',  'Central African Republic');
INSERT INTO cc_country VALUES (42, 'TCD' ,'235',  'Chad');
INSERT INTO cc_country VALUES (43, 'CHL' ,'56',  'Chile');
INSERT INTO cc_country VALUES (44, 'CHN' ,'86', 'China');
INSERT INTO cc_country VALUES (45,  'CXR' ,'618', 'Christmas Island');
INSERT INTO cc_country VALUES (46, 'CCK' ,'61',  'Cocos (Keeling); Islands');
INSERT INTO cc_country VALUES (47, 'COL' ,'57', 'Colombia');
INSERT INTO cc_country VALUES (48, 'COM' ,'269', 'Comoros');
INSERT INTO cc_country VALUES (49, 'COG' ,'242', 'Congo');
INSERT INTO cc_country VALUES (50, 'COD' ,'243','Congo, The Democratic Republic Of The');
INSERT INTO cc_country VALUES (51, 'COK' ,'682', 'Cook Islands');
INSERT INTO cc_country VALUES (52, 'CRI' ,'506', 'Costa Rica');
INSERT INTO cc_country VALUES (54, 'HRV' ,'385', 'Croatia');
INSERT INTO cc_country VALUES (55, 'CUB' ,'53', 'Cuba');
INSERT INTO cc_country VALUES (56, 'CYP' ,'357', 'Cyprus');
INSERT INTO cc_country VALUES (57, 'CZE' ,'420', 'Czech Republic');
INSERT INTO cc_country VALUES (58, 'DNK' ,'45', 'Denmark');
INSERT INTO cc_country VALUES (59, 'DJI' ,'253', 'Djibouti');
INSERT INTO cc_country VALUES (60, 'DMA' ,'1767', 'Dominica');
INSERT INTO cc_country VALUES (61, 'DOM' ,'1809', 'Dominican Republic');
INSERT INTO cc_country VALUES (62, 'ECU' ,'593', 'Ecuador');
INSERT INTO cc_country VALUES (63, 'EGY' ,'20', 'Egypt');
INSERT INTO cc_country VALUES (64, 'SLV' ,'503', 'El Salvador');
INSERT INTO cc_country VALUES (65, 'GNQ' ,'240', 'Equatorial Guinea');
INSERT INTO cc_country VALUES (66, 'ERI' ,'291', 'Eritrea');
INSERT INTO cc_country VALUES (67, 'EST' ,'372', 'Estonia');
INSERT INTO cc_country VALUES (68, 'ETH' ,'251', 'Ethiopia');
INSERT INTO cc_country VALUES (69, 'FLK' ,'500', 'Falkland Islands (Malvinas);');
INSERT INTO cc_country VALUES (70, 'FRO' ,'298', 'Faroe Islands');
INSERT INTO cc_country VALUES (71, 'FJI' ,'679', 'Fiji');
INSERT INTO cc_country VALUES (72, 'FIN' ,'358', 'Finland');
INSERT INTO cc_country VALUES (73, 'FRA' ,'33', 'France');
INSERT INTO cc_country VALUES (74, 'GUF' ,'596', 'French Guiana');
INSERT INTO cc_country VALUES (75, 'PYF' ,'594', 'French Polynesia');
INSERT INTO cc_country VALUES (76, 'ATF' ,'689', 'French Southern Territories');
INSERT INTO cc_country VALUES (77, 'GAB' ,'241', 'Gabon');
INSERT INTO cc_country VALUES (78, 'GMB' ,'220', 'Gambia');
INSERT INTO cc_country VALUES (79, 'GEO' ,'995', 'Georgia');
INSERT INTO cc_country VALUES (80, 'DEU' ,'49', 'Germany');
INSERT INTO cc_country VALUES (81, 'GHA' ,'233', 'Ghana');
INSERT INTO cc_country VALUES (82, 'GIB' ,'350', 'Gibraltar');
INSERT INTO cc_country VALUES (83, 'GRC' ,'30', 'Greece');
INSERT INTO cc_country VALUES (84, 'GRL' ,'299', 'Greenland');
INSERT INTO cc_country VALUES (85, 'GRD' ,'1473', 'Grenada');
INSERT INTO cc_country VALUES (86, 'GLP' ,'590', 'Guadeloupe');
INSERT INTO cc_country VALUES (87, 'GUM' ,'1671', 'Guam');
INSERT INTO cc_country VALUES (88, 'GTM' ,'502', 'Guatemala');
INSERT INTO cc_country VALUES (89, 'GIN' ,'224', 'Guinea');
INSERT INTO cc_country VALUES (90, 'GNB' ,'245', 'Guinea-Bissau');
INSERT INTO cc_country VALUES (91, 'GUY' ,'592', 'Guyana');
INSERT INTO cc_country VALUES (92, 'HTI' ,'509', 'Haiti');
INSERT INTO cc_country VALUES (93, 'HM' ,'0', 'Heard Island And McDonald Islands');
INSERT INTO cc_country VALUES (94, 'VAT' ,'0', 'Holy See (Vatican City State);');
INSERT INTO cc_country VALUES (95, 'HND' ,'504', 'Honduras');
INSERT INTO cc_country VALUES (96, 'HKG' ,'852', 'Hong Kong');
INSERT INTO cc_country VALUES (97, 'HUN' ,'36', 'Hungary');
INSERT INTO cc_country VALUES (98, 'ISL' ,'354', 'Iceland');
INSERT INTO cc_country VALUES (99, 'IND' ,'91', 'India');
INSERT INTO cc_country VALUES (100, 'IDN' ,'62', 'Indonesia');
INSERT INTO cc_country VALUES (101, 'IRN' ,'98', 'Iran, Islamic Republic Of');
INSERT INTO cc_country VALUES (102, 'IRQ' ,'964', 'Iraq');
INSERT INTO cc_country VALUES (103, 'IRL' ,'353', 'Ireland');
INSERT INTO cc_country VALUES (104, 'ISR' ,'972', 'Israel');
INSERT INTO cc_country VALUES (105, 'ITA' ,'39', 'Italy');
INSERT INTO cc_country VALUES (106, 'JAM' ,'1876', 'Jamaica');
INSERT INTO cc_country VALUES (107, 'JPN' ,'81', 'Japan');
INSERT INTO cc_country VALUES (108, 'JOR' ,'962', 'Jordan');
INSERT INTO cc_country VALUES (109, 'KAZ' ,'7', 'Kazakhstan');
INSERT INTO cc_country VALUES (110, 'KEN' ,'254', 'Kenya');
INSERT INTO cc_country VALUES (111, 'KIR' ,'686', 'Kiribati');
INSERT INTO cc_country VALUES (112, 'PRK' ,'850', 'Korea, Democratic People''s Republic Of');
INSERT INTO cc_country VALUES (113, 'KOR' ,'82', 'Korea, Republic of');
INSERT INTO cc_country VALUES (114, 'KWT' ,'965', 'Kuwait');
INSERT INTO cc_country VALUES (115, 'KGZ' ,'996', 'Kyrgyzstan');
INSERT INTO cc_country VALUES (116, 'LAO' ,'856', 'Lao Peoples Democratic Republic');
INSERT INTO cc_country VALUES (117, 'LVA' ,'371', 'Latvia');
INSERT INTO cc_country VALUES (118, 'LBN' ,'961', 'Lebanon');
INSERT INTO cc_country VALUES (119, 'LSO' ,'266', 'Lesotho');
INSERT INTO cc_country VALUES (120, 'LBR' ,'231', 'Liberia');
INSERT INTO cc_country VALUES (121, 'LBY' ,'218', 'Libyan Arab Jamahiriya');
INSERT INTO cc_country VALUES (122, 'LIE' ,'423', 'Liechtenstein');
INSERT INTO cc_country VALUES (123, 'LTU' ,'370', 'Lithuania');
INSERT INTO cc_country VALUES (124, 'LUX' ,'352', 'Luxembourg');
INSERT INTO cc_country VALUES (125, 'MAC' ,'853', 'Macao');
INSERT INTO cc_country VALUES (126, 'MKD' ,'389', 'Macedonia, The Former Yugoslav Republic Of');
INSERT INTO cc_country VALUES (127, 'MDG' ,'261', 'Madagascar');
INSERT INTO cc_country VALUES (128, 'MWI' ,'265', 'Malawi');
INSERT INTO cc_country VALUES (129, 'MYS' ,'60', 'Malaysia');
INSERT INTO cc_country VALUES (130, 'MDV' ,'960', 'Maldives');
INSERT INTO cc_country VALUES (131, 'MLI' ,'223', 'Mali');
INSERT INTO cc_country VALUES (132, 'MLT' ,'356', 'Malta');
INSERT INTO cc_country VALUES (133, 'MHL' ,'692', 'Marshall islands');
INSERT INTO cc_country VALUES (134, 'MTQ' ,'596', 'Martinique');
INSERT INTO cc_country VALUES (135, 'MRT' ,'222', 'Mauritania');
INSERT INTO cc_country VALUES (136, 'MUS' ,'230', 'Mauritius');
INSERT INTO cc_country VALUES (137, 'MYT' ,'269', 'Mayotte');
INSERT INTO cc_country VALUES (138, 'MEX' ,'52', 'Mexico');
INSERT INTO cc_country VALUES (139, 'FSM' ,'691', 'Micronesia, Federated States Of');
INSERT INTO cc_country VALUES (140, 'MDA' ,'1808', 'Moldova, Republic Of');
INSERT INTO cc_country VALUES (141, 'MCO' ,'377', 'Monaco');
INSERT INTO cc_country VALUES (142, 'MNG' ,'976', 'Mongolia');
INSERT INTO cc_country VALUES (143, 'MSR' ,'1664', 'Montserrat');
INSERT INTO cc_country VALUES (144, 'MAR' ,'212', 'Morocco');
INSERT INTO cc_country VALUES (145, 'MOZ' ,'258', 'Mozambique');
INSERT INTO cc_country VALUES (146, 'MMR' ,'95', 'Myanmar');
INSERT INTO cc_country VALUES (147, 'NAM' ,'264', 'Namibia');
INSERT INTO cc_country VALUES (148, 'NRU' ,'674', 'Nauru');
INSERT INTO cc_country VALUES (149, 'NPL' ,'977', 'Nepal');
INSERT INTO cc_country VALUES (150, 'NLD' ,'31', 'Netherlands');
INSERT INTO cc_country VALUES (151, 'ANT' ,'599', 'Netherlands Antilles');
INSERT INTO cc_country VALUES (152, 'NCL' ,'687', 'New Caledonia');
INSERT INTO cc_country VALUES (153, 'NZL' ,'64', 'New Zealand');
INSERT INTO cc_country VALUES (154, 'NIC' ,'505', 'Nicaragua');
INSERT INTO cc_country VALUES (155, 'NER' ,'227', 'Niger');
INSERT INTO cc_country VALUES (156, 'NGA' ,'234', 'Nigeria');
INSERT INTO cc_country VALUES (157, 'NIU' ,'683', 'Niue');
INSERT INTO cc_country VALUES (158, 'NFK' ,'672', 'Norfolk Island');
INSERT INTO cc_country VALUES (159, 'MNP' ,'1670', 'Northern Mariana Islands');
INSERT INTO cc_country VALUES (160, 'NOR' ,'47', 'Norway');
INSERT INTO cc_country VALUES (161, 'OMN' ,'968', 'Oman');
INSERT INTO cc_country VALUES (162, 'PAK' ,'92', 'Pakistan');
INSERT INTO cc_country VALUES (163, 'PLW' ,'680', 'Palau');
INSERT INTO cc_country VALUES (164, 'PSE' ,'970', 'Palestinian Territory, Occupied');
INSERT INTO cc_country VALUES (165, 'PAN' ,'507', 'Panama');
INSERT INTO cc_country VALUES (166, 'PNG' ,'675', 'Papua New Guinea');
INSERT INTO cc_country VALUES (167, 'PRY' ,'595', 'Paraguay');
INSERT INTO cc_country VALUES (168, 'PER' ,'51', 'Peru');
INSERT INTO cc_country VALUES (169, 'PHL' ,'63', 'Philippines');
INSERT INTO cc_country VALUES (170, 'PN' ,'0', 'Pitcairn');
INSERT INTO cc_country VALUES (171, 'POL' ,'48', 'Poland');
INSERT INTO cc_country VALUES (172, 'PRT' ,'351', 'Portugal');
INSERT INTO cc_country VALUES (173, 'PRI' ,'1787', 'Puerto Rico');
INSERT INTO cc_country VALUES (174, 'QAT' ,'974', 'Qatar');
INSERT INTO cc_country VALUES (175, 'REU' ,'262', 'Reunion');
INSERT INTO cc_country VALUES (176, 'ROU' ,'40', 'Romania');
INSERT INTO cc_country VALUES (177, 'RUS' ,'7', 'Russian Federation');
INSERT INTO cc_country VALUES (178, 'RWA' ,'250', 'Rwanda');
INSERT INTO cc_country VALUES (179, 'SHN' ,'290', 'SaINT Helena');
INSERT INTO cc_country VALUES (180, 'KNA' ,'1869', 'SaINT Kitts And Nevis');
INSERT INTO cc_country VALUES (181, 'LCA' ,'1758', 'SaINT Lucia');
INSERT INTO cc_country VALUES (182, 'SPM' ,'508', 'SaINT Pierre And Miquelon');
INSERT INTO cc_country VALUES (183, 'VCT' ,'1784', 'SaINT Vincent And The Grenadines');
INSERT INTO cc_country VALUES (184, 'WSM' ,'685', 'Samoa');
INSERT INTO cc_country VALUES (185, 'SMR' ,'378', 'San Marino');
INSERT INTO cc_country VALUES (186, 'STP' ,'239', 'São Tomé And Principe');
INSERT INTO cc_country VALUES (187, 'SAU' ,'966', 'Saudi Arabia');
INSERT INTO cc_country VALUES (188, 'SEN' ,'221', 'Senegal');
INSERT INTO cc_country VALUES (189, 'SYC' ,'248', 'Seychelles');
INSERT INTO cc_country VALUES (190, 'SLE' ,'232', 'Sierra Leone');
INSERT INTO cc_country VALUES (191, 'SGP' ,'65', 'Singapore');
INSERT INTO cc_country VALUES (192, 'SVK' ,'421', 'Slovakia');
INSERT INTO cc_country VALUES (193, 'SVN' ,'386', 'Slovenia');
INSERT INTO cc_country VALUES (194, 'SLB' ,'677', 'Solomon Islands');
INSERT INTO cc_country VALUES (195, 'SOM' ,'252', 'Somalia');
INSERT INTO cc_country VALUES (196, 'ZAF' ,'27', 'South Africa');
INSERT INTO cc_country VALUES (197, 'GS' ,'0', 'South Georgia And The South Sandwich Islands');
INSERT INTO cc_country VALUES (198, 'ESP' ,'34', 'Spain');
INSERT INTO cc_country VALUES (199, 'LKA' ,'94', 'Sri Lanka');
INSERT INTO cc_country VALUES (200, 'SDN' ,'249', 'Sudan');
INSERT INTO cc_country VALUES (201, 'SUR' ,'597', 'Suriname');
INSERT INTO cc_country VALUES (202, 'SJ' ,'0', 'Svalbard and Jan Mayen');
INSERT INTO cc_country VALUES (203, 'SWZ' ,'268', 'Swaziland');
INSERT INTO cc_country VALUES (204, 'SWE' ,'46', 'Sweden');
INSERT INTO cc_country VALUES (205, 'CHE' ,'41', 'Switzerland');
INSERT INTO cc_country VALUES (206, 'SYR' ,'963', 'Syrian Arab Republic');
INSERT INTO cc_country VALUES (207, 'TWN' ,'886', 'Taiwan, Province Of China');
INSERT INTO cc_country VALUES (208, 'TJK' ,'992', 'Tajikistan');
INSERT INTO cc_country VALUES (209, 'TZA' ,'255', 'Tanzania, United Republic Of');
INSERT INTO cc_country VALUES (210, 'THA' ,'66', 'Thailand');
INSERT INTO cc_country VALUES (211, 'TL' ,'0', 'Timor LEste');
INSERT INTO cc_country VALUES (212, 'TGO' ,'228', 'Togo');
INSERT INTO cc_country VALUES (213, 'TKL' ,'690', 'Tokelau');
INSERT INTO cc_country VALUES (214, 'TON' ,'676', 'Tonga');
INSERT INTO cc_country VALUES (215, 'TTO' ,'1868', 'Trinidad And Tobago');
INSERT INTO cc_country VALUES (216, 'TUN' ,'216', 'Tunisia');
INSERT INTO cc_country VALUES (217, 'TUR' ,'90', 'Turkey');
INSERT INTO cc_country VALUES (218, 'TKM' ,'993', 'Turkmenistan');
INSERT INTO cc_country VALUES (219, 'TCA' ,'1649', 'Turks And Caicos Islands');
INSERT INTO cc_country VALUES (220, 'TUV' ,'688', 'Tuvalu');
INSERT INTO cc_country VALUES (221, 'UGA' ,'256', 'Uganda');
INSERT INTO cc_country VALUES (222, 'UKR' ,'380', 'Ukraine');
INSERT INTO cc_country VALUES (223, 'ARE' ,'971', 'United Arab Emirates');
INSERT INTO cc_country VALUES (224, 'GBR' ,'44', 'United Kingdom');
INSERT INTO cc_country VALUES (225, 'USA' ,'1', 'United States');
INSERT INTO cc_country VALUES (226, 'UM' ,'0', 'United States Minor Outlying Islands');
INSERT INTO cc_country VALUES (227, 'URY' ,'598', 'Uruguay');
INSERT INTO cc_country VALUES (228, 'UZB' ,'998', 'Uzbekistan');
INSERT INTO cc_country VALUES (229, 'VUT' ,'678', 'Vanuatu');
INSERT INTO cc_country VALUES (230, 'VEN' ,'58', 'Venezuela');
INSERT INTO cc_country VALUES (231, 'VNM' ,'84', 'Vietnam');
INSERT INTO cc_country VALUES (232, 'VGB','1284', 'Virgin Islands, British');
INSERT INTO cc_country VALUES (233, 'VIR','808', 'Virgin Islands, U.S.');
INSERT INTO cc_country VALUES (234, 'WLF' ,'681', 'Wallis And Futuna');
INSERT INTO cc_country VALUES (235, 'EH' ,'0', 'Western Sahara');
INSERT INTO cc_country VALUES (236, 'YEM' ,'967', 'Yemen');
INSERT INTO cc_country VALUES (237, 'YUG' ,'0', 'Yugoslavia');
INSERT INTO cc_country VALUES (238, 'ZMB' ,'260', 'Zambia');
INSERT INTO cc_country VALUES (239, 'ZWE' ,'263', 'Zimbabwe');
INSERT INTO cc_country VALUES (240, 'ASC' ,'0', 'Ascension Island');
INSERT INTO cc_country VALUES (241, 'DGA' ,'0', 'Diego Garcia');
INSERT INTO cc_country VALUES (242, 'XNM' ,'0', 'Inmarsat');
INSERT INTO cc_country VALUES (243, 'TMP' ,'670', 'East timor');
INSERT INTO cc_country VALUES (244, 'AK' ,'0', 'Alaska');
INSERT INTO cc_country VALUES (245, 'HI' ,'0', 'Hawaii');
INSERT INTO cc_country VALUES (53, 'CIV' ,'225', 'Côte d''Ivoire');


--
-- Predictive Dialer update  database - Create database schema
--

--
-- CURRENT_TIMESTAMP
-- last_attempt TIMESTAMP DEFAULT 'now()' NOT NULL,  
-- last_attempt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
--

--
--	MYSQL 5.x - MYSQL 5.x - MYSQL 5.x - MYSQL 5.x - MYSQL 5.x
--
--
-- Predictive Dialer update  database - Create database schema
--



CREATE TABLE cc_campaign (
    id 							INT NOT NULL AUTO_INCREMENT,    
    campaign_name 				CHAR(50) NOT NULL,
    creationdate 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    startingdate 				TIMESTAMP, 
    expirationdate 				TIMESTAMP,
    description 				MEDIUMTEXT,
    id_trunk 					INT DEFAULT 0,
    secondusedreal 				INT DEFAULT 0,
    nb_callmade 				INT DEFAULT 0,
    enable INT 					DEFAULT 0 NOT NULL,	
    PRIMARY KEY (id),
    UNIQUE cons_cc_campaign_campaign_name (campaign_name)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;


CREATE TABLE cc_phonelist (
    id 							INT NOT NULL AUTO_INCREMENT,
    id_cc_campaign 				INT DEFAULT 0 NOT NULL,
    numbertodial 				CHAR(50) NOT NULL,
    name 						CHAR(60) NOT NULL,
    inuse 						INT DEFAULT 0,
    enable 						INT DEFAULT 1 NOT NULL,    
    num_trials_done 			INT DEFAULT 0,
    creationdate 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,	
    last_attempt 				TIMESTAMP,
    secondusedreal 				INT DEFAULT 0,
    additionalinfo 				MEDIUMTEXT,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;
CREATE INDEX ind_cc_phonelist_numbertodial ON cc_phonelist (numbertodial);


CREATE TABLE cc_provider(
    id 							INT NOT NULL AUTO_INCREMENT,
    provider_name 				CHAR(30) NOT NULL,
    creationdate 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    description 				MEDIUMTEXT,
    PRIMARY KEY (id),
    UNIQUE cons_cc_provider_provider_name (provider_name)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;
		
--
--  cc_currencies table
--

CREATE TABLE cc_currencies (
    id 								SMALLINT (5) unsigned NOT NULL AUTO_INCREMENT,
    currency 						CHAR(3) NOT NULL DEFAULT '',
    name 							VARCHAR(30) NOT NULL DEFAULT '',
    value 							FLOAT (7,5) unsigned NOT NULL DEFAULT '0.00000',
    lastupdate 						TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    basecurrency 					CHAR(3) NOT NULL DEFAULT 'USD',
    PRIMARY KEY  (id),
    UNIQUE cons_cc_currencies_currency (currency)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin AUTO_INCREMENT=150;


INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (1, 'ALL', 'Albanian Lek (ALL)', 0.00974,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (2, 'DZD', 'Algerian Dinar (DZD)', 0.01345,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (3, 'XAL', 'Aluminium Ounces (XAL)', 1.08295,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (4, 'ARS', 'Argentine Peso (ARS)', 0.32455,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (5, 'AWG', 'Aruba Florin (AWG)', 0.55866,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (6, 'AUD', 'Australian Dollar (AUD)', 0.73384,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (7, 'BSD', 'Bahamian Dollar (BSD)', 1.00000,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (8, 'BHD', 'Bahraini Dinar (BHD)', 2.65322,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (9, 'BDT', 'Bangladesh Taka (BDT)', 0.01467,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (10, 'BBD', 'Barbados Dollar (BBD)', 0.50000,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (11, 'BYR', 'Belarus Ruble (BYR)', 0.00046,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (12, 'BZD', 'Belize Dollar (BZD)', 0.50569,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (13, 'BMD', 'Bermuda Dollar (BMD)', 1.00000,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (14, 'BTN', 'Bhutan Ngultrum (BTN)', 0.02186,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (15, 'BOB', 'Bolivian Boliviano (BOB)', 0.12500,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (16, 'BRL', 'Brazilian Real (BRL)', 0.46030, 'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (17, 'GBP', 'British Pound (GBP)', 1.73702,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (18, 'BND', 'Brunei Dollar (BND)', 0.61290,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (19, 'BGN', 'Bulgarian Lev (BGN)', 0.60927,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (20, 'BIF', 'Burundi Franc (BIF)', 0.00103,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (21, 'KHR', 'Cambodia Riel (KHR)', 0.00000,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (22, 'CAD', 'Canadian Dollar (CAD)', 0.86386,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (23, 'KYD', 'Cayman Islands Dollar (KYD)', 1.16496,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (24, 'XOF', 'CFA Franc (BCEAO) (XOF)', 0.00182,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (25, 'XAF', 'CFA Franc (BEAC) (XAF)', 0.00182, 'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (26, 'CLP', 'Chilean Peso (CLP)', 0.00187,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (27, 'CNY', 'Chinese Yuan (CNY)', 0.12425,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (28, 'COP', 'Colombian Peso (COP)', 0.00044,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (29, 'KMF', 'Comoros Franc (KMF)', 0.00242,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (30, 'XCP', 'Copper Ounces (XCP)', 2.16403,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (31, 'CRC', 'Costa Rica Colon (CRC)', 0.00199,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (32, 'HRK', 'Croatian Kuna (HRK)', 0.16249,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (33, 'CUP', 'Cuban Peso (CUP)', 1.00000,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (34, 'CYP', 'Cyprus Pound (CYP)', 2.07426, 'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (35, 'CZK', 'Czech Koruna (CZK)', 0.04133,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (36, 'DKK', 'Danish Krone (DKK)', 0.15982,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (37, 'DJF', 'Dijibouti Franc (DJF)', 0.00000,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (38, 'DOP', 'Dominican Peso (DOP)', 0.03035,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (39, 'XCD', 'East Caribbean Dollar (XCD)', 0.37037,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (40, 'ECS', 'Ecuador Sucre (ECS)', 0.00004,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (41, 'EGP', 'Egyptian Pound (EGP)', 0.17433,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (42, 'SVC', 'El Salvador Colon (SVC)', 0.11426,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (43, 'ERN', 'Eritrea Nakfa (ERN)', 0.00000,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (44, 'EEK', 'Estonian Kroon (EEK)', 0.07615,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (45, 'ETB', 'Ethiopian Birr (ETB)', 0.11456,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (46, 'EUR', 'Euro (EUR)', 1.19175,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (47, 'FKP', 'Falkland Islands Pound (FKP)', 0.00000,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (48, 'GMD', 'Gambian Dalasi (GMD)', 0.03515,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (49, 'GHC', 'Ghanian Cedi (GHC)', 0.00011,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (50, 'GIP', 'Gibraltar Pound (GIP)', 0.00000,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (51, 'XAU', 'Gold Ounces (XAU)', 555.55556,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (52, 'GTQ', 'Guatemala Quetzal (GTQ)', 0.13103,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (53, 'GNF', 'Guinea Franc (GNF)', 0.00022,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (54, 'HTG', 'Haiti Gourde (HTG)', 0.02387,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (55, 'HNL', 'Honduras Lempira (HNL)', 0.05292,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (56, 'HKD', 'Hong Kong Dollar (HKD)', 0.12884,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (57, 'HUF', 'Hungarian ForINT (HUF)', 0.00461,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (58, 'ISK', 'Iceland Krona (ISK)', 0.01436,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (59, 'INR', 'Indian Rupee (INR)', 0.02253,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (60, 'IDR', 'Indonesian Rupiah (IDR)', 0.00011,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (61, 'IRR', 'Iran Rial (IRR)', 0.00011, 'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (62, 'ILS', 'Israeli Shekel (ILS)', 0.21192,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (63, 'JMD', 'Jamaican Dollar (JMD)', 0.01536,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (64, 'JPY', 'Japanese Yen (JPY)', 0.00849,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (65, 'JOD', 'Jordanian Dinar (JOD)', 1.41044,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (66, 'KZT', 'Kazakhstan Tenge (KZT)', 0.00773,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (67, 'KES', 'Kenyan Shilling (KES)', 0.01392,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (68, 'KRW', 'Korean Won (KRW)', 0.00102,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (69, 'KWD', 'Kuwaiti Dinar (KWD)', 3.42349,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (70, 'LAK', 'Lao Kip (LAK)', 0.00000, 'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (71, 'LVL', 'Latvian Lat (LVL)', 1.71233,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (72, 'LBP', 'Lebanese Pound (LBP)', 0.00067,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (73, 'LSL', 'Lesotho Loti (LSL)', 0.15817,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (74, 'LYD', 'Libyan Dinar (LYD)', 0.00000,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (75, 'LTL', 'Lithuanian Lita (LTL)', 0.34510, 'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (76, 'MOP', 'Macau Pataca (MOP)', 0.12509,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (77, 'MKD', 'Macedonian Denar (MKD)', 0.01945,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (78, 'MGF', 'Malagasy Franc (MGF)', 0.00011,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (79, 'MWK', 'Malawi Kwacha (MWK)', 0.00752, 'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (80, 'MYR', 'Malaysian Ringgit (MYR)', 0.26889,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (81, 'MVR', 'Maldives Rufiyaa (MVR)', 0.07813,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (82, 'MTL', 'Maltese Lira (MTL)', 2.77546,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (83, 'MRO', 'Mauritania Ougulya (MRO)', 0.00369,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (84, 'MUR', 'Mauritius Rupee (MUR)', 0.03258,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (85, 'MXN', 'Mexican Peso (MXN)', 0.09320,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (86, 'MDL', 'Moldovan Leu (MDL)', 0.07678,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (87, 'MNT', 'Mongolian Tugrik (MNT)', 0.00084,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (88, 'MAD', 'Moroccan Dirham (MAD)', 0.10897,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (89, 'MZM', 'Mozambique Metical (MZM)', 0.00004,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (90, 'NAD', 'Namibian Dollar (NAD)', 0.15817, 'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (91, 'NPR', 'Nepalese Rupee (NPR)', 0.01408, 'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (92, 'ANG', 'Neth Antilles Guilder (ANG)', 0.55866,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (93, 'TRY', 'New Turkish Lira (TRY)', 0.73621,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (94, 'NZD', 'New Zealand Dollar (NZD)', 0.65096,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (95, 'NIO', 'Nicaragua Cordoba (NIO)', 0.05828,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (96, 'NGN', 'Nigerian Naira (NGN)', 0.00777,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (97, 'NOK', 'Norwegian Krone (NOK)', 0.14867,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (98, 'OMR', 'Omani Rial (OMR)', 2.59740,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (99, 'XPF', 'Pacific Franc (XPF)', 0.00999,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (100, 'PKR', 'Pakistani Rupee (PKR)', 0.01667,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (101, 'XPD', 'Palladium Ounces (XPD)', 277.77778,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (102, 'PAB', 'Panama Balboa (PAB)', 1.00000,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (103, 'PGK', 'Papua New Guinea Kina (PGK)', 0.33125,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (104, 'PYG', 'Paraguayan Guarani (PYG)', 0.00017,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (105, 'PEN', 'Peruvian Nuevo Sol (PEN)', 0.29999,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (106, 'PHP', 'Philippine Peso (PHP)', 0.01945,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (107, 'XPT', 'Platinum Ounces (XPT)', 1000.00000,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (108, 'PLN', 'Polish Zloty (PLN)', 0.30574, 'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (109, 'QAR', 'Qatar Rial (QAR)', 0.27476,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (110, 'ROL', 'Romanian Leu (ROL)', 0.00000,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (111, 'RON', 'Romanian New Leu (RON)', 0.34074,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (112, 'RUB', 'Russian Rouble (RUB)', 0.03563,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (113, 'RWF', 'Rwanda Franc (RWF)', 0.00185,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (114, 'WST', 'Samoa Tala (WST)', 0.35492,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (115, 'STD', 'Sao Tome Dobra (STD)', 0.00000,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (116, 'SAR', 'Saudi Arabian Riyal (SAR)', 0.26665,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (117, 'SCR', 'Seychelles Rupee (SCR)', 0.18114,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (118, 'SLL', 'Sierra Leone Leone (SLL)', 0.00034,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (119, 'XAG', 'Silver Ounces (XAG)', 9.77517,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (120, 'SGD', 'Singapore Dollar (SGD)', 0.61290,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (121, 'SKK', 'Slovak Koruna (SKK)', 0.03157, 'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (122, 'SIT', 'Slovenian Tolar (SIT)', 0.00498,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (123, 'SOS', 'Somali Shilling (SOS)', 0.00000, 'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (124, 'ZAR', 'South African Rand (ZAR)', 0.15835, 'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (125, 'LKR', 'Sri Lanka Rupee (LKR)', 0.00974,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (126, 'SHP', 'St Helena Pound (SHP)', 0.00000,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (127, 'SDD', 'Sudanese Dinar (SDD)', 0.00427,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (128, 'SRG', 'Surinam Guilder (SRG)', 0.36496,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (129, 'SZL', 'Swaziland Lilageni (SZL)', 0.15817,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (130, 'SEK', 'Swedish Krona (SEK)', 0.12609,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (131, 'CHF', 'Swiss Franc (CHF)', 0.76435,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (132, 'SYP', 'Syrian Pound (SYP)', 0.00000,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (133, 'TWD', 'Taiwan Dollar (TWD)', 0.03075,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (134, 'TZS', 'Tanzanian Shilling (TZS)', 0.00083,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (135, 'THB', 'Thai Baht (THB)', 0.02546,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (136, 'TOP', 'Tonga Paanga (TOP)', 0.48244, 'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (137, 'TTD', 'Trinidad&Tobago Dollar (TTD)', 0.15863,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (138, 'TND', 'Tunisian Dinar (TND)', 0.73470,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (139, 'USD', 'U.S. Dollar (USD)', 1.00000,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (140, 'AED', 'UAE Dirham (AED)', 0.27228,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (141, 'UGX', 'Ugandan Shilling (UGX)', 0.00055, 'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (142, 'UAH', 'Ukraine Hryvnia (UAH)', 0.19755,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (143, 'UYU', 'Uruguayan New Peso (UYU)', 0.04119,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (144, 'VUV', 'Vanuatu Vatu (VUV)', 0.00870,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (145, 'VEB', 'Venezuelan Bolivar (VEB)', 0.00037,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (146, 'VND', 'Vietnam Dong (VND)', 0.00006,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (147, 'YER', 'Yemen Riyal (YER)', 0.00510,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (148, 'ZMK', 'Zambian Kwacha (ZMK)', 0.00031, 'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (149, 'ZWD', 'Zimbabwe Dollar (ZWD)', 0.00001,  'USD');
INSERT INTO cc_currencies (id, currency, name, value, basecurrency) VALUES (150, 'GYD', 'Guyana Dollar (GYD)', 0.00527,  'USD');



--
-- Backup Database
--

CREATE TABLE cc_backup (
    id 								BIGINT NOT NULL AUTO_INCREMENT ,
    name 							VARCHAR( 255 ) NOT NULL ,
    path 							VARCHAR( 255 ) NOT NULL ,
    creationdate 					TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
    PRIMARY KEY ( id ) ,
    UNIQUE cons_cc_backup_name(name)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;





-- 
-- E-Commerce Table
--


CREATE TABLE cc_ecommerce_product (
    id 										BIGINT NOT NULL AUTO_INCREMENT,
    product_name 							VARCHAR(255) NOT NULL,	
    creationdate 							TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    description 							MEDIUMTEXT,
    expirationdate 							TIMESTAMP,
    enableexpire 							INT DEFAULT 0,
    expiredays 								INT DEFAULT 0,
    mailtype 								VARCHAR(50) NOT NULL,
    credit 									FLOAT DEFAULT 0 NOT NULL,
    tariff 									INT DEFAULT 0,
    id_didgroup 							INT DEFAULT 0,
    activated 								CHAR(1) DEFAULT 'f' NOT NULL,
    simultaccess 							INT DEFAULT 0,
    currency 								CHAR(3) DEFAULT 'USD',
    typepaid 								INT DEFAULT 0,
    creditlimit 							INT DEFAULT 0,
    language 								CHAR(5) DEFAULT 'en',
    runservice 								INT DEFAULT 0,
    sip_friend 								INT DEFAULT 0,
    iax_friend 								INT DEFAULT 0,
    PRIMARY KEY ( id )
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;



-- 
-- Speed Dial Table
--

CREATE TABLE cc_speeddial (
    id 										BIGINT NOT NULL AUTO_INCREMENT,
    id_cc_card 								BIGINT NOT NULL DEFAULT 0,
    phone 									VARCHAR(100) NOT NULL,	
    name 									VARCHAR(100) NOT NULL,	
    speeddial 								INT DEFAULT 0,
    creationdate 							TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ( id ),
    UNIQUE cons_cc_speeddial_id_cc_card_speeddial (id_cc_card, speeddial)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;



-- Auto Refill Report Table	
CREATE TABLE cc_autorefill_report (
	id 										BIGINT NOT NULL AUTO_INCREMENT,    
	daterun 								TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	totalcardperform 						INT ,
	totalcredit 							DECIMAL(15,5),
	PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;








-- cc_prefix Table	

CREATE TABLE cc_prefix (
	id 											BIGINT NOT NULL AUTO_INCREMENT,
	prefixe 									VARCHAR(50) NOT NULL,
	destination 								VARCHAR(100) NOT NULL,
	id_cc_country 								BIGINT ,
	PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;


INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Afghanistan','93','1');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Albania','355','2');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Algeria','213','3');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('American Samoa','684','4');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Andorra','376','5');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Angola','244','6');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Anguilla','1264','7');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Antarctica','672','8');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Antigua','1268',9);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Argentina','54','10');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Armenia','374','11');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Aruba','297','12');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Ascension','247',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Australia','61','13');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Australian External Territories','672','13');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Austria','43','14');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Azerbaijan','994','15');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Bahamas','1242','16');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Bahrain','973','17');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Bangladesh','880','18');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Barbados','1246','19');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Barbuda','1268',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Belarus','375','20');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Belgium','32','21');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Belize','501','22');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Benin','229','23');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Bermuda','1441','24');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Bhutan','975','25');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Bolivia','591','26');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Bosnia & Herzegovina','387','27');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Botswana','267','28');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Brazil','55','30');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Brasil Telecom','5514','30');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Brazil Telefonica','5515','30');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Brazil Embratel','5521','30');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Brazil Intelig','5523','30');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Brazil Telemar','5531','30');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Brazil mobile phones','550','30');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('British Virgin Islands','1284','31');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Brunei Darussalam','673','32');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Bulgaria','359','33');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Burkina Faso','226','34');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Burundi','257','35');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Cambodia','855','36');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Cameroon','237','37');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Canada','1','38');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Cape Verde Islands','238','39');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Cayman Islands','1345','40');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Central African Republic','236','41');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Chad','235','42');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Chatham Island (New Zealand)','64',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Chile','56','43');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('China (PRC)','86','44');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Christmas Island','618','45');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Cocos-Keeling Islands','61','46');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Colombia','57','47');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Colombia Mobile Phones','573','47');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Colombia Orbitel','575','47');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Colombia ETB','577','47');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Colombia Telecom','579','47');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Comoros','269','48');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Congo','242','49');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Congo, Dem. Rep. of  (former Zaire)','243',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Cook Islands','682','51');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Costa Rica','506','52');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Côte d''Ivoire (Ivory Coast)','225','53');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Croatia','385','54');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Cuba','53','55');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Cuba (Guantanamo Bay)','5399','55');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Curaâo','599',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Cyprus','357','56');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Czech Republic','420','57');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Denmark','45','58');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Diego Garcia','246','241');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Djibouti','253','59');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Dominica','1767','60');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Dominican Republic','1809','61');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('East Timor','670','211');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Easter Island','56',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Ecuador','593','62');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Egypt','20','63');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('El Salvador','503','64');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Ellipso (Mobile Satellite service)','8812',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('EMSAT (Mobile Satellite service)','88213',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Equatorial Guinea','240','65');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Eritrea','291','66');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Estonia','372','67');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Ethiopia','251','68');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Falkland Islands (Malvinas)','500','69');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Faroe Islands','298','70');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Fiji Islands','679','71');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Finland','358','72');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('France','33','73');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('French Antilles','596','74');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('French Guiana','594','75');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('French Polynesia','689','76');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Gabonese Republic','241','77');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Gambia','220','78');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Georgia','995','79');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Germany','49','80');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Ghana','233','81');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Gibraltar','350','82');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Global Mobile Satellite System (GMSS)','881',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('ICO Global','8810-8811',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Ellipso','8812-8813',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Iridium','8816-8817',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Globalstar','8818-8819',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Globalstar (Mobile Satellite Service)','8818-8819',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Greece','30','83');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Greenland','299','84');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Grenada','1473','85');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Guadeloupe','590','86');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Guam','1671','87');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Guantanamo Bay','5399',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Guatemala','502','88');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Guinea-Bissau','245','90');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Guinea','224','89');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Guyana','592','91');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Haiti','509','92');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Honduras','504','95');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Hong Kong','852','96');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Hungary','36','97');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('ICO Global (Mobile Satellite Service)','8810-8811',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Iceland','354','98');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('India','91','99');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Indonesia','62','100');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Inmarsat (Atlantic Ocean - East)','871','242');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Inmarsat (Atlantic Ocean - West)','874','242');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Inmarsat (Indian Ocean)','873','242');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Inmarsat (Pacific Ocean)','872','242');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Inmarsat SNAC','870','242');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('International Freephone Service','800',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('International Shared Cost Service (ISCS)','808',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Iran','98','101');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Iraq','964','102');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Ireland','353','103');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Iridium (Mobile Satellite service)','8816-8817',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Israel','972','104');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Italy','39','105');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Jamaica','1876','106');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Japan','81','107');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Jordan','962','108');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Kazakhstan','7','109');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Kenya','254','110');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Kiribati','686','111');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Korea (North)','850','112');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Korea (South)','82','113');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Kuwait','965','114');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Kyrgyz Republic','996','115');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Laos','856','116');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Latvia','371','117');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Lebanon','961','118');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Lesotho','266','119');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Liberia','231','120');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Libya','218','121');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Liechtenstein','423','122');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Lithuania','370','123');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Luxembourg','352','124');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Macao','853','125');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Macedonia (Former Yugoslav Rep of.)','389','126');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Madagascar','261','127');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Malawi','265','128');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Malaysia','60','129');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Maldives','960','130');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Mali Republic','223','131');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Malta','356','132');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Marshall Islands','692','133');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Martinique','596','134');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Mauritania','222','135');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Mauritius','230','136');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Mayotte Island','269','137');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Mexico','52','138');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Micronesia, (Federal States of)','691','139');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Midway Island','1808',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Moldova','373','140');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Monaco','377','141');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Mongolia','976','142');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Montserrat','1664','143');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Morocco','212','144');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Mozambique','258','145');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Myanmar','95','146');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Namibia','264','147');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Nauru','674','148');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Nepal','977','149');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Netherlands','31','150');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Netherlands Antilles','599','151');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Nevis','1869',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('New Caledonia','687','152');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('New Zealand','64','153');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Nicaragua','505','154');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Niger','227','155');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Nigeria','234','156');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Niue','683','157');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Norfolk Island','672','158');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Northern Marianas Islands(Saipan, Rota, & Tinian)','1670','159');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Norway','47','160');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Oman','968','161');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Pakistan','92','162');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Palau','680','163');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Palestinian Settlements','970','164');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Panama','507','165');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Papua New Guinea','675','166');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Paraguay','595','167');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Peru','51','168');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Philippines','63','169');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Poland','48','171');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Portugal','351','172');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Puerto Rico','1787','173');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Qatar','974','174');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Réunion Island','262','175');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Romania','40','176');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Russia','7','177');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Rwandese Republic','250','178');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('St. Helena','290','179');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('St. Kitts/Nevis','1869','180');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('St. Lucia','1758','181');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('St. Pierre & Miquelon','508','182');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('St. Vincent & Grenadines','1784','183');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('San Marino','378','185');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('São Tomé and Principe','239','186');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Saudi Arabia','966','187');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Senegal','221','188');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Serbia and Montenegro','381',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Seychelles Republic','248','189');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Sierra Leone','232','190');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Singapore','65','191');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Slovak Republic','421','192');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Slovenia','386','193');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Solomon Islands','677','194');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Somali Democratic Republic','252','195');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('South Africa','27','196');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Spain','34','198');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Sri Lanka','94','199');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Sudan','249','200');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Suriname','597','201');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Swaziland','268','203');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Sweden','46','204');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Switzerland','41','205');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Syria','963','206');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Taiwan','886','207');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Tajikistan','992','208');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Tanzania','255','209');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Thailand','66','210');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Thuraya (Mobile Satellite service)','88216',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Togolese Republic','228','212');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Tokelau','690','213');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Tonga Islands','676','214');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Trinidad & Tobago','1868','215');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Tunisia','216','216');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Turkey','90','217');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Turkmenistan','993','218');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Turks and Caicos Islands','1649','219');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Tuvalu','688','220');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Uganda','256','221');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Ukraine','380','222');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('United Arab Emirates','971','223');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('United Kingdom','44','224');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('United States of America','1','225');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('US Virgin Islands','1340','225');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Universal Personal Telecommunications (UPT)','878',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Uruguay','598','227');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Uzbekistan','998','228');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Vanuatu','678','229');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Vatican City','39',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Venezuela','58','230');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Venezuela Etelix','58102','230');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Venezuela http://www.multiphone.net.ve','58107','230');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Venezuela CANTV','58110','230');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Venezuela Convergence Comunications','58111','230');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Venezuela Telcel, C.A.','58114','230');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Venezuela Totalcom Venezuela','58119','230');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Venezuela Orbitel de Venezuela, C.A. ENTEL Venezuela','58123','230');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Venezuela LD Telecomunicaciones, C.A.','58150','230');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Venezuela Telecomunicaciones NGTV','58133','230');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Venezuela Veninfotel Comunicaciones','58199','230');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Vietnam','84','231');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Wake Island','808',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Wallis and Futuna Islands','681',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Western Samoa','685','184');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Yemen','967','236');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Zambia','260','238');
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Zanzibar','255',NULL);
INSERT INTO cc_prefix (destination,prefixe,id_cc_country) VALUES ('Zimbabwe','263','239');



CREATE TABLE cc_alarm (
    id 										BIGINT NOT NULL AUTO_INCREMENT,
    name 									TEXT NOT NULL,
    periode 								INT NOT NULL DEFAULT 1,
    type 									INT NOT NULL DEFAULT 1,
    maxvalue 								FLOAT NOT NULL,
    minvalue 								FLOAT NOT NULL DEFAULT -1,
    id_trunk 								INT ,
    status 									INT NOT NULL DEFAULT 0,
    numberofrun 							INT NOT NULL DEFAULT 0,
    numberofalarm 							INT NOT NULL DEFAULT 0,   
	datecreate    							TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,	
	datelastrun    							TIMESTAMP,
    emailreport 							VARCHAR(50),
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;


 CREATE TABLE cc_alarm_report (
    id 										BIGINT NOT NULL AUTO_INCREMENT,
    cc_alarm_id 							BIGINT NOT NULL,
    calculatedvalue 						FLOAT NOT NULL,
    daterun 								TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;




CREATE TABLE cc_callback_spool (
    id 								BIGINT NOT NULL AUTO_INCREMENT,
    uniqueid 						VARCHAR(40),
    entry_time 						TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status 							VARCHAR(80),
    server_ip 						VARCHAR(40),
    num_attempt 					INT NOT NULL DEFAULT 0,
    last_attempt_time 				TIMESTAMP,
    manager_result 					VARCHAR(60),
    agi_result 						VARCHAR(60),
    callback_time 					TIMESTAMP,
    channel 						VARCHAR(60),
    exten 							VARCHAR(60),
    context 						VARCHAR(60),
    priority 						VARCHAR(60),
    application 					VARCHAR(60),
    data 							VARCHAR(60),
    timeout 						VARCHAR(60),
    callerid 						VARCHAR(60),
    variable 						VARCHAR(100),
    account 						VARCHAR(60),
    async 							VARCHAR(60),
    actionid 						VARCHAR(60),
	id_server						INT,
	id_server_group					INT,
    PRIMARY KEY (id),
    UNIQUE cc_callback_spool_uniqueid_key (uniqueid)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;

CREATE TABLE cc_server_manager (
    id 								BIGINT NOT NULL AUTO_INCREMENT,
	id_group						INT DEFAULT 1,
    server_ip 						VARCHAR(40),
    manager_host 					VARCHAR(50),
    manager_username 				VARCHAR(50),
    manager_secret 					VARCHAR(50),
	lasttime_used		 			TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;

INSERT INTO cc_server_manager (id_group, server_ip, manager_host, manager_username, manager_secret) VALUES (1, 'localhost', 'localhost', 'myasterisk', 'mycode');


CREATE TABLE cc_server_group (
	id 								BIGINT NOT NULL AUTO_INCREMENT,
	name 							VARCHAR(60),
	description						MEDIUMTEXT,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;
INSERT INTO cc_server_group (id, name, description) VALUES (1, 'default', 'default group of server');




CREATE TABLE cc_invoices (
    id 										INT NOT NULL AUTO_INCREMENT,    
    cardid 									bigINT NOT NULL,
	orderref 								VARCHAR(50),
    invoicecreated_date 					TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	cover_startdate 						TIMESTAMP,
    cover_enddate 							TIMESTAMP,	
    amount 									DECIMAL(15,5) DEFAULT 0,
	tax 									DECIMAL(15,5) DEFAULT 0,
	total 									DECIMAL(15,5) DEFAULT 0,
	invoicetype 							INT ,
	filename 								VARCHAR(250),
	payment_date		 					TIMESTAMP,
	payment_status							INT DEFAULT 0,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;
CREATE INDEX ind_cc_invoices ON cc_invoices (cover_startdate);


CREATE TABLE cc_invoice_history (
    id 										INT NOT NULL AUTO_INCREMENT,    
    invoiceid 								INT NOT NULL,	
    invoicesent_date 						TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    invoicestatus 							INT ,    
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;
CREATE INDEX ind_cc_invoice_history ON cc_invoice_history (invoicesent_date);





CREATE TABLE cc_package_offer (
    id 					BIGINT NOT NULL AUTO_INCREMENT,
    creationdate 		TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    label 				VARCHAR(70) NOT NULL,
    packagetype 		INT NOT NULL,
	billingtype 		INT NOT NULL,
	startday 			INT NOT NULL,
	freetimetocall 		INT NOT NULL,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;
-- packagetype : Free minute + Unlimited ; Free minute ; Unlimited ; Normal
-- billingtype : Monthly ; Weekly 
-- startday : according to billingtype ; if monthly value 1-31 ; if Weekly value 1-7 (Monday to Sunday) 


CREATE TABLE cc_card_package_offer (
    id 					BIGINT NOT NULL AUTO_INCREMENT,
	id_cc_card 			BIGINT NOT NULL,
	id_cc_package_offer BIGINT NOT NULL,
    date_consumption 	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	used_secondes 		BIGINT NOT NULL,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;
CREATE INDEX ind_cc_card_package_offer_id_card 			ON cc_card_package_offer (id_cc_card);
CREATE INDEX ind_cc_card_package_offer_id_package_offer ON cc_card_package_offer (id_cc_package_offer);
CREATE INDEX ind_cc_card_package_offer_date_consumption ON cc_card_package_offer (date_consumption);

CREATE TABLE cc_subscription_fee (
    id 								BIGINT NOT NULL AUTO_INCREMENT,
    label 							TEXT NOT NULL,
    fee 							FLOAT DEFAULT 0 NOT NULL,
	currency 						CHAR(3) DEFAULT 'USD',
    status 							INT DEFAULT '0' NOT NULL,
    numberofrun 					INT DEFAULT '0' NOT NULL,
    datecreate 						TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    datelastrun 					TIMESTAMP,
    emailreport 					TEXT,
    totalcredit 					FLOAT NOT NULL DEFAULT 0,
    totalcardperform 				INT DEFAULT '0' NOT NULL,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;

-- ## 	INSTEAD USE CC_CHARGE  ##
-- CREATE TABLE cc_subscription_fee_card (
--     id 						BIGINT NOT NULL AUTO_INCREMENT,
--     id_cc_card 				BIGINT NOT NULL,
--     id_cc_subscription_fee 	BIGINT NOT NULL,
--     datefee 				TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
--     fee 					FLOAT DEFAULT 0 NOT NULL,	
-- 	fee_converted 			FLOAT DEFAULT 0 NOT NULL,
-- 	currency 				CHAR(3) DEFAULT 'USD',
--     PRIMARY KEY (id)
-- )ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;
-- 
-- CREATE INDEX ind_cc_subscription_fee_card_id_cc_card  				ON cc_subscription_fee_card (id_cc_card);
-- CREATE INDEX ind_cc_subscription_fee_card_id_cc_subscription_fee 	ON cc_subscription_fee_card (id_cc_subscription_fee);
-- CREATE INDEX ind_cc_subscription_fee_card_datefee 					ON cc_subscription_fee_card (datefee);


-- Table Name: cc_outbound_cid_group
-- For outbound CID Group
-- group_name: Name of the Group Created.

CREATE TABLE cc_outbound_cid_group (
    id 					INT NOT NULL AUTO_INCREMENT,
    creationdate 		TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    group_name 			VARCHAR(70) NOT NULL,    
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;


-- Table Name: cc_outbound_cid_list
-- For outbound CIDs 
-- outbound_cid_group: Foreign Key of the CID Group
-- cid: Caller ID
-- activated Field for Activated or Disabled t=activated.

CREATE TABLE cc_outbound_cid_list (
    id 					INT NOT NULL AUTO_INCREMENT,
	outbound_cid_group	INT NOT NULL,
	cid					CHAR(100) NULL,    
    activated 			INT	NOT NULL DEFAULT 0,
    creationdate 		TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,    
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;







-- Payment Methods Table
CREATE TABLE cc_payment_methods (
    id 						INT NOT NULL AUTO_INCREMENT,
    payment_method 				CHAR(100) NOT NULL,
    payment_filename 				CHAR(200) NOT NULL,
    active 						CHAR(1) DEFAULT 'f' NOT NULL,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;

INSERT INTO cc_payment_methods (payment_method,payment_filename,active) VALUES ('paypal','paypal.php','t');
INSERT INTO cc_payment_methods (payment_method,payment_filename,active) VALUES ('Authorize.Net','authorizenet.php','t');
INSERT INTO cc_payment_methods (payment_method,payment_filename,active) VALUES ('MoneyBookers','moneybookers.php','t');


CREATE TABLE cc_payments (
  id 							INT NOT NULL AUTO_INCREMENT,
  customers_id 					VARCHAR(60) NOT NULL,
  customers_name 				VARCHAR(200) NOT NULL,
  customers_email_address 		VARCHAR(96) NOT NULL,
  item_name 					VARCHAR(127),
  item_id 						VARCHAR(127),
  item_quantity 				INT NOT NULL DEFAULT 0,
  payment_method 				VARCHAR(32) NOT NULL,
  cc_type 						VARCHAR(20),
  cc_owner 						VARCHAR(64),
  cc_number 					VARCHAR(32),
  cc_expires 					VARCHAR(4),
  orders_status 				INT (5) NOT NULL,
  orders_amount 				DECIMAL(14,6),
  last_modified 				DATETIME,
  date_purchased 				DATETIME,
  orders_date_finished 			DATETIME,
  currency 						CHAR(3),
  currency_value 				DECIMAL(14,6),
  PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;

-- Payment Status Lookup Table
CREATE TABLE cc_payments_status (
  id 							INT NOT NULL AUTO_INCREMENT,
  status_id 					INT NOT NULL,
  status_name 					VARCHAR(200) NOT NULL,
  PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;

INSERT INTO cc_payments_status (status_id,status_name) VALUES (-2, 'Failed');
INSERT INTO cc_payments_status (status_id,status_name) VALUES (-1, 'Denied');
INSERT INTO cc_payments_status (status_id,status_name) VALUES (0, 'Pending');
INSERT INTO cc_payments_status (status_id,status_name) VALUES (1, 'In-Progress');
INSERT INTO cc_payments_status (status_id,status_name) VALUES (2, 'Completed');
INSERT INTO cc_payments_status (status_id,status_name) VALUES (3, 'Processed');
INSERT INTO cc_payments_status (status_id,status_name) VALUES (4, 'Refunded');
INSERT INTO cc_payments_status (status_id,status_name) VALUES (5, 'Unknown');


CREATE TABLE cc_configuration (
  configuration_id 					INT NOT NULL AUTO_INCREMENT,
  configuration_title 				VARCHAR(64) NOT NULL,
  configuration_key 				VARCHAR(64) NOT NULL,
  configuration_value 				VARCHAR(255) NOT NULL,
  configuration_description 		VARCHAR(255) NOT NULL,
  configuration_type 				INT NOT NULL DEFAULT 0,
  use_function 						VARCHAR(255) NULL,
  set_function 						VARCHAR(255) NULL,
  PRIMARY KEY (configuration_id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;

INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description) VALUES ('Login Username', 'MODULE_PAYMENT_AUTHORIZENET_LOGIN', 'testing', 'The login username used for the Authorize.net service');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description) VALUES ('Transaction Key', 'MODULE_PAYMENT_AUTHORIZENET_TXNKEY', 'Test', 'Transaction Key used for encrypting TP data');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function) VALUES ('Transaction Mode', 'MODULE_PAYMENT_AUTHORIZENET_TESTMODE', 'Test', 'Transaction mode used for processing orders', 'tep_cfg_select_option(array(\'Test\', \'Production\'), ');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function) VALUES ('Transaction Method', 'MODULE_PAYMENT_AUTHORIZENET_METHOD', 'Credit Card', 'Transaction method used for processing orders', 'tep_cfg_select_option(array(\'Credit Card\', \'eCheck\'), ');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function) VALUES ('Customer Notifications', 'MODULE_PAYMENT_AUTHORIZENET_EMAIL_CUSTOMER', 'False', 'Should Authorize.Net e-mail a receipt to the customer?', 'tep_cfg_select_option(array(\'True\', \'False\'), ');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function) VALUES ('Enable Authorize.net Module', 'MODULE_PAYMENT_AUTHORIZENET_STATUS', 'True', 'Do you want to accept Authorize.net payments?', 'tep_cfg_select_option(array(\'True\', \'False\'), ');

INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function) VALUES ('Enable PayPal Module', 'MODULE_PAYMENT_PAYPAL_STATUS', 'True', 'Do you want to accept PayPal payments?','tep_cfg_select_option(array(\'True\', \'False\'), ');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description) VALUES ('E-Mail Address', 'MODULE_PAYMENT_PAYPAL_ID', 'you@yourbusiness.com', 'The e-mail address to use for the PayPal service');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function) VALUES ('Transaction Currency', 'MODULE_PAYMENT_PAYPAL_CURRENCY', 'Selected Currency', 'The currency to use for credit card transactions', 'tep_cfg_select_option(array(\'Selected Currency\',\'USD\',\'CAD\',\'EUR\',\'GBP\',\'JPY\'), ');

INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description) VALUES ('E-Mail Address', 'MODULE_PAYMENT_MONEYBOOKERS_ID', 'you@yourbusiness.com', 'The eMail address to use for the moneybookers service');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description) VALUES ('Referral ID', 'MODULE_PAYMENT_MONEYBOOKERS_REFID', '989999', 'Your personal Referral ID from moneybookers.com');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function) VALUES ('Transaction Currency', 'MODULE_PAYMENT_MONEYBOOKERS_CURRENCY', 'Selected Currency', 'The default currency for the payment transactions', 'tep_cfg_select_option(array(\'Selected Currency\',\'EUR\', \'USD\', \'GBP\', \'HKD\', \'SGD\', \'JPY\', \'CAD\', \'AUD\', \'CHF\', \'DKK\', \'SEK\', \'NOK\', \'ILS\', \'MYR\', \'NZD\', \'TWD\', \'THB\', \'CZK\', \'HUF\', \'SKK\', \'ISK\', \'INR\'), ');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function) VALUES ('Transaction Language', 'MODULE_PAYMENT_MONEYBOOKERS_LANGUAGE', 'Selected Language', 'The default language for the payment transactions', 'tep_cfg_select_option(array(\'Selected Language\',\'EN\', \'DE\', \'ES\', \'FR\'), ');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function) VALUES ('Enable moneybookers Module', 'MODULE_PAYMENT_MONEYBOOKERS_STATUS', 'True', 'Do you want to accept moneybookers payments?','tep_cfg_select_option(array(\'True\', \'False\'), ');

CREATE TABLE cc_epayment_log (
    id 								INT NOT NULL AUTO_INCREMENT,
    cardid 							INT DEFAULT 0 NOT NULL,
    amount 							FLOAT DEFAULT 0 NOT NULL,
	vat 							FLOAT DEFAULT 0 NOT NULL,
    paymentmethod	 				CHAR(50) NOT NULL,     
  	cc_owner 						VARCHAR(64),
  	cc_number 						VARCHAR(32),
  	cc_expires 						VARCHAR(7),						   
    creationdate  					TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status 							INT DEFAULT 0 NOT NULL,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;


CREATE TABLE cc_system_log (
    id 								INT NOT NULL AUTO_INCREMENT,
    iduser 							INT DEFAULT 0 NOT NULL,
    loglevel	 					INT DEFAULT 0 NOT NULL,
    action			 				TEXT NOT NULL,
    description						MEDIUMTEXT,    
    data			 				BLOB,
	tablename						VARCHAR(255),
	pagename			 			VARCHAR(255),
	ipaddress						VARCHAR(255),	
    creationdate  					TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE utf8_bin;


CREATE TABLE cc_config (
  	id 								INT NOT NULL auto_increment,
	config_title		 			VARCHAR(64) NOT NULL,
	config_key 						VARCHAR(64) NOT NULL,
	config_value 					TEXT NOT NULL,
	config_description 				TEXT NOT NULL,
	config_valuetype				INT NOT NULL DEFAULT 0,	
	config_group_id 				INT NOT NULL,
	config_listvalues				TEXT,
	PRIMARY KEY (id)
);

CREATE TABLE cc_config_group (
  	id 								INT NOT NULL auto_increment,
	group_title 					VARCHAR(64) NOT NULL,	
	group_description 				VARCHAR(255) NOT NULL,
	PRIMARY KEY (id)
);

INSERT INTO cc_config_group (id, group_title, group_description) VALUES (NULL, 'global', 'This configuration group handles the global settings for application.');
INSERT INTO cc_config_group (id, group_title, group_description) VALUES (NULL, 'callback', 'This configuration group handles calllback settings.');
INSERT INTO cc_config_group (id, group_title, group_description) VALUES (NULL, 'webcustomerui', 'This configuration group handles Web Customer User Interface.');
INSERT INTO cc_config_group (id, group_title, group_description) VALUES (NULL, 'sip-iax-info', 'SIP & IAX client configuration information.');
INSERT INTO cc_config_group (id, group_title, group_description) VALUES (NULL, 'epayment_method', 'Epayment Methods Configuration.');
INSERT INTO cc_config_group (id, group_title, group_description) VALUES (NULL, 'signup', 'This configuration group handles the signup related settings.');
INSERT INTO cc_config_group (id, group_title, group_description) VALUES (NULL, 'backup', 'This configuration group handles the backup/restore related settings.');
INSERT INTO cc_config_group (id, group_title, group_description) VALUES (NULL, 'webui', 'This configuration group handles the WEBUI and API Configuration.');
INSERT INTO cc_config_group (id, group_title, group_description) VALUES (NULL, 'peer_friend', 'This configuration group handles the WEBUI and API Configuration.');
INSERT INTO cc_config_group (id, group_title, group_description) VALUES (NULL, 'log-files', 'This configuration group handles the Log Files Directory Paths.');
INSERT INTO cc_config_group (id, group_title, group_description) VALUES (NULL, 'agi-conf1', 'This configuration group handles the AGI Configuration.');



INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Card Number length', 'interval_len_cardnumber', '10-15', 'Card Number length, You can define a Range e.g:10-15.',0 , 1);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Card Alias Length', 'len_aliasnumber', '15', 'Card Number Alias Length e.g: 15.',0 , 1);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Voucher Lenght', 'len_voucher', '15', 'Voucher Number Length.',0 , 1);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Base Currency', 'base_currency', 'usd', 'Base Currency to use for application.',0 , 1);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Invoice Image', 'invoice_image', '10', 'Image to Display on the Top of Invoice',0 , 1);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Admin Email', 'admin_email', '10', 'Web Administrator Email Address.',0 , 1);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('DID Bill Payment Day', 'didbilling_daytopay', '5', 'DID Bill Payment Day of Month',0 , 1);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Manager Host', 'manager_host', 'localhost', 'Manager Host Address',0 , 1);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Manager User ID', 'manager_username', 'myastersik', 'Manger Host User Name',0 , 1);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Manager Password', 'manager_secret', 'mycode', 'Manager Host Password',0 , 1);

INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Context Callback', 'context_callback', '10', 'Contaxt to use in Callback',0 , 2);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Extension', 'extension', '1000', 'Extension to call while callback.',0 , 2);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Avoid Repeat Duration', 'sec_avoid_repeate', '10', 'Number of seconds before the call-back can be re-initiated from the web page to prevent repeated and unwanted calls.',0 , 2);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Time out', 'timeout', '20', 'if the callback doesnt succeed within the value below, then the call is deemed to have failed.',0 , 2);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Answer on Call', 'answer_call', 'yes', 'if we want to manage the answer on the call.',1 , 2);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('No of Predictive Calls', 'nb_predictive_call', '10', 'number of calls an agent will do when the call button is clicked.',0 , 2);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Delay for Availability', 'nb_day_wait_before_retry', '1', 'Number of days to wait before the number becomes available to call again.',0 , 2);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('PD Contect', 'context_preditctivedialer', 'a2billing-predictivedialer', 'The context to redirect the call for the predictive dialer.',0 , 2);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Max Time to call', 'predictivedialer_maxtime_tocall', '10', 'When a call is made we need to limit the call duration : amount in seconds.',0 , 2);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('PD Caller ID', 'callerid', '10', 'Set the callerID for the predictive dialer and call-back.',0 , 2);

INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Callback CallPlan ID', 'all_callback_tariff', '1', 'ID Call Plan to use when you use the all-callback mode, check the ID in the "list Call Plan" - WebUI.',0 , 2);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Server Group ID', 'id_server_group', '1', 'Define the group of servers that are going to be used by the callback.',0 , 2);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Audio Intro', 'callback_audio_intro', 'prepaid-callback_intro', 'Audio intro message when the callback is initiate.',0 , 2);

INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Signup URL', 'signup_page_url', '', 'url of the signup page to show up on the sign in page (if empty no link will show up).',0 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Payment Method', 'paymentmethod', 'yes', 'Enable or disable the payment methods; yes for multi-payment or no for single payment method option.',1 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Personal Info', 'personalinfo', 'yes', 'Enable or disable the page which allow customer to modify its personal information.',1 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Payment Info', 'customerinfo', 'yes', 'Enable display of the payment interface - yes or no.',1 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('SIP/IAX Info', 'sipiaxinfo', 'yes', 'Enable display of the sip/iax info - yes or no.',1 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('CDR', 'cdr', 'yes', 'Enable the Call history - yes or no.',1 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Invoices', 'invoice', 'yes', 'Enable invoices - yes or no.',1 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Voucher Screen', 'voucher', 'yes', 'Enable the voucher screen - yes or no.',1 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Paypal', 'paypal', 'yes', 'Enable the paypal payment buttons - yes or no.',1 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Speed Dial', 'speeddial', 'yes', 'Allow Speed Dial capabilities - yes or no.',1 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('DID', 'did', 'yes', 'Enable the DID (Direct Inwards Dialling) interface - yes or no.',1 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('RateCard', 'ratecard', 'yes', 'Show the ratecards - yes or no.',1 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Simulator', 'simulator', 'yes', 'Offer simulator option on the customer interface - yes or no.',1 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('CallBack', 'callback', 'yes', 'Enable the callback option on the customer interface - yes or no.',1 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Predictive Dialer', 'predictivedialer', '10', 'Enable the predictivedialer option on the customer interface - yes or no.',1 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('WebPhone', 'webphone', 'yes', 'Let users use SIP/IAX Webphone (Options : yes/no).',1 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('WebPhone Server', 'webphoneserver', 'localhost', 'IP address or domain name of asterisk server that would be used by the web-phone.',0 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Caller ID', 'callerid', 'yes', 'Let the users add new callerid.',1 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Password', 'password', 'yes', 'Let the user change the webui password.',1 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('CallerID Limit', 'limit_callerid', '5', 'The total number of callerIDs for CLI Recognition that can be add by the customer.',0 , 3);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Error Email', 'error_email', 'root@localhost', 'Email address to send the notification and error report - new DIDs assigned will also be emailed..',0 , 3);

INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Trunk Name', 'sip_iax_info_trunkname', 'call-labs', 'Trunk Name to show in sip/iax info.',0 , 4);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Codecs Allowed', 'sip_iax_info_allowcodec', 'g729', 'Allowed Codec, ulaw, gsm, g729.',0 , 4);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Host', 'sip_iax_info_host', 'call-labs.com', 'Host information.',0 , 4);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('IAX Parms', 'iax_additional_parameters', 'canreinvite = no', 'IAX Additional Parameters.',0 , 4);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('SIP Parms', 'sip_additional_parameters', 'trustrpid = yes | sendrpid = yes | canreinvite = no', 'SIP Additional Parameters.',0 , 4);


INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Enable', 'enable', 'yes', 'Enable/Disable.',1 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('HTTP Server', 'http_server', 'http://www.call-labs.com', 'Set the Server Address of Website, It should be empty for productive Servers.',0 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('HTTPS Server', 'https_server', 'https://www.call-labs.com', 'https://localhost - Enter here your Secure Server Address, should not be empty for productive servers.',0 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Server IP/Domain', 'http_cookie_domain', '26.63.165.200', 'Enter your Domain Name or IP Address, eg, 26.63.165.200.',0 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Secure Server IP/Domain', 'https_cookie_domain', '26.63.165.200', 'Enter your Secure server Domain Name or IP Address, eg, 26.63.165.200.',0 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Application Path', 'http_cookie_path', '/A2BCustomer_UI/', 'Enter the Physical path of your Application on your server.',0 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Secure Application Path', 'https_cookie_path', '/A2BCustomer_UI/', 'Enter the Physical path of your Application on your Secure Server.',0 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Application Physical Path', 'dir_ws_http_catalog', '/A2BCustomer_UI/', 'Enter the Physical path of your Application on your server.',0 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Secure Application Physical Path', 'dir_ws_https_catalog', '/A2BCustomer_UI/', 'Set the callerID for .',0 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Enable SSL', 'enable_ssl', 'yes', 'secure webserver for checkout procedure?',1 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('HTTP Domain', 'http_domain', '26.63.165.200', 'Http Address.',0 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Directory Path', 'dir_ws_http', '/~areski/svn/a2billing/payment/A2BCustomer_UI/', 'Directory Path.',0 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Payment Amount', 'purchase_amount', '1:2:5:10:20', 'define the different amount of purchase that would be available - 5 amount maximum (5:10:15).',0 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Item Name', 'item_name', 'Credit Purchase', 'Item name that would be display to the user when he will buy credit.',0 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Currency Code', 'currency_code', 'USD', 'Currency for the Credit purchase, only one can be define here.',0 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Paypal Payment URL', 'paypal_payment_url', 'https://www.sandbox.paypal.com/cgi-bin/webscr', 'Define here the URL of paypal gateway the payment (to test with paypal sandbox).',0 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Paypal Verify URL', 'paypal_verify_url', 'www.sandbox.paypal.com', 'paypal transaction verification url.',0 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Authorize.NET Payment URL', 'authorize_payment_url', 'https://test.authorize.net/gateway/transact.dll', 'Define here the URL of Authorize gateway.',0 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('PayPal Store Name', 'store_name', 'Asterisk2Billing', 'paypal store name to show in the paypal site when customer will go to pay.',0 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Transaction Key', 'callerid', 'asdf1212fasd121554sd4f5s45sdf', 'Transaction Key for security of Epayment Max length of 60 Characters.',0 , 5);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Secret Word', 'moneybookers_secretword', 'areski', 'Moneybookers secret word.',0 , 5);

INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Enable', 'enable_signup', 'yes', 'Enable Signup Module.',1 , 6);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Captcha Security', 'enable_captcha', 'yes', 'enable Captcha on the signup module (value : YES or NO).',1 , 6);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Credit', 'credit', '0', 'amount of credit applied to a new user.',0 , 6);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('CallPlan ID List', 'callplan_id_list', '1,2', 'the list of id of call plans which will be shown in signup.',0 , 6);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Card Activation', 'activated', 'no', 'Specify whether the card is created as active or pending.',1 , 6);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Access Type', 'simultaccess', '0', 'Simultaneous or non concurrent access with the card - 0 = INDIVIDUAL ACCESS or 1 = SIMULTANEOUS ACCESS.',0 , 6);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Paid Type', 'typepaid', '0', 'PREPAID CARD  =  0 - POSTPAY CARD  =  1.',0 , 6);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Credit Limit', 'creditlimit', '0', 'Define credit limit, which is only used for a POSTPAY card.',0 , 6);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Run Service', 'runservice', '0', 'Authorise the recurring service to apply on this card  -  Yes 1 - No 0.',0 , 6);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Enable Expire', 'enableexpire', '0', 'Enable the expiry of the card  -  Yes 1 - No 0.',0 , 6);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Date Format', 'expirationdate', '', 'Expiry Date format YYYY-MM-DD HH:MM:SS. For instance 2004-12-31 00:00:00',0 , 6);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Expire Limit', 'expiredays', '0', 'The number of days after which the card will expire.',0 , 6);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Create SIP', 'sip_account', 'yes', 'Create a sip account from signup ( default : yes ).',1 , 6);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Create IAX', 'iax_account', 'yes', 'Create an iax account from signup ( default : yes ).',1 , 6);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Activate Card', 'activatedbyuser', 'yes', 'active card after the new signup. if No, the Signup confirmation is needed and an email will be sent to the user with a link for activation (need to put the link into the Signup mail template).',1 , 6);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Customer Interface URL', 'urlcustomerinterface', 'http://localhost/A2BCustomer_UI/', 'url of the customer interface to display after activation.',0 , 6);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Asterisk Reload', 'reload_asterisk_if_sipiax_created', 'no', 'Define if you want to reload Asterisk when a SIP / IAX Friend is created at signup time.',1 , 6);

INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Backup Path', 'backup_path', '/tmp', 'Path to store backup of database.',0 , 7);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('GZIP Path', 'gzip_exe', '/bin/gzip', 'Path for gzip.',0 , 7);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('GunZip Path', 'gunzip_exe', '/bin/gunzip', 'Path for gunzip .',0 , 7);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('MySql Dump Path', 'mysqldump', '/usr/bin/mysqldump', 'path for mysqldump.',0 , 7);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('PGSql Dump Path', 'pg_dump', '/usr/bin/pg_dump', 'path for pg_dump.',0 , 7);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('MySql Path', 'mysql', '/usr/bin/mysql', 'Path for MySql.',0 , 7);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('PSql Path', 'psql', '/usr/bin/psql', 'Path for PSql.',0 , 7);


INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('SIP File Path', 'buddy_sip_file', '/etc/asterisk/additional_a2billing_sip.conf', 'Path to store the asterisk configuration files SIP.',0 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('IAX File Path', 'buddy_iax_file', '/etc/asterisk/additional_a2billing_iax.conf', 'Path to store the asterisk configuration files IAX.',0 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('API Security Key', 'api_security_key', 'Ae87v56zzl34v', 'API have a security key to validate the http request, the key has to be sent after applying md5, Valid characters are [a-z,A-Z,0-9].',0 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Authorized IP', 'api_ip_auth', '127.0.0.1', 'API to restrict the IPs authorised to make a request, Define The the list of ips separated by '';''.',0 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Admin Email', 'email_admin', 'root@localhost', 'Administative Email.',0 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('MOH Directory', 'dir_store_mohmp3', '/var/lib/asterisk/mohmp3', 'MOH (Music on Hold) base directory.',0 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('MOH Classes', 'num_musiconhold_class', '10', 'Number of MOH classes you have created in musiconhold.conf : acc_1, acc_2... acc_10 class	etc....',0 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Display Help', 'show_help', 'yes', 'Display the help section inside the admin interface  (YES - NO).',1 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Max File Upload Size', 'my_max_file_size_import', '1024000', 'File Upload parameters, PLEASE CHECK ALSO THE VALUE IN YOUR PHP.INI THE LIMIT IS 2MG BY DEFAULT .',0 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Audio Directory Path', 'dir_store_audio', '/var/lib/asterisk/sounds/a2billing', 'Not used yet, The goal is to upload files and use them in the IVR.',0 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Max Audio File Size', 'my_max_file_size_audio', '3072000', 'upload maximum file size.',0 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Extensions Allowed', 'file_ext_allow', 'gsm, mp3, wav', 'File type extensions permitted to be uploaded such as "gsm, mp3, wav" (separated by ,).',0 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Muzic Files Allowed', 'file_ext_allow_musiconhold', 'mp3', 'File type extensions permitted to be uploaded for the musiconhold such as "gsm, mp3, wav" (separate by ,).',0 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Link Audio', 'link_audio_file', 'no', 'Enable link on the CDR viewer to the recordings. (YES - NO).',1 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Monitor Path', 'monitor_path', '/var/spool/asterisk/monitor', 'Path to link the recorded monitor files.',0 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Monitor Format', 'monitor_formatfile', 'gsm', 'FORMAT OF THE RECORDED MONITOR FILE.',0 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Invoice Icon', 'show_icon_invoice', 'yes', 'Display the icon in the invoice.',1 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Show Top Frame', 'show_top_frame', 'no', 'Display the top frame (useful if you want to save space on your little tiny screen ) .',1 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Currency', 'currency_choose', 'usd, eur, cad, hkd', 'Allow the customer to chose the most appropriate currency ("all" can be used).',0 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Card Export Fields', 'card_export_field_list', 'creationdate, username, credit, lastname, firstname', 'Fields to export in csv format from cc_card table.',0 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Vouvher Export Fields', 'voucher_export_field_list', 'id, voucher, credit, tag, activated, usedcardnumber, usedate, currency', 'Field to export in csv format from cc_voucher table.',0 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Advance Mode', 'advanced_mode', 'no', 'Advanced mode - Display additional configuration options on the ratecard (progressive rates, musiconhold, ...).',1 , 8);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('SIP/IAX Delete', 'delete_fk_card', 'yes', 'Delete the SIP/IAX Friend & callerid when a card is deleted.',1 , 8);

INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Type', 'type', 'friend', 'Refer to sip.conf & iax.conf documentation for the meaning of those parameters.',0 , 9);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Allow', 'allow', 'ulaw, alaw, gsm, g729', 'Refer to sip.conf & iax.conf documentation for the meaning of those parameters.',0 , 9);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Context', 'context', 'a2billing', 'Refer to sip.conf & iax.conf documentation for the meaning of those parameters.',0 , 9);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('PD Caller ID', 'nat', 'yes', 'Refer to sip.conf & iax.conf documentation for the meaning of those parameters.',0 , 9);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('AMA Flag', 'amaflag', 'billing', 'Refer to sip.conf & iax.conf documentation for the meaning of those parameters.',0 , 9);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Qualify', 'qualify', 'yes', 'Refer to sip.conf & iax.conf documentation for the meaning of those parameters.',0 , 9);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Host', 'host', 'dynamic', 'Refer to sip.conf & iax.conf documentation for the meaning of those parameters.',0 , 9);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('DTMF Mode', 'dtmfmode', 'RFC2833', 'Refer to sip.conf & iax.conf documentation for the meaning of those parameters.',0 , 9);

INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Alarm Log File', 'cront_alarm', '/tmp/cront_a2b_alarm.log', 'To disable application logging, remove/comment the log file name aside service.',0 , 10);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Auto refill Log File', 'cront_autorefill', '/tmp/cront_a2b_autorefill.log', 'To disable application logging, remove/comment the log file name aside service.',0 , 10);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Bactch Process Log File', 'cront_batch_process', '/tmp/cront_a2b_batch_process.log', 'To disable application logging, remove/comment the log file name aside service .',0 , 10);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('DID Billing Log File', 'cront_bill_diduse', '/tmp/cront_a2b_bill_diduse.log', 'To disable application logging, remove/comment the log file name aside service .',0 , 10);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Subscription Fee Log File', 'cront_subscriptionfee', '/tmp/cront_a2b_subscription_fee.log', 'To disable application logging, remove/comment the log file name aside service.',0 , 10);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Currency Cront Log File', 'cront_currency_update', '/tmp/cront_a2b_currency_update.log', 'To disable application logging, remove/comment the log file name aside service.',0 , 10);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Invoice Cront Log File', 'cront_invoice', '/tmp/cront_a2b_invoice.log', 'To disable application logging, remove/comment the log file name aside service.',0 , 10);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Cornt Log File', 'cront_check_account', '/tmp/cront_a2b_check_account.log', 'To disable application logging, remove/comment the log file name aside service .',0 , 10);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Paypal Log File', 'paypal', '/tmp/a2billing_paypal.log', 'paypal log file, to log all the transaction & error.',0 , 10);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('EPayment Log File', 'epayment', '/tmp/a2billing_epayment.log', 'epayment log file, to log all the transaction & error .',0 , 10);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('ECommerce Log File', 'api_ecommerce', '/tmp/api_ecommerce_request.log', 'Log file to store the ecommerce API requests .',0 , 10);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Callback Log File', 'api_callback', '/tmp/api_callback_request.log', 'Log file to store the CallBack API requests.',0 , 10);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('AGI Log File', 'agi', '/tmp/a2billing_agi.log', 'File to log.',0 , 10);


INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Debug', 'debug', '1', 'The debug level 0=none, 1=low, 2=normal, 3=all.',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Asterisk Version', 'asterisk_version', '1_2', 'Asterisk Version Information, 1_1,1_2,1_4 By Default it will take 1_2 or higher .',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Answer Call', 'answer_call', 'yes', 'Manage the answer on the call.',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Play Audio', 'play_audio', 'yes', 'Play audio - this will disable all stream file but not the Get Data , for wholesale ensure that the authentication works and than number_try = 1.',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Say GoodBye', 'say_goodbye', 'no', 'play the goodbye message when the user has finished.',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Play Language Menu', 'play_menulanguage', 'no', 'enable the menu to choose the language, press 1 for English, pulsa 2 para el español, Pressez 3 pour Français',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Force Language', 'force_language', '', 'force the use of a language, if you dont want to use it leave the option empty, Values : ES, EN, FR, etc... (according to the audio you have installed).',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Intro Prompt', 'intro_prompt', '', 'Introduction prompt : to specify an additional prompt to play at the beginning of the application .',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Min Call Credit', 'min_credit_2call', '0', 'Minimum amount of credit to use the application .',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Min Bill Duration', 'min_duration_2bill', '0', 'this is the minimum duration in seconds of a call in order to be billed any call with a length less than min_duration_2bill will have a 0 cost useful not to charge callers for system errors when a call was answered but it actually didn''t connect.',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Not Enough Credit', 'notenoughcredit_cardnumber', 'yes', 'if user doesn''t have enough credit to call a destination, prompt him to enter another cardnumber .',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('New Caller ID', 'notenoughcredit_assign_newcardnumber_cid', 'yes', 'if notenoughcredit_cardnumber = YES  then	assign the CallerID to the new cardnumber.',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Use DNID', 'use_dnid', 'no', 'if YES it will use the DNID and try to dial out, without asking for the phonenumber to call.',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Not Use DNID', 'no_auth_dnid', '2400,2300', 'list the dnid on which you want to avoid the use of the previous option "use_dnid" .',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Try Count', 'number_try', '3', 'number of times the user can dial different number.',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Force CallPlan', 'force_callplan_id', '', 'this will force to select a specific call plan by the Rate Engine.',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Say Balance After Auth', 'say_balance_after_auth', 'yes', 'Play the balance to the user after the authentication (values : yes - no).',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Say Balance After Call', 'say_balance_after_call', 'no', 'Play the balance to the user after the call (values : yes - no).',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Say Rate', 'say_rateinitial', 'no', 'Play the initial cost of the route (values : yes - no)',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Say Duration', 'say_timetocall', 'yes', 'Play the amount of time that the user can call (values : yes - no).',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Auto Set CLID', 'auto_setcallerid', 'yes', 'enable the setup of the callerID number before the outbound is made, by default the user callerID value will be use.',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Force CLID', 'force_callerid', '', 'If auto_setcallerid is enabled, the value of force_callerid will be set as CallerID.',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('CLID Sanitize', 'cid_sanitize', 'NO', 'If force_callerid is not set, then the following option ensures that CID is set to one of the card''s configured caller IDs or blank if none available.(NO - disable this feature, caller ID can be anything, CID - Caller ID must be one of the customers caller IDs, DID - Caller ID must be one of the customers DID nos, BOTH - Caller ID must be one of the above two items)',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('CLID Enable', 'cid_enable', 'NO', 'enable the callerid authentication if this option is active the CC system will check the CID of caller  .',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Ask PIN', 'cid_askpincode_ifnot_callerid', 'yes', 'if the CID does not exist, then the caller will be prompt to enter his cardnumber .',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Auto CLID', 'cid_auto_assign_card_to_cid', 'yes', 'if the callerID authentication is enable and the authentication fails then the user will be prompt to enter his cardnumber;this option will bound the cardnumber entered to the current callerID so that next call will be directly authenticate.',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Auto Create Card', 'cid_auto_create_card', 'no', 'if the callerID is captured on a2billing, this option will create automatically a new card and add the callerID to it.',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Auto Create Card Length', 'cid_auto_create_card_len', '10', 'set the length of the card that will be auto create (ie, 10).',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Auto Create Card Type', 'cid_auto_create_card_typepaid', 'POSTPAY', 'billing type of the new card( value : POSTPAY or PREPAY) .',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Auto Create Card Credit', 'cid_auto_create_card_credit', '0', 'amount of credit of the new card.',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Auto Create Card Limit', 'cid_auto_create_card_credit_limit', '1000', 'if postpay, define the credit limit for the card.',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Auto Create Card TariffGroup', 'cid_auto_create_card_tariffgroup', '6', 'the tariffgroup to use for the new card (this is the ID that you can find on the admin web interface) .',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Auto CLID Security', 'callerid_authentication_over_cardnumber', 'NO', 'to check callerID over the cardnumber authentication (to guard against spoofing).',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('SIP Call', 'sip_iax_friends', 'NO', 'enable the option to call sip/iax friend for free (values : YES - NO).',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('SIP Call Prefix', 'sip_iax_pstn_direct_call_prefix', '555', 'if SIP_IAX_FRIENDS is active, you can define a prefix for the dialed digits to call a pstn number .',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Direct Call', 'sip_iax_pstn_direct_call', 'no', 'this will enable a prompt to enter your destination number. if number start by sip_iax_pstn_direct_call_prefix we do directly a sip iax call, if not we do a normal call.',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('IVR Voucher Refill', 'ivr_voucher', 'NO', 'enable the option to refill card with voucher in IVR (values : YES - NO) .',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('IVR Voucher Prefix', 'ivr_voucher_prefix', '8', 'if ivr_voucher is active, you can define a prefix for the voucher number to refill your card, values : number - don''t forget to change prepaid-refill_card_with_voucher audio accordingly .',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('IVR Low Credit', 'jump_voucher_if_min_credit', 'NO', 'When the user credit are below the minimum credit to call min_credit jump directly to the voucher IVR menu  (values: YES - NO) .',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Dail Command Parms', 'dialcommand_param', '|60|HRrL(%timeout%:61000:30000)', 'More information about the Dial : http://voip-info.org/wiki-Asterisk+cmd+dial<br>30 :  The timeout parameter is optional. If not specifed, the Dial command will wait indefinitely, exiting only when the originating channel hangs up, or all the dialed channels return a busy or error condition. Otherwise it specifies a maximum time, in seconds, that the Dial command is to wait for a channel to answer.<br>H: Allow the caller to hang up by dialing * <br>r: Generate a ringing tone for the calling party<br>R: Indicate ringing to the calling party when the called party indicates ringing, pass no audio until answered.<br>m: Provide Music on Hold to the calling party until the called channel answers.<br>L(x[:y][:z]): Limit the call to ''x'' ms, warning when ''y'' ms are left, repeated every ''z'' ms)<br>%timeout% tag is replaced by the calculated timeout according the credit & destination rate!.',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('SIP/IAX Dial Command Parms', 'dialcommand_param_sipiax_friend', '|60|HL(3600000:61000:30000)', 'by default (3600000  =  1HOUR MAX CALL).',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Outbound Call', 'switchdialcommand', 'NO', 'Define the order to make the outbound call<br>YES -> SIP/dialedphonenumber@gateway_ip - NO  SIP/gateway_ip/dialedphonenumber<br>Both should work exactly the same but i experimented one case when gateway was supporting dialedphonenumber@gateway_ip, So in case of trouble, try it out.',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Failover Retry Limit', 'failover_recursive_limit', '2', 'failover recursive search - define how many time we want to authorize the research of the failover trunk when a call fails (value : 0 - 20) .',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Max Time', 'maxtime_tocall_negatif_free_route', '5400', 'For free calls, limit the duration: amount in seconds  .',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Send Reminder', 'send_reminder', 'NO', 'Send a reminder email to the user when they are under min_credit_2call  .',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Record Call', 'record_call', 'NO', 'enable to monitor the call (to record all the conversations) value : YES - NO .',1 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Monitor File Format', 'monitor_formatfile', 'gsm', 'format of the recorded monitor file.',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('AGI Force Currency', 'agi_force_currency', '', 'Force to play the balance to the caller in a predefined currency, to use the currency set for by the customer leave this field empty.',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Currency Associated', 'currency_association', 'usd:dollars,mxn:pesos,eur:euros,all:credit', 'Define all the audio (without file extensions) that you want to play according to currency (use , to separate, ie "usd:prepaid-dollar,mxn:pesos,eur:Euro,all:credit").',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('File Enter Destination', 'file_conf_enter_destination', 'prepaid-enter-dest', 'Please enter the file name you want to play when we prompt the calling party to enter the destination number, file_conf_enter_destination = prepaid-enter-number-u-calling-1-or-011.',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('File Language Menu', 'file_conf_enter_menulang', 'prepaid-menulang2', 'Please enter the file name you want to play when we prompt the calling party to choose the prefered language .',0 , 11);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id) VALUES ('Bill Callback', 'callback_bill_1stleg_ifcall_notconnected', 'YES', 'Define if you want to bill the 1st leg on callback even if the call is not connected to the destination.',1 , 11);