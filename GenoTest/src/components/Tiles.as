package components {
	
	import com.ktm.genome.core.data.component.Component;
	import flash.display.BitmapData;
	
	public class Tiles extends Component {
		public var tileId:Vector.<String>;
		public var textureTilePath:String;
		public var collisionTilePath:String;
		public var textureTileName:Vector.<String>;
		public var collisionTileName:Vector.<String>;
		public var textureTile:Vector.<BitmapData> = new Vector.<BitmapData>();
		public var collisionTile:Vector.<BitmapData> = new Vector.<BitmapData>();
	}
}