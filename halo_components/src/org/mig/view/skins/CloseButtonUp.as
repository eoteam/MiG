package org.mig.view.skins 
{ 
	import mx.skins.ProgrammaticSkin;
	
	public class CloseButtonUp extends ProgrammaticSkin
	{
		public function CloseButtonUp(){}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			//var backgroundColor:Number = getStyle("color");
			var backgroundColor:Number = 0xFFFFFF;
			var bw:int = 2;
			var bh:int = 7;
			var x:Number = 6;
			var y:Number = -12;
			
			graphics.clear();
			graphics.lineStyle(0,0,0);
			//bounding box
			graphics.beginFill(backgroundColor,0);
			graphics.drawRect(x,y,17,17);
			graphics.endFill();
			graphics.beginFill(backgroundColor,1);

			graphics.lineTo(x,y+bh);
			graphics.lineTo(x+bh,y+bh);
			graphics.lineTo(x+bh,y);
			graphics.lineTo(x+(bh+bw),y);
			graphics.lineTo(x+(bh+bw),y+bh);
			graphics.lineTo(x+((bh*2)+bw),y+bh);
			graphics.lineTo(x+((bh*2)+bw),y+(bh+bw));
			graphics.lineTo(x+(bh+bw),y+(bh+bw));
			graphics.lineTo(x+(bh+bw),y+((bh*2)+bw));
			graphics.lineTo(x+bh,y+((bh*2)+bw));
			graphics.lineTo(x+bh,y+(bh+bw));
			graphics.lineTo(x,y+(bh+bw));
			graphics.lineTo(x,y+bh);
			
			graphics.endFill();
			this.rotation = 45;
		}

	}
}