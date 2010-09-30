package org.mig.model.vo
{
	public class BaseVO extends ValueObject
	{
		public var updateData:UpdateData = new UpdateData();
		public var isNew:Boolean = true; //needed to discriminate delete from reorder actions of new objects
		public var modified:Boolean = false; //used almost never
		public var stateProps:Array;
		
		public function BaseVO()
		{
			stateProps = ["stateProps","isNew","modified","updateData"];
		}
	}
}