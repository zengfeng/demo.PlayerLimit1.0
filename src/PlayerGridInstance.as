package
{
	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-20
	// ============================
	public class PlayerGridInstance
	{
		private static var grid : PlayerGrid = new PlayerGrid();

		public static function reset(width : int, height : int, gridSize : int, maxShow : int = 100) : void
		{
			grid.reset(width, height, gridSize, maxShow);
		}

		public static function setSelf(player : Player) : void
		{
			grid.setSelf(player);
		}

		public static function addPlayer(player : Player) : void
		{
			grid.addPlayer(player);
		}

		public static function removePlayer(player : Player) : void
		{
			grid.removePlayer(player);
		}
		
	}
}
