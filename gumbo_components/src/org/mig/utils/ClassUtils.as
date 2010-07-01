package org.mig.utils
{
	import flash.utils.getDefinitionByName;
	
	/**
	 * Class utilities such as dynamic instantiation.
	 */
	public class ClassUtils
	{
		public static function instantiateClass(className:String):*
		{
			var instance:*;
			
			try
			{
				instance = getDefinitionByName(className);
			}
			catch (e:Error)
			{
					throw new Error("Could not find class for className: " + className);
			}
			
			return new instance();
		}
	}
}