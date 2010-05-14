package com.map.controller
{
	//Handle Tag Manager dependency and use Event to refresh, IManager should have refresh 
	//OR UPLOAD_COMPLETE is sufficient and TagManager should listen to that
	
	import com.adobe.xmp.XMPArray;
	import com.adobe.xmp.XMPMeta;
	import com.adobe.xmp.XMPProperty;
	import com.map.event.ApplicationEvent;
	import com.map.manager.ManagerBase;
	import com.map.model.MediaCategoryNode;
	import com.map.model.MediaContainerNode;
	import com.map.services.XmlHttpOperation;
	import com.map.event.EventBus;
	//import com.mapx.manager.TagManager;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLRequest;
	import flash.utils.Timer;	
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.events.CollectionEvent;	
	
	[Event(name="complete", type="flash.events.Event")]
	[Bindable]
	public class FileUploadController extends EventDispatcher
	{
//////*******FILE UPLOAD MODEL******//////////
					
		private var _uploadProgress:Number=0;
		private var _currentFile:String="";			
		private var _status:String;		
		private var _bytesTotal:Number;		
		private var _bytesLoaded:Number=0		
		private var _uploadType:String;		
		private var _prevUploaded:String;
		private var _prevFileXML:XML;
		private var uploadURL:URLRequest;					
		private var clearDataTimer:Timer;
		private var thmbToCreate:String="";
		private var _rootDirectory:String;	
		private var _uploadPath:String;
		private var _nextUploadPath:String;
		private var currDirectory:String;
		private var keywords:Array;	
		private var files:FileReferenceList;
		private var fileUploadMove:Boolean = false
		private var scannedIndex:int;
		private var scanBusy:Boolean;
		private var makeVideoThumb:Boolean = false;
		
		public  var currentMediaCategoryNode:MediaCategoryNode;
		public var uploadDir:String;		
		public var uploadedList:String = "";			
		public var currentFileIndex:Number=0;		
		public var browseRequested:Boolean;	
		public var currentlyUploading:String="";		
		public var selectedFiles:Array;
		public var busy:Boolean = false;
        public var imageExtensions:Array= [".jpg", ".jpeg", ".gif", ".png"];
        public var videoExtensions:Array= [".flv", ".mov", ".mp4", ".m4v", ".f4v"];
        public var audioExtensions:Array=[".mp3"];
        public var fontExtensions:Array= [".ttf", ".otf"];      		
		public var scannedSets:ArrayCollection;

		public function FileUploadController():void
		{
			super();
			// set a reference to this controller in the locator
        	ControllerLocator.fileUploadController = this;	
			scanBusy = false;		
			scannedSets = new ArrayCollection();
			scannedSets.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleSetsChanged);
			clearDataTimer = new Timer(2500);	
			//EventBus.getInstance().addEventListener(ManagerEvent.ACTIVATE,handleServiceManager);
		}
		private function handleSetsChanged(event:ionEvent):void
		{
			if(event.kind == "add" && !scanBusy)
			{
				uploadSet(scannedIndex);
			}	
		}
		private function uploadSet(index:int):void
		{
			scanBusy = true;
			var scannedSet:Object = scannedSets.getItemAt(index);
			uploadPath = scannedSet.uploadPath;
			currentMediaCategoryNode = scannedSet.node;
			selectedFiles = scannedSet.files;
			scannedSet.done = "1";
			uploadFiles(true);
			trace("############ NEW SET############# ",index);
		}

		public function get currentFile():String {
			return _currentFile;
		}	
		public function set currentFile(file:String):void {
			_currentFile=file
		}	
		public function set rootDirectory(newVal:String):void {
			_rootDirectory = newVal;
		}	
		public function get rootDirectory():String {
			return _rootDirectory;
		}		
		public function set uploadPath(newVal:String):void {
			if(!busy) {
				_uploadPath = newVal;
				if(!fileUploadMove)
					currentMediaCategoryNode = MediaCategoryNode(ControllerLocator.mediaManagerController.selectedContent); 
			}
			else {
				_nextUploadPath = newVal;
			}
		}
		public function get uploadPath():String {
			return _uploadPath;
		}	
		public function get status():String{
			return _status;
		}	
		public function set status(newStatus:String):void{
			_status=newStatus;
		}		
		public function get bytesLoaded():Number{
			return _bytesLoaded;
		}		
		public function set bytesLoaded(loaded:Number):void{
			_bytesLoaded=loaded;
			dispatchEvent(new Event("bytesLoadedChanged"))
		}		
		public function get bytesTotal():Number{
			return _bytesTotal;
		}		
		public function set bytesTotal(total:Number):void{
			_bytesTotal=total;
		}	
		public function get uploadProgress():Number{
			return _uploadProgress;
		}	
		public function set uploadProgress(percentage:Number):void{
			_uploadProgress=percentage;
		}	
/*		public function get prevUploaded():String{
			return _prevUploaded;
		}
		public function set prevUploaded(newVal:String):void{
			_prevUploaded=newVal;
		}*/	
//////******END OF MODEL*******////////							
		public function browseFiles():void
		{	
			files = new FileReferenceList();
			configListeners(IEventDispatcher(files));
			files.browse([new FileFilter("Files (*.*)", "*.*")]);			
		}
		private function configListeners(dispatcher:IEventDispatcher):void
		{
			var newError:String = "DISPATCH EVENTS";	
			dispatcher.addEventListener(Event.CANCEL, cancelHandler);
            dispatcher.addEventListener(Event.SELECT, selectHandler);	
		}		
		private function selectHandler(event:Event):void
		{
		    files = FileReferenceList(event.target);  
		    selectedFiles = files.fileList;
		    var newError:String = "SELECTION COMPLETE";
		}
		public function uploadFiles(uploaded:Boolean=false):void
		{
			busy = true;
			fileUploadMove = uploaded;
			this.currentFileIndex = 0;
			uploadNextFile(this.currentFileIndex);
			keywords = new Array();
			makeVideoThumb = ControllerLocator.mediaManagerController.contentModel.children.getItemAt(0).config.@videoThumb.toString() == "true"?true:false;
		}		
		private function cancelHandler(event:Event):void 
		{
        	dispatchEvent(new Event("resetUploadMod"));
	    	this.uploadedList = "";
	    	dispatchEvent(new Event("uploadedListChanged"));
	    	this.currentFileIndex=0;
	    	this.uploadProgress=0;
        }        
        private function runDataClear(event:TimerEvent):void
        {
        	clearDataTimer.stop();
        	clearDataTimer.addEventListener(TimerEvent.TIMER, runDataClear);
        	dispatchEvent(new Event("resetUploadMod"));
        	this.uploadedList = "";
        	this.currentFileIndex=0;
        	this.uploadProgress=0;
			busy = false;
        	if(_nextUploadPath)
        	{
        		_uploadPath = _nextUploadPath;	
        		currentMediaCategoryNode = MediaCategoryNode(ControllerLocator.mediaManagerController.selectedContent);
        	}
        }        
        private function generateErrorOutput(newError:String):void
        {
        	//trace("UPLOAD CONTROLLER: " + newError);
        }        
        private function openHandler(event:Event):void
        {
            var newError:String = "Open";
            generateErrorOutput(newError);		
        }
		private function getFileType(fileExtension:String):String
		{
			if(imageExtensions.indexOf(fileExtension) != -1)	
				return "images";
			else if(videoExtensions.indexOf(fileExtension) != -1)	
				return"videos";
			else if(fontExtensions.indexOf(fileExtension) != -1)	
				return "fonts";    
			else if(audioExtensions.indexOf(fileExtension) != -1)	
				return "audio";   
			else if(fileExtension == ".swf")
				return "swf";
			else
				return "files";	 
		}
		private function uploadNextFile(n:Number):void
		{	
			var item:Object = selectedFiles[n];
			var directory:String = _rootDirectory + "/" + uploadPath;
			var thumbsDir:String = _rootDirectory + "/migThumbs/" + uploadPath;
			currDirectory = directory;	
			if(!fileUploadMove)
			{
				var file:FileReference = item as FileReference;
	     		var extArr:Array = file.name.split('.');
	     		var fileExtension:String = String('.'+extArr[extArr.length-1]).toLowerCase();
	     		var fileType:String = getFileType(fileExtension);
	     		
		        file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		        file.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHttpStatus);
		        file.addEventListener(Event.COMPLETE, fileUploadComplete);
		        file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);
		        file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		        file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		        try  
		        {       	        	
		        	var newURL:String = Constants.FILEUPLOAD_PHP + "?directory=" + directory + "/&thumbsDir=" + thumbsDir + "/&fileType=" + fileType;
		        	uploadURL = new URLRequest(newURL);
		            file.upload(uploadURL, "Filedata")
		            currentlyUploading = file.name;
		            dispatchEvent(new Event("currentlyUploadingChanged"));
		        }  
		        catch (error:Error)  
		        {  
		        } 	
	  		}     
	  		else
	  		{
	  			currentlyUploading = item.name;
	  			this.uploadProgress = 1;
	  			resumeFileUploadComplete(item.name,item.thumb,item.video_proxy,item.parent);
	  		}   			
		}     	
        private function fileUploadComplete(event:Event):void
        {	

		}
		private function resumeFileUploadComplete(filename:String,thumb:String,video_proxy:String,parent:String=''):void
		{
     		var extArr:Array = filename.split('.');
     		var fileExtension:String = String('.'+extArr[extArr.length-1]).toLowerCase();
     		var fileType:String = getFileType(fileExtension);   		
    		
			var tokens:Object = new Object();
			tokens.filename = filename;
			tokens.thumb = thumb;
			tokens.video_proxy = video_proxy;
          	if(fileType == "images")
          	{  
	         	var operation:XmlHttpOperation = new XmlHttpOperation(Constants.XMP_PARSER);
	         	operation.addEventListener(Event.COMPLETE,xmpParsingComplete);	
	         	var params:Object = new Object();
	         	var path:String;
	         	if(uploadPath != "")
	        		path = "/" + uploadPath + "/"+parent;
	        	else
	        		path = "/"+parent;
	         	params.file = ControllerLocator.mediaManagerController.fileDir+path+filename;
	         	operation.params = params;
				operation.tokens = tokens;
	         	operation.execute();
          	}            
    		else if(fileType == "audio" || fileType == "videos") // get playtime in seconds, using ID3 lib, can add more ID3 in DB
    		{
	         	operation = new XmlHttpOperation(Constants.ID3_PLAYTIME);
	         	operation.addEventListener(Event.COMPLETE,playtimeComplete);	
	         	params = new Object();
	         	path;
	         	if(uploadPath != "")
	        		path = "/" + uploadPath + "/"+parent;
	        	else
	        		path = "/"+parent;
	         	params.file =  ControllerLocator.mediaManagerController.fileDir+path+filename;
	         	operation.params = params;
				operation.tokens = tokens;
	         	operation.execute();    			
    		}
    		else
    			populateDatabase(filename,thumb,video_proxy,selectedFiles[this.currentFileIndex]);                
        }
        private function playtimeComplete(event:Event):void
        {
			var _data:XMLList =  XmlHttpOperation(event.target).xml.children();
			var playTime:Number = NaN;
			var tokens:Object = event.target.tokens;
			if(_data.length() == 2)
    		{
				playTime = Number(_data[1].toString());		
			}
			 populateDatabase(tokens.filename,tokens.thumb,tokens.video_proxy,selectedFiles[this.currentFileIndex],null,playTime);      	
        }    
		private function xmpParsingComplete(event:Event):void
		{	
			var _data:XMLList =  XmlHttpOperation(event.target).xml.children();
			var tokens:Object = event.target.tokens;
			if(_data.success != "false")
    		{
				var xmp:XML = XmlHttpOperation(event.target).xml;
    			var xmpMeta:XMPMeta = new XMPMeta(xmp);
    			var tags:Array = parseXMPData(xmpMeta);					
			}
			populateDatabase(tokens.filename,tokens.thumb,tokens.video_proxy,selectedFiles[this.currentFileIndex],tags);
		}
		private function parseXMPData(value:XMPMeta):Array
		{
			var tags:Array = new Array();
			for each(var xmpElement:Object in value)
			{
				if(xmpElement is XMPArray && XMPArray(xmpElement).qname.localName.toString() == "subject")
				{
					//trace("XMP subject array: "+XMPArray(xmpElement).length.toString());
					for each(var xmpProp:XMPProperty in xmpElement)
					{
						tags.push(parseXMPProperty(xmpProp));
					}
				}
			}
			return tags;				
		}
		private function parseXMPProperty(prop:XMPProperty):String
		{
			var result:String = "";
			if(XMPProperty(prop).value)
			{
				if(keywords.indexOf(XMPProperty(prop).value) == -1)
					keywords.push(XMPProperty(prop).value);
				result = XMPProperty(prop).value;
			}
			//trace(XMPProperty(prop).value);	
			return result;	
		}	
		private function populateDatabase(filename:String,thumb:String,video_proxy:String,file:Object,tags:Array=null,playTime:Number=NaN):void
		{
			var extArr:Array = filename.split('.');
     		var fileExtension:String = String('.'+extArr[extArr.length-1]).toLowerCase();
     		var fileType:String = getFileType(fileExtension);
	
      		var parent:String = '';
      		if(this.fileUploadMove)
      			parent = file.parent;
        	var directory:String = _rootDirectory + "/" + uploadPath+parent;
        	var thumbsDir:String = _rootDirectory + "/migThumbs/" + uploadPath+parent;  	
        	        
	        var operation:XmlHttpOperation = new XmlHttpOperation(Constants.EXECUTE);
	        operation.addEventListener(Event.COMPLETE, handleDatabaseComplete);
	                	       
	        var tokens:Object = new Object();
	        tokens.index= this.currentFileIndex;
	        tokens.directory = directory;
	        tokens.thumbsDir = thumbsDir;
	        tokens.fileType = fileType;	        
	        
	        var params:Object = new Object();
	        params.action = "insertRecord";
	        params.tablename = "media";
	        params.size = file.size;
	        params.name = filename;
	        if(uploadPath != "")
	        	params.path = "/" + uploadPath + "/"+parent;
	        else
	        	params.path = "/"+parent;
	        
			params.thumb = thumb;
			if(video_proxy != "false")
				params.video_proxy = video_proxy;
	        params.mimetype = fileType;
	        if(fileType == "font")
	        {
	        	params.customfield1 = false; //not compiled 
	        }
	        params.createdby = Application.application.user.id;
	        params.modifiedby = Application.application.user.id;
	        params.verbose = false;
	        trace(params.name,"\t\t\t",this.currentFileIndex,"\t",this.selectedFiles.length);
	        var date:Date = new Date();
	        params.createdate = date.time;
	        params.modifieddate = date.time;
	        if(!isNaN(playTime))
	        	params.playtime = playTime;
	        var tagString:String="";
	        if(tags)
	        {
	        	for each(var keyword:String in tags)
	        	{
	        		tagString += keyword+",";
	        	}
	        	tagString = tagString.substring(0,tagString.length-1);
	        	params.tags = tagString; 
	        }	       
	        operation.params = params;
	        operation.tokens = tokens;
	        operation.execute();     			
		}
		private function handleDatabaseComplete(event:Event):void
		{
			var op:XmlHttpOperation = event.target as XmlHttpOperation;
			var operation:XmlHttpOperation = new XmlHttpOperation(Constants.EXECUTE);
			operation.addEventListener(Event.COMPLETE, handleDatatebaseRetrieveComplete);
			var params:Object = new Object();
			params.action = "getMedia";
			params.include_unused =1;
			params.mediaid	 = op.xml.children()[0].id.toString();
			operation.params = params;
			operation.execute();
		}
		private function handleDatatebaseRetrieveComplete(event:Event):void	{
			
			var operation:XmlHttpOperation = event.target as XmlHttpOperation;
			_prevFileXML = operation.xml.children()[0];
   			generateErrorOutput("Complete"); 
	        this.uploadedList += "<p></p>"+currentlyUploading+" is completed";
	        //this.prevUploaded = currentlyUploading;    
	        dispatchEvent(new Event("uploadedListChanged"));
	       	var newNode:MediaContainerNode = currentMediaCategoryNode.addMediaContainerNode(_prevFileXML,_prevFileXML.name.toString()); 
            currentlyUploading="";
            dispatchEvent(new Event("fileUploaded"));	
			
			this.currentFileIndex++;
	        if(this.currentFileIndex < selectedFiles.length)
	        	uploadNextFile(this.currentFileIndex);      	
	        else
	        {
	            if(this.fileUploadMove)
	            {
	            	scannedIndex++;
	            	if(scannedIndex < scannedSets.length)
	            	{
	            		this.uploadSet(scannedIndex);
	            	}
	            	else
	            	{
	            		clearDataTimer.addEventListener(TimerEvent.TIMER, runDataClear)
	        			clearDataTimer.start();
						scanBusy = fileUploadMove = false;
	           			this.uploadPath ='';
	           			this.selectedFiles = [];
	           			this.scannedSets = new ArrayCollection();
	           			//TagManager(ManagerBase.getInstance(TagManager)).refresh();
						EventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.UPLOAD_COMPLETE));
	           		}
	           	}
	           	else
	           	{
	            	clearDataTimer.addEventListener(TimerEvent.TIMER, runDataClear);
	        		clearDataTimer.start();	           		
	           		//TagManager(ManagerBase.getInstance(TagManager)).refresh();
					EventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.UPLOAD_COMPLETE));
	           	}
	        }	            		
		}
		//FILE REFERENCE LISTERNERS ---
		private function handleHttpStatus(event:HTTPStatusEvent):void
		{
			//trace("HTTP STATUS EVENT");
		}				
        private function ioErrorHandler(event:IOErrorEvent):void
        {
            var newError:String = "ioErrorHandler: " + event
            generateErrorOutput(newError);
            var percentLoaded:Number = 0;
			this.uploadProgress = 0;
			this.currentFileIndex++;
            if(this.currentFileIndex<this.selectedFiles.length)
            	uploadNextFile(this.currentFileIndex);
        }        
        private function securityErrorHandler(event:SecurityErrorEvent):void 
        {
        	var newError:String = "securityErrorHandler: " + event
        	generateErrorOutput(newError);
        	var percentLoaded:Number = 0;
			this.uploadProgress = 0;
			this.currentFileIndex++;
            if(this.currentFileIndex<this.selectedFiles.length)
            	uploadNextFile(this.currentFileIndex);
        }
		private function uploadCompleteDataHandler(event:DataEvent):void
		{
			this.uploadProgress = 1; 		
			var file:FileReference = event.target as FileReference;
			var d:XML = XML(event.data);
			resumeFileUploadComplete(d.filename.toString(),d.thumb.toString(),d.video_proxy.toString());
		}
		private function progressHandler(event:ProgressEvent):void
		{
			var newError:String = Number(event.bytesLoaded/event.bytesTotal).toString();
            generateErrorOutput(newError);
			this.bytesLoaded = event.bytesLoaded;
			this.bytesTotal = event.bytesTotal;
			var percentLoaded:Number = event.bytesLoaded/event.bytesTotal;
			this.uploadProgress = percentLoaded;
		}											
	}
}