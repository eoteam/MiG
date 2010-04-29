package com.mapx.view.skins 
{
	import mx.skins.halo.ScrollThumbSkin;

	public class RightArrowUpSkin extends ScrollThumbSkin
	{
		override protected function updateDisplayList(w:Number, h:Number):void{
			super.updateDisplayList(w, h);
			
			var backgroundColor:Number = 0xFFFFFF;	
			graphics.clear();
			graphics.lineStyle(0,0,0);
			graphics.beginFill(backgroundColor,1);
			graphics.lineTo(0,0);
			graphics.lineTo(w,h/2);
			graphics.lineTo(0,h);
			graphics.lineTo(0,0);
			graphics.endFill();
			
			
		}
	}
} 