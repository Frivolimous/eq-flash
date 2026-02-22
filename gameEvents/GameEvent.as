package gameEvents {
	
	public class GameEvent {
		public static const ENCOUNTER_BOSS:int=0,
							KILL_BOSS:int=1,
							PLAYER_HEALTH:int=2,
							KILL_SHADOW:int=3,
							MEET_SHADOW:int=4,
							INVENTORY_FULL:int=5,
							AREA_REACHED:int=6,
							CHALLENGE_DEFEATED:int=7,
							ASCEND:int=8,
							LEVEL_UP:int=9,
							PLAYER_TURN:int=10,
							COVER_ITEM:int=11,
							HARDCORE_CHALLENGE_DEFEATED:int=12,
							EPIC_AREA_REACHED:int=13,
							CHALLENGE_AREA_REACHED:int=14;
		
		public var type:int;
		public var identifier:String;
		public var origin:*;
		public var values:*;
		
		public function GameEvent(_type:int,_values:*){
			type=_type;
			values=_values;
		}

	}
	
}
