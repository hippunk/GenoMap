package systems {
	
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.resource.component.TextureResource;
	import components.Controlable;
	import components.CollisionMap;
	import components.Movable;
	import components.WatchedColors;
	import components.CollisionTile;
	import components.GrilleComponent;
	
	public class CollisionSystem extends  System {
		
		private var controlableEntities:Family;
		private var gameLevel:Family;
		private var collisionTileMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		private var movableMapper:IComponentMapper;
		private var watchedColorsMapper:IComponentMapper;
		private var collisionMapMapper:IComponentMapper;
		private var grilleMapper:IComponentMapper;
		
		public function CollisionSystem() {
			super();
		}
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			controlableEntities = entityManager.getFamily(allOfGenes(Transform, Movable, CollisionTile));
			gameLevel = entityManager.getFamily(allOfGenes(CollisionMap, GrilleComponent));
			
			collisionTileMapper = geneManager.getComponentMapper(CollisionTile);
			transformMapper = geneManager.getComponentMapper(Transform);
			movableMapper = geneManager.getComponentMapper(Movable);
			watchedColorsMapper = geneManager.getComponentMapper(WatchedColors);
			collisionMapMapper = geneManager.getComponentMapper(CollisionTile);
			grilleMapper = geneManager.getComponentMapper(GrilleComponent);
		}
		
		override protected function onProcess(delta:Number):void {
			super.onProcess(delta);
			
			for (var iEnt:uint = 0; iEnt < controlableEntities.members.length; iEnt++) {
				var e:IEntity = controlableEntities.members[iEnt];
				var collisionTile:CollisionTile = collisionTileMapper.getComponent(e);
				var transform:Transform = transformMapper.getComponent(e);
				var movable:Movable = movableMapper.getComponent(e);
				var watchedColors:WatchedColors = watchedColorsMapper.getComponent(e);
				var collisionMap:CollisionMap = collisionMapMapper.getComponent(gameLevel.members[0]);
				var grille:GrilleComponent = grilleMapper.getComponent(gameLevel.members[0]);
				
				var w:int = collisionTile.tile.width;
				var h:int = collisionTile.tile.height;
				var i:int = w * h;
				var col:int;
				var velocity:Array = new Array();
				
				while ( i-- ) {
					if ( collisionTile.tile.getPixel( i % w, int( i / w ) ) == int(0x000000)) {
						var color:int = collisionMap.collisionMap.getPixel(transform.x + i % w - grille.startX, transform.y + int( i / w ) - grille.startY);
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