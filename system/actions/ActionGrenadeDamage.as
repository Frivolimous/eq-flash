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
	
	public class ActionGrenadeDamage extends ActionBase{
		public function ActionGrenadeDamage(_label:String=null,_level:int=0,_damage:Number=0,_type:int=-1,_effects:Vector.<EffectBase>=null,_dodgeReduce:Number=0,_priorities:int=ActionPriorities.COMBAT){
			if (_label!=null){
				baseStats();
				label=_label;
				level=_level;
				userate=0;
				target=ActionBase.ENEMY;
				damage=_damage;
				type=_type;
				if (_effects!=null) effects=_effects;
				dodgeReduce=_dodgeReduce;
				basePriority.setBaseDistance(_priorities,false);
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
			
			m.dodgeReduce+=_v.actionList.attack.dodgeReduce;
			
			var _effect:EffectBase=m.findEffect(EffectData.BASE_DMG);
			if (_effect !=null){
				m.damage+=_effect.values;
			}
			
			var _scaling:Number=0;
			
			_effect=m.findEffect(EffectData.MPOWSCALING)
			if (_effect!=null){
				_scaling=_v.stats.getValue(StatModel.MPOWER)/100*_effect.values;
			}
			
			if (_scaling==0){
				_scaling=_v.stats.getValue(StatModel.THROWEFF);
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
			
			m.damage*=_v.stats.getValue(StatModel.ITEMEFF);
			switch (m.type){
				case DamageModel.HOLY: m.damage*=_v.stats.getValue(StatModel.HOLYEFF); break;
				case DamageModel.CHEMICAL: m.damage*=_v.stats.getValue(StatModel.CHEMEFF); break;
				case DamageModel.PHYSICAL: m.damage*=_v.stats.getValue(StatModel.PHYSEFF); break;
				case DamageModel.MAGICAL: m.damage*=_v.stats.getValue(StatModel.MAGICEFF); break;
				case DamageModel.DARK: m.damage*=_v.stats.getValue(StatModel.DARKEFF); break;
			}
			
			if (m.damage<0) m.damage=0;
			if (m.damage>0 && m.damage<1) m.damage=1;
			
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
				for (i=0;i<effects.length;i+=1){
					if (effects[i].name==EffectData.MULTI){
						if (_o.shots==0) _o.shots+=1;
						_o.shots+=effects[i].values;
					}
				}
				
				for (var i:int=0;i<_o.stats.displays.length;i+=1){
					if (_o.stats.displays[i].name==EffectData.DOUBLESHOT && _o.stats.displays[i].checkRate()){
						if (_o.shots==0) _o.shots+=1;
						_o.shots+=_o.stats.displays[i].values;
					}
				}
			}
			
			if (_o.shots>1){
				_o.shots-=1;
				
				if (source.charges>=0 && source.charges<chargeCost()){
					_o.shots=0;
					return;
				}
								
				if (source.charges>=0){
					source.charges-=chargeCost();
				}
				
				playerEffect(PLAYER_BACK_THREE,_o,null);
				
				var _action:ActionBase=source.action.modify(_o);
				_action.finishAction(_o,_action.makeProjectile,_t);
			}else{
				_o.shots=0;
			}
		}
		
		override public function setDefense(_o:SpriteModel,_t:SpriteModel){
			if (_t==null) return;
			var _avoid:Number=_t.stats.getValue(StatModel.DODGE)
			if (Facade.gameM.distance!=GameModel.NEAR){
				_avoid=StatModel.addMult(_avoid,_t.stats.getValue(StatModel.FAR_AVOID));
			}
			_avoid-=dodgeReduce;
			if (GameModel.random()<_avoid){
				defended=SpriteView.DODGE_LONG;
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
				if (damage>0){
					dmgModel.setDmg(damage*_o.stats.getValue(StatModel.DMGMULT),type,crit);
				}
				dmgModel.addLeech(leech,type);
				useEffects(EffectBase.HURT,_o,_t,dmgModel,true);
				
				playerEffect(ActionBase.SOUND_HIT,_o,label);
				playerEffect(ActionBase.PLAYER_ACTION,_t,SpriteView.HURT);
				
				_t.stats.useEffects(EffectBase.HURT,new DamageModel,_t,_o,this);
			}
			
			checkStrike(_o,_t);
		}
		
		override public function fullUse(_v:SpriteModel):Number{
			var m:Number=userate;
			m=addMult(m,_v.stats.getValue(StatModel.IRATE));
			m=addMult(m,_v.stats.getValue(StatModel.TRATE));
			
			return m;
		}
		
		//===================PRIORITIES==========================\\
		
		override public function canUse(_o:SpriteModel,_t:SpriteModel,_distance:String=null):Boolean{
			if (_distance==null) _distance=Facade.gameM.distance;
			
			if (_t==null) return false;
			
			if (!checkCanDistance(_distance)) return false;
			
			for (var i:int=0;i<_o.buffList.numBuffs();i+=1){
				switch(_o.buffList.getBuff(i).name){ //limited actions
					case BuffData.INITIAL_NO_OFFENSIVE: case BuffData.BERSERK: case BuffData.TAUNT: return false;
					
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
			m+="\n DMG: <font color="+StringData.RED+"><b>"+Math.round(damage)+" "+ActionBase.statNames[type]+"</b></font>";
			
			if (leech!=0) m+="\n LIFESTEAL: <font color="+StringData.RED+"><b>+"+StringData.reduce(leech*100)+"%</b></font>";
			if (dodgeReduce!=0) m+="\n ACCURACY: <font color="+StringData.RED+"><b>+"+StringData.reduce(dodgeReduce*100)+"%</b></font>";
			
			m+=getEffectDescs();
			
			return m;
		}
	}
}