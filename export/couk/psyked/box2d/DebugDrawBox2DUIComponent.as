package couk.psyked.box2d
{
    import Box2D.Dynamics.b2DebugDraw;

    import flash.display.Sprite;

    public class DebugDrawBox2DUIComponent extends Box2DUIComponent
    {

        public function DebugDrawBox2DUIComponent()
        {
            super();
        }

        override protected function childrenCreated():void
        {
            var dbgDraw:b2DebugDraw = new b2DebugDraw();
            var dbgSprite:Sprite = new Sprite();
            dbgDraw.SetSprite( dbgSprite );
            dbgDraw.SetDrawScale( 30 );
            dbgDraw.SetFillAlpha( 0.3 );
            dbgDraw.SetLineThickness( 1 );
            dbgDraw.SetFlags( b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit );
            box2d_world.SetDebugDraw( dbgDraw );
            addChild( dbgSprite );
        }

    }
}