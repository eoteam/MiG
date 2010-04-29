package  com.mapx.view.skins
{
	import mx.skins.halo.ProgressBarSkin;

	public class LoadingBarSkin extends ProgressBarSkin
	{
		override protected function updateDisplayList(w:Number, h:Number):void{
			super.updateDisplayList(w, h);
			
			
			 var backgroundColor:Number = 0x000000; 
			var strokeColor:Number = 0xCCCCCC;	
			
			
			
			graphics.clear();
			graphics.lineStyle(1,strokeColor,1);
			graphics.beginFill(backgroundColor,1);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
			
			
			
		}
	}
} 