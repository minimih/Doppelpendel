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

	public class GenericButton implements IButton
	{
		protected var _asset:MovieClip;
		protected var _mcButton:MovieClip;
		protected var _mcHi:MovieClip;

		protected var onClick:Function;

		protected var isLocked:Boolean;
		protected var hiIsLocked:Boolean;

		public function GenericButton(mcAsset:MovieClip, setButtonArea:MovieClip = null, setHiClip:MovieClip = null)
		{
			//do the rest
			_asset = mcAsset;
			
			asset.mouseEnabled = false;
			
			mcButton = asset;
			if (setButtonArea != null) {
				mcButton = setButtonArea;
			} else if(asset.getChildByName("mc_btnarea") != null) {
				mcButton = asset.mc_btnarea;
			}
			
			mcButton.buttonMode = true;
			mcButton.mouseChildren = false;
			
			mcHi = asset;
			if (setHiClip != null) {
				mcHi = setHiClip;
			} else if(asset.getChildByName("mc_hi") != null) {
				mcHi = asset.mc_hi;
			}
			
			onClick = null;
			
			isLocked = false;
			hiIsLocked = false;
		}

		public function kill():void 
		{
			if(onClick != null) {
				mcButton.removeEventListener(MouseEvent.CLICK, onClickEvent);
				onClick = null;
			}
			
			mcButton.removeEventListener(MouseEvent.ROLL_OUT, setLo);
			mcButton.removeEventListener(MouseEvent.ROLL_OVER, setHi);
			
			_mcButton = null;
			_mcHi = null;
			_asset = null;
		}

		protected function autoLock():void 
		{
			if (onClick != null) {
				unlockElement();
			} else {
				lockElement();
			}
		}

		/* ----------------------------------------------------------------- */
		
		public function setOnClick(callBack:Function):void 
		{
			if (onClick != null) {
				mcButton.removeEventListener(MouseEvent.CLICK, onClickEvent);
				onClick = null;
			}
			onClick = callBack;
			if (onClick != null) {
				mcButton.addEventListener(MouseEvent.CLICK, onClickEvent);
			}
			autoLock();
		}
		
		protected function onClickEvent(e:MouseEvent):void
		{
			onClick();
		}
		
		/* ----------------------------------------------------------------- */

		public function setRollover(rLo:Object = null, rHi:Object = null):void 
		{	
			if(mcHi != null) {
				mcHi.visible = false;
				mcHi.alpha = 0;
				
				mcButton.addEventListener(MouseEvent.ROLL_OUT, setLo);
				mcButton.addEventListener(MouseEvent.ROLL_OVER, setHi);
			}
		}

		/* ----------------------------------------------------------------- */

		protected function setLo(...args):void 
		{
			if (mcHi != null && !hiIsLocked && !isLocked) {
				TweenMax.killTweensOf(mcHi);
				TweenMax.to(mcHi, 0.2, {autoAlpha:0, ease:Linear.easeNone});
			}
		}

		protected function setHi(...args):void 
		{
			if (mcHi != null && !isLocked) {
				TweenMax.killTweensOf(mcHi);
				TweenMax.to(mcHi, 0.2, {autoAlpha:1, ease:Linear.easeNone});
			}
		}

		/* ----------------------------------------------------------------- */

		public function unlockElement():void
		{
			mcButton.enabled = true;
			mcButton.mouseEnabled = true;
			isLocked = false;
		}

		public function lockElement():void
		{
			mcButton.enabled = false;
			mcButton.mouseEnabled = false;
			isLocked = true;
		}

		public function setLoAndUnlockElement(...args):void
		{
			hiIsLocked = false;
			unlockElement();
			setLo();
		}

		public function setHiAndLockElement(...args):void
		{
			hiIsLocked = true;
			setHi();
			lockElement();
		}

		public function showElement(immediate:Boolean = false):void
		{
			TweenMax.killTweensOf(asset);
			TweenMax.killTweensOf(mcHi);
			
			unlockElement();
			
			var fadeAlpha:Number = 1;
			
			if(!immediate) {
				TweenMax.to(asset, 0.25, {autoAlpha:fadeAlpha, delay:0.25, ease:Linear.easeNone});
			} else {
				asset.visible = true;
				asset.alpha = fadeAlpha;
			}
		}

		public function hideElement(immediate:Boolean = false):void
		{
			TweenMax.killTweensOf(asset);
			TweenMax.killTweensOf(mcHi);
			
			lockElement();
			
			var fadeAlpha:Number = 0;
			
			if(!immediate) {
				TweenMax.to(asset, 0.25, {autoAlpha:fadeAlpha, delay:0.25, ease:Linear.easeNone});
			} else {
				asset.visible = false;
				asset.alpha = fadeAlpha;
			}
		}

		/**
		 * properties
		 */
		public function get asset():MovieClip {
			return _asset;
		}

		public function set mcButton(target:MovieClip):void {
			_mcButton = target;
		}

		public function get mcButton():MovieClip {
			return _mcButton;
		}

		public function set mcHi(target:MovieClip):void {
			_mcHi = target;
			
			if(_mcHi != null && _mcHi != asset){
				_mcHi.mouseEnabled = false;
				_mcHi.mouseChildren = false;
			}
		}

		public function get mcHi():MovieClip {
			return _mcHi;
		}

		public function get isHiAndLocked():Boolean {
			return hiIsLocked;
		}
	}
}
