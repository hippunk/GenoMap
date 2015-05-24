package
{
	import com.ktm.genome.core.logic.system.ISystemManager;
	import com.ktm.genome.render.system.RenderSystem;
	import components.TypeCase;
	import flash.display.Sprite;
	import com.ktm.genome.core.IWorld;
	import com.ktm.genome.core.BigBang;
	import com.ktm.genome.core.logic.system.impl.SystemManager;
	import com.ktm.genome.core.logic.process.ProcessPhase;
	import com.ktm.genome.resource.manager.ResourceManager;
	import com.ktm.genome.resource.component.EntityBundle;
	import flash.events.Event;
	import managers.GrilleManager;
	import systems.TestSystem;
	import managers.TypeManager;
	import constants.GameState;
	import systems.CharacterSystem;
	import systems.CollisionSystem;
	import systems.GameStateSystem;	
	/**
	 * ...
	 * @author Arthur
	 */
	public class EtagePrototype extends Sprite 
	{
		private var typeCase:TypeCase;
		
		public function EtagePrototype() 
		{
			var world:IWorld = BigBang.createWorld(stage);
			var sm:ISystemManager = world.getSystemManager();
			
			//Creation du gestionnaire d'états du moteur
			var gss:GameStateSystem = sm.setSystem(new GameStateSystem()).setProcess(ProcessPhase.TICK) as GameStateSystem;
			gss.setGameState(GameState.LOADING);
			
			//Appel des managers de construction de la map
				//Dans un premier temps on charge les types de case
					world.setLogic(new TypeManager());

			
			//Systèmes indispensables
			sm.setSystem(ResourceManager).setProcess(ProcessPhase.TICK, int.MAX_VALUE);
			sm.setSystem(new RenderSystem(this)).setProcess(ProcessPhase.FRAME);
			

			
			var test:TestSystem = new TestSystem(this.stage);			
			var characterSystem:CharacterSystem = new CharacterSystem(this.stage);			
			//var collisionSystem:CollisionSystem = new CollisionSystem(this.stage);
			
			gss.addGameStatesForSystem(test, GameState.RUNNING);
			gss.addGameStatesForSystem(characterSystem, GameState.RUNNING);
			//gss.addGameStatesForSystem(collisionSystem, GameState.RUNNING);

			
			sm.setSystem(test).setProcess(ProcessPhase.FRAME);
			sm.setSystem(characterSystem).setProcess(ProcessPhase.FRAME);
			//sm.setSystem(collisionSystem).setProcess();
			
			var aliasURL:String = 'xml/alias.entityBundle.xml';
			var gameURL:String = 'xml/game.entityBundle.xml';
			
			EntityFactory.createResourcedEntity(world.getEntityManager(), aliasURL, "alias", EntityBundle);
			EntityFactory.createResourcedEntity(world.getEntityManager(), gameURL, "game", EntityBundle);
		}
	}
}