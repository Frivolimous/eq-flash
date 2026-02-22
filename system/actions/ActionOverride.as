package system.actions{
	import items.ItemModel;
	import items.ItemData;
	import system.buffs.BuffData;
	import system.buffs.BuffBase;
	import system.actions.ActionList;
	import system.actions.ActionPriorities;
	import system.actions.conditionals.ConditionalBase;
	import ui.effects.AnimatedEffect;
	
	public class ActionOverride extends ActionBase{
		public function ActionOverride(_label:String=null,_level:int=0,_userate:Number=0,_priority:int=0,_target:String=null,_damage:Number=0,_type:String=null,_effects:Array=null,_hitrate:Number=NaN,_critrate:Number=0,_critMult:Number=0,_cEffects:Array=null,_mana:int=0,_leech:Number=0,_dodgeReduce:Number=0){
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
		
		override public function modify(_v:SpriteModel,_random:Boolean=true):ActionBase{
			var _boost:int=0;
			specialEffect=null;
			if (isMagic()){
				var _effect:EffectModel=_v.stats.findDisplay(EffectData.SPELL_BOOST);
				if (_effect!=null){
					if (_random && _effect.checkRate()){
						_boost+=_effect.values;
						specialEffect=GAIA;
					}
				}
			}else if (isBuffing()){
				_effect=_v.stats.findDisplay(EffectData.BUFF_POT_BOOST);
				if (_effect!=null){
					if (_random && _effect.checkRate()){
						_boost+=_effect.values;
						specialEffect=GAIA;
					}
				}
			}
			if (isBuff()){
				_effect=_v.stats.findDisplay(EffectData.BUFF_BOOST);
				if (_effect!=null){
					if (_random && _effect.checkRate()){
						_boost+=_effect.values;
						specialEffect=GAIA;
					}
				}
			}
			
			var m:ActionBase=clone(_boost);
			m.specialEffect=specialEffect;
			
			if (isAttack()){
				m.addBase(_v.actionList.attack,true);
			}
			if (hasTag(EffectData.MONK_WEAPON)){
				m.addBase(_v.actionList.unarmed);
				m.damage+=_v.actionList.unarmed.damage;
			}
			
			_effect=m.findEffect(EffectData.BASE_DMG);
			if (_effect !=null){
				m.damage+=_effect.values;
			}
			if (hasTag(EffectData.RANGED) && Facade.gameM.distance!=GameModel.NEAR){
				m.damage/=2;
			}
			
			var _scaling:Number=0;
			
			if (_scaling==0){
				if (isInitiative()){
					_scaling=_v.stats.getValue(StatModel.INITIATIVE)/100;
					_effect=m.findEffect(EffectData.INITSCALING);
					if (_effect!=null){
						_scaling+=(_v.stats.getValue(StatModel.STRENGTH)-100)/100*_effect.values;
					}
					_effect=m.findEffect(EffectData.MPOWSCALINGADD);
					if (_effect!=null){
						_scaling+=(_v.stats.getValue(StatModel.MPOWER)-100)/100*_effect.values;
					}
				}else if (isAttack()){
					_effect=m.findEffect(EffectData.MPOWSCALING)
					if (_effect!=null){
						_scaling=_v.stats.getValue(StatModel.MPOWER)/100*_effect.values;
					}else{
						_scaling=_v.stats.getValue(StatModel.STRENGTH)/100;
					}
					_effect=m.findEffect(EffectData.INITSCALING);
					if (_effect!=null){
						_scaling+=(_v.stats.getValue(StatModel.INITIATIVE)-100)/100*_effect.values;
					}
					_effect=m.findEffect(EffectData.MPOWSCALINGADD);
					if (_effect!=null){
						_scaling+=(_v.stats.getValue(StatModel.MPOWER)-100)*_effect.values/100;
					}
					
					if (hasTag(EffectData.HALF_STRENGTH)){
						_scaling=(_scaling*0.5+0.5)
					}else if (hasTag(EffectData.BONUS_STRENGTH)){
						_scaling=(_scaling*1.5-0.5);
					}
				}else if (isMagic()){
					m.leech+=_v.stats.getValue(StatModel.SPELLSTEAL);
					m.dodgeReduce+=_v.stats.getValue(StatModel.TURN_REDUCE);
					if (hasTag(EffectData.HALF_MPOW)){
						_scaling=((100+_v.stats.getValue(StatModel.MPOWER))/200);
					}else{
						_scaling=_v.stats.getValue(StatModel.MPOWER)/100;
					}
					_effect=_v.stats.findDisplay(EffectData.INIT_SPELL);
					if (_effect!=null) _scaling+=(_v.stats.getValue(StatModel.INITIATIVE)-100)*_effect.values/100;
					
				}else if (source.primary==ItemData.POTION){
					if (target==SELF){
						_scaling=_v.stats.getValue(StatModel.POTEFF);
					}else{
						_scaling=_v.stats.getValue(StatModel.THROWEFF);
					}
				}else{
					_scaling=1;
				}
			}
			
			if (m.damage>0){
				if (_random){
					m.damage*=(1+_v.stats.drange*(GameModel.random()-0.5)*2)*_scaling;
				}else{
					m.damage*=_scaling;
				}
			}
			
			if (target==SELF && source.secondary!=ItemData.MANA) m.damage*=_v.stats.getValue(StatModel.HEALMULT);
			if (target==ENEMY){
				if (Facade.gameM.distance==GameModel.NEAR){
					m.damage*=_v.stats.getValue(StatModel.NEAR);
				}else{
					m.damage*=_v.stats.getValue(StatModel.FAR);
				}
			}
			
			if (m.hasEffect(EffectData.RANDOM_COLOR)){
				switch (Math.floor(GameModel.random()*4)){
					case 0: m.type=HOLY; break;
					case 1: m.type=CHEMICAL; break;
					case 2: m.type=PHYSICAL; break;
					case 3: m.type=MAGICAL; break;
				}
			}
			
			if (isConsumable()) m.damage*=_v.stats.getValue(StatModel.ITEMEFF);
			switch (m.type){
				case HOLY: m.damage*=_v.stats.getValue(StatModel.HOLYEFF);
				case CHEMICAL: m.damage*=_v.stats.getValue(StatModel.CHEMEFF);
				case PHYSICAL: m.damage*=_v.stats.getValue(StatModel.PHYSEFF);
				case MAGICAL: m.damage*=_v.stats.getValue(StatModel.MAGICEFF);
			}
			
			if (isAttack()){
				if (_random){
					if (m.critrate>0 && GameModel.random()<m.critrate){
						m.crit=true;
						m.damage*=m.critmult;
					}else{
						_effect=m.findEffect(EffectData.NONCRIT);
						if (_effect!=null){
							m.damage*=(1+_effect.values);
						}
					}
				}
			}
			
			if (isDouble()){
				m.double=true;
			}
			
			if (m.damage<0) m.damage=0;
			if (m.damage>0 && m.damage<1) m.damage=1;
			
			m.leech*=_v.stats.getValue(StatModel.HEALMULT);
			
			var _effects:Array=m.effects;
			m.effects=new Array;
			
			var _numQuicks:int=0; 
			for (var i:int=0;i<_effects.length;i+=1){
				if (_effects[i].name==EffectData.QUICK){
					if (isConsumable() || Facade.gameM.distance!=GameModel.NEAR) {
						 if (hasTag(EffectData.MONK_WEAPON)&&_numQuicks==0){
							//m.effects.push(EffectData.makeEffect(EffectData.DOUBLESHOT,_effects[i].level));
							//_numQuicks+=1;
						 }else if (Facade.gameM.distance==GameModel.FAR && label==ActionData.ATTACK && !hasTag(EffectData.RANGED)){
						 }else{
						 	continue;
						 }
					}
					_numQuicks+=1;
				}else if (_effects[i].name==EffectData.LEAP_ATTACK){
					if (label==ActionData.ATTACK && source!=null && source.secondary!=ItemData.RANGED){
						//m.basePriority.addLeap(true);
					}else{
						continue;
					}
				}
				m.effects.push(_effects[i].modify(_v,m));
			}
			
			var _cEffects:Array=m.cEffects;
			m.cEffects=new Array;
			for (i=0;i<_cEffects.length;i+=1){
				m.cEffects.push(_cEffects[i].modify(_v,m));
			}
			
			return m;
		}
		
		override public function useAction2(_o:SpriteModel,_t:SpriteModel){
			if (_t!=null){
				//set up post-animation values
				if (this is ActionAttack && (this as ActionAttack).willLeap(_o)){
					var _effect:EffectModel=findEffect(EffectData.LEAP_ATTACK);
					_o.buffList.addBuff(_effect.values);
					Facade.effectC.buffEffects(_o.stats.effects,_o,this,Facade.actionC.dmgModel);
					_o.eDistance=GameModel.NEAR;
					finishAction(_o,Facade.actionC.attack,_t,this);
					playerEffect(PLAYER_ACTION,_o,SpriteView.LEAP);
				}else{
					if ((label==ActionData.ATTACK && _o.eDistance==GameModel.NEAR) || label==ActionData.BASH){
						finishAction(_o,Facade.actionC.attack,_t,this);
					}
					
					//which animation?
					
					playerEffect(PLAYER_FROM_ACTION,_o,this);
				}
			}
		}
		
		override public function postAnim(_o:SpriteModel,_t:SpriteModel){
			if (defended!=null){
				graphicEffect(ActionBase.FLYING_TEXT,_t,defended);
				
				Facade.effectC.defendEffects(_t.stats.effects,_t,_o,this);
				Facade.effectC.defendProcs(effects,_o,_t,this);
				
				if (double){
					graphicEffect(ActionBase.ADD_DEFEND,_o,this);
				}
				graphicEffect(ActionBase.DEFEND_SOUND,_v,defended);
			}else{
				if (damage>0){
					dmgModel.setDmg(damage*_o.stats.getValue(StatModel.DMGMULT),type,crit);
				}
				
				var _reflect:EffectModel=_t.stats.findDisplay(EffectData.CURSE_REFLECT);
				if (_reflect!=null && isCurse() && _reflect.checkRate()){
					var _temp:SpriteModel=_o;
					_o=_t;
					_t=_temp;
				}
				
				Facade.effectC.applyEffects(effects,this,_o,_t);
				dmgModel.addLeech(leech,type);
				dmgModel.applyDamage(_o,_t,true);
				
				playerEffect(ActionBase.SOUND_HIT,_v,label);
				playerEffect(ActionBase.PLAYER_ACTION,_t,SpriteView.HURT);
				
				Facade.effectC.hitEffects(_t.stats.effects,_t,_o,this);
			}
			
			if (double){
				var _action:ActionBase=_o.actionList.getAttack().modify(_o);
				_action.double=false;
				_action.finishAction(_o,_action.attack,_t);
				graphicEffect(ActionBase.SET_POSITIONS,_o,null);
			}else{
				checkStrike(_o,_t);
			}
		}
		
		override public function makeProjectile(_o:SpriteModel,_t:SpriteModel){
			var _projM:ProjectileObject=new ProjectileObject(this,_o,_t);
			gameM.projectiles.push(_projM);
			
			if (_o.shots==0){
				for (i=0;i<effects.length;i+=1){
					if (effects[i].name==EffectData.MULTI){
						if (_o.shots==0) _o.shots+=1;
						_o.shots+=effects[i].values;
					}
				}
				
				if (isProjectile() || isGrenade() || (this is ActionAttack && !(this as ActionAttack).willLeap() && gameM.distance!=GameModel.NEAR)){
					for (var i:int=0;i<_o.stats.displays.length;i+=1){
						if (_o.stats.displays[i].name==EffectData.DOUBLESHOT && _o.stats.displays[i].checkRate()){
							if (_o.shots==0) _o.shots+=1;
							_o.shots+=_o.stats.displays[i].values;
						}
					}
				}
			}
			
			if (_o.shots>1){
				_o.shots-=1;
				
				if (_o.mana<mana){
					_o.shots=0;
					return;
				}
				if (source.charges>=0 && source.charges<chargeCost()){
					_o.shots=0;
					return;
				}
				
				if (mana>0){
					_o.mana-=mana;
					effectC.checkAutoMana(_o);
				}
				
				if (source.charges>=0){
					source.charges-=chargeCost();
				}
				
				if (source.index==125 || source.index==134){
					switch(_o.shots){
						case 2: case 5: _projM.type=ProjectileObject.REVERSE_ARC; break;
						case 1: case 4: _projM.type=ProjectileObject.ARC; break;
						case 0: case 3: break;
					}
				}
				
				if (source.index==128 || source.index==125){
					playerEffect(PLAYER_BACK_TWO,_o,null);
				}else{
					playerEffect(PLAYER_BACK_THREE,_o,null);
				}
				
				var _action:ActionBase=source.action.modify(_o);
				_action.finishAction(_o,_action.makeProjectile,_t);
			}else{
				_o.shots=0;
			}
		}
		
		override public function setDefense(_o:SpriteModel,_t:SpriteModel){
			if (_t==null || target!=ENEMY) return;
			
			var _bonusHit:Number=0;
			var _toFeather:Boolean=false
			if (isAttack() && _o.strike==0 && (!isDouble() || double)){
				_effect=_o.stats.findDisplay(EffectData.FEATHER_HIT);
				if (_effect!=null){
					_bonusHit+=_effect.values;
					_toFeather=true;
				}
			}
			if ((isAttack() || isGrenade()) && GameModel.random()<(_t.stats.getValue(StatModel.DODGE)-dodgeReduce)){
				if (isAttack()){
					defended=SpriteView.DODGE;
				}else{
					defended=SpriteView.DODGE_LONG;
				}
			}else if (isAttack() && GameModel.random()>toHit(_t.stats.getValue(StatModel.BLOCK),_bonusHit)){
				defended=SpriteView.BLOCK;
			}else if (isMagic() && (GameModel.random()<(_t.stats.getValue(StatModel.TURN)-dodgeReduce))){
				defended=SpriteView.TURN;
			}
			if (defended==null){
				if (_toFeather){
					Facade.effectC.graphicEffect(EffectControl.ANIMATED,_t,ui.effects.AnimatedEffect.FEATHERS);
				}
				var _effect:EffectModel=_t.stats.findDisplay(EffectData.IGNORE_ATTACK);
				if (_effect!=null && !_t.buffList.hasBuff(BuffData.ATTACK_IGNORED)){
					defended=SpriteView.IGNORED;
					_t.buffList.addBuff(_effect.values.modify(_t));
				}
			}
			
			//if thrown, delay 3;
			//block always delay 2;
			//turn projectile delay 3;
			if (defended!=null){
				playerEffect(PLAYER_DEFENDED,_t,defended);
			}
		}
		
		override public function clone(_boost:int=0):ActionBase{
			if (source!=null  && source.index>=0){
				var _item:ItemModel=ItemData.spawnItem(source.level+_boost,source.index,source.charges);
				if (source.enchantIndex>=0){
					ItemData.enchantItem(_item,source.enchantIndex);
				}
				var m:ActionBase=_item.action;
			}else{
				m=ActionData.makeAction(label,level+_boost);
			}
			m.source=source;
			
			return m;
		}
		
		override public function fullUse(_v:SpriteModel):Number{
			var m:Number=userate;
			if (isMagic()){
				m=addMult(m,_v.mana/_v.stats.getValue(StatModel.MANA)/5);
				m=addMult(m,_v.stats.getValue(StatModel.MRATE));
			}
			if (isConsumable()){
				m=addMult(m,_v.stats.getValue(StatModel.IRATE));
				if (isDrinking()){
					m=addMult(m,_v.stats.getValue(StatModel.PRATE));
				}else if (isGrenade()){
					m=addMult(m,_v.stats.getValue(StatModel.TRATE));
				}
			}
			return m;
		}
		
		//===================PRIORITIES==========================\\
		
		override public function canUse(_o:SpriteModel,_t:SpriteModel,_distance:String=null):Boolean{
			if (_distance==null) _distance=Facade.gameM.distance;
			if (hasEffect(EffectData.FULL_POWER) && _o.healthPercent()<0.75 && _distance!=GameModel.NEAR) return false;
			
			if (target==ENEMY && _t==null) return false;
			if (!checkCanDistance(_distance)){
				if (label==ActionData.ATTACK){
					if (!_o.actionList.attack.willLeap(_o,_distance)){
						return false;
					}
				}else{
					return false;
				}
			}
			//if (!checkCanDistance(_distance)) return false;
			
			if (isMelee() && _o.equipment[0]!=null && _o.equipment[0].hasTag(EffectData.NO_ATTACK)) return false;
			
			for (var i:int=0;i<_o.buffList.numBuffs();i+=1){
				switch(_o.buffList.getBuff(i).name){ //limited actions
					case BuffData.RUSHED: if (label!=ActionData.APPROACH && (target==SELF  || damage==0)) return false;
						break;
					case BuffData.AIMING: if (target==SELF || damage==0|| label==ActionData.APPROACH || label==ActionData.WITHDRAW){ return false; }
						break;
					case BuffData.BERSERK: if ((label!=ActionData.APPROACH) && (label!=ActionData.ATTACK) && (label!=ActionData.WALK)) {return false;}
						break;
					case BuffData.ROOTED: case BuffData.IVY:
						if ((label==ActionData.APPROACH) || (label==ActionData.ATTACK && willLeap(_o,_distance)) || (label==ActionData.WITHDRAW) || (label==ActionData.WALK)) {return false;}
						break;
					case BuffData.SILENCED: if (isMagic()) {return false;}
						break;
				}
			}
			
			if (mana>0 && _o.mana<mana){
				return false; //cant pay mana cost
			}
			
			if (source.charges>=0 && source.charges<chargeCost()){
				return false;
			}
			
			return true;
		}
		
override public function wantUse(_o:SpriteModel,_t:SpriteModel,_distance:String=null,_rate:Boolean=true):Boolean{
			if (_distance==null) _distance=_o.eDistance;
			if (!checkDistance(_distance)) return false;
			
			for (var i:int=0;i<additionalPriorities.length;i+=1){
				if (!additionalPriorities[i].testThis(_o,_t,this)) return false;
			}
			
			if (_rate){
				var _userate:Number=fullUse(_o);
				if (_userate<1 && (_userate<=0 || GameModel.random()>_userate)) return false;
			}
			
			if (damage==0){
				//if it doesn't deal damage, check if already has effect
				if (effects.length>0 && effects[0].values!=null && (effects[0].values is BuffBase)){
					//buffs and not instant effects
					if (target==ActionBase.SELF){
						if (_o.buffList.hasBuff(effects[0].values.name)){
							return false; //self has buffs
						}
					}else {
						if (_t.buffList.hasBuff(effects[0].values.name)){
							return false;
						}
					}
				}
			}
			return true;
		}
		
		override public function setDefaultPriorities(){
			switch(label){
				case ActionData.HEALING: case ActionData.HEAL_GRAIL: case ActionData.HEALING_POT:
					additionalPriorities=[new ConditionalBase(1,0,[2,3,4])];
					priorityTier=1;
					break;
				case ActionData.MANA_POT:
					additionalPriorities=[new ConditionalBase(1,1,[2,3,4])];
					priorityTier=1;
					break;
				case ActionData.MANA_PENTA:
					additionalPriorities=[new ConditionalBase(1,1,[3,4])];
					priorityTier=1;
					break;
				case ActionData.RECOVERY_POT:
					additionalPriorities=[new ConditionalBase(1,0,[1,2,3,4]),new ConditionalBase(1,1,[1,2,3,4])];
					priorityTier=1;
					break;
				case ActionData.ATTACK:
					additionalPriorities=[new ConditionalBase(0,0,[0,1])];
					priorityTier=4;
					break;
				case ActionData.WITHDRAW:
					additionalPriorities=[];
					priorityTier=0;
					break;
				case ActionData.APPROACH:
					additionalPriorities=[];
					priorityTier=5;
					break;
				default:
					additionalPriorities=[new ConditionalBase(0,0,[0,1])];
					if (damage==0){
						priorityTier=2;
					}else{
						priorityTier=3;
					}
					break;
			}
			
			if (target==SELF || damage==0){
				additionalPriorities.push(new ConditionalBase(3,0,[0,1,2,3,4,5,6,7]));
			}
		}
		
		public function getDesc():String{
			var m:String="";
			m+="<font color="+StringData.YELLOW+"><b>"+label+"</b></font>";
			if ((userate>0)&&(userate<1)){
				m+="\n USE: <font color="+StringData.RED+"><b> +"+StringData.reduce(userate*100)+"%</b></font>";
			}
			
			if (damage!=0){
				if (source.secondary==ItemData.HEALING){
					if (source.primary==ItemData.TRINKET){
						m+="\n HEALING: <font color="+StringData.RED+"><b>"+Math.floor(damage*100)+"% ";
					}else{
						m+="\n HEALING: <font color="+StringData.RED+"><b>"+Math.round(damage)+" ";
						if (type>-1) m+=ActionBase.statNames[type];
					}
				}else if(source.secondary==ItemData.MANA){
					if (source.primary==ItemData.TRINKET){
						m+="\n MANA: <font color="+StringData.RED+"><b>"+Math.floor(damage*100)+"% ";
					}else{
						m+="\n MANA: <font color="+StringData.RED+"><b>"+Math.round(damage)+" ";
						if (type>-1) m+=ActionBase.statNames[type];
					}
				}else if (source.secondary==ItemData.RECOVERY){
					m+="\n HEALTH: <font color="+StringData.RED+"><b>"+Math.round(damage)+"</b></font>";
					m+="\n MANA: <font color="+StringData.RED+"><b>"+Math.floor(damage*0.35)+" ";
				}else{
					m+="\n DMG: <font color="+StringData.RED+"><b>"+Math.round(damage)+" "+ActionBase.statNames[type];
				}
				if (source.secondary==ItemData.DOUBLE) m+=" x2";
				m+="</b></font>";
			}
			
			if (mana!=0){
				m+="\n MANA: <font color="+StringData.RED+"><b>"+mana+"</b></font>";
			}
			
			if (!isNaN(hitrate)&&(hitrate<1000)&&(hitrate!=0)){
				m+="\n HIT: <font color="+StringData.RED+"><b>+"+hitrate+"</b></font>";
			}
			if (leech>0){
				m+="\n LEECH: <font color="+StringData.RED+"><b>+"+StringData.reduce(leech*100)+"%</b></font>";
			}
			if (dodgeReduce>0){
				if (isMagic()){
					m+="\n SPELL PEN: ";
				}else{
					m+="\n ACCURACY: ";
				}
				m+="<font color="+StringData.RED+"><b>+"+StringData.reduce(dodgeReduce*100)+"%</b></font>";
			}
			if (effects.length>0){
				var _temp:String="";
				for (var i:int=0;i<effects.length;i+=1){
					_temp+=StringData.effectDesc(effects[i]);
				}
				if (_temp.length>0){
					m+="\n<font color="+StringData.YELLOW+"><b>Effects:</b></font>\n";
					m+=_temp;
				}
			}
			if (critrate>0){
				//if (effects.length>0) m+="\n";
				
				m+="\n CRIT: <font color="+StringData.RED+"><b>+"+StringData.reduce(critrate*100)+"%</b></font>";
			}
			if (critmult!=0 && !isNaN(critmult)){
				m+="\n C.MULT: <font color="+StringData.RED+"><b>"+(critmult>0?"+":"")+StringData.reduce(critmult*100)+"%</b></font>";
			}
			if ((cEffects!=null)&&(cEffects.length>0)){
				m+="\n<font color="+StringData.YELLOW+"><b> Crit Effects:</b></font>\n";
				for (i=0;i<cEffects.length;i+=1){
					m+=StringData.effectDesc(cEffects[i]);
				}
			}
			return m;
		}
	}
}