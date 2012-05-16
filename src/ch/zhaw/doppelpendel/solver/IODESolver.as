/**
 * @class IODE
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
	public interface IODESolver
	{
		function reset():void;
		
		/* 
		 * defines the equations of the diff eq.
		 * input is the current variables in array 'x'.
		 * output is change rates for each diffeq in array 'change'.
		 */
		function evaluate(x:Vector.<Number>, change:Vector.<Number>):void;
		
		/* 
		 * returns the array of state variables associated with this diff eq
   		 */
		function getVars():Vector.<Number>;
		function setVars(v:Vector.<Number>):void;

		/* returns array of booleans corresponding to the state variables.
		 * If true, then the variable is calculated by the ode solver.
		 * If false, then the variable is not modified by the ode solver.
		 */
		function getCalc():Vector.<Boolean>;
	}
}
