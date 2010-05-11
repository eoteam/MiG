import com.map.controller.ControllerLocator;
import com.map.model.ContentNode;
import com.greensock.TweenMax;
import com.greensock.easing.Expo;

import mx.core.Application;
import mx.managers.PopUpManager;
import mx.managers.PopUpManagerChildList;

override public function set enabled(value:Boolean):void
{
	super.enabled = value;
	if(value && created)
		initializePanel();
}
public function initializePanel():void
{
	if(!mediaManager.managerInitialized)
	{
		mediaManager.initializeManager();
		mediaManager.selectedContent = ControllerLocator.mediaManagerController.selectedContent;
	}		
}
[Bindable]
private var _scalePercent:Number = .4;

public function set scalePercent(newVal:Number):void
{
	_scalePercent = newVal;
}

[Bindable]
public function get scalePercent():Number
{
	return _scalePercent;	
}

private var created:Boolean = false;
private function handleCreationComplete():void
{
	TweenMax.to(thumbIcon, 0.5, {colorTransform:{tint:0xffffff, tintAmount:1}, ease:Expo.easeOut});
	TweenMax.to(listIcon, 0.5, {colorTransform:{tint:0xed1c58, tintAmount:1}, ease:Expo.easeOut});
	scaleSlider.alpha = 0.2;
	scaleSlider.mouseEnabled = false;
	scaleSlider.mouseChildren = false;	
	created = true;
}
private function handleSliderChange(event:Event):void
{
	scalePercent = scaleSlider.value;
}	
private function handleNewViewMode(viewType:String):void
{
	if(viewType == "thumb")
	{
		TweenMax.to(thumbIcon, 0.5, {colorTransform:{tint:0xed1c58, tintAmount:1}, ease:Expo.easeOut});
		TweenMax.to(listIcon, 0.5, {colorTransform:{tint:0xffffff, tintAmount:1}, ease:Expo.easeOut});
		scaleSlider.visible = true;
	}
	else
	{
		TweenMax.to(thumbIcon, 0.5, {colorTransform:{tint:0xffffff, tintAmount:1}, ease:Expo.easeOut});
		TweenMax.to(listIcon, 0.5, {colorTransform:{tint:0xed1c58, tintAmount:1}, ease:Expo.easeOut});
		scaleSlider.visible = false;
	}
}	
public function resetTool():void
{
	TweenMax.to(thumbIcon, 0.5, {colorTransform:{tint:0xffffff, tintAmount:1}, ease:Expo.easeOut});
	TweenMax.to(listIcon, 0.5, {colorTransform:{tint:0xed1c58, tintAmount:1}, ease:Expo.easeOut});
	scaleSlider.alpha = 0.2;
	scaleSlider.mouseEnabled = false;
	scaleSlider.mouseChildren = false;
	mediaManager.selectedIndex= 0;
}	
private function handleViewMouseDown(event:MouseEvent, index:int):void
{
	if(index != mediaManager.selectedIndex)
	{
		if(index == 1)
		{
			TweenMax.to(thumbIcon, 0.5, {colorTransform:{tint:0xed1c58, tintAmount:1}, ease:Expo.easeOut});
			TweenMax.to(listIcon, 0.5, {colorTransform:{tint:0xffffff, tintAmount:1}, ease:Expo.easeOut});
			scaleSlider.alpha = 1;
			scaleSlider.mouseChildren = true;
			scaleSlider.mouseEnabled = true;
			mediaManager.selectedIndex= 1;
		}
		else
		{
			TweenMax.to(thumbIcon, 0.5, {colorTransform:{tint:0xffffff, tintAmount:1}, ease:Expo.easeOut});
			TweenMax.to(listIcon, 0.5, {colorTransform:{tint:0xed1c58, tintAmount:1}, ease:Expo.easeOut});
			scaleSlider.alpha = 0.2;
			scaleSlider.mouseEnabled = false;
			scaleSlider.mouseChildren = false;
			mediaManager.selectedIndex= 0;
		}
	}
}
private function handleAddDirectoryDown():void
{
	var newContentNode:ContentNode = ContentNode(ControllerLocator.mediaManagerController.selectedContent);
	if (newContentNode != null && newContentNode.config.@addDirectoryView.length() > 0)
	{
		var contentView:AddDirectoryView = PopUpManager.createPopUp(DisplayObject(Application.application), 
											Class(getDefinitionByName(newContentNode.config.@addDirectoryView)), 
											false,PopUpManagerChildList.POPUP) as AddDirectoryView;
		contentView.content = newContentNode;
		PopUpManager.centerPopUp(contentView);
	} 
}
[Bindable] private var _currentLocation:String;
public function set currentLocationArray(value:Array):void
{
	if(value)
	{
		value.reverse();
		_currentLocation = "<font color='#999999'>/ ";
		var numItems:int = value.length - 1;	
		for(var i:int = 0; i < value.length; i++)
		{
			if(i < value.length-1)
			{
				_currentLocation += value[numItems - i] + " / ";
			}
			else if( i == value.length-1)
			{
				_currentLocation += "</font><font color='#FFFFFF'>"+ value[numItems - i] + "</font> ";
			}
		}
	}
}	
private function search(value:String):void
{
	if(value != '')	
	{
		parentDirIcon.mouseEnabled = addDirectoryIcon.mouseEnabled = false;
		parentDirIcon.alpha = addDirectoryIcon.alpha = 0.5;
		mediaManager.search(value);
	}
	else
	{
		if(mediaManager.searchMode)
		{
			searchInput.text = '';
			mediaManager.search(value);
		}
		parentDirIcon.mouseEnabled = addDirectoryIcon.mouseEnabled = true;
		parentDirIcon.alpha = addDirectoryIcon.alpha = 1;
	}
}