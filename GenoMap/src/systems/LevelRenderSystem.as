package systems {
	
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import components.Level;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import components.Active;
	import components.Grille;
	import components.Case;
	
	/**
	 * ...
	 * @author Arthur
	 */
	public class LevelRenderSystem extends System {
		private var etages:Family;
		private var etageActif:Family;
		private var transformMapper:IComponentMapper;
		private var levelMapper:IComponentMapper;
		private var grilleMapper:IComponentMapper;
		private var stage:Stage;
		private var track:int = 0;
		
		public function LevelRenderSystem(stage:Stage) {
			this.stage = stage;
		}
		
		override protected function onConstructed():void {
			super.onConstructed();
			etages = entityManager.getFamily(allOfGenes(Level, Transform,Case));
			etageActif = entityManager.getFamily(allOfGenes(Active,Grille));
			transformMapper = geneManager.getComponentMapper(Transform);
			levelMapper = geneManager.getComponentMapper(Level);
			grilleMapper = geneManager.getComponentMapper(Grille);
		}
		
		override protected function onProcess(delta:Number):void {
			var level:Level;
			var grilleActive:Grille;
			var transform:Transform;
			var numActif:int = 1;
			//trace(entities.members.length);
			//trace("nb levelActif : "+etageActif.members.length);
			if(etageActif.members.length != 0){
				var d:IEntity = etageActif.members[0];
				grilleActive = grilleMapper.getComponent(d);
				numActif = grilleActive.level;
			}
			
			var i:int = 0;
			var I:int = etages.members.length;
			
			for (i = 0; i < I; i++) {
				var b:IEntity = etages.members[i];
				transform = transformMapper.getComponent(b);
				level = levelMapper.getComponent(b);
				if (numActif == level.level) {
					transform.alpha = 1;
				}
				else{
					transform.alpha = 0.2;
				}				
			}
		}
	}

}