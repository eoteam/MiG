
import flash.events.Event;

import mx.core.Application;
import mx.core.FlexGlobals;
import mx.managers.PopUpManager;
import mx.managers.PopUpManagerChildList;

import org.mig.model.vo.ContentNode;
import org.mig.model.vo.content.ContainerNode;
import org.mig.model.vo.content.ContentData;
import org.mig.model.vo.media.MimeTypes;
import org.mig.model.vo.relational.ContentMedia;


public var thumbURL:String;

[Bindable] private var _content:ContentNode;
[Bindable] private var _data:ContentMedia;
[Bindable] private var imageSource:String;
[Bindable] private var _scalePercent:Number;


private var _added:Boolean = false;
private var _selected:Boolean = false;	
private var edited:Boolean = false;
private var bgColorSelected:uint;
private var bgColorUnselected:uint;
[Bindable] private var docIcon:Object;

public var info:EditFileResourceView;

[Embed(source='/migAssets/library.swf#youtubeIcon')]
private var youtubeIcon:Class;	

public function set url(value:String):void {
	thumbURL = value;
}
public function get selectionColor():uint
{
	return bgColorSelected;
}
public function set scalePercent(newVal:Number):void
{
	_scalePercent = newVal;
}
[Bindable]
public function get scalePercent():Number
{
	return _scalePercent;	
}
public var isImage:Boolean;
/*public function get fileExtension():String{
	return imageSource;
}*/
public function set content(value:ContentNode):void {
	_content = value;
	_data = _content.data as ContentMedia;

	if(_data.mimetypeid == MimeTypes.IMAGE) {
		imageSource = thumbURL+_data.path.toString()+_data.name.toString();
		isImage = true;
	}
	else if(_data.mimetypeid == MimeTypes.VIDEO && _data.thumb.toString() != '') {
		imageSource =thumbURL+_data.path.toString()+_data.thumb.toString();
		isImage = true;		
	}
	else
	{
		if(_data.mimetypeid == MimeTypes.YOUTUBE)
		{
			docIcon = youtubeIcon;
			imageSource = '';
		}
		else
		{
			docIcon="migAssets/images/docIcon.png";
		}
		isImage = false;	
	}	
	if(imageHolder != null)
		imageHolder.source = imageSource;
	if(imageName != null)
		imageName.text = _data.name.toString();	
}
private function handleCreationComplete():void
{
	if(isImage == true) {
		dragCanvas.visible = false;
		imageHolder.visible = true;
	}
	else {
		imageHolder.visible = false;
		dragCanvas.visible = true;
	}
}
public function get content():ContentNode
{
	return _content;
}
public function set selected(value:Boolean):void
{
	_selected = value;
	if(!value)
	{
		this.setStyle("backgroundColor", bgColorUnselected);
		if(info)
		{
			PopUpManager.removePopUp(info);
			info = null;
		}
	}
	else
	{	
		this.setStyle("backgroundColor", bgColorSelected);
	}	
}
public function get selected():Boolean
{
	return _selected;
}
public function set added(value:Boolean):void
{
	_added = value;
	if(!_added)
	{
		bgColorUnselected = 0x444444;
		bgColorSelected = 0xF491A9;
		this.setStyle("backgroundColor", bgColorUnselected);
	}
	else
	{
		bgColorUnselected = 0x111111;
		bgColorSelected = 0xED1C58;		
		this.setStyle("backgroundColor", bgColorUnselected);
		
	}
}
public function get added():Boolean
{
	return _added;
}
public function dispatchInfoOpenedEvent():void
{
	info = new EditFileResourceView();
	info.bgColor = bgColorSelected;
	info.content = _content;
	info.file = this;
	info.x = FlexGlobals.topLevelApplication.mouseX-this.mouseX; 
	info.y = FlexGlobals.topLevelApplication.mouseY-this.mouseY+this.height;	
	PopUpManager.addPopUp(info,this,false,PopUpManagerChildList.POPUP);
}
public function dispatchSelectedEvent():void
{
	this.dispatchEvent(new Event('selected'));
}
public function get viewname():String
{
	return "FileResourceView";
}	