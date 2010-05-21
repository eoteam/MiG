package org.mig 
{
	import flash.display.DisplayObjectContainer;
	
	import org.mig.controller.configuration.BootstrapApplicationCommand;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;
	
	public class MiGContext extends Context
	{
		public function MiGContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		override public function startup():void {
					
			commandMap.mapEvent( ContextEvent.STARTUP, BootstrapApplicationCommand, ContextEvent, true );
			dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
			
		}
	}
}