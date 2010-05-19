package 
{
	import flash.display.DisplayObjectContainer;
	
	import org.mig.controller.ContentCommand;
	import org.mig.controller.MediaCommand;
	import org.mig.controller.ShowAlertCommand;
	import org.mig.controller.StartupCommand;
	import org.mig.controller.UploadCommand;
	import org.mig.events.AlertEvent;
	import org.mig.events.AppEvent;
	import org.mig.events.ContentEvent;
	import org.mig.events.MediaEvent;
	import org.mig.events.UploadEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.services.AppService;
	import org.mig.services.ContentService;
	import org.mig.services.FileService;
	import org.mig.services.MediaService;
	import org.mig.services.UserService;
	import org.mig.services.interfaces.IAppService;
	import org.mig.services.interfaces.IContentService;
	import org.mig.services.interfaces.IFileService;
	import org.mig.services.interfaces.IMediaService;
	import org.mig.services.interfaces.IUserService;
	import org.mig.view.components.content.ContentGeneralEditor;
	import org.mig.view.components.content.ContentView;
	import org.mig.view.components.content.tabs.MediaTab;
	import org.mig.view.components.content.tabs.TagsCategoriesTab;
	import org.mig.view.components.main.ContentTree;
	import org.mig.view.components.main.ContentViewer;
	import org.mig.view.components.main.LoginView;
	import org.mig.view.components.main.MainView;
	import org.mig.view.components.main.ManagersTree;
	import org.mig.view.components.main.StatusModule;
	import org.mig.view.components.managers.media.AddDirectoryView;
	import org.mig.view.components.managers.media.FileUploadView;
	import org.mig.view.components.managers.media.MediaManagerView;
	import org.mig.view.mediators.content.ContentGeneralEditorMediator;
	import org.mig.view.mediators.content.ContentViewMediator;
	import org.mig.view.mediators.content.tabs.MediaTabMediator;
	import org.mig.view.mediators.main.ContentTreeMediator;
	import org.mig.view.mediators.main.ContentViewerMediator;
	import org.mig.view.mediators.main.LoginViewMediator;
	import org.mig.view.mediators.main.MainViewMediator;
	import org.mig.view.mediators.main.ManagersTreeMediator;
	import org.mig.view.mediators.main.StatusModuleMediator;
	import org.mig.view.mediators.managers.media.AddDirectoryMediator;
	import org.mig.view.mediators.managers.media.FileUploadMediator;
	import org.mig.view.mediators.managers.media.MediaManagerMediator;
	import org.robotlegs.mvcs.Context;
	
	public class MiGContext extends Context
	{
		public function MiGContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		override public function startup():void {
			
			//top level
			commandMap.mapEvent(AppEvent.STARTUP,StartupCommand,AppEvent);
			commandMap.mapEvent(AppEvent.LOGGEDIN,StartupCommand,AppEvent);
			commandMap.mapEvent(AppEvent.CONFIG_LOADED,StartupCommand,AppEvent);
			commandMap.mapEvent(AppEvent.CONFIG_FILE_LOADED,StartupCommand,AppEvent);
			//content commands
			commandMap.mapEvent(ContentEvent.RETRIEVE_CHILDREN,ContentCommand,ContentEvent);
			commandMap.mapEvent(ContentEvent.RETRIEVE_VERBOSE,ContentCommand,ContentEvent);	
			//media commands
			commandMap.mapEvent(MediaEvent.RETRIEVE_CHILDREN,MediaCommand,MediaEvent);
			commandMap.mapEvent(MediaEvent.ADD_DIRECTORY,MediaCommand,MediaEvent);
			commandMap.mapEvent(MediaEvent.ADD_FILE,MediaCommand,MediaEvent);
			commandMap.mapEvent(MediaEvent.DELETE,MediaCommand,MediaEvent);
			
			//upload
			commandMap.mapEvent(UploadEvent.UPLOAD,UploadCommand,UploadEvent);
			commandMap.mapEvent(UploadEvent.CANCEL,UploadCommand,UploadEvent);
			//errors
			commandMap.mapEvent(AlertEvent.SHOW_ALERT, ShowAlertCommand, AlertEvent);
						
			//services
			injector.mapSingletonOf(IUserService,UserService); 
			injector.mapSingletonOf(IAppService, AppService);
			injector.mapSingletonOf(IContentService,ContentService);
			injector.mapSingletonOf(IMediaService,MediaService);
			injector.mapSingletonOf(IFileService,FileService);
				
			//model
			injector.mapSingleton(AppModel);
			injector.mapSingleton(ContentModel);

			
			//views
			mediatorMap.mapView(LoginView, LoginViewMediator);			
			mediatorMap.mapView(ContentTree,ContentTreeMediator);	
			mediatorMap.mapView(ManagersTree,ManagersTreeMediator);
			mediatorMap.mapView(StatusModule,StatusModuleMediator);
			mediatorMap.mapView(MainView,MainViewMediator);  
			mediatorMap.mapView(ContentViewer,ContentViewerMediator); 
			mediatorMap.mapView(ContentView,ContentViewMediator);
			mediatorMap.mapView(ContentGeneralEditor,ContentGeneralEditorMediator);
			mediatorMap.mapView(MediaTab,MediaTabMediator);
			mediatorMap.mapView(MediaManagerView,MediaManagerMediator);
			mediatorMap.mapView(FileUploadView,FileUploadMediator);
			//popup mediations
			mediatorMap.mapView(AddDirectoryView,AddDirectoryMediator, null, false, false ); //disable auto mediation

			injector.mapClass(TagsCategoriesTab,TagsCategoriesTab);

			dispatchEvent(new AppEvent(AppEvent.STARTUP));
		}
	}
}