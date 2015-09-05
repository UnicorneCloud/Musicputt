<?
	/*************************************************************************************
	 * MUSICPUTT json server - (listeningList)
	 *
	 * This is the json server for the iOS application musicputt. This server respond to
	 * json request.
	 *
	 * This service is use for get what user in musicput listening and send new song
	 * listening in musicputt.
	 * 
	 * ************************************************************************************/

	$host		= $_SERVER['HTTP_HOST'];
	$request_is_get = true;
	
	header('Content-type: application/json');

	
	///////////////////////////////////////////////////////////////////////////////////////
	// mysql connection
	//
	$mysqli = new mysqli("fdb13.awardspace.net",	// host
						 "1812630_music",		    // user
						 "Asdlkj01msn", 		    // password
						 "1812630_music"); 	        // database
	if ($mysqli->connect_errno) {
		echo "{\n";
		echo "	\"results\": [\n";
		echo "	{\n	\"error\": \"Mysql connection: " . $mysqli->connect_error . "\"\n";
		echo "	}";
		echo "]\n";
		echo "}\n";
				
		exit();
	}
	
	
	
	///////////////////////////////////////////////////////////////////////////////////////
	// check if is a get or post request
	//
	if($_POST){
		$request_is_get = false;
		
		
		if($_POST['mplistening']['trackId']){
				
				// check if this trackId already exist
				$exist = false;
				$sql =  "SELECT trackId, listeningCount FROM listening WHERE trackId = '". $_POST['mplistening']['trackId'] ."' LIMIT 1";
				if( $result = $mysqli->query($sql) ){
						if( $row = $result->fetch_assoc() ){
								$exist = true;
						}
				}
				
				if($exist)
				{
						// if trackId already exist (update)
						$update = "UPDATE listening set listeningCount = " . ($row["listeningCount"] + 1) . ", " . 
													   " listeningDate = '" . date("Y-m-d H:i:s") ."' " .
													   "WHERE trackId = '". $_POST['mplistening']['trackId'] ."'";
						
						
						if($mysqli->query($update)){
								
								echo "{\n";
								echo "	\"results\": [\n";
								echo "	{\n	\"Success\": \"Success update\"\n";
								echo "	}";
								echo "]\n";
								echo "}\n";
						}
						else{
								echo "{\n";
								echo "	\"results\": [\n";
								echo "	{\n	\"error\": \"" . $mysqli->error . "\",\n";
								echo "		\"sql\": \"" . $update . "\"\n";
								echo "	}";
								echo "]\n";
								echo "}\n";
						}
						
				}
				else{
						// if trackId not found (insert)
						$insert = "INSERT INTO listening (trackId, artistId, collectionId, artistName, collectionName, trackName, previewUrl, artworkUrl100, listeningCount) " .
						"VALUES ('" . $_POST['mplistening']['trackId'] . "','" . $_POST['mplistening']['artistId'] . "','" .
						$_POST['mplistening']['collectionId'] . "','" . $_POST['mplistening']['artistName'] . "','" . $_POST['mplistening']['collectionName'] . "','" .
						$_POST['mplistening']['trackName'] . "','" . $_POST['mplistening']['previewUrl'] . "','" . $_POST['mplistening']['artworkUrl100'] . "', '1')";
						
						if($mysqli->query($insert)){
								
								echo "{\n";
								echo "	\"results\": [\n";
								echo "	{\n	\"Success\": \"Success insert\"\n";
								echo "	}";
								echo "]\n";
								echo "}\n";
						}
						else{
								echo "{\n";
								echo "	\"results\": [\n";
								echo "	{\n	\"error\": \"" . $mysqli->error . "\",\n";
								echo "		\"sql\": \"" . $insert . "\"\n";
								echo "	}";
								echo "]\n";
								echo "}\n";
						}
				}	
		}
		else{
				echo "{\n";
				echo "	\"results\": [\n";
				echo "	{\n	\"error\": \"No trackId\"\n";
				echo "	}";
				echo "]\n";
				echo "}\n";
		}
	}
	
	
	///////////////////////////////////////////////////////////////////////////////////////
	// get request
	//
	if($request_is_get==true){
			
		// build sql query
		$sql =  "SELECT trackId, artistId, collectionId, trackName, artistName, collectionName, " .
		"previewUrl, artworkUrl100, listeningDate, listeningCount FROM listening " .
		"ORDER BY YEARWEEK( listeningDate ) DESC LIMIT 500";

		// execute query
		if( $result = $mysqli->query($sql) ){
				
				// start json header
				echo "{\n";
				echo "	\"results\": [\n";
				
				$first = true;
				
				// output data of each row
				while($row = $result->fetch_assoc() ) {
					
					if($first==true){
							$first = false;
					}
					else{
							echo "	,\n";
					}
					
					echo "{\n	\"trackId\": \"" . $row["trackId"] . "\",\n";
					echo "	\"artistId\": \"" . $row["artistId"] . "\",\n";
					echo "	\"collectionId\": \"" . $row["collectionId"] . "\",\n";
					echo "	\"trackName\": \"" . $row["trackName"] . "\",\n";
					echo "	\"artistName\": \"" . $row["artistName"] . "\",\n";
					echo "	\"collectionName\": \"" . $row["collectionName"] . "\",\n";
					echo "	\"previewUrl\": \"" . $row["previewUrl"] . "\",\n";
					echo "	\"artworkUrl100\": \"" . $row["artworkUrl100"] . "\"\n";
					
					echo "	}\n";
				}
				
				// output json bottom
				echo "	]\n";
				echo "}\n";
		}
		else{
				echo "{\n";
				echo "	\"results\": [\n";
				echo "	{\n	\"error\": \"" . $mysqli->error . "\"\n";
				echo "	}";
				echo "]\n";
				echo "}\n";
		}
	}
	
	///////////////////////////////////////////////////////////////////////////////////////
	// mysql disconnection
	//
	$mysqli->close();
	
?>

