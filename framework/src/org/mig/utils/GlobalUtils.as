package org.mig.utils
{

	
	import flash.display.StageDisplayState;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.core.UIComponent;
	
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.model.vo.media.FileNode;

	public class GlobalUtils //implements IGlobalUtils
	{
		public static function createContextMenu(titles:Array,itemCallBack:Function,menuCallback:Function,targets:Array):Object {
			 return createFlexMenu(titles,itemCallBack,menuCallback,targets);
		}
		private static function createFlexMenu(titles:Array,itemCallBack:Function,menuCallback:Function,targets:Array):ContextMenu {
			var menu:ContextMenu = new ContextMenu();
			menu.hideBuiltInItems();
			for each(var title:String in titles) {
				var menuItem:ContextMenuItem = new ContextMenuItem(title);
				menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemCallBack);
				menu.customItems.push(menuItem);
			}
			if(menuCallback != null)
				menu.addEventListener(ContextMenuEvent.MENU_SELECT, menuCallback);
			for each(var target:UIComponent in targets)
				target.contextMenu = menu;
			return menu;
		}
		public function get uploadView():String {
			return "com.map.view.mediaManager.FileUpload";	
		}
		public function get fullScreenMode():String {
			return StageDisplayState.FULL_SCREEN;
		}
		public static function sanitizeString(input:String):String {
			var output:String = input.replace(new RegExp("[^a-zA-Z 0-9]+", "g"), "").replace(new RegExp("\\s+","g"), "-").toLowerCase();
			return output;
		}
		public static function accumulateChildren(content:ContentNode,arr:Array):void {
			arr.push(content);
			addChildren(content,arr);
		}
		public static function accumulateFiles(directory:DirectoryNode,arr:Array):void {
			addMediaChildren(directory,arr);
		}
		private static function addChildren(node:ContentNode,arr:Array):void {
			if(node.children) {
				for each(var item:ContentNode in node.children) {
					arr.push(item);
					addChildren(item,arr);
				}
			}
		}
		private static function addMediaChildren(node:DirectoryNode,arr:Array):void {
			if(node.children) {
				for each(var item:ContentNode in node.children) {
					if(item is FileNode)
						arr.push(item);
					else
						addMediaChildren(item as DirectoryNode,arr);
				}
			}
		}		
	}
}