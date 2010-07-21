package org.mig.model.vo.content
{
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	import org.mig.collections.DataCollection;
	import org.mig.model.vo.ConfigurationObject;
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.ValueObject;
	import org.mig.model.vo.app.CustomField;
	
	[Bindable]
	public class Template extends ConfigurationObject
	{
		public function Template() {
			super();
			//stateProps = stateProps.concat(
			customfields = new ArrayList();
			contentTabs = new ArrayList();
		}

		public var is_fixed:int;
		public var is_nesting:int;
		public var orderby:String = "id";
		public var orderdirection:String = "ASC";
		public var generalView:String;
		public var verbosity:int;
		public var customfields:ArrayList;
		public var contentTabs:ArrayList;
		
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