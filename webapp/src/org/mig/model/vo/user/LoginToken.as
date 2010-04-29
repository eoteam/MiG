package org.mig.model.vo.user
{
	public class LoginToken
	{
		public var name:String;
		public var password:String;
		public var email:String;
		public function LoginToken(name:String,password:String,email:String='') {
			this.name = name;
			this.password = password;
			this.email = email;
		}
	}
}