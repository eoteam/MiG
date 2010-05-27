package org.mig.view.interfaces
{
	import org.mig.model.vo.ContentNode;
	
	
	/**
	 * All content views which are used to represent content in the
	 * application need to implement this interface.
	 */
	public interface IContentView
	{
		function set content(value:ContentNode):void;
		
		function get content():ContentNode;
		
	}
}