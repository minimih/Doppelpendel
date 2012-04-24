/**
 * @class Pendulum
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.gui.element
{
	import ch.futurecom.log.FucoLogger;
	import ch.zhaw.doppelpendel.utils.Geom;

	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;

	import flash.display.Sprite;

	public class Pendulum extends Sprite
	{
		private var mcBar:Sprite;

		private var drawFactor:Number;

		private var dLength:Number;
		private var dWidth:Number;
		private var dDepth:Number;
		private var dOffset:Number;

		private var _pDensity:Number;
		private var _pMass:Number;

		private var _pLength:Number;
		private var _pWidth:Number;
		private var _pDepth:Number;

		private var _pVolume:Number;

		private var _pPhi:Number;
		private var _pOmega:Number;

		private var _pColor:Number;

		public function Pendulum(d:Number, l:Number, r:Number, o:Number, c:Number)
		{
			// display factor = 375;
			drawFactor = 375;

			_pDensity = d;

			_pLength = l;
			_pWidth = 0.04; // 4cm
			_pDepth = 0.004; // 4mm
			
			_pOmega = o;
			_pColor = c;
			
			mcBar = new Sprite();
			this.addChild(mcBar);
			
			var mcRound:Sprite = new Sprite();
			this.addChild(mcRound);
			mcRound.graphics.beginFill(0x000000);
			mcRound.graphics.drawCircle(0, 0, 3);
			mcRound.graphics.endFill();
			
			updateSize();
			pPhi = r;
		}
		
		/* ----------------------------------------------------------------- */

		private function drawBar():void
		{
			dLength = _pLength * drawFactor;
			dWidth = _pWidth * drawFactor;
			dDepth = _pDepth * drawFactor;
			dOffset = dWidth * 0.5;
			
			mcBar.graphics.clear();
			mcBar.graphics.lineStyle(2, 0x000000, 1.0, false);
			mcBar.graphics.beginFill(pColor, 0.5);
			mcBar.graphics.drawRect(-dOffset, -dOffset, dWidth, dLength);
		}

		public function reset(l:Number, r:Number, o:Number):void
		{
			pLength = l;
			pOmega = o;
			
			FucoLogger.debug(Geom.degrees(-this.rotation));
			FucoLogger.debug(r);
			
			if(Geom.degrees(-this.rotation) > r + 180){
				r = r + 360;
			}
			
			TweenMax.to(this, 1, {pPhi:r, ease:Elastic.easeOut});
		}

		public function setPosition(p:Pendulum):void
		{
			this.y = p.dLength - (2 * p.dOffset);
		}

		public function updateSize():void
		{
			// calc volume
			_pVolume = _pLength * _pWidth * _pDepth;

			// calc mass
			_pMass = _pDensity * _pVolume;

			drawBar();
		}

		public function updateMass():void
		{
			// calc volume
			_pVolume = _pMass / _pDensity;
			// calc length
			_pLength = _pVolume / (_pWidth * _pDepth);

			drawBar();
		}

		/* ----------------------------------------------------------------- */

		public function get pPhi():Number {
			return _pPhi;
		}

		public function set pPhi(r:Number):void {
			_pPhi = Geom.degrees(r);
			this.rotation = -_pPhi;
		}

		public function get pOmega():Number {
			return _pOmega;
		}

		public function set pOmega(i:Number):void {
			_pOmega = i;
		}

		public function get pLength():Number {
			return _pLength;
		}

		public function set pLength(l:Number):void {
			_pLength = l;

			updateSize();
		}

		public function get pMass():Number {
			return _pMass;
		}

		public function set pMass(m:Number):void {
			_pMass = m;

			updateMass();
		}

		public function get pColor():Number {
			return _pColor;
		}

		public function set pColor(n:Number):void {
			_pColor = n;
		}
	}
}
