package  com.mapx.view.skins
{
	   
    import org.mig.utils.MacMouseWheel;
    
    import flash.display.GradientType;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.Matrix;
    import flash.utils.Timer;
    
    import mx.controls.scrollClasses.ScrollBar;
    import mx.skins.halo.ScrollTrackSkin;


    //import com.pixelbreaker.ui.osx.MacMouseWheel;
    /**
     *  The skin for the track in a ScrollBar.
     */
    public class CustomScrollTrackSkin extends ScrollTrackSkin
    {

		public function CustomScrollTrackSkin()
		{
			super(); 
		}
		
        override protected function updateDisplayList(w:Number, h:Number):void
        {
        	super.updateDisplayList(w, h);
			if(this.parent != null)
			{
	          	if(this.parent.parent != null)
	          	{
			    	var scrollComponent:ScrollBar = this.parent.parent as ScrollBar;	
		           	if(scrollComponent != null)
		           	{
		          		if(scrollComponent.stage != null)
						{
							MacMouseWheel.setup(scrollComponent.stage);
						}
/* 						if(scrollComponent.numChildren > 3)
						{
							scrollComponent.getChildAt(1).visible = false;
							scrollComponent.getChildAt(1).height = 0;
							scrollComponent.getChildAt(3).visible = false;
							scrollComponent.getChildAt(3).height = 0;
						} */
						var backgroundColor:Number = 0x000000;
						graphics.clear();
						//graphics.beginFill(backgroundColor,1);
						graphics.lineStyle(0,backgroundColor,0.5);	
						
						var matr:Matrix = new Matrix();
			 			matr.createGradientBox(w, h, 0, 0, 0);
			            graphics.beginGradientFill(GradientType.LINEAR,[0x000000,0x111111],[1,1],[0,150],matr);
									
						graphics.drawRoundRect(10,0,5,h,0,0);
						graphics.endFill();						
						
	           		}
          		}
   			}
        }   
		private function checkMouseDelta(event:MouseEvent):void
		{
			var scrollComponent:ScrollBar = this.parent.parent as ScrollBar;
			scrollComponent.scrollPosition += event.delta / 10;
			trace(event.delta);
			
		}           
    }
}