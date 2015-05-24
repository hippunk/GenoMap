package systems {
	
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import components.CollisionMap;
	import components.CollisionTile;
	import components.Grille;
	import components.Movable;
	import components.WatchedColors;
	
	public class CollisionSystem extends System {
		
		private var controlableEntities:Family;
		private var etage:Family;
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
			etage = entityManager.getFamily(allOfGenes(CollisionMap, Grille));
			
			collisionTileMapper = geneManager.getComponentMapper(CollisionTile);
			transformMapper = geneManager.getComponentMapper(Transform);
			movableMapper = geneManager.getComponentMapper(Movable);
			watchedColorsMapper = geneManager.getComponentMapper(WatchedColors);
			collisionMapMapper = geneManager.getComponentMapper(CollisionMap);
			grilleMapper = geneManager.getComponentMapper(Grille);
		}
		
		override protected function onProcess(delta:Number):void {
			super.onProcess(delta);
				
			for each (var e:IEntity in controlableEntities.members) {
				var collisionTile:CollisionTile = collisionTileMapper.getComponent(e);
				var transform:Transform = transformMapper.getComponent(e);
				var movable:Movable = movableMapper.getComponent(e);
				var watchedColors:WatchedColors = watchedColorsMapper.getComponent(e);
				var collisionMap:CollisionMap = collisionMapMapper.getComponent(etage.members[0]);
				var grille:Grille = grilleMapper.getComponent(etage.members[0]);
				
				var w:int = collisionTile.bitmapData.width;
				var h:int = collisionTile.bitmapData.height;
				var i:int = w * h;
				var col:int;
				var velocity:Array = new Array();
				
				// pour tous les pixels de la collision tile
				while (i--) {
					// si c'est un pixel noir
					if (collisionTile.bitmapData.getPixel(i % w, int(i / w)) == int(0x000000)) {
						var color:int = collisionMap.bitmapData.getPixel(transform.x + i % w - grille.startX, transform.y + int(i / w) - grille.startY);
						for each (var watchedColor:int in watchedColors.colors) {
							if (color == watchedColor) {
								velocity.push(8);
							} else {
								velocity.push(0);
							}
						}
					}
				}
				
				movable.currentVelocity = movable.normalVelocity + Math.min.apply(null, velocity);
			}
		}
	}
}