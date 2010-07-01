package org.mig.view.mediators.main
{
	import flash.events.MouseEvent;
	import flash.text.engine.ContentElement;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	import org.mig.events.ContentEvent;
	import org.mig.events.ViewEvent;
	import org.mig.model.AppModel;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.view.components.main.NewContentView;
	import org.robotlegs.mvcs.Mediator;
	
	public class NewContentMediator extends Mediator
	{
		[Inject]
		public var view:NewContentView;
		
		[Inject]
		public var appModel:AppModel;
		
		override public function onRegister():void {
			eventMap.mapListener(eventDispatcher, ContentEvent.SELECT,handleContentSelected,ContentEvent);
			view.cancelBtn.addEventListener(MouseEvent.CLICK,handleCancel);
			view.createBtn.addEventListener(MouseEvent.CLICK,handleCreate);
		}
		
		private function handleContentSelected(event:ContentEvent):void {
			var contentNode:ContainerNode = event.args[0] as ContainerNode;
			var dataProvider:ArrayList = new ArrayList();
			if(contentNode.config.attribute("createContent").length() > 0)
			{
				if(ContainerNode(contentNode).isNesting) {
					dataProvider.addItem(contentNode.config);
				}
				else {
					//get the non fixed containers
					var containers:XMLList  = contentNode.config.child.(@is_fixed == '0');
					for each(var container:XML  in containers) {
						dataProvider.addItem(container);
					}
				}
			}
			if(dataProvider.length > 0) {
				view.addLabel.text = "Add Container";
				eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.ENABLE_NEW_CONTENT,true,false));
				//selectedNode = col.getItemAt(0) as ContentNode;
			}
			else
				eventDispatcher.dispatchEvent(new ViewEvent(ViewEvent.ENABLE_NEW_CONTENT,false,false));
			view.dataProvider = dataProvider;
		}
		private function handleCancel(event:MouseEvent):void {
			view.visible = false;
		}
		private function handleCreate(event:MouseEvent):void {
			if(view.valid) {
				eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.CREATE,view.titleInput.text,view.optionsList.selectedItem));
			}
		}
	}
}