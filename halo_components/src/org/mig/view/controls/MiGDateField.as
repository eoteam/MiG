package org.mig.view.controls
{
	import flash.events.Event;
	import flash.text.TextField;
	
	import mx.controls.DateField;
	import mx.events.FlexEvent;
	import mx.core.mx_internal;
	use namespace mx_internal;
	public class MiGDateField extends DateField
	{
		[Bindable] public var inputStyleName:String = "inputFieldBlack";
		public function MiGDateField()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
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
			textInput.styleName = inputStyleName;
			SelectionColor.setFieldSelectionColor(this.textInput.mx_internal::getTextField() as TextField,0xffffff);
		}

	}
}