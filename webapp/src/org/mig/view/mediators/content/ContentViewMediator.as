package org.mig.view.mediators.content
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.events.IndexChangedEvent;
	
	import org.mig.events.ContentEvent;
	import org.mig.model.vo.content.ContainerData;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.ContentStatus;
	import org.mig.model.vo.content.ContentTab;
	import org.mig.model.vo.content.SubContainerNode;
	import org.mig.utils.ClassUtils;
	import org.mig.view.components.content.ContentTabItem;
	import org.mig.view.components.content.ContentView;
	import org.mig.view.interfaces.IEditableContentView;
	import org.robotlegs.mvcs.Mediator;
	
	public class ContentViewMediator extends Mediator
	{
		[Inject]
		public var view:ContentView;
		
		private var generalEditor:IEditableContentView;
		
		private var editableViewsList:Array;
		//this will store a list of views that implement IEditable and this mediator will call the submit function on each view, which will 
		//trigger the corresponding  behavior in each view's mediator
		override public function onRegister():void {

			editableViewsList = [];
/*			generalEditor = IEditableContentView(ClassUtils.instantiateClass(ContainerNode(view.content).template.generalview));
			generalEditor.content = view.content;
			view.contentTabs.addChildAt(generalEditor as UIComponent,0);
			editableViewsList.push(generalEditor);*/
			for each (var container:ContentTab in ContainerNode(view.content).template.contentTabs.source) {

				var queryVars:Object = new Object();
				var vars:Array = container.vars.split(",");
				
				for each(var queryVar:String in vars)
				{
					if(queryVar == "contentid" || queryVar == "parentid")
						queryVars[queryVar] = view.content.data.id.toString();
					else
						queryVars[queryVar] = view.content.data[queryVar].toString();
				}
				var data:ContainerData = new ContainerData();
				data.id = view.content.data.id;
				
				var subNode:SubContainerNode;
				if(!view.content.subContainers[container.name]) {
					subNode = new SubContainerNode(container.name, container, data, view.content,view.content.privileges,queryVars);
					view.content.subContainers[container.name] = subNode;
					eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.RETRIEVE_CHILDREN,subNode));
				}
				else
					subNode = view.content.subContainers[container.name];
				var tabItem:ContentTabItem = new ContentTabItem();
				view.contentTabs.addChild(tabItem);
				tabItem.content = subNode;
				tabItem.percentHeight = 100;
				tabItem.percentWidth = 100;
				tabItem.y = 0;
				tabItem.styleName = "contentTabItem";
				editableViewsList.push(tabItem);
			}
			view.draftBtn.addEventListener(MouseEvent.CLICK,handleDraft);
			view.publishBtn.addEventListener(MouseEvent.CLICK,handlePublish);
			view.contentTabs.addEventListener(Event.CHANGE,handleTabChange);
		}
		private function handleTabChange(event:IndexChangedEvent):void {
			if(event.newIndex > 0 ) {
				var selectedTabItem:ContentTabItem = view.contentTabs.getChildAt(event.newIndex) as ContentTabItem;	
				selectedTabItem.configure();
			}
		}
		private function handleDraft(event:MouseEvent):void {
			submit(ContentStatus.DRAFT);
		}
		private function handlePublish(event:MouseEvent):void {
			submit(ContentStatus.PUBLISHED);
		}
		private function submit(statusid:int):void {
			for each(var view:IEditableContentView in this.editableViewsList) {
				view.submit(statusid);
			}
		}
	}
}