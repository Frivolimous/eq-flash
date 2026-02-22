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
	
	public class ActionWalk extends ActionBase{
		public function ActionWalk(){
			baseStats();
			label=ActionData.WALK;
			level=0;
			userate=1;
			target=ActionBase.SELF;
			effects=new <EffectBase>[EffectData.makeEffect(EffectData.WALK,0)];
			
			basePriority.setBaseDistance(ActionPriorities.BETWEEN,false);
			setDefaultPriorities();
			
			source=ActionData.DEFAULT;
		}
		
		override public function modify(_v:SpriteModel,_random:Boolean=true):ActionBase{
			var m:ActionBase=new ActionWalk();
			
			for (var i:int=0;i<m.effects.length;i+=1){
				m.effects[i].modifyThis(_v,m);
			}
			
			if (_v.stats.procs.length>0){
				m.effects=m.effects.concat(_v.stats.modProcs(_v,this));
			}
			
			return m;
		}
		
		override public function useAction2(_o:SpriteModel,_t:SpriteModel){
			playerEffect(PLAYER_ACTION,_o,SpriteView.WALK);
			finishAction(_o,postAnim,_o);
			return;
		}
		
		override public function clone(_boost:int=0):ActionBase{
			return new ActionWalk;
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
					case BuffData.RUSHED: case BuffData.AIMING: case BuffData.ROOTED: case BuffData.IVY: case BuffData.TRAP: return false;
				}
			}
			
			return true;
		}
		
		override public function wantUse(_o:SpriteModel,_t:SpriteModel,_distance:String=null,_rate:Boolean=true):Boolean{
			if (_distance==null) _distance=_o.eDistance;
			if (!checkDistance(_distance)) return false;
			
			for (var i:int=0;i<additionalPriorities.length;i+=1){
				if (!additionalPriorities[i].testThis(_o,_t,this)) return false;
			}
			
			return true;
		}
		
		override public function setDefaultPriorities(){
			additionalPriorities=[];
			priorityTier=4;
		}
	}
}