/**
 * @class MenuEvent
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * 
 * Contact Information:
 * ZHAW - Zurich University of Applied Sciences
 * School of Engineering
 * Lagerstrasse 41
 * Postfach
 * 8021 Zurich 
 * 
 * Michael Hoehn (mih) - hoehnmic@students.zhaw.ch
 * Stefan Hauenstein (haui) - hauenst@students.zhaw.ch
 * 
 * @author mih
 */
package ch.zhaw.doppelpendel.event
{
	import flash.events.Event;

	/**
	 * Event class for Menu related events
	 */
	public class MenuEvent extends Event
	{
		public static const LOAD:String = "load";
		public static const ERROR:String = "error";

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