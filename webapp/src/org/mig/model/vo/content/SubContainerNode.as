package org.mig.model.vo.content
{

	import org.mig.model.vo.content.ContentData;
	import org.mig.model.vo.ContentNode;

	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CollectionEvent;
	
	public class SubContainerNode extends ContentNode
	{
		public var queryVars:Object;
		public function SubContainerNode(baseLabel:String, config:XML, data:ContentData, parentContent:ContentNode,privileges:int,queryVars:Object) {
			this.queryVars = queryVars;
			super(baseLabel, config, data, parentContent,privileges);
		}
		override public function get label():String {
			if(children != null && children.length > 0)
				return _baseLabel + " (" + children.source.length + ")";
			else
				return _baseLabel + " (0)";	
		}
/*		override protected function retrieve():void {
			if(queryVars != null) {
				var params:Object = new Object();
				params.action = _config.@getContent.toString();
				if(_config.attribute("tablename").length() > 0) 
					params.tablename = _config.@tablename.toString();
				if(_config.attribute("verbosity").length() > 0) 	
					params.verbosity = _config.@verbosity.toString();
				if(_config.attribute("orderby").length() > 0) 
					params.orderby = _config.@orderby.toString();
				if(_config.attribute("orderdirection").length() > 0)
					params.orderdirection = _config.@orderdirection.toString();					
				if(_config.attribute("include_children").length() > 0)
					params.include_children = 1;
				if(_config.attribute("children_depth").length() > 0)
					params.children_depth = _config.@children_depth.toString();	
				if(_config.attribute("deleted").length() > 0)
					params.deleted = _config.@deleted.toString();							
				for (var item:String in queryVars) {
					if(queryVars[item] == "")
						params[item] = 0;
					else
						params[item] = queryVars[item];
				}
				var retrieve:RetrieveContentCommand = new RetrieveContentCommand(this,params,ContentData,handleChildren);
				retrieve.execute();
			}
			else
				;//this.dispatchEvent(new ContentNodeEvent(ContentNodeEvent.READY,this,true));	
		}
		override protected function load():void {
			trace("Nothing to do here");
		}
		override protected function remove(args:Array=null):void {
			throw new IllegalOperationError("Removing subcontainer is not allowed");
		}
		override protected function update(value:UpdateData):void {
			throw new IllegalOperationError("Updating subcontainer is not allowed");
		}
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