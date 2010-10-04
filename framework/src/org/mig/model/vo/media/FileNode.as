package org.mig.model.vo.media
{

	
	import flash.errors.IllegalOperationError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	import mx.controls.Alert;
	import mx.core.Application;
	
	import org.mig.model.vo.ContentNode;
	
	
	/**
	 * @flowerModelElementId _edfE4M2REd--irTzzklAjg
	 */
	[Bindable]
	public class FileNode extends ContentNode
	{
		public var isBranch:Boolean = false;
		public function FileNode(baseLabel:String, data:MediaData, parentContent:ContentNode,privileges:int) {
			super(baseLabel, data, parentContent,privileges);	
			children = null;
		}
/*		

		
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

		private function handleLoad(results:Array):void {
			MediaData(data).loaded = true;
			data = results[0] as MediaData;
		}*/
		
	}
}