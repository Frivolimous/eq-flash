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
	
	public class EffectStrike extends EffectBase{
		public static const ANY:int=-1,
							BASIC:int=0,
							WITHDRAW:int=1,
							MAGIC:int=2,
							GRENADE:int=3,
							BUFFPOT:int=4;
		var actionType:int
		
		public function EffectStrike(_name:String=null,_level:int=0,_actionType:int=-1,_userate:Number=1){
			name=_name;
			level=_level;
			actionType=_actionType;
			userate=_userate;
			trigger=EffectBase.ALL;
			type=EffectBase.INSTANT;
		}
		
		override public function modify(_v:SpriteModel,_action:ActionBase=null):EffectBase{
			var m:EffectStrike=(clone() as EffectStrike);
			m.modifyThis(_v,_action);
			return m;
		}
		
		override public function modifyThis(_v:SpriteModel,_action:ActionBase=null){
			
		}
		
		override public function clone():EffectBase{
			return new EffectStrike(name,level,actionType,userate);
		}
		
		override public function applyEffect(_o:SpriteModel,_t:SpriteModel,_action:ActionBase,_dmgModel:DamageModel){
			switch (actionType){
				case ANY: _o.actionList.runAct(_o); break;
				case BASIC:
					if (_o.eDistance==GameModel.NEAR){
						if (_o.strike>-1){
							_t.actionList.getAttack().useAction(_o,_o.attackTarget);
						}
					}else if (_o.strike==0){
						_o.actionList.runAct(_o);
					}else if (_o.strike==1){
						_t.actionList.getActionCalled(ActionData.APPROACH).useAction(_o,_o.attackTarget);
					}else{
						_o.actionList.runAct(_o);
					}
					break;
				case WITHDRAW:
					(_action as ActionWithdraw).withdrawAction.useAction(_o,_o.attackTarget);
					break;
				case MAGIC: 
					if (_o.eDistance==GameModel.BETWEEN || _o.strike!=0) return;
					if (_action.isMagic()) _dmgModel.numQuicks+=1;
					break;
				case GRENADE:
					if (_o.eDistance==GameModel.BETWEEN || _o.strike!=0) return;
					if (_action.isGrenade()) _dmgModel.numQuicks+=1;
					break;
				case BUFFPOT:
					if (_o.eDistance==GameModel.BETWEEN || _o.strike!=0) return;
					if (_action.isBuffing()) _dmgModel.numQuicks+=1;
					break;
			}
		}
		
		override public function getDesc(_tabs:int=1):String{
			if (name==EffectData.STRIKE || name==EffectData.ACT){
				return "";
			}
			
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
			switch(actionType){
				case MAGIC: n="make a Basic Attack after casting a spell."; break;
				case GRENADE: n="make a Basic Attack after using a Grenade."; break;
				case BUFFPOT: n="make a Basic Attack after using a Buffing Potion."; break;
				case ANY: n="Take a bonus action."; break;
				case BASIC: n="Make a bonus strike against your opponent."; break;
				case WITHDRAW: n="Take an attack action."; break;
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