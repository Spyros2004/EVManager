<?php 
	session_start(); 
?>
<html>
<body>
<?php
	if (isset($_POST['connect'])) {
		echo "<br/>Setting session variables!<br/>";
		// collect value of input field
		$sqlDBname = $_POST['dbName'];
		$sqlUser = $_POST['userName'];
		$sqlPass = $_POST['pswd'];
	
		if (empty($sqlDBname)) echo "Database name is empty!<br/>";
		if (empty($sqlUser)) echo "Username is empty!<br/>";
		if (empty($sqlPass)) echo "Password name is empty!<br/>";

		if (!(empty($sqlDBname) || empty($sqlUser) || empty($sqlPass))) {
			// Set session variables
			$_SESSION["serverName"] = "mssql.cs.ucy.ac.cy";
			$_SESSION["connectionOptions"] = array(
				"Database" => $sqlDBname,
				"Uid" => $sqlUser,
				"PWD" => $sqlPass
			);
		} else {
			session_unset();
			session_destroy();
			echo "<br/>Cannot setup the session variables! Redirecting back in 5 seconds<br/>";
			die('<meta http-equiv="refresh" content="5; url=index.php" />');
		}
	}
?>
<body>
	<table cellSpacing=0 cellPadding=5 width="100%" border=0>
	<tr>
		<td vAlign=top width=170><img height=91 alt=UCY src="images/ucy.jpg" width=94>
			<h5>
				<a href="http://www.ucy.ac.cy/">University of Cyprus</a><BR/>
				<a href="http://www.cs.ucy.ac.cy/">Dept. of Computer Science</a>
			</h5>
		</td>
		<td vAlign=center align=middle><h2>Welcome to the EPL342 project test page</h2></td>
	</tr>
    </table>
	<hr>
	<a href="q1.php">Query 1 (Simple SQL statement)</a><br>
	<a href="q2.php">Query 2 (Calling a stored procedure without parameters)</a><br>
	<form action="q3.php" method="get">
		Query 3 (Calling a stored procedure with parameters)</a><br>
		Parameter: <input type="text" name="city" value="Seattle">
    <input type="submit" name="Query 3">
	</form>

	<hr>
	<?php
		if(isset($_POST['disconnect'])) { 
			echo "Clossing session and redirecting to start page"; 
			session_unset();
			session_destroy();
			die('<meta http-equiv="refresh" content="2; url=index.php" />');
		} 
	?> 
	
	<form method="post"> 
		<input type="submit" name="disconnect" value="Disconnect"/> 
	</form> 

</body>
</html>
