/**
 * @class Geom
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.utils
{
	public class Geom
	{
		public static function realDeg(deg:Number):Number
		{
			deg = deg % 360;

			if (deg < 0)
			{
				deg = 360 + deg;
			}

			return deg;
		}
		
		public static function radToDeg(rad:Number):Number
		{
			return rad * 180/Math.PI;
			
		}
		
		public static function degToRad(deg:Number):Number
		{
			return deg * Math.PI/180;
		}
	}
}
