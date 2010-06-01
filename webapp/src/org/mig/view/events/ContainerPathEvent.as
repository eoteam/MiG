package org.mig.view.events
{
	import flash.events.Event;
	
	import org.mig.model.vo.content.ContainerNode;
	
	public class ContainerPathEvent extends Event
	{
		public static const CONTAINER_SELECTED:String = "containerSelected";
		
		public var container:ContainerNode;
		public function ContainerPathEvent(type:String, container:ContainerNode)
		{
			this.container = container;
			super(type, false, false);
		}
	}
}