package org.mig.model.vo.media
{
	/**
	 * @flowerModelElementId _edmZoM2REd--irTzzklAjg
	 */
	public class MimeType
	{
		public static const IMAGE:MimeType = new MimeType(1,"images");
		public static const VIDEO:MimeType = new MimeType(2,"video");
		public static const AUDIO:MimeType = new MimeType(3,"audio"); 
		public static const SWF:MimeType = new MimeType(4,"swf");
		public static const FILE:MimeType = new MimeType(5,"file");
		public static const YOUTUBE:MimeType = new MimeType(6,"youtube");	
		public static const FONT:MimeType = new MimeType(7,"font");
		public static const DIRECTORY:MimeType = new MimeType(8,"directory");
		
		
		public function MimeType(id:int,name:String)
		{
			this.id = id;
			this.name = name;
		}

		public static function get list( ):Array
		{
			return [IMAGE,VIDEO,AUDIO,SWF,FILE,YOUTUBE,FONT,DIRECTORY];
		}
		public var id:int;
		public var name:String;
		
	}
}