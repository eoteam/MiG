package com.daveoncode.filters {
	
	/**
	 * The base abstract class of all concrete filters
	 * 
	 * @author Davide Zanotti (davidezanotti@gmail.com)
	 */
	public class AbstractFilterDecorator implements IFilter {
		
		/**
		 * A reference to a wrapped IFilter object
		 */
		protected var _target:IFilter;
		
		/**
		 * Value against which the filter is applied
		 */
		protected var _value:Object;
		
		/**
		 * Since this class is abstract this constructor MUST be called only by subclasses of AbstractFilterDecorator
		 * (concrete filters decorators)
		 * 
		 * @param target IFilter <p>A reference to a wrapped IFilter object</p>
		 * @param value Object <p>Value against which the filter is applied</p>
		 */
		public function AbstractFilterDecorator(target:IFilter, value:Object) {
			
			this._target = target;
			this._value = value;
			
		}
		
		/**
		 * Basic implementation of IFilter interface the value returned is always true and only apply() 
		 * methods implemented by subclasses of AbstractFilter have real buisiness logic implementation
		 */
		public function apply(item:Object):Boolean {
			
			return true;
			
		}
		
	}
	
}