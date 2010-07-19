package org.mig.model.vo
{
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import mx.events.PropertyChangeEvent;
	import mx.utils.ObjectProxy;
	import mx.utils.StringUtil;
	
	//stateless
	
	internal class ValueObject extends ObjectProxy implements IValueObject
	{
		public var id:Number;
		public function ValueObject() {
			//this.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, updateHandler);
		}
		//need better logging...?	
		 public function toString():String {
			var result:String = '';
			var xml:XML = flash.utils.describeType(this);
/*			for (var item:String in this) {
				result += item +'\t\t\t\t'+ getQualifiedClassName(this[item])+'\t\t\t\t\t\t'+this[item]+'\n';
				result += '-----------------------------------------------------------------------------\n';
			}*/
			return xml.toXMLString(); 
		}
		private function updateHandler(event:PropertyChangeEvent):void {
			trace(StringUtil.substitute("updateHandler('{0}', {1}, {2}, {3})",
			 event.kind,
			 event.property,
			 event.oldValue,
			 event.newValue));
		}
	}
}