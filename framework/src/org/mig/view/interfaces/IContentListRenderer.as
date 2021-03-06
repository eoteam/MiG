package org.mig.view.interfaces
{
	
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.relational.ContentMedia;
	
	public interface IContentListRenderer // purely visual operations.
	//the DragTile should stop managing components state and just do layout, the parenting list will deal with the 
	//data provider and do CRUDS on model and then tell DragTile to refresh
	{
		function set added(value:Boolean):void
		
		function set selected(value:Boolean):void;
		
		function get added():Boolean;
		
		function get selected():Boolean;
		
		function dispatchSelectedEvent():void;
		
		function dispatchInfoOpenedEvent():void;
		
		function get selectionColor():uint;

		function set url(value:String):void;
		
		function set data(value:Object):void;
	}
}