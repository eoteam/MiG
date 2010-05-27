package org.mig.view.skins{
	import mx.skins.ProgrammaticSkin;
	
	public class EmptyButtonSkin extends ProgrammaticSkin
	{
		public function EmptyButtonSkin(){}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			
			graphics.clear();
			
		}

	}
}