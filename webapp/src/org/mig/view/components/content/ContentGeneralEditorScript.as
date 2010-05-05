import com.map.controller.ControllerLocator;
import com.map.event.ContentNodeEvent;
import com.map.model.ContentDataVO;
import com.map.model.ContentNode;
import com.map.model.CustomField;
import com.map.model.SubContainerNode;
import com.map.model.UserPrivileges;
import com.map.view.Tools;
import com.mapx.model.ContentVO;
import com.mapx.view.content.ContentTrayItem;
import com.mapx.view.content.trays.ThumbView;
import com.mapx.view.content.trays.TrayBase;
import com.mapx.view.content.trays.TrayItemBase;

import flash.utils.ByteArray;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.core.Application;
import mx.events.DragEvent;
import mx.managers.DragManager;
import flashx.textLayout.conversion.TextConverter;

[Bindable] private var _data:ContentVO;
[Bindable] private var _editedData:ContentDataVO;
[Bindable] private var cat:String;
[Bindable] private var _color:Number;
[Bindable] private var _date:Date;
[Bindable] private var _content:ContentNode;
private var thumbnail:Canvas;
private var traysArray:Array;
private var customfields:Array;

private var descriptionChanged:Boolean = false;
private var shortdescriptionChanged:Boolean = false;

