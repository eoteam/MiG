package org.mig.controller.configuration
{
	import org.mig.AppConfigStateConstants;
	import org.mig.view.components.content.ContentGeneralEditor;
	import org.mig.view.components.content.ContentView;
	import org.mig.view.components.content.MainMiddleView;
	import org.mig.view.components.content.media.MediaTab;
	import org.mig.view.components.content.media.MediaTabAnimatedListRenderer;
	import org.mig.view.components.content.tags.TagsCategoriesTab;
	import org.mig.view.components.main.ContainerPathView;
	import org.mig.view.components.main.ContentTree;
	import org.mig.view.components.main.ContentViewer;
	import org.mig.view.components.main.LoginView;
	import org.mig.view.components.main.MainView;
	import org.mig.view.components.main.ManagersTree;
	import org.mig.view.components.main.NewContentView;
	import org.mig.view.components.main.PendingListView;
	import org.mig.view.components.main.StatusModule;
	import org.mig.view.components.managers.media.AddDirectoryView;
	import org.mig.view.components.managers.media.DownloadView;
	import org.mig.view.components.managers.media.FileUploadView;
	import org.mig.view.components.managers.media.MediaManagerView;
	import org.mig.view.components.managers.media.RenameView;
	import org.mig.view.components.managers.tags.TagManagerView;
	import org.mig.view.components.managers.templates.TemplatesManagerView;
	import org.mig.view.components.managers.templates.tabs.TemplateMediaTab;
	import org.mig.view.components.managers.templates.tabs.TemplateTermsTab;
	import org.mig.view.controls.MiGColorPicker;
	import org.mig.view.mediators.content.ContentGeneralEditorMediator;
	import org.mig.view.mediators.content.ContentViewMediator;
	import org.mig.view.mediators.content.media.MediaTabMediator;
	import org.mig.view.mediators.controls.MiGColorPickerMediator;
	import org.mig.view.mediators.main.ContainerPathMediator;
	import org.mig.view.mediators.main.ContentTreeMediator;
	import org.mig.view.mediators.main.ContentViewerMediator;
	import org.mig.view.mediators.main.LoginViewMediator;
	import org.mig.view.mediators.main.MainViewMediator;
	import org.mig.view.mediators.main.ManagersTreeMediator;
	import org.mig.view.mediators.main.NewContentMediator;
	import org.mig.view.mediators.main.PendingListMediator;
	import org.mig.view.mediators.main.StatusModuleMediator;
	import org.mig.view.mediators.managers.media.AddDirectoryMediator;
	import org.mig.view.mediators.managers.media.DownloadMediator;
	import org.mig.view.mediators.managers.media.FileUploadMediator;
	import org.mig.view.mediators.managers.media.MediaManagerMediator;
	import org.mig.view.mediators.managers.media.RenameMediator;
	import org.mig.view.mediators.managers.tags.TagManagerMediator;
	import org.mig.view.mediators.managers.templates.TemplatesManagerMediator;
	import org.mig.view.mediators.managers.templates.tabs.TemplateMediaTabMediator;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.utilities.statemachine.StateEvent;
	
	public class ConfigureViewsCommand extends Command
	{
		override public function execute():void
		{
			
			//views
			//main
			mediatorMap.mapView( LoginView,			LoginViewMediator		);			
			mediatorMap.mapView( ContentTree,		ContentTreeMediator		);	
			mediatorMap.mapView( ManagersTree,		ManagersTreeMediator	);
			mediatorMap.mapView( StatusModule,		StatusModuleMediator	);
			mediatorMap.mapView( MainView,			MainViewMediator		);  
			mediatorMap.mapView( ContentViewer,		ContentViewerMediator	); 
			mediatorMap.mapView( ContainerPathView,	ContainerPathMediator	);
			mediatorMap.mapView( NewContentView,	NewContentMediator		);
			mediatorMap.mapView( PendingListView,	PendingListMediator		);  
			
			//tabs
			mediatorMap.mapView(ContentView,ContentViewMediator);
			mediatorMap.mapView(ContentGeneralEditor,ContentGeneralEditorMediator);
			mediatorMap.mapView(MediaTab,MediaTabMediator);
			
			//media manager
			mediatorMap.mapView(MediaManagerView,MediaManagerMediator);
			mediatorMap.mapView(FileUploadView,FileUploadMediator);
			
			//tag manager
			mediatorMap.mapView(TagManagerView,TagManagerMediator);
			
			//customfields manager
			//mediatorMap.mapView(CustomFieldsManagerView ,CustomFiledsManagerMediator);
			
			//templates manager
			mediatorMap.mapView(TemplatesManagerView,TemplatesManagerMediator);
			mediatorMap.mapView(TemplateMediaTab, TemplateMediaTabMediator);
			
			//components
			mediatorMap.mapView(MiGColorPicker ,MiGColorPickerMediator); 
			
			//popup mediations
			mediatorMap.mapView(AddDirectoryView,AddDirectoryMediator, null, false, false ); //disable auto mediation
			mediatorMap.mapView(DownloadView,DownloadMediator, null, false, false ); 
			mediatorMap.mapView(RenameView, RenameMediator,null, false, false ); 
			
			//non mediated views
			injector.mapClass(MainMiddleView,MainMiddleView);
			injector.mapClass(TagsCategoriesTab,TagsCategoriesTab);
			injector.mapClass(MediaTabAnimatedListRenderer, MediaTabAnimatedListRenderer);
			
			injector.mapClass(TemplateTermsTab,TemplateTermsTab);
			
			trace("Configure: Views Complete");
			//notifiy the state machine that we are done with this step
			eventDispatcher.dispatchEvent( new StateEvent(StateEvent.ACTION, AppConfigStateConstants.CONFIGURE_VIEWS_COMPLETE));
		}
	}
}