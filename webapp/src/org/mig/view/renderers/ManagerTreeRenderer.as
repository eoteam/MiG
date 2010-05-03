package org.mig.view.renderers
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Canvas;
	import mx.controls.treeClasses.TreeItemRenderer;

	public class ManagerTreeRenderer extends TreeItemRenderer
	{
		[Bindable]
		private var _bgColor:uint = 0x999999;
		
		public function set bgColor(color:uint):void
		{
			_bgColor = color;
		}
		
		[Bindable]
		public function get bgColor():uint
		{
			return _bgColor;
		}
		
		[Bindable]
		private var _overColor:uint = 0x333333;
		
		public function set overColor(color:uint):void
		{
			_overColor = color;
		}
		
		[Bindable]
		public function get overColor():uint
		{
			return _overColor;
		}		
		public var bg:Canvas;
		public var _overBg:Canvas;
		
		public var selected:Boolean = false;
	
		public function ManagerTreeRenderer()
		{
			super ();
			addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
		}
		
		 override public function set data(value:Object):void
		 {
            super.data = value;
            if (super.listData)
            {
           		super.label.gridFitType = "pixel";
		    	super.label.antiAliasType = "advanced";
		    	
				if (getChildAt(0).name=="bg")
				{
					removeChildAt(0);
					
					this.removeChild(_overBg);
				}
				
           		
       			bg = new Canvas();
       			bg.styleName = "treeManagerItem";
       			//bg.setStyle("backgroundColor", bgColor);
       			BindingUtils.bindProperty(bg, "width", this, "width");
       			BindingUtils.bindProperty(bg, "height", this, "height");
       			bg.name = "bg";
       			addChildAt(bg, 0);
       			
       			_overBg = new Canvas();
       			_overBg.alpha = 0;
       			_overBg.styleName = "treeOverItem";
           		BindingUtils.bindProperty(_overBg, "width", this, "width");
       			BindingUtils.bindProperty(_overBg, "height", this, "height");
       			_overBg.name = "overBg";
       			addChildAt(_overBg, 1);
	            //TreeListData(super.listData).hasChildren
	            //TreeListData(super.listData).owner
	            //super.data.itemIcons
	            //super.label.text
            }
        }
        
        public function selectedColorOff():void
        {
        	selected = false;
        	//TweenMax.to(bg, {_color:bgColor, time:1, transition:"easeOutExpo"});
        	TweenMax.to(_overBg, 1, {alpha:0,ease:Expo.easeOut});
        	addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
        }
        
        public function selectedColorOn(color:uint):void
        {
        	removeEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
        	selected = true;
        	//TweenMax.to(bg, {_color:color, time:1, transition:"easeOutExpo"});
        	TweenMax.to(_overBg, 1, {alpha:0,ease:Expo.easeOut});
        }
        
        private function handleMouseOver(event:MouseEvent):void 
        {
        	//hide default over bg		
			this.parent.getChildAt(1).visible = false;
       		//TweenMax.to(bg, {_color:overColor, time:1, transition:"easeOutExpo"});
       		TweenMax.to(_overBg, 1, {alpha:1, ease:Expo.easeOut});
       		addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
    	}
    	
		private function handleMouseOut(event:MouseEvent):void {
			if(!selected)
			{
	       		//TweenMax.to(bg, {_color:bgColor, time:1, transition:"easeOutExpo"});
	       		TweenMax.to(_overBg, 1, {alpha:0,ease:Expo.easeOut});
	       		removeEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
	  		}
    	}
    	
    	//enable - disable items
           override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
           super.updateDisplayList(unscaledWidth, unscaledHeight);
           if((typeof(data) == "xml" && data.@enabled == "false")){
                this.mouseChildren = false;
                this.enabled = false;
                this.removeEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
                //this.alpha = 0.2;
           }
           else
           {
               	this.mouseChildren = true;
               	this.enabled = true;
                this.alpha = 1;
           }
        }
	
	}
}