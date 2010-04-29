package org.mig.model.vo.content
{
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.UpdateData;
	import org.mig.model.vo.content.ContentData;
	
	
	public class ContainerNode extends ContentNode
	{		
		
		public var isRoot:Boolean;
		public var isFixed:Boolean; //fixed items in DB and config
		public var isNesting:Boolean; //if turned on, this node and its children share the same template
		public var isBranch:Boolean = false; //used for the spring loaded mechanism
		
		public function ContainerNode(baseLabel:String, config:XML, data:ContentData, parentContent:ContentNode,
		priveleges:int,root:Boolean=true,fixed:Boolean=false,nesting:Boolean=false) {
			isRoot = root;
			isFixed = fixed;
			isNesting = nesting;
			if(isFixed || isRoot || isNesting)
				isBranch = true;	
			super(baseLabel, config, data, parentContent,priveleges);
		}
		/*public function updateChildrenOrder(userId:int = -1):void {
			var modDate:Date = new Date();
			for each(var child:ContainerNode in children) {
				var update:UpdateData  = new UpdateData();
				update.id = ContentData(data).id;
				update.displayorder = children.getItemIndex(child)+1;
				update.parentid = ContentData(data).id.toString();
				update.modifieddate = modDate.time;
				if(userId!=-1)
					update.modifiedby = userId;	
				child.updateData(update);			
			}	
		}*/
	}
}