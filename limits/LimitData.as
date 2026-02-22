package limits{
	import system.buffs.BuffData;
	
	public class LimitData{
		public static function spawnLimit(_index:int,_charges:int=-1):LimitModel{
			var s:String;
			switch (_index){
				case 0: s="Super Attack"; break;
				case 1: s="Super Crit"; break;
				case 2: s="Super Find"; break;
				case 3: s="Super Craft"; break;
				case 4: s="Super Cleanse"; break;
				case 5: s="Super Defend"; break;
				case 6: s="Super Heal"; break;
				case 7: s="Super Curse"; break;
				default: return null;
			}
			return new LimitModel(_index,s,_charges>-1?_charges:0);
		}
		
		
		
		public static function levelFromCharges(i:int):int{
			if (i>=50) return 3;
			if (i>=15) return 2;
			if (i>=5) return 1;
			return 0;
		}
		
		public static function levelRemainder(i:int):Number{
			if (i>=50) return 0;
			if (i>=15) return (i-15)/35;
			if (i>=5) return (i-5)/10;
			return i/5;
		}
		
		public static function useLimit(_o:SpriteModel,_limit:LimitModel){
			if (levelFromCharges(_limit.charges)>0){
				switch(_limit.index){
					case 0: default: _o.buffList.addBuff(BuffData.makeBuff(BuffData.ENCHANTED,levelFromCharges(_limit.charges)));
				}
				_limit.charges=0;
			}
		}
	}
}