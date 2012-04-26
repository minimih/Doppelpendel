/**
 * @class SystemEvent
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.event
{
	import flash.events.Event;

	public class SystemEvent extends Event
	{
		public static const UPDATE:String = "update";
		public static const RESET:String = "reset";

		public function SystemEvent(type:String)
		{
			super(type);
		}
	}
}