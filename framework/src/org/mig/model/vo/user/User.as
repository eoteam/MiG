package org.mig.model.vo.user
{
	import org.mig.model.vo.ContentData;

	/**
	 * @flowerModelElementId _ed1qMM2REd--irTzzklAjg
	 */
	[Bindable]
	public class User extends ContentData
	{
		
		public static const MiG:int = 1;
		public static const FronEnd:int = 2;
		
		public var email:String;
		public var active:int;
		public var username:String;
		public var firstname:String;
		public var lastname:String;
		public var password:String;
		public var dateofbirth:Number;
		
		public var miggroup:int;
		
		public var address:String;
		public var address2:String;
		public var city:String;
		public var state:String;
		public var zip:String;
		public var country:String;
		
		public var phone:String;
		public var mobile:String;
		public var fax:String;
	
		public var privilege:UserPrivilege;
				
		public var lastlogin:Number;

		
		public var categories:Array;
		public var newCategories:Array;
		public var delCategories:Array;
			

		public function set privilegeid(value:int):void {
			privilege = UserPrivilege.list[value];
		}		
		
		public function User() {
			email="";
			firstname="";
			lastname="";
			password="";
			address = '';
			address2 = '';
			country = '';
			state = '';
			zip = '';
			city= '';
			phone = '';
			mobile = '';
			fax = '';
			privilege = UserPrivilege.NONE; //always reader
			categories = [];
			newCategories = [];
			delCategories = [];
		}
		override public function toString():String {
			return firstname+" " +lastname;
		}
		public function get fullname():String {
			return firstname+" " +lastname;
		}
		public function set fullname(value:String):void {
			
		}
	}
}