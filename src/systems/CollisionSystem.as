package systems {
	
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.resource.component.TextureResource;
	import components.CollisionMap;
	import components.Controlable;
	import components.GameLevel;
	import components.Movable;
	import components.WatchedColors;
	
	public class CollisionSystem extends System {
		
		private var controlableEntities:Family;
		private var grilleEntities:Family;
		private var grilleMapper:IComponentMapper;
		private var textureResourceMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		private var movableMapper:IComponentMapper;
		private var watchedColorsMapper:IComponentMapper;
		private var collisionMapMapper:IComponentMapper;
		private var collisionMapEntities:Family;
		
		public function CollisionSystem() {
			super();
		}
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			controlableEntities = entityManager.getFamily(allOfGenes(Transform, TextureResource, Movable, Controlable));
			grilleEntities = entityManager.getFamily(allOfGenes(GameLevel));
			collisionMapEntities = entityManager.getFamily(allOfGenes(CollisionMap));
			
			textureResourceMapper = geneManager.getComponentMapper(TextureResource);
			transformMapper = geneManager.getComponentMapper(Transform);
			movableMapper = geneManager.getComponentMapper(Movable);
			watchedColorsMapper = geneManager.getComponentMapper(WatchedColors);
			collisionMapMapper = geneManager.getComponentMapper(CollisionMap);
		}
		
		override protected function onProcess(delta:Number):void {
			super.onProcess(delta);
			
			for (var iEnt:uint = 0; iEnt < controlableEntities.members.length; iEnt++) {
				var e:IEntity = controlableEntities.members[iEnt];
				var textureResource:TextureResource = textureResourceMapper.getComponent(e);
				var transform:Transform = transformMapper.getComponent(e);
				var movable:Movable = movableMapper.getComponent(e);
				var watchedColors:WatchedColors = watchedColorsMapper.getComponent(e);
				var colors:Vector.<int> = watchedColors.colors;
				
				var collisionMap:CollisionMap = collisionMapMapper.getComponent(collisionMapEntities.members[0]);
				
				for each (var colorHexa:int in colors) {
					if (colorHexa == collisionMap.bitmapData.getPixel(transform.x, transform.y))
						movable.velocity = 10;
					else
						movable.velocity = 2;
				}
				
			}
		}
	}
}