package couk.psyked.twitter
{
    import couk.psyked.air.ApplicationConfig;
    import couk.psyked.twitter.events.TwitterUploadErrorEvent;
    import couk.psyked.twitter.events.TwitterUploadSuccessEvent;
    import couk.psyked.twitter.services.ImgLy;
    import couk.psyked.twitter.services.Mobypicture;
    import couk.psyked.twitter.services.Posterous;
    import couk.psyked.twitter.services.ScreenTweet;
    import couk.psyked.twitter.services.TweetPhoto;
    import couk.psyked.twitter.services.TwitDoc;
    import couk.psyked.twitter.services.TwitPic;
    import couk.psyked.twitter.services.Twitgoo;
    import couk.psyked.twitter.services.TwitrPix;
    import couk.psyked.twitter.services.YFrog;
    import couk.psyked.twitter.types.ServiceTypes;

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;

    /**
     *
     * @author James
     */
    public class ServiceManager extends EventDispatcher implements ITwitterService
    {
        private static var _instance:ServiceManager;

        /**
         *
         * @return
         */
        public static function get instance():ServiceManager
        {
            if ( !_instance )
            {
                _instance = new ServiceManager();
            }
            return _instance;
        }

        private var _serviceType:String;

        private var _twitterService:ITwitterService;

        /**
         *
         * @param target
         */
        public function ServiceManager( target:IEventDispatcher = null )
        {
            super( target );
        }

        /**
         *
         * @return
         */
        public function get serviceType():String
        {
            return _serviceType;
        }

        /**
         *
         * @param str
         */
        public function set serviceType( str:String ):void
        {
            if ( _twitterService )
            {
                twitterService.removeEventListener( Event.CANCEL, cancelHandler );
                twitterService.removeEventListener( ProgressEvent.PROGRESS, progressHandler );
                twitterService.removeEventListener( TwitterUploadSuccessEvent.UPLOAD_SUCCESS, onUploadSuccess );
                twitterService.removeEventListener( TwitterUploadErrorEvent.UPLOAD_ERROR, onUploadError );
                twitterService = null;
            }

            _serviceType = str;

            switch ( str )
            {
                case ServiceTypes.TWIT_PIC:
                    twitterService = TwitPic.instance;
                    break;
                case ServiceTypes.TWEET_PHOTO:
                    twitterService = TweetPhoto.instance;
                    break;
                case ServiceTypes.SCREEN_TWEET:
                    twitterService = ScreenTweet.instance;
                    break;
                case ServiceTypes.YFROG:
                    twitterService = YFrog.instance;
                    break;
                case ServiceTypes.TWITGOO:
                    twitterService = Twitgoo.instance;
                    break;
                case ServiceTypes.MOBYPICTURE:
                    twitterService = Mobypicture.instance;
                    break;
                case ServiceTypes.IMG_LY:
                    twitterService = ImgLy.instance;
                    break;
                case ServiceTypes.POSTEROUS:
                    twitterService = Posterous.instance;
                    break;
                case ServiceTypes.TWITR_PIX:
                    twitterService = TwitrPix.instance;
                    break;
                case ServiceTypes.TWIT_DOC:
                    twitterService = TwitDoc.instance;
                    break;
                default:
                    twitterService = TweetPhoto.instance;
                    break;
            }

            twitterService.addEventListener( Event.CANCEL, cancelHandler );
            twitterService.addEventListener( ProgressEvent.PROGRESS, progressHandler );
            twitterService.addEventListener( TwitterUploadSuccessEvent.UPLOAD_SUCCESS, onUploadSuccess );
            twitterService.addEventListener( TwitterUploadErrorEvent.UPLOAD_ERROR, onUploadError );
        }

        private function onUploadSuccess( e:TwitterUploadSuccessEvent ):void
        {
            dispatchEvent( e.clone());
        }

        private function onUploadError( e:TwitterUploadErrorEvent ):void
        {
            dispatchEvent( e.clone());
        }

        /**
         *
         * @param file
         * @param _message
         */
        public function uploadToService( file:File, _message:String = null ):void
        {
            twitterService.uploadToService( file, _message );
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
        private function progressHandler( event:ProgressEvent ):void
        {
            dispatchEvent( event.clone());
            trace( "Uploading", Math.round(( event.bytesLoaded / event.bytesTotal ) * 100 ), "%" );
        }

        /**
         *
         * @return
         */
        private function get twitterService():ITwitterService
        {
            if ( !_twitterService )
            {
                serviceType = ServiceTypes.TWEET_PHOTO;
            }
            return _twitterService;
        }

        /**
         *
         * @param service
         */
        private function set twitterService( service:ITwitterService ):void
        {
            _twitterService = service;
        }
    }
}