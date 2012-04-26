/**
 * @class MenuEvent
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.event
{
	import flash.events.Event;

	public class MenuEvent extends Event
	{
		public static const LOAD:String = "load";

		private var _arguments:Object;
		
		public function MenuEvent(type:String, args:Object = null) {
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