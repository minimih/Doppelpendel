/**
 * @class Background
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
package ch.zhaw.doppelpendel.gui {
	import ch.futurecom.utils.StageUtils;
	import ch.zhaw.doppelpendel.event.StageEvent;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Background extends Sprite {
		private var mcBg : Sprite;

		public function Background() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e : Event = null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			// add listener
			setSizeAndPosition();
			StageUtils.stage.addEventListener(StageEvent.STAGERESIZE, onStageResize);
		}

		/* ----------------------------------------------------------------- */
		
		private function setSizeAndPosition() : void {
			var bmp : BitmapData = new LibBg();

			var tilesWidth : int = Math.ceil(StageUtils.stageWidth / bmp.width);
			var tilesHeight : int = Math.ceil(StageUtils.stageHeight / bmp.height);

			tilesWidth += tilesWidth % 2;
			tilesHeight += tilesHeight % 2;

			var bgWidth : int = tilesWidth * bmp.width;
			var bgHeight : int = tilesHeight * bmp.height;

			mcBg = new Sprite();
			mcBg.graphics.beginBitmapFill(bmp);
			mcBg.graphics.drawRect(0, 0, bgWidth, bgHeight);
			mcBg.graphics.endFill();

			this.addChild(mcBg);

			this.x = Math.round(Math.min(0, (StageUtils.stageWidth - mcBg.width) * 0.5));
			this.y = Math.round(Math.min(0, (StageUtils.stageHeight - mcBg.height) * 0.5));
		}

		/* ----------------------------------------------------------------- */
		
		private function onStageResize(e : Event) : void {
			setSizeAndPosition();
		}
	}
}
