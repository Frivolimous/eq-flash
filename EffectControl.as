package{
	import items.ItemData;
	import items.ItemModel;
	import ui.effects.*;
	import system.buffs.BuffData;
	import system.buffs.BuffBase;
	import system.buffs.BuffDelayedDmg;
	import system.buffs.BuffStealth;
	import system.actions.ActionData;
	import system.actions.ActionBase;
	import system.actions.ActionWithdraw;
	import system.effects.*;

	public class EffectControl{
		public function openEffects(_v:SpriteModel){
			//when gameUI loads the game (playerM) or duel (playerM and enemyM)
			var _effect:EffectBase=_v.stats.findDisplay(EffectData.REVIVE_GOKU);
			if (_effect!=null){
				_v.buffList.addBuff(BuffData.makeBuff(BuffData.SAYAN,_effect.level));
			}
		}
		
		//=============SPECIAL EFFECTS=================
		
		
		
		
		public function removeBuffTurns(_v:SpriteModel,_turns:int){
			var _buffs:Array=new Array();
			for (var i:int=0;i<_v.buffList.numBuffs();i+=1){
				if (_v.buffList.getBuff(i).type==BuffBase.BUFF && _v.buffList.getBuff(i).charges>0){
					_buffs.push(i);
				}
			}
			
			if (_buffs.length>0) graphicEffect(ANIMATED,_v,AnimatedEffect.WINGS);
			
			while (_turns>0 &&_buffs.length>0){
				
				var j:int=Math.floor(GameModel.random()*_buffs.length);
				var _buff:BuffBase=_v.buffList.getBuff(_buffs[j]);
				
				_buff.charges-=1;
				if (_buff.charges<=0){
					_v.buffList.removeBuff(_buffs[j]);
					for (var k:int=j+1;k<_buffs.length;k+=1){
						_buffs[k]-=1;
					}
					_buffs.splice(j,1);
				}
				_turns-=1;
			}
		}
		
		public function checkAutoMana(_o:SpriteModel){
			for (var i:int=0;i<_o.belt.length;i+=1){
				if (_o.belt[i]!=null){
					if (_o.belt[i].values.length>0 && (_o.belt[i].values[0][2] is EffectBase) && (_o.belt[i].values[0][2].name==EffectData.MANA_BANK)){
						if ((_o.stats.getValue(StatModel.MANA)-_o.mana)>=_o.belt[i].values[0][2].values && _o.belt[i].charges>0){
							
							/*_effect=findEffect(EffectData.INFINITY);
							if (_effect==null || GameModel.random()>=_effect.userate){
								_o.belt[i].charges-=1;
							}*/
							_o.belt[i].charges-=1;
							
							_o.mana+=_o.belt[i].values[0][2].values*_o.stats.getValue(StatModel.CHEMEFF)*_o.stats.getValue(StatModel.POTEFF);
							graphicEffect(FLYING_TEXT,_o,"<font color='#00dddd'>"+String(Math.round(_o.belt[i].values[0][2].values*_o.stats.getValue(StatModel.CHEMEFF)*_o.stats.getValue(StatModel.POTEFF)))+"</font>");
							break;
						}
					}
				}
			}
			
			var _effect:EffectBase=_o.stats.findEffect(EffectData.AUTOPOT);
			if (_effect!=null){
				_effect=_effect.modify(_o);
				if (_effect.checkRate()){
					if (_o.mana/_o.stats.getValue(StatModel.MANA)<=0.5){
						for (var j:int=0;j<_o.belt.length;j+=1){
							if (_o.belt[j]!=null && (_o.belt[j].index==32 || _o.belt[j].index==96) && _o.belt[j].charges>0){
								var _action:ActionBase=_o.belt[j].action.modify(_o,true);
								_action.primary=false;
								_action.useAction(_o,_o);
								return;
							}
						}
					}
				}
			}
		}
		
		public function reduceDamage(_o:SpriteModel,_dmg:Number,_health:Number):Number{
			var _mitigated:Number=0;
			_effect=_o.stats.findDisplay(EffectData.DEFENSIVE_ROLL);
			if (_effect!=null){
				//graphics: Fluff
				if (GameModel.random()<_o.stats.getValue(StatModel.DODGE)){
					_dmg*=(1-_effect.values);
					graphicEffect(ANIMATED,_o,AnimatedEffect.DICE);
					graphicEffect(FLYING_TEXT,_o,"<font color='#ffff00'>"+String(Math.round(_dmg*_effect.values))+"</font>");
				}
			}
			_mitigated=0;
			for (var i:int=0;i<_o.belt.length;i+=1){
				if (_o.belt[i]!=null){
					if (_o.belt[i].values.length>0 && (_o.belt[i].values[0][2] is EffectBase) && (_o.belt[i].values[0][2].name==EffectData.BLOOD_BANK)){
						while (_o.belt[i].charges>0 && _dmg>(_health+_mitigated)){
							_o.belt[i].charges-=1;
							_mitigated+=_o.belt[i].values[0][2].values*_o.stats.getValue(StatModel.CHEMEFF)*_o.stats.getValue(StatModel.HEALMULT)*_o.stats.getValue(StatModel.POTEFF);
						}
						if (_dmg<(_health+_mitigated)){
							break;
						}
					}
				}
			}
			if (_mitigated>0){
				graphicEffect(FLYING_TEXT,_o,"<font color='#00ffff'>"+String(Math.round(_mitigated))+"</font>");
				_dmg-=_mitigated;
			}
			
			if ((_health-_dmg)<=0){
				var _effect:EffectBase=_o.stats.findDisplay(EffectData.MANA_SHIELD);
				if (_effect!=null){
					graphicEffect(POP,_o,PopEffect.BUBBLE);
					
					_dmg*=_effect.values;
					if (_dmg<_o.mana){
						_o.mana-=_dmg;
						_dmg=0;
					}else{
						if ((_health-(_dmg-_o.mana)/_effect.values)>0){
							_dmg-=_o.mana;
							_o.mana=0;
						}
						_dmg/=_effect.values;
					}
					checkAutoMana(_o);
				}
			}
			
			if ((_health-_dmg)<=0){
				_effect=_o.stats.findDisplay(EffectData.UNSTOPPABLE);
				if (_effect!=null){
					//graphicEffect
					
					_mitigated=_o.fury*_effect.values[0]*_o.stats.getValue(StatModel.HEALTH);
					if (_mitigated>_dmg){
						_dmg=0;
						graphicEffect(POP,_o,PopEffect.BROWN_BURST);
						var _dmgModel:DamageModel=new DamageModel;
						_dmgModel.setDmg(_effect.values[1]*_o.fury*_o.stats.getValue(StatModel.PHYSEFF)*(_o.stats.getValue(StatModel.STRENGTH)/100+1)/2,DamageModel.PHYSICAL);
						_dmgModel.resist(_o.attackTarget);
						_dmgModel.applyDamage(_o,_o.attackTarget,false);
						(new EffectKnockback(EffectData.UNSTOPPABLE,0,0,1,false)).applyEffect(_o,_o.attackTarget,null,_dmgModel);
						_o.attackTarget.buffList.addBuff(BuffData.makeBuff(BuffData.STUNNED,100));
						_o.fury=0;
						_o.furyLeftToGain=0;
					}
				}
			}
			
			return _dmg;
		}
				
		public function tryRevive(_o:SpriteModel):Boolean{
			if (_o.buffList.hasBuff(BuffData.REVIVED)) return false;
			if (_o.buffList.hasBuff(BuffData.DYING)) return false;
			
			_effect=_o.stats.findDisplay(EffectData.UNDYING);
			if (_effect!=null){
				if (!_o.buffList.hasBuff(BuffData.UNDYING)){
					_o.buffList.addBuff((_effect as EffectBuff).buff.modify(_o));
				}
				return true;
			}			
			
			var _effect:EffectBase=_o.stats.findDisplay(EffectData.REVIVE_GOKU);
			if (_effect==null) _effect=_o.stats.findDisplay(EffectData.REVIVE_GRAIL);
			if (_effect==null) _effect=_o.stats.findDisplay(EffectData.REVIVE_PHOENIX);
			if (_effect==null) _effect=_o.stats.findDisplay(EffectData.REVIVE_JUST);
			
			if (_effect!=null){
				graphicEffect(ANIMATED,_o,AnimatedEffect.REVIVE);
				_o.buffList.addBuff(BuffData.makeBuff(BuffData.REVIVED));
				_o.setHealth(_o.stats.getValue(StatModel.HEALTH)*_effect.userate);
				if (_effect.type==EffectBase.BUFF){
					_o.buffList.addBuff((_effect as EffectBuff).buff.modify(_o));
				}
				return true;
			}
			return false;
		}
		
		public static const FLYING_TEXT:int=0,
							ANIMATED:int=1,
							POP:int=2,
							ADD_BUFF:int=3,
							REMOVE_BUFF:int=4,
							UPDATE_BUFF:int=5;
							
		public function graphicEffect(_type:int,_v:SpriteModel,_obj:*){
			if (GameModel.SIMULATED) return;
			if (Facade.currentUI!=Facade.gameUI) return;
			switch(_type){
				case FLYING_TEXT:
					switch(_obj){
						default: new FlyingText(_v,_obj);
					}
					break;
				case ANIMATED:
					new AnimatedEffect(_v,_obj);
					break;
				case POP:
					new PopEffect(_v,_obj);
					break;
			}
		}
		
		public static const PLAYER_ACTION:int=0,
							PLAYER_BACK_TWO:int=1,
							PLAYER_FROM_ACTION:int=2;
							
		public function playerEffect(_type:int,_v:SpriteModel,_obj:*){
			if (GameModel.SIMULATED) return;
			
			switch(_type){
				case PLAYER_ACTION:
					if (_obj is Array){
						 _v.view.action(_obj[0],_obj[1]);
					}else{
						_v.view.action(_obj);
					}
					break;
				case PLAYER_BACK_TWO: _v.view.backTwo(); break;
				case PLAYER_FROM_ACTION:
					if (_obj.crit){
						var _crit:int=1;
					}else{
						_crit=0;
					}
					_v.view.fromAction(_obj,_crit);
					break;
			}
			
		}
	}
}