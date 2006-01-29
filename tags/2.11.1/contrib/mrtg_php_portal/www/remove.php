<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>MRTG remove switch:</title>
</head>

<body>

<p><b><u>MRTG remove switch:</u></b></p>
<FORM ACTION=remove.php METHOD=POST>
  <table border="0" width="100%">
    <tr>
      <td width="12%">Switch:</td>
      <td width="88%"><select size="1" name="switch">
	<?
	// Include config file with path variable, etc...
	include ("c:\\mrtg\\conf\\config.inc.php");
	$dir = dir($mrtg_config_dir);
	// echo "<ul>";
	while($filename=$dir->read()) {
	if (eregi("\.(cfg)$",$filename))
		echo "<option value=".substr($filename, 0, -4).">".substr($filename, 0, -4)."</option>";
	}
	$dir->close();
	//echo "</ul>";
	?>
       </select></td>
    </tr>
    <tr>
      <td width="12%">Option:</td>
      <td width="88%"><input type="checkbox" name="del_config" value="ON">Delete
        config file</td>
    </tr>
    <tr>
      <td width="12%"></td>
      <td width="88%"><input type="checkbox" name="del_html" value="ON">Delete
        stats</td>
    </tr>
    <tr>
      <td width="12%"></td>
      <td width="88%"><input type="checkbox" name="del_index" value="ON">Delete
        html index</td>
    </tr>
  </table>
  <input type="submit" value="Delete" name="B1"><input type="reset" value="Reset" name="B2">
</form>
<hr>
</body>

</html>
<?

// Include config file with path variable, etc...
include ("e:\\mrtg\\conf\\config.inc.php");


if($REQUEST_METHOD == "POST"){ 
	if (file_exists($mrtg_config_dir.$switch.".cfg") && $del_config == "ON") { 
		echo " $switch config files removed...<br>";
		unlink($mrtg_config_dir.$switch.".cfg"); 
		unlink($mrtg_config_dir.$switch.".ok");
	}
	if (file_exists($mrtg_html_dir.$switch) && $del_html == "ON") { 
		echo " $switch html files removed...<br>";
		exec( "rmdir /s /q ".$mrtg_html_dir.$switch); 
	}
	if (file_exists($mrtg_html_dir.$switch.".html") && $del_index == "ON") { 
		echo " $switch index files removed...<br>";
		unlink($mrtg_html_dir.$switch.".html"); 
	}
}
echo "<br><a href=./>Back to index</a>";

?>