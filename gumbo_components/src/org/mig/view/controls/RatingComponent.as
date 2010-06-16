////////////////////////////////////////////////////////////////////////////////
//
//  Andreas Hulstkamp AH
//  Custom Component in Flex 4 beta (Gumbo).
//    Uses 4.0.0.4932 nightly built (beta)
//    A simple Rating Component 0.01
//  TODO: Optimize
//  Andy
//
////////////////////////////////////////////////////////////////////////////////
package org.mig.view.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	import mx.events.SandboxMouseEvent;
	
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.core.IGraphicElement;
	
	//import mx.graphics.graphicsClasses.GraphicElement;
	[Event(name="change", type="flash.events.Event")]
	public class RatingComponent extends SkinnableComponent //SkinnableContainer
	{
		public function RatingComponent()
		{
			super();
			init();
		}
		
		protected function init():void {
			this.buttonMode = true;
			this.addEventListener(FlexEvent.CREATION_COMPLETE, creationComplete);
		}
		
		//Layout info for graphical rating elements
		private var gap:Number = 0;
		private var ew:Number = 0;
		private var en:Number = 0;
		
		
		/**
		 * Get size and layout infos of graphical rating elements, once everything is laid out and complete. 
		 * @param event
		 * 
		 */
		private function creationComplete (event:FlexEvent):void {
			this.removeEventListener(FlexEvent.CREATION_COMPLETE, creationComplete);
			gap = activeGroup.gap;
			en = activeGroup.numElements;
			ew = activeGroup.columnWidth;
			updateMaskForRating(_rating);
		}
		
		// ---------------------------------------------------------------------------
		// The Skin states
		// ---------------------------------------------------------------------------
		
		[SkinState("disabled")]
		
		[SkinState("up")]
		
		[SkinState("over")]
		
		[SkinState("down")]
		
		private var isOver:Boolean;
		private var isDown:Boolean;
		
		override protected function getCurrentSkinState():String {
			if (!enabled) {
				return "disabled";
			} else if (isOver && isDown) {
				return "down";
			} else if (isOver) {
				return "over";
			} else return "up";
		}
		
		// ---------------------------------------------------------------------------
		// The Skin parts
		// ---------------------------------------------------------------------------
		
		[SkinPart(required="true")]
		public var activeGroup:HGroup;
		
		[SkinPart(required="true")]
		public var passiveGroup:HGroup;
		
		[SkinPart(required="true")]
		public var ratingMask:IGraphicElement;
		//		public var ratingMask:GraphicElement;
		
		[SkinPart(required="false")]
		public var hotSpot:Group;
		
		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			if (partName == "activeGroup") {
				this.addInitialEventListeners();
			}
			if (partName == "ratingMask") {
				ratingMask.width = 0;
				
			}
			if (partName == "hotSpot") {
				hitArea = hotSpot;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			if (partName == "activeGroup") {
				removeInitialEventListeners();
			}
			//Guess this would not be necessary since hotSpot in the skin gets nullified and GC can do its job
			//just to be sure
			if (partName == "hotSpot") {
				hitArea = null;
			} 
		}
		
		// ---------------------------------------------------------------------------
		// The Properties
		// ---------------------------------------------------------------------------
		private var _rating:Number = 10;
		private var ratingChanged:Boolean = false;
		
		[Bindable]
		public function set rating(value:Number):void {
			_rating = value;
			ratingChanged = true,
				invalidateProperties();
		}
		
		public function get value():Number
		{
			return _rating/2;
		}
		public function get rating():Number {
			return _rating;
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			if (ratingChanged) {
				ratingChanged = false;
				this.toolTip = String(_rating);
				this.updateMaskForRating(_rating);
			}
		}
		
		// ---------------------------------------------------------------------------
		// The Controller/Behaviour
		// ---------------------------------------------------------------------------
		
		protected function addInitialEventListeners():void {
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler, true);   
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
		}
		
		protected function removeInitialEventListeners():void {
			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
			systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, mouseEventHandler, true);   
			this.removeEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
		}
		
		protected function mouseEventHandler (event:MouseEvent):void {
			
			switch (event.type) 
			{
				case MouseEvent.MOUSE_OVER: 
					isOver = true; 
					break;
				case MouseEvent.MOUSE_OUT:     
					isOver = false; 
					break;
				case MouseEvent.MOUSE_UP: 
					this.dispatchEvent(new Event(Event.CHANGE));
					isDown = false; 
					break;
				case SandboxMouseEvent.MOUSE_UP_SOMEWHERE:     
					isDown = false; 
					break;
				case MouseEvent.MOUSE_DOWN: 
					isDown = true; updateMask(event);
					break;
				case MouseEvent.MOUSE_MOVE: 
					if (isDown) 
						updateMask(event); 
					break;
			}
			invalidateSkinState();
		}
		
		private function updateMask (event:MouseEvent):void {
			rating = Math.round(this.mouseX/this.width * 10);
			updateMaskForRating (rating);
		}
		
		private function updateMaskForRating (value:Number):void {
			ratingMask.width = value/2 * ew + int(value/2) * gap + .5;
		}
	}
}