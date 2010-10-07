package org.mig.model.vo.app
{
	import mx.collections.ArrayList;

	public final class CustomFieldType
	{		
		public static const NONE:CustomFieldType	= new CustomFieldType(0,"none");
		public static const BINARY:CustomFieldType	= new CustomFieldType(1,"binary");
		public static const SELECT:CustomFieldType	= new CustomFieldType(2,"select");
		public static const STRING:CustomFieldType	= new CustomFieldType(3,"string");
		public static const HTML_TEXT:CustomFieldType = new CustomFieldType(4,"html_text");
		public static const MULTIPLE_SELECT:CustomFieldType = new CustomFieldType(5,"multiple_select");
		public static const COLOR:CustomFieldType = new CustomFieldType(6,"color");
		public static const TEXT:CustomFieldType = new CustomFieldType(7,"text");
		public static const DATE:CustomFieldType = new CustomFieldType(8,"date");
		public static const INTEGER:CustomFieldType = new CustomFieldType(9,"integer");
		public static const FILE_LINK:CustomFieldType = new CustomFieldType(10,"file_link");
		public static const MULTIPLE_SELECT_WITH_ORDER:CustomFieldType = new CustomFieldType(11,"multiple_select_with_order");
		
		public var id:int;
		public var name:String;
		
		public function CustomFieldType(id:int,name:String)
		{
			this.id = id;
			this.name = name;
		}
	
		public static function get list( ):Array
		{
			return [NONE,BINARY,SELECT,STRING,HTML_TEXT,MULTIPLE_SELECT,COLOR,TEXT,DATE,INTEGER,FILE_LINK,MULTIPLE_SELECT_WITH_ORDER];
		}
		
	}
}