<html>

<head>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Mrtg statistics</title>
</head>

<body>
<p><u><b>Configuration:</b></u></p>
<ul>
  <li><a href="login.php">Administration (password requiered)</a></li>
</ul>
<p><u><b>Switch list:</b></u></p>
<?

// Replace this path with the path to the config.inc.php file
include ("c:\\mrtg\\conf\\config.inc.php");

$dir = dir($mrtg_html_dir);
echo "<ul>";
while($filename=$dir ->read()) {
	if (eregi("\.(html)$",$filename))
	echo "<li><a href=".$filename.">".substr($filename, 0, -5)."</a></li>";;
}
$dir ->close();
echo "</ul>";
?>

</body>

</html>
