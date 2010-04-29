package com.mapx.view.skins 
{
	import mx.skins.halo.SliderTrackSkin;
	
	public class migSliderTrackSkin extends SliderTrackSkin
	{
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			var backgroundColor:Number = 0x000000;
			graphics.clear();
			graphics.beginFill(backgroundColor,1);
			graphics.lineStyle(2,backgroundColor,0.5);				
			graphics.drawRect(2,-5,w+16,h+1);
			graphics.endFill();	
						
		}

	}
}