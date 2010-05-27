package com.daveoncode.filters {
	
	/**
	 * The only purpose of Filter is to be wrapped by one or more filters (classes which extend AbstractFilter)
	 * 
	 * @author Davide Zanotti (davidezanotti@gmail.com)
	 */
	public class Filter implements IFilter {
		
		/**
		 * A wildcard which means "all values are accepted"
		 */
		public static const ALL_VALUES:String = "*";
		
		public function Filter() {
			
		}

		/**
		 * This is a basic implementation of IFilter interface, the value returned is always true and only apply() 
		 * methods implemented by subclasses of AbstractFilter have real buisiness logic implementation
		 * 
		 * @return Boolean <p>Always true</p>
		 */
		public function apply(item:Object):Boolean {
			
			return true;
			
		}
		
	}
	
}