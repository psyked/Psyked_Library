package couk.psyked.twitter.events
{
    import flash.events.Event;

    public class TwitterUploadSuccessEvent extends Event
    {
        public static var UPLOAD_SUCCESS:String = "twitterUploadSuccess";

        public var imageUrl:String = "";

        public function TwitterUploadSuccessEvent( bubbles:Boolean = false, cancelable:Boolean = false )
        {
            super( UPLOAD_SUCCESS, bubbles, cancelable );
        }

        override public function clone():Event
        {
            var e:TwitterUploadSuccessEvent = new TwitterUploadSuccessEvent();
            e.imageUrl = imageUrl;
            return e;
        }

    }
}