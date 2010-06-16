package org.mig.model.vo.relational
{
	import org.mig.model.vo.BaseContentData;
	import org.mig.model.vo.content.ContentStatus;

	[Bindable]	
	public class ContentMedia extends BaseContentData
	{
		
		public var contentid:Number;
		public var mediaid:Number;
		
		
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
		public var extension:String ;
		public var width:int;
		public var height:int;
		public var rating:int;
		public var color:String;
		
		public var caption:String = '';
		public var credits:String = '';
		public var displayorder:int;
		public var usage_type:String = '';
		public var statusid:int = ContentStatus.DRAFT;
		public var description:String = '';
		public var added:Boolean = true;
		
	}
}