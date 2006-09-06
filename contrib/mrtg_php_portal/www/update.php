<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>MRTG remove switch:</title>
</head>

<body>

<p><b><u>MRTG update switch stats:</u></b></p>
<FORM ACTION=update.php METHOD=POST>
  <table border="0" width="100%">
    <tr>
      <td width="12%">Switch:</td>
      <td width="88%"><select size="1" name="switch">
	<?
	include ("e:\\mrtg\\conf\\config.inc.php");
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
  </table>
  <br>
  <input type="submit" value="Update" name="B1">
</form>
<hr>
</body>

</html>
<?

// Include config file with path variable, etc...
include ("e:\\mrtg\\conf\\config.inc.php");

if($REQUEST_METHOD == "POST"){ 
	system ($perl_exe." ".$mrtg_exe." ".$mrtg_config_dir.$switch.".cfg");
	echo "Mrtg stats for <b><a href=".$switch.".html".">".$switch."</a></b> updated...<br>";
}
echo "<br><a href=./>Back to index</a>";

?>