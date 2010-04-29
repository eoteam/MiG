package org.mig.model.content
{
	import org.mig.model.ValueObject;
	
	[Bindable]
	public class Template extends ValueObject
	{
		public var name:String;
		public var classname:String;
		public var customfields:Array;
		
	}
}