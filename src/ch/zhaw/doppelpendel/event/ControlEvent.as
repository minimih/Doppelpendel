/**
 * @class ControlEvent
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.event
{
	import flash.events.Event;

	public class ControlEvent extends Event
	{
		public static const START:String = "start";
		public static const STOP:String = "stop";
		public static const RESET:String = "reset";
		public static const UPDATE:String = "update";
		
		private var _arguments:Object;
		
		public function ControlEvent(type:String, args:Object = null) {
			super(type);
			
			if(args == null){
				args = new Object();
			}
			_arguments = args;
		}
		
		public function get args():Object
		{
			return _arguments;
		}
	}
}