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

	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.FileFilter;

	public class MenuBar extends EventDispatcher
	{
		private var file:File;
		
		public function MenuBar()
		{
			//set Menu
			var root:NativeMenu = new NativeMenu(); 
			if (NativeApplication.supportsMenu) 
			{ 
			    NativeApplication.nativeApplication.menu = root; 
			} 
			else if (NativeWindow.supportsMenu) 
			{ 
			    StageUtils.stage.nativeWindow.menu = root;
			}
			
			var fileMenu:NativeMenu = new NativeMenu();			
			var loadMenuItem:NativeMenuItem = new NativeMenuItem("Load Configuration");
			loadMenuItem.addEventListener(Event.SELECT, onLoadFile); 
			
			var exitMenuItem:NativeMenuItem = new NativeMenuItem("Exit");
			exitMenuItem.addEventListener(Event.SELECT, onExit); 
			
			root.addSubmenu(fileMenu, "File");
			fileMenu.addItem(loadMenuItem);
			fileMenu.addItem(exitMenuItem);
			
			// set FileReference
			file = new File();
			file.addEventListener(Event.SELECT, onFileSelected);	
		}
		
		/* ----------------------------------------------------------------- */
		
		private function onLoadFile(e:Event):void
		{
			file.browseForOpen("Load Pendulum Configuration", [new FileFilter("Pendulum Configuration File (idp)", "*.idp")]);
		}
		
		private function onExit(e:Event):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		/* ----------------------------------------------------------------- */

		private function onFileSelected(e:Event):void
		{
			dispatchEvent(new MenuEvent(MenuEvent.LOAD, {file:file.nativePath}));
		}
	}
}
