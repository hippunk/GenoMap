package
{
	import com.ktm.genome.core.logic.system.ISystemManager;
	import com.ktm.genome.render.system.RenderSystem;
	import flash.display.Sprite;
	import com.ktm.genome.core.IWorld;
	import com.ktm.genome.core.BigBang;
	import com.ktm.genome.core.logic.system.impl.SystemManager;
	import com.ktm.genome.core.logic.process.ProcessPhase;
	import com.ktm.genome.resource.manager.ResourceManager;
	import com.ktm.genome.resource.component.EntityBundle;
	import managers.GrilleManager;
	import systems.DragDropSystem;
	
	/**
	 * ...
	 * @author Arthur
	 */
	public class Decor extends Sprite 
	{
		
		public function Decor() 
		{
			var world:IWorld = BigBang.createWorld(stage);
			var sm:ISystemManager = world.getSystemManager();
			world.setLogic(new GrilleManager());
			
			sm.setSystem(ResourceManager).setProcess(ProcessPhase.TICK, int.MAX_VALUE);
			sm.setSystem(new RenderSystem(this)).setProcess(ProcessPhase.FRAME);
			sm.setSystem(new DragDropSystem(this.stage)).setProcess(ProcessPhase.FRAME);
			
			var aliasURL:String = 'xml/alias.entityBundle.xml'
			var gameURL:String = 'xml/game.entityBundle.xml'
			
			EntityFactory.createResourcedEntity(world.getEntityManager(), aliasURL, "alias", EntityBundle);
			EntityFactory.createResourcedEntity(world.getEntityManager(), gameURL, "game", EntityBundle);
		}
		
	}
	
}