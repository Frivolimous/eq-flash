package system.effects{
	import system.actions.ActionBase;
	import ui.effects.PopEffect;
	import system.buffs.BuffData;
	import items.ItemData;
	import utils.GameData;
	
	public class EffectHeal extends EffectBase{
		public var heal:Number,
					healType:int;
		
		public function EffectHeal(_name:String=null,_heal:Number=0,_hType:int=0,_trigger:int=-1,_userate:Number=1){
			if (_name!=null){
				name=_name;
				level=0;
				type=EffectBase.DAMAGE;
				trigger=_trigger;
				userate=_userate;
				heal=_heal;
				healType=_hType;
			}
		}
		
		override public function modify(_v:SpriteModel,_action:ActionBase=null):EffectBase{
			var m:EffectHeal=(clone() as EffectHeal);
			
			m.modifyThis(_v,_action);
			return m;
		}
		
		override public function modifyThis(_v:SpriteModel,_action:ActionBase=null){
			if (name==EffectData.FULL_POWER || name==EffectData.FULL_POWER2){
				if (_v.healthPercent()<0.75) heal=0;
			}
			if (name==EffectData.GOLD_STRIKE){
				if (GameData.gold<100) heal=0;
			}
			
			if (healType==DamageModel.CHEMICAL)  heal*=_v.stats.getValue(StatModel.CHEMEFF);
			if (healType==DamageModel.HOLY)  heal*=_v.stats.getValue(StatModel.HOLYEFF);
			if (healType==DamageModel.MAGICAL)  heal*=_v.stats.getValue(StatModel.MAGICEFF);
			if (healType==DamageModel.PHYSICAL)  heal*=_v.stats.getValue(StatModel.PHYSEFF);
			if (healType==DamageModel.DARK) heal*=_v.stats.getValue(StatModel.DARKEFF);
			if (_action!=null && _action.isConsumable()) heal*=_v.stats.getValue(StatModel.ITEMEFF);
			heal*=_v.stats.getValue(StatModel.PROCEFF);
		}
		
		override public function clone():EffectBase{
			return new EffectHeal(name,heal,healType,trigger,userate);
		}
		
		override public function applyEffect(_o:SpriteModel,_t:SpriteModel,_action:ActionBase,_dmgModel:DamageModel){
			_dmgModel.addHeal(heal);
		}
		
		override public function getDesc(_tabs:int=1):String{
			var m:String="";
			if (userate<1){
				m+="<font color="+StringData.RED+"><b>"+StringData.reduce(userate*100)+"%</b></font> ";
			}
			
			m+="HEAL: <font color="+StringData.RED+"><b>+"+StringData.reduce(heal)+" "+DamageModel.shortTypeName[healType]+"</b></font>";

			if (m.length>0){
				m=StringData.tabs(_tabs)+m;
			}
			return m;
		}
		
		override public function getSpecialDesc(_descType:int=-1):String{
			var m:String="";
				
			m+=getTriggerText(_descType);
			
			m+="Recover an amount of your health.";
			return m;
		}
	}
}