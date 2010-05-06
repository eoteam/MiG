package org.mig.model.vo.content
{
	import org.mig.model.vo.ValueObject;
	
	[Bindable]
	public class Template extends ValueObject
	{
		public var name:String;
		public var classname:String;
		public var customfields:Array = [];
		
	}
}