package org.mig.model
{
	import org.mig.model.vo.user.User;
	import org.robotlegs.mvcs.Actor;
	
	public class AppModel extends Actor
	{
		public var config:XML;
		
		public var prompt:String;
		public var configfile:String;
		public var user:User; //currently logged in user

		public var managers:Array = [];
		
		public var mediaURL:String;
		public var thumbURL:String;
		public var fileDir:String;
		public var thumbDir:String;
		
		
		public var timeZoneOffset:Number = -8*3600*1000;
		
		public var textEditorColor:Number;
		public var htmlRendering:Boolean = false;
		public var rootURL:String;
		public var textFormat:String;
		public var timeout:int = 10;
		public var publishedURL:String;
		public var pendingURL:String;
	}
}