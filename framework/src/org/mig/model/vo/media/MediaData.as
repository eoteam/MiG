package org.mig.model.vo.media
{

	import org.mig.model.vo.ConfigurableContentData;
	import org.mig.model.vo.ContentData;

	//this VO will not be dynamic. It will mirror the media table and its current feature set UNLESS custom fields are introduced.	
	[Bindable]
	public class MediaData extends ConfigurableContentData
	{
		public var id3:XML;
		public var title:String;
		public var name:String;
		public var path:String;
		public var mimetypeid:int;
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
	}
}