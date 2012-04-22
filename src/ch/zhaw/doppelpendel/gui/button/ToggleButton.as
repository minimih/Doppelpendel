/**
 * @class BasicButton
 *
 * @author 		mih
 */
package ch.zhaw.doppelpendel.gui.button
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class ToggleButton extends GenericButton implements IButton
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
