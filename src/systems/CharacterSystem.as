package systems {
	
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.resource.component.TextureResource;
	import components.Controlable;
	import components.GameLevel;
	import components.Movable;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class CharacterSystem extends System {
		
		private var stage:Stage;
		private var gameLevelEntities:Family;
		private var characterEntities:Family;
		private var gameLevelMapper:IComponentMapper;
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
			gameLevelMapper = geneManager.getComponentMapper(GameLevel);
			movableMapper = geneManager.getComponentMapper(Movable);
			textureResourceMapper = geneManager.getComponentMapper(TextureResource);
			
			characterEntities = entityManager.getFamily(allOfGenes(Transform, Controlable));
			gameLevelEntities = entityManager.getFamily(allOfGenes(GameLevel));
			characterEntities.entityAdded.add(onBonhommeAdded);
		}
		
		private function onBonhommeAdded(e:IEntity):void {
			var gameLevelEntity:IEntity = gameLevelEntities.members[0];
			var gameLevel:GameLevel = gameLevelMapper.getComponent(gameLevelEntity);
			var transform:Transform = transformMapper.getComponent(e);
			transform.x = Math.round(Math.random() * (gameLevel.sizeX - 1)) * gameLevel.pixelsX;
			transform.y = Math.round(Math.random() * (gameLevel.sizeY - 1)) * gameLevel.pixelsY;
			var movable:Movable = movableMapper.getComponent(e);
			movable.velocity = 2;
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
				var gameLevelEntity:IEntity = gameLevelEntities.members[0];
				var gameLevel:GameLevel = gameLevelMapper.getComponent(gameLevelEntity);
				var movable:Movable = movableMapper.getComponent(characterEntity);
				var textureResource:TextureResource = textureResourceMapper.getComponent(characterEntity);
				
				if (left) {
					if (transform.x > 0) {
						transform.x -= movable.velocity;
					}
				}
				if (right) {
					if (transform.x < stage.stageWidth - textureResource.bitmapData.width) {
						transform.x += movable.velocity;
					}
				}
				if (up) {
					if (transform.y > 0) {
						transform.y -= movable.velocity;
					}
				}
				if (down) {
					if (transform.y < stage.stageHeight - textureResource.bitmapData.height) {
						transform.y += movable.velocity;
					}
				}
			}
		}
	}
}