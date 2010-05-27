package org.mig.view.controls
{
	import flash.events.Event;
	import flash.text.TextField;
	
	import mx.controls.NumericStepper;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	use namespace mx_internal;
	public class MiGNumericStepper extends NumericStepper
	{
		[Bindable] public var textInputStyleName:String = "inputFieldBlack";
		public function MiGNumericStepper()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
			this.addEventListener(Event.CHANGE,handleChange);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			this.graphics.clear();
			this.graphics.beginFill(0,1);
			this.graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
			this.graphics.endFill();	
		}
		private function handleCreationComplete(event:Event):void
		{
			this.mx_internal::inputField.styleName = textInputStyleName;
			SelectionColor.setFieldSelectionColor(this.inputField.mx_internal::getTextField() as TextField,0xffffff);
		}
		private function handleChange(e:Event):void
		{
			if (inputField.text.length == 1) 
				inputField.text = '0' + inputField.text;

		}
		override public function set value(value:Number):void
		{
			super.value = value;
			if(value.toString().length == 1 && inputField)
				inputField.text = '0' + value.toString();
		}
	}
}