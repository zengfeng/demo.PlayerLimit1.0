package
{
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import worlds.auxiliarys.mediators.MSignal;

	import flash.display.Sprite;
	import flash.events.Event;

	import walks.WalkProcessor;

	import wanders.WanderProcessor;

	import worlds.auxiliarys.MapPoint;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-20
	// ============================
	public class Player extends Sprite
	{
		private var _color : uint;
		private var _radius : Number;
		public var isShow : Boolean;
		public var gridIndex : int = -1;
		private var updateGridPosition : Function;
		public var walking : Boolean;
		public var sWalkStart : MSignal = new MSignal();
		public var sWalkEnd : MSignal = new MSignal();
		public var sPosition : MSignal = new MSignal(int, int);
		public var sMove : MSignal = new MSignal(Player);

		public function Player(radius : Number, color : uint = 0x66AA66)
		{
			_radius = radius;
			_color = color;
			draw();
			walkProcessor.reset(position, 10, updatePosition, walkStart, walkTrun, walkEnd, 0);
		}

		private function draw() : void
		{
			// draw a circle with a dot in the center
			graphics.clear();
			graphics.lineStyle(0);
			graphics.beginFill(_color, 1);
			graphics.drawCircle(_radius / 2, _radius / 2, _radius);
			graphics.endFill();
//			graphics.drawCircle(0, 0, 1);
		}

		public function set color(value : uint) : void
		{
			_color = value;
			draw();
		}

		public function get color() : uint
		{
			return _color;
		}

		public function set radius(value : Number) : void
		{
			_radius = value;
			draw();
		}

		public function get radius() : Number
		{
			return _radius;
		}

		public function addToLayer() : void
		{
			if (isShow == true) return;
			alpha = 1;
			clearTimeout(hideTimer);
//			App.playerAddToLayer(this);
			isShow = true;
		}
		
		private var hideTimer:uint = 0;
		public function removeFromLayer() : void
		{
			if (isShow == false) return;
			alpha = 0.5;
			hideTimer = setTimeout(setAlpha, 1500, 0.1);
//			App.playerRemoveFromLayer(this);
			isShow = false;
		}
		
		private function setAlpha(value:Number):void
		{
			alpha = value;
		}

		public function addToGrid() : void
		{
			if(gridIndex != -1) return;
			PlayerGridInstance.addPlayer(this);
		}

		public function removeFromGrid() : void
		{
			if(gridIndex == -1) return;
			PlayerGridInstance.removePlayer(this);
		}

		private var position : MapPoint = new MapPoint();
		private var wanderProcessor : WanderProcessor = new WanderProcessor();
		private var walkProcessor : WalkProcessor = new WalkProcessor();

		public function wander() : void
		{
			wanderProcessor.reset(walkProcessor.lineTo, null, x, y);
		}

		public function updatePosition(x : int, y : int) : void
		{
			this.x = x;
			this.y = y;
			position.x = x;
			position.y = y;
			sPosition.dispatch(x, y);
		}

		private function walkStart() : void
		{
			walking = true;
			sWalkStart.dispatch();
		}

		private function walkEnd() : void
		{
			walking = false;
			sWalkEnd.dispatch();
		}

		private function walkTrun(fromX : int, fromY : int, toX : int, toY : int) : void
		{
		}

		public function walkTo(toX : int, toY : int) : void
		{
			walkProcessor.lineTo(toX, toY);
		}

		public function walkPathAddPoint(toX : int, toY : int) : void
		{
			walkProcessor.addPathPoint(toX, toY);
		}
	}
}