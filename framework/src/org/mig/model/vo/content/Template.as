package org.mig.model.vo.content
{
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	import org.mig.collections.DataCollection;
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.ValueObject;
	
	[Bindable]
	public class Template extends ContentData
	{
		public function Template() {
			customfields = new ArrayList();
		}
		public var name:String;
		public var customfields:ArrayList;
		//public var config:XML;
	}
}