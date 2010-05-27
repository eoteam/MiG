package org.mig.view.skins
{
 
    import flash.display.Graphics;
    import mx.skins.ProgrammaticSkin;
 
    /**
     *  The skin for the drop indicator of a list-based control.
     */
    public class TreeDropIndicator extends ProgrammaticSkin
    {
 
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
 
        /**
	 *  Constructor.
	 */
        public function TreeDropIndicator()
        {
            super();
        }
 
        //--------------------------------------------------------------------------
        //
        //  Overridden methods
        //
        //--------------------------------------------------------------------------
 
        /**
         *  @private
         */
        override protected function updateDisplayList(w:Number, h:Number):void
        {	
            super.updateDisplayList(w, h);
 
            var g:Graphics = graphics;
 
            g.clear();
            g.beginFill(0xED1C58, 1);
            g.drawRect(20,0, 150,2);
            g.drawCircle(15,0,5);
        }
    }
}