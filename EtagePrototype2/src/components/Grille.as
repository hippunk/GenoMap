package components {
	import com.ktm.genome.core.data.component.Component;
	
	public class Grille extends Component {
		public var tailleX:int;
		public var tailleY:int;
		public var startX:int;
		public var startY:int;
		public var level:int;
		public var pixels:int;
		public var grille:Vector.<Vector.<String>>;
	}
}