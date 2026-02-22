package gameEvents {
	import system.buffs.BuffBase;
	
	public class BuffEvent {
		public static const ADDED:int=0,
							REMOVED:int=1,
							UPDATE:int=2;
		
		var type:String;
		var identifier:String;
		var origin:SpriteModel;
		var buff:BuffBase;
		
		public function BuffEvent(_type:String,_origin:SpriteModel,_buff:BuffBase){
			type=_type;
			origin=_origin;
			buff=_buff;
		}
	}
	
}
