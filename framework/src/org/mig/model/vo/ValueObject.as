package org.mig.model.vo
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	//stateless
	public class ValueObject implements IValueObject
	{
		public var id:Number;

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
	}
}