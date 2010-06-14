package couk.psyked.flex
{
    import flash.events.MouseEvent;
    
    import mx.controls.ToggleButtonBar;
    import mx.core.IFlexDisplayObject;

    public class ShadowToggleButtonBar extends ToggleButtonBar
    {
        override protected function createNavItem( label:String, icon:Class = null ):IFlexDisplayObject
        {
            //var b:ShadowButton = ShadowButton( super.createNavItem( label, icon ));
            var newButton:ShadowButton = new ShadowButton();

            // Set tabEnabled to false so individual buttons don't get focus.
            newButton.focusEnabled = false;
            newButton.label = label;
            newButton.setStyle( "icon", icon );
            newButton.addEventListener( MouseEvent.CLICK, clickHandler );

            addChild( newButton );

            //super.recalcButtonWidths = recalcButtonHeights = true;
            super.invalidateProperties();
            
            newButton.toggle = true;
            return newButton;
        }
    }
}