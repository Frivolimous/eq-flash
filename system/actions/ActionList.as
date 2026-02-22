package system.actions {
	import items.ItemData;
	import items.ItemCover;
	import system.buffs.BuffData;
	import system.effects.EffectData;
	
	public class ActionList {
		public var fullList:Vector.<ActionBase>=new Vector.<ActionBase>;
		
		public var unarmed:ActionBase;
		public var attack:ActionAttack;
		
		public var itemC:ItemCover=new ItemCover;

		public function ActionList() {
			// constructor code
		}
		
		public function clear(_unarmed:ActionBase){
			unarmed=_unarmed;
			fullList=new <ActionBase>[ActionData.makeAction(ActionData.WALK),_unarmed,ActionData.makeAction(ActionData.APPROACH)];
		}
		
		public function replaceAttack(v:ActionBase){
			for (var i:int=0;i<fullList.length;i+=1){
				if (fullList[i].label==ActionData.ATTACK){
					fullList[i]=v;
					break;
				}
			}
		}
		
		public function defaultAttack(){
			for (var i:int=0;i<fullList.length;i+=1){
				if (fullList[i].label==ActionData.ATTACK){
					fullList[i]=unarmed;
					break;
				}
			}
		}
		
		public function getAttack():ActionBase{
			return getActionCalled(ActionData.ATTACK);
		}
		
		public function getActionCalled(s:String):ActionBase{
			for (var i:int=0;i<fullList.length;i+=1){
				if (fullList[i].label==s) return fullList[i];
			}
			return null;
		}
		
		public function getList(s:String):Vector.<ActionBase>{
			var m:Vector.<ActionBase>=new Vector.<ActionBase>;
			for (var i:int=0;i<fullList.length;i+=1){
				if (fullList[i].checkDistance(s) || (s==GameModel.FAR && (fullList[i] is ActionAttack) && attack.hasEffect(EffectData.LEAP_ATTACK))){
					m.push(fullList[i]);
				}
			}
			m.sort(orderTier);
			return m;
		}
		
		function orderTier(a,b):int{
			if (a.priorityTier<b.priorityTier){
				return -1;
			}else if (a.priorityTier>b.priorityTier){
				return 1;
			}else{
				return 0;
			}
		}
		
		public function addAction(_action:ActionBase,_index:int=-1){
			if (_action==null) return;
			
			if (_action.label==ActionData.ATTACK){
				replaceAttack(_action);
			}else{
				fullList.unshift(_action);
			}
		}
		
		public function removeAction(_action:ActionBase){
			if (_action==null) return;
			
			if (_action.label==ActionData.ATTACK){
				defaultAttack();
			}else{
				for (var i:int=0;i<fullList.length;i+=1){
					if (fullList[i]==_action){
						fullList.splice(i,1);
					}
				}
			}
		}
		
		public function runAct(_o:SpriteModel){
			var _t:SpriteModel=_o.attackTarget;
			
			_o.strike=0;
			_o.shots=0;
			
			_o.toApply=new Array;
			if (_t!=null) _t.toApply=new Array;
			
			//if ACTIVE, check if you can Withdraw or Approach to use it
			if ((Facade.gameM.active)&&(_o==Facade.gameM.playerM)&&(itemC.actionM!=null)){
				if (tryForced(itemC.actionM,_o,_t)){
					return;
				}
			}
			
			chooseAction(_o);
		}
		
		public function chooseAction(_o:SpriteModel){
			fullList.sort(orderTier);
			
			for (var i:int=0;i<fullList.length;i+=1){
				if (fullList[i].canUse(_o,_o.attackTarget) && fullList[i].wantUse(_o,_o.attackTarget,_o.eDistance)){
					fullList[i].useAction(_o,_o.attackTarget);
					return;
				}
			}
		}
		
		
		public function tryForced(_forcedAction:ActionBase,_o:SpriteModel,_t:SpriteModel):Boolean{
			var _action:ActionBase;
			
			if (_o.eDistance==GameModel.NEAR){
				_action=getActionCalled(ActionData.WITHDRAW);
				if (_action!=null){
					if ((_action as ActionWithdraw).withdrawForcedCanUse(_o,_t,_forcedAction,GameModel.FAR)){
						_action.useAction(_o,_t);
						if (itemC.stay==false) itemC.remove();
						return true;
					}
				}
				_action=null;
			}else if (_o.eDistance==GameModel.FAR){
				_action=getActionCalled(ActionData.WITHDRAW);
				if (_action!=null && (_action as ActionWithdraw).withdrawForcedCanUse(_o,_t,_forcedAction,GameModel.VERY)){
					_action.useAction(_o,_t);
					if (itemC.stay==false) itemC.remove();
					return true;
				}
				_action=null;
				if (!_forcedAction.canUse(_o,_t)){
					if (_forcedAction.label==ActionData.ATTACK){
						if (_o.buffList.hasBuff(BuffData.RUSHED)){
							_o.strike=-1;
							_action=getActionCalled(ActionData.APPROACH);
						}else{
							_action=getActionCalled(ActionData.APPROACH);
						}
					}
				}
			}else if (_o.eDistance==GameModel.VERY){
				if (!_forcedAction.canUse(_o,_t) && !_o.buffList.hasBuff(BuffData.AIMING)){
					_action=getActionCalled(ActionData.APPROACH);
				}
			}
			if (_action==null) _action=_forcedAction;
			
			if (_action.canUse(_o,_t)){
				_action.useAction(_o,_t);
				if (itemC.stay==false && !(_o.eDistance==GameModel.FAR &&_action.label==ActionData.APPROACH)){
					itemC.remove();
				}
				return true;
			}
			return false;
		}
	}
}
