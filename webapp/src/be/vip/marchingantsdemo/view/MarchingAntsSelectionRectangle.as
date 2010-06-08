package be.vip.marchingantsdemo.view
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;

	public class MarchingAntsSelectionRectangle extends UIComponent
	{
		private var horizontalBitmap:BitmapData;
		private var verticalBitmap:BitmapData;
		private var _rect:Rectangle;
		private var _lineThickness:Number=1;
		private var bitmapScroll:Number=0;
		public var backgroundColor:uint=0xed1c58;
		public function MarchingAntsSelectionRectangle()
		{
			super();
			width=0;
			height=0;
			includeInLayout=false;
			horizontalBitmap=new BitmapData(4,2,false,0XFFFFFF);
			verticalBitmap=new BitmapData(2,4,false,0XFFFFFF);
			initBitmaps();
		}
		public function get rect():Rectangle{
			return _rect;
		}
		public function set rect(value:Rectangle):void{
			_rect = value;
			if(initialized)
				update();
		}
		public function clear():void{
			graphics.clear();
		}
		public function get lineThickness():Number{
			return _lineThickness;
		}
		public function set lineThickness(value:Number):void{
			_lineThickness = value;
			if(initialized)
				update();
		}
		private function scrollBitmaps():void{
			bitmapScroll++;
			if(bitmapScroll>3)
				bitmapScroll=0;
		}
		private function initBitmaps():void{
			for(var _x:Number=0;_x<2;_x++){
				for(var _y:Number=0;_y<2;_y++){
					horizontalBitmap.setPixel(_x,_y,0x000000);
					verticalBitmap.setPixel(_x,_y,0x000000);
				}
			}
		}
		private function update():void{
			scrollBitmaps();
			graphics.clear();
			
			graphics.beginBitmapFill(horizontalBitmap,new Matrix(1, 0, 0, 1, bitmapScroll, 0),true,false);
			graphics.drawRect(_rect.x,_rect.y-lineThickness,_rect.width,lineThickness);
			graphics.drawRect(_rect.x,_rect.y+_rect.height,_rect.width,lineThickness);
			
			graphics.beginBitmapFill(verticalBitmap,new Matrix(1, 0, 0, 1, 0, bitmapScroll),true,false);
			graphics.drawRect(_rect.x-lineThickness,_rect.y-lineThickness,lineThickness,_rect.height+(lineThickness*2));
			graphics.drawRect(_rect.x+_rect.width,_rect.y-lineThickness,lineThickness,rect.height+(lineThickness*2));
			
			graphics.endFill();
			graphics.beginFill(backgroundColor,0.2);
			graphics.drawRect(_rect.x,_rect.y,_rect.width,_rect.height);
			graphics.endFill();
		}
		

	}
}