package com.fxcomponents.skins
{
	import mx.skins.ProgrammaticSkin;
	
	public class MainDividerSkin extends ProgrammaticSkin
	{
		public function MainDividerSkin(){}
		
		override protected function updateDisplayList(iw:Number, ih:Number):void{
			
			//super.updateDisplayList(w, h);
			
			
			var w:int = 5;
			var h:int = 5;
			var x:int = 0;
			var y:int = -5;
			
			//var backgroundColor:Number = getStyle("color");
			var backgroundColor:Number = 0xFFFFFF;	
			graphics.clear();
			
			graphics.lineStyle(0,0,0);
			graphics.beginFill(backgroundColor,1);
			graphics.drawEllipse(x,y,w,h);
			
			graphics.endFill();			
		}

	}
}	