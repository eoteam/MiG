package org.mig.view.controls
{
	//import com.flextendibles.spellcheck.TextArea;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	import com.adobe.linguistics.spelling.SpellUI;
	import mx.core.mx_internal;
	use namespace mx_internal;
	
	[Style(name="textSelectionColor",type="uint", format="Color", inherit="no")]
	
	[Event(name="enter", type="flash.events.Event")]	
	
	public class MiGTextInputSpell extends TextArea
	{
/* 		private function get textfield():UITextField
		{
			return UITextField(textArea.getTextField());
		} */
		public function MiGTextInputSpell()
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
			this.addEventListener(KeyboardEvent.KEY_DOWN, handleKey);
			//this.addEventListener("enter",answerListener);
		} 
		private function handleCreationComplete(event:FlexEvent):void
		{
			//SpellUI.enableSpelling(this, "usa.zwl");
			//this.height = 24;
			this.validateNow();
			//this.dictionary = "dictionary.dic";			
			SelectionColor.setFieldSelectionColor(this.textField as TextField,0xffffff);		
		}
		private function handleKey(event:KeyboardEvent):void
		{
			if(this.text!= "" && event.keyCode == 13)
				dispatchEvent(new Event("enter"));
		}	
	}
}