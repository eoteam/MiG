 package org.mig.controller
{
	public final class Constants
	{
		
    	public static const SERVER_URL:String = "http://localhost/MiG/robotlegs/webapp/bin-debug/php/";
    	
    	public static const GETMEDIACONTENT:String = SERVER_URL+"filesystem/readDir.php";
    	
		public static const UPLOAD_FILE:String = SERVER_URL+"filesystem/upload.php";
    	public static const REMOVE_FILE:String = SERVER_URL+"filesystem/removeFile.php";
    	public static const CREATE_DIR:String = SERVER_URL+"filesystem/createDir.php";
    	public static const REMOVE_DIR:String = SERVER_URL+"filesystem/removeDir.php";
    	public static const RENAME:String = SERVER_URL+"filesystem/rename.php";
		
		public static const XMP_PARSER:String = SERVER_URL+"filesystem/parseXMP.php";
    	
		public static const ID3_PARSER:String = SERVER_URL+"filesystem/parseID3.php";
    	public static const ID3_PLAYTIME:String = SERVER_URL+"filesystem/getPlayTimeID3.php";
    	public static const ZIP_DOWNLOAD:String =SERVER_URL+"filesystem/downloadZip.php?files=";
    	
		public static const CREATE_THUMB:String = SERVER_URL+"filesystem/createThumb.php";
		
    	public static const EXECUTE:String = SERVER_URL+"execute.php";	
	}
}