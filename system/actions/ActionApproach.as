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
	
	public class ActionApproach extends ActionBase{
		public function ActionApproach(){
			baseStats();
			label=ActionData.APPROACH;
			level=0;
			userate=1;
			target=ActionBase.SELF;
			effects=new <EffectBase>[EffectData.makeEffect(EffectData.APPROACH,0),EffectData.makeEffect(EffectData.RUSHED,0),EffectData.makeEffect(EffectData.STRIKE,0)];
			
			basePriority.setBaseDistance(ActionPriorities.VERY,false);
			setDefaultPriorities();
			
			source=ActionData.DEFAULT;
		}
		
		override public function modify(_v:SpriteModel,_random:Boolean=true):ActionBase{
			var m:ActionBase=new ActionApproach();
			
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
			if (_o.eDistance==GameModel.FAR){
				if (_o.buffList.hasBuff(BuffData.RUSHED)) _o.strike=-1;
				_o.eDistance=GameModel.NEAR;
			}else if (_o.eDistance==GameModel.VERY){
				_o.eDistance=GameModel.FAR;
			}
			playerEffect(PLAYER_ACTION,_o,SpriteView.APPROACH);
			finishAction(_o,postAnim,_o);
		}
		
		override public function clone(_boost:int=0):ActionBase{
			return new ActionApproach;
		}
		
		override public function fullUse(_v:SpriteModel):Number{
			return 1;
		}
		
		//===================PRIORITIES==========================\\
		
		override public function canUse(_o:SpriteModel,_t:SpriteModel,_distance:String=null):Boolean{
			if (_distance==null) _distance=_o.eDistance;
			
			if (!checkCanDistance(_distance)){
				return false;
			}
			
			for (var i:int=0;i<_o.buffList.numBuffs();i+=1){
				switch(_o.buffList.getBuff(i).name){ //limited actions
					case BuffData.INITIAL_NO_OFFENSIVE: case BuffData.AIMING: case BuffData.ROOTED: case BuffData.IVY: case BuffData.TRAP: return false;
				}
			}
			
			if (_distance==GameModel.FAR && _o.equipment[0].hasTag(EffectData.NO_ATTACK)) return false;
			
			return true;
		}
		
		override public function wantUse(_o:SpriteModel,_t:SpriteModel,_distance:String=null,_rate:Boolean=true):Boolean{
			if (_distance==null) _distance=_o.eDistance;
			if (!checkDistance(_distance)) return false;
			
			for (var i:int=0;i<additionalPriorities.length;i+=1){
				if (!additionalPriorities[i].testThis(_o,_t,this)) return false;
			}
			
			if (_distance==GameModel.FAR){
				if (_o.actionList.getAttack().wantUse(_o,_t,GameModel.NEAR)){
				}else{
					return false;
				}
			}else if (_distance==GameModel.VERY){
				
			}
			
			return true;
		}
		
		override public function setDefaultPriorities(){
			additionalPriorities=[];
			priorityTier=4;
		}
	}
}