package org.mig.view.mediators.content
{
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.UpdateData;
	import org.mig.model.vo.content.ContentData;
	import org.mig.model.vo.content.Template;
	import org.mig.model.vo.content.TemplateCustomField;
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
			
			var sort:Sort = new Sort();
			sort.fields = [new SortField("displayorder",false,false,true)];
			template.customfields.sort = sort;
			template.customfields.refresh();
			for each(var field:TemplateCustomField in template.customfields)
			{
				var cfElement:CustomFieldElement = new CustomFieldElement();
				cfElement.field = field;
				cfElement.vo = view.content.data as ContentData;
				view.mainContainer.addElement(cfElement);
				cfElements.push(cfElement);
			}
			
			eventMap.mapListener(view,ContentViewEvent.PUBLISH,publishContent,ContentViewEvent);
		}
		private function filterByTemplate(item:Template):Boolean {
			if(item.id == ContentData(view.content.data).templateid)
				return true;
			else
				return false;
		}
		private function publishContent(event:ContentViewEvent):void {
			var update:UpdateData = new UpdateData();
			update.id = view.content.data.id;
			for each(var element:CustomFieldElement in cfElements) {
				if(element.modified) {
					update["customfield"+element.field.fieldid] = view.content.data[element.field.customfield.name];
				}
			}
		}
	}
}