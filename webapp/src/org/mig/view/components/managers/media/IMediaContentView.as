package com.map.view.mediaManager
{
	import com.map.model.ContentNode;
	
	public interface IMediaContentView
	{
		function set scalePercent(newVal:Number):void;
		
		function get scalePercent():Number;
		
		//function set viewModes(newVal:String):void;
		
		//function get viewMode():String;
		
		function set directory(newVal:String):void;
		
		function get directory():String;
		
		function set fileSrc(newVal:String):void;
		
		function get fileSrc():String;
		
		//function createThumb():void;
		
		//function createDelete();
		
		function get fileExtension():String;
		
	}
}