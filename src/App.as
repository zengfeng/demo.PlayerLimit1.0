package
{
	import worlds.auxiliarys.EnterFrameListener;
	import worlds.auxiliarys.MapMath;

	import com.sociodox.theminer.TheMiner;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.Security;
	import flash.ui.Keyboard;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-20
	// ============================
	[ SWF ( frameRate="60" , backgroundColor=0xFFFFFF,width="1680" , height="800" ) ]
	public class App extends Sprite
	{
		private var gridView : GridView = new GridView();
		private static var playerLayer : Sprite = new Sprite();
		private var container : Sprite = new Sprite();
		public static var mapWidth : int = 5888;
		public static var mapHeight : int = 4864;
		private var gridSize : int = 512;
		private var maxShow:int = 30;
		private var playerRadius : int = 50;
		private var self : Player = new Player(playerRadius, 0xFF5555);

		public function App()
		{
			initializeStage();
			EnterFrameListener.startup(stage);
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(Event.RESIZE, onStageResize);
			container.scaleX = container.scaleY = stage.stageHeight / mapHeight;
//			self.sPosition.add(updateContainerLayerPosition);
			addChild(container);
			addChild(new TheMiner());
			playerLayer.mouseChildren = false;
			playerLayer.mouseEnabled = false;
			container.addChild(gridView);
			container.addChild(playerLayer);
			gridView.reset(mapWidth, mapHeight, gridSize);
			self.updatePosition(MapMath.randomInt(mapWidth, mapWidth / 4), MapMath.randomInt(mapHeight, mapHeight / 4));
			playerLayer.addChild(self);
			PlayerGridInstance.reset(mapWidth, mapHeight, gridSize, maxShow);
			PlayerGridInstance.setSelf(self);
		}
		
		/** 根据自己的位置X,获取地图位置X */
		public  function selfToMapX(selfX : int) : int
		{
			var mapX : int;
			var stageWidth:int = stage.stageWidth;
			var stageWidthHalf:int = stageWidth >> 1;
			// 如果地图宽度小场景
			if (mapWidth <= stageWidth)
			{
				mapX = (stageWidth - mapX) >> 1;
			}
			else
			{
				// 左边沿
				if (selfX <= stageWidthHalf)
				{
					mapX = 0;
				}
				// 右边沿
				else if (selfX > mapWidth - stageWidthHalf )
				{
					mapX = stageWidth - mapWidth;
				}
				else
				{
					mapX = stageWidthHalf - selfX;
				}
			}

			return mapX;
		}

		/** 根据自己的位置X,获取地图位置X */
		public  function selfToMapY(selfY : int) : int
		{
			var mapY : int;
			var stageHeight:int = stage.stageHeight;
			var stageHeightHalf:int = stageHeight >> 1;
			// 如果地图宽度小场景
			if (mapHeight <= stageHeight)
			{
				mapY = (stageHeight - selfY) >> 1;
			}
			else
			{
				// 上边沿
				if (selfY <= stageHeightHalf)
				{
					mapY = 0;
				}
				// 下边沿
				else if (selfY > mapHeight - stageHeightHalf )
				{
					mapY = stageHeight - mapHeight;
				}
				else
				{
					mapY = stageHeightHalf - selfY;
				}
			}

			return mapY;
		}
		
		
		private function updateContainerLayerPosition(selfX:int, selfY:int):void
		{
			container.x = selfToMapX(selfX);
			container.y = selfToMapY(selfY);
		}

		private function onKeyDown(event : KeyboardEvent) : void
		{
			switch(event.keyCode)
			{
				case Keyboard.A:
					addPlayers();
					break;
			}
		}

		private function onMouseClick(event : MouseEvent) : void
		{
			if (event.ctrlKey)
			{
				self.walkPathAddPoint(container.mouseX, container.mouseY);
			}
			else
			{
				self.walkTo(container.mouseX, container.mouseY);
			}
		}

		private function onStageResize(event : Event) : void
		{
			container.scaleX = container.scaleY = stage.stageHeight / mapHeight;
			trace(container.scaleX);
		}

		private function initializeStage() : void
		{
			flash.system.Security.allowDomain("*");
			stage.quality = StageQuality.HIGH;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}

		private function addPlayers() : void
		{
			for (var i : int = 0; i < 100; i++)
			{
				createPlayer();
			}
		}

		private function createPlayer() : void
		{
			var player : Player = new Player(50);
//			player.alpha = 0.1;
			player.cacheAsBitmap = true;
			player.updatePosition(MapMath.randomInt(mapWidth - mapWidth / 6, mapWidth / 6), MapMath.randomInt(mapHeight - mapHeight / 6, mapHeight / 6));
			player.wander();
			player.addToGrid();
			playerLayer.addChild(player);
		}

		public static function playerAddToLayer(player : Player) : void
		{
			playerLayer.addChild(player);
		}

		public static function playerRemoveFromLayer(player : Player) : void
		{
			if (player.parent) playerLayer.removeChild(player);
		}
	}
}
