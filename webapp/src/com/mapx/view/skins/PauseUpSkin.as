package  com.mapx.view.skins
{
	import mx.skins.halo.ScrollThumbSkin;

	public class PauseUpSkin extends ScrollThumbSkin
	{
		override protected function updateDisplayList(w:Number, h:Number):void{
			super.updateDisplayList(w, h);
			
			var backgroundColor:Number = 0xFFFFFF;	
			
			var g:Number = 3.5;		//gap between rectangles
			
			graphics.clear();
			graphics.lineStyle(0,0,0);
			
			//invisible bg rect
			graphics.beginFill(backgroundColor,0);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
			
			//rect 1
			graphics.beginFill(backgroundColor,1);
			graphics.drawRect(0, 0, (w/2)-(g/2), h);
			graphics.endFill();
			
			//rect 2
			graphics.beginFill(backgroundColor,1);
			graphics.drawRect((w/2)+(g/2), 0, (w/2)-(g/2), h);
			graphics.endFill();
			
			
		}
	}
} 