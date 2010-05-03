package org.mig.view.mediators
{
	import org.mig.model.AppModel;
	import org.mig.view.components.ManagersTree;
	import org.robotlegs.mvcs.Mediator;

	public class ManagersTreeMediator extends Mediator
	{
		[Inject]
		public var appModel:AppModel;
		
		[Inject]
		public var treeView:ManagersTree;
	}
}