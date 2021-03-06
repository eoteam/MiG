package org.mig.utils
{

	
	import com.appdivision.view.container.FlowContainer;
	
	import flash.display.StageDisplayState;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	import mx.formatters.DateFormatter;
	import mx.managers.DragManager;
	
	import org.mig.model.AppModel;
	import org.mig.model.UserModel;
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.ValueObject;
	import org.mig.model.vo.app.CustomField;
	import org.mig.model.vo.app.CustomFieldOption;
	import org.mig.model.vo.app.CustomFieldTypes;
	import org.mig.model.vo.media.DirectoryNode;
	import org.mig.model.vo.media.FileNode;
	import org.mig.view.components.managers.customfields.CustomFieldListCheckBox;
	import org.mig.view.controls.DataCheckBox;
	import org.mig.view.controls.DateTimePicker;
	import org.mig.view.controls.LinkSocket;
	import org.mig.view.controls.MiGColorPicker;
	import org.mig.view.controls.MiGTLFTextArea;
	import org.mig.view.interfaces.ICustomFieldView;
	import org.mig.view.layouts.FlowLayout;
	
	import spark.components.CheckBox;
	import spark.components.DropDownList;
	import spark.components.List;
	import spark.components.TextArea;
	import spark.components.TextInput;
	import spark.layouts.VerticalLayout;
	
	
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
		public static function get uploadView():String {
			return "com.map.view.mediaManager.FileUpload";	
		}
		public static function get fullScreenMode():String {
			return StageDisplayState.FULL_SCREEN;
		}
		public static function sanitizeString(input:String):String {
			
			var output:String = '';
			if(input!= '')
				output = input.replace(new RegExp("[^a-zA-Z 0-9]+", "g"), "").replace(new RegExp("\\s+","g"), "_").toLowerCase();
			return output;
		}
		public static function createSlug(input:String):String {
			
			var output:String = '';
			if(input!= '')
				output = input.replace(new RegExp("[^a-zA-Z 0-9]+", "g"), "").replace(new RegExp("\\s+","g"), "-").toLowerCase();
			return output;
		}		
		
		public static function tranlateSize(size:Number):String {
			var label:String = '';
			if (size < 1024)
				label = size + " B";
			else if ((size > 1024) && (size < 1048576))
				label = Math.round(size / 1024).toString() + " KB";
			else if (size > 1048576)
				label = Math.round(size / 1048576).toString() + " MB";	
			
			return label;	
		}
		public static function translateUser(userid:int):String {
		return "";//userModel.findUserById(userid).toString()
		}
		public static function translateDate(value:Number,format:String=null):String {
			var d:Date = new Date();
			d.time = value*1000;
			dateFormatter.formatString = "MM/DD/YY";
			if(format)
				dateFormatter.formatString = format;
			return dateFormatter.format(d);
		}
		public static function accumulateParents(content:ContentNode,arr:Array):void {
			arr.push(content);
			if(content.parentNode) {
				accumulateParents(content.parentNode,arr);
			}
		}
		public static function accumulateChildren(content:*,arr:Array):void {
			arr.push(content);
			addChildren(content,arr);
		}
		public static function accumulateFiles(directory:DirectoryNode,arr:Array):void {
			addMediaChildren(directory,arr);
		}
		private static function addChildren(node:*,arr:Array):void {
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
		private static var dateFormatter:DateFormatter = new DateFormatter();
		public static function createCustomField(container:ICustomFieldView):Array {		
			var customfield:CustomField = container.customfield;
			var vo:ContentData = container.vo; 
			var option:Object;
			var child:UIComponent;
			var item:CustomFieldOption;
			var optionRenderer:ClassFactory
			var summary:String = '';
			var selected:Array;
			var index:String;
			dateFormatter.formatString = "MM/DD/YY";
			var layout:VerticalLayout = new VerticalLayout;
			layout.gap = 2;
			switch(customfield.typeid) {
				case CustomFieldTypes.BINARY:
					child = new CheckBox();
					if(vo && vo[customfield.name]) {
						CheckBox(child).selected = vo[customfield.name] == "true"?true:false;
						summary = vo[customfield.name].toString();
					}
				break; 
				
				case CustomFieldTypes.SELECT:
					child = new DropDownList();
					DropDownList(child).labelField = "value";
					DropDownList(child).styleName = "comboBoxBlack";
					DropDownList(child).dataProvider = customfield.optionsArray;
					child.width = 180;
					if(vo && vo[customfield.name]) {
						for each(option in customfield.optionsArray.source) {
						if(option.index.toString() == vo[customfield.name]) {
							DropDownList(child).selectedItem = option;
							summary = option.value;
							break;
						}
					}
				}
				break;
				
				case CustomFieldTypes.STRING:
					child = new TextInput();
					child.styleName = "inputFieldBlack";
					child.percentWidth = 100;
					if(vo && vo[customfield.name]) {
						TextInput(child).text = vo[customfield.name].toString(); 
						summary = vo[customfield.name].toString().slice(0,150)+'...';
					}
				break;
				
				case CustomFieldTypes.HTML_TEXT:
					child = new MiGTLFTextArea();
					child.percentWidth = 100;
					child.minHeight = 300;
					child.percentHeight = 100;
					if(vo && vo[customfield.name]) {
						MiGTLFTextArea(child).htmlText = vo[customfield.name];
						summary = vo[customfield.name].toString().slice(0,150)+'...';
					}
				break;
				
				case CustomFieldTypes.TEXT:
					child = new TextArea();
					TextArea(child).heightInLines = NaN;
					TextArea(child).addEventListener(FlexEvent.UPDATE_COMPLETE,handleTextAreaUpdate,false,0,true);
					TextArea(child).maxHeight = 300;
					child.styleName = "bodyCopy";
					child.setStyle("backgroundColor",0);
					child.percentWidth = 100;
					if(vo && vo[customfield.name]) {
						TextArea(child).text = vo[customfield.name];
						summary = vo[customfield.name].toString().slice(0,150)+'...';
					}
				break;					
				
				case CustomFieldTypes.COLOR:
					child = new MiGColorPicker();
					if(vo && vo[customfield.name]) {
						MiGColorPicker(child).selectedColor =  Number('0x'+vo[customfield.name].substr(1,vo[customfield.name].length));	
						summary = vo[customfield.name];
					}
				break;
				
				case CustomFieldTypes.MULTIPLE_SELECT:
					if(vo) {
						customfield.optionsArray.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleListChange,false,0,true);
						for each(item in customfield.optionsArray.source)
							item.vo = vo;
					}					
					if(vo && vo[customfield.name] && vo[customfield.name].toString() != '') {
						selected = vo[customfield.name].toString().split(',');
						for each(index in selected) {
							item = customfield.optionsArray.getItemAt(Number(index)-1) as CustomFieldOption;
							item.selected = true;
							summary += item.value+', ';
						}
						summary = summary.substring(0,summary.length-2);
					}
										
					child = new List();
					//child.percentHeight = 100;
					child.percentWidth = 100;
					List(child).styleName = 'customFieldsList';
					List(child).dataProvider = customfield.optionsArray;
					List(child).labelField = "value";
					//var flowLayout:FlowLayout = new FlowLayout();
					//flowLayout.clipAndEnableScrolling = false;
					List(child).layout = layout;
					optionRenderer = new ClassFactory(CustomFieldListCheckBox);						
					List(child).itemRenderer = optionRenderer;
					List(child).addEventListener(FlexEvent.CREATION_COMPLETE,handleListCreationComplete,false,0,true);
					//BindingUtils.bindProperty(List(child),"height",flowLayout,"runningHeight");
					//BindingUtils.bindProperty(container,"height",flowLayout,"runningHeight");
				break;
				
				case CustomFieldTypes.INTEGER:
					child = new TextInput();
					child.styleName = "inputFieldBlack";
					TextInput(child).restrict="0-9\\-";
					child.percentWidth = 100;
					if(vo && vo[customfield.name]) {
						TextInput(child).text = vo[customfield.name];	
						summary = vo[customfield.name].toString().slice(0,150)+'...';
					}
				break;				
				
				case CustomFieldTypes.DATE:
					child = new DateTimePicker();
					if(vo && vo[customfield.name] && vo[customfield.name].toString() != '')
					{
						var date:Date = new Date();
						date.time = Number(vo[customfield.name].toString())*1000;
						DateTimePicker(child).selectedDate = date;
						summary =  dateFormatter.format(date);	
					}
					else
						DateTimePicker(child).selectedDate = new Date();
					
				break;
				
				case CustomFieldTypes.FILE_LINK:
					child = new TextInput();
					child.styleName = "inputFieldBlack";	
					child.percentWidth = 100;
					if(vo && vo[customfield.name]) {
						TextInput(child).text = vo[customfield.name];
						summary = vo[customfield.name].toString().slice(0,150)+'...';
					}
				break;	
				
				case CustomFieldTypes.MULTIPLE_SELECT_WITH_ORDER:
					if(vo) {
						customfield.optionsArray.addEventListener(CollectionEvent.COLLECTION_CHANGE,handleListChange,false,0,true);
						for each(item in customfield.optionsArray.source) 		
							item.vo = vo;						
					}	
					if(vo && vo[customfield.name] && vo[customfield.name].toString() != '')
					{
						selected = vo[customfield.name].toString().split(',');
						for each(index in selected)
						{
							item = customfield.optionsArray.getItemAt(Number(index)-1) as CustomFieldOption;
							item.selected = true;
							summary += item.value+', ';
						}
						summary = summary.substring(0,summary.length-2);
					}	
					child = new List();
					//child.percentHeight = 100;

					child.percentWidth = 100;
					List(child).styleName = 'customFieldsList';
					List(child).dataProvider = customfield.optionsArray;
					List(child).labelField = "value";
					List(child).allowMultipleSelection = true;
					List(child).dragMoveEnabled = true;
					List(child).dragEnabled = true;
					List(child).dropEnabled = true;
					List(child).layout = layout;
					List(child).addEventListener(DragEvent.DRAG_EXIT,checkDrag,false,0,true);
					List(child).addEventListener(DragEvent.DRAG_ENTER,checkDrag,false,0,true);
					optionRenderer = new ClassFactory(CustomFieldListCheckBox);	
					List(child).itemRenderer = optionRenderer;
				break;							
			}
			if(child) {
				container.addElement(child);
				
				if(vo)
					child.addEventListener(Event.CHANGE,dataChangeProxy,false,0,true);		
				if(customfield.typeid == CustomFieldTypes.FILE_LINK)
					child.addEventListener(FlexEvent.CREATION_COMPLETE,handleCreationComplete,false,0,true);	
				return [child,summary];
			}
			else {
				return [null];
			}
		}
		private static function handleCreationComplete(event:FlexEvent):void {
			var child:TextInput = event.target as TextInput;
			var linkButton:LinkSocket = new LinkSocket();
			linkButton.drawingLayer = FlexGlobals.topLevelApplication.mainView.drawingLayer;
			linkButton.textInput = TextInput(child);
			linkButton.setStyle("right",2);
			linkButton.setStyle("top",0);
			if(child.parent is IVisualElementContainer)
				IVisualElementContainer(child.parent).addElement(linkButton); 
			else
				child.parent.addChild(linkButton);
		} 
		private static function dataChangeProxy(event:Event):void {
			if(UIComponent(event.target).parentDocument is ICustomFieldView) {
				var container:ICustomFieldView = UIComponent(event.target).parentDocument as ICustomFieldView;
				var customfield:CustomField = container.customfield;
				var vo:ContentData = container.vo;
				switch(customfield.typeid)
				{
					case CustomFieldTypes.BINARY:
						vo[customfield.name] = CheckBox(event.target).selected;
						break;
					case CustomFieldTypes.SELECT:
						vo[customfield.name] = DropDownList(event.target).selectedItem.index;
						break;
					case CustomFieldTypes.STRING:
						vo[customfield.name] = TextInput(event.target).text;
						break;
					case CustomFieldTypes.HTML_TEXT:
						vo[customfield.name] = MiGTLFTextArea(event.target).htmlText;
						break;
					case CustomFieldTypes.TEXT:
						vo[customfield.name] = TextArea(event.target).text;
						break;					
					case CustomFieldTypes.COLOR:
						vo[customfield.name] =  '#'+MiGColorPicker(event.target).selectedColor.toString(16);
						break;
					case CustomFieldTypes.INTEGER:
						vo[customfield.name] = TextInput(event.target).text;
						break;			
					case CustomFieldTypes.DATE:
						if(DateTimePicker(event.target).selectedDate)
							vo[customfield.name] = DateTimePicker(event.target).selectedDate.time / 1000;			
						else
							vo[customfield.name] = 0;
					break;
					case CustomFieldTypes.FILE_LINK:
						vo[customfield.name] = TextInput(event.target).text;
					break;
				}
			}
		}	
		private static function handleListChange(event:CollectionEvent):void {
			var list:ArrayList = event.target as ArrayList;
			var item:CustomFieldOption = list.getItemAt(0) as CustomFieldOption;
			var customfield:CustomField = item.customfield;
			var vo:ContentData = item.vo;
			var summary:String = '';
			var ordereredItems:String = '';
			var modified:Boolean = false;
			if(event.kind == "update") {
				var prop:PropertyChangeEvent = event.items[0];
				if(prop.property != "vo" && prop.property != "customfield") 
					modified = true;
			}
			else if(event.kind == "add" || event.kind == "remove")
				modified = true;
			if(modified && customfield.ready) {
				for each(item in list.source) {
					if(item.selected) {	
						ordereredItems += item.index + ',';
						summary += item.value+', ';
					}
				}
				ordereredItems = ordereredItems.substr(0,ordereredItems.length-1);
				vo[customfield.name] = ordereredItems;
				summary = summary.substring(0,summary.length-2);
			}		
		}
		private static function handleTextAreaUpdate(event:FlexEvent):void {
			TextArea(event.target).heightInLines = NaN;
		}
		private static function handleListCreationComplete(event:FlexEvent):void {
			List(event.target).dataGroup.clipAndEnableScrolling = false;
		}
		private static function checkDrag(event:DragEvent):void {
			if(event.dragInitiator == event.target) {
				DragManager.acceptDragDrop(event.target as List);
			}
			else {
				event.preventDefault();
				//event.target.hideDropFeedback(event);
				DragManager.showFeedback(DragManager.NONE);
			}
		}
		public static function populateCustomField(container:ICustomFieldView,child:UIComponent):void {
			var option:Object;
			var selected:Array;
			var item:CustomFieldOption;
			var summary:String = '';
			var index:String;
			var customfield:CustomField = container.customfield;
			var vo:ContentData = container.vo;
			var dp:ArrayList = customfield.optionsArray;
			switch(customfield.typeid)
			{
				case CustomFieldTypes.BINARY:
						CheckBox(child).selected = vo[customfield.name] == "true"?true:false;
				break; 
				
				case CustomFieldTypes.SELECT:
					for each(option in customfield.optionsArray.source) {
						if(option.index.toString() == vo[customfield.name]) {
							DropDownList(child).selectedItem = option;
							break;
						}
					}	
				break;
				
				case CustomFieldTypes.STRING:
					TextInput(child).text = vo[customfield.name].toString(); 
				break;
				
				case CustomFieldTypes.HTML_TEXT:
					MiGTLFTextArea(child).htmlText = vo[customfield.name];
				break;
				
				case CustomFieldTypes.TEXT:
					TextArea(child).text = vo[customfield.name];
				break;					
				
				case CustomFieldTypes.COLOR:
						MiGColorPicker(child).selectedColor= Number(vo[customfield.name]);				
				break;
				
				case CustomFieldTypes.MULTIPLE_SELECT:
					for each(item in dp.source)
						item.vo = vo;
					if(vo[customfield.name].toString() != '')
					{
						selected = vo[customfield.name].toString().split(',');
						for each(index in selected)
						{
							item = dp.getItemAt(Number(index)-1) as CustomFieldOption;
							item.selected = true;
							summary += item.value+', ';
						}
						summary = summary.substring(0,summary.length-2);
					}
					else {
						for each(item in dp.source) 
							item.selected = false;
					}
					break;
				
				case CustomFieldTypes.INTEGER:
					TextInput(child).text = vo[customfield.name];						
				break;				
				
				case CustomFieldTypes.DATE:
					if(vo[customfield.name].toString() != '')
					{
						var date:Date = new Date();
						date.time = Number(vo[customfield.name].toString())*1000;
						DateTimePicker(child).selectedDate = date;
					}
					else
						DateTimePicker(child).selectedDate = new Date();
					
					break;
				
				case CustomFieldTypes.FILE_LINK:
					TextInput(child).text = vo[customfield.name];						
				break;	
				
				case CustomFieldTypes.MULTIPLE_SELECT_WITH_ORDER:
					for each(item in dp.source)
						item.vo = vo;
					if(vo[customfield.name].toString() != '')
					{
						selected = vo[customfield.name].toString().split(',');
						for each(index in selected)
						{
							item = dp.getItemAt(Number(index)-1) as CustomFieldOption;
							item.selected = true;
							summary += item.value+', ';
						}
						summary = summary.substring(0,summary.length-2);
					}	
					else {
						for each(item in dp.source) 
							item.selected = false;
					}
				break;	
			}
		}
	}
}