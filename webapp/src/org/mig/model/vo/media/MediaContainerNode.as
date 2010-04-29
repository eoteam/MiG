package org.mig.model.media
{
	import org.mig.command.ResponseType;
	import org.mig.command.content.DeleteContentCommand;
	import org.mig.command.content.RetrieveContentCommand;
	import org.mig.command.content.UpdateContentCommand;
	import org.mig.command.file.FileCommand;
	import org.mig.controller.Constants;
	import org.mig.model.ContentNode;
	import org.mig.model.UpdateData;
	import org.mig.model.ValueObject;
	import org.mig.model.media.MediaData;
	
	import flash.errors.IllegalOperationError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	import mx.controls.Alert;
	import mx.core.Application;
	
	public class MediaContainerNode extends ContentNode
	{
		
		public function MediaContainerNode(baseLabel:String, config:XML, data:MediaData, parentContent:ContentNode,privileges:int) {
			super(baseLabel, config, data, parentContent,privileges);	
		}
		override protected function retrieve():void {
			children = null;
		} 
		
		override protected function update(value:UpdateData):void {
			
			sequenceTotal = 2;
			sequenceCounter = 0;
			
			var params:Object = new Object();
			params.action = "updateRecord";
			params.tablename = "media";
			params.id = data.id;
			params.name = value.name;
			
			var updateCommand:UpdateContentCommand = new UpdateContentCommand(this,value,params,checkSequence);
			updateCommand.execute();
			
			
			params = new Object();
			params.action = "renameFile";
			params.oldname = MediaData(data).path+MediaData(data).name;
			params.newname = MediaData(data).path+MediaData(data).name;
			if(MediaData(data).mimetype == MimeTypes.IMAGE || MediaData(data).mimetype == MimeTypes.VIDEO)
				params.thumb = 1;
			else
				params.thumb = 0;
			
			var updateCommand2:FileCommand = new FileCommand(this,Constants.RENAME,params,ResponseType.STATUS,checkSequence);
			updateCommand2.execute();
		}
		private function  checkSequence(result:Object):void {
			sequenceCounter++;
			if(sequenceCounter == sequenceTotal) {
				//sequence complete
			}
		}
		override protected function load():void {
			if(MediaData(data).loaded);
				//this.dispatchEvent(new ContentNodeEvent(ContentNodeEvent.DATA_LOADED,this));
			else {
				var params:Object = new Object();
				params.action = _config.@action.toString();
				params.verbosity = 2;
				params.mediaid = data.id;
				params.include_unused = 1;
				var command:RetrieveContentCommand = new RetrieveContentCommand(this,params,MediaData,handleLoad);
				command.execute();
			}		
		}
		override protected function remove(args:Array=null):void {
			//remove from DB
			var params:Object = new Object();
			params.action = _config.@service.toString();
			params.tablename= _config.@tablename.toString();
			params.id = this.data.id;
			
			var command:DeleteContentCommand;
			
			if(args != null && args[0] == true) { //remove disk
				sequenceTotal = 2;
				sequenceCounter = 0;
				
				command = new DeleteContentCommand(this,params,checkSequence);
				
				var parentCategoryNode:MediaCategoryNode = MediaCategoryNode(this.parentNode);
				params = new Object();
				params.directory = _config.@directory.toString();
				params.folderName = parentCategoryNode.directory.toString();
				params.fileName = _baseLabel;
				if(MediaData(data).mimetype.toString() == MimeTypes.IMAGE || MediaData(data).mimetype.toString() == MimeTypes.VIDEO)
					params.removethumb = 1;
				else
					params.removethumb = 0;
				
				var fileCommand:FileCommand = new FileCommand(this,Constants.REMOVE_FILE,params,ResponseType.STATUS,checkSequence);
				fileCommand.execute();
			}
			else
				command = new DeleteContentCommand(this,params);
			command.execute();
		}
		/*		private function handleDBRemove(event:Event):void {
		
		}*/
		private function handleDiskRemove(event:Event):void {
			
		}
		private function handleLoad(results:Array):void {
			MediaData(data).loaded = true;
			data = results[0] as MediaData;
		}
		
	}
}