private function handleCreationComplete():void
{				
	initiateTools();
	traysArray = new Array();
	if(_content.privileges == UserPrivileges.Admin || _content.privileges == UserPrivileges.Writer1 ||  _content.privileges == UserPrivileges.Writer2)
	{
		//submitButton.enabled = true;
	}
	else
	{
		//submitButton.enabled = false;
		//sectionText.editable = false;
		//sectionText.selectable = false;
	}
	var trays:XMLList = _content.config.tray;
	for each (var tray:XML in trays)
	{
		var contentTrayItem:ContentTrayItem = new ContentTrayItem();
		var queryData:Object = new Object();
		var queryVars:Array = String(tray.@vars).split(",");
		
		for each(var queryVar:String in queryVars)
		{
			if(queryVar == "contentid")
				queryData[queryVar] = _content.data.id.toString();
			else if(queryVar == "templateid")
				queryData[queryVar] = tray.@templateids.toString();	
			else if(queryVar == "usage_type")
				queryData[queryVar] = tray.@usage_type.toString();
			else
				queryData[queryVar] = _content.data[queryVar].toString();
		}
		var data:XML = <result></result>;
		data.appendChild(XML("<id>"+_content.data.id.toString() + "</id>"));		
		contentTrayItem.content = new SubContainerNode(tray.@name, tray, data, _content, queryData,_content.privileges,true);
		contentTrayItem.height = 30;
		contentTrayItem.percentWidth = 90; 
		mainContainer.addChild(contentTrayItem);		
		traysArray.push(contentTrayItem);						
	}
	this.sectionText.format = ControllerLocator.controller.textFormat;
	this.sectionText2.format = ControllerLocator.controller.textFormat;
	var cf:ArrayCollection = ControllerLocator.controller.customfields;
	cf.filterFunction = filterByTemplate;
	cf.refresh();
	var sort:Sort = new Sort();
	sort.fields = [new SortField("displayorder",false,false,true)];
	cf.sort = sort;
	cf.refresh();	
	customfields = [];
	for each(var field:CustomField in cf)
	{
		var cfElement:CustomFieldElement = new CustomFieldElement();
		cfElement.field = field;
		cfElement.vo = _data;
		mainContainer.addChild(cfElement);
		customfields.push(cfElement);
	}
	cf.filterFunction = null;
	cf.refresh();
	cat = ControllerLocator.controller.contentModel.config.@root;
	if(_content.config.attribute("formatShortDesc").length() > 0 &&  _content.config.@formatShortDesc.toString() == '1')
	{
		sectionText2.format = TextConverter.PLAIN_TEXT_FORMAT;
	}
}
public function set content(contentNode:ContentNode):void
{
	_content = contentNode;
	_data = new ContentVO(_content.data);
	_editedData = new ContentDataVO(_content.data.id.toString());
	descriptionChanged = shortdescriptionChanged = false;
	_content.addEventListener(ContentNodeEvent.DATA_UPDATED,handleUpdated);	
	_color = Number(_data.color);
	if(_data.date != '0')
	{
		_date = new Date();
		_date.time = Number(_data.date);
	}
	else
		_date = null;
}
private function handleUpdated(event:ContentNodeEvent):void
{
	_data = new ContentVO(_content.data);
	_editedData = new ContentDataVO(_content.data.id.toString());
	for each(var field:CustomFieldElement in this.customfields)
	{
		field.modified = false;
		field.vo = _data;
	}
}
public function get content():ContentNode
{
	return _content;
}
private function initiateTools():void 
{
	var tools:Tools = Tools(Application.application.mainView.editorsView);
	if(descTray.currentState == "open" || descTray2.currentState == "open")
		tools.instantiateToolSet(["Browse","Preview","Metadata","Upload","Text"]);
	else
		tools.instantiateToolSet(["Browse","Preview","Metadata","Upload"]);
}
private function handleDescriptionChange():void
{
	descriptionChanged = true;
	_editedData._edited = true;
}	
private function handleShortdescriptionChange():void
{
	shortdescriptionChanged = true;
	_editedData._edited = true;
}
private function handleTitleChange():void
{
	_editedData.title = sectionTitle.text;			
	_editedData._edited = true;	
}
private function handleUrlChange():void
{
	_editedData.url = url.text;	
	_editedData._edited = true;			
}	
private function handleColorChange():void
{
	_editedData.color =  mythemeColorapplication.selectedColor.toString(16);
	_editedData._edited = true;				
}
private function handleDateChange():void	
{
	if(dateField.selectedDate)
		_editedData.date = dateField.selectedDate.time;	
	else
		_editedData.date = ' ';
	_editedData._edited = true;			
}
public function submit(statusid:int=0):void
{
	for each(var field:CustomFieldElement in customfields)
	{
		if(field.modified)
		{
			//var value:String = "<customfield"+field.field.fieldid+"><![CDATA["+_data[field.field.fieldname]+ "]"+"]></customfield"+field.field.fieldid+">";
			_editedData["customfield"+field.field.fieldid] = _data[field.field.fieldname];
			_editedData._edited = true;		
		}
	}	
	if(statusid != _data.statusid)
		_editedData._edited = true;		
	if(edited)
	{
		XML.prettyPrinting = false;
		//´XML.ignoreWhitespace = true;
		if(descriptionChanged) {
			sectionText.commit();
			_editedData.description = sectionText.htmlText;
			if(ControllerLocator.controller.htmlRendering)
				_editedData.description2 = sectionText.xhtmlText;
			else
				_editedData.description2 = '';
		}
		if(shortdescriptionChanged) {
			var shortDesc:String;
			sectionText2.commit();
			if(_content.config.attribute("formatShortDesc").length() > 0 )
			{
				if(_content.config.@formatShortDesc.toString() == "1")
					shortDesc = sectionText2.htmlText;
				else
					shortDesc = sectionText2.text;
			}
			else	
				shortDesc = sectionText2.htmlText;
			
			_editedData.shortdescription = shortDesc;
			if(ControllerLocator.controller.htmlRendering)
				_editedData.shortdescription2 = sectionText2.xhtmlText;
			else
				_editedData.shortdescription2 = '';
		}
		if(statusid != 0)
			_editedData.statusid = statusid	

		var modDate:Date = new Date();
		var userId:int =  Application.application.user.id;
		
		_editedData.modifieddate = modDate.time;
		_editedData.modifiedby = userId;
		XML.ignoreWhitespace = true;
		_content.updateData(_editedData);
	}
	
}
public function get edited():Boolean
{
	return _editedData._edited;
	//{
	
	//}
	/* 	if(!compareContent(_data,_editedData))
	return true;
	else
	{
	for each(var tray:ContentTrayItem in traysArray)
	{
	if(tray.edited)
	{
	result = true;
	break;
	}
	}
	
	} */
	
}
public function set edited(value:Boolean):void
{
	
}
private function compareContent(obj1:Object,obj2:Object):Boolean
{
	var buffer1:ByteArray = new ByteArray();
	buffer1.writeObject(obj1);
	var buffer2:ByteArray = new ByteArray();
	buffer2.writeObject(obj2);
	
	// compare the lengths
	var size:uint = buffer1.length;
	if (buffer1.length == buffer2.length) {
		buffer1.position = 0;
		buffer2.position = 0;
		
		// then the bits
		while (buffer1.position < size) {
			var v1:int = buffer1.readByte();
			if (v1 != buffer2.readByte()) {
				return false;
			}
		}    
		return true;                        
	}
	return false;
}
private var formats:Array = ["tag","link","user","thumbNail"];	
private function handleDragEnter(event:DragEvent):void
{	
	if(formats.indexOf(event.dragSource.formats[0]) != -1)
	{
		DragManager.showFeedback("copy");
		DragManager.acceptDragDrop(trashButton);
	}
}	
private function handleDragDrop(event:DragEvent):void
{
	if(event.dragSource.formats[0] == "thumbNail")
	{
		ThumbView(event.dragInitiator).deleteImage(null);
	}
	else
	{
		for each(var item:TrayItemBase in  TrayBase(event.dragInitiator).selectedItems)
		{
			item._content.removeData();
		}
	}
}
private function filterByTemplate(item:Object):Boolean
{
	if(item.templateid == _data.templateid)
		return true;
	else
		return false;
}
public function get viewname() : String
{
	return this.className
} 
public function showFunction():void
{
	this.initiateTools();
}
public function hideFunction():void
{
	
}		
private var  editorOpen:Boolean = false;
private function descTray_openHandler(event:Event):void
{
	if(event.target == this.descTray2 && sectionText2.format != TextConverter.TEXT_LAYOUT_FORMAT)
		return;
	var tools:Tools = Tools(Application.application.mainView.editorsView);
	tools.instantiateToolSet(["Browse","Preview","Metadata","Upload","Text"]);		
}
private function closeDescTray(event:Event):void
{
	if(this.descTray.isClosed && (this.descTray2.isClosed && sectionText2.format == TextConverter.TEXT_LAYOUT_FORMAT))
	{	
		var tools:Tools = Tools(Application.application.mainView.editorsView);
		tools.instantiateToolSet(["Browse","Preview","Metadata","Upload"]);	
	}
}