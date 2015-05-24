package systems {
	
	import com.ktm.genome.core.data.component.IComponentMapper;
	import com.ktm.genome.core.entity.family.Family;
	import com.ktm.genome.core.entity.family.matcher.allOfGenes;
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.core.logic.system.System;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.resource.component.TextureResource;
	import components.CollisionMap;
	import components.CollisionTile;
	import components.Controlable;
	import components.Grille;
	import components.Movable;
	import components.WatchedColors;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import components.Active;
	
	public class CharacterSystem extends System {
		
		private var stage:Stage;
		private var etage:Family;
		private var characterEntities:Family;
		private var transformMapper:IComponentMapper;
		private var movableMapper:IComponentMapper;
		private var textureResourceMapper:IComponentMapper;
		private var collisionTileMapper:IComponentMapper;
		private var watchedColorsMapper:IComponentMapper;
		private var collisionMapMapper:IComponentMapper;
		private var grilleMapper:IComponentMapper;
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
			collisionTileMapper = geneManager.getComponentMapper(CollisionTile);
			watchedColorsMapper = geneManager.getComponentMapper(WatchedColors);
			collisionMapMapper = geneManager.getComponentMapper(CollisionMap);
			grilleMapper = geneManager.getComponentMapper(Grille);
			
			etage = entityManager.getFamily(allOfGenes(CollisionMap, Grille,Active));
			characterEntities = entityManager.getFamily(allOfGenes(Transform, Controlable, Movable, WatchedColors));
			characterEntities.entityAdded.add(onBonhommeAdded);
		}
		
		private function onBonhommeAdded(e:IEntity):void {
			var movable:Movable = movableMapper.getComponent(e);
			movable.currentVelocity = movable.normalVelocity;
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
			
			for each (var characterEntity:IEntity in characterEntities.members) {
				//for (var iChar:int = 0; iChar < characterEntities.members.length; iChar++) {
				//	var characterEntity:IEntity = characterEntities.members[iChar];
				var transform:Transform = transformMapper.getComponent(characterEntity);
				var movable:Movable = movableMapper.getComponent(characterEntity);
				var watchedColors:WatchedColors = watchedColorsMapper.getComponent(characterEntity);
				var textureResource:TextureResource = textureResourceMapper.getComponent(characterEntity);
				var collisionTile:CollisionTile = collisionTileMapper.getComponent(characterEntity);
				
// ne gère qu'un seul étage en dur dans le code
				var grille:Grille = grilleMapper.getComponent(etage.members[0]);
				
				var x:int = transform.x;
				var y:int = transform.y;
				
				if (left && !up && !down) {
					x -= movable.currentVelocity;
				}
				if (right && !up && !down) {
					x += movable.currentVelocity;
				}
				if (up && !right && !left) {
					y -= movable.currentVelocity;
				}
				if (down && !right && !left) {
					y += movable.currentVelocity;
				}
				if (up && right) {
					y -= movable.currentVelocity;
					x += movable.currentVelocity;
				}
				if (up && left) {
					y -= movable.currentVelocity;
					x -= movable.currentVelocity;
				}
				if (down && right) {
					y += movable.currentVelocity;
					x += movable.currentVelocity;
				}
				if (down && left) {
					y += movable.currentVelocity;
					x -= movable.currentVelocity;
				}
				
				if (!inWall(collisionTile, x, y, etage.members[0], movable.normalVelocity, watchedColors)) {
					transform.x = x;
					transform.y = y;
				}
			}
		}
		
		public function inWall(collisionTile:CollisionTile, x:int, y:int, grilleEntity:IEntity, normalVelocity:int, watchedColors:WatchedColors):Boolean {
			var grille:Grille = grilleMapper.getComponent(grilleEntity);
			var collisionMap:CollisionMap = collisionMapMapper.getComponent(grilleEntity);
			var w:int = collisionTile.bitmapData.width;
			var h:int = collisionTile.bitmapData.height;
			var i:int = w * h;
			var col:int;
			var velocity:Array = new Array();
			
			// pour tous les pixels de la collision tile
			while (i--) {
				// si c'est un pixel noir
				if (collisionTile.bitmapData.getPixel(i % w, int(i / w)) == int(0x000000)) {
					// on récupère la couleur du pixel de la carte de collision correspondant à la position du pixel noir considéré
					var color:int = collisionMap.bitmapData.getPixel(x + i % w - grille.startX, y + int(i / w) - grille.startY);
					// si la couleur est une couleur à regarder, on ajoute la modification de vitesse dans le tableau velocity
					for (var idx:int = 0; idx < watchedColors.colors.length; idx++) {
						if (color == watchedColors.colors[idx]) {
							velocity.push(watchedColors.effects[idx]);
						}
					}
				}
			}
			// si le malus de vitesse est égal à la vitesse normal de Movable, alors on est dans un mur
			return Math.min.apply(null, velocity) == -normalVelocity;
		}
	}
}