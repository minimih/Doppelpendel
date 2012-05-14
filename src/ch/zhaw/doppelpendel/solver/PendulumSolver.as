/**
 * @class PendulumSolver
 * 
 * This part of the sourcecode is adapted to AS3 from the www.MyPhysicsLab.com physics simulation applet.
 * Copyright (c) 2001  Erik Neumann
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
package ch.zhaw.doppelpendel.solver
{
	import ch.futurecom.log.FucoLogger;
	import ch.zhaw.doppelpendel.gui.element.Pendulum;

	public class PendulumSolver implements IODESolver
	{
		private var p1:Pendulum;
		private var p2:Pendulum;
		private var gravity:Number;
		// variables for Diff Eqn positions and velocities
		private var vars:Vector.<Number>;
		// calc vector = whether variables are calculated by ode solver
		private var calc:Vector.<Boolean>;

		/**
		 * Creates a new PendulumSolver
		 * 
		 * 	the variables are:
		 * 		0,1,2,3:  theta1,theta1',theta2,theta2'
		 * 		
		 * 	vars[0] = theta1
		 * 	vars[1] = theta1'
		 * 	vars[2] = theta2
		 * 	vars[3] = theta2'
		 */
		public function PendulumSolver(p1:Pendulum, p2:Pendulum)
		{
			this.p1 = p1;
			this.p2 = p2;

			gravity = 9.81;

			var numVars:Number = 4;

			vars = new Vector.<Number>(numVars, true);
			calc = new Vector.<Boolean>(numVars, true);

			// set init vars
			vars[0] = p1.pPhi;
			vars[1] = p1.pOmega;
			vars[2] = p2.pPhi;
			vars[3] = p2.pOmega;

			for (var i:int = 0; i < calc.length; i++)
			{
				calc[i] = true;
			}
		}

		/** Equations for double pendulum
		 * 
		 * 	L1,L2 = stick lengths
		 *	m1,m2 = masses
		 * 	g = gravity
		 * 	
		 * 	theta1,theta2 = angles of sticks with vertical (down = 0)
		 * 	th1,th2 = theta1,theta2 abbreviations
		 * 	
		 * 	diff eqs:
		 * 	
		 * 	
		 * 	        -g (2 m1 + m2) Sin[th1] - g m2 Sin[th1 - 2 th2] - 2 m2 dth2^2 L2 Sin[th1 - th2] - m2 dth1^2 L1 Sin[2(th1 - th2)]
		 * 	ddth1 = ----------------------------------------------------------------------------------------------------------------
		 * 	                                          L1 (2 m1 + m2 - m2 Cos[2(th1-th2)])
		 * 	
		 * 	
		 * 	        2 Sin[th1-th2]((m1+m2) dth1^2 L1 + g (m1+m2) Cos[th1] + m2 dth2^2 L2 Cos[th1-th2])
		 * 	ddth2 = ----------------------------------------------------------------------------------
		 * 	                               L2 (2 m1 + m2 - m2 Cos[2(th1-th2)])
		 * 	
		 * 	
		 */
		public function evaluate(x:Vector.<Number>, change:Vector.<Number>):void
		{
			var th1:Number = x[0];
			var dth1:Number = x[1];
			var th2:Number = x[2];
			var dth2:Number = x[3];

			var m1:Number = p1.pMass;
			var m2:Number = p2.pMass;
			var L1:Number = p1.pLength;
			var L2:Number = p2.pLength;

			var g:Number = gravity;

			change[0] = dth1;

			var num:Number = -g * (2 * m1 + m2) * Math.sin(th1);
			num = num - g * m2 * Math.sin(th1 - 2 * th2);
			num = num - 2 * m2 * dth2 * dth2 * L2 * Math.sin(th1 - th2);
			num = num - m2 * dth1 * dth1 * L1 * Math.sin(2 * (th1 - th2));
			num = num / (L1 * (2 * m1 + m2 - m2 * Math.cos(2 * (th1 - th2))));
			change[1] = num;

			change[2] = dth2;

			num = (m1 + m2) * dth1 * dth1 * L1;
			num = num + g * (m1 + m2) * Math.cos(th1);
			num = num + m2 * dth2 * dth2 * L2 * Math.cos(th1 - th2);
			num = num * 2 * Math.sin(th1 - th2);
			num = num / (L2 * (2 * m1 + m2 - m2 * Math.cos(2 * (th1 - th2))));
			change[3] = num;
		}

		public function getVars():Vector.<Number>
		{
			return vars;
		}

		public function setVars(v:Vector.<Number>):void
		{
			FucoLogger.debug(v.toString());

			p1.pPhi = v[0];
			p1.pOmega = v[1];
			p2.pPhi = v[2];
			p2.pOmega = v[3];
		}

		public function getCalc():Vector.<Boolean>
		{
			return calc;
		}
	}
}
