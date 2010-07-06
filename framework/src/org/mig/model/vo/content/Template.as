package org.mig.model.vo.content
{
	import mx.collections.ArrayCollection;
	
	import org.mig.collections.DataCollection;
	import org.mig.model.vo.ValueObject;
	
	[Bindable]
	public class Template extends ValueObject
	{
		public function Template() {
			customfields = new DataCollection();
		}
		public var name:String;
		public var classname:String;
		public var customfields:DataCollection;
		public var config:XML;
	}
}