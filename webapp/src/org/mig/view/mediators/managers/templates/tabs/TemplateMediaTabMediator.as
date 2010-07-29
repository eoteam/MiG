package org.mig.view.mediators.managers.templates.tabs
{
	import flash.events.MouseEvent;
	
	import mx.events.CollectionEvent;
	import mx.events.FlexEvent;
	
	import org.mig.model.vo.content.ContentTabParameter;
	import org.mig.view.components.managers.templates.tabs.TemplateMediaTab;
	import org.mig.view.events.ContentViewEvent;
	import org.robotlegs.mvcs.Mediator;
	
	public class TemplateMediaTabMediator extends Mediator
	{
		[Inject]
		public var view:TemplateMediaTab;
		
		override public function onRegister():void {
			view.addEventListener(FlexEvent.CONTENT_CREATION_COMPLETE,handleViewCreated);
		}
		private function handleViewCreated(event:FlexEvent):void {
			view.addButton.addEventListener(MouseEvent.CLICK,handleAddButton);
			view.tab.parameters.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleParametersChange);
		}
		private function handleAddButton(event:MouseEvent):void {
			var param:ContentTabParameter = new ContentTabParameter();
			param.name = "usage";
			param.tabid = view.tab.id;
			param.templateid = view.template.id;
			param.value = '';
			param.param2 = '1';
			param.param3 = view.tab.parameters.length.toString();
			view.tab.parameters.addItem(param);
		}
		private function handleParametersChange(event:CollectionEvent):void {
			view.tab.parametersChanged = true;
			eventDispatcher.dispatchEvent(new ContentViewEvent(ContentViewEvent.TEMPLATE_MODIFIED,view.template));
		}
	}
}