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
	
	public class EffectBase{
		
		public static const	BUFF:int=0, //Effect Types
							CURSE:int=1,
							INSTANT:int=2,
							DAMAGE:int=3,
							
							NEVER:int=-2, //Trigger Types
							ALL:int=-1,
							HIT:int=0,
							HIT_MELEE:int=16,
							DEFENSE:int=1,
							BLOCK:int=2,
							DODGE:int=3,
							TURN:int=4,
							//HEAL:int=5,
							HITBLOCK:int=6,
							HURT:int=7,
							INITIAL:int=8,
							SAFE:int=9,
							LEVEL_BOOST:int=10,
							INJURED:int=11,
							CONSTANT:int=12,
							MITIGATION:int=13,
							TRIGGER_SELF:int=14,
							OFFENSE:int=15;
							//BUFF:int=10,
							
		public var name:String,
					level:int,
					type:int,
					values:*,
					userate:Number,
					trigger:int;
		
		public function EffectBase(_name:String=null,_level:int=0,_type:int=0,_trigger:int=0,_userate:Number=0,_values:*=null){
			if (_name!=null){
				name=_name;
				level=_level;
				type=_type;
				trigger=_trigger;
				userate=_userate;
				values=_values;
			}
		}
		
		public function modify(_v:SpriteModel,_action:ActionBase=null):EffectBase{
			//var m:EffectBase=EffectData.makeEffect(name,level);
			var m:EffectBase=new EffectBase(name,level,type,trigger,userate,values);
			if (values is Array){
				m.values=new Array;
				for (var i:int=0;i<values.length;i+=1){
					m.values.push(values[i]);
				}
			}
			m.modifyThis(_v,_action);
			return m;
		}
		
		public function modifyThis(_v:SpriteModel,_action:ActionBase=null){
			
		}
		
		public function canUse(_trigger:int,_action:ActionBase):Boolean{
			if (trigger==ALL) return true;
			
			switch(_trigger){
				case HIT: if (trigger==HIT || trigger==HITBLOCK) return true;
					return false;
				case HURT: if (trigger==HIT || trigger==HITBLOCK || trigger==HURT || trigger==OFFENSE) return true;
					return false;
				case DEFENSE:
					if (trigger==DEFENSE || trigger==OFFENSE) return true;
					switch(_action.defended){
						case SpriteView.DODGE_LONG:
						case SpriteView.DODGE: if (trigger==DODGE) return true;
							return false;
						case SpriteView.BLOCK: if (trigger==HITBLOCK || trigger==BLOCK) return true;
							return false;
						case SpriteView.IGNORED: return false;
						case SpriteView.TURN: if (trigger==TURN) return false;
					}
					break;
				case INITIAL:
					if (trigger==INITIAL || trigger==SAFE) return true;
						return false;
				default:
					if (trigger==_trigger) return true;
						return false;
			}
			return false;
		}
		
		public function checkRate():Boolean{
			if (userate<=0) return false;
			if (userate>=1 || GameModel.random()<userate) return true;
			return false;
		}
		
		public function clone():EffectBase{
			return new EffectBase(name,level,type,trigger,userate,values);
		}
		
		public function applyEffect(_o:SpriteModel,_t:SpriteModel,_action:ActionBase,_dmgModel:DamageModel){
			//When an effect is used
			
			switch (name){
				case EffectData.CHAIN: if (_o.strike==0 && !_action.isRanged()) _dmgModel.numQuicks+=values;
					break;
				case EffectData.WALK: break;
				case EffectData.SACRIFICE: _o.healthDamage(values*_action.damage);
					_o.stats.useEffects(EffectBase.INJURED,new DamageModel,_o,_o.attackTarget);
					graphicEffect(FLYING_TEXT,_o,String(Math.round(values*_action.damage)));
					break;
				
				case EffectData.KI_STRIKE:
					var _mana:Number=_o.mana;
					if (_mana>values[1]) _mana=values[1];
					_dmgModel.setDmg(_mana*values[0]*(_o.stats.getValue(StatModel.MPOWER)+100)/100,DamageModel.MAGICAL,true);
					_dmgModel.after=PopEffect.MAGIC;
					_o.mana-=_mana;
					Facade.effectC.checkAutoMana(_o);
					break;
				case EffectData.RPEN:
					_action.dmgModel.rPen+=values;
					break;
				case EffectData.MANA_HEAL:
					_o.mana+=values;
					graphicEffect(ANIMATED,_t,AnimatedEffect.BLUE_WISPS);
					//new FlyingText(_o,String(Math.round(values)),0x5555ff); break;
					break;
				case EffectData.MPOW_HEAL:
					_dmgModel.addHeal(values*_o.stats.getValue(StatModel.MPOWER));
					graphicEffect(ANIMATED,_t,AnimatedEffect.GREEN_WISPS);
					break;
				case EffectData.REMOVE_BUFF:
					Facade.effectC.removeBuffTurns(_t,values);
					break;
				case EffectData.MPOWSCALING:
					graphicEffect(ANIMATED,_o,AnimatedEffect.FLAME);
					break;
				case EffectData.STEALTH_CRATE: case EffectData.STEALTH_DODGE:
					if (!_o.buffList.hasBuff(BuffData.STEALTH)){
						_o.addApply(EffectData.makeEffect(EffectData.INITIAL_STEALTH,0),1);
					}
					break;
				case EffectData.RANDOM_BUFF:
					switch(Math.floor(GameModel.random()*4)){
						case 0: _dmgModel.oBuffs.push(BuffData.makeBuff(BuffData.CELERITY_POT,values).modify(_o)); break;
						case 1: _dmgModel.oBuffs.push(BuffData.makeBuff(BuffData.BUFF_POT,values).modify(_o)); break;
						case 2: _dmgModel.oBuffs.push(BuffData.makeBuff(BuffData.PURITY_POT,values).modify(_o)); break;
						case 3: _dmgModel.oBuffs.push(BuffData.makeBuff(BuffData.TURTLE_POT,values).modify(_o)); break;
					}
					break;
				
				case EffectData.DTHROW:
					if(_o.eDistance==GameModel.NEAR){
						_t.buffList.addBuff(BuffData.makeBuff(BuffData.STUNNED,100));
						_t.view.tweenA=SpriteView.FREEZE;
						playerEffect(PLAYER_ACTION,_o,SpriteView.DTHROW);
					}
					break;
				case EffectData.STEALTH_CMULT:
					if (!_o.buffList.hasBuff(BuffData.STEALTH)){
						_o.buffList.addBuff(BuffData.makeBuff(BuffData.STEALTH).modify(_o));
					}
					break;
				case EffectData.STEALTH_CLEAR_ATTACK: case EffectData.STEALTH_CLEAR_DAMAGED:
					if (_o.buffList.hasBuff(BuffData.STEALTH)){
						_dmgModel.oBuffs.push(BuffData.STEALTH);
					}
					break;
				case EffectData.MASSIVE_CLEAR_ATTACK:
					if (_o.buffList.hasBuff(BuffData.MASSIVE_BLOW_PROC)){
						_dmgModel.oBuffs.push(BuffData.MASSIVE_BLOW_PROC);
						_dmgModel.after=PopEffect.CRIT;
					}
					break;
				case EffectData.CANNIBAL_CLEAR_ATTACK:
					if (_o.buffList.hasBuff(BuffData.CANNIBALISM)){
						_dmgModel.oBuffs.push(BuffData.CANNIBALISM);
						_dmgModel.after=PopEffect.CRIT;
					}
					break;
				case EffectData.CLEANSE:
				case EffectData.CLEANSE_HEAL:
					if (_o.buffList.numBuffs()>=0){
						var i:int=values;
						var _temp:Array=new Array();
						for (var j:int=0;j<_o.buffList.numBuffs();j+=1){
							var _buff:BuffBase=_o.buffList.getBuff(j);
							if (_buff.type==BuffBase.CURSE && _buff.name!=BuffData.STUNNED && !(_buff is BuffDelayedDmg) && _buff.charges>0){
								_temp.push(j);
							}
						}
						while (_temp.length>0 && i>0){
							i-=1;
							j=Math.floor(GameModel.random()*_temp.length);
							_buff=_o.buffList.getBuff(_temp[j]);
							if (_buff.charges>=0){
								_buff.charges-=1;
								if (_buff.charges<=0){
									_o.buffList.removeBuff(_temp[j]);
									_temp.splice(j,1);
								}
							}
						}
					}
					break;
				case EffectData.AUTOPOT:
					if (_o.healthPercent()<=0.5){
						for (j=0;j<_o.belt.length;j+=1){
							if (_o.belt[j]!=null && (_o.belt[j].index==31 || _o.belt[j].index==96) && _o.belt[j].enchantIndex!=1 && _o.belt[j].charges>0){
								_item=_o.belt[j];
							}
						}
						if (_item!=null){
							var _action:ActionBase=_item.action.modify(_o,true);
							_action.primary=false;
							_action.useAction(_o,_o);
						}
					}break;
				case EffectData.AUTOBUFF:
					for (j=0;j<_o.belt.length;j+=1){
						if (_o.belt[j]!=null && _o.belt[j].primary==ItemData.POTION && _o.belt[j].secondary==ItemData.BUFF && _o.belt[j].charges>0){
							if (!_o.buffList.hasBuff((_o.belt[j].action.effects[0] as EffectBuff).buff.name)){
								var _item:ItemModel=_o.belt[j];
							}
						}
					}
					if (_item!=null){
						_action=_item.action.modify(_o,true);
						_action.primary=false;
						_action.useAction(_o,_o);
					}break;
				case EffectData.FREE_SPELL:
					if (values.mana>_o.mana) return;
					if (_o.attackTarget==null) return;
					_t=_o.attackTarget;
					if ((values is ActionSpellCursing) && _t.buffList.hasBuff(((values as ActionSpellCursing).effects[0] as EffectBuff).buff.name)){
						return;
					}
					
					_o.mana-=values.mana;
					Facade.effectC.checkAutoMana(_o);
					
					_action=values.modify(_o,true);
					_o.shots=1;
					_action.setDefense(_o,_t);
					_action.makeProjectile(_o,_t);
					break;
				case EffectData.MANUFACTURING_HIT:
					_o.craftB+=values;
					break;
				case EffectData.FURY_MISS: case EffectData.FURY_HURT: 
				case EffectData.FURY_DEFEND: case EffectData.FURY_INIT:
				case EffectData.FURY_HIT:
					_o.addFury(values);
					//_o.fury+=values;
					break;
				case EffectData.BLOODLUST:
					_o.fury-=50;
					break;
			}
		}
		
		public function finalEffect(_o:SpriteModel){
			//At the end of the round, if addApply is used
			if (userate==1){
				switch(name){
					case EffectData.INITIAL_STEALTH:
						if (!_o.buffList.hasBuff(BuffData.STEALTH)){
							_o.buffList.addBuff(new BuffStealth().modify(_o));
						}
						break;
				}
			}
		}
		
		public static const FLYING_TEXT:int=0,
							ANIMATED:int=1,
							POP:int=2,
							ADD_BUFF:int=3,
							REMOVE_BUFF:int=4,
							UPDATE_BUFF:int=5;
							
		public function graphicEffect(_type:int,_v:SpriteModel,_obj:*){
			if (GameModel.SIMULATED) return;
			if (Facade.currentUI!=Facade.gameUI) return;
			switch(_type){
				case FLYING_TEXT:
					switch(_obj){
						default: new FlyingText(_v,_obj);
					}
					break;
				case ANIMATED:
					new AnimatedEffect(_v,_obj);
					break;
				case POP:
					new PopEffect(_v,_obj);
					break;
			}
		}
		
		public static const PLAYER_ACTION:int=0,
							PLAYER_BACK_TWO:int=1,
							PLAYER_FROM_ACTION:int=2;
							
		public function playerEffect(_type:int,_v:SpriteModel,_obj:*){
			if (GameModel.SIMULATED) return;
			
			switch(_type){
				case PLAYER_ACTION:
					if (_obj is Array){
						 _v.view.action(_obj[0],_obj[1]);
					}else{
						_v.view.action(_obj);
					}
					break;
				case PLAYER_BACK_TWO: _v.view.backTwo(); break;
				case PLAYER_FROM_ACTION:
					if (_obj.crit){
						var _crit:int=1;
					}else{
						_crit=0;
					}
					_v.view.fromAction(_obj,_crit);
					break;
			}
			
		}
		
		public function getDesc(_tabs:int=1):String{
			var m:String="";
			if (userate<1){
				m+="<font color="+StringData.RED+"><b>"+StringData.reduce(userate*100)+"%</b></font> ";
			}
			
			if (values!=null) {
				m+=name;
				switch(name){
					case EffectData.MANA_SHIELD:
						m+=" <font color="+StringData.RED+"><b>1</b></font> mana prevents <font color="+StringData.RED+"><b>"+StringData.reduce(1/values)+"</b></font> damage";
						break;
					case EffectData.BLOOD_BANK:
						m+=" heals you for <font color="+StringData.RED+"><b>"+values+"C</b></font> Health";
						break;
					case EffectData.MANA_BANK:
						m+=" restores <font color="+StringData.RED+"><b>"+values+"C</b></font> Mana";
						break;
					case EffectData.KI_STRIKE:
						m+=" deals <font color="+StringData.RED+"><b>"+StringData.reduce(values[0]*values[1])+"M</b></font> damage";
						m+="\n"+StringData.tabs(_tabs)+"for <font color="+StringData.RED+"><b>"+String(values[1])+"</b></font> mana.";
						/*m+=" uses up to  <font color="+StringData.RED+"><b>"+String(values[1])+"</b></font> mana,"
						m+="\n"+StringData.tabs(_tabs)+"dealing <font color="+StringData.RED+"><b>"+StringData.reduce(values[0])+"M</b></font> damage per mana used.";*/
						break;
					case EffectData.DEFENSIVE_ROLL:
						m="Reduce damage by <font color="+StringData.RED+"><b>"+String(Math.round(values*100))+"%</b></font>"
						break;
					case EffectData.REVIVE_JUST:
					case EffectData.REVIVE_PHOENIX:
						m=name+" <font color="+StringData.RED+"><b>"+String(Math.round(userate*100))+"%</b></font>";
						break;
					case EffectData.SPELL_BOOST: case EffectData.BUFF_POT_BOOST: case EffectData.MANA_HEAL: case EffectData.BUFF_BOOST:
					case EffectData.REMOVE_BUFF: case EffectData.BASE_DMG: case EffectData.CHAIN: case EffectData.FEATHER_HIT: case EffectData.MULTI:
					case EffectData.DOUBLESHOT: case EffectData.FIND_STACKS:
						m+=" <font color="+StringData.RED+"><b>+"+values+"</b></font>";
						break;
					case EffectData.CLEANSE_HEAL:
					case EffectData.RANDOM_BUFF:
					case EffectData.FURY_DEFEND: case EffectData.FURY_HIT: case EffectData.FURY_HURT:
					case EffectData.FURY_INIT: case EffectData.FURY_MISS:
						m+=" <font color="+StringData.RED+"><b>"+values+"</b></font>";
						break;
					case EffectData.FREE_SPELL:
						m+="\n"+values.getDesc();
						break;
					case EffectData.MANUFACTURING_HIT:
						m+=": <font color="+StringData.RED+"><b>"+values+"</b></font> Manufacturing per hit";
						break;
					case EffectData.GOLD_PER_KILL: 
						m+=" <font color="+StringData.RED+"><b>"+StringData.reduce(values)+"g</b></font>";
						break;
					case EffectData.MPOW_HEAL: break;
					default:
						if (values>0) m+=" <font color="+StringData.RED+"><b>"+StringData.reduce(values*100)+"%</b></font>";
						break;
				}
			}else if (name==EffectData.WALK || name==EffectData.APPROACH || name==EffectData.WITHDRAW || name==EffectData.MASSIVE_CLEAR_ATTACK || name==EffectData.CANNIBAL_CLEAR_ATTACK){
				return "";
			}else{
				m+=name;
			}

			if (m.length>0){
				m=StringData.tabs(_tabs)+m;
			}
			return m;
		}
		
		public static const DESC_DEFAULT:int=-1,
							DESC_OFFENSIVE:int=0,
							DESC_ATTACK:int=1,
							DESC_CRIT:int=2;
							
		public function getTriggerText(_descType:int=-1):String{
			var m:String="";
			
			switch(trigger){
				case HIT_MELEE:
					m+="When you hit with an attack, ";
					break;
				case HIT:
					if (_descType==DESC_CRIT){
						m+="When you critically hit, ";
					}else if (_descType==DESC_ATTACK){
						m+="When you hit with an attack or projectile, ";
					}else if (_descType==HIT_MELEE){
						m+="When you hit with an attack, ";
					}else if (_descType==DESC_OFFENSIVE){
						m+="";
					}else{
						m+="When you are hit, ";
					}
					break;
				case DEFENSE:
					if (_descType==DESC_DEFAULT){
						m+="If you defend with block, dodge or nullify, ";
					}else{
						m+="If your enemy defends, ";
					}
					break;
				case BLOCK:
					if (_descType==DESC_DEFAULT){
						m+="If you block an attack, ";
					}else{
						m+="If your enemy blocks, ";
					}
					break;
				case DODGE:
					if (_descType==DESC_DEFAULT){
						m+="If you dodge an attack, ";
					}else{
						m+="If your enemy dodges, ";
					}
					break;
				case TURN:
					if (_descType==DESC_DEFAULT){
						m+="If you nullify a spell, ";
					}else{
						m+="If your enemy nullifies, ";
					}
					break;
				case HITBLOCK:
					if (_descType==DESC_DEFAULT){
						m+="If you are hit or you block, ";
					}else{
						m+="If you hit or your enemy blocks, ";
					}
					break;
				case HURT:
					if (_descType==DESC_CRIT){
						m+="When you critically hit, ";
					}else if (_descType==DESC_ATTACK){
						m+="When you deal damage with an Attack or Projectile, ";
					}else if (_descType==HIT_MELEE){
						m+="When you hit with an attack, ";
					}else if (_descType==DESC_OFFENSIVE){
						m+="When dealing damage, ";
					}else{
						m+="When you are hurt by your enemy's actions, ";
					}
					
					break;
				case INITIAL:
					m+="At the beginning of an encounter, ";
					break;
				case SAFE:
					m+="Every round when you are safe, ";
					break;
				case INJURED:
					m+="When you take damage from any source, ";
					break;
				case CONSTANT:
					m+="Every round, ";
					break;
				case OFFENSE:
					m+="When you make an offensive action, ";
					break;
				case NEVER: case ALL:
				case LEVEL_BOOST: case MITIGATION: case TRIGGER_SELF:
					m+="";
					break;
				//case HEAL:
			}
			
			if (userate>0 && userate<1) {
				if (m.length==0){
					m+="Chance to ";
				}else{
					m+="chance to ";
				}
			}
			
			return m;
		}
		
		public function getSpecialDesc(_descType:int=-1):String{
			var m:String="";
			
			m+=getTriggerText(_descType);
			
			var n:String;
			
			switch(name){
				case EffectData.SPELL_BOOST: n="Boost the level of any spell you cast."; break;
				case EffectData.BUFF_POT_BOOST: n="Boost the level of buffing potions."; break;
				case EffectData.BUFF_BOOST: n="Boost the level of buffing Spells and Items."; break;
				
				case EffectData.DOUBLESHOT: n="make a bonus ranged attack or throw an additional projectile or grenade."; break;
				
				case EffectData.STEALTH_CMULT: return "Increases your Crit Mult while stealthed.\n\n*Grants Stealth at the start of combat.\n\n*Stealth is lost when you make an offensive action, are Cursed or Injured."; break;
				case EffectData.STEALTH_CRATE: return "Increases your Critical Rate while stealthed.\n\n*Grants you Stealth at the end of your turn if you Critically Hit."; break;
				case EffectData.STEALTH_DODGE: return "Increases your Dodge Rate while stealthed.\n\n*Grants you Stealth whenever you Dodge."; break;
				
				case EffectData.KI_STRIKE: n="automatically consume mana to deal magic damage. Scales off of MPOW."; break;/**/
				case EffectData.AUTOPOT: return "drink when dropping below 50% Health or Mana."; break;
				case EffectData.CLEANSE: n="reduce a random debuff's duration by 1."; break;
				
				case EffectData.SACRIFICE: n="deal a percent of damage dealt to yourself."; break;
				case EffectData.MANA_HEAL: n="recover mana whenever you directly damage an enemy."; break;
				case EffectData.MPOW_HEAL: n="recover your MPow in Health when you directly damage an enemy."; break;
				case EffectData.NONCRIT: n="Increase Non-Critical Damage with Weapons and Projectiles"; break;
				case EffectData.REMOVE_BUFF: n="Destroy a number of buff turns off of your enemy."; break;
				
				case EffectData.RANDOM_BUFF: n="Cast a random Buffing Potion effect on you at the listed level."; break;
				
				case EffectData.INITSCALING: n="Add a percent of your bonus Initiative as a multiplier to Strength Scaling, or a percent of your bonus Strength to Initiative Scaling."; break;
				case EffectData.MPOWSCALING: n="Use your MPow as your weapon multipier instead of Strength."; break;
				case EffectData.INIT_SPELL: n="Add a percent of your bonus Initiative in addition to MPow as a multiplier for spells."; break;
				case EffectData.MPOWSCALINGADD: n="Add a percent of your bonus MPow as a multiplier to Weapon Damage."; break;
				case EffectData.MULTI: case EffectData.CHAIN: n="Increase number of attacks."; break;
				case EffectData.AWARD: n="Grants +1 XP Per Kill."; break; 
				
				case EffectData.FREE_SPELL: n="Cast this spell without using an action but with greatly reduced effect."; break;
				
				case EffectData.DTHROW: n="stun your opponent."; break;
				case EffectData.AUTOBUFF: n="drink a non-active buffing potion."; break;
				
				case EffectData.CLEANSE_HEAL: n="remove 1 debuff turn on successful cast."; break;/**/
				case EffectData.REVIVE_JUST:
				case EffectData.REVIVE_PHOENIX: return "Revive after death with a percent of your maximum health.\n\n*Only one revive of any type can occur per fight."; break;
				case EffectData.MANA_SHIELD: n="When you would take lethal damage, Mana is consumed instead of Health."; break;
				case EffectData.BLOOD_BANK: n="When you would take lethal damage, Charges are consumed to instantly heal you."; break;
				case EffectData.MANA_BANK: n="Whenever you use mana, Charges are consumed to instantly restore you."; break;
				case EffectData.DEFENSIVE_ROLL: n="When you take any form of damage, succeed on a Dodge Roll to reduce damage taken."; break;
				case EffectData.FEATHER_HIT: n="Your first attack every round has bonus Hit."; break;
				case EffectData.IGNORE_ATTACK: return "Ignore the first offensive action made by your enemy."; break;
				case EffectData.UNARMED_INIT: n="Use Initiative instead of Strength for Unarmed Damage."; break;
				
				case EffectData.FIND_STACKS: n="After defeating an opponent, gain Manufacturing Points which stack with points from other sources.  100 Points grants stacks of belt items based on stack size."; break;
				case EffectData.BASE_DMG: n="Improve the weapon's Base Damage."; break;
				case EffectData.CURSE_REFLECT: n="reflect any cursing Spell or Potion back to your enemy."; break;
				case EffectData.BUFF_REFLECT: n="steal any Buffing Spell or Potion cast by your enemy."; break;
				
				case EffectData.WALK: n="Sally forth throughout the land, my friend, sally forth!"; break;
				case EffectData.APPROACH: n="Close the distance between you and your opponent."; break;
				case EffectData.WITHDRAW: n="Move backwards one range category distance."; break;
				case EffectData.BERSERK: n="Has more powerful attacks but is unable to take complicated actions."; break;
				case EffectData.AFRAID: n="Running in terror from opponent."; break;
				case EffectData.INFINITY: n="not consume a charge from this item."; break;
				case EffectData.MANUFACTURING_HIT: n="Gain Manufacturing Points which stack with points from other sources.  100 Points grants stacks of belt items based on stack size."; break;
				case EffectData.GOLD_PER_KILL: n="Gain gold when you kill an enemy."; break;
				
				case EffectData.RPEN: n="Bypasses a percent of enemy resistances."; break;
				
				case EffectData.FURY_DEFEND: case EffectData.FURY_HIT: case EffectData.FURY_HURT:
				case EffectData.FURY_INIT: case EffectData.FURY_MISS:
					n="Gain an amount of fury indicated."; break;
					
				default: return null;
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
	}
}