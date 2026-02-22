package system.effects{
	import system.actions.ActionBase;
	import system.actions.ActionData;
	import system.actions.ActionWithdraw;
	import system.actions.ActionSpellCursing;
	import system.buffs.BuffBase;
	import system.buffs.BuffDelayedDmg;
	import system.buffs.BuffStealth;
	import system.buffs.BuffData;
	import ui.effects.PopEffect;
	import ui.effects.AnimatedEffect;
	import ui.effects.FlyingText;
	import items.ItemData;
	import items.ItemModel;
	
	public class EffectDmgBoost extends EffectBase{
		public static const HAS_CURSE:int=0,
							HAS_BUFF:int=1,
							NUM_CURSE:int=2,
							NUM_BUFF:int=3,
							RANDOMIZED:int=4,
							DISTANCE:int=5,
							HEALTH_PERCENT:int=6,
							FLAT:int=7;
		
		var boostType:int;
		var boostAmount:Number;
		public var extra:*;
		
		public function EffectDmgBoost(_name:String=null,_level:int=0,_boostType:int=-1,_boostAmount:Number=0,_userate:Number=1,_extra:*=null){
			name=_name;
			level=_level;
			boostType=_boostType;
			boostAmount=_boostAmount;
			userate=_userate;
			extra=_extra;
			
			type=EffectBase.INSTANT;
			trigger=EffectBase.HURT;
		}
		
		override public function modify(_v:SpriteModel,_action:ActionBase=null):EffectBase{
			var m:EffectDmgBoost=(clone() as EffectDmgBoost);
			m.modifyThis(_v,_action);
			return m;
		}
		
		override public function clone():EffectBase{
			return new EffectDmgBoost(name,level,boostType,boostAmount,userate,extra);
		}
		
		override public function applyEffect(_o:SpriteModel,_t:SpriteModel,_action:ActionBase,_dmgModel:DamageModel){
			switch(boostType){
				case RANDOMIZED:
					_dmgModel.addMult(0-boostAmount+GameModel.random()*boostAmount*2);
					break;
				case HAS_CURSE:
					if (_t.buffList.hasBuff(extra)){
						_dmgModel.addMult(boostAmount);
					}
					break;
				case HAS_BUFF:
					if (_o.buffList.hasBuff(extra)){
						_dmgModel.addMult(boostAmount);
					}
					break;
				case DISTANCE:
					if (_o.eDistance==extra) _dmgModel.addMult(boostAmount);
					break;
				case NUM_CURSE:
					var _boost:int=_t.buffList.countBuffs(BuffBase.CURSE,true);
					_dmgModel.addMult(boostAmount*_boost);
					//_dmgModel.addMult(dim(boostAmount,_boost));
					break;
				case NUM_BUFF:
					_boost=_o.buffList.countBuffs(BuffBase.BUFF,false);
					_dmgModel.addMult(boostAmount*_boost);
					//_dmgModel.addMult(dim(boostAmount,_boost));
					break;
				case HEALTH_PERCENT:
					_dmgModel.addMult(_t.healthPercent()*boostAmount);
					break;
				case FLAT:
					_dmgModel.addMult(boostAmount);
					break;
			}
		}
		
		override public function getDesc(_tabs:int=1):String{
			var m:String="";
			if (userate<1){
				m+="<font color="+StringData.RED+"><b>"+StringData.reduce(userate*100)+"%</b></font> ";
			}
			if (boostType==HEALTH_PERCENT){
				m="Deal up to <font color="+StringData.RED+"><b>+"+String(Math.round(boostAmount*100))+"%</b></font> damage when enemy is at full health.";
			}else{
				m+=name;
				if (boostType==HAS_CURSE){
					m+=" "+extra;
				}
				m+=" <font color="+StringData.RED+"><b>+"+String(Math.round(boostAmount*100))+"%</b></font>";
			}
						
			if (m.length>0){
				m=StringData.tabs(_tabs)+m;
			}
			return m;
		}
		
		override public function getSpecialDesc(_descType:int=-1):String{
			var m:String="";
			
			m+=getTriggerText(_descType);
			
			var n:String;
			n="Increased Direct Damage ";
			switch(boostType){
				case RANDOMIZED: n+="by up to this amount."; break;
				case HEALTH_PERCENT: n+="based on target's current health."; break;
				case NUM_CURSE: n+="for every Debuff or Debuff Stack applied to your target."; break;//  Reduced effect for every stack beyond the first. (%increase*#buffs*25 / (#buffs+24)"; break;
				case NUM_BUFF: n+="for every unique Buff applied to you."; break//  Reduced effect for every buff beyond the first. (%increase*#buffs*25 / (#buffs+24)"; break;
				case HAS_CURSE: n+="if enemy is "+extra+"."; break;
				case HAS_BUFF: n+="if you are "+extra+"."; break;
				case DISTANCE: n+="at "+extra+" range."; break;
				case FLAT: n+="by this amount."; break;
			}
			
			if (m.length==0){
				m+=n.charAt(0).toUpperCase();
				m+=n.substr(1);
			}else{
				m+=n.charAt(0).toLowerCase();
				m+=n.substr(1);
			}
			return m;
		}
		
		const DIMINISHMENT:Number=25;
		function dim(_boost:Number,_stacks:int){
			return _boost*DIMINISHMENT*_stacks/(DIMINISHMENT+_stacks-1);
		}
	}
}