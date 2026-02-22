package system.buffs{
	
	public class BuffMOT extends BuffBase{
		var mult:int;
		public var healing:Number;
		public var healType:int;
		
		public function BuffMOT(_index:int,_name:String,_level:int,_charges:int,_mult:int=-1,_healing:Number=0,_healType:int=0,_maxStacks:int=1){
			name=_name;
			index=_index;
			level=_level;
			type=BuffBase.BUFF;
			_Charges=_charges;
			mult=_mult;
			healing=_healing;
			healType=_healType;
			maxStacks=_maxStacks;
		}
		
		override public function modify(_v:SpriteModel,_moreMult:Number=1):BuffBase{
			var m:BuffMOT=clone() as BuffMOT;
			m.modifyThis(_v,_moreMult);
			return m;
		}
		
		override public function modifyThis(_v:SpriteModel,_moreMult:Number=1){
			var _multValue:Number=_moreMult*_v.stats.getValue(StatModel.DOTEFF)*_v.stats.getValue(StatModel.PROCEFF)*_v.stats.getValue(StatModel.HEALMULT);
			
			if (mult>-1){
				_multValue*=_v.stats.getValue(mult);
				switch(mult){
					case StatModel.STRENGTH: case StatModel.INITIATIVE: case StatModel.MPOWER: case StatModel.BLOCK:
						_multValue/=100;
				}
			}
			
			healing*=_multValue;
			
			switch(healType){
				case DamageModel.HOLY: healing*=_v.stats.getValue(StatModel.HOLYEFF); break;
				case DamageModel.CHEMICAL: healing*=_v.stats.getValue(StatModel.CHEMEFF); break;
				case DamageModel.MAGICAL: healing*=_v.stats.getValue(StatModel.MAGICEFF); break;
				case DamageModel.PHYSICAL: healing*=_v.stats.getValue(StatModel.PHYSEFF); break;
				case DamageModel.DARK: healing*=_v.stats.getValue(StatModel.DARKEFF); break;
			}

			super.modifyThis(_v,_moreMult);
		}
		
		override public function clone():BuffBase{
			return new BuffMOT(index,name,level,charges,mult,healing,healType,maxStacks);
		}
		
		override public function addStacksFrom(_removed:BuffBase){
			if (_removed.stacks<maxStacks){
				healing+=(_removed as BuffMOT).healing;
			}else{
				healing=(_removed as BuffMOT).healing;
			}
			
			super.addStacksFrom(_removed);
		}
		
		override public function getDesc():String{
			var m:String=name;
			m+="<font color="+StringData.RED+"><b> "+String(Math.floor(healing))+DamageModel.shortTypeName[healType].substr(0,1)+" x"+charges+"</b></font>";
			if (maxStacks>1){
				m+="\nMax Stacks: <font color="+StringData.RED+"><b>"+String(Math.floor(maxStacks))+"</b></font>";
			}
			return m;
		}
		
		override public function update(_v:SpriteModel,_dmg:DamageModel){
			//_dmg.addHeal(healing);
			_v.mana+=healing;
			super.update(_v,_dmg);
			
			graphicUpdateBuff(_v);
		}
		
		override public function getTooltipDesc():String{
			var m:String="Healing: ";
			m+="<font color="+StringData.RED+"><b> "+String(Math.floor(healing))+DamageModel.shortTypeName[healType].substr(0,1)+"</b></font>";
			
			return m;
		}
		
		override public function getEffectDesc():String{
			return getSpecialDesc();
		}
		
		override public function getSpecialDesc():String{
			return "Get "+DamageModel.fullTypeName[healType]+" healing over time.";
		}
	}
}