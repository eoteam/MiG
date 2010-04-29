//========================================================================================
//  $File: //a3t/argon/branches/v1/1.0/dev/sdk/samples/flex/textLayout_ui/src/bxf/ui/controls/BxPopupMenu.as $
//  $DateTime: 2009/12/22 14:38:02 $
//  $Revision: #1 $
//  $Change: 733743 $
//  
//  ADOBE CONFIDENTIAL
//  
//  Copyright 2007-08 Adobe Systems Incorporated. All rights reserved.
//  
//  NOTICE:  All information contained herein is, and remains
//  the property of Adobe Systems Incorporated and its suppliers,
//  if any.  The intellectual and technical concepts contained
//  herein are proprietary to Adobe Systems Incorporated and its
//  suppliers and may be covered by U.S. and Foreign Patents,
//  patents in process, and are protected by trade secret or copyright law.
//  Dissemination of this information or reproduction of this material
//  is strictly forbidden unless prior written permission is obtained
//  from Adobe Systems Incorporated.
//  
//========================================================================================
package bxf.ui.controls
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.controls.Menu;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.Application;
	import mx.events.MenuEvent;
	import mx.events.ResizeEvent;
	import mx.core.Application;
	/**
	 * HUDImagePopupControl is an image control with the popup menu functionality. It allows specifying 
	 * a separate control as the owner to be able to position the menu relative to that control. 
	 * */	
	public class BxPopupMenu extends Menu {
		public function BxPopupMenu(inParent:DisplayObjectContainer, inValues:Array=null, inMenuPositionOwner:DisplayObject=null):void {
			super();			
			
	    	/* Copied implementation of Menu.createMenu() */
	        this.tabEnabled = false;
	        this.owner = DisplayObjectContainer(Application.application);
	        this.showRoot = true;
	        Menu.popUpMenu(this, inParent, inValues);

			mMenuParent = inParent;
			mMenuPositionOwner = inMenuPositionOwner;

			mSelectedItem = null;

			this.rowHeight = 19;
			mNumItems = inValues ? inValues.length : 0;
			
			this.addEventListener(MenuEvent.ITEM_CLICK, onItemSelected);
			this.addEventListener(ResizeEvent.RESIZE, onResize);
		}

		override protected function initializationComplete():void {
			super.initializationComplete();
			
			if (this.getStyle("leftIconGap") != undefined)
				mLeftMargin = this.getStyle("leftIconGap");
			if (this.getStyle("rightIconGap") != undefined)
				mRightMargin = this.getStyle("rightIconGap");
		}
		
		public function set values(inArray:Array):void {
			Menu.popUpMenu(this, mMenuParent, inArray);
			mNumItems = inArray ? inArray.length : 0;
		}

		public function set menuPositionOwner(inMenuPositionOwner:DisplayObject):void {
			mMenuPositionOwner = inMenuPositionOwner;
		}
		
		/** Set to one of the MENU_LOCATION_XXX constants. If not set to a valid value,
		 * defaults to MENU_LOCATION_BELOW. */
		public function set menuPosition(inPosition:String):void {
			mMenuPosition = inPosition;
		}
		
		/** If true, align the left margin of the text in the menu to the owner's left edge.
		 * If false, align the left edge of themenu itself to the owner's left edge. */
		public function set alignLeftMargin(inAlign:Boolean):void {
			mAlignLeftMarginToOwner = inAlign;
		}
				
		public function get selectedItemData():Object {
			return mSelectedItem;	
		}	

		public function get leftMargin():uint {
			return mLeftMargin;
		}

		public function get rightMargin():uint {
			return mRightMargin;
		}
		
        public function Open(inPos:Point=null):void {
        	var menuLocalPosition:Point;
        	var menuGlobalPosition:Point;
        	if (inPos)
        		menuLocalPosition = inPos;
        	else if (mMenuPositionOwner != null)
        	{
        		var left:Number = mMenuPositionOwner.x - (mAlignLeftMarginToOwner ? leftMargin : 0);

        		// Old set the specific location of the menu code, saving it until decided to strip out all associated code
         		//if (mMenuPosition == MENU_LOCATION_ABOVE)
        		//	menuLocalPosition = new Point(left, mMenuPositionOwner.y - (mNumItems * rowHeight) - 2);
        		//else	/* default is MENU_LOCATION_BELOW if no other valid value set */
        		//	menuLocalPosition = new Point(left, mMenuPositionOwner.y + mMenuPositionOwner.height);
        		menuLocalPosition = new Point(left, mMenuPositionOwner.y + mMenuPositionOwner.height);
        		
        	}
        	else
        		menuLocalPosition = new Point(0, 0);
        	
			menuGlobalPosition = mMenuParent.localToGlobal(menuLocalPosition);
 			
 			// Check if the menu location will fit in the app, if not, put it above the menu.
 			if (menuGlobalPosition.y + (mNumItems * rowHeight) + 2 > this.owner.height) {
 				menuLocalPosition = new Point(menuLocalPosition.x, mMenuPositionOwner.y - (mNumItems * rowHeight) - 2);
 				menuGlobalPosition = mMenuParent.localToGlobal(menuLocalPosition);
 				if (menuGlobalPosition.y < 0)
 				{
 					// Menu is longer than the app, let as much of it fit as is possible by placing it at y=0
 					// A better solution is to put scroll bars in the menu, but that doesn't seem to work
 					menuGlobalPosition.y = 0;
 				}
 			}
			this.show(menuGlobalPosition.x, menuGlobalPosition.y);
		}

		protected function onItemSelected(evt:MenuEvent):void {
			if (evt.index >= 0)
			{
				mSelectedItem = evt.item;
				this.dispatchEvent(new Event(SELECTION_CHANGED, true));
			}
		}
		
		protected function onResize(evt:ResizeEvent):void {
			if (evt.oldHeight != height && mMenuPosition == MENU_LOCATION_ABOVE && mMenuPositionOwner != null) {
				var menuLocalPosition:Point = new Point(0, mMenuPositionOwner.y - height);
        		var menuGlobalPosition:Point = mMenuParent.localToGlobal(menuLocalPosition);
        		y = menuGlobalPosition.y;
			}

		}

		override protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
		{
			indicator.alpha = getStyle("rollOverAlpha");
			super.drawHighlightIndicator(indicator, x, y, width, height, color, itemRenderer);
		} 

		override protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer):void
		{
			// We do not want to draw the selection indicator over the rollover indicator, it seems to draw it 
			// completely white. 
		} 


		public static const SELECTION_CHANGED:String = "selectionChanged";

		public static const MENU_LOCATION_ABOVE:String = "menuAbove";
		public static const MENU_LOCATION_BELOW:String = "menuBelow";

		private var mMenuParent:DisplayObjectContainer;
		private var mMenuPositionOwner:DisplayObject;
		private var mMenuPosition:String = MENU_LOCATION_BELOW;
		private var mAlignLeftMarginToOwner:Boolean = false;
		private var mNumItems:uint = 0;
				
		private var mSelectedItem:Object;
		
		private var mLeftMargin:uint = 5;
		private var mRightMargin:uint = 20;
		

	}
}