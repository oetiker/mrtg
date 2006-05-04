<?php
//This is the only variable you might need to change.
$dir = "/home/httpd/html/mrtg";

//These variables can be used to change some of the colors

//Colors for the log file tables
$topcol = "bgcolor=#eeeeee";
$namew = "bgcolor=#f4f4f4";
$valw = "bgcolor=#ffffff";

//Background colors for alternate tables
$bigback1 = "bgcolor=#EEFFFF";
$bigback2 = "bgcolor=#F2FFF2";




//Please do not edit any of the code below unless you know what your doing
$version = "V 1.021";
$first=1;
$extime = gmDate("D") . "," . gmDate("d M Y H:i:s") . "GMT";
?>

<html>
<head>
<META HTTP-EQUIV="Refresh" CONTENT="300">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="<?php echo $extime; ?>">
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
<title>Welcome to MRTG-PHP</title>
<style fprolloverstyle>A:hover {color: #33CCFF; text-decoration: underline}
</style>
</head>

<body link="#808080" vlink="#000080" alink="#C0C0C0" bgcolor=#ffffff>


<p align="center"><b><font size=+2 color="#808080">- MRTG-PHP <?php echo $version; ?>, the MRTG log file veiwer -</font></b></p>
<div align="center">
  <center>

<b><font color=#aaaaaa><a name=top>Page jumps</a></font></b><br>
<?php

chdir($dir);
if(!($dp = opendir($dir))) die("Can't open $dir.");
$count=-1;
$files="";
$names="";

while($file = readdir($dp)) {
   if(is_dir($file)) {
      if($file != '.' && $file != '..' ) {
         echo "/$file<BR>";
         traverse_dir("$dir/$file");
         chdir($dir);
      }
   }
   else if (stristr($file,"html") <> "" AND stristr($file,"~") <> "~") {
      $j =0; 
      $oldfile=$namefile;
      $namefile = "";
      While ($file[$j] <> "_") { $namefile = $namefile . $file[$j]; $j++ ;}
      $count++;      
      $filearray[$count][0] = $file;
      $filearray[$count][1] = $namefile;
      if ($oldfile!=$namefile and $first=1)
         echo "<a href=#$namefile>$namefile</a><br>";
      $first=0;
   }
}

echo "<br>";
$first=1;
$namefile="";
$tablestart = 1;
$alt = 1;

for ($counter=0; $counter<=$count; $counter++) {
   if ($counter>0) $oldfile = $filearray[$counter-1][1];
   if ($oldfile!=$filearray[$counter][1] and $first=1) {
      if ($tablestart == 1) $tablestart = 0;
      else echo "</td></tr></table>";
      echo "<table border=1 width=100% cellspacing=0 cellpadding=2 bordercolor=#C0C0C0 ";
      if ($alt == 1) {
         $alt = 0;
         echo $bigback1;
      } else {
         $alt = 1;
         echo $bigback2;
      }
      echo "><tr>
               <td width=100%>
                  <p align=center>
                     <a name=" . $filearray[$counter][1] . "></a>
                     <b><font size=+2 color=#808080>" . $filearray[$counter][1] . "</font></b><br>";
   }
   $first=0;
   $j =0;
   $ifname="";
   $iftype="";
   $system="";
   $maintain="";
   $des="";
   $speed="";
   $log=file($filearray[$counter][0]);
   while (strchr($log[$j],"<H1>")=="") $j++;
   $logline=$log[$j];

   $i=strpos($logline,"ifName")+21;
   While ($logline[$i] <> "<") {$ifname=$ifname.$logline[$i]; $i++;}
   If (!$ifname) $ifname = "<font color=#ff0000>Not set</font>";

   $i=strpos($logline,"ifType")+21;
   While ($logline[$i] <> "<") {$iftype=$iftype.$logline[$i]; $i++;}
   If (!$iftype) $iftype = "<font color=#ff0000>Not set</font>";

   $i=strpos($logline,"System")+21;
   While ($logline[$i] <> "<") {$system=$system.$logline[$i]; $i++;}
   If (!$system) $system = "<font color=#ff0000>Not set</font>";

   $i=strpos($logline,"Maintain")+21;
   While ($logline[$i] <> "<") {$maintain=$maintain.$logline[$i]; $i++;}
   If (!$maintain) $maintain = "<font color=#ff0000>Not set</font>";

   $i=strpos($logline,"Description")+21;
   While ($logline[$i] <> "<") {$des=$des.$logline[$i]; $i++;}
   If (strlen($des)<4) $des = "<font color=#ff0000>Not set</font>";

   $i=strpos($logline,"Max Speed")+21;
   While ($logline[$i] <> "<") {$speed=$speed.$logline[$i]; $i++;}
   If (!$speed) $speed = "<font color=#ff0000>Not set</font>";


?>

 <table width="750" border="1" cellspacing="0" cellpadding="3" bordercolor="#808080">
    <tr>
      <td width="100%" colspan="2" <?php echo $topcol; ?>>
        <p align="center"><a href="mrtg/<?php echo $filearray[$counter][0];?>"><font size=+1><?php echo $filearray[$counter][1]; ?></font></a></td>
    </tr>
    <tr> 
      <td width=20% <?php echo $namew; ?> align="right">Description </td>
      <td width=80% <?php echo $valw; ?>><?php echo $des; ?></td> 
    </tr> 
    <tr> 
      <td width=20% <?php echo $namew; ?> align="right">Maintainer </td> 
      <td width=80% <?php echo $valw; ?>><?php echo $maintain; ?></td> 
    </tr> 
    <tr> 
      <td width=20% <?php echo $namew; ?> align="right">System </td> 
      <td width=80% <?php echo $valw; ?>><?php echo $system; ?></td> 
    </tr> 
    <tr> 
      <td width=20% <?php echo $namew; ?> align="right">Connection Name </td> 
      <td width=80% <?php echo $valw; ?>><?php echo $ifname; ?></td> 
    </tr> 
    <tr> 
      <td width=20% <?php echo $namew; ?> align="right">Connection Type </td> 
      <td width=80% <?php echo $valw; ?>><?php echo $iftype; ?></td> 
    </tr> 
    <tr> 
      <td width=20% <?php echo $namew; ?> align="right">Max Speed </td> 
      <td width=80% <?php echo $valw; ?>><?php echo $speed; ?></td> 
    </tr> 
  </table>
  <font size=-1 color=#808080><a href=#top>-Back to top-</a></font>
<?php } ?>
</td></tr></table>
  </center>
</div>

<p align="center"><font size="1" color="#808080">MRTG-PHP <?php echo $version; ?> Written by <a href="mailto:crazydave@ntlworld.com">David
Boyer</a> and <a href=mailto:joseph_j@glan-hafren.ac.uk>Jo Joseph</a></font></p>

</body>
</html>
