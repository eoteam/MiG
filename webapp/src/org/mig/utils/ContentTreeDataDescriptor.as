package org.mig.utils
{
	import mx.collections.ICollectionView;
	import mx.controls.Tree;
	import mx.controls.treeClasses.DefaultDataDescriptor;
	import mx.core.UIComponent;
	
	import org.mig.model.vo.ContentNode;
	import org.mig.model.vo.content.ContainerNode;
	import org.mig.view.controls.MigTree;
	import org.mig.view.events.ContentViewEvent;
	
	public class ContentTreeDataDescriptor extends DefaultDataDescriptor
	{
		protected var tree:MigTree;
		public function ContentTreeDataDescriptor(tree:MigTree) {
			this.tree = tree;
			super();
		}
		
		override public function getChildren(node:Object, model:Object=null):ICollectionView {
			if (node is ContentNode) {
				var nl:ContentNode = node as ContentNode;
				if (nl.state == ContentNode.NOT_LOADED && nl.hasChildren) {
					tree.dispatchEvent(new ContentViewEvent(ContentViewEvent.LOAD_CHILDREN,nl));
				}
				return nl.children;
			} else {
				return super.getChildren(node, model);
			}
		}
		//when the node is a LazyLoading, use the hasChildren property read from the data source
		override public function hasChildren(node:Object, model:Object=null):Boolean {
			if (node is ContentNode) {
				return (node as ContentNode).hasChildren;
			} else {
				return super.hasChildren(node, model);
			}
		}
		override public function isBranch(node:Object, model:Object=null):Boolean {
			if (node is ContainerNode) {
				return (node as ContainerNode).hasChildren;
			} else {
				return super.isBranch(node, model);
			}
		}
	}
}