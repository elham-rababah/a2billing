<?php
include ("./lib/defines.php");
include ("./lib/module.access.php");
include ("./lib/Form/Class.FormHandler.inc.php");
include ("./form_data/FG_var_sipiax_info.inc");
include ("./lib/smarty.php");


if (! has_rights (ACX_ACCESS)){
	   Header ("HTTP/1.0 401 Unauthorized");
	   Header ("Location: PP_error.php?c=accessdenied");
	   die();
}

/***********************************************************************************/

getpost_ifset(array('configtype'));

$DBHandle = DbConnect();
$HD_Form -> init();
if($configtype == "")
{
	$configtype = "SIP";
}
$table_instance = new Table();
if($configtype == "IAX")
{
	$config_name = gettext("IAX Config");
	$config_file = gettext("iax.conf");
	$QUERY = "SELECT iax.id, iax.username, iax.secret, iax.disallow, iax.allow, iax.type, iax.host, iax.context FROM cc_iax_buddies iax WHERE iax.id_cc_card = ".$_SESSION["card_id"];	

}
else
{
	$config_name = gettext("SIP Config");
	$config_file = gettext("sip.conf");
	$QUERY = "SELECT sip.id, sip.username, sip.secret, sip.disallow, sip.allow, sip.type, sip.host, sip.context FROM cc_sip_buddies sip where sip.id_cc_card = ".$_SESSION["card_id"];
}
$sip_iax_data = $table_instance->SQLExec ($DBHandle, $QUERY);

//Additonal parameters
$additional_sip = explode("|", SIP_ADDITIONAL_PARAMETERS);
$additional_iax = explode("|", IAX_ADDITIONAL_PARAMETERS);

// #### HEADER SECTION
$smarty->display('main.tpl');

?>
<form name="form1">
<table width="60%" border="0" align="center" cellpadding="0" cellspacing="1">
                                <tr>
                                  <td  class="bgcolor_021">
								  <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                      <tr>

                                        <td colspan="2" class="fontstyle_008">&nbsp;<?php echo gettext("General informations");?> </td>
                                      </tr>
                                      <tr>
                                        <td width="50%" bgcolor="#FFFFFF" class="fontstyle_006">&nbsp;<?php echo gettext("CARD")?></td>
                                        <td width="50%" bgcolor="#FFFFFF" class="fontstyle_006"><?php echo $_SESSION["pr_login"]?></td>
                                      </tr>
                                      <tr>

                                        <td bgcolor="#FFFFFF" class="fontstyle_006">&nbsp;<?php echo gettext("CONFIGURATION TYPE")?> </td>
                                        <td bgcolor="#FFFFFF" class="fontstyle_006"><form name="form1" method="post" action="">
                                           <select name="configtype" id="col_configtype" onChange="window.document.form1.elements['PMChange'].value='Change';window.document.form1.submit();">
                                             <option value="IAX" <?php if($configtype == "IAX")echo "selected"?>><?php echo gettext("IAX")?></option>
                                             <option value="SIP" <?php if($configtype == "SIP")echo "selected"?>><?php echo gettext("SIP")?></option>
                                           </select> 
										  <input name="PMChange" type="hidden" id="PMChange">
                                        </form>                                        </td>

                                      </tr>
									    <tr>
                                        <td colspan="2" bgcolor="#FFFFFF" class="fontstyle_006">&nbsp;<strong><?php echo $config_file;?></strong></td>
                                        </tr>
                                      <tr>
                                        <td colspan="2" bgcolor="#FFFFFF" class="fontstyle_006" align="center"><?php echo $config_name;?><br>
                                         
                                            <textarea name="textfield" cols="80" rows="12" class="form_input_text" ><?php if($configtype == "IAX"){ ?>[<?php echo SIP_IAX_INFO_TRUNKNAME; ?>]
username=<?php echo $sip_iax_data[0][1]?>

type=friend
secret=<?php echo $sip_iax_data[0][2]?>

host=<?php echo SIP_IAX_INFO_HOST; ?>
disallow=all
context=from-trunk ; change for proper context
allow=<?php echo SIP_IAX_INFO_ALLOWCODEC?> ; we support ulaw,alaw,ilbc,gsm,g723.1,g726,g729a
<?php 
if (count($additional_iax) > 0)
{
	for ($i = 0; $i< count($additional_iax); $i++)
	{
		echo trim($additional_iax[$i]).chr(10);
	}
}		
?>
<?php }else{ ?>[<?php echo SIP_IAX_INFO_TRUNKNAME; ?>]
username=<?php echo $sip_iax_data[0][1]?>

type=friend
secret=<?php echo $sip_iax_data[0][2]?>

host=<?php echo SIP_IAX_INFO_HOST; ?>

fromuser=<?php echo $sip_iax_data[0][1]?>

context=from-trunk ; change for proper context
allow=<?php echo SIP_IAX_INFO_ALLOWCODEC?> ; we support ulaw,alaw,ilbc,gsm,g723.1,g726,g729a
<?php 
if (count($additional_sip) > 0)
{
	for ($i = 0; $i< count($additional_sip); $i++)
	{
		echo trim($additional_sip[$i]).chr(10);
	}
}		
?>
<?php } ?>
</textarea>
<br><br>
</td>
                                        </tr>
										
                                  </table></td>
                                </tr>
                              </table>
							  
							  </form>
<?

// #### FOOTER SECTION
$smarty->display('footer.tpl');

?>
