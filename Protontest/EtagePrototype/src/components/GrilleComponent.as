package components 
{
	import com.ktm.genome.core.data.component.Component;
	/**
	 * ...
	 * @author Arthur
	 */
	
	public class GrilleComponent extends Component
	{
		public var tailleX:int = 30;
		public var tailleY:int = 30;
		public var startX:int = 0;
		public var startY:int = 0;
		public var level:int = 0;
		public var pixels:int = 32;
		public var grille:Vector.<Vector.<String>>;
		
	}

}