package {
	import com.ktm.genome.core.BigBang;
	import com.ktm.genome.core.IWorld;
	import com.ktm.genome.core.logic.process.ProcessPhase;
	import com.ktm.genome.core.logic.system.ISystemManager;
	import com.ktm.genome.render.system.RenderSystem;
	import com.ktm.genome.resource.component.EntityBundle;
	import com.ktm.genome.resource.manager.ResourceManager;
	import components.Active;
	import components.Focusable;
	import components.WatchedColors;
	import constants.GameState;
	import flash.display.Sprite;
	import managers.CaseManager;
	import managers.CollisionTileManager;
	import systems.CharacterSystem;
	import systems.CollisionSystem;
	import systems.EscalierSystem;
	import systems.GameStateSystem;
	import systems.TestSystem;
	import com.ktm.genome.core.logic.process.ProcessManager;
	
	public class GenoMap extends Sprite {
		
		private var test:WatchedColors;
		private var foc:Focusable;
		private var act:Active;
		
		public function GenoMap() {
			var world:IWorld = BigBang.createWorld(stage);
			var sm:ISystemManager = world.getSystemManager();
			world.setLogic(new ProcessManager(this.stage));
			
			//Creation du gestionnaire d'états du moteur
			var gss:GameStateSystem = sm.setSystem(new GameStateSystem()).setProcess(ProcessPhase.TICK) as GameStateSystem;
			gss.setGameState(GameState.LOADING);
			
			//Appel des managers de construction de la map
			//world.setLogic(new CaseManager()); //Force les cases à se charger
			//Dans un premier temps on charge toutes les tuiles de collision (case et personnage)
			world.setLogic(new CollisionTileManager());
			//Dans un second temps on génère les étages
			
			//Systèmes indispensables
			sm.setSystem(ResourceManager).setProcess(ProcessPhase.TICK, int.MAX_VALUE);
			sm.setSystem(new RenderSystem(this)).setProcess(ProcessPhase.FRAME);
			
			var test:TestSystem = new TestSystem(this.stage);
			var characterSystem:CharacterSystem = new CharacterSystem(this.stage);
			var collisionSystem:CollisionSystem = new CollisionSystem();
			var escalierSystem:EscalierSystem = new EscalierSystem();
			
			gss.addGameStatesForSystem(test, GameState.RUNNING);
			gss.addGameStatesForSystem(characterSystem, GameState.RUNNING);
			gss.addGameStatesForSystem(collisionSystem, GameState.RUNNING);
			gss.addGameStatesForSystem(escalierSystem, GameState.RUNNING);
			
			sm.setSystem(test).setProcess(ProcessPhase.FRAME);
			sm.setSystem(characterSystem).setProcess(ProcessPhase.FRAME);
			sm.setSystem(collisionSystem).setProcess(ProcessPhase.FRAME);
			sm.setSystem(escalierSystem).setProcess(ProcessPhase.FRAME);
			
			EntityFactory.createResourcedEntity(world.getEntityManager(), 'xml/alias.entityBundle.xml', "alias", EntityBundle);
			EntityFactory.createResourcedEntity(world.getEntityManager(), 'xml/game.entityBundle.xml', "game", EntityBundle);
		}
	}
}