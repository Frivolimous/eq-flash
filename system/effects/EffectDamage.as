package system.effects{
	import system.actions.ActionBase;
	import ui.effects.PopEffect;
	import system.buffs.BuffData;
	import items.ItemData;
	import utils.GameData;
	
	public class EffectDamage extends EffectBase{
		public var damage:Number,
					damageType:int,
					splash:int;
		
		public function EffectDamage(_name:String=null,_damage:Number=0,_dType:int=0,_trigger:int=7,_userate:Number=1,_splash:int=-1){
			if (_name!=null){
				name=_name;
				level=0;
				type=EffectBase.DAMAGE;
				trigger=_trigger;
				userate=_userate;
				damage=_damage;
				damageType=_dType;
				splash=_splash;
			}
		}
		
		override public function modify(_v:SpriteModel,_action:ActionBase=null):EffectBase{
			var m:EffectDamage=(clone() as EffectDamage);
			
			m.modifyThis(_v,_action);
			return m;
		}
		
		override public function modifyThis(_v:SpriteModel,_action:ActionBase=null){
			if (name==EffectData.FULL_POWER || name==EffectData.FULL_POWER2){
				if (_v.healthPercent()<0.75) damage=0;
			}
			if (name==EffectData.GOLD_STRIKE){
				if (GameData.gold<100) damage=0;
			}
			
			if (damageType==DamageModel.CHEMICAL)  damage*=_v.stats.getValue(StatModel.CHEMEFF);
			if (damageType==DamageModel.HOLY)  damage*=_v.stats.getValue(StatModel.HOLYEFF);
			if (damageType==DamageModel.MAGICAL)  damage*=_v.stats.getValue(StatModel.MAGICEFF);
			if (damageType==DamageModel.PHYSICAL)  damage*=_v.stats.getValue(StatModel.PHYSEFF);
			if (damageType==DamageModel.DARK) damage*=_v.stats.getValue(StatModel.DARKEFF);
			if (_action!=null && _action.isConsumable()) damage*=_v.stats.getValue(StatModel.ITEMEFF);
			damage*=_v.stats.getValue(StatModel.PROCEFF);
		}
		
		override public function clone():EffectBase{
			return new EffectDamage(name,damage,damageType,trigger,userate);
		}
		
		override public function applyEffect(_o:SpriteModel,_t:SpriteModel,_action:ActionBase,_dmgModel:DamageModel){
			if (name==EffectData.SMITE_PROC){
				if (!_o.buffList.hasBuff(BuffData.SMITE_PROC)){
					return;
				}
				_dmgModel.oBuffs.push(BuffData.SMITE_PROC);
			}else if (name==EffectData.SPIKEY){
				if (_action.source.primary!=ItemData.WEAPON || _o.eDistance!=GameModel.NEAR){
					return;
				}
			}
			
			if (name==EffectData.GOLD_STRIKE){
				GameData.gold-=100;
				try{
					Facade.currentUI.inventoryUI.updateGold();
				}catch(e:Error){}
			}
			
			if (name==EffectData.RADIANT_PULSE){
				_dmgModel.setDmg(_action.damage*damage,damageType);
			}else{
				_dmgModel.setDmg(damage,damageType);
			}
			
			if (_dmgModel.after==-1 || Math.random()<0.4){
				if (splash!=-1){
					_dmgModel.after=splash;
				}else{
					switch(damageType){
						case DamageModel.MAGICAL: _dmgModel.after=PopEffect.MAGIC; break;
						case DamageModel.CHEMICAL: _dmgModel.after=PopEffect.TOXIC; break;
						case DamageModel.HOLY: _dmgModel.after=PopEffect.HOLY; break;
						case DamageModel.DARK: _dmgModel.after=PopEffect.DARK; break;
						case DamageModel.PHYSICAL: _dmgModel.after=PopEffect.CRIT; break;
					}
				}
			}
			/*switch(name){
				case EffectData.ARCANE: case EffectData.ENCHANTED: case EffectData.SCORCHING: case EffectData.FULL_POWER: case EffectData.FULL_POWER2:
					if ((_dmgModel.after==-1)||(Math.random()<0.4)) _dmgModel.after=PopEffect.MAGIC; break;
					
				case EffectData.FLAMING: case EffectData.EXPLOSIVE: case EffectData.BLAZING: 
					if ((_dmgModel.after==-1)||(Math.random()<0.4)) _dmgModel.after=PopEffect.FIRE; break;
					
				case EffectData.HOLY_FLAT: case EffectData.BRILLIANT: case EffectData.LUMINANT: case EffectData.SMITE_PROC: 
					if ((_dmgModel.after==-1)||(Math.random()<0.4)) _dmgModel.after=PopEffect.HOLY; break;
				case EffectData.CORRUPTED: case EffectData.VENOMOUS: 
					if ((_dmgModel.after==-1)||(Math.random()<0.4)) _dmgModel.after=PopEffect.TOXIC; break;
				case EffectData.RADIANCE: 
					_dmgModel.after=PopEffect.RADIANCE; break;
				default: null;
			}*/
				
		}
		
		override public function getDesc(_tabs:int=1):String{
			var m:String="";
			if (userate<1){
				m+="<font color="+StringData.RED+"><b>"+StringData.reduce(userate*100)+"%</b></font> ";
			}
			
			m+="DMG: <font color="+StringData.RED+"><b>+"+StringData.reduce(damage)+" "+DamageModel.shortTypeName[damageType]+"</b></font>";

			if (m.length>0){
				m=StringData.tabs(_tabs)+m;
			}
			return m;
		}
		
		override public function getSpecialDesc(_descType:int=-1):String{
			var m:String="";
				
			m+=getTriggerText(_descType);
			
			if (name==EffectData.RADIANT_PULSE){
				return m+"deal a percent of your attack's damage.";
			}else if (name==EffectData.SPIKEY){
				m+="if at Near Range, ";
			}else if (name==EffectData.FULL_POWER || name==EffectData.FULL_POWER2){
				m+="if you are above 75% Health, ";
			}else if (name==EffectData.GOLD_STRIKE){
				m+="costing 100 gold per strike, ";
			}else{
				if (m.length==0){
					m+="Deal bonus ";
				}else{
					m+="deal bonus ";
				}
			}
			m+=DamageModel.fullTypeName[damageType].toLowerCase();
			
			m+=" damage";
			if (name==EffectData.FULL_POWER){
				" and can attack from Mid or Far Range";
			}
			m+="."
			return m;
		}
	}
}