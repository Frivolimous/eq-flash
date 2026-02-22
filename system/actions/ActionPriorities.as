package system.actions {
	import items.ItemData;
	
	public class ActionPriorities {
							
		public static const ALL_DISTANCE:int=0,
							COMBAT:int=1,
							BETWEEN:int=2,
							NEAR:int=3,
							FAR:int=4,
							VERY:int=5,
							
							NEVER:int=6,
							EQUIP:int=7,
							NONE:int=8;
							
							
							
		public static const PRIORITIES_DEFAULT:Array=[/*ALL_TYPE,MINION,BOSS*/];
		
		public static const PRIORITIES_HEALING:Array=[/*PERCENT_100,PERCENT_75,PERCENT_50,PERCENT_25,PERCENT_10*/],
							PRIORITIES_BUFF:Array=[],
							PRIORITIES_THROW:Array=[];
							
		
		public static function getListName(i:int):String{
			switch(i){
				/*case BOSS: return "Boss";
				case MINION: return "Mobs";
				case ALL_TYPE: return "All";*/
				
				case ALL_DISTANCE: return "All";
				case COMBAT: return "Fight";
				case BETWEEN: return "Safe";
				case NEAR: return "Near";
				case FAR: return "Mid";
				
				case NEVER: return "Never";
				case EQUIP: return "Equip";
				case VERY: return "Far";
				case NONE: return "";
				
				/*case PERCENT_100: return "<100%";
				case PERCENT_75: return "<75%";
				case PERCENT_50: return "<50%";
				case PERCENT_25: return "<25%";
				case PERCENT_10: return "<10%";*/
			}
			return "";
		}
		
		public static function getTooltipName(i:int):String{
			switch (i){
				/*case BOSS: return "Boss Only";
				case MINION: return "Minions Only";
				case ALL_TYPE: return "All Creature Types";*/
				
				case ALL_DISTANCE: return "Any Distance";
				case COMBAT: return "Fight: Near or Far";
				case BETWEEN: return "Safe Only";
				case NEAR: return "Near Range Only";
				case FAR: return "Mid Range Only";
				case VERY: return "Far Range Only";
				
				case NEVER: return "Never";
				case EQUIP: return "Equippable";
				case NONE: return "";
				
				/*case PERCENT_100: return "Less than 100%";
				case PERCENT_75: return "Less than 75%";
				case PERCENT_50: return "Less than 50%";
				case PERCENT_25: return "Less than 25%";
				case PERCENT_10: return "Less than 10%";*/
			}
			
			return "";
		}
		
		public static function getTooltipDesc(i:int):String{
			switch(i){
				/*case BOSS: return "Only use this action when facing a Level Boss or Arena Opponent.";
				case MINION: return "Only use this action against regular minions and not Bosses or Arena Opponents.";
				case ALL_TYPE: return "Use this action against any creature type.";*/
				
				case ALL_DISTANCE: return "Use this action at any distance.";
				case COMBAT: return "Use this action at Near or Far distance in Combat.";
				case BETWEEN: return "Only use this action when you are Safe (between fights)";
				case NEAR: return "Only use this action when adjacent to your target.";
				case FAR: return "Only use this action when you are away from your target.";
				case VERY: return "Only use this action when you are far from your target.";
				
				case NEVER: return "Never use this action.";
				case EQUIP: return "This item does not have an associated action.";
				case NONE: return "";
				
				/*case PERCENT_100: return "Only use this action when you are at less than 100%.";
				case PERCENT_75: return "Only use this action when you are at less than 75%.";
				case PERCENT_50: return "Only use this action when you are at less than 50%.";
				case PERCENT_25: return "Only use this action when you are at less than 25%.";
				case PERCENT_10: return "Only use this action when you are at less than 10%.";*/
			}
			
			return "";
		}
		
		public static function getColor(i:int):uint{
			switch (i){
				case ALL_DISTANCE: return 0x003333;
				case COMBAT: return 0x993300;
				case NEAR: return 0x2B324D;
				case VERY: case FAR: return 0x5D1185;
				case BETWEEN: return 0x224422;
				
				/*case PERCENT_100: case ALL_DISTANCE: case ALL_TYPE: return 0x003333;
				
				case MINION: case PERCENT_50: case COMBAT: return 0x993300;
				case PERCENT_10: case NEAR: return 0x2B324D;
				case BOSS: case PERCENT_25: case FAR: return 0x5D1185;
				case PERCENT_75: case BETWEEN: return 0x224422;
				
				case EQUIP: case NEVER: case NONE: return 0xC0AA52;*/
			}
			
			return 0xC0AA52;
		}
		
		public static function isLightColor(i:int):Boolean{
			switch(i){
				case EQUIP: case NEVER: case NONE:
					return true;
					
				default:
					return false;
				
			}
			
			return true;
		}
		
		public static function getPriorityList(i:int):Array{
			switch(i){
				case ALL_DISTANCE:
					return [ALL_DISTANCE,BETWEEN,COMBAT,FAR,NEAR,NEVER];
					break;
				case COMBAT:
					return [COMBAT,FAR,NEAR,NEVER];
					break;
				case FAR:
					return [FAR,NEVER];
					break;
				case NEAR:
					return [NEAR,NEVER];
					break;
				case BETWEEN:
					return [BETWEEN,NEVER];
					break;
				case VERY:
					return [VERY,NEVER];
					break;
				default:
					return [];
			}
		}
		
		public static function getPriorities(i:int,_longRanged:Boolean):Array{
			var m:Array;
			switch (i){
				case ALL_DISTANCE: m=[GameModel.NEAR,GameModel.FAR,GameModel.BETWEEN]; if (_longRanged) m.push(GameModel.VERY); return m;
				case COMBAT: m=[GameModel.NEAR,GameModel.FAR]; if (_longRanged) m.push(GameModel.VERY); return m;
				case FAR: m=[GameModel.FAR]; if (_longRanged) m.push(GameModel.VERY); return m;
				case VERY: m=[GameModel.VERY]; return m;
				case NEAR: return [GameModel.NEAR];
				case BETWEEN: return [GameModel.BETWEEN];
				case NEVER: return [];
				case EQUIP: case NONE: return [];
				
				default: return [];
			}
		}
		
		public static function exclusive(i:int):Array{
			switch (i){
				/*case BOSS:
				case MINION:
				case ALL_TYPE:
					return [ALL_TYPE,BOSS,MINION];
				
				case PERCENT_100: case PERCENT_75: case PERCENT_50: case PERCENT_25: case PERCENT_10:
					return [PERCENT_100,PERCENT_75,PERCENT_50,PERCENT_25,PERCENT_10];*/
			}
			
			return null;
		}
		
		public static function getListTitle(i:int):String{
			switch (i){
				/*case BOSS:
				case MINION:
				case ALL_TYPE:
					return "Rank";
				
				case PERCENT_100: case PERCENT_75: case PERCENT_50: case PERCENT_25: case PERCENT_10:
					return "Health";*/
			}
			
			return null;
		}
	}
	
}
