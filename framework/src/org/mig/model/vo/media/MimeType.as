package org.mig.model.vo.media
{
	[Bindable]
	public class MimeType
	{
		public var id:int;
		public var name:String;
		public var _extensions:String;
		public function set extensions(value:String):void {
			_extensions = value;
			extensionsArray = value.split(',');
		}
		public function get extensions():String {
			return _extensions;
		}
		
		public var extensionsArray:Array;
	}
}