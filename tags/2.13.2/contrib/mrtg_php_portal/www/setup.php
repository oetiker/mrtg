<html>

<head>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>MRTG New Switch configuration</title>
</head>

<body>

<p><b><u>MRTG New Switch configuration</u></b></p>
<FORM ACTION=setup.php METHOD=POST>
  <table border="0" width="100%">
    <tr>
      <td width="12%">Switch IP or Hostname:</td>
      <td width="88%"><input type="text" name="switch_ip" size="20"></td>
    </tr>
    <tr>
      <td width="12%">Snmp community:</td>
      <td width="88%"><input type="text" name="snmp_community" size="20" value="public"></td>
    </tr>
    <tr>
      <td width="12%">Option:</td>
      <td width="88%"><input type="checkbox" name="run_cfgmaker" value="ON" checked>Generate
        config</td>
    </tr>
    <tr>
      <td width="12%"></td>
      <td width="88%"><input type="checkbox" name="run_mrtg" value="ON" checked>Run
        mrtg</td>
    </tr>
    <tr>
      <td width="12%"></td>
      <td width="88%"><input type="checkbox" name="run_indexmaker" value="ON" checked>Create
        html index</td>
    </tr>
    <tr>
      <td width="12%">Cfgmaker options:</td>
      <td width="88%" align="left" valign="top">
        <input type="checkbox" name="nodown" value="--no-down">Query down
        interface (--no-down)</td>
    </tr>
    <tr>
      <td width="12%"></td>
      <td width="88%" align="left" valign="top">
        <input type="checkbox" name="noreverse" value="--noreversedns">No
        reverse Dns (--noreversedns)</td>
    </tr>
    <tr>
      <td width="12%">Mrtg Options:</td>
      <td width="88%" align="left" valign="top">
        <p align="left"><input type="checkbox" name="growright" value="growright" checked>Right
        starting graph (growright)</td>
    </tr>
    <tr>
      <td width="12%"></td>
      <td width="88%"><input type="checkbox" name="bits" value="bits" checked>Graph
        in Bits (bits)</td>
    </tr>
    <tr>
      <td width="12%">Interface Name:</td>
      <td width="88%"><select size="1" name="interface_desc">
          <option selected value="nr">Interface Number</option>
          <option value="ip">Ip Address</option>
          <option value="eth">Ethernet Number</option>
          <option value="descr">Interface Description</option>
          <option value="name">Interface Name</option>
          <option value="alias">Interface Alias</option>
          <option value="type">Interface Type</option>
        </select></td>
    </tr>
  </table>
  <p><input type="submit" value="Add switch" name="B1"><input type="reset" value="Reset" name="B2"></p>
</form>
<hr>

<? 

if($REQUEST_METHOD == "POST"){ 

// Replace this path with the path to the config.inc.php file
include ("e:\\mrtg\\conf\\config.inc.php");

// Build Cfgmaker options from the html form
$cfgmaker_option = " ".$nodown." ".$noreverse;
 
// Build Cfgmaker options from the html form
$cfgmaker_global_option = $growright.",".$bits; 
$cfgmaker_param = "--global \"WorkDir: ".$mrtg_html_dir.$switch_ip."\""." --global \"Icondir: ".$mrtg_icon_dir."\""
	." --global \"Options[_]: ".$cfgmaker_global_option."\""
	." --ifdesc=".$interface_desc." --community "
	.$snmp_community
	.$cfgmaker_option." --output=".$mrtg_config_dir
	.$switch_ip.".cfg";
$indexmaker_option = " --output=".$mrtg_html_dir.$switch_ip.".html"." --prefix=./".$switch_ip."/"." ".$mrtg_config_dir.$switch_ip.".cfg";;


// Test if the host answer telnet ('cause UDP querie is always successfull :-()
$fp = fsockopen ($switch_ip, 23, $errno, $errstr, 1);
if (!$fp) {
    echo "The host:".$switch_ip." did not respond...";
    echo "<hr><a href=./>Back to index</a>";
    exit();
}

// Creating dir for Switch config files and stats files
if (!file_exists($switch_ip) && $switch_ip <> "") { 
mkdir ($switch_ip,700);
}

// Run Cfg maker and mrtg script with argument from the form
if ($switch_ip <> "") {
	if ($run_cfgmaker == "ON") {
		//echo $mrtg_html_dir."<br>";
		//echo $perl_exe." ".$cfgmaker_exe." ".$cfgmaker_param." ".$switch_ip;
		system($perl_exe." ".$cfgmaker_exe." ".$cfgmaker_param." ".$switch_ip);
		echo "Mrtg config for <b><a href=".$switch_ip.".html".">".$switch_ip."</a></b> created...<br>";
	}
	if ($run_mrtg == "ON") {
		//echo $perl_exe." ".$mrtg_exe." ".$mrtg_config_dir.$switch_ip.".cfg"."<br>";
		system ($perl_exe." ".$mrtg_exe." ".$mrtg_config_dir.$switch_ip.".cfg");
		echo "1st run Mrtg stats generated...<br>";
	}
	if ($run_indexmaker == "ON") {
		system ($perl_exe." ".$indexmaker_exe." ".$indexmaker_option);
		echo "Mrtg html index generated...<br>";
	}
	
}
}
echo "<br><a href=./>Back to index</a>";
?>
</body>

</html>



