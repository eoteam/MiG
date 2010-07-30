package org.mig.view.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;
	import mx.controls.List;
	import mx.events.FlexEvent;
	import mx.events.FlexMouseEvent;
	import mx.events.SandboxMouseEvent;
	
	import org.mig.view.events.UIEvent;
	import org.mig.view.skins.buttons.ActionButtonSkin;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.List;
	import spark.components.PopUpAnchor;
	
	[Event (name="select", type="org.mig.view.events.UIEvent")]
	
	public class ActionButton extends Button
	{
		[SkinPart(required="true",type="spark.components.Group")]
		public var dropDown:Group;

		[SkinPart(required="true",type="spark.components.PopUpAnchor")]
		public var popUp:PopUpAnchor;
		
		[SkinPart(required="true",type="spark.components.List")]
		public var list:spark.components.List;
		
		public var maxRows:Number = 6;
		public var minChars:Number = 1;
		public var prefixOnly:Boolean = true;
		public var requireSelection:Boolean = false;
		
		private var _selectedItem:Object;
		private var _selectedIndex : int = -1;	
		private var _labelField : String;
		private var _labelFunction:Function;
		private var collection:ListCollectionView = new ArrayCollection();
		
		public function ActionButton()
		{
			super();
			//this.setStyle("skinClass", Class(ActionButtonSkin));
			this.addEventListener(MouseEvent.CLICK,toggleList);
		}
		
		override protected function partAdded(partName:String, instance:Object) : void{
			super.partAdded(partName, instance)
			
			if (instance==list){
				list.dataProvider = collection;
				list.labelField = labelField;
				list.labelFunction = labelFunction
				list.addEventListener(FlexEvent.CREATION_COMPLETE, addClickListener);
				list.focusEnabled = false;
				list.requireSelection = requireSelection
			}
			if (instance==dropDown){
				dropDown.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, mouseOutsideHandler);	
				dropDown.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE, mouseOutsideHandler);				
				dropDown.addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, mouseOutsideHandler);
				dropDown.addEventListener(SandboxMouseEvent.MOUSE_WHEEL_SOMEWHERE, mouseOutsideHandler); 
			}
		}
		
		public function set labelField(field:String) : void	{
			_labelField = field; 
			if (list) list.labelField = field 
		}
		public function get labelField():String {
			return _labelField;
		}
		
		public function set labelFunction(func:Function) : void	{
			_labelFunction = func; 
			if (list) list.labelFunction = func 
		}
		public function get labelFunction() : Function	{ 
			return _labelFunction;
		}
		
				
		public function set dataProvider(value:Object):void{
			if (value is Array)
				collection = new ArrayCollection(value as Array);
			else if (value is ListCollectionView){
				collection = value as ListCollectionView;
				///collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChange)
			}	
			if (list) list.dataProvider = collection;
		}
		public function get dataProvider():Object {
			return collection;
		}		
				
		public function get selectedItem() : Object	{ 
			return _selectedItem;
		}
		
		public function set selectedItem(item:Object):void {
			_selectedItem = item;
		}

		public function get selectedIndex() : int { 
			return _selectedIndex;
		}
		
		private function mouseOutsideHandler(event:Event):void {
			if (event is FlexMouseEvent){
				var e:FlexMouseEvent = event as FlexMouseEvent;
				if (this.hitTestPoint(e.stageX, e.stageY)) return;
			}
			
			close(event);
		}
		
		private function addClickListener(event:Event):void {
			list.dataGroup.addEventListener(MouseEvent.CLICK, listItemClick);
		}
		private function listItemClick(event: MouseEvent) : void
		{
			acceptCompletion();
			event.stopPropagation();
		}
		private function acceptCompletion() : void
		{
			if (list.selectedIndex >= 0 && collection.length>0)
			{
				
				_selectedIndex = list.selectedIndex
				_selectedItem = collection.getItemAt(_selectedIndex)
				
				var e:UIEvent = new UIEvent("select",_selectedItem);
				dispatchEvent(e)
				
			}
			else {
				_selectedIndex = list.selectedIndex = -1
				_selectedItem = null
			}
			
			popUp.displayPopUp = false
			
		} 
		private function toggleList(event:MouseEvent):void {
			popUp.displayPopUp = !popUp.displayPopUp;
		}
		private function close(event:Event):void {
			popUp.displayPopUp = false;
		}		
	}
}