package org.mig.view.controls
{
	import flash.events.Event;
	import flash.events.TextEvent;
	
	import mx.controls.TextArea;

	[Event(name="enter", type="flash.events.Event")]
	public class MultilineTextInput extends TextArea
	{
		public function MultilineTextInput()
		{
			super();
			this.addEventListener(TextEvent.TEXT_INPUT, inputHandler);
		}
		private function inputHandler(event:TextEvent):void
		{
			if(event.text.charCodeAt(0) == 10) {
		        event.preventDefault();
		        dispatchEvent(new Event("enter"));
		    }
		}

	}
}