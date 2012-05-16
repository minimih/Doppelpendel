/**
 * @class BasicButton
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
package ch.zhaw.doppelpendel.gui.button
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class ToggleButton extends ColorButton implements IButton
	{
		private var _isToggled:Boolean;

		private var label1:String;
		private var label2:String;

		public function ToggleButton(mcAsset:MovieClip, setButtonArea:MovieClip = null, setHiClip:MovieClip = null)
		{
			super(mcAsset, setButtonArea, setHiClip);
		}

		/* ----------------------------------------------------------------- */

		public function setToggleLabel(s1:String, s2:String):void
		{
			label1 = s1;
			label2 = s2;

			setLabel(label1);
		}

		public function reset():void
		{
			_isToggled = false;
			setLabel(label1);
		}

		/* ----------------------------------------------------------------- */

		override protected function onClickEvent(e:MouseEvent):void
		{
			if (_isToggled)
			{
				setLabel(label1);
			}
			else
			{
				setLabel(label2);
			}

			_isToggled = !_isToggled;

			onClick();
		}

		/* ----------------------------------------------------------------- */

		public function get isToggled():Boolean {
			return _isToggled;
		}

	}
}
