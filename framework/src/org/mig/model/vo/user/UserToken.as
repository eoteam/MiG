package org.mig.model.vo.user
{
	public class UserToken
	{
		public var username:String;
		public var password:String;
		public var email:String;
		public function UserToken(username:String,password:String,email:String='') {
			this.username = username;
			this.password = password;
			this.email = email;
		}
	}
}