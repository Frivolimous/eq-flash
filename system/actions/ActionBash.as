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
	
	public class ActionBash extends ActionBase{
		public function ActionBash(_label:String=null,_level:int=0,_userate:Number=0,_damage:Number=0,_effects:Vector.<EffectBase>=null,_mana:int=0,_dodgeReduce:Number=0){
			if (_label!=null){
				baseStats();
				label=_label;
				level=_level;
				userate=_userate;
				target=ActionBase.ENEMY;
				damage=_damage;
				type=ActionBase.PHYSICAL;
				hitrate=0;
				critrate=0;
				critmult=0;
				if (_effects!=null) effects=_effects;
				mana=_mana;
				dodgeReduce=_dodgeReduce;
				basePriority.setBaseDistance(ActionPriorities.NEAR,false);
				setDefaultPriorities();
				
				source=ActionData.DEFAULT;
			}
		}
		
		override public function modify(_v:SpriteModel,_random:Boolean=true):ActionBase{
			var m:ActionBase=new ActionBash(label,level,userate,damage,effects,mana,dodgeReduce);
			
			m.addBase(_v.actionList.attack,true);
			
			var _effects:Vector.<EffectBase>=m.effects;
			m.effects=new Vector.<EffectBase>;
			for (var i:int=0;i<_effects.length;i+=1){
				if (_effects[i].name==EffectData.QUICK){
					continue;
				}else if (_effects[i].name==EffectData.LEAP_ATTACK){
					continue;
				}
				m.effects.push(_effects[i].modify(_v,m));
			}
			
			if (_v.stats.procs.length>0){
				m.effects=m.effects.concat(_v.stats.modProcs(_v,this));
			}
			
			if (m.crit && m.cEffects.length>0){
				for (i=0;i<m.cEffects.length;i+=1){
					m.effects.push(m.cEffects[i].modify(_v,m));
				}
			}
			
			var _effect:EffectBase=m.findEffect(EffectData.BASE_DMG);
			if (_effect !=null){
				m.damage+=_effect.values;
			}
			
			var _scaling:Number=0;
			
			if (_scaling==0){
				_scaling=_v.stats.getValue(StatModel.STRENGTH)/100;
				_scaling=(_scaling*1.5-0.5);
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
			
			m.damage*=_v.stats.getValue(StatModel.PHYSEFF);
			
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
			
			if (m.damage<0) m.damage=0;
			if (m.damage>0 && m.damage<1) m.damage=1;
			
			m.leech*=_v.stats.getValue(StatModel.HEALMULT);
			
			return m;
		}
		
		override public function useAction2(_o:SpriteModel,_t:SpriteModel){
			if (_t!=null){
				finishAction(_o,postAnim,_t);
				playerEffect(PLAYER_FROM_ACTION,_o,this);
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
				defended=SpriteView.DODGE;
			}else if (GameModel.random()>toHit(_t.stats.getValue(StatModel.BLOCK),0)){
				defended=SpriteView.BLOCK;
			}
			if (defended!=null){
				playerEffect(PLAYER_DEFENDED,_t,defended);
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
				
				useEffects(EffectBase.HURT,_o,_t,dmgModel,true);
				
				dmgModel.applyDamage(_o,_t,true);
				
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
		
		override public function fullUse(_v:SpriteModel):Number{
			var m:Number=userate;
			return m;
		}
		
		//===================PRIORITIES==========================\\
		
		override public function canUse(_o:SpriteModel,_t:SpriteModel,_distance:String=null):Boolean{
			if (_distance==null) _distance=Facade.gameM.distance;
			
			if (_t==null) return false;
			if (!checkCanDistance(_distance)) return false;
			
			if (mana>0 && _o.mana<mana){
				return false; //cant pay mana cost
			}
			
			for (var i:int=0;i<_o.buffList.numBuffs();i+=1){
				switch(_o.buffList.getBuff(i).name){ //limited actions
					case BuffData.INITIAL_NO_OFFENSIVE: return false;
				}
			}
			
			return true;
		}
		
		override public function setDefaultPriorities(){
			additionalPriorities=[new ConditionalBase(0,0,[0,1])];
			priorityTier=3;
		}
	}
}