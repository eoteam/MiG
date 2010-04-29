//========================================================================================
//  $File: //a3t/argon/branches/v1/1.0/dev/sdk/samples/flex/textLayout_ui/src/flashx/textLayout/ui/inspectors/AdvancedTextPropertyEditor.as $
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

package flashx.textLayout.ui.inspectors
{
	import flash.text.engine.*;
	
	import flashx.textLayout.formats.FormatValue;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.tlf_internal;
	use namespace tlf_internal;
	
	public class AdvancedTextPropertyEditor extends DynamicTextPropertyEditor
	{
		public function AdvancedTextPropertyEditor()
		{
			var recipe:XML = 
				<recipe>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/DigitCase=Digit Case:">
							<property name={TextInspectorController.DIGIT_CASE_UIPROP}/>
							<choice display="Default" value={flash.text.engine.DigitCase.DEFAULT}/>
							<choice display="Lining" value={flash.text.engine.DigitCase.LINING}/>
							<choice display="Old Style" value={flash.text.engine.DigitCase.OLD_STYLE}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/DigitWidth=Digit Width:">
							<property name={TextInspectorController.DIGIT_WIDTH_UIPROP}/>
							<choice display="Default" value={flash.text.engine.DigitWidth.DEFAULT}/>
							<choice display="Proportional" value={flash.text.engine.DigitWidth.PROPORTIONAL}/>
							<choice display="Tabular" value={flash.text.engine.DigitWidth.TABULAR}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/DominantBaseline=Dominant Baseline:">
							<property name={TextInspectorController.DOMINANT_BASELINE_UIPROP}/>
							<choice display="Auto" value={FormatValue.AUTO}/>
							<choice display="Roman" value={flash.text.engine.TextBaseline.ROMAN}/>
							<choice display="Ascent" value={flash.text.engine.TextBaseline.ASCENT}/>
							<choice display="Descent" value={flash.text.engine.TextBaseline.DESCENT}/>
							<choice display="Ideographic Top" value={flash.text.engine.TextBaseline.IDEOGRAPHIC_TOP}/>
							<choice display="Ideographic Center" value={flash.text.engine.TextBaseline.IDEOGRAPHIC_CENTER}/>
							<choice display="Ideographic Bottom" value={flash.text.engine.TextBaseline.IDEOGRAPHIC_BOTTOM}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/AlignmentBaseline=Alignment Baseline:">
							<property name={TextInspectorController.ALIGNMENT_BASELINE_UIPROP}/>
							<choice display="Roman" value={flash.text.engine.TextBaseline.ROMAN}/>
							<choice display="Ascent" value={flash.text.engine.TextBaseline.ASCENT}/>
							<choice display="Descent" value={flash.text.engine.TextBaseline.DESCENT}/>
							<choice display="Ideographic Top" value={flash.text.engine.TextBaseline.IDEOGRAPHIC_TOP}/>
							<choice display="Ideographic Center" value={flash.text.engine.TextBaseline.IDEOGRAPHIC_CENTER}/>
							<choice display="Ideographic Bottom" value={flash.text.engine.TextBaseline.IDEOGRAPHIC_BOTTOM}/>
							<choice display="Use Dominant" value={flash.text.engine.TextBaseline.USE_DOMINANT_BASELINE}/>
						</editor>
					</row>
					<row>
						<editor type="hotnumberunit" label="$$$/stage/TextEditing/Label/BaselineShift=Baseline Shift:">
							<property name={TextInspectorController.BASELINE_SHIFT_UIPROP}/>
							<defaultunit>pix</defaultunit>
							<numericunit displayname="%" 
								min={TextLayoutFormat.baselineShiftProperty.minPercentValue}
								max={TextLayoutFormat.baselineShiftProperty.maxPercentValue} 
								default="0" 
								decimals="1"/>
							<numericunit displayname="pix" 
								min={TextLayoutFormat.baselineShiftProperty.minNumberValue}
								max={TextLayoutFormat.baselineShiftProperty.maxNumberValue} 
								default="0" 
								decimals="1"/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/Ligatures=Ligatures:">
							<property name={TextInspectorController.LIGATURE_LEVEL_UIPROP}/>
							<choice display="Minimum" value={flash.text.engine.LigatureLevel.MINIMUM}/>
							<choice display="Common" value={flash.text.engine.LigatureLevel.COMMON}/>
							<choice display="Uncommon" value={flash.text.engine.LigatureLevel.UNCOMMON}/>
							<choice display="Exotic" value={flash.text.engine.LigatureLevel.EXOTIC}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/Rotation=Rotation:">
							<property name={TextInspectorController.TEXT_ROTATION_UIPROP}/>
							<choice display="0 degrees" value={flash.text.engine.TextRotation.ROTATE_0}/>
							<choice display="90 degrees" value={flash.text.engine.TextRotation.ROTATE_90}/>
							<choice display="180 degrees" value={flash.text.engine.TextRotation.ROTATE_180}/>
							<choice display="270 degrees" value={flash.text.engine.TextRotation.ROTATE_270}/>
							<choice display="auto" value={flash.text.engine.TextRotation.AUTO}/>
						</editor>
					</row>
					<row>
						<editor type="hotnumber" label="$$$/stage/TextEditing/Label/Alpha=Alpha:" suffix="%">
							<property name={TextInspectorController.TEXT_ALPHA_UIPROP} 
								minValue="0" 
								maxValue="100"
								convertToPercent="yes"/>
						</editor>
					</row>
					<row>
						<editor type="hotnumber" label="$$$/stage/TextEditing/Label/BackgroundAlpha=Background alpha:" suffix="%">
							<property name={TextInspectorController.BACKGROUND_ALPHA_UIPROP} 
								minValue="0" 
								maxValue="100"
								convertToPercent="yes"/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/Break=Break:">
							<property name={TextInspectorController.BREAK_OPPORTUNITY_UIPROP}/>
							<choice display="All" value={flash.text.engine.BreakOpportunity.ALL}/>
							<choice display="Any" value={flash.text.engine.BreakOpportunity.ANY}/>
							<choice display="Auto" value={flash.text.engine.BreakOpportunity.AUTO}/>
							<choice display="No Break" value={flash.text.engine.BreakOpportunity.NONE}/>
						</editor>
					</row>
					<row>
						<editor type="combo" label="$$$/stage/TextEditing/Label/Lacale=Locale:">
							<property name={TextInspectorController.LOCALE_UIPROP}/>
							<choice display="Arabic" value="ar"/>,
							<choice display="Bengali" value="bn"/>,
							<choice display="Bulgarian" value="bg"/>,
							<choice display="Catalan" value="ca"/>,
							<choice display="Chinese, Simplified (China)" value="zh-CN"/>,
							<choice display="Chinese, Traditional (Taiwan)" value="zh-TW"/>,
							<choice display="Croatian" value="hr"/>,
							<choice display="Czech" value="cs"/>,
							<choice display="Danish" value="da"/>,
							<choice display="Dutch" value="nl"/>,
							<choice display="English" value="en"/>,
							<choice display="Estonian" value="et"/>,
							<choice display="Finnish" value="fi"/>,
							<choice display="French" value="fr"/>,
							<choice display="German" value="de"/>,
							<choice display="Greek" value="el"/>,
							<choice display="Gujarati" value="gu"/>,
							<choice display="Hindi" value="hi"/>,
							<choice display="Hebrew" value="he"/>,
							<choice display="Hungarian" value="hu"/>,
							<choice display="Italian" value="it"/>,
							<choice display="Japanese" value="ja"/>,
							<choice display="Korean" value="ko"/>,
							<choice display="Latvian" value="lv"/>,
							<choice display="Lithuanian" value="lt"/>,
							<choice display="Marathi" value="mr"/>,
							<choice display="Norwegian" value="no"/>,
							<choice display="Persian" value="fa"/>,
							<choice display="Polish" value="pl"/>,
							<choice display="Portuguese" value="pt"/>,
							<choice display="Punjabi" value="pa"/>,
							<choice display="Romanian" value="ro"/>,
							<choice display="Russian" value="ru"/>,
							<choice display="Slovak" value="sk"/>,
							<choice display="Slovenian" value="sl"/>,
							<choice display="Spanish" value="es"/>,
							<choice display="Swedish" value="sv"/>,
							<choice display="Tamil" value="ta"/>,
							<choice display="Telugu" value="te"/>,
							<choice display="Thai" value="th"/>,
							<choice display="Turkish" value="tr"/>,
							<choice display="Ukrainian" value="uk"/>,
							<choice display="Urdu" value="ur"/>,
							<choice display="Vietnamese" value="vi"/>
						</editor>
					</row>
				</recipe>;

			super(recipe);
		}
		
	}
}