package org.mig.model.vo.user
{
	/**
	 * @flowerModelElementId _eeACQM2REd--irTzzklAjg
	 */
	public final class  UserPrivilege
	{
		public static const NONE:UserPrivilege = new UserPrivilege(0,"NONE");
		public static const MiGAdmin:UserPrivilege = new UserPrivilege(1,"MiGAdmin");
		public static const Admin:UserPrivilege = new UserPrivilege(2,"Admin");
		public static const Writer1:UserPrivilege = new UserPrivilege(3,"Writer1");
		public static const Writer2:UserPrivilege = new UserPrivilege(4,"Writer2");
		public static const Reader:UserPrivilege = new UserPrivilege(5,"Reader");
		
		
		public var id:int;
		public var name:String;
		
		public function UserPrivilege(id:int,name:String)
		{
			this.id = id;
			this.name = name;
		}
		public static function get list( ):Array
		{
			return [NONE,MiGAdmin,Admin,Writer1,Writer2,Reader];
		}
		
		public static function translateIntToString(input:int):String
		{
			for each ( var userPrivilege:UserPrivilege in UserPrivilege.list )
			{
				if ( input == userPrivilege.id )
					return userPrivilege.name;
			}
			return NONE.name;
		}
		public static function translateStringToInt(input:String):int
		{
			for each ( var userPrivilege:UserPrivilege in UserPrivilege.list )
			{
				if ( input == userPrivilege.name )
					return userPrivilege.id;
			}
			return NONE.id;
		}		
	}
}