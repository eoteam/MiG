package org.mig.utils
{
    import mx.core.IFactory;

	[Bindable]
    public class ColumnInfo
    {
        public var dataField:String;
        public var headerText:String;
        public var valueProperty:String;
        public var itemRenderer:IFactory;
        public var width:Number = 100;
		public var minWidth:Number = 100;
		public var maxWidth:Number = 100;
        public var descending:Boolean;
        public var caseInsensitive:Boolean;
        public var numeric:Boolean;
    }
}