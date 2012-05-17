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
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class ColorButton extends GenericButton implements IButton
	{		
		protected var tfLabel:TextField;
		
		protected var rolloverLo:Object;
		protected var rolloverHi:Object;

		public function ColorButton(mcAsset:MovieClip, setButtonArea:MovieClip = null, setHiClip:MovieClip = null)
		{
			super(mcAsset, setButtonArea, setHiClip);
			
			tfLabel = asset.tf_label;
			tfLabel.mouseEnabled = false;
		}

		/* ----------------------------------------------------------------- */
		
		public function setLabel(s:String):void
		{
			tfLabel.text = s;
		}
		
		/* ----------------------------------------------------------------- */

		override public function setRollover(rLo:Object = null, rHi:Object = null):void 
		{	
			if(mcHi != null) {
				rolloverLo = new Object();
				rolloverLo.colorize = 0x000000;
				rolloverLo.amount = 0;
				
				rolloverHi = new Object();
				rolloverHi.colorize = 0x000000;
				rolloverHi.amount = 0.2;
				
				mcButton.addEventListener(MouseEvent.ROLL_OUT, setLo);
				mcButton.addEventListener(MouseEvent.ROLL_OVER, setHi);
				
				setLo();
			}
		}

		/* ----------------------------------------------------------------- */

		override protected function setLo(...args):void 
		{
			if (mcHi != null && !hiIsLocked && !isLocked) {
				TweenMax.killTweensOf(mcHi);
				TweenMax.to(mcHi, 0.2, {colorMatrixFilter:rolloverLo, ease:Linear.easeNone});
			}
		}

		override protected function setHi(...args):void 
		{
			if (mcHi != null && !isLocked) {
				TweenMax.killTweensOf(mcHi);
				TweenMax.to(mcHi, 0.2, {colorMatrixFilter:rolloverHi, ease:Linear.easeNone});
			}
		}
	}
}
