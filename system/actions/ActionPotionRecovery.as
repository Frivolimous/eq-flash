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
	
	public class ActionPotionRecovery extends ActionBase{
		public var manaRecover:Number=0;
		
		public function ActionPotionRecovery(_label:String=null,_level:int=0,_damage:Number=0,_effects:Vector.<EffectBase>=null){
			if (_label!=null){
				baseStats();
				label=_label;
				level=_level;
				userate=0;
				target=ActionBase.SELF
				damage=_damage;
				type=ActionBase.CHEMICAL;
				if (_effects!=null) effects=_effects;
				basePriority.setBaseDistance(ActionPriorities.ALL_DISTANCE,false);
				setDefaultPriorities();
				
				source=ActionData.DEFAULT;
			}
		}
		
		override public function modify(_v:SpriteModel,_random:Boolean=true):ActionBase{
			if (_random){
				var m:ActionPotionRecovery=(clone(getBoost(_v)) as ActionPotionRecovery);
			}else{
				m=(clone() as ActionPotionRecovery);
			}
			
			var _scaling:Number=_v.stats.getValue(StatModel.POTEFF);
			
			if (_random){
				m.damage*=(1+_v.stats.drange*(GameModel.random()-0.5)*2)*_scaling;
			}else{
				m.damage*=_scaling;
			}
			
			m.damage*=_v.stats.getValue(StatModel.ITEMEFF);
			switch (m.type){
				case DamageModel.HOLY: m.damage*=_v.stats.getValue(StatModel.HOLYEFF);
				case DamageModel.CHEMICAL: m.damage*=_v.stats.getValue(StatModel.CHEMEFF);
				case DamageModel.PHYSICAL: m.damage*=_v.stats.getValue(StatModel.PHYSEFF);
				case DamageModel.MAGICAL: m.damage*=_v.stats.getValue(StatModel.MAGICEFF);
				case DamageModel.DARK: m.damage*=_v.stats.getValue(StatModel.DARKEFF);
			}
			
			m.damage*=_v.stats.getValue(StatModel.HEALMULT);
			
			m.manaRecover=m.damage*0.35;
			
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
			makeProjectile(_o,_o);
		}
		
		override public function postAnim(_o:SpriteModel,_t:SpriteModel){
			dmgModel.setDmg(damage,type);
			_t.healthHeal(damage);
			_t.mana+=manaRecover;

			graphicEffect(ADD_HEAL,_o,this);
			graphicEffect(FLYING_TEXT,_t,dmgModel.healText());
			dmgModel=new DamageModel;
			
			super.postAnim(_o,_t);
		}
				
		override public function fullUse(_v:SpriteModel):Number{
			var m:Number=userate;
			m=addMult(m,_v.stats.getValue(StatModel.IRATE));
			m=addMult(m,_v.stats.getValue(StatModel.PRATE));
			
			return m;
		}
		
		//===================PRIORITIES==========================\\
		
		override public function canUse(_o:SpriteModel,_t:SpriteModel,_distance:String=null):Boolean{
			if (_distance==null) _distance=Facade.gameM.distance;
			
			if (!checkCanDistance(_distance)) return false;
			
			for (var i:int=0;i<_o.buffList.numBuffs();i+=1){
				switch(_o.buffList.getBuff(i).name){ //limited actions
					case BuffData.RUSHED: case BuffData.AIMING: case BuffData.BERSERK: case BuffData.TAUNT: return false;
				}
			}
			
			if (source.charges>=0 && source.charges<chargeCost()){
				return false;
			}
			
			return true;
		}
				
		override public function setDefaultPriorities(){
			additionalPriorities=[new ConditionalBase(1,0,[1,2,3,4]),new ConditionalBase(1,1,[1,2,3,4])];
			priorityTier=1;
			additionalPriorities.push(new ConditionalBase(3,0,[0,1,2,3,4,5,6,7]));
		}
		
		override public function getDesc():String{
			var m:String="";
			m+="<font color="+StringData.YELLOW+"><b>"+label+"</b></font>";
			if ((userate!=0)&&(userate<1)){
				m+="\n USE: <font color="+StringData.RED+"><b> +"+StringData.reduce(userate*100)+"%</b></font>";
			}
			
			m+="\n HEALTH: <font color="+StringData.RED+"><b>"+Math.round(damage)+"</b></font>";
			m+="\n MANA: <font color="+StringData.RED+"><b>"+Math.floor(damage*0.35)+"</b></font>";
					
			/*if (type>-1) m+=ActionBase.statNames[type];
			m+="</b></font>";
			*/
			m+=getEffectDescs();
			
			return m;
		}
	}
}