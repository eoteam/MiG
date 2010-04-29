package 
{
	import flash.display.DisplayObjectContainer;
	
	import org.mig.controller.InitCommand;
	import org.mig.controller.LoginCommand;
	import org.mig.controller.RetrieveContentCommand;
	import org.mig.controller.ShowAlertCommand;
	import org.mig.events.AlertEvent;
	import org.mig.events.AppEvent;
	import org.mig.events.ContentEvent;
	import org.mig.events.LoginEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.user.LoginToken;
	import org.mig.services.AppService;
	import org.mig.services.ContentService;
	import org.mig.services.UserService;
	import org.mig.services.interfaces.IAppService;
	import org.mig.services.interfaces.IContentService;
	import org.mig.services.interfaces.IUserService;
	import org.mig.view.ContentTreeMediator;
	import org.mig.view.LoginViewMediator;
	import org.mig.view.StatusModuleMediator;
	import org.mig.view.components.ContentTree;
	import org.mig.view.components.LoginView;
	import org.mig.view.components.StatusModule;
	import org.mig.view.interfaces.ILoginView;
	import org.robotlegs.mvcs.Context;
	
	public class MiGContext extends Context
	{
		public function MiGContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		override public function startup():void {
	
			commandMap.mapEvent(LoginEvent.LOGIN,LoginCommand,LoginEvent);
			commandMap.mapEvent(LoginEvent.FORGOT,LoginCommand, LoginEvent);
			
			commandMap.mapEvent(AlertEvent.SHOW_ALERT, ShowAlertCommand, AlertEvent );
			
			commandMap.mapEvent(AppEvent.LOGGEDIN,InitCommand,AppEvent);
			commandMap.mapEvent(AppEvent.CONFIG_LOADED,InitCommand,AppEvent);
			
			injector.mapSingletonOf(IUserService,UserService ); 
			injector.mapSingletonOf(IAppService, AppService);
			injector.mapSingletonOf(IContentService,ContentService);
			
			injector.mapSingleton(AppModel);
			injector.mapSingleton(ContentModel);
			
			mediatorMap.mapView(LoginView, LoginViewMediator);			
			mediatorMap.mapView(ContentTree,ContentTreeMediator);	
			mediatorMap.mapView(StatusModule,StatusModuleMediator);
			//content commands
			commandMap.mapEvent(ContentEvent.RETRIEVE,RetrieveContentCommand,ContentEvent);
			
			
			
		}
	}
}