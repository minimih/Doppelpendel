/**
 * @class Pendulum
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.gui.element
{
	import ch.zhaw.doppelpendel.utils.Geom;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Pendulum extends Sprite
	{
		private var mcBar:Sprite;

		private var drawFactor:Number;

		public var dLength:Number;
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
		
		//reset stuff
		private var _rPhi:Number;
		private var _rOmega:Number;
		private var _rLength:Number;
		private var _rMass:Number;
		
		public function Pendulum(d:Number, l:Number, r:Number, o:Number, c:Number)
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			// display factor = 375;
			drawFactor = 375;

			_pDensity = d;

			_pLength = l;
			_pWidth = 0.04;
			// 4cm
			_pDepth = 0.004;
			// 4mm
			
			_pPhi = Geom.degToRad(r);
			_pOmega = o;
			
			_pColor = c;

			mcBar = new Sprite();
			this.addChild(mcBar);

			var mcCenter:Sprite = new Sprite();
			this.addChild(mcCenter);
			mcCenter.graphics.beginFill(0x000000);
			mcCenter.graphics.drawCircle(0, 0, 3);
			mcCenter.graphics.endFill();
			
			updateSize();
			updateRotation();
		}
		
		private function onRemovedFromStage(e:Event = null):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			while(true){
				try{
					this.removeChildAt(0);
				}catch(error:Error){
					return;
				}
			}
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
			pPhi = Geom.degToRad(r);
			
			_rLength = l;
			_rPhi = r;
			_rOmega = o;
			_rMass = pMass;
			
			if (Geom.realDeg(-this.rotation) > r + 180)
			{
				r = r + 360;
			}
			
			TweenMax.to(this, 1, {rotation:Geom.realDeg(r), ease:Elastic.easeOut});
		}

		public function setPosition(parentP:Pendulum):void
		{
			this.y = parentP.dLength - (2 * parentP.dOffset);
		}
		
		public function updateRotation(parentP:Pendulum = null):void
		{
			var pRotation:Number;
			if(parentP){
				pRotation = Geom.radToDeg(pPhi - parentP.pPhi);
			}else{
				pRotation = Geom.radToDeg(pPhi);
			}
			this.rotation = -Geom.realDeg(pRotation);
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
			_pPhi = r;
		}

		public function get pOmega():Number {
			return _pOmega;
		}

		public function set pOmega(n:Number):void {
			_pOmega = n;
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
		
		/* ----------------------------------------------------------------- */
		
		public function get rPhi():Number {
			return _rPhi;
		}
		
		public function get rOmega():Number {
			return _rOmega;
		}
		
		public function get rLength():Number {
			return _rLength;
		}
		
		public function get rMass():Number {
			return _rMass;
		}
	}
}
