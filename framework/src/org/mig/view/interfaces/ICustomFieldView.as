package org.mig.view.interfaces
{
	import mx.core.IUIComponent;
	import mx.core.IVisualElementContainer;
	
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.app.CustomField;

	public interface ICustomFieldView extends IUIComponent,IVisualElementContainer
	{
		function set vo(value:ContentData):void;
		
		function get vo():ContentData;
		
		function set customfield(value:CustomField):void;
		
		function get customfield():CustomField;
	}
}