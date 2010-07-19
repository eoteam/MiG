import mx.effects.easing.Exponential;

import org.mig.view.skins.buttons.AddContainerButtonSkin;
import org.mig.view.skins.buttons.SearchButtonSkin;
import org.mig.view.skins.dropdowns.ComboBoxHeaderButtonSkin;
import org.mig.view.skins.dropdowns.DefaultComboBoxSkin;
[Embed(source='/migAssets/library.swf#Tree_folderClosedIcon')]
[Bindable] private var closeIcon:Class;

[Embed(source='/migAssets/library.swf#Tree_folderOpenIcon')]
[Bindable] private var openIcon:Class;

[Embed(source='/migAssets/library.swf#draftIconWhiteUp')]
[Bindable] public var draftIconWhite:Class;

[Embed(source='/migAssets/library.swf#mainBGLogo')]
[Bindable] public var bgLogo:Class;
private const SIDEBAR_CLOSED_WIDTH:Number = 18;
private const LEFT_SIDEBAR_OPEN_WIDTH:Number = 200;
private const RIGHT_SIDEBAR_OPEN_WIDTH:Number = 350;
private var _containerPanelVisible:Boolean = true;
private var _toolsPanelVisible:Boolean = true;
private var introLogo:MovieClip;

public var optionsComboPrompt:String;
public var helpComboPrompt:String = "Help"; 

private function handleCreationComplete():void {
	var c:Number = preloaderHolder.width > preloaderHolder.height ? preloaderHolder.height : preloaderHolder.height;
	var a:Number = Math.sqrt(c*c/2);
	preloaderHolder.x = (this.width +a)/2;
	preloaderHolder.y = (this.height+a)/2;
	pendingTree.visible = false;
}
public function set containerPanelVisible(newVal:Boolean):void {
	_containerPanelVisible = newVal;
	toggleContainerPanelVisible();
}
public function get containerPanelVisible():Boolean {
	return _containerPanelVisible;
}
private function toggleContainerPanelVisible():void {
	if(_containerPanelVisible == true) {
		containerPanelCollapseButton.selected = false;
		//hide/show tray content
		containerTray.visible = true;
		controlBox.visible = true;
	}
	else {
		containerPanelCollapseButton.selected = true;
		containerTray.visible = false;
		controlBox.visible = false;
	}
}
public function set toolsPanelVisible(newVal:Boolean):void {
	_toolsPanelVisible = newVal;
	toggleToolsPanelVisible();
}
public function get toolsPanelVisible():Boolean {
	return _toolsPanelVisible;
}
private function toggleToolsPanelVisible():void {
	if(_toolsPanelVisible == true) {
		toolsPanelCollapseButton.selected = false;
		//hide/show tray content
		//editorsView.visible = true;
	}
	else {
		toolsPanelCollapseButton.selected = true;
		//editorsView.visible = false;	
	}
}
private function logoCompleteHandler(event:Event):void {
	introLogo = MovieClip(mainLogo.content);		
	introLogo.play();
}
private function handleResize():void {
	if(preloaderHolder) {
		var c:Number = preloaderHolder.width > preloaderHolder.height ? preloaderHolder.height : preloaderHolder.height;
		var a:Number = Math.sqrt(c*c/2);
		preloaderHolder.x = (this.width +a)/2;
		preloaderHolder.y = (this.height+a)/2;
	}
}
private function handleSliderParentReSize(event:Event):void{
	//handle reaction to dragging from a closed state or 
	//to a closed state so that the arrow reflects this
	//for both sliders
	if(event.currentTarget.name=="pendingTray"){
		if (event.currentTarget.height > pendingTrayTitleHolder.height && pendingTree.visible == false){
			pendingTree.visible = true;
			pendingStateIcon.icon = openIcon;
			pendingStateIcon.invalidateSkinState();
		}
		else{
			if (event.currentTarget.height < pendingTrayTitleHolder.height){
				pendingTree.visible = false;
				event.currentTarget.height = pendingTrayTitleHolder.height;
				pendingStateIcon.icon = closeIcon;
				pendingStateIcon.invalidateSkinState();
			}
		}
	}
	else{
		if (event.currentTarget.width > SIDEBAR_CLOSED_WIDTH){
			event.currentTarget.visible = true;
			if(event.currentTarget.name=="leftMain"){containerPanelVisible = true;}
			else if(event.currentTarget.name=="rightMain"){toolsPanelVisible = true;}
			
		}
		else{
			if (event.currentTarget.width <= SIDEBAR_CLOSED_WIDTH){
				
				if(event.currentTarget.name=="leftMain"){containerPanelVisible = false;}
				else if(event.currentTarget.name=="rightMain"){toolsPanelVisible = false;}
				event.currentTarget.width = SIDEBAR_CLOSED_WIDTH;
			}
		} 
	}
}	
private function pendingTrayToggle(event:MouseEvent):void {
	if(pendingTree.visible == true) {
		closePendingTray.play();
		pendingTree.visible = false;
		pendingStateIcon.icon = closeIcon;
		pendingStateIcon.invalidateSkinState();
	}
	else {
		openPendingTray.play();
		pendingTree.visible = true;
		pendingStateIcon.icon = openIcon;
		pendingStateIcon.invalidateSkinState();
	}
}// ActionScript file