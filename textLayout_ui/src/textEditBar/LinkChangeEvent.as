//========================================================================================
//  $File: //a3t/argon/branches/v1/1.0/dev/sdk/samples/flex/textLayout_editBar/src/textEditBar/LinkChangeEvent.as $
//  $DateTime: 2009/12/22 14:38:02 $
//  $Revision: #1 $
//  $Change: 733743 $
//  
//  ADOBE CONFIDENTIAL
//  
//  Copyright 2007-08 Adobe Systems Incorporated. All rights reserved.
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
package textEditBar
{
	import flash.events.Event;
	
	public class LinkChangeEvent extends Event
	{
		private var _linkText:String;
		private var _targetText:String;
		private var _extendToOverlappingLinks:Boolean;
		
		public function LinkChangeEvent(type:String, linkText:String, targetText:String, extendToOverlappingLinks:Boolean=false, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_linkText = linkText;
			_targetText = targetText;
			_extendToOverlappingLinks = extendToOverlappingLinks;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new LinkChangeEvent(type, _linkText, _targetText, _extendToOverlappingLinks, bubbles, cancelable);
		}
		
		public function get linkText():String
		{ return _linkText; }		
		
		public function get linkTarget():String
		{ return _targetText; }
		
		public function get extendToOverlappingLinks():Boolean
		{ return _extendToOverlappingLinks; }
	}
}
