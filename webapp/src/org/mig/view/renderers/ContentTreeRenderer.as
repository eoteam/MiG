package org.mig.view.renderers
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Canvas;
	import mx.controls.SWFLoader;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.core.UITextField;
	import mx.events.FlexEvent;
	
	
	public class ContentTreeRenderer extends TreeItemRenderer
	{		
		
		[Embed(source="/migAssets/flex_skins.swf#Tree_folderOpenIconGray")]
		[Bindable] private var openIcon:Class;
		
		[Embed(source="/migAssets/flex_skins.swf#Tree_folderClosedIconGray")]
		[Bindable] private var closedIcon:Class;
		
		[Embed(source="/migAssets/library.swf#collapsePanelIconRight")]
		[Bindable] private var zeroChild:Class;
		
		
		public var bg:Canvas;
		public var overBg:Canvas;		
		public var selected:Boolean = false;
		private var swfLoader:SWFLoader;
		
		[Bindable] private var _overAlpha:Number = 1;
		private var _isCreated:Boolean = false;
		
		public function ContentTreeRenderer()
		{
			super ();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,handleCreationComplete);
			addEventListener(MouseEvent.ROLL_OVER, handleMouseOver);
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseOver);
		}
		private function handleCreationComplete(event:Event):void
		{	
			bg = new Canvas();
			bg.styleName = "treeContainerItem";
			BindingUtils.bindProperty(bg, "width", this, "width");
			BindingUtils.bindProperty(bg, "height", this, "height");
			//BindingUtils.bindProperty(bg, "alpha", this, this._overAlpha);
			bg.name = "bg";
			addChildAt(bg, 0);
			
			overBg = new Canvas();
			overBg.alpha = 0;
			overBg.styleName = "treeOverItem";
			BindingUtils.bindProperty(overBg, "width", this, "width");
			BindingUtils.bindProperty(overBg, "height", this, "height");
			overBg.name = "overBg";
			addChildAt(overBg, 1)
			
			_isCreated = true;
			if(data)
			{
				if(data.children.length == 0 && this.disclosureIcon != null)
					this.disclosureIcon.visible = false;
				this.toolTip = this.data.label;
			}
			this.label.truncateToFit('...');
			
		}
		private function handleDataUpdated(event:Event):void
		{
			this.label.text = data.label;
			this.label.truncateToFit('...');
			this.toolTip = data.label;
		}
		override public function set data(value:Object):void
		{
			super.data = value;
			if (super.listData && label != null)
			{
				super.label.gridFitType = "pixel";
				super.label.antiAliasType = "advanced";  
				this.label.truncateToFit('...');
			}
			if(data!= null)
			{
				this.toolTip = this.data.label;
				if(data.data != null)
				{
					if(typeof(data.data)  == "xml" && data.data.statusid == "1")
					{
						if(bg)bg.alpha = 0.65;
						_overAlpha = 0.65;
					}
					else
					{
						if(bg)bg.alpha = 1;
						_overAlpha = 1;					
					}     
				}
				if(data.children.length == 0 && this.disclosureIcon != null)
					this.disclosureIcon.visible = false;
				
				if(_isCreated==true)
				{
					this.label.truncateToFit('...');
					if(UITextField(this.getChildAt(2)).text.slice(0,10) != "Containers" )
					{
						this.getChildAt(4).visible = false;
						this.getChildAt(2).x = this.getChildAt(2).x-22;
					}
				}         
			}
		}
		public function selectedColorOff():void
		{
			selected = false;
			TweenMax.to(overBg,1, {alpha:0,ease:Expo.easeOut});
			TweenMax.to(this.getChildAt(3),1, {tint:null,  ease:Expo.easeOut});
			addEventListener(MouseEvent.ROLL_OVER, handleMouseOver);
		}
		public function setColorHalfOn():void
		{
			TweenMax.to(overBg,1, {alpha:0.5,  ease:Expo.easeOut});
			TweenMax.to(this.getChildAt(3),1, {tint:0xBD1E53,  ease:Expo.easeOut});
			removeEventListener(MouseEvent.ROLL_OVER, handleMouseOver);
			removeEventListener(MouseEvent.ROLL_OUT, handleMouseOut);
		}		
		public function setColorHalfOff():void
		{
			TweenMax.to(overBg,1, {alpha:0, ease:Expo.easeOut});
			TweenMax.to(this.getChildAt(3),1, {tint:null,  ease:Expo.easeOut});
			addEventListener(MouseEvent.ROLL_OVER, handleMouseOver);
		}				
		
		public function selectedColorOn():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, handleMouseOver);
			selected = true;
			TweenMax.to(overBg,1, {alpha:_overAlpha, ease:Expo.easeOut});
			TweenMax.to(this.getChildAt(3),1, {tint:0xFFFFFF,  ease:Expo.easeOut});
		}
		
		private function handleMouseOver(event:MouseEvent):void 
		{	
/*			if(this.parent.parent is ContentTree)
			{
				if(ContentTree(this.parent.parent).linkingMode)
				{
					this.owner.selectedItem = this.data;
					ContentTree(this.parent.parent).validateNow();
					ContentTree(this.parent.parent).expandItem(this.data,true,true);
				}
			}*/
			TweenMax.to(overBg,1, {alpha:_overAlpha,  ease:Expo.easeOut});
			TweenMax.to(this.getChildAt(3),1, {tint:null,  ease:Expo.easeOut});      		
			addEventListener(MouseEvent.ROLL_OUT, handleMouseOut);
		}
		
		private function handleMouseOut(event:MouseEvent):void 
		{
			if(!selected)
			{
				TweenMax.to(overBg, 1,{alpha:0,  ease:Expo.easeOut});
				TweenMax.to(this.getChildAt(3),1, {tint:null,  ease:Expo.easeOut});
				removeEventListener(MouseEvent.ROLL_OUT, handleMouseOut);
			}
		}
		public function toggle(state:Boolean):void
		{
			var bgAlpha:int = state ? 1:0;
			bg.visible = state;
			overBg.visible = state;
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(data!= null)
			{
				if(data.data != null)
				{
					if(typeof(data.data)  == "xml" && data.data.statusid == "1")
					{
						if(bg)bg.alpha = 0.65;
						_overAlpha = 0.65;
					}
					else
					{
						if(bg)bg.alpha = 1;
						_overAlpha = 1;	
					}
				}
				if(_isCreated==true)
				{
					this.label.truncateToFit('...');
					if(UITextField(this.getChildAt(2)).text.slice(0,10) != "Containers" )
					{
						this.getChildAt(4).visible = false;
						this.getChildAt(2).x = this.getChildAt(2).x-22;
					}
				}
				if(data.children.length == 0 && this.disclosureIcon != null)
					this.disclosureIcon.visible = false;
				
			}
		}     	
	}
}