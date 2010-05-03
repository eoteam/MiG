package  org.mig.view.skins
{
	import mx.skins.halo.NumericStepperDownSkin;
	
	public class StepperDownArrowSkin extends NumericStepperDownSkin
	{
		public function StepperDownArrowSkin(){}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			
			graphics.clear();
			var fillColor:uint = 0xFFFFFF;
			var x:Number = 5;
			var y:Number = 2;
			var w:Number = 8;
			var h:Number = 5;
			
			graphics.lineStyle(0,0,0);
			graphics.beginFill(fillColor,1);
			
			graphics.lineTo(x,y);
			graphics.lineTo((w+x),y);
			graphics.lineTo((w/2)+x,(h+y));
			graphics.lineTo(x,y);
			
			graphics.endFill();
			
			
		}

	}
}