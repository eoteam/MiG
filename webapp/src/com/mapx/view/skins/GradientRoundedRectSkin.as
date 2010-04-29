package  com.mapx.view.skins
{
	import flash.display.*;
	import flash.geom.*;
	
	import mx.controls.Button;
	import mx.core.UIComponent;
	
	public class GradientRoundedRectSkin extends UIComponent
	{
		import flash.display.Graphics;
		import flash.geom.Rectangle;
		import mx.graphics.GradientEntry;
		import mx.graphics.LinearGradient;
		  
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		   super.updateDisplayList(unscaledWidth,unscaledHeight);
			var w:Number = unscaledWidth;
			var h:Number = unscaledHeight;
		
			var cornerRadius:Number = getStyle("cornerRadius");
			var backgroundAlpha:Number = getStyle("backgroundAlpha");
			var borderColor:Number = getStyle("borderColor");
			
			// hold the values of the gradients depending on button state
			var backgroundFillColor:Number;
			var backgroundFillColor2:Number;
						
			
			var colors:Array = new Array();
			var alphas:Array = [100, 100];
			var ratios:Array = [0, 100];
			
			var matrix:Matrix = new Matrix();
            matrix.createGradientBox(50, 50, Math.PI / 2, 0, 0);
            
            var spreadMethod:String = SpreadMethod.PAD;
    
			
			// reference the graphics object of this skin class
			var g:Graphics = graphics;
			g.clear();				
			
			//	which skin is the button currently looking for? Which skin to use?
			switch (name) {
				case "upSkin":
					backgroundFillColor = getStyle("fillColors")[0];
					backgroundFillColor2 = getStyle("fillColors")[1];
					break;
				case "overSkin":
					backgroundFillColor = getStyle("fillColors")[1];
					backgroundFillColor2 = getStyle("fillColors")[0];
					borderColor = getStyle("themeColor");
					break;
				case "downSkin":
					backgroundFillColor = getStyle("fillColors")[1];
					backgroundFillColor2 = getStyle("fillColors")[0];
					color: 0xFF0000;
					break;
				case "disabledSkin":
					backgroundFillColor = 0xCCCCCC;
					backgroundFillColor2 = 0xCCCCCC;
					break;
			}			
			
			colors = [backgroundFillColor,backgroundFillColor2];
			
			
			this.graphics.lineStyle(1,borderColor,1,true);
			this.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix,spreadMethod);
			//this.graphics.drawRoundRect(0,0,unscaledWidth,unscaledHeight,{tl: cornerRadius, tr: cornerRadius, bl: cornerRadius, br: cornerRadius},backgroundFillColor,backgroundAlpha);
			this.graphics.drawRoundRect(0.5,0.5,unscaledWidth,unscaledHeight,cornerRadius*2,cornerRadius*2);				
		
 			if(this.parent != null)
			{
				Button(this.parent).buttonMode = true;
				Button(this.parent).useHandCursor = true;
				Button(this.parent).mouseChildren = false;
			} 
	
		 }	 
	}
}