package systems {
	
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.resource.component.TextureResource;
	import components.Controlable;
	import components.GameLevel;
	import components.Movable;
	import components.WatchedColors;
	import components.TextureTile;
	import components.CollisionTile;
	import components.Tiles;
	
	public class CollisionSystem extends System {
		
		private var controlableEntities:Family;
		private var gameLevelEntities:Family;
		private var tilesEntities:Family;
		private var textureResourceMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		private var movableMapper:IComponentMapper;
		private var watchedColorsMapper:IComponentMapper;
		private var gameLevelMapper:IComponentMapper;
		private var collisionTileMapper:IComponentMapper;
		private var tilesMapper:IComponentMapper;
		
		
		public function CollisionSystem() {
			super();
		}
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			controlableEntities = entityManager.getFamily(allOfGenes(Transform, Movable, CollisionTile));
			gameLevelEntities = entityManager.getFamily(allOfGenes(GameLevel));
			tilesEntities = entityManager.getFamily(allOfGenes(Tiles));
			
			textureResourceMapper = geneManager.getComponentMapper(TextureResource);
			transformMapper = geneManager.getComponentMapper(Transform);
			movableMapper = geneManager.getComponentMapper(Movable);
			watchedColorsMapper = geneManager.getComponentMapper(WatchedColors);
			gameLevelMapper = geneManager.getComponentMapper(GameLevel);
			collisionTileMapper = geneManager.getComponentMapper(CollisionTile);
			tilesMapper = geneManager.getComponentMapper(Tiles);
		}
		
		override protected function onProcess(delta:Number):void {
			super.onProcess(delta);
			
			for (var iEnt:uint = 0; iEnt < controlableEntities.members.length; iEnt++) {
				var e:IEntity = controlableEntities.members[iEnt];
				var textureResource:TextureResource = textureResourceMapper.getComponent(e);
				var transform:Transform = transformMapper.getComponent(e);
				var movable:Movable = movableMapper.getComponent(e);
				var watchedColors:WatchedColors = watchedColorsMapper.getComponent(e);
				var gameLevel:GameLevel = gameLevelMapper.getComponent(gameLevelEntities.members[0]);
				var collisionTile:CollisionTile = collisionTileMapper.getComponent(e);
				
				
				var tiles:Tiles = tilesMapper.getComponent(this.tilesEntities.members[0]);
				var w:int = tiles.collisionTile[collisionTile.tileIndex].width;
				var h:int = tiles.collisionTile[collisionTile.tileIndex].height;
				var i:int = w * h;
				var col:int;
				var velocity:Array = new Array();
				
				while ( i-- ) {
					if ( tiles.collisionTile[collisionTile.tileIndex].getPixel( i % w, int( i / w ) ) == int(0x000000)) {
						var color:int = gameLevel.collisionMap.getPixel(transform.x + i % w - gameLevel.posX, transform.y + int( i / w ) - gameLevel.posY);
						for each (var watchedColor:int in watchedColors.colors) {
							if (color == watchedColor) {
								velocity.push(8);
							}
							else {
								velocity.push(0);
							}
						}
					}
				}
				
				movable.currentVelocity = movable.normalVelocity+Math.min.apply(null, velocity);
			}
		}
	}
}