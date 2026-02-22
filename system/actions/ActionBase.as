package system.actions{
	import items.ItemModel;
	import items.ItemData;
	import system.buffs.BuffData;
	import system.buffs.BuffBase;
	import system.actions.ActionList;
	import system.actions.ActionPriorities;
	import system.actions.conditionals.ConditionalBase;
	import ui.effects.AnimatedEffect;
	import ui.effects.FlyingText;
	import system.effects.EffectBase;
	import system.effects.EffectData;
	
	public class ActionBase{
		public static const statNames:Vector.<String>=new <String>["TYPE","USERATE","DAMAGE","ACCURACY","HIT","Hit Mult","CRIT","C.MULT","MANA",
																	 "LEECH","HEAL","Effect","CEffect","PHYS","MAGI","CHEM","HOLY","DARK",
																	 "Fury to Crit","Fury to Hit"];
		public static const TYPE:int=0,
							USERATE:int=1,
							DAMAGE:int=2,
							
							DODGE_REDUCE:int=3,
							
							
							HITRATE:int=4,
							HITMULT:int=5,
							CRITRATE:int=6,
							CRITMULT:int=7,
							MANA:int=8,
							
							LEECH:int=9,
							
							HEAL:int=10,
							
							EFFECT:int=11,
							CEFFECT:int=12,

							PHYSICAL:int=13,
							MAGICAL:int=14,
							CHEMICAL:int=15,
							HOLY:int=16,
							DARK:int=17,
							
							
							FURYTOCRIT:int=18,
							FURYTOHIT:int=19,
							
							TAG:int=20,
							
							/*EFFECTS:String="Effects:",
							CEFFECTS:String="Crit:",*/
							
							SELF:int=0,
							ENEMY:int=1,
							
							GAIA:int=0;
							
		public var label:String,
					level:int,
					 target:int,
					 type:int,
					 damage:Number,
					 hitrate:Number,
					 hitmult:Number,
					 critrate:Number,
					 critmult:Number,
					 effects:Vector.<EffectBase>,
					 cEffects:Vector.<EffectBase>,
					 userate:Number,
					 leech:Number,
					 dodgeReduce:Number,
					 furytocrit:Number,
					 furytohit:Number,
					 
					 source:ItemModel,
					 mana:int=0,
					 
					 crit:Boolean=false,
					 defended:String,
					 specialEffect:int,
					 double:Boolean=false,
					 strikes:int=1,
					 shots:int=1,
					 
					 tags:Array,
					 
					primary:Boolean=true,
					 
					 basePriority:ConditionalBase=new ConditionalBase(3,1),
					 additionalPriorities:Array,
					 priorityTier:int;
					 
		public var dmgModel:DamageModel=new DamageModel;
		
		public function ActionBase(_label:String=null,_level:int=0,_userate:Number=0,_priority:int=0,_target:int=0,_damage:Number=0,_type:int=0,_effects:Vector.<EffectBase>=null,_hitrate:Number=NaN,_critrate:Number=0,_critMult:Number=0,_cEffects:Vector.<EffectBase>=null,_mana:int=0,_leech:Number=0,_dodgeReduce:Number=0){
			baseStats();
			if (_label!=null){
				label=_label;
				level=_level;
				userate=_userate;
				target=_target;
				damage=_damage;
				type=_type;
				hitrate=_hitrate;
				
				critrate=_critrate;
				critmult=_critMult;
				
				if (_effects!=null) effects=_effects;
				if (_cEffects!=null) cEffects=_cEffects;
				mana=_mana;
				leech=_leech;
				dodgeReduce=_dodgeReduce;
				basePriority.setBaseDistance(_priority,false);
				setDefaultPriorities();
				
				source=ActionData.DEFAULT;
			}
		}
		
		public function baseStats(){
			label=null;
			type=target=-1;
			level=damage=hitrate=critrate=critmult=userate=leech=dodgeReduce=mana=0;
			hitmult=0;
			specialEffect=-1;
			furytohit=furytocrit=0;
			effects=new Vector.<EffectBase>;
			cEffects=new Vector.<EffectBase>;
			tags=new Array;
		}

		public function addSource(_item:ItemModel){
			source=_item;
			setBasePriority();
		}
		
		public function addValue(_id:int,_value:*){
			switch(_id){
				case HITRATE: hitrate+=_value; break;
				case HITMULT: hitmult+=_value; break;
				case USERATE: userate=addMult(userate,_value); break;
				case DAMAGE: damage+=_value; break;
				case CRITRATE: critrate=addMult(critrate,_value); break;
				case CRITMULT: critmult+=_value; break;
				case EFFECT: effects.push(_value); break;
				case CEFFECT: cEffects.push(_value); break;
				case MANA: mana+=_value; break;
				case LEECH: leech+=_value; break;
				case DODGE_REDUCE: dodgeReduce+=_value; break;
				case FURYTOCRIT: furytocrit+=_value; break;
				case FURYTOHIT: furytohit+=_value; break;
				case TAG: tags.push(_value); break;
				default: throw(new Error("Unavailable action property: "+_id));
			}
		}
		
		public function subValue(_id:int,_value:*){
			switch(_id){
				case HITRATE: hitrate-=_value; break;
				case HITMULT: hitmult-=_value; break;
				case USERATE: userate=subMult(userate,_value); break;
				case DAMAGE: damage-=_value; break;
				case CRITRATE: critrate=subMult(critrate,_value); break;
				case CRITMULT: critmult-=_value; break;
				case EFFECT: effects.splice(effects.indexOf(_value),1); break;
				case CEFFECT: cEffects.splice(cEffects.indexOf(_value),1); break;
				case MANA: mana-=_value; break;
				case LEECH: leech-=_value; break;
				case DODGE_REDUCE: dodgeReduce-=_value; break;
				case FURYTOCRIT: furytocrit-=_value; break;
				case FURYTOHIT: furytohit-=_value; break;
				case TAG: tags.splice(tags.indexOf(_value),1); break;
				default: throw(new Error("Unavailable action property: "+_id));
			}
		}
		
		public function getValue(_id:int){
			switch(_id){
				case HITRATE: return hitrate*(1+hitmult);
				case HITMULT: return hitmult;
				case USERATE: return userate;
				case DAMAGE: return damage;
				case CRITRATE: return critrate;
				case CRITMULT: return critmult;
				case EFFECT: return effects;
				case CEFFECT: return cEffects;
				case MANA: return mana;
				case LEECH: return leech;
				case DODGE_REDUCE: return dodgeReduce;
				case FURYTOCRIT: return furytocrit;
				case FURYTOHIT: return furytohit;
				case TAG: return tags;
				default: throw(new Error("Unavailable action property: "+_id));
			}
		}
		
		public function modify(_v:SpriteModel,_random:Boolean=true):ActionBase{
			var m:ActionBase=new ActionBase();
			
			
			var _effects:Vector.<EffectBase>=m.effects;
			m.effects=new Vector.<EffectBase>;
			for (var i:int=0;i<_effects.length;i+=1){
				m.effects.push(_effects[i].modify(_v));
			}
			
			if (_v.stats.procs.length>0){
				m.effects=m.effects.concat(_v.stats.modProcs(_v,this));
			}
			
			return m;
		}
		
		public function getBoost(_v:SpriteModel):int{
			specialEffect=-1;
			return 0;
		}
		
		public function useAction(_o:SpriteModel,_t:SpriteModel){
			//second phase function, sets up the everything required pre-animation.
			if (mana>0){
				if (hasTag(EffectData.BLOOD_MAGIC)){
					if(mana*EffectData.BLOOD_MAGIC_RATIO<_o.getHealth()-1){
						_o.healthDamage(mana*EffectData.BLOOD_MAGIC_RATIO);
					}
				}else{
					if (mana>_o.mana) return;
					
					_o.mana-=mana;
					Facade.effectC.checkAutoMana(_o);
				}
			}
			
			if (source.charges>0){
				var _effect:EffectBase=findEffect(EffectData.INFINITY);
				if (_effect==null || GameModel.random()>=_effect.userate){
					source.charges-=chargeCost();
				}
			}else if (source.charges==0){
				return;
			}
			graphicEffect(ADD_ACTION,_o,this);
			
			modify(_o,true).useAction2(_o,_t);
		}
		
		public function useAction2(_o:SpriteModel,_t:SpriteModel){
			finishAction(_o,postAnim,_o);
		}
		
		public function makeProjectile(_o:SpriteModel,_t:SpriteModel){
			var _projM:ProjectileObject=new ProjectileObject(this,_o,_t);
			Facade.gameM.projectiles.push(_projM);
		}
		
		public function postAnim(_o:SpriteModel,_t:SpriteModel){
			if (effects.length>0 && primary){
				useEffects(EffectBase.TRIGGER_SELF,_o,_t,dmgModel,true);
			}
			if (primary) _o.stats.useEffects(EffectBase.TRIGGER_SELF,new DamageModel,_o,_o.attackTarget,this);
			
			checkStrike(_o,_o.attackTarget);
		}
		
		public function checkStrike(_o:SpriteModel,_t:SpriteModel){
			if (_o.strike>1 && _o.shots==0 && !_t.dead){
				_o.strike-=1;
				
				if (hasEffect(EffectData.CHAIN) && !isRanged()){
					var _action:ActionBase=_o.actionList.getAttack().modify(_o);
					_action.finishAction(_o,_action.postAnim,_t);
					playerEffect(PLAYER_BACK_TWO,_o,null);
				}else if (hasTag(EffectData.MONK_WEAPON)){
					source.action.useAction(_o,_t);
				}else{
					if (_o.actionList.getAttack().canUse(_o,_t)){
						_o.actionList.getAttack().useAction(_o,_t);
					}else if (_o.eDistance==GameModel.FAR){
						if (!_o.buffList.hasBuff(BuffData.AIMING) && !_o.buffList.hasBuff(BuffData.RUSHED)){
							_o.actionList.getActionCalled(ActionData.APPROACH).useAction(_o,_t);
						}else{
							endTurn(_o,_t);
						}
					}else if (_o.eDistance==GameModel.VERY){
						if (!_o.buffList.hasBuff(BuffData.AIMING)){
							_o.actionList.getActionCalled(ActionData.APPROACH).useAction(_o,_t);
						}else{
							endTurn(_o,_t);
						}
					}else{
						endTurn(_o,_t);
					}
				}
			}else if (_o.shots==0 && Facade.gameM.projectiles.length<=1 && _o.tAction==null){
				endTurn(_o,_t);
			}
		}
		
		public function finishAction(_o:SpriteModel,_function:Function,_t:SpriteModel){
			//Facade.soundC.testAction(label,_o.view);
			if (target==ENEMY){
				var _effect:EffectBase=_t.stats.findDisplay(EffectData.IGNORE_ATTACK);
				if (_effect!=null && !_t.buffList.hasBuff(BuffData.ATTACK_IGNORED)){
					_t.buffList.addBuff(_effect.values.modify(_t));
					defended=SpriteView.IGNORED;
					playerEffect(PLAYER_DEFENDED,_t,defended);
				}else{
					setDefense(_o,_t);
				}
			}
			
			_o.tFunction=_function;
			_o.tTarget=_t;
			_o.tAction=this;
		}
		
		
		public function setDefense(_o:SpriteModel,_t:SpriteModel){
			
		}
		
		public function useEffects(_trigger:int,_o:SpriteModel,_t:SpriteModel,_dmgModel:DamageModel,_finish:Boolean=true){
			for (var i:int=0;i<effects.length;i+=1){
				if (effects[i].canUse(_trigger,this) && effects[i].checkRate()){
					effects[i].applyEffect(_o,_t,this,_dmgModel);
				}
			}
			_dmgModel.applyBuffs(_o,_t);
			if (_finish) _dmgModel.applyDamage(_o,_t,true);
		}
		
		public function endTurn(_o:SpriteModel,_t:SpriteModel){
			for (var i:int=0;i<_o.toApply.length;i+=1){
				_o.toApply[i].finalEffect(_o);
			}
			
			if (_t!=null) {
				for (i=0;i<_t.toApply.length;i+=1){
					_t.toApply[i].finalEffect(_t);
				}
			}
			_o.doneTurn=true;
		}
		
		public function clone(_boost:int=0):ActionBase{
			if (source!=null && source!=ActionData.DEFAULT){
				m=source.clone(source.level+_boost).action;
				m.source=source;
			}else{
				var m:ActionBase=ActionData.makeAction(label,level+_boost);
			}
			m.specialEffect=specialEffect;
			
			return m;
		}
		
		
		public function addBase(_v:ActionBase,_multDmg:Boolean=false){
			effects=effects.concat(_v.effects);
			hitrate+=_v.hitrate;
			hitmult+=_v.hitmult;
			type=_v.type;
			critrate=addMult(critrate,_v.critrate);
			critmult+=_v.critmult;
			cEffects=cEffects.concat(_v.cEffects);
			furytohit+=_v.furytohit;
			furytocrit+=_v.furytocrit;
			leech+=_v.leech;
			dodgeReduce+=_v.dodgeReduce;
			if (_multDmg) damage*=_v.damage;
		}
		
		public function fullUse(_v:SpriteModel):Number{
			var m:Number=userate;
			
			return m;
		}
		
		public function addMult(a:Number,b:Number):Number{
			return (1-(1-a)*(1-b));
		}
		
		public function subMult(t:Number,a:Number):Number{
			return (1-(1-t)/(1-a));
		}
		
		public function toHit(_block:Number,_bonusHit:Number=0):Number{
			var m:Number=(getValue(HITRATE)+_bonusHit)/(getValue(HITRATE)+_bonusHit+_block/3);
			return m;
		}
		
		public function isMagic():Boolean{
			if (source!=null && (source.primary==ItemData.MAGIC || source.primary==ItemData.SCROLL)) return true;
			return false;
		}
		
		public function isConsumable():Boolean{
			if (source!=null && source.slot==ItemData.USEABLE && source.primary!=ItemData.CHARM) return true;
			return false;
		}
		
		public function isMelee():Boolean{
			//if (source!=null && (source.primary==ItemData.WEAPON || type==PHYSICAL)) return true;
			if (label==ActionData.APPROACH || label==ActionData.ATTACK || label==ActionData.BASH) return true;
			return false;
		}
		
		public function isProjectile():Boolean{
			if (source!=null && source.primary==ItemData.PROJECTILE) return true;
			return false;
		}
		
		public function isAttack():Boolean{
			if (source!=null && (source.primary==ItemData.WEAPON || source.primary==ItemData.PROJECTILE)) return true;
			return false;
		}
		
		public function isRanged():Boolean{
			if (source!=null && (source.primary==ItemData.PROJECTILE || (source.primary==ItemData.WEAPON && (hasTag(EffectData.RANGED) || hasTag(EffectData.LONG_RANGED))))){
				return true;
			}
			return false;
		}
		
		public function isInitiative():Boolean{
			if (source!=null && hasTag(EffectData.PIERCE)) return true;
			if (hasEffect(EffectData.UNARMED_INIT)) return true;
			return false;
		}
		
		public function isBuffing():Boolean{
			if (source!=null && source.primary==ItemData.POTION && source.secondary==ItemData.BUFF) return true;
			return false;
		}
		
		public function isBuff():Boolean{
			if (source!=null && source.secondary==ItemData.BUFF) return true;
			return false;
		}
		
		public function isCurse():Boolean{
			if (source!=null && (source.secondary==ItemData.CURSE)) return true;
			return false;
		}
		
		public function isDrinking():Boolean{
			if (source!=null && (source.primary==ItemData.POTION) && (source.index<34 || source.index==96)) return true;
			return false;
		}
		
		public function isGrenade():Boolean{
			if (source!=null && (source.primary==ItemData.GRENADE) && (source.index>=34) && target==ENEMY) return true;
			return false;
		}
		
		public function isDouble():Boolean{
			if (source!=null && (source.secondary==ItemData.DOUBLE || source.secondary==ItemData.UNARMED)) return true;
			return false;
		}
		
		public function chargeCost():int{
			if (source!=null && hasTag(EffectData.TWO_CHARGES)) return 2;
			return 1;
		}
		
		public function noAttack():Boolean{
			if (source!=null && hasTag(EffectData.NO_ATTACK)) return true;
			return false;
		}
		
		public function isReturn():Boolean{
			if (source!=null && hasTag(EffectData.RETURN)) return true;
			return false;
		}
		
		public function hasTag(s:String):Boolean{
			for (var i:int=0;i<tags.length;i+=1){
				if (tags[i]==s) return true;
			}
			return false;
		}
		
		public function hasEffect(_name:String):Boolean{
			for (var i:int=0;i<effects.length;i+=1){
				if (effects[i].name==_name) return true;
			}
			return false;
		}
		
		public function findEffect(_name:String):EffectBase{
			for (var i:int=0;i<effects.length;i+=1){
				if (effects[i].name==_name) return effects[i];
			}
			return null;
		}
		
		public function findCEffect(_name:String):EffectBase{
			for (var i:int=0;i<cEffects.length;i+=1){
				if (cEffects[i].name==_name) return cEffects[i];
			}
			return null;
		}
		
		//===================PRIORITIES==========================\\
		
		public function checkDistance(_distance:String):Boolean{
			return basePriority.testDistance(_distance);			
		}
		
		public function checkCanDistance(_distance:String):Boolean{
			return basePriority.testCanDistance(_distance);
		}
		
		public function canUse(_o:SpriteModel,_t:SpriteModel,_distance:String=null):Boolean{
			return true;
		}
		
		public function wantUse(_o:SpriteModel,_t:SpriteModel,_distance:String=null,_rate:Boolean=true):Boolean{
			if (_distance==null) _distance=_o.eDistance;
			if (!checkDistance(_distance)) return false;
			
			for (var i:int=0;i<additionalPriorities.length;i+=1){
				if (!additionalPriorities[i].testThis(_o,_t,this)) return false;
			}
			
			if (_rate){
				var _userate:Number=fullUse(_o);
				if (_userate<1 && (_userate<=0 || GameModel.random()>_userate)) return false;
			}
			
			return true;
		}
		
		public function hasPriority(j:int):Boolean{
			for (var i:int=0;i<additionalPriorities.length;i+=1){
				if (additionalPriorities[i]==j) return true;
			}
			return false
		}
		
		public function addAdditionalPriority(_conditional:ConditionalBase){
			additionalPriorities.push(_conditional);
		}
		
		public function removeAdditionalPriorityIndex(i:int){
			additionalPriorities.splice(i,1);
		}
		
		public function setBasePriority(i:int=-1){
			if (i==-1){
				i=basePriority.getCurrentName();
			}
			basePriority.setBaseDistance(i,(source==null || target==SELF || hasTag(EffectData.LONG_RANGED)));
		}
		
		public function setMainPriority(a:Array){
			basePriority.selections=a;
		}
		
		public function getMainPriority():Array{
			return basePriority.selections;
		}
		
		public function getAdditionalPriorities():Array{
			var m:Array=new Array;
			for (var i:int=0;i<additionalPriorities.length;i+=1){
				m.push(additionalPriorities[i].toArray());
			}
			return m;
		}
		
		public function setAdditionalPriorities(a:Array){
			additionalPriorities=new Array;
			for (var i:int=0;i<a.length;i+=1){
				additionalPriorities.push(ConditionalBase.fromArray(a[i]));
			}
		}
		
		public function setDefaultPriorities(){
			additionalPriorities=[new ConditionalBase(0,0,[0,1])];
			priorityTier=3;
		}
		
		public static const FLYING_TEXT:int=0,
							ADD_ACTION:int=1,
							ADD_DEFEND:int=2,
							ADD_HEAL:int=3,
							ADD_EFFECT:int=4,
							SET_POSITIONS:int=5,
							DEFEND_SOUND:int=6,
							SOUND_HIT:int=7,
							ANIMATED:int=8;
							
							
		public function graphicEffect(_type:int,_v:SpriteModel,_obj:*){
			if (GameModel.SIMULATED) return;
			switch(_type){
				case FLYING_TEXT:
					switch(_obj){
						case SpriteView.IGNORED: new FlyingText(_v,"It didn't happen!",0x00ff00); break;
						case SpriteView.DODGE: case SpriteView.DODGE_LONG: new FlyingText(_v,FlyingText.MISS,0x00ff00);break;
						case SpriteView.BLOCK: new FlyingText(_v,FlyingText.BLOCK,0x00ff00); break;
						case SpriteView.TURN: new FlyingText(_v,FlyingText.TURN,0x00ff00); break;
						default: new FlyingText(_v,_obj,0xffffff); break;
					}
					break;
				case ADD_ACTION:
					Facade.gameUI.actionText.addAction(_v.label,_obj.label);
					break;
				case ADD_DEFEND:
					Facade.gameUI.actionText.addDefend(_obj.defended);
					break;
				case ADD_HEAL:
					Facade.gameUI.actionText.addHeal(_obj.damage);
					break;
				case ADD_EFFECT:
					Facade.gameUI.addEffect(_v,_obj);
					break;
				case SET_POSITIONS:
					Facade.gameUI.setPositions();
					break;
				case DEFEND_SOUND:
					Facade.soundC.actionDefended(_obj);
					break;
				case SOUND_HIT:
					Facade.soundC.actionHit(_obj);
					break;
				case ANIMATED:
					new AnimatedEffect(_v,_obj);
					break;
			}
		}
		
		public static const PLAYER_ACTION:int=0,
							PLAYER_BACK_TWO:int=1,
							PLAYER_FROM_ACTION:int=2,
							PLAYER_BACK_THREE:int=3,
							PLAYER_DEFENDED:int=4;
							
		public function playerEffect(_type:int,_v:SpriteModel,_obj:*){
			if (GameModel.SIMULATED) return;
			
			switch(_type){
				case PLAYER_ACTION:
					_v.view.action(_obj);
					break;
				case PLAYER_BACK_TWO: _v.view.backTwo(); break;
				case PLAYER_BACK_THREE: _v.view.backThree(); break;
				case PLAYER_FROM_ACTION:
					if (_obj.label==ActionData.ATTACK && _obj.source!=null && _obj.source.secondary==ItemData.RANGED){
						if (_obj.source.index==126 || _obj.source.index==129){
							_v.view.fromAction(_obj,2);
						}else{
							_v.view.fromAction(_obj,3);
						}
					}else{
						if (_obj.crit){
							var _crit:int=1;
						}else{
							_crit=0;
						}
						_v.view.fromAction(_obj,_crit);
					}
					break;
				case PLAYER_DEFENDED:
					_v.view.defended(_obj);
			}
		}
		
		public function getDesc():String{
			var m:String="";
			m+="<font color="+StringData.YELLOW+"><b>"+label+"</b></font>";
			if ((userate!=0)&&(userate<1)){
				m+="\n USE: <font color="+StringData.RED+"><b> +"+StringData.reduce(userate*100)+"%</b></font>";
			}
			
			m+=getEffectDescs();
			
			return m;
		}
		
		public function getEffectDescs():String{
			var m:String="";
			if (effects.length>0){
				for (var i:int=0;i<effects.length;i+=1){
					if (i>0)m+="\n";
					m+=effects[i].getDesc();
				}
				if (m.length>0){
					m="\n<font color="+StringData.YELLOW+"><b>Effects:</b></font>\n"+m;;
				}
			}
			return m;
		}
		
		public function getCEffectDescs():String{
			var m:String="";
			if (cEffects.length>0){
				for (var i:int=0;i<cEffects.length;i+=1){
					if (i>0)m+="\n";
					m+=cEffects[i].getDesc();
				}
				if (m.length>0){
					m="\n<font color="+StringData.YELLOW+"><b> Crit Effects:</b></font>\n"+m;;
				}
			}
			return m;
		}
	}
}