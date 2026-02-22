package system.effects{
	import system.actions.ActionBase;
	import system.actions.ActionData;
	import system.buffs.BuffBase;
	import system.buffs.BuffData;
	import system.buffs.BuffDOT;
	import system.buffs.BuffDelayedDmg;
	import items.FilterData;
	import system.buffs.BuffShield;
	import flash.filters.ColorMatrixFilter;
	
	public class EffectBuff extends EffectBase{							
		public var buff:BuffBase;
		
		public function EffectBuff(_label:String=null,_level:int=0,_type:int=0,_trigger:int=0,_userate:Number=1,_buff:BuffBase=null){
			if (_label!=null){
				name=_label;
				level=_level;
				type=_type;
				trigger=_trigger;
				userate=_userate;
				buff=_buff;
			}
		}
		
		override public function modify(_v:SpriteModel,_action:ActionBase=null):EffectBase{
			var m:EffectBuff=new EffectBuff(name,level,type,trigger,userate,buff);
			m.modifyThis(_v,_action);
			return m;
		}
		
		override public function modifyThis(_v:SpriteModel,_action:ActionBase=null){
			var _mult:Number=1;
			if (_action!=null && _action.isConsumable()) _mult*=_v.stats.getValue(StatModel.ITEMEFF);
			buff=buff.modify(_v,_mult);
			if (_action!=null && _action.source!=null){
				buff.filter=items.FilterData.getPremiumFilter(_action.source.index,_action.source.enchantIndex);
			}
				
			//buff.modifyThis(_v,_mult);
		}
		
		override public function clone():EffectBase{
			return new EffectBuff(name,level,type,trigger,userate,buff.clone());
		}
		
		override public function applyEffect(_o:SpriteModel,_t:SpriteModel,_action:ActionBase,_dmgModel:DamageModel){
			if (name==EffectData.DREAM){
				if (_t!=null){
					if (_action.label!=ActionData.WALK && _action.label!=ActionData.APPROACH && 
						_action.label!=ActionData.WITHDRAW && _action.label!=ActionData.ATTACK){
							_t.buffList.addBuff(buff);
					}
				}
			}else if (name==EffectData.MOVE_BOOST){
				if (_action.label==ActionData.WALK || _action.label==ActionData.APPROACH || 
						_action.label==ActionData.WITHDRAW || _action.label==ActionData.ATTACK){
						_o.buffList.addBuff(buff);
				}
			/*}else if (name==EffectData.INITIAL_NO_OFFENSIVE){
				_o.buffList.addBuff(buff.clone());
				_t.buffList.addBuff(buff);
				*/
			}else if (type==EffectBase.BUFF){
				if (name==EffectData.CRIT_ACCUM){
					if (_action.crit){
						_dmgModel.oBuffs.push(BuffData.CRIT_ACCUM);
					}else{
						_dmgModel.oBuffs.push(buff);
					}
				}else if (buff.name==BuffData.COOLDOWN){
					if (!_o.buffList.hasBuff(BuffData.COOLDOWN)){
						_dmgModel.oBuffs.push(buff);
					}
				}else if (name==EffectData.BUILD_WALL){
					(buff as BuffShield).shield*=_action.dmgModel.total();
					_dmgModel.oBuffs.push(buff);
				}else if (name==EffectData.MASSIVE_BLOW){
					if (!_o.buffList.hasBuff(BuffData.MASSIVE_BLOW_PROC)){
						var _buff:BuffBase=_o.buffList.getBuffCalled(BuffData.MASSIVE_BLOW_OFF);
						if (_buff!=null && _buff.stacks>=_buff.maxStacks-1){
							_dmgModel.oBuffs.push(BuffData.MASSIVE_BLOW_OFF);
							_dmgModel.oBuffs.push(buff);
							buff.addStacksFrom(_buff);
							buff.filter=new ColorMatrixFilter([1,1,1,0,0,
															   1,1,1,0,0,
															   0,0,0,0,0,
															   0,0,0,1,0]);
							//buff.stacks=buff.maxStacks;
						}else{
							_dmgModel.oBuffs.push(BuffData.makeBuff(BuffData.MASSIVE_BLOW_OFF,buff.level).modify(_o));
						}
					}
				}else{
					if (buff.index==-1){
						_o.buffList.addBuff(buff);
					}else{
						_dmgModel.oBuffs.push(buff);
					}
					switch(name){
						case EffectData.QUICK:
							if (_o.strike==0){
								_dmgModel.numQuicks+=1;
							}
							break;
						default: null;
					}
				}
			}else if (type==EffectBase.CURSE){
				if (buff.name==BuffData.BLEEDING){
					(buff as BuffDOT).damage*=_dmgModel.getDmg(_action.type)*_dmgModel.totalMult;
					if (_action.type!=ActionBase.PHYSICAL){
						(buff as BuffDOT).damageType=_action.type;
					}
				}else if (buff.name==BuffData.DELAYED_DAMAGE){
					(buff as BuffDelayedDmg).damage*=_dmgModel.getDmg(_action.type)*_dmgModel.totalMult;
					if ((buff as BuffDelayedDmg).damageType==ActionBase.PHYSICAL && _action.type!=ActionBase.PHYSICAL){
						(buff as BuffDelayedDmg).damageType=_action.type;
					}
				}else if (buff.name==BuffData.PHOENIX_THORNS){
					if (_o.eDistance!=GameModel.NEAR) return;
				}
				
				if (name==EffectData.DISORIENT){
					if (_action.isConsumable()){
						_dmgModel.tBuffs.push(buff);
					}
				}else{
					_dmgModel.tBuffs.push(buff);
				}
			}
		}
		
		override public function getDesc(_tabs:int=1):String{
			var m:String="";
			if (userate<1){
				m+="<font color="+StringData.RED+"><b>"+StringData.reduce(userate*100)+"%</b></font> ";
			}
			
			if (name==EffectData.REVIVE_GOKU){
				m=BuffData.makeBuff(BuffData.SAYAN,level).getDesc()+"\n";
				m+=name+" <font color="+StringData.RED+"><b>"+String(Math.round(userate*100))+"%</b></font>\n ";
			}
			
			if (name==EffectData.REVIVE_GRAIL){
				m=name+" <font color="+StringData.RED+"><b>"+String(Math.round(userate*100))+"%</b></font>\n ";
			}
			m+=buff.getDesc();
			
			if (m.length>0){
				m=StringData.tabs(_tabs)+m;
			}
			return m;
		}
		
		override public function getSpecialDesc(_descType:int=-1):String{
			var m:String="";
			if (name==EffectData.QUICK){
				m+=getTriggerText(EffectBase.HIT_MELEE);
			}else if (name!=EffectData.MASSIVE_BLOW){
				m+=getTriggerText(_descType);
			}
			
			if (name==EffectData.REVIVE_GRAIL || name==EffectData.REVIVE_GOKU){
				m="When you are dealt lethal damage, come back to life and ";
			}
			
			var n:String=buff.getEffectDesc();
			if (n==null || n.length==0) return null;
			
			if (m.length==0){
				m+=n.charAt(0).toUpperCase();
				m+=n.substr(1);
			}else{
				m+=n.charAt(0).toLowerCase();
				m+=n.substr(1);
			}
			
			if (name==EffectData.REVIVE_GRAIL || name==EffectData.REVIVE_GOKU){
				m+="\n\n*Only one revive of any type can occur per fight.";
			}
			
			return m;
		}
	}
}