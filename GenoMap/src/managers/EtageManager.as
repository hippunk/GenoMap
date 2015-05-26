package managers {
	
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.data.gene.GeneManager;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.entity.IEntityManager;
	import com.ktm.genome.core.logic.impl.LogicScope;
	import com.ktm.genome.core.logic.process.ProcessManager;
	import com.ktm.genome.render.component.Layered;
	import com.ktm.genome.resource.component.TextureResource;
	import components.Case;
	import components.CollisionMap;
	import components.CollisionTile;
	import components.Grille;
	import constants.GameState;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import systems.GameStateSystem;
	
	public class EtageManager extends LogicScope {
		[Inject] public var gss:GameStateSystem;
		[Inject] public var entityManager:IEntityManager;
		[Inject] public var geneManager:GeneManager;
		[Inject] public var processManager:ProcessManager;

		private var grilleEntities:Family;
		private var caseEntities:Family;
		private var grilleMapper:IComponentMapper;
		private var typeMapper:IComponentMapper;
		private var texMapper:IComponentMapper;
		private var layerMapper:IComponentMapper;
		private var colMapper:IComponentMapper;
		private var colMapMapper:IComponentMapper;
		private var listeTypes:Array;
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			grilleEntities = entityManager.getFamily(allOfGenes(Grille));
			grilleMapper = geneManager.getComponentMapper(Grille);
			
			caseEntities = entityManager.getFamily(allOfGenes(Case));
			typeMapper = geneManager.getComponentMapper(Case);
			texMapper = geneManager.getComponentMapper(TextureResource);
			layerMapper = geneManager.getComponentMapper(Layered);
			colMapper = geneManager.getComponentMapper(CollisionTile);
			colMapMapper = geneManager.getComponentMapper(CollisionMap);
			
			grilleEntities.entityAdded.add(ajout);
		}
		
		protected function ajout(e:IEntity):void {
			var grille:Grille = grilleMapper.getComponent(e);
			var colMap:CollisionMap = colMapMapper.getComponent(e);
			var lay:Layered = layerMapper.getComponent(e);
			var longueur:int = grille.tailleX;
			var hauteur:int = grille.tailleY;
			var colTile:CollisionTile;
			var elm:IEntity;
			var tex:TextureResource;
			
			//Récupération de la liste des types existants
			listeTypes = new Array();
			for (var l:int = 0; l < caseEntities.members.length; l++) {
				listeTypes[l] = ((Case) (typeMapper.getComponent(caseEntities.members[l]))).type;
			}
			if (caseEntities.members.length == 0) {
				processManager.callLater(ajout, e);
				return;
			}
			
			var collisionMap:BitmapData = new BitmapData(longueur * grille.pixels, hauteur * grille.pixels, false);
			var rect:Rectangle = new Rectangle(0, 0, grille.pixels, grille.pixels);
			
			for (var j:int = 0; j < hauteur; j++) {
				for (var i:int = 0; i < longueur; i++) {
					var idx:int = listeTypes.indexOf(grille.grille[j][i]);
					if (idx == -1) {
						//processManager.callLater(ajout, e);
					}	
					else{
						elm = caseEntities.members[idx];
						tex = texMapper.getComponent(elm);
						colTile = colMapper.getComponent(elm);
						
						//Création case par case de la map de collision
						collisionMap.copyPixels(colTile.bitmapData, rect, new Point(i * grille.pixels, j * grille.pixels));
						//Création de chaque case de la map
						EntityFactory.createSquare(entityManager, grille.grille[j][i],grille.pixels * i, grille.pixels * j, grille.startX, grille.startY, grille.level, lay.layerId, tex);
					
					}
				}
			}
			
			colMap.bitmapData = collisionMap;
			
			gss.setGameState(GameState.RUNNING); 
		}
	}
}