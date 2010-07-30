package org.mig.view.controls
{
	import flash.text.TextField;
	
	import mx.controls.TextInput;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	use namespace mx_internal;
	
	[Style(name="textSelectionColor",type="uint", format="Color", inherit="no")]
	
	public class MiGTextInput extends TextInput
	{
		public function MiGTextInput()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
		} 
		private function handleCreationComplete(event:FlexEvent):void
		{
			this.height = 24;
			this.validateNow();
			this.setStyle("color", this.getStyle("color"));
			SelectionColor.setFieldSelectionColor(this.textField as TextField,0xffffff);		
		}	
		
				
	}
}