package org.mig.model.vo.content
{
	import org.mig.model.vo.ContentData;
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.UpdateData;
	import org.mig.model.vo.content.ContainerData;
	
	/**
	 * @flowerModelElementId _ec_VoM2REd--irTzzklAjg
	 */
	[Bindable] 
	public class ContainerNode extends ContentNode
	{		
		
		public var isRoot:Boolean = false;
		public var isFixed:Boolean = false; //fixed items in DB and config
		public var isBranch:Boolean = false; //used for the spring loaded mechanism
		
		public var template:Template;
		
		public function ContainerNode(baseLabel:String, template:Template, data:ContainerData, parentContent:ContentNode,
		priveleges:int,root:Boolean=true,fixed:Boolean=false) {
			super(baseLabel, data, parentContent,priveleges);
			isRoot = root;
			isFixed = fixed;
			this.template = template;
			if(isFixed || isRoot || template.is_nesting)
				isBranch = true;	
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