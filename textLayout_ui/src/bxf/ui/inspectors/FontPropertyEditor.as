//========================================================================================
//  $File: //a3t/argon/branches/v1/1.0/dev/sdk/samples/flex/textLayout_ui/src/bxf/ui/inspectors/FontPropertyEditor.as $
//  $DateTime: 2009/12/22 14:38:02 $
//  $Revision: #1 $
//  $Change: 733743 $
//  
//  ADOBE CONFIDENTIAL
//  
//  Copyright 2008 Adobe Systems Incorporated. All rights reserved.
//  
//  NOTICE:  All information contained herein is, and remains
//  the property of Adobe Systems Incorporated and its suppliers,
//  if any.  The intellectual and technical concepts contained
//  herein are proprietary to Adobe Systems Incorporated and its
//  suppliers and may be covered by U.S. and Foreign Patents,
//  patents in process, and are protected by trade secret or copyright law.
//  Dissemination of this information or reproduction of this material
//  is strictly forbidden unless prior written permission is obtained
//  from Adobe Systems Incorporated.
//  
//========================================================================================

package bxf.ui.inspectors
{
	import flash.events.Event;
	import flash.text.Font;
	import flash.text.FontType;
	
	import mx.controls.ComboBox;

	public class FontPropertyEditor extends PropertyEditorBase implements IPropertyEditor
	{
		public function FontPropertyEditor(inLabel:String, inPropName:String)
		{
			super(inLabel);
			mChangeNotify = new ValueChangeNotifier(inPropName, this);
			var fonts:Array = Font.enumerateFonts(false);
			fonts.sortOn("fontName", Array.CASEINSENSITIVE);
/*			mFonts.push("_sans");
			mFonts.push("_serif");
			mFonts.push("_typewriter");
			mFonts.push("\u005f\u30b4\u30b7\u30c3\u30af");
			mFonts.push("\u005f\u7b49\u5e45");
			mFonts.push("\u005f\u660e\u671d");*/
			// This code will add fonts to the list, and skip dupe names because of embedded fonts.
			var curFont:String = "";
			for each (var font:Font in fonts)
			{
   				// only show device fonts (apparently, we embed Myriad Pro and Myriad Pro Bold in the TextLayout GUI swf)
   				// override  Adobe behavior and allow embedded fonts.
				//if (font.fontType == FontType.DEVICE) {
	    			if (curFont != font.fontName){
						mFonts.push(font.fontName);
	    				curFont = font.fontName; 
	    			}
    			//}
    		}
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			if (mFontCombo == null)
			{
				mFontCombo = new TextLayoutFontComboBox;
				mFontCombo.dataProvider = mFonts;
				mFontCombo.width = 185;
				mFontCombo.height = 22;
				mFontCombo.rowCount = 20;
				mFontCombo.editable = true;
				mFontCombo.addEventListener("open", onFontOpen);
				mFontCombo.addEventListener("close", onFontClose);
				mFontCombo.addEventListener("enter", onFontChoice);
				mFontCombo.addEventListener("change", onValueChange);
				
				mFontCombo.styleName = "fontComboStyle";
				mFontCombo.setStyle("dropdownStyleName", "fontDropDownStyle");
				mFontCombo.y += -10;
				
				addChild(mFontCombo);							
				mFontCombo.updateDropDownWidth();
				DisplayValue();
			}
		}
				
		private function onFontChoice(evt:Event):void
		{
			if (!mProcessingChoice)		// no reentrance!
			{
				mProcessingChoice = true;
				if (evt.type == "enter")
				{
					mFontCombo.close();
					mChangeNotify.ValueCommitted(mFontCombo.text);
				}
				else
					mChangeNotify.ValueCommitted(mFontCombo.text);
				mProcessingChoice = false;
			}
		}
		
		/**
		 * Find the best match in the list of font names for the entry string. Best match is defined as the first 
		 * font (alphabetically) that begins with the string, or if there are none that begin with it, the first
		 * that contains the string. Strings are converted to upper case, so case does not matter.
		 * @param entry string to search for in font names
		 * @return index to font found in mFonts, or -1 if no match.
		 */
		private function findBestMatch(entry:String):int
		{
			var bestMatch:int = -1;
			if (entry.length > 0)
			{
				var entryUpper:String = entry.toUpperCase();
				var fontUpper:String;
				var n:int = mFonts.length;
				for (var i:int = 0; i < n; ++i)
				{
					fontUpper = mFonts[i].toUpperCase();
					var subIndex:int = fontUpper.search(entryUpper);
					if (subIndex == 0)
					{
						bestMatch = i;
						break;
					} else if (subIndex > 0 && bestMatch == -1)
						bestMatch = i;
				}
			}
			return bestMatch;
		}
		
		private function onFontOpen(evt:Event):void
		{
			mComboOpen = true;
		}	
			
		private function onFontClose(evt:Event):void
		{
			mComboOpen = false;
			if (!mProcessingChoice)		// no reentrance!
			{
				mProcessingChoice = true;
				mChangeNotify.ValueCommitted(mFontCombo.text);
				mProcessingChoice = false;
			}
		}	
			
		private function onValueChange(evt:Event):void
		{
			if (mComboOpen)
			{
				if (mFontCombo.text != mFonts[mFontCombo.selectedIndex])
				{
					// If we get this when the combo box is open, but the text is not equal to the selected list item, 
					// it means that the user is typing. Autoscroll to best matching font name.
					var entry:String = mFontCombo.text;
					var bestMatch:int = findBestMatch(entry);
					if (bestMatch != -1)
					{
						mFontCombo.dropdown.selectedIndex = bestMatch;
						mFontCombo.dropdown.scrollToIndex(bestMatch);
					}
				}
			}
		}
		
		public function setValueAsString(value:String, inPropType:String):void
		{
			mValue = value;
			DisplayValue();
		}
		
		public function setMultiValue(values:Array, inPropType:String):void
		{
			mValue = values;
			DisplayValue();
		}
		
		private function DisplayValue():void
		{
			if (mValue && mFontCombo)
				if (mValue is String)
				{
					var fontIndex:int = mFonts.indexOf(mValue as String);
					if (fontIndex >= 0)
						mFontCombo.selectedIndex = fontIndex;
					else
					{
						mFontCombo.selectedIndex = -1;
						mFontCombo.validateNow();
						mFontCombo.text = mValue as String;
					}
				}
				else
				{
					mFontCombo.selectedIndex = -1;
					mFontCombo.validateNow();
					mFontCombo.text = "Mixed";
				}
		}
		
		
		private var mFontCombo:TextLayoutFontComboBox = null;
		private var mValue:Object = null;
		private var mChangeNotify:ValueChangeNotifier;
		private var mFonts:Array = [];
		private var mProcessingChoice:Boolean = false;
		private var mComboOpen:Boolean = false;
	}	
}

import mx.controls.ComboBox;

class TextLayoutFontComboBox extends ComboBox
{
	public function updateDropDownWidth():void
	{
		//this.dropdownWidth = this.calculatePreferredSizeFromData(this.dataProvider.length).width + 25;
	}						
}