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
	
	public class ActionSpellHealing extends ActionBase{
		public function ActionSpellHealing(_label:String=null,_level:int=0,_damage:Number=0,_type:int=-1,_effects:Vector.<EffectBase>=null,_mana:int=0,_tags:Array=null){
			if (_label!=null){
				baseStats();
				label=_label;
				level=_level;
				userate=0;
				target=SELF;
				damage=_damage;
				type=_type;
				if (_effects!=null) effects=_effects;
				if (_tags!=null) tags=_tags;
				mana=_mana;
				basePriority.setBaseDistance(ActionPriorities.ALL_DISTANCE,false);
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
			
			if (m.damage>0){
				if (_random){
					m.damage*=(1+_v.stats.drange*(GameModel.random()-0.5)*2)*_scaling;
				}else{
					m.damage*=_scaling;
				}
			}
			
			m.damage*=_v.stats.getValue(StatModel.HEALMULT);
			
			if (isConsumable()) m.damage*=_v.stats.getValue(StatModel.ITEMEFF);
			switch (m.type){
				case DamageModel.HOLY: m.damage*=_v.stats.getValue(StatModel.HOLYEFF); break;
				case DamageModel.CHEMICAL: m.damage*=_v.stats.getValue(StatModel.CHEMEFF); break;
				case DamageModel.PHYSICAL: m.damage*=_v.stats.getValue(StatModel.PHYSEFF); break;
				case DamageModel.MAGICAL: m.damage*=_v.stats.getValue(StatModel.MAGICEFF); break;
				case DamageModel.DARK: m.damage*=_v.stats.getValue(StatModel.DARKEFF); break;
			}
			
			if (m.damage<1) m.damage=1;
			
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
			makeProjectile(_o,_o);
		}
		
		override public function postAnim(_o:SpriteModel,_t:SpriteModel){
			dmgModel.setDmg(damage,type);
			_t.healthHeal(damage);
			
			graphicEffect(ADD_HEAL,_o,this);
			graphicEffect(FLYING_TEXT,_t,dmgModel.healText());
			dmgModel=new DamageModel;
			
			super.postAnim(_o,_t);
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
		
		override public function isMagic():Boolean{
			return true;
		}
		
		override public function isBuff():Boolean{
			return true;
		}
		
		//===================PRIORITIES==========================\\
		
		override public function canUse(_o:SpriteModel,_t:SpriteModel,_distance:String=null):Boolean{
			for (var i:int=0;i<_o.buffList.numBuffs();i+=1){
				switch(_o.buffList.getBuff(i).name){ //limited actions
					case BuffData.RUSHED: case BuffData.AIMING: case BuffData.BERSERK: case BuffData.TAUNT: case BuffData.SILENCED: return false;
						break;
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
			additionalPriorities=[new ConditionalBase(1,0,[2,3,4])];
			additionalPriorities.push(new ConditionalBase(3,0,[0,1,2,3,4,5,6,7]));
			priorityTier=1;			
		}
		
		override public function getDesc():String{
			var m:String="";
			m+="<font color="+StringData.YELLOW+"><b>"+label+"</b></font>";
			if ((userate!=0)&&(userate<1)){
				m+="\n USE: <font color="+StringData.RED+"><b> +"+StringData.reduce(userate*100)+"%</b></font>";
			}
			
			m+="\n HEALING: <font color="+StringData.RED+"><b>"+Math.round(damage)+" ";
			if (type>-1) m+=ActionBase.statNames[type];
			m+="</b></font>";

			if (mana!=0){
				if (hasTag(EffectData.BLOOD_MAGIC)){
					m+="\n HEALTH COST: <font color="+StringData.RED+"><b>"+Math.round(mana*EffectData.BLOOD_MAGIC_RATIO)+"</b></font>";
				}else{
					m+="\n MANA: <font color="+StringData.RED+"><b>"+mana+"</b></font>";
				}
			}
			
			m+=getEffectDescs();
			
			return m;
		}
	}
}