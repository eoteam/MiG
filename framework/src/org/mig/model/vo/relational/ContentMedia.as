package org.mig.model.vo.relational
{
	import org.mig.model.vo.BaseContentData;

	public class ContentMedia extends BaseContentData
	{
		public var statusid:int;
		public var contentid:Number;
		public var mediaid:Number;
		
		
		public var id3:XML;
		public var name:String;
		public var path:String;
		public var mimetypeid:int;
		public var mimetype:String;
		public var thumb:String;
		public var video_proxy:String;
		public var size:Number;
		public var playtime:Number;
		public var url:String;
		public var type:String;
		public var createthumb:String;
		public var extension:String = '';
		public var width:int;
		public var height:int;
		public var rating:int;
		public var color:String;
		
		public var caption:String;
		public var credits:String;
		public var displayorder:int;
		public var usage_type:String;
		
	}
}