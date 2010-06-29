package org.mig.model
{
	import mx.collections.ArrayCollection;
	
	import org.mig.model.vo.user.User;
	import org.robotlegs.mvcs.Actor;
	
	public class UserModel extends Actor
	{
		public var userGroups:Array;
		
		public var users:ArrayCollection;
		
		private var searchId:int;
		public function findUserById(id:int):User {
			searchId = id;
			users.filterFunction = searchUser;
			users.refresh();
			var result:User;
			if(users.length == 1) {
				result =  users.getItemAt(0) as User;
			}
			users.filterFunction = null;
			users.refresh();
			return result;
		}
		private function searchUser(item:User):Boolean {
			return item.id == searchId?true:false;
		}
	}
}