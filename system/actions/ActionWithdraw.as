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
	
	public class ActionWithdraw extends ActionBase{		
	
		public var withdrawAction:ActionBase;
		
		public function ActionWithdraw(_level:int=0){
			baseStats();
			label=ActionData.WITHDRAW;
			level=_level;
			userate=0.3+0.07*level;
			target=ActionBase.SELF;
			
			effects=new <EffectBase>[EffectData.makeEffect(EffectData.WITHDRAW,0),EffectData.makeEffect(EffectData.AIMING,level),EffectData.makeEffect(EffectData.WITHDRAW_ACT,0)];
			
			basePriority.setBaseDistance(ActionPriorities.COMBAT,false);
			setDefaultPriorities();
			
			source=ActionData.DEFAULT;
		}
		
		override public function modify(_v:SpriteModel,_random:Boolean=true):ActionBase{
			var m:ActionWithdraw=new ActionWithdraw(level);
			m.withdrawAction=withdrawAction;
			
			for (var i:int=0;i<m.effects.length;i+=1){
				m.effects[i].modifyThis(_v,m);
			}
			
			if (_v.stats.procs.length>0){
				m.effects=m.effects.concat(_v.stats.modProcs(_v,this));
			}
			
			return m;
		}
		
		override public function useAction2(_o:SpriteModel,_t:SpriteModel){
			if (_o.eDistance==GameModel.NEAR){
				_o.eDistance=GameModel.FAR;
				playerEffect(PLAYER_ACTION,_o,SpriteView.WITHDRAW);
			}else if (_o.eDistance==GameModel.FAR){
				_o.eDistance=GameModel.VERY;
				playerEffect(PLAYER_ACTION,_o,SpriteView.WITHDRAW);
			}
			finishAction(_o,postAnim,_o);
		}
		
		override public function clone(_boost:int=0):ActionBase{
			return new ActionWithdraw(level);
		}
		
		override public function fullUse(_v:SpriteModel):Number{
			return userate;
		}
		
		//===================PRIORITIES==========================\\
		
		override public function canUse(_o:SpriteModel,_t:SpriteModel,_distance:String=null):Boolean{
			withdrawAction=null;
			if (_distance==null) _distance=_o.eDistance;
			
			if (!checkCanDistance(_distance)){
				return false;
			}
			
			for (var i:int=0;i<_o.buffList.numBuffs();i+=1){
				switch(_o.buffList.getBuff(i).name){ //limited actions
					case BuffData.RUSHED: case BuffData.AIMING: case BuffData.BERSERK: case BuffData.TAUNT: case BuffData.ROOTED: case BuffData.IVY: case BuffData.TRAP: 
						return false;
				}
			}
			
			
			if (_o.eDistance==GameModel.NEAR){
				_distance=GameModel.FAR;
			}else if (_o.eDistance==GameModel.FAR){
				_distance=GameModel.VERY;
			}else{
				return false;
			}
			var _list:Vector.<ActionBase>=_o.actionList.getList(_distance);
			for (i=0;i<_list.length;i+=1){
				if (_list[i].label!=ActionData.WITHDRAW && _list[i].label!=ActionData.APPROACH){
					if (_list[i].target!=SELF && _list[i].damage!=0){
						if (_list[i].canUse(_o,_t,_distance) && _list[i].wantUse(_o,_t,_distance)){
							withdrawAction=_list[i];
							return true;
						}
					}
				}
			}
			return false;
		}
		
		public function withdrawForcedCanUse(_o:SpriteModel,_t:SpriteModel,_action:ActionBase,_distance:String=null):Boolean{
			withdrawAction=null;
			if (_action==null) return false;
			if (_distance==null) _distance=_o.eDistance;
			
			//if (source!=null && !basePriority.testCanDistance(Facade.gameM.distance)) return false;
			
			if (_action.target==SELF || _action.damage==0 || !_action.canUse(_o,_t,_distance)) return false;
			
			for (var i:int=0;i<_o.buffList.numBuffs();i+=1){
				switch(_o.buffList.getBuff(i).name){ //limited actions
					case BuffData.AIMING: case BuffData.BERSERK: case BuffData.TAUNT: case BuffData.ROOTED: case BuffData.IVY: return false;
				}
			}
			withdrawAction=_action;
			return true;
		}
		
		override public function setDefaultPriorities(){
			additionalPriorities=[];
			priorityTier=0;
		}
	}
}