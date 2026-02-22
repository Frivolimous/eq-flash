package system.buffs{
	import flash.filters.ColorMatrixFilter;
	
	public class BuffBase{
		public static const BUFF:int=0,
							CURSE:int=1,
							DISPLAY:int=2;
		
		public var index:int;
		public var name:String;
		public var level:int;
		public var type:int;
		public var maxStacks:int=1;
		public var filter:ColorMatrixFilter;
		var _Charges:int;
		
		public var view:BuffView;
		public var stacks:int=0;
		
		/*public function BuffBase(_index:int,_name:String,_level:int,_type:String,_charges:int,_maxStacks:int=1){
			name=_name;
			index=_index;
			level=_level;
			type=_type;
			_Charges=_charges;
			maxStacks=_maxStacks;
		}*/
		
		public function set charges(_charges:int){
			_Charges=_charges;
			if (view!=null && view.counter!=null) view.counter.text=String(_charges);
		}
		
		public function get charges():int{
			return _Charges;
		}
		
		public function modify(_v:SpriteModel,_moreMult:Number=1):BuffBase{
			var m:BuffBase=new BuffBase();
			return m;
		}
		
		public function modifyThis(_v:SpriteModel,_moreMult:Number=1){
			if (type==BUFF){
				charges=Math.floor(charges*_v.stats.getValue(StatModel.BUFFMULT));
			}else if (type==CURSE){
				if (name!=BuffData.STUNNED){
					charges=Math.floor(charges*_v.stats.getValue(StatModel.CURSEMULT));
				}
			}
			stacks=1;
		}
		
		public function clone():BuffBase{
			return new BuffBase();
		}
		
		public function addStacksFrom(_removed:BuffBase){
			stacks+=_removed.stacks;
			if (stacks>maxStacks) stacks=maxStacks;
			if (view!=null){
				view.upgrade((stacks-1)/(maxStacks-1));
			}
		}
		
		public function wasAddedTo(_v:SpriteModel,_existing:BuffBase=null){
			if (_existing!=null){
				if (_existing.view!=null) _existing.view.newModel(this);
				if (maxStacks>1){
					addStacksFrom(_existing);
				}
			}
		}
		
		public function wasRemovedFrom(_v:SpriteModel){
			
		}
		
		public function update(_v:SpriteModel,_dmg:DamageModel){
			if (charges>0) charges-=1;
			
			graphicUpdateBuff(_v);
		}
		
		public function graphicUpdateBuff(_v:SpriteModel){
			//Facade.soundC.buffUpdate(_obj);
		}
		
		public function getDesc():String{
			return name;
		}
		
		public function getTooltipDesc():String{
			return "";
		}
		
		public function getEffectDesc():String{
			return getSpecialDesc();
		}
		
		public function getSpecialDesc():String{
			switch(name){
				case BuffData.MASSIVE_BLOW_OFF: return "When you reach max stacks, deal increased damage.";
				case BuffData.UNDYING: 
				case BuffData.DYING: return "Can survive below 0 health for a number of turns.";
				case BuffData.REVIVED: return "You have already revived this fight and cannot revive again.";
				
				case BuffData.TOWN: return "You will go to town after this battle.";
				case BuffData.XP_BOOST: return "Gain extra Experience and Gold.";
				case BuffData.PROGRESS_BOOST: return "Every monster kill counts as two for Level Progress, XP and Loot.  Multiplies with XP Boosts!  Gained from Offline Hours.";
				
				default: return null;
			}
		}
	}
}