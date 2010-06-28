package org.mig.model.vo.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.ValueObject;
	
	[Bindable]
	public dynamic class Term extends ContentData
	{
		public var name:String;
		public var slug:String;
		public var taxonomy:String;
		public var termid:Number;
		public var parentid:Number;

		public var contentList:Array;
		public var mediaList:Array;
		public var displayorder:Number;
		public var isBranch:Boolean = false;
	}
}