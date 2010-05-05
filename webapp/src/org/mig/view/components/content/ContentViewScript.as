import com.map.event.ApplicationEvent;
import com.map.model.ContentNode;
import com.map.model.SubContainerNode;
import com.map.utils.ClassUtils;
import com.map.view.content.IContentView;
import com.map.view.content.IEditableContentView;
import com.mapx.event.ContentDataEvent;
import com.mapx.event.ContentViewEvent;
import com.map.event.EventBus;
import com.mapx.view.content.tabs.ITabView;

import flash.display.DisplayObject;

import mx.events.IndexChangedEvent;
		

[Bindable]
private var _content:ContentNode;

public var isset:Boolean = false;
public function set content(contentNode:ContentNode):void
{
	_content = contentNode;
}
public function get content():ContentNode
{
	return _content;
}			
private function handleChange(event:IndexChangedEvent):void
{
	var selectedTabItem:Object = contentTabs.getChildAt(event.newIndex);	
	var selectedContentView:IContentView;
	if(selectedTabItem.className == "ContentTabItem")
	{
		if(ContentTabItem(selectedTabItem).configured == false)
		{
			ContentTabItem(selectedTabItem).configureContentTab();
		}
		else
		{
			ContentTabItem(selectedTabItem).enableView();
			selectedContentView = IContentView(ContentTabItem(selectedTabItem).getChildAt(0));
		}
	}
	else if(event.newIndex == 0 && generalEditor is ITabView)
		ITabView(generalEditor).showFunction();
}
private var generalEditor:IEditableContentView;

public function get viewname():String
{
	return "Main";
}
/* private function handleCompareButton():void
{
	EventBus.getInstance().dispatchEvent(new ContentDataEvent(ContentDataEvent.COMPARE_COMMAND,null));
	var status:int = this.edited? 1:0;
	EventBus.getInstance().dispatchEvent(new ContentDataEvent(ContentDataEvent.COMPARE_RESULT,this,status));	
} */
public function get edited():Boolean
{
	var edited:Boolean = false;
	if(generalEditor.edited)
		return true;
	else
	{
		for each(var view:ContentTabItem in contentTabs)
		{
			if(view.edited)
			{
				edited = true;
				break;
			}
		}
		return edited;
	}
}
public function set edited(value:Boolean):void
{
	
}
public function submit(statusid:int=0):void
{
	generalEditor.submit(statusid);
	EventBus.getInstance().dispatchEvent(new ContentDataEvent(ContentDataEvent.SUBMIT,this,statusid,false));
}				