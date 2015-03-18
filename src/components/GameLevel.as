package components {
	
	import com.ktm.genome.core.data.component.Component;
	
	public class GameLevel extends Component {
		public var sizeX:int;
		public var sizeY:int;
		public var pixelsX:int;
		public var pixelsY:int;
		public var grid:Vector.<Vector.<int>>;
	}
}