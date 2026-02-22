package system.effects{
	import system.actions.ActionBase;
	import ui.effects.PopEffect;
	import system.buffs.BuffData;
	import items.ItemData;
	
	public class EffectDamageRadiation extends EffectDamage{
		
		public function EffectDamageRadiation(_name:String=null,_damageMult:Number=0,_dType:int=0,_trigger:int=12,_userate:Number=1,_splash:int=-1){
			name=_name;
			level=0;
			type=EffectBase.DAMAGE;
			trigger=_trigger;
			userate=_userate;
			damage=_damageMult;
			damageType=_dType;
			splash=_splash;
		}
		
		override public function modify(_v:SpriteModel,_action:ActionBase=null):EffectBase{
			var m:EffectDamage=(clone() as EffectDamage);
			
			m.modifyThis(_v,_action);
			return m;
		}
		
		override public function modifyThis(_v:SpriteModel,_action:ActionBase=null){
			if (damageType==DamageModel.CHEMICAL)  damage*=_v.stats.getValue(StatModel.CHEMEFF);
			if (damageType==DamageModel.HOLY)  damage*=_v.stats.getValue(StatModel.HOLYEFF);
			if (damageType==DamageModel.MAGICAL)  damage*=_v.stats.getValue(StatModel.MAGICEFF);
			if (damageType==DamageModel.PHYSICAL)  damage*=_v.stats.getValue(StatModel.PHYSEFF);
			if (_action!=null && _action.isConsumable()) damage*=_v.stats.getValue(StatModel.ITEMEFF);
			
			damage*=_v.stats.getValue(StatModel.PROCEFF);
			damage*=_v.stats.getValue(StatModel.DOTEFF);
			damage*=_v.getHealth();
		}
		
		override public function clone():EffectBase{
			return new EffectDamageRadiation(name,damage,damageType,trigger,userate);
		}
		
		override public function applyEffect(_o:SpriteModel,_t:SpriteModel,_action:ActionBase,_dmgModel:DamageModel){
			if (_o.eDistance!=GameModel.NEAR) return;
			
			_dmgModel.setDmg(damage,damageType);
			
			if (_dmgModel.after==-1 || Math.random()<0.4){
				if (splash!=-1){
					_dmgModel.after=splash;
				}else{
					switch(damageType){
						case DamageModel.MAGICAL: _dmgModel.after=PopEffect.MAGIC; break;
						case DamageModel.CHEMICAL: _dmgModel.after=PopEffect.TOXIC; break;
						case DamageModel.HOLY: _dmgModel.after=PopEffect.HOLY; break;
						case DamageModel.DARK: _dmgModel.after=PopEffect.MAGIC; break;
						case DamageModel.PHYSICAL: _dmgModel.after=PopEffect.CRIT; break;
					}
				}
			}
		}
		
		override public function getDesc(_tabs:int=1):String{
			var m:String="";
			if (userate<1){
				m+="<font color="+StringData.RED+"><b>"+StringData.reduce(userate*100)+"%</b></font> ";
			}
			m+="DMG: <font color="+StringData.RED+"><b>"+StringData.reduce(damage*100)+"% "+DamageModel.shortTypeName[damageType]+"</b></font>";
			m=StringData.tabs(_tabs)+m;
			
			return m;
		}
		
		override public function getSpecialDesc(_descType:int=-1):String{
			var m:String="";
				
			m+=getTriggerText(_descType);
			return m+"if at Near Range, deal Chemical Damage based on a percent of your current health.";
		}
	}
}