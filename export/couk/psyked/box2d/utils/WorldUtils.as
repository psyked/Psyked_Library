package couk.psyked.box2d.utils
{
    import Box2D.Collision.Shapes.b2PolygonDef;
    import Box2D.Collision.b2AABB;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2DebugDraw;
    import Box2D.Dynamics.b2World;

    import flash.display.Sprite;

    public class WorldUtils
    {
        public static function createBox2DWorld( aabb:b2AABB = null, gravity:b2Vec2 = null ):b2World
        {
            if ( !aabb )
            {
                aabb = new b2AABB();
                aabb.lowerBound.Set( -1000.0, -1000.0 );
                aabb.upperBound.Set( 1000.0, 1000.0 );
            }
            if ( !gravity )
            {
                gravity = new b2Vec2( 0, 9.8 );
            }
            var m_world:b2World = new b2World( aabb, gravity, true );
            return m_world;
        }

        public static function createDebugDraw( m_world:b2World ):Sprite
        {
            var dbgDraw:b2DebugDraw = new b2DebugDraw();
            var dbgSprite:Sprite = new Sprite();
            dbgDraw.SetSprite( dbgSprite );
            dbgDraw.SetDrawScale( 30 );
            dbgDraw.SetFillAlpha( 0.3 );
            dbgDraw.SetLineThickness( 1 );
            dbgDraw.SetFlags( b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit );
            m_world.SetDebugDraw( dbgDraw );
            return dbgSprite;
        }

        public static function createBoxedWorld( _world:b2World, _scale:int, _width:int, _height:int, _top:Boolean = true, _left:Boolean = true, _bottom:Boolean = true, _right:Boolean = true ):void
        {
            // Create border of boxes
            var wallSd:b2PolygonDef = new b2PolygonDef();
            var wallBd:b2BodyDef = new b2BodyDef();
            var wallB:b2Body;

            if ( _left )
            {
                // Left
                wallBd.position.Set( -100 / _scale, _height / _scale / 2 );
                wallSd.SetAsBox( 100 / _scale, ( _height + 40 ) / _scale / 2 );
                wallB = _world.CreateBody( wallBd );
                wallB.CreateShape( wallSd );
                wallB.SetMassFromShapes();
            }
            if ( _right )
            {
                // Right
                wallBd.position.Set(( _width + 99 ) / _scale, _height / _scale / 2 );
                wallB = _world.CreateBody( wallBd );
                wallB.CreateShape( wallSd );
                wallB.SetMassFromShapes();
            }
            if ( _top )
            {
                // Top
                wallBd.position.Set( _width / _scale / 2, -100 / _scale );
                wallSd.SetAsBox(( _width + 40 ) / _scale / 2, 100 / _scale );
                wallB = _world.CreateBody( wallBd );
                wallB.CreateShape( wallSd );
                wallB.SetMassFromShapes();
            }
            if ( _bottom )
            {
                // Bottom
                wallBd.position.Set( _width / _scale / 2, ( _height + 99 ) / _scale );
                wallB = _world.CreateBody( wallBd );
                wallB.CreateShape( wallSd );
                wallB.SetMassFromShapes();
            }
        }

    }
}