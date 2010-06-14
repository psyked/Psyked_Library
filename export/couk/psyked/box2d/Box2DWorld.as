package couk.psyked.box2d
{
    import Box2D.Collision.Shapes.b2CircleDef;
    import Box2D.Collision.Shapes.b2PolygonDef;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2World;

    import couk.psyked.box2d.utils.Box2DUtils;
    import couk.psyked.box2d.utils.Box2DWorldOptions;
    import couk.psyked.box2d.utils.PolygonTool;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.utils.Timer;

    import wumedia.vector.VectorShapes;

    public class Box2DWorld extends Sprite
    {

        private var _animateOnEnterFrame:Boolean;
        private var _debugDraw:Boolean;
        private var _world:b2World;
        private var options:Box2DWorldOptions;
        private var worldSprite:Sprite;

        public function Box2DWorld( world:b2World, _options:Box2DWorldOptions )
        {
            options = _options;
            _world = world;
            worldSprite = Box2DUtils.addDebugDraw( world );
        }

        public function get animateOnEnterFrame():Boolean
        {
            return _animateOnEnterFrame;
        }

        public function set animateOnEnterFrame( value:Boolean ):void
        {
            if ( value )
            {
                if ( !_animateOnEnterFrame )
                {
                    addEventListener( Event.ENTER_FRAME, updateBox2D );
                }
            }
            else
            {
                if ( _animateOnEnterFrame )
                {
                    removeEventListener( Event.ENTER_FRAME, updateBox2D );
                }
            }
            _animateOnEnterFrame = value;
        }

        private var _framerateIndependantAnimation:Boolean;
        private var fiaTimer:Timer;

        public function get framerateIndependantAnimation():Boolean
        {
            return _framerateIndependantAnimation;
        }

        private var framerate:Number = ( 60 / 1000 );

        public function set framerateIndependantAnimation( value:Boolean ):void
        {
            if ( value )
            {
                if ( !_framerateIndependantAnimation )
                {
                    fiaTimer = new Timer( framerate );
                    fiaTimer.addEventListener( TimerEvent.TIMER, updateBox2D );
                    fiaTimer.start();
                }
            }
            else
            {
                if ( _framerateIndependantAnimation )
                {
                    fiaTimer.removeEventListener( TimerEvent.TIMER, updateBox2D );
                    fiaTimer.stop();
                    fiaTimer = null;
                }
            }
            _framerateIndependantAnimation = value;
        }

        public function get debugDraw():Boolean
        {
            return _debugDraw;
        }

        public function set debugDraw( value:Boolean ):void
        {
            if ( value )
            {
                if ( !contains( worldSprite ))
                {
                    addChild( worldSprite );
                }
            }
            else
            {
                if ( contains( worldSprite ))
                {
                    removeChild( worldSprite );
                }
            }
            _debugDraw = value;
        }

        public function createCircle( x:int, y:int, radius:int, rotation:int = 0 ):void
        {
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.position.Set( x / options.scale, y / options.scale );
            bodyDef.linearDamping = 0.25;
            bodyDef.angularDamping = 0.25;
            var shapeDef:b2CircleDef = new b2CircleDef();
            shapeDef.radius = radius / options.scale;
            shapeDef.density = 1;
            shapeDef.friction = 5;
            var body:b2Body = _world.CreateBody( bodyDef );
            body.SetAngle(( rotation % 360 ) * ( Math.PI / 180 ));
            body.CreateShape( shapeDef );
            body.SetMassFromShapes();
        }

        public function createRectangle( x:int, y:int, width:int, height:int, rotation:int = 0 ):void
        {
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.position.Set( x / options.scale, y / options.scale );
            bodyDef.linearDamping = 0.25;
            bodyDef.angularDamping = 0.25;
            var shapeDef:b2PolygonDef = new b2PolygonDef();
            shapeDef.SetAsBox( width / options.scale, height / options.scale );
            shapeDef.density = 1;
            shapeDef.friction = 5;
            var body:b2Body = _world.CreateBody( bodyDef );
            body.SetAngle(( rotation % 360 ) * ( Math.PI / 180 ));
            body.CreateShape( shapeDef );
            body.SetMassFromShapes();
        }

        public function createComplexPolygon( x:int, y:int, points:Array, rotation:int = 0 ):void
        {
            if ( points.length < 3 )
            {
                throw new Error( "Complex Polygons must have at least 3 points." );
            }

            // If there are more than 8 vertices, its a complex body
            /* if ( points.length > 8 )
               {
               makeComplexBody( body, points );
               }
               else
               {
               if ( polygonto.isPolyConvex( points ) && _polyTool.isPolyClockwise( points ))
               {
               makeSimpleBody( body, points );
               }
               else
               {
               makeComplexBody( body, points );
               }
             } */
            var bodyDef:b2BodyDef = new b2BodyDef();
            bodyDef.position.Set( x / options.scale, y / options.scale );
            bodyDef.linearDamping = 0.25;
            bodyDef.angularDamping = 0.25;

            var body:b2Body = _world.CreateBody( bodyDef );
            body.SetAngle(( rotation % 360 ) * ( Math.PI / 180 ));

            var processedVerts:Array = PolygonTool.getTriangulatedPoly( points );

            if ( processedVerts != null )
            {
                makeComplexBody( body, processedVerts );
            }
            else
            {
                makeComplexBody( body, PolygonTool.getConvexPoly( points ));
            }
            body.SetMassFromShapes();
        }

        public function createPolyFromLibraryShape( x:int, y:int, shapeName:String, libraryName:String, rotation:int = 0 ):void
        {

            var loader:URLLoader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.BINARY;
            loader.addEventListener( Event.COMPLETE, onLoaded );
            loader.load( new URLRequest( libraryName ));

            function onLoaded( e:Event = null ):void
            {
                VectorShapes.extractFromLibrary( loader.data, [ shapeName ]);
                //VectorShapes.draw( graphics, shapeName, 1.0, mouseX, mouseY );
                var points:Array = VectorShapes.getPoints( shapeName, 1 );

                for each ( var p:Point in points )
                {
                    trace( p.x, p.y );
                }
                
                if ( points )
                {
                    createComplexPolygon( x, y, points, rotation );
                }
            }

        }


        internal function makeComplexBody( body:b2Body, processedVerts:Array ):void
        {
            var tcount:int = int( processedVerts.length / 3 );

            for ( var i:int = 0; i < tcount; i++ )
            {
                var shapeDef:b2PolygonDef = new b2PolygonDef();
                shapeDef.density = 1;
                shapeDef.friction = 5;

                shapeDef.vertexCount = 3;

                var index:int = i * 3;
                shapeDef.vertices[ 0 ].Set( processedVerts[ index ].x / 30, processedVerts[ index ].y / 30 );
                shapeDef.vertices[ 1 ].Set( processedVerts[ index + 1 ].x / 30, processedVerts[ index + 1 ].y / 30 );
                shapeDef.vertices[ 2 ].Set( processedVerts[ index + 2 ].x / 30, processedVerts[ index + 2 ].y / 30 );
                body.CreateShape( shapeDef );
            }
            body.SetMassFromShapes();
            body.CreateShape( shapeDef );
        }

        public function updateBox2D( e:Event = null ):void
        {
            _world.Step(( 1 / 30 ), 10, 10 );
        }
    }
}