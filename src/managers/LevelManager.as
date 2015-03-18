package managers {
	
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import components.GameLevel;
	import components.Tiles;
	import constants.GameState;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import systems.GameStateSystem;
	
	public class LevelManager extends System {
		
		[Inject]
		public var gss:GameStateSystem;
		private var gameLevelEntities:Family;
		private var gameLevelMapper:IComponentMapper;
		private var tilesEntities:Family;
		private var tiles:Tiles;
		private var tilesMapper:IComponentMapper;
		
		public function LevelManager() {
			super();
		}
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			this.tilesMapper = geneManager.getComponentMapper(Tiles);
			this.tilesEntities = entityManager.getFamily(allOfGenes(Tiles));
			
			this.gameLevelMapper = geneManager.getComponentMapper(GameLevel);
			this.gameLevelEntities = entityManager.getFamily(allOfGenes(GameLevel));
		}
		
		override protected function onProcess(delta:Number):void {
			super.onProcess(delta);
			
			for each (var e:IEntity in gameLevelEntities.members) {
				var gameLevel:GameLevel = gameLevelMapper.getComponent(e);
				var collisionMap:BitmapData = new BitmapData(gameLevel.sizeX * gameLevel.pixelsX, gameLevel.sizeY * gameLevel.pixelsY, false);
				var rect:Rectangle = new Rectangle(0, 0, gameLevel.pixelsX, gameLevel.pixelsY);
				
				this.tiles = tilesMapper.getComponent(this.tilesEntities.members[0]);
				for (var y:int = 0; y < gameLevel.sizeY; y++) {
					for (var x:int = 0; x < gameLevel.sizeX; x++) {
						var id:int = gameLevel.grid[y][x];
						collisionMap.copyPixels(tiles.collisionTile[id], rect, new Point(x * gameLevel.pixelsX, y * gameLevel.pixelsY));
						EntityFactory.createTextureTile(entityManager, x * gameLevel.pixelsX, y * gameLevel.pixelsY, "gameLayer", tiles.textureTilePath + tiles.textureTileName[id], tiles.tileId[id]);
					}
				}
				
				EntityFactory.createCollisionMap(entityManager, collisionMap);
			}
			
			gss.setGameState(GameState.RUNNING);
		}
	
	}
}