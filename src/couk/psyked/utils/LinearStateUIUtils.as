package couk.psyked.utils
{
	import flash.events.MouseEvent;

	import mx.core.UIComponent;
	import mx.events.StateChangeEvent;

	import spark.components.supportClasses.ToggleButtonBase;

	/**
	 * A series of functions that should make it easier to link interactive elements
	 * (such as buttons) in both functionality and display.
	 *
	 * @author James
	 */
	public class LinearStateUIUtils
	{
		/**
		 * Links an element on a component to a components' state, with an optional
		 * ability to make it enabled or disabled automatically.
		 *
		 * If the components' current state is the same as the state name passed in,
		 * the element will be selected.  Otherwise it will be clickable.  Clicking
		 * on the element will change the components' currentState to the state name
		 * we've passed in as toState.  Whenever the state changes we will also check
		 * against the enabledFlag function to see if the element should be enabled
		 * or not.
		 *
		 * @param element
		 * @param toComponent
		 * @param toState
		 * @param enabledFlag
		 *
		 */
		public static function bindElement( element:ToggleButtonBase, toComponent:UIComponent, toState:String, enabledFlag:Function = null, visibleFlag:Function = null ):void
		{
			element.addEventListener( MouseEvent.CLICK, onMouseClick );
			element.tabFocusEnabled = false;
			element.tabEnabled = false;

			function onMouseClick( e:MouseEvent ):void
			{
				toComponent.currentState = toState;
			}

			toComponent.addEventListener( StateChangeEvent.CURRENT_STATE_CHANGE, onStateChange );

			function onStateChange( e:StateChangeEvent ):void
			{
				element.selected = ( e.newState == toState );

				if ( enabledFlag != null )
				{
					element.enabled = enabledFlag.call();
				}

				if ( visibleFlag != null )
				{
					element.visible = visibleFlag.call();
					element.includeInLayout = visibleFlag.call();
				}
			}
		}
	}
}