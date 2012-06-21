package
{
	import flash.display.Sprite;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-20
	// ============================
	public class GridView extends Sprite
	{
		private var _height : Number;
		private var _width : Number;
		private var _gridSize : Number;

		public function GridView()
		{
		}

		public function reset(width : int, height : int, gridSize : int) : void
		{
			_width = width;
			_height = height;
			_gridSize = gridSize;
			drawGrid();
		}

		private function drawGrid() : void
		{
			graphics.lineStyle(0, .5);
			var i : int;
			for (i = 0; i <= _width; i += _gridSize)
			{
				graphics.moveTo(i, 0);
				graphics.lineTo(i, _height);
			}

			for (i = 0; i <= _height; i += _gridSize)
			{
				graphics.moveTo(0, i);
				graphics.lineTo(_width, i);
			}
		}
	}
}
