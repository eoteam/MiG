package org.mig.view.mediators.content
{
	import org.mig.model.ContentModel;
	import org.mig.model.vo.UpdateData;
	import org.mig.model.vo.ValueObject;
	import org.mig.model.vo.app.CustomField;
	import org.mig.model.vo.content.ContainerData;
	import org.mig.model.vo.content.Template;
	import org.mig.view.components.content.ContentGeneralEditor;
	import org.mig.view.components.content.CustomFieldElement;
	import org.mig.view.events.ContentViewEvent;
	import org.robotlegs.mvcs.Mediator;
	
	public class ContentGeneralEditorMediator extends Mediator
	{
		[Inject]
		public var view:ContentGeneralEditor;
		
		[Inject]
		public var contentModel:ContentModel;
		
		private var cfElements:Array;
		override public function onRegister():void {
			cfElements = [];
			contentModel.templates.filterFunction = filterByTemplate;
			contentModel.templates.refresh();
			var template:Template = contentModel.templates.getItemAt(0) as Template;
			contentModel.templates.filterFunction = null;
			contentModel.templates.refresh();
			
			//var sort:Sort = new Sort();
			//sort.fields = [new SortField("displayorder",false,false,true)];
			//template.customfields.sort = sort;
			//template.customfields.refresh();
			for each(var field:CustomField in template.customfields.source)
			{
				var cfElement:CustomFieldElement = new CustomFieldElement();
				cfElement.customfield = field;
				cfElement.vo = view.content.data as ValueObject;
				view.mainContainer.addElement(cfElement);
				cfElements.push(cfElement);
			}
			
			eventMap.mapListener(view,ContentViewEvent.PUBLISH,publishContent,ContentViewEvent);
		}
		private function filterByTemplate(item:Template):Boolean {
			if(item.id == ContainerData(view.content.data).templateid)
				return true;
			else
				return false;
		}
		private function publishContent(event:ContentViewEvent):void {
			var update:UpdateData = new UpdateData();
			update.id = view.content.data.id;
			for each(var element:CustomFieldElement in cfElements) {
				if(element.modified) {
					//update["customfield"+element.customfield.fieldid] = view.content.data[element.customfield.name];
				}
			}
		}
	}
}