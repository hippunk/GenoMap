package components {
	
	import com.ktm.genome.core.data.component.Component;
	import flash.display.BitmapData;
	
	public class GameLevel extends Component {
		public var posX:int;
		public var posY:int;
		public var sizeX:int;
		public var sizeY:int;
		public var pixelsX:int;
		public var pixelsY:int;
		public var grid:Vector.<Vector.<int>>;
		public var collisionMap:BitmapData;
	}
}