package managers {
	
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.data.gene.GeneManager;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.entity.IEntityManager;
	import com.ktm.genome.core.logic.impl.LogicScope;
	import com.ktm.genome.render.component.Layered;
	import com.ktm.genome.resource.component.TextureResource;
	import components.CollisionMap;
	import components.CollisionTile;
	import components.Grille;
	import components.Case;
	import constants.GameState;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import systems.GameStateSystem;
	
	public class EtageManager extends LogicScope {
		[Inject] public var gss:GameStateSystem;
		[Inject] public var entityManager:IEntityManager;
		[Inject] public var geneManager:GeneManager;
		private var grilleEntities:Family;
		private var caseEntities:Family;
		private var grilleMapper:IComponentMapper;
		private var typeMapper:IComponentMapper;
		private var texMapper:IComponentMapper;
		private var layerMapper:IComponentMapper;
		private var colMapper:IComponentMapper;
		private var colMapMapper:IComponentMapper;
		private var listeTypes:Array;
		private var cptGrille:int;
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			cptGrille = 0;
			grilleEntities = entityManager.getFamily(allOfGenes(Grille));
			grilleMapper = geneManager.getComponentMapper(Grille);
			
			caseEntities = entityManager.getFamily(allOfGenes(Case));
			typeMapper = geneManager.getComponentMapper(Case);
			texMapper = geneManager.getComponentMapper(TextureResource);
			layerMapper = geneManager.getComponentMapper(Layered);
			colMapper = geneManager.getComponentMapper(CollisionTile);
			colMapMapper = geneManager.getComponentMapper(CollisionMap);
			
			//Récupération de la liste des types existants
			listeTypes = new Array();
			for (var i:int = 0; i < caseEntities.members.length; i++) {
				listeTypes[i] = ((Case) (typeMapper.getComponent(caseEntities.members[i]))).type;
			}
			
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
			
			var collisionMap:BitmapData = new BitmapData(longueur * grille.pixels, hauteur * grille.pixels, false);
			var rect:Rectangle = new Rectangle(0, 0, grille.pixels, grille.pixels);
			
			for (var j:int = 0; j < hauteur; j++) {
				for (var i:int = 0; i < longueur; i++) {
					elm = caseEntities.members[listeTypes.indexOf(grille.grille[j][i])];
					tex = texMapper.getComponent(elm);
					colTile = colMapper.getComponent(elm);
					
					//Création case par case de la map de collision
					collisionMap.copyPixels(colTile.bitmapData, rect, new Point(i * grille.pixels, j * grille.pixels));
					//Création de chaque case de la map
					EntityFactory.createSquare(entityManager, grille.pixels * i, grille.pixels * j, grille.startX, grille.startY, grille.level, lay.layerId, tex);
				}
			}
			
			colMap.bitmapData = collisionMap;
			
			// ATTENTION l'état du jeu ne doit être changé qu'une fois TOUTES les grilles chargées. (le code qui suit ne fonctionne pas)
			cptGrille += 1;
			if ( cptGrille == grilleEntities.members.length) {
				trace("EtageManager lancé,");
				trace("-->",cptGrille, "étages chargés + changement GameState.RUNNING");
				gss.setGameState(GameState.RUNNING); 
			}
		}
	}
}