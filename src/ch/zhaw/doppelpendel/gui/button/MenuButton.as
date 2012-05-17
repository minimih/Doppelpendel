/**
 * @class MenuButton
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
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class MenuButton extends GenericButton implements IButton
	{	
		private var _isToggled:Boolean;
		
		protected var tfLabel:TextField;
			
		public function MenuButton(mcAsset:MovieClip, setButtonArea:MovieClip = null, setHiClip:MovieClip = null)
		{
			super(mcAsset, setButtonArea, setHiClip);
			
			tfLabel = asset.tf_label;
			tfLabel.mouseEnabled = false;
		}

		/* ----------------------------------------------------------------- */
		
		public function setLabel(s:String, hasMinSize:Boolean = false):void
		{
			tfLabel.autoSize = TextFieldAutoSize.LEFT;
			tfLabel.text = s;

			// set buttonsize
			var btnWidth:int = Math.ceil(2 * tfLabel.x + tfLabel.width);
			if (!hasMinSize || btnWidth > mcButton.width)
				mcButton.width = btnWidth;
				mcHi.width = btnWidth;
		}
	}
}
