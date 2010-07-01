package org.mig.view.controls
{
	import spark.components.ToggleButton;
	
	public class IconToggleButton extends ToggleButton
	{
			 public var icon1:Class;
		[Bindable] public var icon2:Class;
		
		public function IconToggleButton()
		{
			super();
			if(icon2 == null)
				icon2 = icon1;
		}
	}
}