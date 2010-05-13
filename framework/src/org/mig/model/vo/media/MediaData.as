package org.mig.model.vo.media
{

	import org.mig.model.vo.BaseContentData;

	//this VO will not be dynamic. It will mirror the media table and its current feature set UNLESS custom fields are introduced.	
	[Bindable]
	public class MediaData extends org.mig.model.vo.BaseContentData
	{
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
	}
}