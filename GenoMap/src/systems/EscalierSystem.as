package systems {
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Layer;
	import com.ktm.genome.render.component.Layered;
	import com.ktm.genome.render.component.Transform;
	import components.Active;
	import components.CollisionMap;
	import components.Dimension;
	import components.Focusable;
	import components.Grille;
	import components.Level;
	import components.LienEtage;
	import components.LienLayer;
	import components.Movable;
	import components.Orientation;
	import components.Position;
	import flash.utils.Dictionary;
	
	public class EscalierSystem extends System {
		private var escaliers:Family;
		private var layers:Family;
		private var maps:Family;
		private var persos:Family;
		
		private var grilleMapper:IComponentMapper;
		private var transformMapper:IComponentMapper;
		private var layerMapper:IComponentMapper;
		private var layeredMapper:IComponentMapper;
		
		private var dimensionMapper:IComponentMapper;
		private var orientationMapper:IComponentMapper;
		private var positionMapper:IComponentMapper;
		private var lienEtageMapper:IComponentMapper;
		private var lienLayerMapper:IComponentMapper;
		private var focusableMapper:IComponentMapper;
		private var levelMapper:IComponentMapper;
		private var activeMapper:IComponentMapper;
		private var boolEsc:Dictionary;
		
		private var sortie:Boolean = true;
		
		public function EscalierSystem() {
			super();
		}
		
		override protected function onConstructed():void {
			super.onConstructed();
			escaliers = entityManager.getFamily(allOfGenes(LienEtage, LienLayer, Orientation, Position, Dimension));
			layers = entityManager.getFamily(allOfGenes(Layer));
			maps = entityManager.getFamily(allOfGenes(CollisionMap, Grille));
			persos = entityManager.getFamily(allOfGenes(Movable));
			
			grilleMapper = geneManager.getComponentMapper(Grille);
			transformMapper = geneManager.getComponentMapper(Transform);
			layerMapper = geneManager.getComponentMapper(Layer);
			layeredMapper = geneManager.getComponentMapper(Layered);
			
			dimensionMapper = geneManager.getComponentMapper(Dimension);
			orientationMapper = geneManager.getComponentMapper(Orientation);
			positionMapper = geneManager.getComponentMapper(Position);
			lienEtageMapper = geneManager.getComponentMapper(LienEtage);
			lienLayerMapper = geneManager.getComponentMapper(LienLayer);
			focusableMapper = geneManager.getComponentMapper(Focusable);
			levelMapper = geneManager.getComponentMapper(Level);
			activeMapper = geneManager.getComponentMapper(Active);
			
			boolEsc = new Dictionary();
		}
		
		override protected function onProcess(delta:Number):void {
			super.onProcess(delta);
			
			for each (var e:IEntity in escaliers.members) {
				
				var pos:Position = positionMapper.getComponent(e);
				var dim:Dimension = dimensionMapper.getComponent(e);
				var ori:Orientation = orientationMapper.getComponent(e);
				var liet:LienEtage = lienEtageMapper.getComponent(e);
				var lila:LienLayer = lienLayerMapper.getComponent(e);
				
				for each (var f:IEntity in persos.members) {
					var tran:Transform = transformMapper.getComponent(f);
					var dimPerso:Dimension = dimensionMapper.getComponent(f);
					var layPerso:Layered = layeredMapper.getComponent(f);
					var lev:Level = levelMapper.getComponent(f);
					if (boolEsc[e] == null || boolEsc[e] == true) {
						if (tran.x + dimPerso.x / 2 < pos.x + dim.x && tran.x + dimPerso.x / 2 > pos.x && tran.y + dimPerso.y / 2 < pos.y + dim.y && dimPerso.y / 2 + tran.y > pos.y) {
							//trace("Dans escalier");
							boolEsc[e] = false;
							//Modificateur garantie pas de blocage
							if (ori.orientation == "Vertical") {
								tran.x = pos.x + dim.x / 2 - dimPerso.x / 2;
							} else if (ori.orientation == "Horizontal") {
								tran.y = pos.y + dim.y / 2 - dimPerso.y / 2;
							}
							
							//Changement de layer :
							entityManager.removeComponent(f, layeredMapper.gene);
							
							if (lila.down == (String)(layPerso.layerId)) {
								//trace("On monte");
								entityManager.addComponent(f, Layered, {layerId: lila.up});
							} else if (lila.up == (String)(layPerso.layerId)) {
								//trace("On dessend");
								entityManager.addComponent(f, Layered, {layerId: lila.down});
							} else {
								trace("Pas de match possible pour l'escalier");
								return;
							}
							
							//Changement d'etage actif :
							var etageDown:Grille;
							var etageUp:Grille;
							var entEtageDown:IEntity;
							var entEtageUp:IEntity;
							for each (var h:IEntity in maps.members) {
								var map:Grille = grilleMapper.getComponent(h)
								//trace("Niveau : " + map.level);
								if (liet.up == map.level) {
									etageUp = map;
									entEtageUp = h;
								}
								if (liet.down == map.level) {
									etageDown = map;
									entEtageDown = h;
								}
							}
							
							//trace("Debug : " + etageDown.level + " " + etageUp.level);
							if (etageDown.level == lev.level) {
								lev.level = etageUp.level;
								entityManager.removeComponent(entEtageDown, activeMapper.gene);
								entityManager.addComponent(entEtageUp, Active);
							} else if (etageUp.level == lev.level) {
								lev.level = etageDown.level;
								entityManager.removeComponent(entEtageUp, activeMapper.gene);
								entityManager.addComponent(entEtageDown, Active);
							} else {
								trace("Pas de match possible pour l'escalier");
								return;
							}
						}
					} else {
						if (!(tran.x + dimPerso.x / 2 < pos.x + dim.x && tran.x + dimPerso.x / 2 > pos.x && tran.y + dimPerso.y / 2 < pos.y + dim.y && dimPerso.y / 2 + tran.y > pos.y)) {
							//trace("Sortie escalier");
							boolEsc[e] = true;
						}
					}
				}
			}
		}
	}
}