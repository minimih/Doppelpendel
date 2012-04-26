/**
 * @class MenuBar
 *
 * @author 		mih
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
