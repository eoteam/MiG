package org.mig.model.vo.content
{
	import org.mig.model.vo.BaseVO;
	
	/**
	 * @flowerModelElementId _edKUwM2REd--irTzzklAjg
	 */
	[Bindable]
	public class ContentTabParameter extends BaseVO
	{

		public var templateid:int;
		public var tabid:int;
		public var value:String;
		public var name:String;
		public var param1:String;
		public var param2:String;
		public var param3:String;
		public var is_label:int;
		
		public function ContentTabParameter() {
			super();
		}

		
	}
}