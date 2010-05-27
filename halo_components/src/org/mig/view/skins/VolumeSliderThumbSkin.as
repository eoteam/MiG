package org.mig.view.skins
{
	import mx.skins.halo.SliderThumbSkin;

	public class VolumeSliderThumbSkin extends SliderThumbSkin
	{
		override protected function updateDisplayList(w:Number, h:Number):void{
			super.updateDisplayList(w, h);
			
			var backgroundColor:Number = 0xFFFFFF;	
			
			
			graphics.clear();
			graphics.lineStyle(0,0,0);
			graphics.beginFill(backgroundColor,0);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
		}
	}
} 