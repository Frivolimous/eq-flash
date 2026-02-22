package system.buffs{
	
	public class BuffDisplay extends BuffBase{		
		public function BuffDisplay(_index:int,_name:String,_level:int,_charges:int,_maxStacks:int=1){
			name=_name;
			index=_index;
			level=_level;
			type=BuffBase.DISPLAY;
			_Charges=_charges;
			maxStacks=_maxStacks;
		}
		
		override public function modify(_v:SpriteModel,_moreMult:Number=1):BuffBase{
			var m:BuffDisplay=clone() as BuffDisplay;
			m.stacks=1;
			return m;
		}
		
		override public function clone():BuffBase{
			return new BuffDisplay(index,name,level,charges,maxStacks);
		}
	}
}