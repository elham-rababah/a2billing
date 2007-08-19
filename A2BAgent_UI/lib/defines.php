<?php
	include (dirname(__FILE__)."/Class.A2Billing.php");
	//require_once('DB.php'); // PEAR
	require_once('adodb/adodb.inc.php'); // AdoDB
	include (dirname(__FILE__)."/Class.Table.php");

	$A2B = new A2Billing();
	
	// SELECT THE FILES TO LOAD THE CONFIGURATION
	$A2B -> load_conf($agi, AST_CONFIG_DIR."a2billing.conf", 1);
	
	
	// DEFINE FOR THE DATABASE CONNECTION
	define ("HOST", isset($A2B->config["database"]['hostname'])?$A2B->config["database"]['hostname']:null);
	define ("PORT", isset($A2B->config["database"]['port'])?$A2B->config["database"]['port']:null);
	define ("USER", isset($A2B->config["database"]['user'])?$A2B->config["database"]['user']:null);
	define ("PASS", isset($A2B->config["database"]['password'])?$A2B->config["database"]['password']:null);
	define ("DBNAME", isset($A2B->config["database"]['dbname'])?$A2B->config["database"]['dbname']:null);
	define ("DB_TYPE", isset($A2B->config["database"]['dbtype'])?$A2B->config["database"]['dbtype']:null); 	
	
	
	// WEB DEFINE FROM THE A2BILLING.CONF FILE
	define ("EMAIL_ADMIN", isset($A2B->config["webui"]['email_admin'])?$A2B->config["webui"]['email_admin']:null);
	define ("LEN_CARDNUMBER", isset($A2B->config["webui"]['len_cardnumber'])?$A2B->config["webui"]['len_cardnumber']:null);
	define ("LEN_ALIASNUMBER", isset($A2B->config["webui"]['len_aliasnumber'])?$A2B->config["webui"]['len_aliasnumber']:null);
	define ("LEN_VOUCHER", isset($A2B->config["webui"]['len_voucher'])?$A2B->config["webui"]['len_voucher']:null);
	define ("NUM_MUSICONHOLD_CLASS", isset($A2B->config["webui"]['num_musiconhold_class'])?$A2B->config["webui"]['num_musiconhold_class']:null);
	define ("MANAGER_HOST", isset($A2B->config["webui"]['manager_host'])?$A2B->config["webui"]['manager_host']:null);
	define ("MANAGER_USERNAME", isset($A2B->config["webui"]['manager_username'])?$A2B->config["webui"]['manager_username']:null);
	define ("MANAGER_SECRET", isset($A2B->config["webui"]['manager_secret'])?$A2B->config["webui"]['manager_secret']:null);
	define ("SHOW_HELP", isset($A2B->config["webui"]['show_help'])?$A2B->config["webui"]['show_help']:null);	
	define ("MY_MAX_FILE_SIZE_IMPORT", isset($A2B->config["webui"]['my_max_file_size_import'])?$A2B->config["webui"]['my_max_file_size_import']:null);
	define ("MY_MAX_FILE_SIZE", isset($A2B->config["webui"]['my_max_file_size'])?$A2B->config["webui"]['my_max_file_size']:null);
	define ("DIR_STORE_MOHMP3",isset($A2B->config["webui"]['dir_store_mohmp3'])?$A2B->config["webui"]['dir_store_mohmp3']:null);
	define ("DIR_STORE_AUDIO", isset($A2B->config["webui"]['dir_store_audio'])?$A2B->config["webui"]['dir_store_audio']:null);
	define ("MY_MAX_FILE_SIZE_AUDIO", isset($A2B->config["webui"]['my_max_file_size_audio'])?$A2B->config["webui"]['my_max_file_size_audio']:null);
	$file_ext_allow = isset($A2B->config["webui"]['file_ext_allow'])?$A2B->config["webui"]['file_ext_allow']:null;
	$file_ext_allow_musiconhold = isset($A2B->config["webui"]['file_ext_allow_musiconhold'])?$A2B->config["webui"]['file_ext_allow_musiconhold']:null;
	define ("LINK_AUDIO_FILE", isset($A2B->config["webui"]['link_audio_file'])?$A2B->config["webui"]['link_audio_file']:null);
	define ("MONITOR_PATH", isset($A2B->config["webui"]['monitor_path'])?$A2B->config["webui"]['monitor_path']:null);
	define ("MONITOR_FORMATFILE", isset($A2B->config["webui"]['monitor_formatfile'])?$A2B->config["webui"]['monitor_formatfile']:null); 
	define ("SHOW_ICON_INVOICE", isset($A2B->config["webui"]['show_icon_invoice'])?$A2B->config["webui"]['show_icon_invoice']:null);
	define ("SHOW_TOP_FRAME", isset($A2B->config["webui"]['show_top_frame'])?$A2B->config["webui"]['show_top_frame']:null);
	define ("ADVANCED_MODE", isset($A2B->config["webui"]['advanced_mode'])?$A2B->config["webui"]['advanced_mode']:null);
	
	
	define ("BASE_CURRENCY", isset($A2B->config["webui"]['base_currency'])?$A2B->config["webui"]['base_currency']:null);
	define ("CURRENCY_CHOOSE", isset($A2B->config["webui"]['currency_choose'])?$A2B->config["webui"]['currency_choose']:null);
	
	
	// PAYPAL	
	define ("PAYPAL_EMAIL", isset($A2B->config["paypal"]['paypal_email'])?$A2B->config["paypal"]['paypal_email']:null);
	define ("PAYPAL_FROM_EMAIL",isset( $A2B->config["paypal"]['from_email'])?$A2B->config["paypal"]['from_email']:null);
	define ("PAYPAL_FROM_NAME", isset($A2B->config["paypal"]['from_name'])?$A2B->config["paypal"]['from_name']:null);
	define ("PAYPAL_COMPANY_NAME", isset($A2B->config["paypal"]['company_name'])?$A2B->config["paypal"]['company_name']:null);
	define ("PAYPAL_ERROR_EMAIL", isset($A2B->config["paypal"]['error_email'])?$A2B->config["paypal"]['error_email']:null);
	define ("PAYPAL_ITEM_NAME", isset($A2B->config["paypal"]['item_name'])?$A2B->config["paypal"]['item_name']:null);
	define ("PAYPAL_CURRENCY_CODE", isset($A2B->config["paypal"]['currency_code'])?$A2B->config["paypal"]['currency_code']:null);
	define ("PAYPAL_NOTIFY_URL", isset($A2B->config["paypal"]['notify_url'])?$A2B->config["paypal"]['notify_url']:null);
	define ("PAYPAL_PURCHASE_AMOUNT", isset($A2B->config["paypal"]['purchase_amount'])?$A2B->config["paypal"]['purchase_amount']:null);
	define ("PAYPAL_LOGFILE", isset($A2B->config["paypal"]['paypal_logfile'])?$A2B->config["paypal"]['paypal_logfile']:null);

	
	
	define ("ACTIVATEDBYUSER", isset($A2B->config["signup"]['activatedbyuser'])?$A2B->config["signup"]['activatedbyuser']:null);


	define ("AGENT_REFILLS", isset($A2B->config["agent"]['refills'])?$A2B->config["agent"]['refills']:'5.00|10.00|20.00');
	// max_refill is a chech against forged http requests
	define ("AGENT_MAX_REFILL", isset($A2B->config["agent"]['max_refill'])?$A2B->config["agent"]['max_refill']:50.0);

    //Images Path
    define ("Images_Path","./images");

	define ("Images_Path_Main","./images");
	
	// INCLUDE FILES
	define ("FSROOT", substr(dirname(__FILE__),0,-3));
	define ("LIBDIR", FSROOT."lib/");
	include (FSROOT."lib/help.php");
	include (FSROOT."lib/Misc.php");
	
	
	/*
	 *		GLOBAL USED VARIABLE
	 */
	$PHP_SELF = $_SERVER["PHP_SELF"];
	

	$CURRENT_DATETIME = date("Y-m-d H:i:s");
		
	/*
	 *		GLOBAL POST/GET VARIABLE
	 */		 
	getpost_ifset(array('form_action', 'atmenu', 'action', 'stitle', 'sub_action', 'IDmanager', 'current_page', 'order', 'sens', 'mydisplaylimit', 'filterprefix'));

	// Include general language file
        // Language session
     session_start();
    if(ini_get('register_globals'))
    {
        foreach($_REQUEST as $key => $value)
        {
            $$key = $value;
        }
    }

