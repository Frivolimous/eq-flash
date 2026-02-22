package system.actions{
	import items.ItemModel;
	import items.ItemData;
	import system.buffs.BuffData;
	import system.buffs.BuffBase;
	import system.actions.ActionList;
	import system.actions.ActionPriorities;
	import system.actions.conditionals.ConditionalBase;
	import ui.effects.AnimatedEffect;
	import ui.effects.PopEffect;
	import system.effects.EffectBase;
	import system.effects.EffectData;
	import system.effects.EffectBuff;
	
	public class ActionAttack extends ActionBase{
		public function ActionAttack(_priority:int,_damage:Number,_type:int,_effects:Vector.<EffectBase>=null,_hitrate:Number=0,_critrate:Number=0,_critMult:Number=0,_cEffects:Vector.<EffectBase>=null,_leech:Number=0,_dodgeReduce:Number=0,_tags:Array=null){
			baseStats();
			label=ActionData.ATTACK;
			level=0;
			userate=1;
			target=ActionBase.ENEMY;
			
			level=0;
			damage=_damage;
			type=_type;
			hitrate=_hitrate;
			critrate=_critrate;
			critmult=_critMult;
			if (_effects!=null) effects=_effects;
			if (_cEffects!=null) cEffects=_cEffects;
			if (_tags!=null) tags=_tags;
			leech=_leech;
			dodgeReduce=_dodgeReduce;
			source=ActionData.DEFAULT;
			
			basePriority.setBaseDistance(_priority,false);
			setDefaultPriorities();
		}
		
		override public function modify(_v:SpriteModel,_random:Boolean=true):ActionBase{
			if (_random){
				var m:ActionBase=clone(getBoost(_v));
			}else{
				m=clone();
			}
			
			if (hasTag(EffectData.MONK_WEAPON)){
				m.addBase(_v.actionList.unarmed);
			}
			
			m.addBase(_v.actionList.attack,true);
			
			m.hitrate+=m.furytohit*_v.fury;
			m.critrate+=m.furytocrit*_v.fury;
			
			var _effect:EffectBase=m.findEffect(EffectData.BASE_DMG);
			if (_effect !=null){
				m.damage+=_effect.values;
			}
			if (hasTag(EffectData.RANGED) && _v.eDistance!=GameModel.NEAR){
				m.damage/=2;
			}
			
			var _effects:Vector.<EffectBase>=m.effects;
			m.effects=new Vector.<EffectBase>;
			var _numQuicks:int=0; 
			for (var i:int=0;i<_effects.length;i+=1){
				if (_effects[i].name==EffectData.QUICK){
					if (isConsumable() || _v.eDistance!=GameModel.NEAR) {
						 if (hasTag(EffectData.MONK_WEAPON)&&_numQuicks==0){
						 }else if (_v.eDistance==GameModel.FAR && !hasTag(EffectData.RANGED) && !hasTag(EffectData.LONG_RANGED)){
						 }else{
							continue;
						 }
					}
					_numQuicks+=1;
				}else if (_effects[i].name==EffectData.LEAP_ATTACK){
					if (source!=null && source.secondary!=ItemData.RANGED){
					}else{
						continue;
					}
				}
				m.effects.push(_effects[i].modify(_v,m));
			}
			
			if (_v.stats.procs.length>0){
				m.effects=m.effects.concat(_v.stats.modProcs(_v,this));
			}
			
			if (_random){
				m.damage*=(1+_v.stats.drange*(GameModel.random()-0.5)*2);
				
				if (m.critrate>0 && GameModel.random()<m.critrate){
					m.crit=true;
					if (m.cEffects.length>0){
						for (i=0;i<m.cEffects.length;i+=1){
							if (m.cEffects[i].name==EffectData.BLOODLUST){
								if (_v.fury>=50){
									m.damage+=m.cEffects[i].userate;
									m.leech+=m.cEffects[i].values;
								}else{
									continue;
								}
							}
							m.effects.push(m.cEffects[i].modify(_v,m));
						}
					}
					
					m.damage*=m.critmult;
					dmgModel.after=PopEffect.CRIT;
				}else{
					_effect=m.findEffect(EffectData.NONCRIT);
					if (_effect!=null){
						m.damage*=(1+_effect.values);
					}
				}
			}else{
				_effects=m.cEffects;
				m.cEffects=new Vector.<EffectBase>;
				for (i=0;i<_effects.length;i+=1){
					m.cEffects.push(_effects[i].modify(_v,m));
				}
			}
			
			var _scaling:Number=0;
			
			_effect=m.findEffect(EffectData.MPOWSCALING)
			if (_effect!=null){
				_scaling=_v.stats.getValue(StatModel.MPOWER)/100*_effect.values;
			}
			
			if (m.isInitiative()){
				if (_scaling==0) _scaling=_v.stats.getValue(StatModel.INITIATIVE)/100;
				
				_effect=m.findEffect(EffectData.INITSCALING);
				if (_effect!=null){
					_scaling+=(_v.stats.getValue(StatModel.STRENGTH)-100)/100*_effect.values;
				}
				_effect=m.findEffect(EffectData.MPOWSCALINGADD);
				if (_effect!=null){
					_scaling+=(_v.stats.getValue(StatModel.MPOWER)-100)/100*_effect.values;
				}
			}else{
				if (_scaling==0) _scaling=_v.stats.getValue(StatModel.STRENGTH)/100;
				
				_effect=m.findEffect(EffectData.INITSCALING);
				if (_effect!=null){
					_scaling+=(_v.stats.getValue(StatModel.INITIATIVE)-100)/100*_effect.values;
				}
				_effect=m.findEffect(EffectData.MPOWSCALINGADD);
				if (_effect!=null){
					_scaling+=(_v.stats.getValue(StatModel.MPOWER)-100)/100*_effect.values;
				}
				
				if (hasTag(EffectData.HALF_STRENGTH)){
					_scaling=(_scaling*0.5+0.5)
				}else if (hasTag(EffectData.BONUS_STRENGTH)){
					_scaling=(_scaling*1.5-0.5);
				}
			}
			m.damage*=_scaling;
			
			if (_v.eDistance==GameModel.NEAR || (_v.eDistance==GameModel.FAR && (m as ActionAttack).willLeap(_v,_v.eDistance))){
				m.damage*=_v.stats.getValue(StatModel.NEAR);
			}else{
				m.damage*=_v.stats.getValue(StatModel.FAR);
			}
			
			if (m.hasEffect(EffectData.RANDOM_COLOR)){
				switch (Math.floor(GameModel.random()*4)){
					case 0: m.type=DamageModel.HOLY; break;
					case 1: m.type=DamageModel.CHEMICAL; break;
					case 2: m.type=DamageModel.PHYSICAL; break;
					case 3: m.type=DamageModel.MAGICAL; break;
				}
			}
			
			switch (m.type){
				case DamageModel.HOLY: m.damage*=_v.stats.getValue(StatModel.HOLYEFF); break;
				case DamageModel.CHEMICAL: m.damage*=_v.stats.getValue(StatModel.CHEMEFF); break;
				case DamageModel.PHYSICAL: m.damage*=_v.stats.getValue(StatModel.PHYSEFF); break;
				case DamageModel.MAGICAL: m.damage*=_v.stats.getValue(StatModel.MAGICEFF); break;
				case DamageModel.DARK: m.damage*=_v.stats.getValue(StatModel.DARKEFF); break;
			}
			
			if (isDouble()){
				m.double=true;
			}
			
			if (m.damage<0){
				m.damage=0;
			}else if (m.damage<1){
				m.damage=1;
			}
			
			m.leech*=_v.stats.getValue(StatModel.HEALMULT);
			
			return m;
		}
		
		override public function useAction2(_o:SpriteModel,_t:SpriteModel){
			if (_t!=null){
				if (willLeap(_o)){
					var _effect:EffectBase=findEffect(EffectData.LEAP_ATTACK);
					_o.buffList.addBuff((_effect as EffectBuff).buff);
					_o.stats.useEffects(EffectBase.TRIGGER_SELF,new DamageModel,_o,_o.attackTarget,this);
					_o.eDistance=GameModel.NEAR;
					finishAction(_o,postAnim,_t);
					playerEffect(PLAYER_ACTION,_o,SpriteView.LEAP);
				}else{
					if (_o.eDistance==GameModel.NEAR){
						finishAction(_o,postAnim,_t);
					}else{
						finishAction(_o,makeProjectile,_t);
					}
					
					//which animation?
					
					playerEffect(PLAYER_FROM_ACTION,_o,this);
				}
			}
		}
		
		override public function makeProjectile(_o:SpriteModel,_t:SpriteModel){
			var _projM:ProjectileObject=new ProjectileObject(this,_o,_t);
			Facade.gameM.projectiles.push(_projM);
			
			if (_o.shots==0){
				for (i=0;i<effects.length;i+=1){
					if (effects[i].name==EffectData.MULTI || effects[i].name==EffectData.CHAIN){
						if (_o.shots==0) _o.shots+=1;
						_o.shots+=effects[i].values;
					}
				}
				
				if (!(this as ActionAttack).willLeap() && _o.eDistance!=GameModel.NEAR){
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
				
				if (source.index==128){
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
			var _bonusHit:Number=0;
			var _toFeather:Boolean=false;
			if (isAttack() && _o.strike==0 && (!isDouble() || double)){
				var _effect:EffectBase=_o.stats.findDisplay(EffectData.FEATHER_HIT);
				if (_effect!=null){
					_bonusHit+=_effect.values;
					_toFeather=true;
				}
			}
			var _avoid:Number=_t.stats.getValue(StatModel.DODGE)
			if (Facade.gameM.distance!=GameModel.NEAR){
				_avoid=StatModel.addMult(_avoid,_t.stats.getValue(StatModel.FAR_AVOID));
			}
			_avoid-=dodgeReduce;
			if (GameModel.random()<_avoid){
				if (Facade.gameM.distance==GameModel.NEAR){
					defended=SpriteView.DODGE;
				}else{
					defended=SpriteView.DODGE_LONG;
				}
			}else if (GameModel.random()>toHit(_t.stats.getValue(StatModel.BLOCK),_bonusHit)){
				defended=SpriteView.BLOCK;
			}
			
			if (defended==null){
				if (_toFeather){
					graphicEffect(ActionBase.ANIMATED,_t,ui.effects.AnimatedEffect.FEATHERS);
				}
			}else{
				playerEffect(ActionBase.PLAYER_DEFENDED,_t,defended);
			}
		}
		
		override public function postAnim(_o:SpriteModel,_t:SpriteModel){
			if (defended!=null){
				graphicEffect(ActionBase.FLYING_TEXT,_t,defended);
				
				_t.stats.useEffects(EffectBase.DEFENSE,new DamageModel,_t,_o,this);
				useEffects(EffectBase.DEFENSE,_o,_t,dmgModel,true);
									
				if (double){
					graphicEffect(ActionBase.ADD_DEFEND,_o,this);
				}
				graphicEffect(ActionBase.DEFEND_SOUND,_o,defended);
			}else{
				if (damage>0){
					dmgModel.setDmg(damage*_o.stats.getValue(StatModel.DMGMULT),type,crit);
				}
				
				dmgModel.addLeech(leech,type);
				useEffects(EffectBase.HURT,_o,_t,dmgModel,true);
				
				playerEffect(ActionBase.SOUND_HIT,_o,label);
				playerEffect(ActionBase.PLAYER_ACTION,_t,SpriteView.HURT);
				
				_t.stats.useEffects(EffectBase.HURT,new DamageModel,_t,_o,this);
			}
			
			if (double){
				var _action:ActionBase=_o.actionList.getAttack().modify(_o);
				_action.double=false;
				_action.finishAction(_o,_action.postAnim,_t);
				graphicEffect(ActionBase.SET_POSITIONS,_o,null);
			}else{
				checkStrike(_o,_t);
			}
		}
		
		override public function clone(_boost:int=0):ActionBase{
			var m:ActionAttack=new ActionAttack(basePriority.basePriorityList,damage,type,effects,hitrate,critrate,critmult,cEffects,leech,dodgeReduce,tags);
			m.hitmult=hitmult;
			m.furytocrit=furytocrit;
			m.furytohit=furytohit;
			m.source=source;
			m.specialEffect=specialEffect;
			
			return m;
		}
		
		//===================PRIORITIES==========================\\
		
		override public function checkDistance(_distance:String):Boolean{
			if (willLeap(null,_distance)) return true;
			return basePriority.testDistance(_distance);			
		}
		
		override public function checkCanDistance(_distance:String):Boolean{
			if (willLeap(null,_distance)) return true;
			return basePriority.testCanDistance(_distance);
		}
		
		public function willLeap(_o:SpriteModel=null,_distance:String=null):Boolean{
			if (_distance==null){
				if (_o!=null){
					_distance=_o.eDistance;
				}else{
					_distance=Facade.gameM.distance;
				}
			}
			
			if (_distance!=GameModel.FAR) return false;
			if (!hasEffect(EffectData.LEAP_ATTACK)) return false;
			if (hasTag(EffectData.RANGED)){
				if (_o!=null && (!hasEffect(EffectData.FULL_POWER) || _o.healthPercent()>=0.75)){
					return false;
				}
			}
			if (_o!=null && _o.buffList.hasBuff(BuffData.RUSHED)) return false;
			return true;
		}
		
		override public function canUse(_o:SpriteModel,_t:SpriteModel,_distance:String=null):Boolean{
			if (_distance==null) _distance=_o.eDistance;
			if (hasEffect(EffectData.FULL_POWER) && _o.healthPercent()<0.75 && _distance!=GameModel.NEAR) return false;
			
			if (_t==null) return false;
			if (!checkCanDistance(_distance)){
				if (!_o.actionList.attack.willLeap(_o,_distance)){
					return false;
				}
			}
			//if (!checkCanDistance(_distance)) return false;
			
			if (isMelee() && _o.equipment[0]!=null && _o.equipment[0].hasTag(EffectData.NO_ATTACK)) return false;
			
			for (var i:int=0;i<_o.buffList.numBuffs();i+=1){
				switch(_o.buffList.getBuff(i).name){ //limited actions
					case BuffData.ROOTED: case BuffData.IVY: case BuffData.TRAP: 
						if (willLeap(_o,_distance)) return false;
						break;
					case BuffData.INITIAL_NO_OFFENSIVE: return false;
				}
			}
			
			return true;
		}
		
		override public function wantUse(_o:SpriteModel,_t:SpriteModel,_distance:String=null,_rate:Boolean=true):Boolean{
			if (_distance==null) _distance=_o.eDistance;
			if (!checkDistance(_distance)){
				if (!_o.actionList.attack.willLeap(_o,_distance)){
					return false;
				}
			}
			
			for (var i:int=0;i<additionalPriorities.length;i+=1){
				if (!additionalPriorities[i].testThis(_o,_t,this)) return false;
			}
			
			return true;
		}
		
		override public function setBasePriority(i:int=-1){
			if (i==-1){
				i=basePriority.getCurrentName();
			}
			basePriority.setBaseDistance(i,(source==null || hasTag(EffectData.LONG_RANGED)));
		}
		
		override public function setDefaultPriorities(){
			additionalPriorities=[new ConditionalBase(0,0,[0,1])];
			priorityTier=4;
		}
		
		override public function getDesc():String{
			var m:String="";
			m+="<font color="+StringData.YELLOW+"><b>"+label+"</b></font>";
			
			m+="\n DMG: <font color="+StringData.RED+"><b>"+Math.round(damage)+" "+ActionBase.statNames[type];
			if (source.secondary==ItemData.DOUBLE) m+=" x2";
			m+="</b></font>";
			
			if (hitrate!=0) m+="\n HIT: <font color="+StringData.RED+"><b>"+(hitrate>0?"+":"")+getValue(HITRATE)+"</b></font>";
			if (leech!=0) m+="\n LEECH: <font color="+StringData.RED+"><b>"+(leech>0?"+":"")+StringData.reduce(leech*100)+"%</b></font>";
			if (dodgeReduce!=0) m+="\n ACCURACY: <font color="+StringData.RED+"><b>"+(dodgeReduce>0?"+":"")+StringData.reduce(dodgeReduce*100)+"%</b></font>";
			
			m+=getEffectDescs();
			
			if (critrate!=0) m+="\n CRIT: <font color="+StringData.RED+"><b>"+(critrate>0?"+":"")+StringData.reduce(critrate*100)+"%</b></font>";
			if (critmult!=0) m+="\n C.MULT: <font color="+StringData.RED+"><b>"+(critmult>0?"+":"")+StringData.reduce(critmult*100)+"%</b></font>";
			
			m+=getCEffectDescs();
			
			return m;
		}
	}
}