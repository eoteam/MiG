package org.mig.view.skins
{
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import mx.skins.halo.ScrollThumbSkin;

	public class CustomScrollThumbSkin extends ScrollThumbSkin
	{
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			var newW:Number = w-5;
			var newH:Number = h;
			var backgroundColor:Number = 0xffffff;	
			graphics.clear();
			graphics.lineStyle(0,0,0);
			graphics.beginFill(backgroundColor,1);
			
			var matr:Matrix = new Matrix();
 			matr.createGradientBox(w, h, 0, 0, 0);
            graphics.beginGradientFill(GradientType.LINEAR,[0xFFFFFF,0xBBBBBB],[1,1],[150,255],matr);
            
			graphics.drawRoundRect(10,0,5,h,0,0);
			graphics.endFill();
			

		}
	}
} 