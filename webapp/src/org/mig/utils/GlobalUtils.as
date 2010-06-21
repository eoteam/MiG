package org.mig.utils
{

	
	import com.appdivision.view.container.FlowContainer;
	
	import flash.display.StageDisplayState;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.collections.ArrayList;
	import mx.controls.TextInput;
	import mx.core.ClassFactory;
	import mx.core.UIComponent;
	
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.app.CustomField;
	import org.mig.model.vo.app.CustomFieldTypes;
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.model.vo.media.FileNode;
	import org.mig.view.controls.DataCheckBox;
	import org.mig.view.controls.DateTimePicker;
	import org.mig.view.controls.MiGTLFTextArea;
	import org.mig.view.controls.colorPicker;
	import org.mig.view.renderers.CustomFieldListCheckBox;
	
	import spark.components.CheckBox;
	import spark.components.DropDownList;
	import spark.components.List;
	import spark.components.TextArea;

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
			
			var output:String = '';
			if(input!= '')
				output = input.replace(new RegExp("[^a-zA-Z 0-9]+", "g"), "").replace(new RegExp("\\s+","g"), "-").toLowerCase();
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
		
		public static function createCustomField(vo:ContentData,customfield:CustomField):UIComponent {		
			var option:Object;
			var child:UIComponent;
			switch(customfield.typeid)
			{
				case CustomFieldTypes.BINARY:
					child = new CheckBox();
					CheckBox(child).selected = vo[customfield.name] == "true"?true:false;
				break; 
				
				case CustomFieldTypes.SELECT:
					child = new DropDownList();
					child.width = 300;
					DropDownList(child).labelField = "value";
					DropDownList(child).styleName = "comboBoxBlack";
					DropDownList(child).dataProvider = new ArrayList(customfield.optionsArray);
					for each(option in customfield.optionsArray) {
					if(option.index.toString() == vo[customfield.name]) {
						DropDownList(child).selectedItem = option;
						break;
					}
				}
				break;
				
				case CustomFieldTypes.STRING:
					child = new TextInput();
					child.styleName = "inputFieldBlack";
					child.percentWidth = 100;
					TextInput(child).text = vo[customfield.name].toString(); 
				break;
				
				case CustomFieldTypes.HTML_TEXT:
					child = new MiGTLFTextArea();
					MiGTLFTextArea(child).htmlText = vo[customfield.name];
					child.percentWidth =100;
				break;
				
				case CustomFieldTypes.TEXT:
					child = new TextArea();
					TextArea(child).text = vo[customfield.name];
					TextArea(child).heightInLines = NaN;
					child.percentWidth = 100;
					child.styleName = "bodyCopy";
					child.setStyle("backgroundColor",0x0f0f0f);	
				break;					
				
				case CustomFieldTypes.COLOR:
					child = new colorPicker();
					colorPicker(child).selectedColor= Number(vo[customfield.name]);				
				break;
				
				case CustomFieldTypes.MULTIPLE_SELECT:
					child = new FlowContainer();
					child.percentHeight=100;
					child.percentWidth=100;
					for each(option in customfield.optionsArray)
					{
						var checkBox:DataCheckBox = new DataCheckBox();
						checkBox.label = option.value;
						checkBox.data = option;
						child.addChild(checkBox);
						if(vo[customfield.name].toString().search(option.value) != -1)
							checkBox.selected = true;
					}
				break;
				
				case CustomFieldTypes.INTEGER:
					child = new TextInput();
					child.styleName = "inputFieldBlack";
					child.percentWidth = 100;
					TextInput(child).restrict="0-9\\-";
					TextInput(child).text = vo[customfield.name];						
				break;				
				
				case CustomFieldTypes.DATE:
					child = new DateTimePicker();
					if(vo[customfield.name].toString() != '')
					{
						var date:Date = new Date();
						date.time = Number(vo[customfield.name].toString());
						DateTimePicker(child).selectedDate = date;
					}
					else
						DateTimePicker(child).selectedDate = new Date();
					
				break;
				
				case CustomFieldTypes.FILE_LINK:
					child = new TextInput();
					child.styleName = "inputFieldBlack";
					child.percentWidth = 100;			
					TextInput(child).text = vo[customfield.name];						
				break;	
				
				case CustomFieldTypes.MULTIPLE_SELECT_WITH_ORDER:
					var dp:ArrayList = new ArrayList();
					var summary:String = '';
					if(vo[customfield.name].toString() != '')
					{
						var selected:Array = vo[customfield.name].toString().split(',');
						for each(var index:String in selected)
						{
							var item:Object = customfield.optionsArray[Number(index)-1];
							item.selected = true;
							dp.addItem(item);
							summary += item.value+', ';
						}
					}
					for each(item in customfield.optionsArray)
					{
						if(dp.getItemIndex(item) == -1)
						{
							dp.addItem(item);
							item.selected = false;
						}
					}
					child = new List();
					child.percentHeight = 100;
					child.width = 300;
					List(child).styleName = 'customFieldsList';
					List(child).dataProvider = dp;
					List(child).labelField = "value";
					List(child).allowMultipleSelection = true;
					List(child).dragMoveEnabled = true;
					List(child).dragEnabled = true;
					List(child).dropEnabled = true;	
					var optionRenderer:ClassFactory = new ClassFactory(CustomFieldListCheckBox);
					List(child).itemRenderer = optionRenderer;
				break;							
			}
			return child;
		}
		
	}
}