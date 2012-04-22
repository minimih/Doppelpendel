/**
 * @class StageEvent
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.event
{
	import flash.events.Event;

	public class StageEvent extends Event
	{
		public static const STAGERESIZE:String = "stageResize";
		
		private var _arguments:Object;
		
		public function StageEvent(type:String, args:Object = null) {
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