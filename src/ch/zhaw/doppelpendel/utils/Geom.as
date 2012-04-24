/**
 * @class Geom
 * 
 * @author 		mih
 */
package ch.zhaw.doppelpendel.utils
{
	public class Geom
	{
		public static function degrees(deg:Number):Number
		{
			deg = deg % 360;

			if (deg < 0)
			{
				deg = 360 + deg;
			}

			return deg;
		}
	}
}
