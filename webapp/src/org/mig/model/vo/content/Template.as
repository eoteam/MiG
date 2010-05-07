package org.mig.model.vo.content
{
	import mx.collections.ArrayCollection;
	
	import org.mig.model.vo.ValueObject;
	
	[Bindable]
	public class Template extends ValueObject
	{
		public function Template() {
			customfields = new ArrayCollection();
		}
		public var name:String;
		public var classname:String;
		public var customfields:ArrayCollection;
		
	}
}