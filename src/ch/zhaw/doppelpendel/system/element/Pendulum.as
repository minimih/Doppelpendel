/**
 * @class Pendulum
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
package ch.zhaw.doppelpendel.system.element
{
	import ch.zhaw.doppelpendel.utils.Geom;

	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;

	import flash.display.Sprite;
	import flash.events.Event;

	public class Pendulum extends Sprite
	{
		private var parentPendulum:Pendulum;
		
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
		private var _rOmega:Number;
		private var _rLength:Number;
		private var _rMass:Number;
		
		public function Pendulum(d:Number, l:Number, r:Number, o:Number, c:Number, p:Pendulum = null)
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			parentPendulum = p;
			
			// display factor = 375;
			drawFactor = 375;

			_pDensity = d;

			_pLength = l;
			// 4cm
			_pWidth = 0.04;
			// 4mm
			_pDepth = 0.004;
			
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
			_rOmega = o;
			_rMass = pMass;
			
			TweenMax.to(this, 0.75, {shortRotation:{rotation:-rPhi}, ease:Cubic.easeInOut});
		}

		public function setPosition(parentP:Pendulum):void
		{
			this.y = parentP.dLength - (2 * parentP.dOffset);
		}
		
		public function updateRotation():void
		{
			this.rotation = -Geom.realDeg(rPhi);
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
			if(parentPendulum)
				return Geom.radToDeg(pPhi - parentPendulum.pPhi);

			return Geom.radToDeg(pPhi);
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
