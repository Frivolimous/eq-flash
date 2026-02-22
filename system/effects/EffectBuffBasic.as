package system.effects{
	import system.actions.ActionBase;
	import system.actions.ActionData;
	import system.buffs.BuffBase;
	import system.buffs.BuffData;
	import system.buffs.BuffDOT;
	import system.buffs.BuffDelayedDmg;
	import items.FilterData;
	import system.buffs.BuffShield;
	import flash.filters.ColorMatrixFilter;
	
	public class EffectBuffBasic extends EffectBuff{
		
		public function EffectBuffBasic(_buff:BuffBase=null,_type:int=0,_trigger:int=0,_userate:Number=1){
			name=_buff.name;
			level=_buff.level;
			type=_type;
			trigger=_trigger;
			buff=_buff;
			userate=_userate;
		}
		
		override public function modify(_v:SpriteModel,_action:ActionBase=null):EffectBase{
			var m:EffectBuffBasic=new EffectBuffBasic(buff,type,trigger,userate);
			m.modifyThis(_v,_action);
			return m;
		}
		
		override public function modifyThis(_v:SpriteModel,_action:ActionBase=null){
			var _mult:Number=1;
			if (_action!=null && _action.isConsumable()) _mult*=_v.stats.getValue(StatModel.ITEMEFF);
			buff=buff.modify(_v,_mult);
			if (_action!=null && _action.source!=null){
				buff.filter=items.FilterData.getPremiumFilter(_action.source.index,_action.source.enchantIndex);
			}
		}
		
		override public function clone():EffectBase{
			return new EffectBuffBasic(buff.clone(),type,trigger,userate);
		}
		
		override public function applyEffect(_o:SpriteModel,_t:SpriteModel,_action:ActionBase,_dmgModel:DamageModel){
			if (type==EffectBase.BUFF){
				if (buff.index==-1){
					_o.buffList.addBuff(buff);
				}else{
					_dmgModel.oBuffs.push(buff);
				}
			}else if (type==EffectBase.CURSE){
				_dmgModel.tBuffs.push(buff);
			}
		}
		
		override public function getDesc(_tabs:int=1):String{
			var m:String="";
			if (userate<1){
				m+="<font color="+StringData.RED+"><b>"+StringData.reduce(userate*100)+"%</b></font> ";
			}
			
			m+=buff.getDesc();
			
			if (m.length>0){
				m=StringData.tabs(_tabs)+m;
			}
			return m;
		}
		
		override public function getSpecialDesc(_descType:int=-1):String{
			var m:String="";
			m+=getTriggerText(_descType);
			var n:String=buff.getEffectDesc();
			if (n==null || n.length==0) return null;
			
			if (m.length==0){
				m+=n.charAt(0).toUpperCase();
				m+=n.substr(1);
			}else{
				m+=n.charAt(0).toLowerCase();
				m+=n.substr(1);
			}
			
			return m;
		}
	}
}