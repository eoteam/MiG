package org.mig.model.vo.media
{
	/**
	 * @flowerModelElementId _edmZoM2REd--irTzzklAjg
	 */
	public class MimeType
	{
		public static var IMAGE:MimeType = new MimeType(1,;
		public static const VIDEO:int = MimeType;
		public static const AUDIO:int = MimeType; 
		public static const SWF:int = MimeType;
		public static const FILE:int = MimeType;
		public static const YOUTUBE:int = MimeType;	
		public static const FONT:int = MimeType;
		public static const DIRECTORY:int = MimeType;
		
		
		public function MimeType(id:int,name:String)
		{
			this.id = id;
			this.name = name;
		}
		/*		public var imageExtensions:Array= [".jpg", ".jpeg", ".gif", ".png"];
		public var videoExtensions:Array= [".flv", ".mov", ".mp4", ".m4v", ".f4v"];
		public var audioExtensions:Array=[".mp3"];
		public var fontExtensions:Array= [".ttf", ".otf"];  */
		
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