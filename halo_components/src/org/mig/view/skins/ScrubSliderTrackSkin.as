package org.mig.view.skins 
{
	import mx.skins.halo.SliderTrackSkin;

	public class ScrubSliderTrackSkin extends SliderTrackSkin
	{
		override protected function updateDisplayList(w:Number, h:Number):void{
			super.updateDisplayList(w, h);
			
			var backgroundColor:Number = 0xFFFFFF;
			var vPadding:Number = 9;
			var hPadding:Number = 12;
			
			graphics.clear();
			graphics.lineStyle(1,backgroundColor,1);
		
			graphics.drawRect(((hPadding/2)*-1),((vPadding/2)*-1),(w+hPadding) , (h + vPadding));
			
		}
	}
} 