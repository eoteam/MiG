package com.mapx.view.controls
{
	//import com.flextendibles.spellcheck.TextArea;
	import com.map.controller.ControllerLocator;
	import com.map.event.ApplicationEvent;
	import com.map.event.EventBus;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.TextArea;
	import mx.core.Container;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.events.ScrollEvent;
	import com.adobe.linguistics.spelling.SpellUI;
	
	public class MiGTextArea extends TextArea
	{
		public var htmlRendering:Boolean = false;
		[Bindable] public var scrollingParent:Container;
		public var delayDuration:Number = 250;
		public function MiGTextArea() 
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE,init);
		}
		private function init(event:FlexEvent):void
		{
			//SpellUI.enableSpelling(this, "usa.zwl");
			this.addEventListener(FocusEvent.FOCUS_IN,handleFocusIn);
		}		
		private function handleFocusIn(event:Event):void
		{
			dispatchFocusEvent(true);			
		}
		public function dispatchFocusEvent(state:Boolean):void
		{
			EventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.TEXTEDITOR,[this,htmlRendering,state,this.parentDocument]));		
		}
		override public function set htmlText(value:String) : void
		{
			htmlRendering = ControllerLocator.controller.htmlRendering;
			if(htmlRendering)
			{
				this.text = value;
				this.dispatchEvent(new Event(Event.CHANGE));
			}
			else
				super.htmlText = value;
		}
		override public function get htmlText() : String
		{
			if(htmlRendering)
				return this.text;
			else
				return super.htmlText;
		}
		
	}
}