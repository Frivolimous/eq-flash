package system.effects{
	import system.actions.ActionBase;
	import system.actions.ActionData;
	import system.actions.ActionWithdraw;
	import system.actions.ActionSpellCursing;
	import system.buffs.BuffBase;
	import system.buffs.BuffDelayedDmg;
	import system.buffs.BuffStealth;
	import system.buffs.BuffData;
	import ui.effects.PopEffect;
	import ui.effects.AnimatedEffect;
	import ui.effects.FlyingText;
	import items.ItemData;
	import items.ItemModel;
	
	public class EffectModified extends EffectBase{
		
		public function EffectModified(_name:String=null,_level:int=0,_type:int=0,_trigger:int=0,_userate:Number=0){
		}
		
		override public function modify(_v:SpriteModel,_action:ActionBase=null):EffectBase{
			var m:EffectModified=(clone() as EffectModified);
			m.modifyThis(_v,_action);
			return m;
		}
		
		override public function modifyThis(_v:SpriteModel,_action:ActionBase=null){
			
		}
		
		override public function clone():EffectBase{
			return new EffectModified(name,level,type,trigger,userate);
		}
		
		override public function applyEffect(_o:SpriteModel,_t:SpriteModel,_action:ActionBase,_dmgModel:DamageModel){
			
		}
		
		override public function getDesc(_tabs:int=1):String{
			var m:String="";
			if (userate<1){
				m+="<font color="+StringData.RED+"><b>"+StringData.reduce(userate*100)+"%</b></font> ";
			}
			
			m+=name;
			
			if (m.length>0){
				m=StringData.tabs(_tabs)+m;
			}
			return m;
		}
		
		override public function getSpecialDesc(_descType:int=-1):String{
			var m:String="";
			
			m+=getTriggerText(_descType);
			
			var n:String;
			
			switch(name){
				
				default: n="do this."; break;
			}
			
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