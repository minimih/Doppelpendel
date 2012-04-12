/**
 * @class Pendulum
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.gui.element {
	import flash.display.Sprite;
	
	public class Pendulum extends Sprite
	{
		private var mcBar:Sprite;

		private var _pWidth:Number;
		private var _pHeight:Number;
		private var _pOffset:Number;
		private var _pColor:Number;
		
		public function Pendulum(c:Number)
		{
			_pWidth = 16;
			_pHeight = 100; //TODO needs to be calculated with mass
			_pOffset = pWidth/2;
			
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
			mcBar.graphics.lineStyle(2,0x000000);
			mcBar.graphics.beginFill(pColor, 0.5);
			mcBar.graphics.drawRect(-pOffset, -pOffset, pWidth, pHeight);
		}
		
		public function get pWidth():Number {
			return _pWidth;
		}
		
		public function set pWidth(w:Number):void {
			_pWidth = w;
			_pOffset = w/2;
			
			drawBar();
		}
		
		public function get pHeight():Number {
			return _pHeight;
		}
		
		public function set pHeight(h:Number):void {
			_pHeight = h;
			
			drawBar();
		}
		
		public function get pOffset():Number {
			return _pOffset;
		}

		public function set pOffset(n:Number):void {
			_pOffset = n;
		}

		public function get pColor():Number {
			return _pColor;
		}

		public function set pColor(n:Number):void {
			_pColor = n;
		}
		
		// pendelA = new Sprite();
			// pendelB = new Sprite();
			//			
			// this.addChild(pendelA);
			// pendelA.addChild(pendelB);
			//			
			// pendelA.graphics.lineStyle(3,0x000000);
			// pendelA.graphics.moveTo(0,0);
			// pendelA.graphics.lineTo(0,100);
			//			
			// var rA:Sprite = new Sprite();
			// pendelA.addChild(rA);
			// rA.graphics.beginFill(0x00ffff);
			// rA.graphics.drawCircle(0, 0, 10);
			// rA.graphics.endFill();
			//
			// rA.x = 0;
			// rA.y = 100;
			//			
			// pendelB.graphics.lineStyle(3,0x000000);
			// pendelB.graphics.moveTo(0,0);
			// pendelB.graphics.lineTo(0,100);
			//
			// var rB:Sprite = new Sprite();
			// pendelB.addChild(rB);
			// rB.graphics.beginFill(0xff0000);
			// rB.graphics.drawCircle(0, 0, 10);
			// rB.graphics.endFill();
			//
			// rB.x = 0;
			// rB.y = 100;
			//
			// pendelA.x = Math.round(stage.stageWidth/2);
			// pendelA.y = Math.round(stage.stageHeight/2);
			//			
			// pendelB.x = 0;
			// pendelB.y = 100;
			//			
			// pendelA.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
//		private function onEnterFrame(e:Event):void
//		{
//			pendelA.rotation += 1;
//			pendelB.rotation -= 5;
//		}
	}
}
