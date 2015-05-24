package managers {
	
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.data.gene.GeneManager;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.entity.IEntityManager;
	import com.ktm.genome.core.IWorld;
	import com.ktm.genome.core.logic.impl.LogicScope;
	import components.Case;
	import components.CollisionTile;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class CollisionTileManager extends LogicScope {
		[Inject] public var world:IWorld;
		[Inject] public var entityManager:IEntityManager;
		[Inject] public var geneManager:GeneManager;
		private var collisionTileEntities:Family;
		private var colMapper:IComponentMapper;
		private var cptLoad:int;
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			collisionTileEntities = entityManager.getFamily(allOfGenes(CollisionTile));
			colMapper = geneManager.getComponentMapper(CollisionTile);
			cptLoad = 0;
			
			//On charge la tuile de collision
			collisionTileEntities.entityAdded.add(ajout);
		}
		
		protected function ajout(e:IEntity):void {
			var loader:Loader = new Loader();
			var colTile:CollisionTile = colMapper.getComponent(e);
			
			loader.load(new URLRequest(colTile.collisionTilePath));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded(colTile));
		}
		
		public function onLoaded(colTile:CollisionTile):Function {
			return function(event:Event):void {
				LoaderInfo(event.target).removeEventListener(Event.COMPLETE, onLoaded);
				colTile.bitmapData = Bitmap(event.target.content).bitmapData;
				cptLoad += 1;
				
				if (cptLoad == collisionTileEntities.members.length) {
					trace("EtageManager lancé,");
					trace("-->",cptLoad, "tuiles de collision chargées");
					world.setLogic(new EtageManager());
				}
			};
		}
	}

}