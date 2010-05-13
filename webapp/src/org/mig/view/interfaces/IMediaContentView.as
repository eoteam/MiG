package org.mig.view.interfaces
{
	public interface IMediaContentView
	{
		function set scalePercent(newVal:Number):void;
		
		function get scalePercent():Number;
				
		function set directory(newVal:String):void;
		
		function get directory():String;
		
		function set fileSrc(newVal:String):void;
		
		function get fileSrc():String;
		
		function get fileExtension():String;
		
	}
}