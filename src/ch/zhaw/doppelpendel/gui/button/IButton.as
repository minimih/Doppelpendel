/**
 * @class IButton
 *
 * @author 		mih
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
