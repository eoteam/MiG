package org.mig.services
{
	public final class ValidFunctions
	{

		public static const VALIDATE_USER:String 					= "validateUser";
		public static const GET_CUTOMFIELDS:String 					= "getCustomFields";
		public static const GET_DATA:String 						= "getData";
		public static const GET_CONTENT_TREE:String					= "getContentTree";
		public static const GET_USERS:String 						= "getUsers";
		public static const GET_CONTENT:String 						= "getContent";
		public static const GET_CONTENT_USERS:String				= "getContentUsers";
		public static const GET_CONTENT_MEDIA:String 				= "getContentMedia";
		public static const GET_CONTENT_TAGS:String 				= "getContentTags";
		public static const GET_CONTENT_CONTENT:String 				= "getContentContent";
		public static const GET_MEDIA:String 						= "getMedia";
		public static const GET_TEMPLATES:String 					= "getTemplates";
		public static const CONTENT_SEARCH:String 					= "contentSearch";
		public static const SEND_USER_INFO:String 					= "sendUserInformation";
		public static const MIG_SEARCH:String 						= "migSearch";
		public static const GET_TERMS:String 						= "getTerms";
		public static const GET_ROOT:String							= "getRoot";
		public static const GET_RELATED_CUSTOMFIELDS:String			= "getRelatedCustomFields";
		
		public static const UPDATE_TAG:String 						= "updateTag";
		public static const UPDATE_RECORD:String 					= "updateRecord";
		public static const UPDATE_RECORDS:String 					= "updateRecords";
		public static const UPDATE_CONTAINER_PATHS:String 			= "updateContainerPaths";
		public static const UPDATE_MEDIA_BY_PATH:String 			= "updateMediaByPath";
		public static const INSET_TAG:String 						= "insertTag";
		public static const INSERT_RECORD:String 					= "insertRecord";
		public static const INSET_RECORD_WITH_RELATED_TAGS:String 	= "insertRecordWithRelatedTag";
		public static const DELETE_TAG:String 						= "deleteTag";
		public static const DELETE_RECORD:String 					= "deleteRecord";
		public static const DELETE_RECORDS:String 					= "deleteRecords";
		public static const DELETE_CONTENT:String 					= "deleteContent";
		public static const DELETE_MEDIA_BY_PATH:String 			= "deleteMediaByPath";
		public static const DUPLICATE_CONTENT:String 				= "duplicateContent";

		
		public static const READ_DIRECTORY:String					= "readDirectory";
		public static const CREATE_DIRECTORY:String					= "createDirectory";
		public static const DELETE_DIRECTORY:String					= "removeDirectory";
		public static const DELETE_FILE:String 						= "removeFile";
		public static const RENAME_ITEM:String 						= "renameItem";
		public static const MOVE_FILE:String 						= "moveFile";
		public static const GET_XMP:String 							= "getXMP";
		public static const GET_ID3:String 							= "getID3";
		public static const GET_KEYWORDS:String 					= "getKeywords";
		public static const GET_PLAYTIME:String 					= "getPlayTime";
		public static const DOWNLOAD_ZIP:String 					= "downloadZip";
		public static const DIRECTORY_SIZE:String 					= "getDirSize";
		
		public static const FUNCTIONS_WITH_TABLENAME:Array = [GET_DATA,UPDATE_RECORD,UPDATE_RECORDS,INSERT_RECORD,DELETE_RECORD,DELETE_RECORDS];

	}
}