require("languageSettings.php");
	// Actual setting of language has moved to module.access, since it is related
	// to the login account.

	/*
	 *	CONNECT / DISCONNECT DATABASE
	 */

	function DbConnect($db= NULL)
	{
		if (DB_TYPE == "postgres"){
			if (HOST!=null)
				$datasource = 'pgsql://'.USER.':'.PASS.'@'.HOST.'/'.DBNAME;
			else
				$datasource = 'pgsql://dbname='.DBNAME.' user='.USER ;
		}else{
			$datasource = 'mysql://'.USER.':'.PASS.'@'.HOST.'/'.DBNAME;
		}
		
		$DBHandle = NewADOConnection($datasource);

		if (!$DBHandle) die("Connection failed");

		return $DBHandle;
	}
	
	
	function DbDisconnect($DBHandle)
	{
		$DBHandle ->disconnect();
	}


	function get_currencies()
	{
		$handle = DbConnect();
		$instance_table = new Table();
		$QUERY =  "SELECT id,currency,name,value from cc_currencies order by id";
		$result = $instance_table -> SQLExec ($handle, $QUERY);
		/*
			$currencies_list['ADF'][1]="Andorran Franc";
			$currencies_list['ADF'][2]="0.1339";
			[ADF] => Array ( [1] => Andorran Franc (ADF), [2] => 0.1339 )
		*/

		if (is_array($result)){
			$num_cur = count($result);
			for ($i=0;$i<$num_cur;$i++)
				$currencies_list[$result[$i][1]] = array (1 => $result[$i][2], 2 => $result[$i][3]);
		}	
		
		return $currencies_list;
	}

	
