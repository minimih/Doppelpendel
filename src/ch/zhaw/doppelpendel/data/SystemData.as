package ch.zhaw.doppelpendel.data
{
	/**
	 * @author MIH
	 */
	public class SystemData
	{
		public static function defaultData():XML
		{
			var data:XML = 
			<data>
				<!--
				gravity in m/s^2 (9.81 = earth)
				density in kg/m^3 (2700 = aluminium)
				-->
				<system gravity="9.81" density="2700">
					<!--
					length in m
					phi in grad
					omega in rad*s^(-1)
					color in hex
					-->
					<pendulum length="0.65" phi="180" omega="0" color="0xFF0000" />
					<pendulum length="0.35" phi="180" omega="0.1" color="0xFFFF00" />
				</system>
			</data>;
			
			return data;
		}
	}
}
