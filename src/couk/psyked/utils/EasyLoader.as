package couk.psyked.utils
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    
    import mx.managers.CursorManager;


    public class EasyLoader
    {
        public static function loadFile( url:String, completeFunction:Function = null, faultFunction:Function = null ):void
        {

            var loader:URLLoader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.TEXT;
            loader.addEventListener( Event.COMPLETE, onComplete );
            loader.addEventListener( ProgressEvent.PROGRESS, onProgress );
            loader.addEventListener( IOErrorEvent.IO_ERROR, onError );
            loader.load( new URLRequest( url ));
            //CursorManager.setBusyCursor();

            function onComplete( e:Event ):void
            {
                loader.removeEventListener( Event.COMPLETE, onComplete );
                loader.removeEventListener( ProgressEvent.PROGRESS, onProgress );
                loader.removeEventListener( IOErrorEvent.IO_ERROR, onError );
                if ( completeFunction != null )
                {
                    completeFunction( loader.data as String );
                }
            }

            function onError( e:IOErrorEvent ):void
            {
                CursorManager.removeAllCursors();
                loader.removeEventListener( Event.COMPLETE, onComplete );
                loader.removeEventListener( ProgressEvent.PROGRESS, onProgress );
                loader.removeEventListener( IOErrorEvent.IO_ERROR, onError );
                if ( faultFunction != null )
                {
                    faultFunction( e );
                }
            }

            function onProgress( e:ProgressEvent ):void
            {
                trace( "Loaded", Math.round(( e.bytesLoaded / e.bytesTotal ) * 100 ), "%" );
            }

        }

    }
}