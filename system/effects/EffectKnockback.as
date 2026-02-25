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
	
	public class EffectKnockback extends EffectBase{
		public static const FORWARDS_TWO:int=-2,
							FORWARDS:int=-1,
							NONE:int=0,
							BACK:int=1,
							BACK_TWO:int=2;
		var animation:int=-1;
		var direction:int;
		var stun:Boolean;
		
		public function EffectKnockback(_name:String=null,_level:int=0,_trigger:int=0,_direction:int=1,_stun:Boolean=false,_userate:Number=1,_animation:int=-1){
			name=_name;
			level=_level;
			trigger=_trigger;
			type=EffectBase.INSTANT;
			direction=_direction;
			stun=_stun;
			userate=_userate;
			animation=_animation;
		}
		
		override public function modify(_v:SpriteModel,_action:ActionBase=null):EffectBase{
			var m:EffectKnockback=(clone() as EffectKnockback);
			m.modifyThis(_v,_action);
			return m;
		}
		
		override public function modifyThis(_v:SpriteModel,_action:ActionBase=null){
			
		}
		
		override public function clone():EffectBase{
			return new EffectKnockback(name,level,trigger,direction,stun,userate);
		}
		
		override public function applyEffect(_o:SpriteModel,_t:SpriteModel,_action:ActionBase,_dmgModel:DamageModel){
			if (name==EffectData.MINOTAUR){
				if (_o.eDistance==GameModel.NEAR){
					if (_action.defended==null){
						if (_action.defended==SpriteView.BLOCK){
							_t.addApply(this,1);
						}
					}else{
						_t.addApply(this,0,true);
					}
				}
			}else{
				_t.addApply(this,1);
			}
		}
		
		override public function finalEffect(_o:SpriteModel){
			//At the end of the round, if addApply is used
			if (userate==1){
				if (stun){
					_o.buffList.addBuff(BuffData.makeBuff(BuffData.STUNNED,0));
				}
				if (animation>=-1){
					graphicEffect(ANIMATED,_o,animation);
				}
				
				switch(direction){
					case FORWARDS_TWO:
						if (_o.eDistance!=GameModel.NEAR){
							_o.eDistance=GameModel.NEAR;
							playerEffect(PLAYER_ACTION,_o,SpriteView.KNOCKBACK_REVERSED);
						}
						break;
					case FORWARDS:
						if (_o.eDistance==GameModel.FAR){
							_o.eDistance=GameModel.NEAR;
							playerEffect(PLAYER_ACTION,_o,SpriteView.KNOCKBACK_REVERSED);
						}else if (_o.eDistance==GameModel.VERY){
							_o.eDistance=GameModel.FAR;
							playerEffect(PLAYER_ACTION,_o,SpriteView.KNOCKBACK);
						}
						break;
					case BACK:
						if (_o.eDistance==GameModel.NEAR){
							_o.eDistance=GameModel.FAR;
							playerEffect(PLAYER_ACTION,_o,SpriteView.KNOCKBACK);
						}else if (_o.eDistance==GameModel.FAR){
							_o.eDistance=GameModel.VERY;
							playerEffect(PLAYER_ACTION,_o,SpriteView.KNOCKBACK);
						}
						break;
					case BACK_TWO:
						if (_o.eDistance!=GameModel.VERY){
							_o.eDistance=GameModel.VERY;
							playerEffect(PLAYER_ACTION,_o,SpriteView.KNOCKBACK);
						}
						break;
				}
			}
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
			
			switch(direction){
				case FORWARDS_TWO: n="pull the enemy forwards to Near Range"; break;
				case FORWARDS: n="pulls the enemy forwards by 1 unit"; break;
				case BACK: n="knocks the target back 1 unit"; break;
				case BACK_TWO: n="knocks the target back to Long Range"; break;
			}
			if (stun){
				n+=" and stuns for 1 round.";
			}else{
				n+=" without stunning.";
			}
			
			if (name==EffectData.MINOTAUR){
				n+="  Can only occur once per round and only if no attack hits.";
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