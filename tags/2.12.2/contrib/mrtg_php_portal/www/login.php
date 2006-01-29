<html>
<script>
<!--
function setfocus() { document.login.form_password.focus(); }
-->
</script>


<head>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>MRTG Admin login</title>
</head>

<body onLoad=setfocus()>
<p><b><u>MRTG Admin login</u></b></p>
<FORM name=login ACTION=login.php METHOD=POST>
  <table border="0" width="100%">
    <tr>
      <td width="12%">Admin Password:</td>
      <td width="88%"><input type="password" name="form_password" size="20" tabindex="1"></td>
    </tr>
  </table>
  <p><input type="submit" value="Login" name="B1" tabindex="2"></p>
</form>

</body></html>

<?php  

// Replace this path with the path to the config.inc.php file
include ("e:\\mrtg\\conf\\config.inc.php");

if ($pass_wrong == "1"){
	echo "Wrong password !!!<br>";
}
if($REQUEST_METHOD == "POST"){ 
if($form_password){  
  if($form_password == $admin_password1 or $form_password == $admin_password2){  
     ?>  
      <script language="JavaScript">  
      location="./admin.php";  
      </script>  
     <?php
  }else{  
      ?>  
      <script language="JavaScript">  
      location="./login.php?pass_wrong=1";  
      </script>  
      <?php  
  }  
}  
}
?>  
