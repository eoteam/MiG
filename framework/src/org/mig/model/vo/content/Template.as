package org.mig.model.vo.content
{
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	import org.mig.collections.DataCollection;
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.ValueObject;
	import org.mig.model.vo.app.CustomField;
	
	[Bindable]
	public class Template extends ContentData
	{
		public function Template() {
			customfields = new ArrayList();
		}
		public var name:String;
		public var customfields:ArrayList;
		
	/*	public function clone(id:int):Template {
			var template:Template = new Template();
			template.name = this.name;
			template.id = id;
			for each(var field:CustomField in customfields.source) {
				var newField:CustomField = field.clone();
				newField.templateid = id;
				template.customfields.addItem(newField);
			}
			return template;
		}*/
		//public var config:XML;
	}
}