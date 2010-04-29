package org.mig.model.vo.user
{
	public final class  UserPrivileges
	{
		public static const Admin:int = 1;
		public static const Writer1:int = 2;
		public static const Writer2:int = 3;
		public static const Reader:int = 4;
		public static const MiGAdmin:int = 5;
		public static function translateIntToString(privilege:int):String
		{
			if(privilege == Admin)
				return "Administrator";
			else if(privilege == Writer1)
				return "Writer 1";
			else if(privilege == Writer2)
				return "Writer 2";	
			else if(privilege == Reader)
				return "Reader";
			else if(privilege == MiGAdmin)
				return "MiG Admin";
			else
				return "";	
		}
		public static function translateStringToInt(privilegeString:String):int
		{
			if(privilegeString == "Administrator")
				return Admin;
			else if(privilegeString == "Writer 1")
				return Writer1;
			else if(privilegeString == "Writer 2")
				return Writer2;	
			else if(privilegeString == "Reader")
				return Reader;
			else if(privilegeString == "MiG Admin")
				return MiGAdmin;
			else
				return 0;	
		}		
	}
}