/**
 * @class BasicButton
 *
 * @author 		mih
 */
package ch.zhaw.doppelpendel.gui.button
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class AbstractButton implements IButton
	{
		protected var _asset:MovieClip;
		protected var _mcButton:MovieClip;
		protected var _mcHi:MovieClip;

		protected var onClick:Function;

		protected var isLocked:Boolean;
		protected var hiIsLocked:Boolean;

		public function AbstractButton(mcAsset:MovieClip, setButtonArea:MovieClip = null, setHiClip:MovieClip = null)
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
