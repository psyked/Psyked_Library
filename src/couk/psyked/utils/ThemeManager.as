package couk.psyked.utils
{
    import flash.events.IEventDispatcher;

    import mx.styles.StyleManager;

    /**
     *
     * @author James
     */
    public class ThemeManager
    {

        private static var _skin:String;

        /**
         * Changes the selected skin by unloading current style declarations
         * and loading new style declarations from the embedded stylesheet swf file.
         */
        public static function changeSkin( skinUrl:String ):void
        {
            /* if ( _skin != null )
               {
               StyleManager.unloadStyleDeclarations( _skin, true );
             } */
            _skin = skinUrl;
            try
            {
                var styleEvent:IEventDispatcher = StyleManager.loadStyleDeclarations( _skin, true ); // force immediate update
            }
            catch ( e:* )
            {
                //trace( "StyleManager Error" );
                throw new Error( "ThemeManager Error changing skin." );
            }
        }
    }
}