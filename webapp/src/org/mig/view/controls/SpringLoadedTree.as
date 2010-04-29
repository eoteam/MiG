package org.mig.view.controls
{	
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	
	import mx.controls.Tree;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.core.mx_internal;
	import mx.effects.Fade;
	import mx.events.DragEvent;
	import mx.events.TreeEvent;
	import mx.managers.DragManager;
	
	import org.mig.utils.DelayedTimer;
	
	use namespace mx_internal;
		
	public class SpringLoadedTree extends Tree
	{
	
		//Extended timer class for the open delay.
		private var _delayedTimer:org.mig.utils.DelayedTimer = new DelayedTimer();
		
		//Used to close nodes on delay.
		private var _cleanUpDelayedTimer:DelayedTimer = new DelayedTimer();
						
		//Store last folder that the user was over.
		private var _lastNodeOver:TreeItemRenderer;
		
		//Fade effect instance for the icon TreeItemRenderer.
		private var _treeItemRendererFadeEffect:Fade = new Fade();
		
		private var tweeningNode:Object
				
		/**
		* Keep a list of folders that were open prior to the drag operation so that
		* we can know not to close them in the restore and close nodes methods.
		**/
		private var openedFolderHierarchy:Object;
		        
	        
		public function SpringLoadedTree()
		{
			super();
						
			//Drag events
			addEventListener(DragEvent.DRAG_COMPLETE,handleDragComplete);
			addEventListener(DragEvent.DRAG_OVER,handleDragOver);
			addEventListener(DragEvent.DRAG_EXIT,handleDragExit);
			addEventListener(DragEvent.DRAG_START,handleDragStart);
			
			addEventListener(TreeEvent.ITEM_OPEN,handleItemOpened);
			addEventListener(TreeEvent.ITEM_CLOSE,handleItemClosed);
			
			
			//key events
			addEventListener(KeyboardEvent.KEY_UP, handleKeyEvents);
			
			_delayedTimer.addEventListener(TimerEvent.TIMER_COMPLETE,handleTimerComplete);
			
			//setup for effect
			_treeItemRendererFadeEffect.alphaFrom = 1;
			_treeItemRendererFadeEffect.alphaTo = .2;
			_treeItemRendererFadeEffect.duration = 200;
			_treeItemRendererFadeEffect.startDelay = 400;
			_treeItemRendererFadeEffect.repeatDelay = 200;
			
			
		}
		
		/**
		* When true the node will be closed on drag exit if it was not already 
		* open before the drag operation started.
		**/
		private var _showOpeningIndication:Boolean=true;
		[Bindable]
		public function set showOpeningIndication(value:Boolean):void{
			_showOpeningIndication=value;
		}
		public function get showOpeningIndication():Boolean{
			return _showOpeningIndication;	
		}

		/**
		* When true the node dropped into will be closed on drop complete.
		**/
		private var _autoCloseOnDrop:Boolean=true;
		[Bindable]
		public function set autoCloseOnDrop(value:Boolean):void{
			_autoCloseOnDrop=value;
		}
		public function get autoCloseOnDrop():Boolean{
			return _autoCloseOnDrop;	
		}
		
		/**
		* When true when the user drags outside the control the state is restored 
	 	* as it was before the drag operation.
		**/
		private var _autoCloseOnExit:Boolean=true;
		[Bindable]
		public function set autoCloseOnExit(value:Boolean):void{
			_autoCloseOnExit=value;
		}
		public function get autoCloseOnExit():Boolean{
			return _autoCloseOnExit;	
		}
				
		/**
		* When true the node will be closed on dragging out of the current node if; 
		* it was not already open before the drag operation started.
		**/
		private var _autoCloseOpenNodes:Boolean=true;
		[Bindable]
		public function set autoCloseOpenNodes(value:Boolean):void{
			_autoCloseOpenNodes=value;
		}
		public function get autoCloseOpenNodes():Boolean{
			return _autoCloseOpenNodes;	
		}
		/**
		* Used to set the timer delay in MS for the closing of the folders.
		**/
		private var _autoCloseTimerMS:Number = 100;
		[Bindable]
		public function set autoCloseTimerMS(value:Number):void{
			_autoCloseTimerMS;
		}
		public function get autoCloseTimerMS():Number{
			return _autoCloseTimerMS;	
		}
		
		/**
		* Used to set the timer delay in MS for opening folders.
		**/
		private var _autoOpenTimerMS:Number = 1000;
		[Bindable]
		public function set autoOpenTimerMS(value:Number):void{
			_autoOpenTimerMS=value;
		}
		public function get autoOpenTimerMS():Number{
			return _autoOpenTimerMS;	
		}
					
		/**
		* The returned dispatched call if delay triggered.
		**/
		private function dispatchDelayedOpen(event:TimerEvent):void{
			
			if(autoCloseOpenNodes==true){
				
				//Stop the indicator if required.
				if (_treeItemRendererFadeEffect.isPlaying){
					_treeItemRendererFadeEffect.end();
					TreeItemRenderer(itemToItemRenderer(event.currentTarget.item)).alpha = 1;
				}
				trace(event.currentTarget.item.isBranch);
				if (event.currentTarget.item.children.length !=0){
					try{
						expandItem(event.currentTarget.item,true,true,true,event);
						toggleState(false);
					}
					catch (err:Error){
						return;
					}
				}
				else{
					try{
						expandItem(event.currentTarget.item,true,false,true,event);
						toggleState(false);
					}
					catch (err:Error){
						return;
					}
				}
			}
		}
		public function toggleState(state:Boolean):void
		{
			
		}
		private function initOpeningIndication(value:Object):void{
						
			//Grab the TreeItemRenderer.
			var currNodeOver:TreeItemRenderer = TreeItemRenderer(itemToItemRenderer(value));
			
			stopAnimation();
			
			_treeItemRendererFadeEffect.target = currNodeOver;
			_treeItemRendererFadeEffect.repeatCount = (((autoOpenTimerMS-200)-_treeItemRendererFadeEffect.startDelay)/200)
			
			callLater(_treeItemRendererFadeEffect.play);
			
						
		}
				
		
		/**
		* stop the currently playing animation
		**/
		private function stopAnimation():void{
			//Stop the indicator if required.
			if (_treeItemRendererFadeEffect.isPlaying){
				_treeItemRendererFadeEffect.end();
				_treeItemRendererFadeEffect.target.alpha = 1;
			}
		}
		
		/**
		* Start closing the opened nodes.
		**/
		private function handleTimerComplete(event:TimerEvent):void{
			closeNodes(event.currentTarget.item);
		}
		
		/**
		* For each item closed re-curse until all items are closed.
		**/
		private function handleItemClosed(event:TreeEvent):void{
			if (DragManager.isDragging){
				if (_lastNodeOver !=null){
					closeNodes(_lastNodeOver.data);
				}
				else{
					closeNodes(null);
				}
			}
		}
		
		/**
		* Once the animation for opening a node is complete, make the 
		* call to close un wanted open nodes. This will re-curse until all
		* items are closed.
		**/		
		private function handleItemOpened(event:TreeEvent):void{
			if (DragManager.isDragging){
				if (_lastNodeOver !=null){
					closeNodes(_lastNodeOver.data);
				}
				else{
					closeNodes(null);
				}
			}
		}
		
		/**
		* Handle the delayed call to close any un wanted nodes.  
	 	* This is called in a few areas to properly handle the closing.
		**/
		private function closeNodes(item:Object=null):void{
			
			if(autoCloseOpenNodes==true){
				
				tweeningNode = item;
				
				if (item==null && _lastNodeOver==null){
					_cleanUpDelayedTimer.startDelayedTimer(restoreState,null,null,autoCloseTimerMS,1,null);
				}
				else{
					_cleanUpDelayedTimer.startDelayedTimer(closeOpenNodes,null,null,autoCloseTimerMS,1,item);
				}
			}
		}
				
		
		/**
		* Listen for the spacebar key and open folder if not 
		* already open, then cancel the timer.
		**/
		private function handleKeyEvents(event:KeyboardEvent):void{
			switch(event.keyCode){
				case 32:
				
					if (_lastNodeOver !=null){
		
						_delayedTimer.cancelDelayedTimer();
						stopAnimation();
						
						if (_lastNodeOver.data.isBranch==true){
							if (_lastNodeOver.data.children.length==0){
								try{
									expandItem(_lastNodeOver.data,true,false);
									toggleState(false);
								}
								catch (err:Error){
									break;	
								}
							}
							else{
								try{
									expandItem(_lastNodeOver.data,true,true);
									toggleState(false)
								}
								catch (err:Error){
									break;	
								}
							}
							
						}
					}
					
			}
		}
		/**
		* Handle the drag over trying to make sure we don't do unnecessary calls.
		* Store the node that the user is currently over for proper close testing.
		* Dispatch the delayed open call if over a new node.
		**/
		private function handleDragOver(event:DragEvent):void{
			
			if(autoCloseOpenNodes==false){return;}
					
			//Get the node currently dragging over.
			var currNodeOver:TreeItemRenderer = TreeItemRenderer(indexToItemRenderer(calculateDropIndex(event)));
			
			if (currNodeOver !=null){
				
				//If not a branch node exit.
				if (currNodeOver.data.isBranch!=true){
					_delayedTimer.cancelDelayedTimer();
					stopAnimation();
					return;
				}
				
				//Cleanup opened nodes.
				closeNodes(currNodeOver.data);
						
				//If the current node is not open then dispatch timer.
				if (isItemOpen(currNodeOver.data)==false){
				
					//If it's already running on the current item avoid a timer reset.
					if (_delayedTimer.running ==true && _delayedTimer.item ==currNodeOver.data){
						return;
					}
					else if (_delayedTimer.running ==true) {
						//Clear the current delayed timer.
						_delayedTimer.cancelDelayedTimer();
						stopAnimation();
					} 
										
					//Set the local new folder over.
					_lastNodeOver = currNodeOver;
				
					//Start the indication if required "showOpeningIndication".
					if (_showOpeningIndication){
						initOpeningIndication(currNodeOver.data);
					}
														
					//Create callback.
					_delayedTimer.startDelayedTimer(dispatchDelayedOpen,null,null,autoOpenTimerMS,1,currNodeOver.data);
					
					
					
				}
			}
			
			else{
				//If not over any node cleanup and return.
				if (_lastNodeOver != null){
					_delayedTimer.cancelDelayedTimer();
					stopAnimation();
					_lastNodeOver = null;
				}
			}
		}
		
		/**
		* Init the start of the drag and grab a open folder stack so we can 
		* compare later when closing, opening, exiting etc..
		**/		
		private function handleDragStart(event:DragEvent):void{
			if(autoCloseOpenNodes==true){
				stopAnimation();
				_delayedTimer.cancelDelayedTimer();
				openedFolderHierarchy = openItems;
			}
		}
		
		/**
		* Cleanup the drag operation and call restore to set the nodes as 
		* before the drag operation started.
		**/
		private function handleDragComplete(event:DragEvent):void{
			if(autoCloseOpenNodes==true){
				_delayedTimer.cancelDelayedTimer();
				_lastNodeOver = null;
				
				stopAnimation();
				
				if(_autoCloseOnDrop==true){
					closeNodes(null);
				}
			}
		}
		
		/**
		* Same as above in a different handler due to it being an optional process. 
		**/ 
		private function handleDragExit(event:DragEvent):void{
			_delayedTimer.cancelDelayedTimer();
			_lastNodeOver = null;
			stopAnimation();
			if(_autoCloseOnExit==true){
				closeNodes(null);
			}
			
		}
				
		/**
		* Restore tree structure to original state based on the open items 
		* before the drag operation. Called from drag exit and drop complete 
		* to reset original state.
		**/
		private function restoreState(event:TimerEvent):void{
			
			//Back out if state has changed since timer delay setting.
			if (_lastNodeOver != null){return;}
			
			//Get a current state of hierarchy.
			var currentOpenFolders:Object=openItems;
			
			for (var i:int = 0; i < currentOpenFolders.length; i++){
				if (openedFolderHierarchy.indexOf(currentOpenFolders[i])==-1){
					
					if (currentOpenFolders[i].isBranch==true){
						if (!currentOpenFolders[i].children.length==0){
							
							try{
								expandItem(currentOpenFolders[i],false,true,true);
							}
							catch (err:Error){
								break;	
							}
							break;
						}
						else{
							try{
								expandItem(currentOpenFolders[i],false,false,true);
							}
							catch (err:Error){
								break;
							}
							
						}
						
					}
					
				}
			}
			
			
		}
		
		
		/**
		* Close all nodes as required, except the current node the user is 
		* dragging over, and only if the node to be closed is not part of the 
		* original open node stack.
		**/
		private function closeOpenNodes(event:TimerEvent):void{
			
			var parentItems:Object = getParentStack(event.currentTarget.item);
			
			//Get a current state of hierarchy.
			var currentOpenFolders:Object=openItems;
			
			for (var i:int = 0; i < currentOpenFolders.length; i++){
				//Make sure it was not opened before the drag start
				//and the current node that we are dragging over
				//is not going to be closed.
				if (openedFolderHierarchy.indexOf(currentOpenFolders[i])==-1){
					if (currentOpenFolders[i]!=event.currentTarget.item && parentItems.indexOf(currentOpenFolders[i])==-1){
						//Otherwise close the node.
						if (currentOpenFolders[i].isBranch==true){
							if (!currentOpenFolders[i].children.length==0){
								try{
									expandItem(currentOpenFolders[i],false,true,true);	
								}
								catch (err:Error){
									break;	
								}
								break;
							}
							else{
								try{
									expandItem(currentOpenFolders[i],false,false,true);
								}
								catch (err:Error){
									break;
								}
							}
							
							
						}
					}
				}
			}
		}
		
		//override the tween end to avoid nasty error on the close of 
		//a node with no children when calling expandItem. without this
		//sometimes when closeing a node with no children generates an
		//Error #1009 in the tree.as error is unhandled so it explodes
		//the app. 
		override mx_internal function onTweenEnd(value:Object):void{
			
			try{
				super.mx_internal::onTweenEnd(value);
			}
			catch(err:Error){
				//Tween failure a nasty flex bug.
				//trace(err.message); 
			}
			
		}
		
		
		/**
	    * Returns the stack of parents from a child item. 
	    * Note: Stolen from tree code in framwork handy :)!!
	    */
	    private function getParentStack(item:Object):Array{
	        var stack:Array = [];
	        if (item == null)
	            return stack;
	        
	        	var parent:* = getParentItem(item);
	    	    while (parent){
	        	    stack.push(parent);
	    	        parent = getParentItem(parent);
		        }
	        	return stack;       
	    }
	 	
	 		 	
	 	
	}
}