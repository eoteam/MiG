package  org.mig.view.skins
{
	import mx.skins.halo.SliderThumbSkin;
	
	public class migSliderThumbSkin extends SliderThumbSkin
	{
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			var newW:Number = w-7;
			var newH:Number = h;
			var backgroundColor:Number = 0xffffff;	
			graphics.clear();
			graphics.lineStyle(0,0,0);
			graphics.beginFill(backgroundColor,1);
			graphics.drawRect(6,-1.5,18,6);
			graphics.endFill();
			
		}

	}
}