// 	function get_languages_r(&$langs) {
// 	//FIXME!
// 		if (is_array($langs)){
// 			$num=count($langs);
// 			for ($i=0;$i<$num;$i++)
// 				$ret_list[$i]=array($langs[$i][1], $langs[$i][0]);
// 		}
// 		return $ret_list;
// 	}

/** @param $typ a string describing the charge type. It can be in the form "3|4|5" so
	that multiple sides can be selected.
*/
	function get_chargetypes($typ = '3')
	{
		$handle = DbConnect();
		$it = new Table();
		$sides= explode('|',$typ);
		foreach ($sides as $s)
			$sides_c[] = "side = " . trim($s);
		$sides_clause = implode (" OR ", $sides_c);
		$QUERY =  "SELECT id, gettexti(id,'". getenv('LANG')."'), charge FROM cc_paytypes WHERE $sides_clause ORDER BY id";
		// $it->debug_st =1;
		$result = $it -> SQLExec ($handle, $QUERY);
		
		if (is_array($result)){
			$num = count($result);
			for ($i=0;$i<$num;$i++)
				$charges_list[$result[$i][0]] = array (1 => $result[$i][0], 
					0 => $result[$i][1], 2 => $result[$i][2]);
		}
		
		return $charges_list;
	}
	
	function getmonthnames(){
	return array( gettext("JANUARY"), gettext("FEBRUARY"), gettext("MARCH"),
		gettext("APRIL"), gettext("MAY"), gettext("JUNE"),
		gettext("JULY"), gettext("AUGUST"), gettext("SEPTEMBER"),
		gettext("OCTOBER"), gettext("NOVEMBER"), gettext("DECEMBER"));
	}
?>