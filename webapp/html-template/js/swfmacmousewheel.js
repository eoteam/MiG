/**
 * SWFMacMouseWheel v2.0: Mac Mouse Wheel functionality in flash - http://blog.pixelbreaker.com/
 *
 * SWFMacMouseWheel is (c) 2007 Gabriel Bucknall and is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Dependencies: 
 * SWFObject v2.0 rc1 <http://code.google.com/p/swfobject/>
 * Copyright (c) 2007 Geoff Stearns, Michael Williams, and Bobby van der Sluis
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 */
var swfmacmousewheel = function()
{
	if( !swfobject ) return null;
	
	var u = navigator.userAgent.toLowerCase();
	var p = navigator.platform.toLowerCase();
	var mac = p ? /mac/.test(p) : /mac/.test(u);
	
	if( !mac ) return null;

	var regObjArr = [];
	
	var deltaFilter = function(event)
	{
		var delta = 0;
        if (event.wheelDelta) {
			delta = event.wheelDelta/500;
			if (window.opera) delta = -delta;
        } else if (event.detail) {
            delta = -event.detail;
        }
        if (event.preventDefault) event.preventDefault();
		return delta;
	}
	
	var deltaDispatcher = function(event)
	{
		var delta = deltaFilter(event);
		var obj;
		for(var i=0; i<regObjArr.length; i++ )
		{
			obj = swfobject.getObjectById(regObjArr[i]);
			if( typeof( obj.externalMouseEvent ) == 'function' ) obj.externalMouseEvent( delta );
		}
	}
	
	if (window.addEventListener) window.addEventListener('DOMMouseScroll', deltaDispatcher, false);
	window.onmousewheel = document.onmousewheel = deltaDispatcher;
			
	return {
		/*
		Public API
		*/
		registerObject: function(objectIdStr)
		{
			regObjArr[regObjArr.length] = objectIdStr;
		}
	};
}();


