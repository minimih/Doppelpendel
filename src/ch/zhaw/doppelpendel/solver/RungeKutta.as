/**
 * @class RungeKutta
 * 
 * This part of the sourcecode is adapted from the www.MyPhysicsLab.com physics
 * simulation applet by Erik Neumann to ActionScript 3.
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
	public class RungeKutta implements IODE
	{
		private var ode : IODESolver;
		private var inp : Vector.<Number>;
		private var k1 : Vector.<Number>;
		private var k2 : Vector.<Number>;
		private var k3 : Vector.<Number>;
		private var k4 : Vector.<Number>;

		/** 
		 * Creates Runge-Kutta for solving ordinary differential equations.
		 * 
		 * @param ode Differential equation
		 */ 
		public function RungeKutta(ode : IODESolver)
		{
			this.ode = ode;
		}

		/** 
		 * Runge-Kutta method for solving ordinary differential equations.
		 * 
		 * Calculates the values of the variables at time t+h
		 * t = last time value
		 * h = time increment
		 * vars = array of variables
		 * n = number of variables in x array
		 * 
		 * @param h: step size (dt)
		 */
		public function step(h : Number) : void
		{
			var vars : Vector.<Number> = Vector.<Number>(ode.getVars());
			var n : int = vars.length;

			if ((inp == null) || (inp.length != n))
			{
				inp = new Vector.<Number>(n, true);
				k1 = new Vector.<Number>(n, true);
				k2 = new Vector.<Number>(n, true);
				k3 = new Vector.<Number>(n, true);
				k4 = new Vector.<Number>(n, true);
			}

			var i : int;

			// evaluate at time t
			ode.evaluate(vars, k1);
			for (i = 0; i < n; i++)
			{
				// set up input to diffeqs
				inp[i] = vars[i] + k1[i] * h / 2;
			}

			// evaluate at time t+stepSize/2
			ode.evaluate(inp, k2);
			for (i = 0; i < n; i++)
			{
				// set up input to diffeqs
				inp[i] = vars[i] + k2[i] * h / 2;
			}

			// evaluate at time t+stepSize/2
			ode.evaluate(inp, k3);
			for (i = 0; i < n; i++)
			{
				// set up input to diffeqs
				inp[i] = vars[i] + k3[i] * h;
			}

			// evaluate at time t+stepSize
			ode.evaluate(inp, k4);

			// determine which vars should be modified (calculated)
			var calc : Vector.<Boolean> = ode.getCalc();
			
			// modify the variables
			for (i = 0; i < n; i++)
			{
				if (calc[i])
				{
					vars[i] = vars[i] + (k1[i] + 2 * k2[i] + 2 * k3[i] + k4[i]) * h / 6;
				}
			}
		}
	}
}
