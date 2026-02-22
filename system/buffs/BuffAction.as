package system.buffs{
	
	public class BuffAction extends BuffBase{
		public var rate:Number;
		
		public function BuffAction(_index:int,_name:String,_level:int,_charges:int,_rate:Number,_maxStacks:int=1){
			name=_name
			index=_index;
			level=_level;
			type=BuffBase.CURSE;
			_Charges=_charges;
			rate=_rate;
			maxStacks=_maxStacks;
		}
		
		override public function modify(_v:SpriteModel,_moreMult:Number=1):BuffBase{
			var m:BuffAction=clone() as BuffAction;
			if (name!=BuffData.STUNNED){
				m.modifyThis(_v,_moreMult);
			}
			return m;
		}
		
		override public function clone():BuffBase{
			return new BuffAction(index,name,level,charges,rate,maxStacks);
		}
		
		override public function wasRemovedFrom(_v:SpriteModel){
			if (name==BuffData.STUNNED || name==BuffData.CONFUSED){
				_v.view.action(SpriteView.UNFREEZE);
			}
		}
		
		public function checkRate():Boolean{
			if (rate>=1 || GameModel.random()<rate){
				return true;
			}else{
				return false;
			}
		}
		
		override public function getDesc():String{
			var m:String=name;
			
			m+="<font color="+StringData.RED+"><b>";
			if (rate<1 && rate>0){
				m+=" "+String(Math.floor(rate*100))+"%";
			}
			m+=" x"+charges;
			/*m+="\n";
			if (_effect.values.values[1].length>1){
				m+=statDesc([_effect.values.values[1][1]],_tabs+1);
			}*/
			m+="</b></font>";
			
			return m;
		}
		
		override public function getTooltipDesc():String{
			if (rate>0){
				return "Miss Turn: <font color="+StringData.RED+"><b>"+String(Math.floor(rate*100))+"%</b></font>";
			}else{
				return "";
			}
		}
		
		override public function getEffectDesc():String{
			switch(name){
				case BuffData.GOLEM_CONFUSED: case BuffData.CONFUSED: case BuffData.DISORIENTED: return "Cause the enemy to have a chance of not acting.";
				case BuffData.STUNNED:
				case BuffData.ASLEEP: return "Prevent enemy from acting.";
				case BuffData.AFRAID: return "Cause the enemy to have a chance of not acting and move backwards.";
				case BuffData.ENTRANCED: return "Cause the enemy to have a chance of not acting and move forwards.";
				
				case BuffData.SILENCED: return "Cause the enemy to be unable to cast spells";
				case BuffData.ROOTED: return "Cause the enemy to be unable to move backwards of forwards.";
			}
			return getSpecialDesc();
		}
		
		override public function getSpecialDesc():String{
			switch(name){
				case BuffData.GOLEM_CONFUSED: case BuffData.CONFUSED: case BuffData.DISORIENTED: return "Chance of not acting.";
				case BuffData.STUNNED:
				case BuffData.ASLEEP: return "Cannot act.";
				case BuffData.AFRAID: return "Running in terror from opponent.";
				case BuffData.ENTRANCED: return "Fascinated by opponent.";
				
				case BuffData.SILENCED: return "Can't cast magic spells.";
				case BuffData.ROOTED: return "Cannot move forwards or backwards on your own.";
				case BuffData.INITIAL_NO_OFFENSIVE: return "Prevent offensive actions.";
			}
			
			return "";
		}
	}
}