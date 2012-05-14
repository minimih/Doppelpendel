/**
 * @class IButton
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

	public interface IButton
	{
		function kill():void;

		function setOnClick(callBack:Function):void;

		function setRollover(rLo:Object = null, rHi:Object = null):void;

		function unlockElement():void;

		function lockElement():void;

		function setLoAndUnlockElement(...args):void;

		function setHiAndLockElement(...args):void;

		function showElement(immediate:Boolean = false):void;

		function hideElement(immediate:Boolean = false):void;

		/* ----------------------------------------------------------------- */

		function get asset():MovieClip;

		function set mcButton(target:MovieClip):void;

		function get mcButton():MovieClip;

		function set mcHi(target:MovieClip):void;

		function get mcHi():MovieClip;

		function get isHiAndLocked():Boolean;
	}
}
