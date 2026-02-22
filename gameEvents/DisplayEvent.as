package gameEvents {
	
	public class DisplayEvent {
		public static const FLYING:int=0,
							ANIMATED:int=1,
							POP:int=2;
		
		var type:String;
		var identifier:String;
		var origin:*;
		var values:*;

	}
	
}
