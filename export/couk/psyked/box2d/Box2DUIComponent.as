package couk.psyked.box2d
{
    import Box2D.Collision.b2AABB;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2World;

    import flash.events.Event;

    import mx.core.UIComponent;

    public class Box2DUIComponent extends UIComponent
    {
        internal var actualHeight:int = 600;
        internal var actualWidth:int = 800;
        internal var box2d_gravity:Number = 9.8;

        internal var box2d_iterations:int = 10;

        public var box2d_world:b2World;

        public function Box2DUIComponent()
        {
            super();

            var area:b2AABB = new b2AABB();
            area.lowerBound.Set( -actualWidth, -actualHeight );
            area.upperBound.Set( actualWidth, actualHeight );

            var gravity:b2Vec2 = new b2Vec2( 0, box2d_gravity );
            var ignoreSleeping:Boolean = true;

            box2d_world = new b2World( area, gravity, ignoreSleeping );
        }

        public var m_physScale:int = 30;

        public function onStep( e:Event = null ):void
        {
            var box2d_timestep:Number;
            if ( stage )
            {
                box2d_timestep = ( 1 / stage.frameRate );
            }
            else
            {
                box2d_timestep = ( 1 / 30 );
            }

            box2d_world.Step( box2d_timestep, box2d_iterations, box2d_iterations );
        }

    }
}