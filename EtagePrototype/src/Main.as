package {
	
	import com.ktm.genome.core.BigBang;
	import com.ktm.genome.core.IWorld;
	import com.ktm.genome.core.logic.process.ProcessPhase;
	import com.ktm.genome.core.logic.system.ISystemManager;
	import com.ktm.genome.render.system.RenderSystem;
	import com.ktm.genome.resource.component.EntityBundle;
	import com.ktm.genome.resource.manager.ResourceManager;
	import constants.GameState;
	import flash.display.Sprite;
	import flash.events.Event;
	import managers.LevelManager;
	import managers.TilesLoader;
	import systems.CharacterSystem;
	import systems.CollisionSystem;
	import systems.GameStateSystem;
	
	import components.TextureTile;
	
	public class Main extends Sprite {
		
		private var sdfld:TextureTile;
		
		public function Main() {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var world:IWorld = BigBang.createWorld(stage);
			var sm:ISystemManager = world.getSystemManager();
			var gss:GameStateSystem = sm.setSystem(new GameStateSystem()).setProcess(ProcessPhase.TICK) as GameStateSystem;
			
			world.setLogic(new TilesLoader());
			
			var levelManager:LevelManager = new LevelManager();
			var characterSystem:CharacterSystem = new CharacterSystem(this.stage);
			var renderSystem:RenderSystem = new RenderSystem(this);
			var collisionSystem:CollisionSystem = new CollisionSystem();
			gss.addGameStatesForSystem(levelManager, GameState.BUILDINGMAP);
			gss.addGameStatesForSystem(characterSystem, GameState.RUNNING);
			gss.addGameStatesForSystem(collisionSystem, GameState.RUNNING);
			gss.addGameStatesForSystem(renderSystem, GameState.RUNNING);
			
			sm.setSystem(ResourceManager).setProcess(ProcessPhase.TICK, int.MAX_VALUE);
			sm.setSystem(levelManager).setProcess();
			sm.setSystem(characterSystem).setProcess(ProcessPhase.FRAME);
			sm.setSystem(collisionSystem).setProcess();
			sm.setSystem(renderSystem).setProcess(ProcessPhase.FRAME);
			
			var aliasURL:String = 'xml/alias.entityBundle.xml';
			var gameURL:String = 'xml/game.entityBundle.xml';
			EntityFactory.createResourcedEntity(world.getEntityManager(), aliasURL, "alias", EntityBundle);
			EntityFactory.createResourcedEntity(world.getEntityManager(), gameURL, "game", EntityBundle);
		}
	}
}