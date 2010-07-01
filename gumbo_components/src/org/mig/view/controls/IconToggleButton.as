package org.mig.view.controls
{
	import spark.components.ToggleButton;
	
	public class IconToggleButton extends ToggleButton
	{
		[Bindable]public var icon1:Class;
		[Bindable] public var icon2:Class;
		[Bindable] public var disabledIcon:Class;
		
		public function IconToggleButton()
		{
			super();
			if(icon2 == null)
				icon2 = icon1;
		}
	}
}