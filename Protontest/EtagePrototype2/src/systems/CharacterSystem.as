package systems {
	
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.resource.component.TextureResource;
	import components.Controlable;
	import components.Movable;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class CharacterSystem extends System {
		
		private var stage:Stage;
		private var characterEntities:Family;
		private var transformMapper:IComponentMapper;
		private var movableMapper:IComponentMapper;
		private var textureResourceMapper:IComponentMapper;
		private var left:Boolean;
		private var right:Boolean;
		private var up:Boolean;
		private var down:Boolean;
		
		public function CharacterSystem(stage:Stage) {
			super();
			this.stage = stage;
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			left = false;
			right = false;
			up = false;
			down = false;
		}
		
		override protected function onConstructed():void {
			super.onConstructed();
			
			transformMapper = geneManager.getComponentMapper(Transform);
			movableMapper = geneManager.getComponentMapper(Movable);
			textureResourceMapper = geneManager.getComponentMapper(TextureResource);
			
			characterEntities = entityManager.getFamily(allOfGenes(Transform, Controlable));
			characterEntities.entityAdded.add(onBonhommeAdded);
		}
		
		private function onBonhommeAdded(e:IEntity):void {
			
			var transform:Transform = transformMapper.getComponent(e);
			transform.x = 0;
			transform.y = 0;
			var movable:Movable = movableMapper.getComponent(e);
			movable.currentVelocity = 2;
		}
		
		private function keyDownHandler(event:KeyboardEvent):void {
			switch (event.keyCode) {
				case Keyboard.UP:  {
					up = true;
					break;
				}
				case Keyboard.DOWN:  {
					down = true;
					break;
				}
				case Keyboard.LEFT:  {
					left = true;
					break;
				}
				case Keyboard.RIGHT:  {
					right = true;
					break;
				}
				default: 
					break;
			}
		}
		
		private function keyUpHandler(event:KeyboardEvent):void {
			switch (event.keyCode) {
				case Keyboard.UP:  {
					up = false;
					break;
				}
				case Keyboard.DOWN:  {
					down = false;
					break;
				}
				case Keyboard.LEFT:  {
					left = false;
					break;
				}
				case Keyboard.RIGHT:  {
					right = false;
					break;
				}
				default: 
					break;
			}
		}
		
		override protected function onProcess(delta:Number):void {
			super.onProcess(delta);
			
			for (var iChar:int = 0; iChar < characterEntities.members.length; iChar++) {
				var characterEntity:IEntity = characterEntities.members[iChar];
				var transform:Transform = transformMapper.getComponent(characterEntity);
				var movable:Movable = movableMapper.getComponent(characterEntity);
				var textureResource:TextureResource = textureResourceMapper.getComponent(characterEntity);
				
				if (left) {
					if (transform.x > 0) {
						transform.x -= movable.currentVelocity;
					}
				}
				if (right) {
					if (transform.x < stage.stageWidth - textureResource.bitmapData.width) {
						transform.x += movable.currentVelocity;
					}
				}
				if (up) {
					if (transform.y > 0) {
						transform.y -= movable.currentVelocity;
					}
				}
				if (down) {
					if (transform.y < stage.stageHeight - textureResource.bitmapData.height) {
						transform.y += movable.currentVelocity;
					}
				}
			}
		}
	}
}