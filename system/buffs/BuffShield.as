package system.buffs{
	
	public class BuffShield extends BuffBase{		
		public var mult:int;
		public var shield:Number;
		
		var origin:SpriteModel;
		
		public function BuffShield(_index:int,_name:String,_level:int,_charges:int,_mult:int,_shield:Number,_maxStacks:int=1){
			name=_name;
			index=_index;
			level=_level;
			type=BuffBase.BUFF;
			_Charges=_charges;
			mult=_mult;
			shield=_shield;
			maxStacks=_maxStacks;
		}
		
		override public function modify(_v:SpriteModel,_moreMult:Number=1):BuffBase{
			var m:BuffShield=clone() as BuffShield;
			m.modifyThis(_v,_moreMult);
			return m;
		}
		
		override public function modifyThis(_v:SpriteModel,_moreMult:Number=1){
			if (name==BuffData.SHIELD){
				stacks=3;
			}else{
				stacks=1;
			}
		}
		
		override public function clone():BuffBase{
			return new BuffShield(index,name,level,charges,mult,shield,maxStacks);
		}
				
		override public function addStacksFrom(_removed:BuffBase){
			super.addStacksFrom(_removed);
		}
		
		override public function getDesc():String{
			var m:String=name;
			
			if (shield>=1){
				m+="<font color="+StringData.RED+"><b> "+String(Math.floor(shield))+"</b></font>";
			}else{
				m+="<font color="+StringData.RED+"><b> "+String(Math.floor(shield*100))+"%</b></font> of Damage Taken.";
			}
			if (mult>-1) m+="\nScaling Stat: <font color="+StringData.RED+"><b> Half "+StatModel.statNames[mult]+"</b></font>"
			if (maxStacks>1){
				m+="\nMax Stacks: <font color="+StringData.RED+"><b>"+String(Math.floor(maxStacks))+"</b></font>";
			}
			return m;
		}
		
		override public function wasAddedTo(_v:SpriteModel,_existing:BuffBase=null){
			origin=_v;
			
			super.wasAddedTo(_v,_existing);
		}
											
		public function getReduction(_v:SpriteModel,_dmg:Number):Number{
			var _shield:Number=shield;
			if (mult>-1){
				var _multValue:Number=_v.stats.getValue(mult);
				switch(mult){
					case StatModel.STRENGTH: case StatModel.INITIATIVE: case StatModel.MPOWER: case StatModel.BLOCK:
						_multValue/=100;
				}
				_shield*=1+(_multValue-1)/2;
			}
			
			_shield*=_v.stats.getValue(StatModel.HEALMULT);
			
			var _reduction:Number=0;
			while (stacks>0 && _reduction<_dmg){
				_reduction+=_shield;
				stacks-=1;
				if (_reduction>_dmg) _reduction=_dmg;
			}
			if (stacks<=0){
				_v.buffList.removeBuffCalled(name);
			}else if (view!=null){
				view.upgrade((stacks-1)/(maxStacks-1));
			}
			
			
			return _reduction;
		}
		
		override public function getTooltipDesc():String{
			var _shield:Number=shield;
			
			if (mult>-1){
				var _multValue:Number=origin.stats.getValue(mult);
				switch(mult){
					case StatModel.STRENGTH: case StatModel.INITIATIVE: case StatModel.MPOWER: case StatModel.BLOCK:
						_multValue/=100;
				}
				_shield*=1+(_multValue-1)/2;
			}
			_shield*=origin.stats.getValue(StatModel.HEALMULT);
			_shield*=stacks;
			return "Shielding: <font color="+StringData.RED+"><b> "+String(Math.floor(_shield))+"</b></font>";
			
		}
		
		override public function getEffectDesc():String{
			switch(name){
				case BuffData.SHIELD: return "Prevent up to this amount of damage next time you receive damage.\n\n*Adds 3 Stacks on cast.";
				case BuffData.BARRIER: return "add a Barrier Stack to protect you from incoming damage.";
			}
			return getSpecialDesc();
		}
		
		override public function getSpecialDesc():String{
			return "Prevent up to this amount of damage next time you receive damage.";
		}
	}
}