package org.mig.view.containers
{

	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.controls.SWFLoader;
	import mx.controls.Text;
	import mx.controls.listClasses.AdvancedListBase;
	import mx.controls.listClasses.ListBase;
	import mx.controls.scrollClasses.ScrollBar;
	import mx.controls.scrollClasses.ScrollThumb;
	import mx.core.ClassFactory;
	import mx.core.DragSource;
	import mx.core.FlexLoader;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.managers.DragManager;
	
	import org.mig.model.vo.media.FileNode;
	import org.mig.view.controls.AssociativeInstanceCache;
	import org.mig.view.controls.CachedLabel;
	import org.mig.view.controls.DragTileMultiProxy;
	import org.mig.view.controls.LayoutAnimator;
	import org.mig.view.controls.LayoutTarget;
	import org.mig.view.interfaces.IContentListRenderer;

	/** the amount of space, in pixels, between invidual items */
	[Style(name="spacing", type="Number", inherit="no")]
	[Style(name="padding", type="Number", inherit="no")]
	[Style(name="horizontalAlign", type="String", enumeration="left,center,right", inherit="no")]
	[Style(name="horizontalGap", type="Number", inherit="no")]
	[Style(name="verticalGap", type="Number", inherit="no")]
		
	[Event(name="orderChange" , type="flash.events.Event")]
	[Event(name="selectionChange", type="flash.events.Event")]
	
	public class DragTile extends Canvas
	{
		private var _items:ArrayCollection;
		private var _pendingItems:ArrayCollection;
		protected var dpChanged:Boolean = false;
		protected var itemsChanged:Boolean = false;
		/** true if the renderers need to be regenerated */
		protected var renderersDirty:Boolean = true;
		/** the renderers representing the data items, one for each item */
		private var renderers:Array = [];
		/** the factory that generates item renderers
		 */
		private var _itemRendererFactory:IFactory;
		/** 
		 * the object that manages animating the children layout
		 */
		private var _rowLength:int = 16;
		private var _maxRowLength:Number = Number.MAX_VALUE;
		private var _colLength:int;
		private var _tileWidth:int;
		private var _tileHeight:int;
		private var _userTileWidth:Number;
		private var _userTileHeight:Number;
		private var _dragTargetIdx:Number;
		private var _dragMouseStart:Point;
		private var _dragMousePos:Point;
		private var _dragPosStart:Point;
		private var _dragAction:String;
		private var _renderCache:AssociativeInstanceCache;
				
		private var animator:LayoutAnimator;
		public var dataField:String = "data";
		public var dragEnabled:Boolean = true;
		
		private var selectionRectangle:Canvas;
		private var r:Rectangle;
		private var dragItems:Array;
		private var isDragging:Boolean = false;
		private var commandKey:Boolean = false;
		private var shiftKey:Boolean = false;
		private var indicator:UIComponent;
		private var sequentialSelection:Boolean = false;
		private var _selectedItems:Array = new Array();				
		
		[Bindable] private  var _scalePercent:Number = 0.4;
		private var shiftFirstItem:IContentListRenderer;
		private var shiftLastItem:IContentListRenderer;	
		
		public function DragTile()
		{
			super(); 
			_itemRendererFactory= new ClassFactory(CachedLabel);
			animator = new LayoutAnimator();
			animator.autoPrioritize = false;
			animator.animationSpeed = .2;
			animator.layoutFunction = generateLayout;
			animator.updateFunction = layoutUpdated;
			
			//horizontalScrollPolicy = ScrollPolicy.OFF;
			clipContent = true;
			
			_renderCache = new AssociativeInstanceCache();
			_renderCache.factory = _itemRendererFactory;
			
			if(dragEnabled)
			{
				addEventListener(MouseEvent.MOUSE_DOWN,startReorder);
				addEventListener(DragEvent.DRAG_EXIT,dragOut);
				addEventListener(DragEvent.DRAG_DROP,dragDrop);
				addEventListener(DragEvent.DRAG_COMPLETE,dragComplete);
			}
			addEventListener(MouseEvent.MOUSE_UP,onSelection);
			addEventListener(Event.REMOVED_FROM_STAGE,handleRemovedFromStage);	
			addEventListener(FlexEvent.CREATION_COMPLETE,init);			
		}	
		private function init(event:FlexEvent):void
		{
			/* Set the event listeners */			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,handleKeyDown);
			//this.parent.addEventListener(MouseEvent.MOUSE_DOWN,setUpMarquis);
		}		
		private function onSelection(event:Event):void
		{
			if(_selectedItems)
				dispatchEvent(new Event('selectionChange'));
		}		
		private function handleKeyDown(event:KeyboardEvent):void
		{
			if(event.ctrlKey || event.shiftKey)
			{
				commandKey = event.ctrlKey;
				shiftKey = event.shiftKey
				this.stage.addEventListener(KeyboardEvent.KEY_UP,handleKeyUp);
				this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleKeyDown);					
			}
		}
		private function handleKeyUp(event:KeyboardEvent):void
		{
			//if(event.ctrlKey)
			//{			
				commandKey = false;
				shiftKey = false;
				this.shiftFirstItem = null;
				this.shiftLastItem = null;
				this.stage.removeEventListener(KeyboardEvent.KEY_UP,handleKeyUp);
				this.stage.addEventListener(KeyboardEvent.KEY_DOWN,handleKeyDown);
			//}
		}		
		private function handleRemovedFromStage(event:Event):void
		{
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleKeyDown);
			this.stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
		}
		public function get selectedItems():Array
		{
			var result:Array = [];
			for each(var r:IUIComponent in _selectedItems)
				result.push(r[dataField]);
			return result;
		}	
		public function set selectedItems(value:Array):void
		{
			_selectedItems = [];
			for each(var r:IContentListRenderer in renderers)
			{
				if(value.indexOf(r[dataField]) != -1)
				{
					r.selected = true;
					_selectedItems.push(r);
				}
				else
					r.selected = false;
			}
		}			
		public function set scalePercent(value:Number):void
		{
			_scalePercent = value;
		}
		[Bindable]
		public function get scalePercent():Number
		{
			return _scalePercent;
		}		
		public function set dataProvider(value:ArrayCollection):void
		{
			_pendingItems= value;
			renderersDirty = true;
			itemsChanged = true;
			dpChanged = true;
			invalidateProperties();			
		}
		[Bindable] public function get dataProvider():ArrayCollection
		{
			return 	_items;
		}
		//-----------------------------------------------------------------
		public function set maxRowLength(value:int):void
		{
			_maxRowLength = value;
			invalidateSize();
			invalidateDisplayList();
		}
		public function get maxRowLength():int
		{
			return _maxRowLength;
		}
		//-----------------------------------------------------------------
		public function set tileWidth(value:Number):void
		{
			_userTileWidth = value;
			invalidateSize();
			invalidateDisplayList();
		}
		public function get tileWidth():Number
		{
			return isNaN(_userTileWidth)? _tileWidth:_userTileWidth;
		}
		//-----------------------------------------------------------------
		public function set tileHeight(value:Number):void
		{
			_userTileHeight = value;
			invalidateSize();
			invalidateDisplayList();
		}
		public function get tileHeight():Number
		{
			return isNaN(_userTileHeight)? _tileHeight:_userTileHeight;
		}
		//-----------------------------------------------------------------
		/**
		 * by making the itemRenderer be of type IFactory, 
		 * developers can define it inline using the <Component> tag
		 */
		public function get itemRenderer():IFactory
		{
			return _itemRendererFactory;
		}
		public function set itemRenderer(value:IFactory):void
		{
			_itemRendererFactory = value;
			_renderCache.factory = value;
			renderersDirty = true;
			invalidateProperties();						
		}
		public function set newItems(items:Array):void //the set passes an array of ContainerNodes, the get returns an array of renderers
		{
			for each(var item:Object in items)
			{
				item.added = false;
				_items.addItem(item);
			}
			renderersDirty = true;
			invalidateProperties();			
		}
		public function get newItems():Array
		{
			var result:Array = [];
			for each (var item:UIComponent in renderers)
			{
				if(item[dataField] is FileNode)
				{
					result.push(item);
				}
			}
			return result;
		}		
		private function handleItemSelected(event:Event):void
		{
			if(!commandKey && !shiftKey)
			{
				for each(var renderer:IContentListRenderer in renderers)
				{
					if(renderer == event.target)
						renderer.selected = true;
					else
						renderer.selected = false;
				}
			}			
		}					
		private function get spacingWidthDefault():Number
		{
			var result:Number = getStyle("spacing");
			if(isNaN(result))
				result = 10;
			return result;
		}
		private function get hGapWithDefault():Number
		{
			var result:Number = getStyle("horizontalGap");
			if(isNaN(result))
				result = 4;
			return result;
		}
		private function get vGapWithDefault():Number
		{
			var result:Number = getStyle("verticalGap");
			if(isNaN(result))
				result = 4;
			return result;
		}
		private function get paddingWidthDefault():Number
		{
			var result:Number = getStyle("padding");
			if(isNaN(result))
				result = 20;
			return result;
		}
		override protected function commitProperties():void
		{
			// its now safe to switch over new dataProviders.
			isDragging = false;
			if(dpChanged)
			{
				_items = _pendingItems
				//_items.addAll(_pendingItems);
				dpChanged = false;				
			}
			
			itemsChanged = false;
			
			if(renderersDirty && _items)
			{
				// something has forced us to reallocate our renderers. start by throwing out the old ones.
				renderersDirty = false;
				//var i:int=0;
				for(var i:int=numChildren-1;i>= 0;i--)
				{
					removeChildAt(i);
				}
				renderers = [];
				_renderCache.beginAssociation();
				// allocate new renderers, assign the data.
				for(i = 0;i<_items.length;i++)
				{
					var renderer:IUIComponent = _renderCache.associate(_items.getItemAt(i));
					IDataRenderer(renderer).data = _items.getItemAt(i);
					renderer[dataField] = _items.getItemAt(i);						
					renderers[i] = renderer;
					addChild(DisplayObject(renderer));
					
					if(renderer is IContentListRenderer)
					{
						BindingUtils.bindProperty(Object(renderer), "scalePercent", this, "scalePercent");	
						renderer.addEventListener("selected", handleItemSelected,false,0,true);
						var newIndex:int
						if(_items.getItemAt(i) is FileNode)
						{
							IContentListRenderer(renderer).added = false;
							if(_selectedItems && selectedItems.indexOf(_items.getItemAt(i)) != -1)
							{
								newIndex = selectedItems.indexOf(_items.getItemAt(i));
								_selectedItems[newIndex] = renderer;
								IContentListRenderer(renderer).selected = true;
							}							
						}
						else
						{
							IContentListRenderer(renderer).added = true;
							if(_selectedItems && selectedItems.indexOf(_items.getItemAt(i)) != -1)
							{
								newIndex = selectedItems.indexOf(_items.getItemAt(i));
								_selectedItems[newIndex] = renderer;
								IContentListRenderer(renderer).selected = true;
							}
						}				
					}						
				}
				_renderCache.endAssociation();
			}
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,handleKeyDown);
			invalidateSize();
		}		
		override protected function measure():void
		{
			_tileWidth = 0;
			_tileHeight = 0;
			
			// first, calculate the largest width/height of all the items, since we'll have to make all of the items
			// that size
			if(renderers.length > 0)
			{
				if(isNaN(_userTileHeight) || isNaN(_userTileWidth))
				{
					for(var i:int=0;i<renderers.length;i++)
					{
						var itemRenderer:IUIComponent = renderers[i];
						_tileWidth = Math.ceil(Math.max(_tileWidth,itemRenderer.getExplicitOrMeasuredWidth()));
						_tileHeight = Math.ceil(Math.max(_tileHeight,itemRenderer.getExplicitOrMeasuredHeight()));
					}
				}
				if(!isNaN(_userTileHeight))
					_tileHeight = _userTileHeight;
				if(!isNaN(_userTileWidth))
					_tileWidth = _userTileWidth;
			}
			// square them off
			//_tileWidth = Math.max(_tileWidth,_tileHeight);
			//_tileHeight = _tileWidth;		
			var itemsInRow:Number = Math.min(renderers.length,Math.min(_maxRowLength,_rowLength));
			
			var spacing:Number = spacingWidthDefault;
			var hGap:Number = hGapWithDefault;
			var vGap:Number= vGapWithDefault;
			
			measuredWidth = itemsInRow * _tileWidth + (itemsInRow - 1) * hGap;
			var defaultColumnCount:Number = Math.ceil(renderers.length / Math.min(_maxRowLength,_rowLength));
			measuredHeight = defaultColumnCount*_tileHeight + (defaultColumnCount-1)*vGap;
	
			animator.invalidateLayout();		
							
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			graphics.clear();
			graphics.moveTo(0,0);
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
			animator.invalidateLayout();			
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}
		private function findItemAt(px:Number,py:Number,seamAligned:Boolean):Number
		{
			var gPt:Point = localToGlobal(new Point(px,py));
			
			px += horizontalScrollPosition;
			py += verticalScrollPosition;
			
			var spacing:Number = spacingWidthDefault;
			var hGap:Number = hGapWithDefault;
			var vGap:Number= vGapWithDefault;
			var padding:Number = paddingWidthDefault;
			
			var targetWidth:Number = unscaledWidth -2*padding + hGap;
			var rowLength:Number = Math.max(1,Math.min(renderers.length,Math.min(_maxRowLength,Math.floor(targetWidth/(_tileWidth+hGap)) )));
			var colLength:Number = (rowLength == 0)? 0:(Math.ceil(renderers.length / rowLength));
			
			var hAlign:String = getStyle("horizontalAlign");
			var leftSide:Number = (hAlign == "left")? 	padding:
				(hAlign == "right")? 	(unscaledWidth - (rowLength * _tileWidth + (rowLength-1) * hGap + 2*padding)):
				(unscaledWidth - (rowLength * _tileWidth + (rowLength-1) * hGap + 2*padding))/2
			
			var rowPos:Number = (px-padding - leftSide) / (_tileWidth + hGap);
			var colPos:Number = (py-vGap/2) / (_tileHeight + vGap);
			rowPos = (seamAligned)? Math.round(rowPos):Math.floor(rowPos);
			colPos = Math.floor(colPos);
			
			if(seamAligned)
			{
				rowPos = Math.max(0,Math.min(rowPos,rowLength));
				colPos = Math.max(0,Math.min(colPos,colLength));
				var result:Number = colPos * rowLength + rowPos;						
				return Math.min(_items.length,result);
				
			}
			else
			{
				if(rowPos >= rowLength || rowPos < 0)
					return NaN;
				if(colPos >= colLength || colPos < 0)
					return NaN;
				result = colPos * rowLength + rowPos;																	
				if(result > _items.length)
					return NaN;
				var r:DisplayObject = renderers[result];
				if(r.hitTestPoint(gPt.x,gPt.y,true) == false)
					return NaN;					
				return result;
			}
		}			
		private function addShiftItems():void
		{
			var shiftStart:int = this.getChildIndex(shiftFirstItem as UIComponent);
			var shiftEnd:int = this.getChildIndex(shiftLastItem as UIComponent);
			var i:int = shiftStart > shiftEnd ? shiftEnd:shiftStart;
			var j:int = shiftStart > shiftEnd ? shiftStart:shiftEnd;
			_selectedItems = [];
			for (var k:int=i;k<= j;k++)
			{
				IContentListRenderer(this.getChildAt(k)).selected = true;
				_selectedItems.push(this.getChildAt(k));
			}					
		}
		private function startReorder(e:MouseEvent):void
		{	
			if(	(e.target is FlexLoader || e.target is Text || (e.target is Label && e.target.parent.id == 'dragCanvas') || ( e.target is IContentListRenderer)) && dragEnabled)
			{	
				var currentItem:IContentListRenderer;
				if(e.target is FlexLoader)
					currentItem = e.target.parent.parentDocument; //parent is image and parentDocument is render class	
				else if(e.target is IContentListRenderer)
					currentItem = e.target as IContentListRenderer;
				else
					currentItem = e.target.parent;	
				if(!commandKey && !shiftKey)
				{	
					
					if(_selectedItems.indexOf(currentItem) == -1 || _selectedItems.length == 1)
					{
						_selectedItems = [currentItem];
						for each(var renderer:IContentListRenderer in renderers)
						{
							if(renderer == currentItem)
							{
								renderer.selected = true;
								UIComponent(renderer).invalidateProperties();
							}
							else
								renderer.selected = false;
						}
					}
					var dragIdx:Number = findItemAt(mouseX,mouseY,false);
					if(isNaN(dragIdx))
						return;
					
					if(verticalScrollBar != null && verticalScrollBar.contains(DisplayObject(e.target)))
						return;
					if(horizontalScrollBar != null && horizontalScrollBar.contains(DisplayObject(e.target)))
						return;
						
					var dragItem:IUIComponent = renderers[dragIdx];	
					var dragImage:UIComponent = this.dragImage;
					var dragSrc:DragSource = new DragSource();
					dragSrc.addData([dataProvider[dragIdx]],"items");
					dragSrc.addData(dragIdx,"index");
					
					var pt:Point = DisplayObject(dragItem).localToGlobal(new Point(0,0));
					pt = globalToLocal(pt);
					DragManager.doDrag(this,dragSrc,e,dragImage,-pt.x - 4 ,-pt.y - 4,.6);
				}
				else if(commandKey)
				{
					if(_selectedItems.indexOf(currentItem) == -1)
					{
						_selectedItems.push(currentItem);
						IContentListRenderer(currentItem).selected = true;
					}
					else
					{
						var index:int = _selectedItems.indexOf(currentItem);
						IContentListRenderer(currentItem).selected = false;
						_selectedItems.splice(index,1);					
					}					
				}
				else if(shiftKey)
				{
					if(this._selectedItems.length == 1 && shiftFirstItem == null )
					{
						shiftFirstItem = _selectedItems[0];
						shiftFirstItem.selected = true;
						this.shiftLastItem = currentItem;
						this.addShiftItems();
					}
					else if(this._selectedItems.length == 0 && shiftFirstItem == null)
					{
						shiftFirstItem  = currentItem;
						shiftFirstItem.selected = true;
					}
					else
					{
						this.shiftLastItem = currentItem;
						this.addShiftItems();							
					}
				}				
			}
			else 
			{
				setUpMarquis(e);
			}
		}
		private function setUpMarquis(e:Event):void
		{
			if( (!(e.target is Label) && !(e.target is ScrollThumb) && !(e.target is ScrollBar) && !(e.target.parent is SWFLoader)) 
				|| e.target == this.parent)
			{
				r = new Rectangle(Number(this.parent.mouseX),Number(this.parent.mouseY),0,0);
				selectionRectangle = new Canvas();		
				selectionRectangle.x = r.x;
				selectionRectangle.y = r.y;
				selectionRectangle.width = r.width;
				selectionRectangle.height = r.height;
				selectionRectangle.styleName = "selectionRectangleStyle";
				this.parent.addEventListener(MouseEvent.MOUSE_UP, onMouseUp,false,0,true);
				this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp,false,0,true);
				this.parent.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove,false,0,true);	
				this.addChild(selectionRectangle);			
			}
		}
		private function get dragImage():UIComponent
		{
			var dragProxy:DragTileMultiProxy = new DragTileMultiProxy();
			dragProxy.addItems(_selectedItems);
			return dragProxy;
		}
		public function refresh():void
		{
			renderersDirty = true;
			itemsChanged = true;
			invalidateProperties();	
		}
		public function itemToItemRenderer(item:Object):IContentListRenderer
		{
			var result:IContentListRenderer;
			for each(var r:IContentListRenderer in renderers)
			{
				if(r[dataField] == item)
				{
					result = r;
					break;
				}
			}	
			return result;
		}
		public function allowDrag(e:DragEvent,dragAction:String = "copy"):void
		{
			_dragAction = dragAction;
			if(e.dragInitiator == this && dragEnabled )
			{
		    	DragManager.acceptDragDrop(this);
				e.action = _dragAction;
				DragManager.showFeedback(DragManager.COPY);
				isDragging = true;
				if(!indicator || !this.parentDocument.contains(indicator))
				{ 
					indicator = new UIComponent();
					var sprite:Sprite = new	Sprite();
		            var g:Graphics = sprite.graphics;
		            g.clear();
		            g.beginFill(0xED1C58, 1);
		            g.drawRect(0,5, 2,100);	
		            g.drawCircle(0,0,5);
		            indicator.addChild(sprite);
		            
		            indicator.width = 3;
		            indicator.height = 100;
		            indicator.visible = false;	
		           				
					this.parentDocument.addChild(indicator);			
				}			
			}
		    else
			{
				isDragging = false;			
			}
			animator.animationSpeed = .1;
		}
		public function showDragFeedback(e:DragEvent,dragAction:String = "move"):void
		{
			_dragAction = dragAction;
			DragManager.showFeedback(_dragAction);				
			_dragTargetIdx = findItemAt(mouseX,mouseY,true);
			_dragMousePos = new Point(mouseX,mouseY);
			animator.invalidateLayout(true);						
		}

		private function dragDrop(e:DragEvent):void
		{
			_dragTargetIdx = findItemAt(mouseX,mouseY,true);
			indicator.visible = false;
			indicator.x = 0;
			indicator.y = 0;	
			isDragging = false;
			if(e.dragInitiator == this) // drag drop within
			{
				var i:int = 0;
				if(e.dragInitiator == this)
				{
					e.dragSource.addData(this,"target");
				}
				if(e.dragInitiator == this && e.action == _dragAction)
				{				
					DragManager.showFeedback(_dragAction);
					var dragFromIndex:Number;// = Number(e.dragSource.dataForFormat("index"));
					for(i=_selectedItems.length-1;i>=0;i--)
					{
						dragFromIndex = _items.getItemIndex(_selectedItems[i][dataField]);
						_items.removeItemAt(dragFromIndex);
						if(_dragTargetIdx > dragFromIndex)
						{
							_items.addItemAt(_selectedItems[i][dataField],_dragTargetIdx-1);
						}
						else
						{
							_items.addItemAt(_selectedItems[i][dataField],_dragTargetIdx);
						}
					}	
				}
			}
			renderersDirty = true;
			itemsChanged = true;
			invalidateProperties();	
			this.dispatchEvent(new Event('orderChange'));
		}
		private function newRendererFor(item:*):IUIComponent
		{
			var r:IUIComponent = _itemRendererFactory.newInstance();
			IDataRenderer(r).data = item;
			addChild(DisplayObject(r));
			return r;
		}
		private function dragComplete(e:DragEvent):void
		{
			if(e.action == DragManager.MOVE && e.dragSource.dataForFormat("target") != this)
			{
				var dragFromIndex:Number = Number(e.dragSource.dataForFormat("index"));
				_items.source.splice(dragFromIndex,1);
				_items.refresh();
				var r:IUIComponent = renderers.splice(dragFromIndex,1)[0];
				removeChild(DisplayObject(r));
				animator.invalidateLayout();
			}
			hideIndicator();
			invalidateSize();
			this.generateLayout();
		}
		private function dragOut(e:DragEvent):void
		{
			_dragTargetIdx = NaN;
			animator.animationSpeed = .2;						
			animator.invalidateLayout(true);
		}
		private function layoutUpdated():void
		{
			validateDisplayList();
		}
		private function hideIndicator():void
		{
			if(!isDragging && indicator!=null && this.parentDocument.contains(indicator))
			{
				this.parentDocument.removeChild(indicator);	
				indicator = null;
				this.callLater(refreshLayout);
			}		
		}
		private function refreshLayout():void
		{
			this.itemsChanged = true;
			invalidateProperties();			
		}
		private function generateLayout():void
		{
			var spacing:Number = spacingWidthDefault;
			var hGap:Number = hGapWithDefault;
			var vGap:Number= vGapWithDefault;
			var padding:Number = paddingWidthDefault;
			var targetWidth:Number = unscaledWidth - 2*padding + hGap;
			var rowLength:Number = Math.max(1,Math.min(renderers.length,Math.min(_maxRowLength,Math.floor(targetWidth/(hGap + _tileWidth)) )));
			var colLength:Number = Math.ceil(renderers.length / rowLength);
			
			var hAlign:String = getStyle("horizontalAlign");
			
			var leftSide:Number = (hAlign == "left")? 	padding:
								  (hAlign == "right")? 	(unscaledWidth - (rowLength * _tileWidth + (rowLength-1) * hGap + 2*padding)):
													  	(unscaledWidth - (rowLength * _tileWidth + (rowLength-1) * hGap + 2*padding))/2
			
			var positionFunc:Function = function(r:int,c:int,offset:Number):void
			{			
				var idx:int = c*rowLength + r;
				if(idx >= renderers.length)
					return;								
				var renderer:IUIComponent = renderers[idx];
				var target:LayoutTarget = animator.targetFor(renderer);//targets[idx];
				target.scaleX = target.scaleY = 1;
				target.item = renderer;
				target.unscaledWidth = (isNaN(renderer.percentWidth)? renderer.getExplicitOrMeasuredWidth():renderer.percentWidth/100*_tileWidth);
				target.unscaledHeight = renderer.getExplicitOrMeasuredHeight();
				target.x = offset + r * (_tileWidth + hGap) + _tileWidth/2 - target.unscaledWidth/2;
				target.y = vGap + c * (_tileHeight + vGap)+ _tileHeight/2 - target.unscaledHeight/2;
				target.animate = true;					
			}

			var insertRowPos:Number = _dragTargetIdx % rowLength;
			var insertColPos:Number = Math.floor(_dragTargetIdx / rowLength);
			var add:Number;
			if(indicator)
			{
				this.indicator.x = insertRowPos*(_tileWidth+hGap) + leftSide+10;
				this.indicator.y = insertColPos*(_tileHeight+vGap)+padding+30;
				indicator.visible = true;
				this.callLater(hideIndicator);
			} 	
			for(var c:int = 0;c<colLength;c++)			
			{
				if(c == insertColPos)
				{
					for(var r:int = 0;r<insertRowPos;r++)
					{
						positionFunc(r,c,leftSide);
					}
					for(r = insertRowPos;r<rowLength;r++)
					{
						add = isDragging?padding:0;
						positionFunc(r,c,leftSide+add);
					}
				}
				else
				{
					for(r = 0;r<rowLength;r++)
					{
						add = isDragging?padding:0;
						positionFunc(r,c,leftSide + add);
					}
				}
			}
		}
		override public function styleChanged(styleProp:String):void
		{
			invalidateSize();
			invalidateDisplayList();
			animator.invalidateLayout();
		}
		private function onMouseUp(e:MouseEvent):void
		{
			//Get an array of items on stage
			var children:Array = this.getChildren();		
			_selectedItems = new Array();		
			/* Find items that intersect with the selection rectangle */
			for(var i:uint = 0; i< children.length; i++)
			{
				if((children[i] as DisplayObject) != selectionRectangle && children[i] != indicator && !(children[i] is Canvas))
				{
					if(selectionRectangle.getRect(this).intersects((children[i] as DisplayObject).getRect(this)))
					{
						_selectedItems.push(children[i]);
						IContentListRenderer(children[i]).selected = true;
					}
					else
						IContentListRenderer(children[i]).selected = false;
				}
			}		
			//Remove the selection rectangle
			//this.parentDocument.removeChild(selectionRectangle);
			//ouText = _selectedItems.length + " items selected";
			this.parent.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.parent.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.removeChild(selectionRectangle);
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			//Keep resizing the Rectangle object and the canva
			r.bottomRight = new Point(this.parent.mouseX, this.parent.mouseY);
			selectionRectangle.x = r.x;
			selectionRectangle.y = r.y;
			selectionRectangle.width = r.width;
			selectionRectangle.height = r.height;
			updateMarquis();
		}
		private function updateMarquis():void
		{
			//trace(Math.abs(selectionRectangle.y+selectionRectangle.height - parent.height));
			if(Math.abs(selectionRectangle.y+selectionRectangle.height - parent.height) <= 10 && selectionRectangle.height > 0)
			{
				trace("down");
				this.verticalScrollPosition += 10;
				r.bottomRight = new Point(this.mouseX, this.mouseY+10);
				selectionRectangle.width = r.width;
				selectionRectangle.height = r.height;				
				this.callLater(updateMarquis);
			}			
		}
		
	}
}