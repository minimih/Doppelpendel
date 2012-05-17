/**
 * @class MenuBar
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
package ch.zhaw.doppelpendel.gui
{
	import ch.futurecom.utils.StageUtils;
	import ch.zhaw.doppelpendel.event.MenuEvent;
	import ch.zhaw.doppelpendel.event.StageEvent;
	import ch.zhaw.doppelpendel.gui.button.MenuButton;

	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;

	public class MenuBar extends AssetMenuBar
	{
		private var mcBg:Sprite;

		private var file:FileReference;

		public function MenuBar()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			mcBg = this.mc_bg;

			initMenu();

			// add listener
			setSizeAndPosition();
			StageUtils.stage.addEventListener(StageEvent.STAGERESIZE, onStageResize);
		}

		private function initMenu():void
		{
			// set Menu
			var mcLoadMenu:LibMenu = new LibMenu();
			this.addChild(mcLoadMenu);
			
			var loadMenuBtn:MenuButton = new MenuButton(mcLoadMenu);
			loadMenuBtn.setLabel("Load Configuration");
			loadMenuBtn.setRollover();
			loadMenuBtn.setOnClick(onLoadFile);

			// set FileReference
			file = new FileReference();
			file.addEventListener(Event.SELECT, onFileSelected);
			file.addEventListener(Event.COMPLETE, onLoadComplete);
			file.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}

		/* ----------------------------------------------------------------- */

		private function onLoadFile():void
		{
			file.browse([new FileFilter("Pendulum Configuration File (idp)", "*.idp")]);
		}

		/* ----------------------------------------------------------------- */

		private function onFileSelected(e:Event):void
		{
			file.load();
		}

		private function onLoadComplete(e:Event):void
		{
			var loadedXml:XML = new XML(file.data);
			dispatchEvent(new MenuEvent(MenuEvent.LOAD, {xml:loadedXml}));
		}

		private function onError(e:ErrorEvent = null):void
		{
			dispatchEvent(new MenuEvent(MenuEvent.ERROR));
		}

		/* ----------------------------------------------------------------- */

		public function getHeight():int
		{
			return mcBg.height;
		}

		/* ----------------------------------------------------------------- */

		private function setSizeAndPosition():void
		{
			mc_bg.width = StageUtils.stageWidth;
		}

		private function onStageResize(e:Event):void
		{
			setSizeAndPosition();
		}
	}
}
