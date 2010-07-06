package org.mig.view.events
{
	import flash.events.Event;
	
	public class ContentViewEvent extends Event
	{
		public static const PUBLISH:String = "submit";
		public static const DRAFT:String = "draft";
		public static const CANCEL:String = "cancel";
		public static const LOAD_CHILDREN:String = "loadChildren";
		public static const TITLE_CHANGED:String = "titleChanged";
		public static const CONTAINER_SELECTED:String = "containerSelected";
		public static const MEDIA_RATING_SELECTED:String = "mediaRatingSelected";
		public static const MEDIA_RATING_DESELECTED:String = "mediaRatingDeselected";
		
		public static const CUSTOMFIELD_DRAG_START:String = "customFieldDragStart";
		
		public var args:Array
		public function ContentViewEvent(type:String,...args)
		{
			this.args = args;
			super(type, false, false);
		}
	}
}