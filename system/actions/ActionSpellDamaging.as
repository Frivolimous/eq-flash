package system.actions{
	import items.ItemModel;
	import items.ItemData;
	import system.buffs.BuffData;
	import system.buffs.BuffBase;
	import system.actions.ActionList;
	import system.actions.ActionPriorities;
	import system.actions.conditionals.ConditionalBase;
	import system.effects.EffectBase;
	import system.effects.EffectData;
	import ui.effects.AnimatedEffect;
	
	public class ActionSpellDamaging extends ActionBase{
		public function ActionSpellDamaging(_label:String=null,_level:int=0,_damage:Number=0,_type:int=-1,_effects:Vector.<EffectBase>=null,_mana:int=0,_tags:Array=null){
			if (_label!=null){
				baseStats();
				label=_label;
				level=_level;
				userate=0;
				target=ENEMY;
				damage=_damage;
				type=_type;
				if (_effects!=null) effects=_effects;
				if (_tags!=null) tags=_tags;
				
				mana=_mana;
				basePriority.setBaseDistance(ActionPriorities.COMBAT,false);
				setDefaultPriorities();
				
				source=ActionData.DEFAULT;
			}
		}
		
		override public function modify(_v:SpriteModel,_random:Boolean=true):ActionBase{
			if (_random){
				var m:ActionBase=clone(getBoost(_v));
			}else{
				m=clone();
			}
			
			var _effect:EffectBase=m.findEffect(EffectData.BASE_DMG);
			if (_effect !=null){
				m.damage+=_effect.values;
			}
			
			m.leech+=_v.stats.getValue(StatModel.SPELLSTEAL);
			m.dodgeReduce+=_v.stats.getValue(StatModel.TURN_REDUCE);
				
			var _scaling:Number=0;
			
			if (_scaling==0){
				if (hasTag(EffectData.HALF_MPOW)){
					_scaling=((100+_v.stats.getValue(StatModel.MPOWER))/200);
				}else{
					_scaling=_v.stats.getValue(StatModel.MPOWER)/100;
				}
				_effect=_v.stats.findDisplay(EffectData.INIT_SPELL);
				if (_effect!=null) _scaling+=(_v.stats.getValue(StatModel.INITIATIVE)-100)*_effect.values/100;
			}
			
			if (_random){
				m.damage*=(1+_v.stats.drange*(GameModel.random()-0.5)*2)*_scaling;
			}else{
				m.damage*=_scaling;
			}
			
			if (Facade.gameM.distance==GameModel.NEAR){
				m.damage*=_v.stats.getValue(StatModel.NEAR);
			}else{
				m.damage*=_v.stats.getValue(StatModel.FAR);
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
				case DamageModel.HOLY: m.damage*=_v.stats.getValue(StatModel.HOLYEFF); break;
				case DamageModel.CHEMICAL: m.damage*=_v.stats.getValue(StatModel.CHEMEFF); break;
				case DamageModel.PHYSICAL: m.damage*=_v.stats.getValue(StatModel.PHYSEFF); break;
				case DamageModel.MAGICAL: m.damage*=_v.stats.getValue(StatModel.MAGICEFF); break;
				case DamageModel.DARK: m.damage*=_v.stats.getValue(StatModel.DARKEFF); break;
			}
			
			if (m.damage<0) m.damage=0;
			if (m.damage>0 && m.damage<1) m.damage=1;
			
			m.leech*=_v.stats.getValue(StatModel.HEALMULT);
			
			var _effects:Vector.<EffectBase>=m.effects;
			m.effects=new Vector.<EffectBase>;
			for (var i:int=0;i<_effects.length;i+=1){
				m.effects[i]=_effects[i].modify(_v,m);
			}
			
			if (_v.stats.procs.length>0){
				m.effects=m.effects.concat(_v.stats.modProcs(_v,this));
			}
			
			return m;
		}
		
		override public function useAction2(_o:SpriteModel,_t:SpriteModel){
			if (_t!=null){
				finishAction(_o,makeProjectile,_t);
				playerEffect(PLAYER_FROM_ACTION,_o,this);
			}
		}
		
		override public function makeProjectile(_o:SpriteModel,_t:SpriteModel){
			var _projM:ProjectileObject=new ProjectileObject(this,_o,_t);
			Facade.gameM.projectiles.push(_projM);
			
			if (_o.shots==0){
				for (var i:int=0;i<effects.length;i+=1){
					if (effects[i].name==EffectData.MULTI){
						if (_o.shots==0) _o.shots+=1;
						_o.shots+=effects[i].values;
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
					Facade.effectC.checkAutoMana(_o);
				}
				
				if (source.charges>=0){
					source.charges-=chargeCost();
				}
				
				if (source.index==125){
					switch(_o.shots){
						case 2: case 5: _projM.type=ProjectileObject.REVERSE_ARC; break;
						case 1: case 4: _projM.type=ProjectileObject.ARC; break;
						case 0: case 3: break;
					}
				}
				
				if (source.index==125){
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
			
			var _avoid:Number=_t.stats.getValue(StatModel.TURN)
			if (Facade.gameM.distance!=GameModel.NEAR){
				_avoid=StatModel.addMult(_avoid,_t.stats.getValue(StatModel.FAR_AVOID));
			}
			_avoid-=dodgeReduce;
			if (GameModel.random()<_avoid){
				defended=SpriteView.TURN;
				playerEffect(PLAYER_DEFENDED,_t,defended);
			}
		}
		
		override public function postAnim(_o:SpriteModel,_t:SpriteModel){
			if (defended!=null){
				graphicEffect(ActionBase.FLYING_TEXT,_t,defended);
				
				_t.stats.useEffects(EffectBase.DEFENSE,new DamageModel,_t,_o,this);
				useEffects(EffectBase.DEFENSE,_o,_t,dmgModel,true);
				
				graphicEffect(ActionBase.DEFEND_SOUND,_o,defended);
			}else{
				dmgModel.setDmg(damage*_o.stats.getValue(StatModel.DMGMULT),type,crit);
				dmgModel.addLeech(leech,type);
				useEffects(EffectBase.HURT,_o,_t,dmgModel,true);
				
				playerEffect(ActionBase.SOUND_HIT,_o,label);
				playerEffect(ActionBase.PLAYER_ACTION,_t,SpriteView.HURT);
				
				_t.stats.useEffects(EffectBase.HURT,new DamageModel,_t,_o,this);
			}
			
			checkStrike(_o,_t);
		}
		
		override public function getBoost(_v:SpriteModel):int{
			specialEffect=-1;
			var m:int=0;
			for (var i:int=0;i<_v.stats.displays.length;i+=1){
				if (_v.stats.displays[i].trigger==EffectBase.LEVEL_BOOST){
					switch(_v.stats.displays[i].name){
						case EffectData.SPELL_BOOST:
							 if (_v.stats.displays[i].checkRate()) m+=_v.stats.displays[i].values; 
							 specialEffect=GAIA;
							 break;
					}
				}
			}
			return m;
		}
		
		override public function fullUse(_v:SpriteModel):Number{
			var m:Number=userate;
			m=addMult(m,_v.mana/_v.stats.getValue(StatModel.MANA)/5);
			m=addMult(m,_v.stats.getValue(StatModel.MRATE));
			
			if (isConsumable()){
				m=addMult(m,_v.stats.getValue(StatModel.IRATE));
			}
			return m;
		}
		
		override public function clone(_boost:int=0):ActionBase{
			//var m:ActionProjectile=new ActionProjectile(label,level,basePriority.basePriorityList,damage,effects,hitrate,critrate,critmult,cEffects,dodgeReduce,tags);
			var m:ActionSpellDamaging=new ActionSpellDamaging(label,level,damage,type,effects,mana,tags);
			m.source=source;
			m.specialEffect=specialEffect;
			
			return m;
		}
		
		override public function isMagic():Boolean{
			return true;
		}
		
		//===================PRIORITIES==========================\\
		
		override public function canUse(_o:SpriteModel,_t:SpriteModel,_distance:String=null):Boolean{
			if (_distance==null) _distance=Facade.gameM.distance;
			
			if (target==ENEMY && _t==null) return false;
			if (!checkCanDistance(_distance)){
				return false;
			}
			//if (!checkCanDistance(_distance)) return false;
			
			for (var i:int=0;i<_o.buffList.numBuffs();i+=1){
				switch(_o.buffList.getBuff(i).name){ //limited actions
					case BuffData.BERSERK: case BuffData.TAUNT:
					case BuffData.SILENCED:
					case BuffData.INITIAL_NO_OFFENSIVE: return false;
				}
			}
			
			if (mana>0){
				if (hasTag(EffectData.BLOOD_MAGIC)){
					if (mana*EffectData.BLOOD_MAGIC_RATIO>_o.getHealth()-1){
						return false;
					}
				}else{
					if (_o.mana<mana){
						return false; //cant pay mana cost
					}
				}
			}
			
			if (source.charges>=0 && source.charges<chargeCost()){
				return false;
			}
			
			return true;
		}
		
		override public function setDefaultPriorities(){
			additionalPriorities=[new ConditionalBase(0,0,[0,1])];
			priorityTier=3;
		}
		
		override public function getDesc():String{
			var m:String="";
			m+="<font color="+StringData.YELLOW+"><b>"+label+"</b></font>";
			if ((userate!=0)&&(userate<1)){
				m+="\n USE: <font color="+StringData.RED+"><b> +"+StringData.reduce(userate*100)+"%</b></font>";
			}
			
			if (damage!=0) m+="\n DMG: <font color="+StringData.RED+"><b>"+Math.round(damage)+" "+ActionBase.statNames[type]+"</b></font>";
			if (mana!=0){
				if (hasTag(EffectData.BLOOD_MAGIC)){
					m+="\n HEALTH COST: <font color="+StringData.RED+"><b>"+Math.round(mana*EffectData.BLOOD_MAGIC_RATIO)+"</b></font>";
				}else{
					m+="\n MANA: <font color="+StringData.RED+"><b>"+mana+"</b></font>";
				}
			}
			if (leech!=0) m+="\n SPELLSTEAL: <font color="+StringData.RED+"><b>+"+StringData.reduce(leech*100)+"%</b></font>";
			if (dodgeReduce!=0) m+="\n SPELL PEN: <font color="+StringData.RED+"><b>+"+StringData.reduce(dodgeReduce*100)+"%</b></font>";
			
			m+=getEffectDescs();
			
			return m;
		}
	}
}