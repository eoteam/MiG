/*This class is the base class, and maybe should be abstract.
The tasks it performs
1- refreshData/refresh
Given the config, it loads all of its children nodes
2- updateData/update: updates the data for this node
2a- load with more verbosity
3- removeData/remove: removes its data and removes itself from itself parent children list
4- attaching subcontainer
5- batch update all children
*/
package org.mig.model.vo
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	[Bindable]
	public class ContentNode
	{
		public static const NOT_LOADED:int = 0;
		public static const LOADING:int = 1;
		public static const LOADED:int  = 2;
		
			
		public var children:ArrayCollection;
		public var parentNode:ContentNode;
		public var subContainers:Dictionary;
		public var data:BaseContentData;
		public var privileges:int;		
		
		public var state:int;
		public var hasChildren:Boolean = false;
		
		protected var _config:XML;
		protected var _baseLabel:String;
		
		public function ContentNode(baseLabel:String, config:XML, data:BaseContentData, parentNode:ContentNode,privileges:int) {
			this.parentNode = parentNode;	
			this.baseLabel = baseLabel.replace(/<.*?>/g, "");
			this.baseLabel = baseLabel.replace(/]]>/g, "");
			this.data = data;
			this.privileges = privileges;
			this._config = config;
			this.state = 0;
			this.hasChildren =  data.count > 0 ? true :  false;
			children = new ArrayCollection();
			subContainers = new Dictionary();
			children.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleCollection);								
		}		
	
		public function handleCollection(event:CollectionEvent):void {
			if(event.kind == CollectionEventKind.ADD) {
				for each(var node:ContentNode in event.items) {
					node.parentNode = this;
				}
			}	
		}	
		public function get config():XML {
			return _config;
		}		
		public function get label():String {
			if(data.count > 0)
				return _baseLabel + " (" + data.count + ")";
			else
				return _baseLabel;	
		}
		public function get debugLabel():String {
			if(data.count > 0)
				return  "id=" + data.id + " " + _baseLabel + " (" + data.count + ")";
			else
				return "id=" + data.id + " " + _baseLabel;			
		}	
		public function get baseLabel():String {
			return _baseLabel;
		}
		public function toString():String {
			return label;
		}	
		public function set baseLabel(value:String):void {
			_baseLabel = value;
			if(data)
				data[_config.@labelField] = value;
		}	
		//removes a child node from the children list
		/*		public function removeNode(node:ContentNode):void {
		var fc:Function
		if(children.filterFunction != null)
		{
		children.filterFunction = null;
		children.refresh();
		}
		var nodeIndex:int = this.children.getItemIndex(node);
		this.children.removeItemAt(nodeIndex);
		if(fc != null)
		{
		children.filterFunction = fc;
		children.refresh();
		}
		//dispatchEvent(new ContentNodeEvent(ContentNodeEvent.NODE_DELETED,node));
		//updateLabel();  	
		}	*/	
		
		
		
		/*public function addNode(node:ContentNode,index:int=-1,update:Boolean=true,swap:Boolean=false):void {
		var fc:Function;
		if(!children)
		children = new ArrayCollection();
		else if(children.filterFunction != null)
		{
		children.filterFunction = null;
		children.refresh();
		}	
		if(index == -1)
		this.children.addItemAt(node,0);
		else if(swap)
		this.children.setItemAt(node,index);
		else
		this.children.addItemAt(node,index);
		if(fc != null)
		{
		children.filterFunction = fc;
		children.refresh();
		}			
		//dispatchEvent(new ContentNodeEvent(ContentNodeEvent.NODE_ADDED,node));
		//updateLabel();
		//			if(update)
		u//pdateChildrenOrder();
		}	*/		
		
		
		
		// base label to use when constructing a label
		
		/*protected function remove():void {
		//var newData:Object = XMLUtils.xmlToDataObject(data);
		trace("DELETE CONTENT: " + config.@deleteContent);
		if (config.@deleteContent.length() > 0)
		{
		// create a new xml http operation			
		// get the parameters out of the config xml
		var params:Object = new Object();
		params.action = _config.@deleteContent.toString();
		params.tablename = _config.@tablename.toString();
		params.id = data.id.toString();			
		if(_config.@deleteContent == "updateRecord") //soft delete
		{
		params.deleted = 1;		
		var modDate:Date = new Date();
		params.modifieddate = modDate.time;
		params.modifiedby = Application.application.user.id;					
		}	
		operation = new XMLOperation();
		operation.execute(this,Constants.EXECUTE,params);
		}
		//for each(var node:ContentNode in this.children)
		//{
		//node.removeData();	
		//}
		}*/
		
		
		
		/*public function updateBaseLabel(baseLabel:String):void {
		_baseLabel = baseLabel.replace(/<.*?>/g, "");
		updateLabel();
		}
		private function handleRemoveComplete(event:Event):void
		{
		var _data:XMLList = event.target.xml.children();
		if(_data != null)
		{
		if(_data.errorName != null && _data.errorName != "" && _data.errorName != undefined)
		{
		Alert.show(("Server-side Error:<br></br>Error:" + _data.errorName + "   Error Msg: " + _data.errorMsg));
		}else if(_data.success == "true")
		{
		Application.application.mainView.statusMod.updateStatus("Update Successful.");
		this.parentNode.removeNode(this);  
		dispatchEvent(new ContentNodeEvent(ContentNodeEvent.NODE_DELETED,this));
		}
		else
		{
		Alert.show("Error Connecting To The Database. Try Again Later.");
		}
		}
		}*/
	}
}