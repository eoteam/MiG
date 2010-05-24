package org.mig.events
{
	import flash.events.Event;
	
	public class ViewEvent extends Event
	{
		public static const RESIZE_MANAGER_TREE:String = "resizeManagerTree";
		public static const MANAGER_SELECTED:String = "managerSelected";
		
		public static const REFRESH_MEDIA:String = "refreshMedia";
		public static const REFRESH_CONTENT:String = "refreshContent";
		
		public static const FILE_DOWNLOAD_PROGRESS:String = "fileDownloadProgress";
		public static const FILE_DOWNLOAD_CANCEL:String = "fileDownloadCancel";
		
		public static const DELETE_CONTAINERS:String = "deleteContainers";
		
		public static const ENABLE_CONTENT_TREE:String = "enableContentTree";
		
		public var args:Array;
		
		public function ViewEvent(type:String,...args)
		{
			this.args = args;
			super(type, true, true);
		}
		override public function clone() : Event
		{
			return new ViewEvent(this.type,this.args);
		}
	}
}