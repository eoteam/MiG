package org.mig.view.mediators.content
{
	import flash.display.DisplayObject;
	
	import mx.core.UIComponent;
	
	import org.mig.utils.ClassUtils;
	import org.mig.view.components.content.ContentView;
	import org.mig.view.interfaces.IEditableContentView;
	import org.robotlegs.mvcs.Mediator;
	
	public class ContentViewMediator extends Mediator
	{
		[Inject]
		public var view:ContentView;
		
		private var generalEditor:IEditableContentView;
		
		override public function onRegister():void {
			
			var containers:XMLList = view.content.config.tab;
			generalEditor = IEditableContentView(ClassUtils.instantiateClass(view.content.config.@generalEditorView));
			generalEditor.content = view.content;
			view.contentTabs.addChildAt(generalEditor as UIComponent,0);
			/*for each (var container:XML in containers)
			{
				var contentTabItem:ContentTabItem = new ContentTabItem();
				var newData:Object = new Object();
				var queryVars:Array = String(container.@vars).split(",");
				
				for each(var queryVar:String in queryVars)
				{
					if(queryVar == "contentid" || queryVar == "parentid")
						newData[queryVar] = view.content.data.id.toString();
					else
						newData[queryVar] = view.content.data[queryVar].toString();
				}
				var data:XML = <result></result>;
				data.appendChild(XML("<id>"+view.content.data.id.toString() + "</id>"));
				contentTabItem.content = new SubContainerNode(container.@name, container, data, view.content, newData,view.content.privileges,true);
				contentTabItem.percentHeight = 100;
				contentTabItem.percentWidth = 100;
				contentTabItem.y = 0;
				contentTabItem.styleName = "contentTabItem";
				contentTabs.addChild(contentTabItem);
			}	*/
		}
	}
}