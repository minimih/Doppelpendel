/**
 * @class Controls
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.gui
{
	import ch.futurecom.utils.StageUtils;
	import ch.zhaw.doppelpendel.event.ControlEvent;
	import ch.zhaw.doppelpendel.event.StageEvent;
	import ch.zhaw.doppelpendel.gui.button.GenericButton;
	import ch.zhaw.doppelpendel.gui.button.ToggleButton;
	import ch.zhaw.doppelpendel.gui.form.TextInput;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Controls extends AssetControls
	{
		private var mcControls:MovieClip;
		private var mcBg:MovieClip;

		private var phi1:TextInput;
		private var phi2:TextInput;
		private var omega1:TextInput;
		private var omega2:TextInput;
		private var length1:TextInput;
		private var length2:TextInput;
		private var mass1:TextInput;
		private var mass2:TextInput;

		private var btnStartStop:ToggleButton;
		private var btnReset:GenericButton;

		public function Controls()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			mcControls = this.mc_controls;
			mcBg = this.mc_bg;

			initControls();

			// add listener
			setSizeAndPosition();
			StageUtils.stage.addEventListener(StageEvent.STAGERESIZE, onStageResize);
		}

		private function initControls():void
		{
			phi1 = new TextInput(mcControls.inp_phi_1);
			phi1.maxLength = 10;
			phi1.restrict = "0-9.";

			phi2 = new TextInput(mcControls.inp_phi_2);
			phi2.maxLength = 10;
			phi2.restrict = "0-9.";

			omega1 = new TextInput(mcControls.inp_omega_1);
			omega1.maxLength = 10;
			omega1.restrict = "0-9.";

			omega2 = new TextInput(mcControls.inp_omega_2);
			omega2.maxLength = 10;
			omega2.restrict = "0-9.";

			length1 = new TextInput(mcControls.inp_length_1);
			length1.maxLength = 10;
			length1.restrict = "0-9.";

			length2 = new TextInput(mcControls.inp_length_2);
			length2.maxLength = 10;
			length2.restrict = "0-9.";

			mass1 = new TextInput(mcControls.inp_mass_1);
			mass1.maxLength = 10;
			mass1.restrict = "0-9.";

			mass2 = new TextInput(mcControls.inp_mass_2);
			mass2.maxLength = 10;
			mass2.restrict = "0-9.";

			// set buttons
			btnStartStop = new ToggleButton(mcControls.btn_start);
			btnStartStop.setToggleLabel("Start", "Stop");
			btnStartStop.setRollover();
			btnStartStop.setOnClick(onStartStop);

			btnReset = new GenericButton(mcControls.btn_reset);
			btnReset.setLabel("Reset");
			btnReset.setRollover();
			btnReset.setOnClick(onReset);

			// add eventlisteners
			// phi1.addEventListener(Event.CHANGE, onUpdatePhi);
			// phi2.addEventListener(Event.CHANGE, onUpdatePhi);
			// omega1.addEventListener(Event.CHANGE, onUpdateOmega);
			// omega2.addEventListener(Event.CHANGE, onUpdateOmega);
			// length1.addEventListener(Event.CHANGE, onUpdateLength);
			// length2.addEventListener(Event.CHANGE, onUpdateLength);
			// mass1.addEventListener(Event.CHANGE, onUpdateMass);
			// mass2.addEventListener(Event.CHANGE, onUpdateMass);
		}

		private function onStartStop():void
		{
			TweenMax.killAll();
			
			if (btnStartStop.isToggled)
			{
				setFormEnabled(false);
				dispatchEvent(new ControlEvent(ControlEvent.START));
			}
			else
			{
				setFormEnabled(true);
				dispatchEvent(new ControlEvent(ControlEvent.STOP));
			}
		}

		private function onReset():void
		{
			resetControls();
			dispatchEvent(new ControlEvent(ControlEvent.RESET));
		}

		private function onUpdate(e:Event):void
		{
			dispatchEvent(new ControlEvent(ControlEvent.UPDATE));
		}

		/* ----------------------------------------------------------------- */
		
		public function resetControls():void
		{
			setFormEnabled(true);
			btnStartStop.reset();
		}
		
		public function updateControls(id:int, p:Number, o:Number, l:Number, m:Number):void
		{
			if(id == 0){
				phi1.text = p.toFixed(3);
				omega1.text = o.toFixed(3);
				length1.text = l.toFixed(3);
				mass1.text = m.toFixed(3);
			}else if(id == 1){
				phi2.text = p.toFixed(3);
				omega2.text = o.toFixed(3);
				length2.text = l.toFixed(3);
				mass2.text = m.toFixed(3);
			}
		}

		/* ----------------------------------------------------------------- */

		private function setFormEnabled(b:Boolean):void
		{
			phi1.enabled = b;
			phi2.enabled = b;
			omega1.enabled = b;
			omega2.enabled = b;
			length1.enabled = b;
			length2.enabled = b;
			mass1.enabled = b;
			mass2.enabled = b;
		}

		private function setSizeAndPosition():void
		{
			this.y = StageUtils.stageHeight - this.height;

			mcBg.width = StageUtils.stageWidth;
			mcControls.x = Math.round(mcBg.width - mcControls.width) * 0.5;
		}

		/* ----------------------------------------------------------------- */

		private function onStageResize(e:Event):void
		{
			setSizeAndPosition();
		}
	}
}
