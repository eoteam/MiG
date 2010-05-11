package org.mig.model.vo.manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	[Bindable]
	public class Tag extends EventDispatcher
	{
		public var id:Number;
		public var slug:String;
		public var taxonomy:String;
		public var description:String;
		public var color:uint;
		public var termid:Number;
		public var parentName:String;
		public var node:XML;
		public var children:Array;
		public var contentList:Array;
		public var mediaList:Array;
		public var displayorder:Number;
		private var _name:String;
		private var _parent:Tag;
		
/* 		private var accents:Array = ['Š','Œ','Ž','š','œ','ž','Ÿ','¥','µ','À','Á','Â','Ã','Ä','Å','Æ','Ç','È','É','Ê','Ë','Ì','Í','Î','Ï',
									 'Ð','Ñ','Ò','Ó','Ô','Õ','Ö','Ø','Ù','Ú','Û','Ü','Ý','ß','à','á','â','ã','ä','å','æ','ç','è','é','ê','ë',
									 'ì','í','î','ï','ð','ñ','ò','ó','ô','õ','ö','ø','ù','ú','û','ü','ý','ÿ'];
		
		private var baseLetters:Array = ['S','O','Z','s','o','z','Y','Y','u','A','A','A','A','A','A','A','C','E','E','E','E','I','I','I','I',
										 'D','N','O','O','O','O','O','O','U','U','U','U','Y','s','a','a','a','a','a','a','a','c','e','e','e','e',
										 'i','i','i','i','o','n','o','o','o','o','o','o','u','u','u','u','y','y']; */
		public function set name(value:String):void
		{
			if(value)
			{
				_name = value;
				slug = _name.toLowerCase().split(' ').join('-');	
/* 				for (var i:int=0;accents.length;i++)
				{
					slug.replace(accents[i],baseLetters[i]);
				} */
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		public function get name():String
		{
			return _name;
		}
		public function set parent(value:Tag):void
		{
			_parent = value;
			if(_parent)
				parentName = _parent.name;
		}
		public function  get parent():Tag
		{
			return _parent;
		}
		public function set contenttitles(value:String):void
		{
			if(value != "")
				contentList = value.split(",");
		}
		public function set mediatitles(value:String):void
		{
			if(value != "")
				mediaList = value.split(",");
		}
		public function Tag(value:XML=null) 
		{
			contentList = [];
			mediaList = [];
			id = -1;
			description = ' ';
			if(value)
			{
				node = value;
				var classInfo:XML = describeType( this );
				for each(var v:XML in node.children())
				{
					var prop:String = v.name().toString();
					var t:XMLList = classInfo..accessor.(@name == prop);
					if(t.length() > 0)
					{
						this[v.name().toString()] = v.toString();
					}
				}
				//if(node.parent_termid.toString() == '0')
				//	children= [];
			}
		}
	}
}