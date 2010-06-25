package org.mig.model.vo.app
{
	import mx.collections.ArrayList;

	public final class CustomFieldTypes
	{		
		public static const BINARY:int							= 1;
		public static const SELECT:int							= 2;
		public static const STRING:int							= 3;
		public static const HTML_TEXT:int						= 4;
		public static const MULTIPLE_SELECT:int 				= 5;
		public static const COLOR:int 							= 6;
		public static const TEXT:int 							= 7;
		public static const DATE:int 							= 8;
		public static const INTEGER:int 						= 9;
		public static const FILE_LINK:int 						= 10;
		public static const MULTIPLE_SELECT_WITH_ORDER:int 		= 11;
		
		public static const TYPES:ArrayList = new ArrayList([
			{typeid:BINARY,label:"binary"},				
			{typeid:SELECT,label:"select"},					
			{typeid:STRING,label:"string"},					
			{typeid:HTML_TEXT,label:"html"},				
			{typeid:MULTIPLE_SELECT,label:"multiple select"}, 		
			{typeid:COLOR,label:"color"}, 					
			{typeid:TEXT,label:"plain text"}, 					
			{typeid:DATE,label:"date"}, 					
			{typeid:INTEGER,label:"integer"}, 				
			{typeid:FILE_LINK,label:"link"}, 				
			{typeid:MULTIPLE_SELECT_WITH_ORDER,label:"ms w order"}
		]); 
	}
}