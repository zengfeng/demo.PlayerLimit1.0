package
{
	import worlds.auxiliarys.MapMath;

	import flash.events.Event;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-20
	// ============================
	public class PlayerGrid
	{
		private var _width : Number;
		private var _height : Number;
		private var _gridSize : Number;
		private var _numCells : int;
		private var _numCols : int;
		private var _numRows : int;
		private var _maxShow : int;
		private var _countShow : int;
		private var _grid : Vector.<Vector.<Player>> = new Vector.<Vector.<Player>>();
		private var _self : Player;
		private var _selfMoveing : Boolean;

		function PlayerGrid() : void
		{
		}

		public function clearup() : void
		{
			var cell : Vector.<Player>;
			while (_grid.length > 0)
			{
				cell = _grid.shift();
				while (cell.length > 0)
				{
					cell.shift();
				}
			}
		}

		public function reset(width : int, height : int, gridSize : int, maxShow : int = 100) : void
		{
			clearup();
			_width = width;
			_height = height;
			_gridSize = gridSize;
			_numCols = Math.ceil(_width / _gridSize);
			_numRows = Math.ceil(_height / _gridSize);
			_numCells = _numCols * _numRows;
			_maxShow = maxShow;
			_countShow = 0;
			_selfMoveing = false;
			makeGrid();
		}

		private function makeGrid() : void
		{
			var cell : Vector.<Player>;
			for (var i : int = 0; i < _numCells; i++)
			{
				cell = new Vector.<Player>();
				_grid.push(cell);
			}
		}

		public function setSelf(player : Player) : void
		{
			_self = player;
			_self.gridIndex = getIndex(_self.x, _self.y);
			_self.sWalkStart.add(selfMoveStart);
			_self.sWalkEnd.add(selfMoveEnd);
			_self.sPosition.add(selfMove);
			_selfMoveing = _self.walking;
		}

		public function addPlayer(player : Player) : void
		{
			if (player.gridIndex == -1)
			{
				player.gridIndex = getIndex(player.x, player.y);
				var cell : Vector.<Player> = getCell(player.gridIndex);
				cellAddPlayer(cell, player);
				playerMove(player);
			}
		}

		public function removePlayer(player : Player) : void
		{
			if (player.gridIndex != -1)
			{
				var cell : Vector.<Player> = getCell(player.gridIndex);
				cellRemovePlayer(cell, player);
			}
			player.gridIndex = -1;
		}

		private function selfMoveStart() : void
		{
			_selfMoveing = true;
		}

		private function selfMoveEnd() : void
		{
			_selfMoveing = false;
		}

		private function selfMove(x : int, y : int) : void
		{
			var preIndex : int = _self.gridIndex;
			var currIndex : int = getIndex(x, y);
			var cell : Vector.<Player>;
			if (preIndex == currIndex)
			{
				if (isFull)
				{
					cell = getCell(currIndex);
					cellSortShowHide(cell);
					if (isFull)
					{
						cellHide(currIndex - 1);
						if (isFull)
						{
							cellHide(currIndex + 1);
						}
					}
				}
				else
				{
					cell = getCell(currIndex);
					cellShowAll(cell);
					if (isFull == false)
					{
						cellShow(currIndex - 1);
						if (isFull == false)
						{
							cellShow(currIndex + 1);
						}
					}
				}
			}
			else
			{
				_self.gridIndex = currIndex;
				if (isFull)
				{
					cellHideGreaterDistance(preIndex);
					cellShow(currIndex);
				}
				else
				{
					cellShow(currIndex);
				}
			}
		}

		private function playerMove(player : Player) : void
		{
			if (_selfMoveing)
			{
				playerChangeIndex(player);
				return;
			}
		}

		private function playerChangeIndex(player : Player) : void
		{
			var preIndex : int = player.gridIndex;
			var currIndex : int = getIndex(player.x, player.y);
			if (preIndex != currIndex)
			{
				var cell : Vector.<Player> = getCell(preIndex);
				cellRemovePlayer(cell, player);
				cell = getCell(currIndex);
				cellAddPlayer(cell, player);
			}
		}

		private function get isFull() : Boolean
		{
			return _countShow > _maxShow;
		}

		private function getIndex(x : int, y : int) : int
		{
			return int(y / _gridSize) * _numCols + int(x / _gridSize);
		}

		private function getCell(index : int) : Vector.<Player>
		{
			return _grid[index];
		}

		private function playerShow(player : Player) : void
		{
			if (player.isShow == true) return;
			player.addToLayer();
			_countShow++;
		}

		private function playerHide(player : Player) : void
		{
			if (player.isShow == false) return;
			player.removeFromLayer();
			_countShow--;
		}

		private function cellRemovePlayer(cell : Vector.<Player>, player : Player) : void
		{
			var index : int = cell.indexOf(player);
			cell.splice(index, 1);
		}

		private function cellAddPlayer(cell : Vector.<Player>, player : Player) : void
		{
			cell.push(player);
		}

		private function cellShowAll(cell : Vector.<Player>) : void
		{
			var i : int;
			var length : int = cell.length;
			var player : Player;
			for (i = 0; i < length; i++)
			{
				player = cell[i];
				playerShow(player);
				if (isFull) break;
			}
		}

		private function cellHideAll(cell : Vector.<Player>) : void
		{
			var i : int;
			var length : int = cell.length;
			var player : Player;
			for (i = 0; i < length; i++)
			{
				player = cell[i];
				playerHide(player);
				if (isFull == false) break;
			}
		}

		private function cellHide(index : int) : void
		{
			if (index < 0 || index >= _numCells) return;
			var cell : Vector.<Player> = getCell(index);
			cellHideAll(cell);
		}

		private function cellHideGreaterDistance(index : int, distance : Number = 400) : void
		{
			if (index < 0 || index >= _numCells) return;
			var cell : Vector.<Player> = getCell(index);
			var player : Player;
			var playerDistance : Number;
			var length : int = cell.length;
			for (var i : int = 0; i < length; i++)
			{
				player = cell[i];
				playerDistance = MapMath.distance(player.x, player.y, _self.x, _self.y);
				if (playerDistance > distance)
				{
					playerHide(player);
				}
			}
		}

		private function cellShow(index : int) : void
		{
			if (index < 0 || index >= _numCells) return;
			var cell : Vector.<Player> = getCell(index);
			var vacantShow : int = _maxShow - _countShow;
			if (vacantShow > cell.length)
			{
				cellShowAll(cell);
			}
			else
			{
				cellSortShow(cell);
			}
		}

		private function cellSortShow(cell : Vector.<Player>) : void
		{
			cell.sort(cellSortHander);
			var length : int = _maxShow - _countShow;
			if (length > cell.length) length = cell.length;
			var player : Player;
			for (var i : int = 0; i < length; i++)
			{
				player = cell[i];
				playerShow(player);
			}
		}

		private function cellSortShowHide(cell : Vector.<Player>) : void
		{
			cell.sort(cellSortHander);
			var length : int = _maxShow;
			if (length > cell.length) length = cell.length;
			var player : Player;
			for (var i : int = 0; i < length; i++)
			{
				player = cell[i];
				playerShow(player);
			}

			i = length;
			length = cell.length;
			for (i; i < length; i++)
			{
				player = cell[i];
				playerHide(player);
			}
		}

		private function cellSortHander(a : Player, b : Player) : Number
		{
			var distA : Number = MapMath.distance(a.x, b.x, _self.x, _self.y);
			var distB : Number = MapMath.distance(a.x, b.x, _self.x, _self.y);
			return distA - distB;
		}
	}
}
