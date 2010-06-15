package org.mig.controller.startup
{
	import org.mig.services.interfaces.IAppService;
	import org.robotlegs.mvcs.Command;
	
	public class LoadTermsCommand extends Command
	{
		[Inject]
		public var appService:IAppService;
		
		override public function execute():void {
			appService.loadTerms();
		}
	}
}