package couk.psyked.puremvc
{
	import mx.core.ClassFactory;
	import mx.core.UIComponent;
	import mx.events.StateChangeEvent;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.interfaces.IMediator;

	/**
	 * A series of functions to help bind and unbind PureMVC mediators to different states
	 * on a component. 
	 * 
	 * @author James
	 */
	public class StateMediatorUtils
	{
		/**
		 * Makes it easier to add and remove Mediators to a component whenever the state changes
		 * on the component.  Whenever the component state changes to or from the state name you
		 * pass into this function, it adds or removes the mediator for that state to the component. 
		 * 
		 * ## NB: Untested for performance / memory leaks. ##
		 *  
		 * @param facade The current iFacade instance
		 * @param component A reference to the component on which the state will change
		 * @param stateName The state name that the mediator is added to and removed from.
		 * @param mediator A reference to the mediator Class that will be added and removed.
		 */		
		public static function registerStateMediator(facade:IFacade, component:UIComponent, stateName:String, mediator:Class):void
		{
			component.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, onStateChange);
		
			function onStateChange( e:StateChangeEvent ):void
			{
				if ( e.oldState == stateName)
				{
					facade.removeMediator((new mediator as IMediator).getMediatorName());
				}
				
				if ( e.newState == stateName)
				{
					facade.registerMediator(new mediator(component));
				}
			}
		}
	}
}