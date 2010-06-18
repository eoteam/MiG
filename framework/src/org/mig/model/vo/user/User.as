package org.mig.model.vo.user
{
	import org.mig.model.vo.ContentData;

	[Bindable]
	public class User extends ContentData
	{
		public var email:String;
		public var active:int;
		public var username:String;
		public var firstname:String;
		public var lastname:String;
		public var password:String;
		public var dateofbirth:Number;
		
		public var group:int;
		
		public var address:String;
		public var address2:String;
		public var city:String;
		public var state:String;
		public var zip:String;
		public var country:String;
		
		public var phone:String;
		public var mobile:String;
		public var fax:String;
	
		private var _privileges:int;
		private var _privilegesString:String;
		
				
		public var lastlogin:Number;
		public var createdBy:int;
		public var createdDate:Number;
		
		public var categories:Array;
		public var newCategories:Array;
		public var delCategories:Array;
			
		public function get privileges():int {
			return _privileges;
		}
		public function set privileges(value:int):void {
			_privileges = value;
			_privilegesString = UserPrivileges.translateIntToString(value);
		}		
		public function get privilegesString():String {
			return _privilegesString;
		}
		public function set privilegesString(value:String):void {
			_privilegesString = value;
			_privileges = UserPrivileges.translateStringToInt(value);
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
			privileges = 4; //always reader
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