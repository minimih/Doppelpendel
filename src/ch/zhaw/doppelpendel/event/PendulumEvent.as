/**
 * @class PendulumEvent
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.event
{
	import flash.events.Event;

	public class PendulumEvent extends Event
	{
		public static const UPDATE:String = "update";

		public function PendulumEvent(type:String)
		{
			super(type);
		}
	}
}