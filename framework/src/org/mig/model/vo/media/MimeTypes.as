package org.mig.model.vo.media
{
	import mx.collections.ArrayList;

	public final class MimeTypes
	{
		public static const IMAGE:int = 1;
		public static const VIDEO:int = 2;
		public static const AUDIO:int = 3; 
		public static const SWF:int = 4;
		public static const FILE:int = 5;
		public static const YOUTUBE:int = 6;	
		public static const FONT:int = 7;
		public static const DIRECTORY:int = 8;
/*		public var imageExtensions:Array= [".jpg", ".jpeg", ".gif", ".png"];
		public var videoExtensions:Array= [".flv", ".mov", ".mp4", ".m4v", ".f4v"];
		public var audioExtensions:Array=[".mp3"];
		public var fontExtensions:Array= [".ttf", ".otf"];  */
		
		public static const TYPES:ArrayList  = new ArrayList([
			{typeid:IMAGE,label:"images"},				
			{typeid:VIDEO,label:"videos"},					
			{typeid:AUDIO,label:"audio"},					
			{typeid:FILE,label:"other"}
		]); 
	}
}