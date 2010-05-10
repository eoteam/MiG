package org.mig.view.mediators.content
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	import org.mig.events.ContentEvent;
	import org.mig.model.vo.content.ContentData;
	import org.mig.model.vo.content.ContentStatus;
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
			
			var containers:XMLList = view.content.config.tab;
			generalEditor = IEditableContentView(ClassUtils.instantiateClass(view.content.config.@generalEditorView));
			generalEditor.content = view.content;
			view.contentTabs.addChildAt(generalEditor as UIComponent,0);
			editableViewsList.push(generalEditor);
			for each (var container:XML in containers)
			{

				var queryVars:Object = new Object();
				var vars:Array = String(container.@vars).split(",");
				
				for each(var queryVar:String in vars)
				{
					if(queryVar == "contentid" || queryVar == "parentid")
						queryVars[queryVar] = view.content.data.id.toString();
					else
						queryVars[queryVar] = view.content.data[queryVar].toString();
				}
				var data:ContentData = new ContentData();
				data.id = view.content.data.id;
				
				var subNode:SubContainerNode = new SubContainerNode(container.@name, container, data, view.content,view.content.privileges,queryVars);
				eventDispatcher.dispatchEvent(new ContentEvent(ContentEvent.RETRIEVE_CHILDREN,subNode));
				var tabItem:ContentTabItem = new ContentTabItem();
				view.contentTabs.addChild(tabItem);
				tabItem.content = subNode;
				tabItem.percentHeight = 100;
				tabItem.percentWidth = 100;
				tabItem.y = 0;
				tabItem.styleName = "contentTabItem";
				editableViewsList.push(tabItem);
				
				view.draftBtn.addEventListener(MouseEvent.CLICK,handleDraft);
				view.publishBtn.addEventListener(MouseEvent.CLICK,handlePublish)
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