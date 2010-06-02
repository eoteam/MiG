package org.mig.view.controls
{
	import spark.components.CheckBox;
	
	public class DataCheckBox extends CheckBox
	{
		[Bindable] public var data:*;
		public function DataCheckBox()
		{
			super();
		}
	}
}