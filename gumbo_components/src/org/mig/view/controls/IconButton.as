package org.mig.view.controls
{
	import spark.components.Button;
	
	public class IconButton extends Button
	{
		[Bindable] public var icon:Class;
		[Bindable] public var disabledIcon:Class;
		public function IconButton()
		{
			super();
		}
	}
}