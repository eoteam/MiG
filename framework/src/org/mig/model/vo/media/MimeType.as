package org.mig.model.vo.media
{
	public class MimeType
	{
		
		public static var IMAGE:MimeType;
		public static const VIDEO:int = 2;
		public static const AUDIO:int = 3; 
		public static const SWF:int = 4;
		public static const FILE:int = 5;
		public static const YOUTUBE:int = 6;	
		public static const FONT:int = 7;
		public static const DIRECTORY:int = 8;
		
		public var id:int;
		public var name:String;
		public var _extensions:String;
		public function set extensions(value:String):void {
			_extensions = value;
			extensionsArray = value.split(',');
		}
		public function get extensions():String {
			return _extensions;
		}
		
		public var extensionsArray:Array;
	}
}