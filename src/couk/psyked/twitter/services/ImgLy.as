package couk.psyked.twitter.services
{
    import couk.psyked.air.ApplicationConfig;
    import couk.psyked.twitter.ITwitterService;
    import couk.psyked.twitter.events.TwitterUploadErrorEvent;
    import couk.psyked.twitter.events.TwitterUploadSuccessEvent;

    import flash.events.DataEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.filesystem.File;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;

    /**
     *
     * @author James
     */
    public class ImgLy extends EventDispatcher implements ITwitterService
    {

        private static var _instance:ImgLy;

        /**
         *
         * @return
         */
        public static function get instance():ImgLy
        {
            if ( !_instance )
            {
                _instance = new ImgLy();
            }
            return _instance;
        }
        private var file:File;

        /**
         *
         */
        public function ImgLy()
        {
            //
        }

        /**
         *
         * @param _file
         * @param _message
         */
        public function uploadToService( _file:File, _message:String = null ):void
        {
            removeListeners();

            file = _file;
            file.addEventListener( Event.CANCEL, cancelHandler );
            file.addEventListener( Event.COMPLETE, completeHandler );
            file.addEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusHandler );
            file.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
            file.addEventListener( Event.OPEN, openHandler );
            file.addEventListener( ProgressEvent.PROGRESS, progressHandler );
            file.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
            file.addEventListener( DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler );

            var urlRequest:URLRequest;

            var urlVars:URLVariables = new URLVariables();
            urlVars.username = ApplicationConfig.instance.getSetting( "twitterUsername" );
            urlVars.password = ApplicationConfig.instance.getSetting( "twitterPassword" );

            if ( _message )
            {
                urlRequest = new URLRequest( "http://img.ly/api/uploadAndPost" );
                urlVars.message = _message;
            }
            else
            {
                urlRequest = new URLRequest( "http://img.ly/api/upload" );
            }

            urlRequest.method = URLRequestMethod.POST;
            urlRequest.data = urlVars;

            file.upload( urlRequest, 'media' );
        }

        /**
         *
         * @param event
         */
        private function cancelHandler( event:Event ):void
        {
            dispatchEvent( event.clone());
            trace( "cancelHandler: " + event );
        }

        /**
         *
         * @param event
         */
        private function completeHandler( event:Event ):void
        {
            dispatchEvent( event.clone());
            trace( "completeHandler: " + event );
        }

        /**
         *
         * @param event
         */
        private function httpStatusHandler( event:HTTPStatusEvent ):void
        {
            //trace( "httpStatusHandler: " + event );
            switch ( event.status )
            {
                case 401:
                    // For img.ly - a 401 error usually means invalid credentials. 
                    var errorEvent:TwitterUploadErrorEvent = new TwitterUploadErrorEvent();
                    errorEvent.errorCode = TwitterUploadErrorEvent.INVALID_TWITTER_CREDENTIALS;
                    errorEvent.errorMessage = "An Error occured uploading your file.";
                    dispatchEvent( errorEvent );
                    removeListeners();
                    break;
            }
        }

        private function removeListeners():void
        {
            if ( file )
            {
                file.removeEventListener( Event.CANCEL, cancelHandler );
                file.removeEventListener( Event.COMPLETE, completeHandler );
                file.removeEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusHandler );
                file.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
                file.removeEventListener( Event.OPEN, openHandler );
                file.removeEventListener( ProgressEvent.PROGRESS, progressHandler );
                file.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
                file.removeEventListener( DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler );
            }
        }

        /**
         *
         * @param event
         */
        private function ioErrorHandler( event:IOErrorEvent ):void
        {
            //dispatchEvent( event.clone());
            //trace( "ioErrorHandler: " + event );
            var errorEvent:TwitterUploadErrorEvent = new TwitterUploadErrorEvent();
            errorEvent.errorCode = TwitterUploadErrorEvent.IMAGE_UPLOAD_ERROR;
            errorEvent.errorMessage = "An Error occured uploading your file.";
            dispatchEvent( errorEvent );
        }

        /**
         *
         * @param event
         */
        private function openHandler( event:Event ):void
        {
            dispatchEvent( event.clone());
            //trace( "openHandler: " + event );
        }

        /**
         *
         * @param event
         */
        private function progressHandler( event:ProgressEvent ):void
        {
            dispatchEvent( event.clone());
            //trace( "Uploading", Math.round(( event.bytesLoaded / event.bytesTotal ) * 100 ), "%" );
        }

        /**
         *
         * @param event
         */
        private function securityErrorHandler( event:SecurityErrorEvent ):void
        {
            //dispatchEvent( event.clone());
            trace( "securityErrorHandler: " + event );
            var errorEvent:TwitterUploadErrorEvent = new TwitterUploadErrorEvent();
            errorEvent.errorCode = TwitterUploadErrorEvent.IMAGE_UPLOAD_ERROR;
            errorEvent.errorMessage = "Security Error";
            dispatchEvent( errorEvent );
        }

        /**
         *
         * @param event
         */
        private function uploadCompleteDataHandler( event:DataEvent ):void
        {
            trace( "Upload is complete, recieved response from ImgLy." );
            var resultXML:XML = new XML( event.text );

            var errorMessage:String = resultXML.child( "err" )[ 0 ];
            var resultUrl:String = resultXML.child( "mediaurl" )[ 0 ];

            file.removeEventListener( Event.CANCEL, cancelHandler );
            file.removeEventListener( Event.COMPLETE, completeHandler );
            file.removeEventListener( HTTPStatusEvent.HTTP_STATUS, httpStatusHandler );
            file.removeEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler );
            file.removeEventListener( Event.OPEN, openHandler );
            file.removeEventListener( ProgressEvent.PROGRESS, progressHandler );
            file.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
            file.removeEventListener( Event.COMPLETE, uploadCompleteDataHandler );
            file.removeEventListener( DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler );

            dispatchEvent( event.clone());

            /* <?xml version="1.0" encoding="UTF-8"?>
               <rsp stat="ok">
               <statusid>1111</statusid>
               <userid>11111</userid>
               <mediaid>test123</mediaid>
               <mediaurl>http://img.ly/abc123</mediaurl>
             </rsp> */

            /* <?xml version="1.0" encoding="UTF-8"?>
               <rsp stat="fail">
               <err code="1001" msg="Invalid twitter username or password" />
             </rsp> */
            //trace( "resultUrl:", resultUrl );

            if ( resultUrl != "" )
            {
                var successEvent:TwitterUploadSuccessEvent = new TwitterUploadSuccessEvent();
                successEvent.imageUrl = resultUrl; //resultXML.child( "mediaurl" )[ 0 ];
                dispatchEvent( successEvent );
            }
            else
            {
                var errorEvent:TwitterUploadErrorEvent = new TwitterUploadErrorEvent();
                //
                // the TwitterUploadErrorEvent needs to have a consistent error message, so we parse the results and set the error type
                // flag in the event we're sending out.
                //
                // detecting invalid credentials is a common situation, and we can prompt to fix this and try again, so this is important.  
                // The rest really doesn't matter, because there's not much more we can deal with - the error message supplied should 
                // be enough for the user to figure out and fix the problem.
                //
                switch ( resultXML.child( "err" )[ 0 ].@code.toString())
                {
                    case "1001":
                        errorEvent.errorCode = TwitterUploadErrorEvent.INVALID_TWITTER_CREDENTIALS;
                        break;
                    default:
                        errorEvent.errorCode = TwitterUploadErrorEvent.IMAGE_UPLOAD_ERROR;
                        break;
                }
                errorEvent.errorMessage = resultXML.child( "err" )[ 0 ].@msg.toString();
                dispatchEvent( errorEvent );
            }
        }
    }
}