/*
* Robotlegs Chat Client Example using WebORB (authentication) and the Union Platform
* for client communicaton.
* 	
* Copyright (c) 2009 the original author or authors
*
* http://creativecommons.org/licenses/by-sa/3.0/
*	
* original author:
* Joel Hooks
* http://joelhooks.com
* joelhooks@gmail.com 
*/
package org.mig.controller.startup
{
	/**
	 * Static constants and variables used for starting the Finite State
	 * Machine used by this example for application bootstrapping.
	 *  
	 * @author joel
	 * 
	 */	
	public class AppStartupStateConstants
	{
		
		/***********************************************FSM*************************************************/
		public static const STARTING:String              			= "state/startup/starting";
		public static const START:String                 			= "event/startup/start";
		public static const STARTED:String               			= "action/startup/completed/start";
		public static const START_FAILED:String          			= "action/startup/start/failed";
			
		public static const STARTINGUP_COMPLETE:String				= "state/startingComplete";
		public static const STARTUP_COMPLETE:String					= "event/startComplete";
		
		public static const FAILING:String  	  		  	    	= "state/start/failing";
		public static const FAIL:String  	  		  	        	= "event/start/fail";
		/*******************************************************************************************************/
		
		
		
		/***********************************************SETTINGS*************************************************/
		public static const SETTINGS:String          					= "state/starting/settings";
		public static const SETTINGS_LOAD:String             			= "event/start/settings";
		public static const SETTINGS_LOAD_COMPLETE:String				= "action/start/settings/complete";
		public static const SETTINGS_LOAD_FAILED:String   				= "action/start/settings/failed";
		/*******************************************************************************************************/
		
		
		/***********************************************TEMPLATES*************************************************/	
		public static const LOADING_TEMPLATES_CFS:String			= "state/starting/templatescfs";
		public static const LOAD_TEMPLATES_CFS:String				= "event/start/templatescfs";
		public static const LOAD_TEMPLATES_CFS_COMPLETE:String  	= "action/start/templatescfs/complete";
		public static const LOAD_TEMPLATES_CFS_FAILED:String    	= "action/start/templatescfs/failed";	

		public static const LOADING_TEMPLATES_CFS:String			= "state/starting/templatescfs";
		public static const LOAD_TEMPLATES_CFS:String				= "event/start/templatescfs";
		public static const LOAD_TEMPLATES_CFS_COMPLETE:String  	= "action/start/templatescfs/complete";
		public static const LOAD_TEMPLATES_CFS_FAILED:String    	= "action/start/templatescfs/failed";	
		
		public static const LOADING_TEMPLATES:String				= "state/starting/templates";
		public static const LOAD_TEMPLATES:String					= "event/start/templates";
		public static const LOAD_TEMPLATES_COMPLETE:String  		= "action/start/templates/complete";
		public static const LOAD_TEMPLATES_FAILED:String    		= "action/start/templates/failed";	
		
		
		public static const LOADING_CONTENT:String					= "state/starting/content";
		public static const LOAD_CONTENT:String						= "event/start/content";
		public static const LOAD_CONTENT_COMPLETE:String 			= "action/start/content/complete";
		public static const LOAD_CONTENT_FAILED:String    			= "action/start/content/failed";
		/*******************************************************************************************************/
			
		
		
		/*******************************************MEDIA******************************************************/
		public static const LOADING_MEDIA:String					= "state/starting/media";
		public static const LOAD_MEDIA:String						= "event/start/media";
		public static const LOAD_MEDIA_COMPLETE:String  			= "action/start/media/complete";
		public static const LOAD_MEDIA_FAILED:String    			= "action/start/media/failed";
		
		public static const LOADING_MIMETYPES:String				= "state/starting/mimetypes";
		public static const LOAD_MIMETYPES:String					= "event/start/mimetypes";
		public static const LOAD_MIMETYPES_COMPLETE:String  		= "action/start/mimetypes/complete";
		public static const LOAD_MIMETYPES_FAILED:String    		= "action/start/mimetypes/failed";
		/*******************************************************************************************************/
		
		
		
		/*******************************************TERMS*******************************************************/
		public static const LOADING_CATEGORIES_CFS:String			= "state/starting/categoriescfs";
		public static const LOAD_CATEGORIES_CFS:String				= "event/start/categoriescfs";
		public static const LOAD_CATEGORIES_CFS_COMPLETE:String		= "action/start/categoriescfs/complete";
		public static const LOAD_CATEGORIES_CFS_FAILED:String    	= "action/start/categoriescfs/failed";
		
		public static const LOADING_TERMS:String					= "state/starting/terms";
		public static const LOAD_TERMS:String						= "event/start/terms";
		public static const LOAD_TERMS_COMPLETE:String  			= "action/start/terms/complete";
		public static const LOAD_TERMS_FAILED:String    			= "action/start/terms/failed";	
		/*******************************************************************************************************/				
	
		
		
		/*******************************************MISC / APP***************************************************/
		public static const LOADING_COLORS:String					= "state/starting/colors";
		public static const LOAD_COLORS:String						= "event/start/colors";
		public static const LOAD_COLORS_COMPLETE:String				= "action/start/colors/complete";
		public static const LOAD_COLORS_FAILED:String				= "action/start/colors/failed";	
		/*******************************************************************************************************/

		/**
		 * XML starts the State Machine. This could be loaded from an external
		 * file as well. 
		 */		
		public static const FSM:XML = 
			<fsm initial={STARTING}>
			    
			    <!-- THE INITIAL STATE -->
				<state name={STARTING}>
			       <transition action={STARTED} target={LOADING_CONFIG}/>
			       <transition action={START_FAILED} target={FAILING}/>
				</state>
				
				<!-- CONFIG -->
				<state name={LOADING_CONFIG} changed={LOAD_CONFIG}>
				   <transition action={LOAD_CONFIG_COMPLETE} target={LOADING_CONTENT}/>			       
				   <transition action={LOAD_CONFIG_FAILED} target={FAILING}/>
				</state>
		
		
				<!-- CONTENT -->
				<state name={LOADING_CONTENT} changed={LOAD_CONTENT}>
				   <transition action={LOAD_CONTENT_COMPLETE} target={LOADING_TEMPLATES_CFS}/>			       
				   <transition action={LOAD_CONTENT_FAILED} target={FAILING}/>
				</state>

				<state name={LOADING_TEMPLATES_CFS} changed={LOAD_TEMPLATES_CFS}>
				   <transition action={LOAD_TEMPLATES_CFS_COMPLETE} target={LOADING_TEMPLATES}/>			       
				   <transition action={LOAD_TEMPLATES_CFS_FAILED} target={FAILING}/>
				</state>
		
				<state name={LOADING_TEMPLATES} changed={LOAD_TEMPLATES}>
				   <transition action={LOAD_TEMPLATES_COMPLETE} target={LOADING_MEDIA}/>			       
				   <transition action={LOAD_TEMPLATES_FAILED} target={FAILING}/>
				</state>	
		
		
				<!-- MEDIA -->		
				<state name={LOADING_MEDIA} changed={LOAD_MEDIA}>
				   <transition action={LOAD_MEDIA_COMPLETE} target={LOADING_MIMETYPES}/>			       
				   <transition action={LOAD_MEDIA_FAILED} target={FAILING}/>
				</state>

				<state name={LOADING_MIMETYPES} changed={LOAD_MIMETYPES}>
				   <transition action={LOAD_MIMETYPES_COMPLETE} target={LOADING_CATEGORIES_CFS}/>			       
				   <transition action={LOAD_MIMETYPES_FAILED} target={FAILING}/>
				</state>

		
				<!-- TERMS -->
				<state name={LOADING_CATEGORIES_CFS} changed={LOAD_CATEGORIES_CFS}>
				   <transition action={LOAD_CATEGORIES_CFS_COMPLETE} target={LOADING_TERMS}/>			       
				   <transition action={LOAD_CATEGORIES_CFS_FAILED} target={FAILING}/>
				</state>
		
				<state name={LOADING_TERMS} changed={LOAD_TERMS}>
				   <transition action={LOAD_TERMS_COMPLETE} target={LOADING_COLORS}/>			       
				   <transition action={LOAD_TERMS_FAILED} target={FAILING}/>
				</state>
		
				<!-- MISC / APP -->
				<state name={LOADING_COLORS} changed={LOAD_COLORS}>
				   <transition action={LOAD_COLORS_COMPLETE} target={STARTINGUP_COMPLETE}/>			       
				   <transition action={LOAD_COLORS_FAILED} target={FAILING}/>
				</state>
		
		
				<!-- READY -->
				<state name={STARTINGUP_COMPLETE} changed={STARTUP_COMPLETE}/>
				
		
				<!-- REPORT FAILURE FROM ANY STATE -->
				<state name={FAILING} changed={FAIL}/>

			</fsm>;
	}
}