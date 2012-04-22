/**
 * @class Pendulum
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.gui.element
{
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
		
		private var _pRotation:Number;
		private var _pColor:Number;
		
		public function Pendulum(d:Number, l:Number, r:Number, c:Number)
		{
			//display factor = 375;
			drawFactor = 375;
			
			_pDensity = d;
			
			_pLength = l;
			_pWidth = 0.04; // 4cm
			_pDepth = 0.004; // 4mm
			
			_pVolume = _pLength * _pWidth * _pDepth;
			
			//calc mass
			_pMass = _pDensity * _pVolume;
			
			dLength = _pLength * drawFactor;
			dWidth = _pWidth * drawFactor;
			dDepth = _pDepth * drawFactor;
			dOffset = dWidth * 0.5;
			
			_pRotation = r;
			_pColor = c;

			mcBar = new Sprite();
			this.addChild(mcBar);
			drawBar();
			
			var mcRound:Sprite = new Sprite();
			this.addChild(mcRound);
			mcRound.graphics.beginFill(0x000000);
			mcRound.graphics.drawCircle(0, 0, 3);
			mcRound.graphics.endFill();
		}
		
		private function drawBar():void
		{
			mcBar.graphics.clear();
			mcBar.graphics.lineStyle(2,0x000000,1.0,false);
			mcBar.graphics.beginFill(pColor, 0.5);
			mcBar.graphics.drawRect(-dOffset, -dOffset, dWidth, dLength);
		}
		
		public function setPosition(p:Pendulum):void
		{
			this.y = p.dLength - (2 * p.dOffset);
		}
		
		public function calcLenght():void
		{
			
		}

		public function calcMass():void
		{
			
		}
		
//		public function get pWidth():Number {
//			return _pWidth;
//		}
//		
//		public function set pWidth(w:Number):void {
//			_pWidth = w;
//			_pOffset = w/2;
//			
//			drawBar();
//		}
//		
//		public function get pLength():Number {
//			return _pLength;
//		}
//		
//		public function set pLength(h:Number):void {
//			_pLength = h;
//			
//			drawBar();
//		}
//		
//		public function get pOffset():Number {
//			return _pOffset;
//		}
//
//		public function set pOffset(n:Number):void {
//			_pOffset = n;
//		}

		public function get pColor():Number {
			return _pColor;
		}

		public function set pColor(n:Number):void {
			_pColor = n;
		}
	}
}
