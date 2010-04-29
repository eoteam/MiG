package org.mig.view.controls
{
	import flash.events.FocusEvent;
	import mx.events.FlexEvent;
	import mx.controls.TextInput;
	import mx.core.mx_internal;
	use namespace mx_internal;	
	import flash.text.TextField;
	[Style(name="promptColor", type="uint",format="Color",inherit="no")]
	public class PromptTextInput extends TextInput
	{
		private var __prompt:String = null;
		private var __firstTime:Boolean = true;
		public var textColor:uint = 0xffffff;
		private var _promptColor:uint;
		/**
		 * Getter for prompt
		 */
		public function get prompt():String
		{
			return __prompt;
		}
		
		/**
		 * Setter for prompt
		 */
		public function set prompt( prompt:String ):void
		{
			__prompt = prompt;
			showPrompt();
		}
		
		/**
		 * Getter for text
		 */
		[Bindable] override public function get text():String
		{
			return super.text;
		}
		
		/**
		 * Setter for text
		 */
		override public function set text( text:String ):void
		{	
			hidePrompt();
			super.text = text;			
		}
		override public function styleChanged(styleProp:String):void {
			
			super.styleChanged(styleProp);
			
			// Check to see if style changed. 
			if (styleProp=="promptColor") 
			{
				_promptColor = getStyle('promptColor');
				if(super.text == __prompt)
					setStyle('color',_promptColor);
			}
			
			
		}		
		/**
		 * Constructor
		 */
		public function PromptTextInput()
		{
			super();
			
			if (prompt != null && prompt != "")
			{
				showPrompt();
			}

			this.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			this.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,handleCreationComplete); 
		}
		private function handleCreationComplete(event:Event):void
		{
			SelectionColor.setFieldSelectionColor(this.mx_internal::getTextField() as TextField,0xffffff);
		}		
		
		private function showPrompt():void
		{
			// If promopt is set, add it to the text property and set style
			if (prompt != null && prompt != "" && text.length <= 0)
			{
				super.text = prompt;
				if(getStyle('promptColor') == undefined)
					this.setStyle("color", 0x666666);
				else
					this.setStyle("color", this.getStyle('promptColor'));
			}
		}
		
		private function hidePrompt():void 
		{
			// Remove prompt from text string and set style to default
			super.text = null;
			
			// Style
			this.setStyle("color", textColor);
		}
		
		private function onFocusIn( e:FocusEvent ):void
		{
			if(text == __prompt)
				this.hidePrompt();
			
		}
		
		private function onFocusOut( e:FocusEvent ):void
		{
			// Remove listener for keys
			
			
			// Show prompt if text is blank
			if (super.text == null || super.text == "")
			{
				showPrompt();
			}
			
			__firstTime = true;
		}
	}
}