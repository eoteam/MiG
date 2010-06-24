package org.mig.view.interfaces
{
	import mx.core.IUIComponent;
	import mx.core.IVisualElementContainer;
	
	import org.mig.model.vo.ValueObject;
	import org.mig.model.vo.app.CustomField;

	public interface ICustomFieldView extends IUIComponent,IVisualElementContainer
	{
		function set vo(value:ValueObject):void;
		
		function get vo():ValueObject;
		
		function set customfield(value:CustomField):void;
		
		function get customfield():CustomField;
	}
}