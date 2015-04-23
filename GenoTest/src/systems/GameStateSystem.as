package systems {
	
	import com.ktm.genome.core.logic.system.System;
	import constants.GameState;
	
	/**
	 * ...
	 * @author clement rouanet
	 */
	public class GameStateSystem extends System {
		private var gameState:String = GameState.LOADING;
		private var gameStateBySystem:Object;
		private var systemBySystem:Object;
		
		public function GameStateSystem():void {
			gameStateBySystem = new Object();
			systemBySystem = new Object();
		}
		
		override protected function onProcess(delta:Number):void {
			super.onProcess(delta);
			for (var obj:Object in gameStateBySystem) {
				var run:Boolean = false;
				if (!gameStateBySystem[obj])
					continue;
				for each (var gameState:String in gameStateBySystem[obj]) {
					if (gameState == this.gameState) {
						run = true;
						break;
					}
				}
				var system:System = systemBySystem[obj];
				if (run)
					system.resume();
				else
					system.pause();
			}
		}
		
		public function setGameState(gameState:String):void {
			this.gameState = gameState;
		}
		
		public function getGameState():String {
			return this.gameState;
		}
		
		public function addGameStatesForSystem(system:System, ... args):void {
			for each (var gameState:String in args) {
				addSystemToGameState(system, gameState);
			}
		}
		
		private function addSystemToGameState(system:System, gameState:String):void {
			systemBySystem[system] = system;
			if (!gameStateBySystem[system])
				gameStateBySystem[system] = new Vector.<String>;
			gameStateBySystem[system].push(gameState);
		}
	}
}