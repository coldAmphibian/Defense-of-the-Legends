package
{
    import flash.events.Event;

    public class ev_Invoke extends Event
    {
        // Your custom event 'types'.
        public static const INVOKE:String = "ev_invoke";

        // Your custom properties.
        public var _spell_ID:String;
		public var _owned:Boolean;

        // Constructor.
        public function ev_Invoke(type:String, bubbles:Boolean=true, cancelable:Boolean=false):void
        {
            super(type, bubbles, cancelable);
        }
    }
}