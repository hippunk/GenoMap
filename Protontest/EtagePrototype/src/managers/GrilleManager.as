package managers 
{
	
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.data.gene.GeneManager;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.entity.IEntityManager;
	import com.ktm.genome.core.logic.impl.LogicScope;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.resource.component.TextureResource;
	import components.CollisionMap;
	import components.CollisionTile;
	import systems.GameStateSystem;
	import components.GrilleComponent;
	import components.TypeCase;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.ktm.genome.render.component.Layered;
	import constants.GameState;
	/**
	 * ...
	 * @author Arthur
	 */
	public class GrilleManager extends LogicScope
	{
		[Inject] public var gss:GameStateSystem;
		[Inject] public var entityManager:IEntityManager;
		[Inject] public var geneManager:GeneManager;
		private var grilleEntities:Family;
		private var typeEntities:Family;
		private var grilleMapper:IComponentMapper;
		private var typeMapper:IComponentMapper;
		private var texMapper:IComponentMapper;
		private var layerMapper:IComponentMapper;
		private var colMapper:IComponentMapper;
		private var colMapMapper:IComponentMapper;
		private	var listeTypes:Array;

				
		override protected function onConstructed():void {
			super.onConstructed();
			
			grilleEntities = entityManager.getFamily(allOfGenes(GrilleComponent));
			grilleMapper = geneManager.getComponentMapper(GrilleComponent);

			typeEntities = entityManager.getFamily(allOfGenes(TypeCase,CollisionTile));
			typeMapper = geneManager.getComponentMapper(TypeCase);
			texMapper = geneManager.getComponentMapper(TextureResource);
			layerMapper = geneManager.getComponentMapper(Layered);
			colMapper = geneManager.getComponentMapper(CollisionTile);
			colMapMapper = geneManager.getComponentMapper(CollisionMap);
			
			//Récupération de la liste des types existants
				var ed:IEntity;
				var type:TypeCase;
				listeTypes = new Array();
				var I:int = typeEntities.members.length;

				for (var i:int = 0; i < I; i++) {
					ed = typeEntities.members[i];
					type = typeMapper.getComponent(ed);
					listeTypes[i] = type.typeCase;
				}
				trace(listeTypes);
			
			grilleEntities.entityAdded.add(ajout);
		}
		
		protected function ajout(e:IEntity):void {
			


			
			var grille:GrilleComponent = grilleMapper.getComponent(e);
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
					
					elm = typeEntities.members[listeTypes.indexOf(grille.grille[j][i])];	
					tex = texMapper.getComponent(elm);
					colTile = colMapper.getComponent(elm);
					
					//Création point par point de la map de collision
						collisionMap.copyPixels(colTile.tile, rect, new Point(i * grille.tailleX, j * grille.tailleY));
					//Création de chaque case de la map
						EntityFactory.createSquare(entityManager, grille.pixels * i, grille.pixels * j, grille.startX, grille.startY,grille.level , lay.layerId, tex);
				}

			}
			
			colMap.collisionMap =  collisionMap;//<< Ajouter la collisionMap dans l'etage et c'est gagné
			gss.setGameState(GameState.RUNNING);
		}

	}

}