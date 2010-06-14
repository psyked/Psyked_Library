package couk.psyked.air
{
    import flash.display.NativeMenuItem;
    import flash.events.Event;

    /**
     * 
     * @author James
     */
    public class NativeMenuItemUtils
    {
        /**
         * 
         * @param label
         * @param onSelect
         * @param checkEnabled A reference to a function which returns a boolean value of whether the menu item should be enabled or not.
         * @return 
         */
        public static function createNativeMenuItem( label:String, onSelect:Function = null, checkEnabled:Function = null ):NativeMenuItem
        {
            var newMenuItem:NativeMenuItem = new NativeMenuItem( label );
            if ( onSelect != null )
            {
                newMenuItem.addEventListener( Event.SELECT, onSelect );
            }
            if ( checkEnabled != null )
            {
                newMenuItem.addEventListener( Event.DISPLAYING, onDisplay );
            }
            return newMenuItem;

            function onDisplay( e:Event ):void
            {
                newMenuItem.enabled = checkEnabled.call();
            }
        }
    }
}