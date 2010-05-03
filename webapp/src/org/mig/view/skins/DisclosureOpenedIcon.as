package  org.mig.view.skins
{
	import mx.skins.ProgrammaticSkin;
	
	public class DisclosureOpenedIcon extends ProgrammaticSkin
	{
		public function DisclosureOpenedIcon(){}
		
		override protected function updateDisplayList(iw:Number, ih:Number):void{
				
			//super.updateDisplayList(w, h);
			
			
			var w:int = 10;
			var h:int = 12;
			var x:int = 0;
			var y:int = -5;
			
			var backgroundColor:Number = getStyle("color");
			//var backgroundColor:Number = 0x3F3F3F;
				
			graphics.clear();
			graphics.lineStyle(0,0,0);
			graphics.beginFill(backgroundColor,1);
			graphics.lineTo(0,0);
			graphics.lineTo(w,0);
			graphics.lineTo(w/2,h);
			graphics.lineTo(0,0);
			graphics.endFill();		
		}

	}
}	