package org.mig.services
{
	import com.darronschall.serialization.ObjectTranslator;
	
	import flash.net.URLRequestMethod;
	import flash.xml.XMLDocument;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.rpc.xml.SimpleXMLDecoder;
	
	import org.mig.controller.Constants;
	import org.mig.events.AppEvent;
	import org.mig.events.ContentEvent;
	import org.mig.model.AppModel;
	import org.mig.model.ContentModel;
	import org.mig.model.vo.CustomField;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.model.vo.content.Template;
	import org.mig.model.vo.content.TemplateCustomField;
	import org.mig.services.interfaces.IAppService;
	import org.robotlegs.mvcs.Actor;

	public class AppService extends AbstractService implements IAppService
	{
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var contentModel:ContentModel;
		
		public function AppService() {
			super();
		}
		public function loadConfig():void {
			var params:Object = new Object();
			params.action = "getData";
			params.tablename = "config";
			this.createService(params,ResponseType.DATA,Object,configHandler);
		}
		public function loadConfigFile(url:String):void {
			var service:HTTPService = new HTTPService();
			var suffix:String = (new Date()).getTime().toString();
			service.url = url + "?" + suffix;
			service.resultFormat = HTTPService.RESULT_FORMAT_E4X;
			var token:AsyncToken = service.send();
			token.addResponder( new Responder(configfileHandler, fault));
		}
		public function loadCustomFieldGroups():void {
			var params:Object = new  Object();
			params.action = "getData";
			params.tablename = "customfieldgroups"; 
			this.createService(params,ResponseType.DATA,Object,handleCustomFieldGroups);
		}		
		public function loadCustomFields():void {
			var params:Object = new  Object();
			params.action = "getData";
			params.tablename = "customfields";
			this.createService(params,ResponseType.DATA,CustomField,handleCustomfields);
		}
		public function loadTemplates():void {
			var params:Object = new  Object();
			params.action = "getTemplates";
			this.createService(params,ResponseType.DATA,Object,handleTemplates);		
		}
		
		private function configHandler(data:ResultEvent):void {
			var results:Array = data.result as Array;
			for each(var item:Object in results) {
				switch(item.name) {
					case "prompt":
						appModel.prompt = item.value;
					break;
					case "configfile":
						appModel.configfile = item.value;
					break;
					default:
						appModel.managers.push(item);
					break
				}
			}
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.CONFIG_LOADED));
		}
		private function configfileHandler(event:ResultEvent):void {
			var config:XML = event.result as XML;
			appModel.config = config;			
			eventDispatcher.dispatchEvent(new AppEvent(AppEvent.CONFIG_FILE_LOADED));
		}
		private function handleCustomFieldGroups(event:ResultEvent):void {
			var results:Array = event.result as Array;
			for each(var item:Object in results) {
				appModel.customfields.push(item);
				item.children = [];
			}
		}
		private function handleCustomfields(event:ResultEvent):void {
			var results:Array = event.result as Array;
			for each(var item:CustomField in results) {
				appModel.customfieldsFlat.push(item);
				for each(var group:Object in appModel.customfields) {
					if(item.groupid == group.id) {
						group.children.push(item);
						break;
					}
				}
			}
		}	
		private function handleTemplates(event:ResultEvent):void {
			var results:Array = event.result as Array;
			for each(var item:Object in results) {
				var template:Template = new Template();
				template.name = item.name;
				template.id = Number(item.id);
				contentModel.templates.addItem(template);
				if(item.rowids != null) {
					var cfs1:Array = item.rowids.split(',');
					var cfs2:Array = item.customfieldids.split(',');
					var cfs3:Array = item.fieldids.split(',');
					var cfs4:Array = item.displayorders.split(',');
					var cfs5:Array = item.rowids.split(',');
					
					for (var i:int=0;i<cfs1.length;i++) {
						var templateCustomField:TemplateCustomField = new TemplateCustomField();
						templateCustomField.id = cfs1[i];
						templateCustomField.fieldid = cfs3[i];
						templateCustomField.displayorder = cfs4[i];
						templateCustomField.visible = cfs5[i] == '1'?true:false;

						var cfid:int = cfs2[i];
						for each(var field:CustomField in appModel.customfieldsFlat) {
							if(field.id == cfid) {
								templateCustomField.customfield = field;
								break;
							}
						}
						template.customfields.addItem(templateCustomField);
					}
				}
			}
		}

	}
}