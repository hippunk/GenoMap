package systems 
{
	
	import com.ktm.genome.core.data.component.IComponentMapper
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform
	import com.ktm.genome.resource.component.TextureResource;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import components.TypeCase;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import components.GrilleComponent;
	import components.Level;
	/**
	 * ...
	 * @author Arthur
	 */
	public class TestSystem extends System
	{
		private var entities:Family;
		private var transformMapper:IComponentMapper;
		private var levelMapper:IComponentMapper;
		private var stage:Stage;
		private var track:int = 0;
		
		public function TestSystem(stage:Stage)	{
			this.stage = stage;
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		private function keyDownHandler(event:KeyboardEvent):void {
			switch(event.keyCode) {
				case Keyboard.ENTER : { track++; break;}
				default : break;
			}
			
			
		}
		
		override protected function onConstructed():void {
			super.onConstructed();
			entities = entityManager.getFamily(allOfGenes(Level,Transform));
			transformMapper = geneManager.getComponentMapper(Transform);
			levelMapper = geneManager.getComponentMapper(Level);
		}
		
		override protected function onProcess(delta:Number):void {
			var level:Level;
			var transform:Transform;
			//trace(entities.members.length);

			//Test changement d'etage
				var i:int = 0;
				var I:int = entities.members.length;
				
				for (i = 0; i < I; i++) {
					var b:IEntity = entities.members[i];
					level = levelMapper.getComponent(b);
					transform = transformMapper.getComponent(b);

					if (level.level == track % 3)
						transform.alpha = 1;
					else
						transform.alpha = 0.2;
				}

		}
	}

}