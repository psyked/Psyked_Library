package couk.psyked.twitter.events
{
    import flash.events.Event;

    public class TwitterUploadErrorEvent extends Event
    {
        public static var UPLOAD_ERROR:String = "twitterUploadError";

        public static var INVALID_TWITTER_CREDENTIALS:int = 1;
        public static var IMAGE_UPLOAD_ERROR:int = 2;

        public var errorCode:int = 0;
        public var errorMessage:String = "";

        public function TwitterUploadErrorEvent( bubbles:Boolean = false, cancelable:Boolean = false )
        {
            super( UPLOAD_ERROR, bubbles, cancelable );
        }

        override public function clone():Event
        {
            var e:TwitterUploadErrorEvent = new TwitterUploadErrorEvent();
            e.errorCode = errorCode;
            e.errorMessage = errorMessage;
            return e;
        }

    }
}