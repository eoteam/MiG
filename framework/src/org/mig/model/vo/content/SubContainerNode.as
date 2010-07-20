package org.mig.model.vo.content
{

	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CollectionEvent;
	
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.content.ContainerData;
	
	[Bindable]
	public class SubContainerNode extends ContentNode
	{
		public var queryVars:Object;
		public var tab:ContentTab;
		
		public function SubContainerNode(baseLabel:String, tab:ContentTab, data:ContainerData, parentContent:ContentNode,privileges:int,queryVars:Object) {
			super(baseLabel, data, parentContent,privileges);
			this.queryVars = queryVars;
			this.tab = tab;
		}
		override public function get label():String {
			if(children != null && children.length > 0)
				return _baseLabel + " (" + children.source.length + ")";
			else
				return _baseLabel + " (0)";	
		}
		override public function set label(value:String):void {
			
		}
/*		

		private function handleChildren(results:Array):void {
			
			ContentData(data).loaded = true;
			for each (var item:ContentData in results)
			{
				var resultLabel:String = item[_config.@labelField];				
				resultLabel = resultLabel.replace(/<.*?>/g, "");
				resultLabel = resultLabel.replace(/]]>/g, "");
				var node:ContainerNode = new ContainerNode(resultLabel, _config.object[0], item, this,this.privileges,false,false,false);
				//node.addEventListener(ContentNodeEvent.READY,handleNodeReady);
				children.addItem(node);
			}
			//this.dispatchEvent(new ContentNodeEvent(ContentNodeEvent.DATA_LOADED,this));
			// update the label
		}*/	
		/*private var readyCount:int = 0;
		private function handleNodeReady(event:ContentNodeEvent):void
		{
		if(event.type == ContentNodeEvent.READY)
		{
		readyCount++;
		if(readyCount == this.children.length-1)
		{
		this.dispatchEvent(new ContentNodeEvent(ContentNodeEvent.READY,this,true));
		}
		}		
		}*/
	}
}