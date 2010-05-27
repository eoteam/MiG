package org.mig.view.skins 
{
	import mx.skins.halo.NumericStepperUpSkin;
	
	public class StepperUpArrowSkin extends NumericStepperUpSkin
	{
		public function StepperUpArrowSkin(){}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			
			graphics.clear();
			var fillColor:uint = 0xFFFFFF;
			var x:Number = 5;
			var y:Number = 4;
			var w:Number = 8;
			var h:Number = 5;
			
			graphics.lineStyle(0,0,0);
			graphics.beginFill(fillColor,1);
			
			graphics.lineTo((w/2)+x,y);
			graphics.lineTo((w+x),(h+y));
			graphics.lineTo(x,(h+y));
			graphics.lineTo((w/2)+x,y);
			
			graphics.endFill();
			
			
		}

	}
}