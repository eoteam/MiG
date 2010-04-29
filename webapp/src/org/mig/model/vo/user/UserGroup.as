package org.mig.model.vo.user
{
	[Bindable]
	public class UserGroup
	{

		public static const MiG:int = 1;
		public static const FronEnd:int = 2;
				

		public var groupid:int;
		public var parentid:int;
		public var groupname:String;
		
		public function toString():String{
			if(groupid == MiG)
				return "MiG";
			else
				return "Front End";
		}
	}
}