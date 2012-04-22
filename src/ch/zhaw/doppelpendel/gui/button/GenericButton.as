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
	import flash.text.TextField;

	public class GenericButton extends AbstractButton implements IButton
	{		
		private var tfLabel:TextField;
		
		private var rolloverLo:Object;
		private var rolloverHi:Object;

		public function GenericButton(mcAsset:MovieClip, setButtonArea:MovieClip = null, setHiClip:MovieClip = null)
		{
			super(mcAsset, setButtonArea, setHiClip);
			
			tfLabel = asset.tf_label;
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
