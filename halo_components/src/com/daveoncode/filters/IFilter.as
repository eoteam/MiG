package com.daveoncode.filters {
	
	/**
	 * Defines a common interface that must be implemented by all the filters.
	 * 
	 * @author Davide Zanotti (davidezanotti@gmail.com)
	 */
	public interface IFilter {
		
		function apply(item:Object):Boolean;
		
	}
	
}