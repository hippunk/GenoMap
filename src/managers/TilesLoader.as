package managers {
	
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.data.gene.GeneManager;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.entity.IEntityManager;
	import com.ktm.genome.core.logic.impl.LogicScope;
	import components.Tiles;
	import constants.GameState;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	import systems.GameStateSystem;
	
	public class TilesLoader extends LogicScope {
		
		[Inject]
		public var entityManager:IEntityManager;
		[Inject]
		public var geneManager:GeneManager;
		[Inject]
		public var gss:GameStateSystem;
		private var tilesEntities:Family;
		private var tilesMapper:IComponentMapper;
		private var collisionTileLoaders:Vector.<Loader>;
		private var collisionTileLoadCounter:uint;
		private var tiles:Tiles;
		
		public function TilesLoader() {
			super();
		}
		
		override protected function onConstructed():void {
			super.onConstructed();
			tilesMapper = geneManager.getComponentMapper(Tiles);
			tilesEntities = entityManager.getFamily(allOfGenes(Tiles));
			tilesEntities.entityAdded.add(loadTiles);
		}
		
		protected function loadTiles(e:IEntity):void {
			this.tiles = tilesMapper.getComponent(e);
			
			// Load collision tiles
			this.collisionTileLoaders = new Vector.<Loader>();
			this.collisionTileLoadCounter = 0;
			for (var i:uint = 0; i < tiles.collisionTileName.length; i++) {
				var collisionTileLoader:Loader = new Loader();
				collisionTileLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCollisionTileLoaded);
				this.collisionTileLoaders.push(collisionTileLoader);
				collisionTileLoader.load(new URLRequest(tiles.collisionTilePath + tiles.collisionTileName[i]));
			}
		}
		
		public function onCollisionTileLoaded(event:Event):void {
			LoaderInfo(event.target).removeEventListener(Event.COMPLETE, onCollisionTileLoaded);
			this.collisionTileLoadCounter += 1;
			// All collision tiles have been loaded
			if (this.collisionTileLoadCounter == this.tiles.collisionTileName.length) {
				for (var i:uint = 0; i < this.tiles.collisionTileName.length; i++) {
					this.tiles.collisionTile.push(Bitmap(this.collisionTileLoaders[i].content).bitmapData);
				}
				gss.setGameState(GameState.BUILDINGMAP);
			}
		}
	}
}