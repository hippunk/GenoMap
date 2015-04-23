package managers 
{
	
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.data.gene.GeneManager;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.entity.IEntityManager;
	import com.ktm.genome.core.logic.impl.LogicScope;
	import flash.display.Loader;
	import components.TypeCase;
	import components.CollisionTile;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	import com.ktm.genome.core.IWorld;
	/**
	 * ...
	 * @author Arthur
	 */
	public class TypeManager extends LogicScope
	{
		[Inject] public var world:IWorld;
		[Inject] public var entityManager:IEntityManager;
		[Inject] public var geneManager:GeneManager;
		private var typeEntities:Family;
		private var typeMapper:IComponentMapper;
		private var colMapper:IComponentMapper;
		private var cptLoad:int;
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			typeEntities = entityManager.getFamily(allOfGenes(TypeCase,CollisionTile));
			typeMapper = geneManager.getComponentMapper(TypeCase);
			colMapper = geneManager.getComponentMapper(CollisionTile);
			cptLoad = 0;
			
			//Pour chaque type que l'on ajoute il faut en plus charger l'image de la tuile de collision, la methode ajout se charge de ce travail
			typeEntities.entityAdded.add(ajout);
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
					colTile.tile = Bitmap(event.target.content).bitmapData;
					cptLoad += 1;

					if (cptLoad == typeEntities.members.length) {
						trace("Fin chargement des images");
						world.setLogic(new GrilleManager());
					}
				};
		}
	}

}