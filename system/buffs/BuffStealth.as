package system.buffs{
	import system.actions.ActionBase;
	import system.effects.EffectBase;
	import system.effects.EffectData;
	
	public class BuffStealth extends BuffStats{
		//public var values:Array;
		
		public function BuffStealth(_level:int=0){
			super(BuffView.SKILL_START+35,BuffData.STEALTH,_level,BuffBase.BUFF,-1,[[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.STEALTH_CLEAR_ATTACK,0)],[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.STEALTH_CLEAR_DAMAGED,0)]]);
		}
		
		public function addPlayerStats(_o:SpriteModel){
			var _effect:EffectBase=_o.stats.findEffect(EffectData.STEALTH_CMULT);
			if (_effect!=null){
				addCMult(_effect.values);
			}
			_effect=_o.stats.findEffect(EffectData.STEALTH_DODGE);
			if (_effect!=null){
				addDodge(_effect.values);
			}
			_effect=_o.actionList.attack.findCEffect(EffectData.STEALTH_CRATE);
			if (_effect!=null){
				addCRate(_effect.values);
			}
		}
		
		public function addCRate(n:Number){
			values.push([SpriteModel.ATTACK,ActionBase.CRITRATE,n]);
		}
		
		public function addCMult(n:Number){
			values.push([SpriteModel.ATTACK,ActionBase.CRITMULT,n]);
		}
		
		public function addDodge(n:Number){
			values.push([SpriteModel.STAT,StatModel.DODGE,n]);
		}
		
		override public function modify(_v:SpriteModel,_moreMult:Number=1):BuffBase{
			//var m:BuffStats=new BuffStats(index,name,level,type,charges,values,maxStacks);
			var m:BuffStealth=new BuffStealth(level);
			m.modifyThis(_v,_moreMult);
			return m;
		}
		
		override public function modifyThis(_v:SpriteModel,_moreMult:Number=1){
			addPlayerStats(_v);
		}
		
		override public function clone():BuffBase{
			return new BuffStealth(level);
		}
		
		override public function wasAddedTo(_v:SpriteModel,_existing:BuffBase=null){
			if (_existing!=null){
				if (_existing.view!=null) _existing.view.newModel(this);
			}else{
				_v.statAdd(values);
			}
		}
		
		override public function getDesc():String{
			var m:String=name;
			m+="\nIncreased bonusses until you break stealth by (1) taking an Offensive Action or (2) getting hit by a curse or attack.";
			m+="\n"+StringData.statDesc(values,1);
			return m;
		}
		
	}
}