package org.mig.model
{
	import org.mig.model.vo.user.User;
	import org.robotlegs.mvcs.Actor;
	
	public class AppModel extends Actor
	{	
		//start
		public var prompt:String;
		
		
		//session
		public var user:User; //currently logged in user


		//settings
		public var settings:Array;
		public var rootURL:String;
		public var publishedURL:String;
		public var pendingURL:String;
		public var textFormat:String;
		public var timeout:int = 10;
		public var textEditorColor:Number;
		public var timezone:Number;
		public var renderer:String;
		public var mediaURL:String;
		public var thumbURL:String;
		public var fileDir:String;
		public var thumbDir:String;

		
		//data strucutures
		public var managers:Array = [];
		public var colors:Array;
		
		
		//startup count
		public var startupItems:int;
		public var startupCount:int;
		
	}
}