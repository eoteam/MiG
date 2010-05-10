package org.mig.view.mediators.content
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	import org.mig.model.vo.content.ContentStatus;
	import org.mig.model.vo.content.ContentData;
	import org.mig.model.vo.content.SubContainerNode;
	import org.mig.utils.ClassUtils;
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

				var newData:Object = new Object();
				var queryVars:Array = String(container.@vars).split(",");
				
				for each(var queryVar:String in queryVars)
				{
					if(queryVar == "contentid" || queryVar == "parentid")
						newData[queryVar] = view.content.data.id.toString();
					else
						newData[queryVar] = view.content.data[queryVar].toString();
				}
				var data:ContentData = new ContentData();
				data.id = view.content.data.id;
				
				var subNode:SubContainerNode = new SubContainerNode(container.@name, container, data, view.content,view.content.privileges,queryVars);
				var tabView:IEditableContentView = IEditableContentView(ClassUtils.instantiateClass(subNode.config.@contentView));
				tabView.content = subNode;
				UIComponent(tabView).percentHeight = 100;
				UIComponent(tabView).percentWidth = 100;
				UIComponent(tabView).y = 0;
				UIComponent(tabView).styleName = "contentTabItem";
				view.contentTabs.addChild(UIComponent(tabView));
				editableViewsList.push(tabView);
				
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