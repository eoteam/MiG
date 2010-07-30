package com.fxcomponents.controls.fe
{
	//import flash.geom.*;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.geom.*;
	import mx.containers.DividedBox;
	import mx.containers.dividedBoxClasses.*;
	import mx.controls.Button;
	import flash.events.MouseEvent;
	import mx.containers.DividerState;
		
	import flash.events.Event;
	import mx.events.ResizeEvent;
	import mx.events.DividerEvent;
	
	import mx.core.mx_internal;
	
	import com.fxcomponents.controls.fe.ButtonClickEvent;
	
	use namespace mx_internal;
	
	[Style(name="barFillColors",type="Array",format="Color",inherit="no")]
	[Style(name="barBorderColor",type="uint",format="Color",inherit="no")]
		
	[Event(name="buttonClick", type="com.ButtonClickEvent")]
	public class ExtendedDividedBox extends DividedBox
	{
						
		//create the gradient and apply tothe box controle
		private var fillType:String = GradientType.LINEAR;
		private var alphas:Array = [1,1];
		private var ratios:Array = [0,255];
		private var spreadMethod:String = SpreadMethod.PAD;
		
		//private var _button:Button; 
		
		private var mBoxDivider:Array = new Array();
		
		private var _barFillColors:Array;	
		
		private var _barBorderColor:uint;	
				
		//[Embed(source="/assets/Arrow_Down.png")]
		private var Arrow_Down:Class;
		
		//[Embed(source="/assets/Arrow_Up.png")]
		private var Arrow_Up:Class;
				
		//[Embed(source="/assets/Arrow_Close.png")]
		private var Arrow_Close:Class;
		
		//[Embed(source="/assets/Arrow_Open.png")]
		private var Arrow_Open:Class;
						
		private var _ButtonOnIndexs:Array;
		private var _showButton:Boolean=false;
		private var _isOverButton:Boolean;
		
		public function ExtendedDividedBox():void{
			super();
		}
		
		public function set ButtonOnIndexs(value:Array):void{
			_ButtonOnIndexs=value
		}
		
		public function get ButtonOnIndexs():Array{
			return _ButtonOnIndexs;	
		}
		
		public function set showButton(value:Boolean):void{
			_showButton=value
		}
		
		public function get showButton():Boolean{
			return _showButton;	
		}
		
		public function set ButtonSelected(value:Boolean):void{
			if (_button){
				_button.selected=value;
			}
		}
		
		public function get ButtonSelected():Boolean{
			if (_button){
				return _button.selected;	
			}
			else{
				return false;
			}
		}


		/**
		 * don't allow dragging if over a button
		 * */		
		
		override mx_internal function startDividerDrag(divider:BoxDivider,trigger:MouseEvent):void{
			
			//ignore if we are over a button
			if(_showButton && _isOverButton){
				return;			
			}
	
			super.mx_internal::startDividerDrag(divider,trigger);
			
        }
        
        /**
		 * don't show splitter cursor when over a button
		 * */	
        override mx_internal function changeCursor(divider:BoxDivider):void{
			
			//ignore if we are over a button
			if(_showButton && _isOverButton){
				return;			
			}
			
			super.mx_internal::changeCursor(divider);
			
		}
		
		private function verifyButtonIndex(value:int):Boolean{
			
			for(var i:int=0;i < _ButtonOnIndexs.length;i++) {
				if (value == _ButtonOnIndexs[i]){
					return true;
				}
			}
			
			return false;
			
		}		
		
		private var _button:Button;
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			
			if (mBoxDivider.length == 0){
				
				for(var i:int=0;i < numDividers;i++) {
					var divbar:BoxDivider = getDividerAt(i);
					divbar.addEventListener("resize",handleResize);
					mBoxDivider.push(divbar);
					
					//see if the current index is in the array or if the array is 0 then
					//all have buttons this will allow us to have buttons only on selected
					//parts of a multi part splitter
					var _hasbutton:Boolean=true;//default true if no indexs
					if (_ButtonOnIndexs){
						if (_ButtonOnIndexs.length !=0){
							_hasbutton= verifyButtonIndex(i)
						}
					}
												
					if(_showButton && _hasbutton){
						_button = new Button();
						_button.name = "SplitterButton" + i;
						
						//set al styles and skins
						_button.width = getStyle("buttonWidth");
						_button.height= getStyle("dividerThickness");
						_button.toggle =true;
						
						_button.setStyle("cornerRadius",getStyle("cornerRadius"));
						
						_button.setStyle("downSkin",getStyle("downSkin"));
						_button.setStyle("overSkin",getStyle("overSkin"));
						_button.setStyle("upSkin",getStyle("upSkin"));
						
						//no divider skin just the button
						divbar.setStyle("dividerSkin",null);
												
						if (direction == "vertical"){
							_button.width = getStyle("buttonWidth");
							_button.height= getStyle("dividerThickness")+1;
							_button.x = (unscaledWidth/2) - (_button.width/2);
							
							_button.setStyle("icon",Arrow_Down);
							_button.setStyle("selectedOverIcon",Arrow_Up);
							_button.setStyle("selectedUpIcon",Arrow_Up);
							_button.setStyle("selectedDownIcon",Arrow_Up);

							_button.setStyle("selectedDownSkin",getStyle("selectedDownSkin"));
							_button.setStyle("selectedOverSkin",getStyle("selectedOverSkin"));
							_button.setStyle("selectedUpSkin",getStyle("selectedUpSkin"));
							
							
						}
						else{
							_button.height = getStyle("buttonWidth");
							_button.width= getStyle("dividerThickness")+1;
							_button.y = (unscaledHeight/2) - (_button.height/2);
							
							_button.setStyle("icon",Arrow_Close);
							_button.setStyle("selectedOverIcon",Arrow_Open);
							_button.setStyle("selectedUpIcon",Arrow_Open);
							_button.setStyle("selectedDownIcon",Arrow_Open);

							_button.setStyle("selectedDownSkin",getStyle("selectedDownSkin"));
							_button.setStyle("selectedOverSkin",getStyle("selectedOverSkin"));
							_button.setStyle("selectedUpSkin",getStyle("selectedUpSkin"));


						}
						
						//add events to change the mouse pointer 
						//and handle the click (open or close children)
						_button.addEventListener(MouseEvent.CLICK, handleClick);
						_button.addEventListener(MouseEvent.MOUSE_OVER, handleOver);
						_button.addEventListener(MouseEvent.MOUSE_OUT, handleOut);
						
						divbar.addChild(_button);
						
					}
					
				}
				
			}
			
			Draw_Gradient_Fill();
			
		}
		
		private function handleResize(event:ResizeEvent):void{
			
			if(!_showButton){return;}
			
			if (event.currentTarget.width != event.oldWidth || event.currentTarget.height != event.oldHeight){
			
				for(var i:int=0;i < numDividers;i++) {
					var divbar:BoxDivider = getDividerAt(i);
				
					var tempButton:Button = Button(divbar.getChildByName("SplitterButton" + i));
					
					if (tempButton){
						if (direction == "vertical"){
							tempButton.x = (unscaledWidth/2) - (tempButton.width/2);
						}
						else{
							tempButton.y = (unscaledHeight/2) - (tempButton.height/2);
						}
						
					}	
					
				}
			}
			
			
		}
				
		//event handlers for the button
		private function handleClick(event:MouseEvent):void{
			
			
			dispatchEvent(new ButtonClickEvent("buttonClick",event.currentTarget,Boolean(event.currentTarget.selected)));
			
			
		}
		
		//trap these event when around the button to make the 
		//extended slider behave as we require
		private function handleOut(event:MouseEvent):void{
			_isOverButton=false;
		}
		private function handleOver(event:MouseEvent):void{
			_isOverButton=true;
		}
		
		override public function styleChanged(styleProp:String):void {

			super.styleChanged(styleProp);

            // Check to see if style changed. 
            if (styleProp=="barFillColors" || styleProp=="barBorderColor") 
            {
            	_barBorderColor=0;
            	_barFillColors=null;
                invalidateDisplayList();
                return;
            }
            
            
        }
				
		private function Draw_Gradient_Fill():void{
			
			graphics.clear();
				
			for(var i:int=0;i < mBoxDivider.length;i++) {
					
				if (!_barFillColors){
					_barFillColors = getStyle("barFillColors");
					if (!_barFillColors){
						_barFillColors =[0xFFFFFF,0xFFFFFF]; // if no style default to orange
					}
				}
				
				if (!_barBorderColor){
					_barBorderColor = getStyle("barBorderColor");
					if (!_barBorderColor){
						_barBorderColor =0xFF0000; // if no style default to orange
					}
				}
				
				/* graphics.lineStyle(0,_barBorderColor); */
				
				var divwidth:Number = mBoxDivider[i].getStyle("dividerThickness");
				
				if (divwidth==0){divwidth=10;}
				
				var matr:Matrix = new Matrix();
				
				if (direction == "vertical"){
					matr.createGradientBox(mBoxDivider[i].width,divwidth,Math.PI/2, mBoxDivider[i].x, mBoxDivider[i].y);
					
					graphics.beginGradientFill(fillType, _barFillColors, alphas, ratios, matr,spreadMethod);
					graphics.drawRect(mBoxDivider[i].x,mBoxDivider[i].y,mBoxDivider[i].width,divwidth);
				}
				else{
					matr.createGradientBox(divwidth,mBoxDivider[i].height ,0, mBoxDivider[i].x, mBoxDivider[i].x+10);
					graphics.beginGradientFill(fillType, _barFillColors, alphas, ratios, matr,spreadMethod);
					graphics.drawRect(mBoxDivider[i].x,mBoxDivider[i].y,divwidth, mBoxDivider[i].height);
				}
				
								
			}			
		}
				
	}
}