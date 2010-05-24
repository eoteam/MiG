package org.mig.controller.configuration
{
	import org.mig.AppConfigStateConstants;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
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
	import org.mig.view.components.managers.media.DownloadView;
	import org.mig.view.components.managers.media.FileUploadView;
	import org.mig.view.components.managers.media.MediaManagerView;
	import org.mig.view.components.managers.media.RenameView;
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
	import org.mig.view.mediators.managers.media.DownloadMediator;
	import org.mig.view.mediators.managers.media.FileUploadMediator;
	import org.mig.view.mediators.managers.media.MediaManagerMediator;
	import org.mig.view.mediators.managers.media.RenameMediator;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
		
	public class ConfigureViewsCommand extends Command
	{
		override public function execute():void
		{
			
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
			mediatorMap.mapView(DownloadView,DownloadMediator, null, false, false ); 
			mediatorMap.mapView(RenameView, RenameMediator,null, false, false ); 
			injector.mapClass(TagsCategoriesTab,TagsCategoriesTab);
			
			trace("Configure: Views Complete");
			//notifiy the state machine that we are done with this step
			eventDispatcher.dispatchEvent( new StateEvent(StateEvent.ACTION, AppConfigStateConstants.CONFIGURE_VIEWS_COMPLETE));
		}
	}
}