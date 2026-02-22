package system.buffs{
	
	public class BuffDelayedDmg extends BuffBase{
		public var mult:int;
		public var damage:Number;
		public var damageType:int;
		public var shred:Number;
		
		public function BuffDelayedDmg(_index:int,_name:String,_level:int,_charges:int,_mult:int=-1,_damage:Number=0,_damageType:int=0,_shred:Number=0,_maxStacks:int=1){
			name=_name;
			index=_index;
			level=_level;
			type=BuffBase.CURSE;
			_Charges=_charges;
			mult=_mult;
			damage=_damage;
			damageType=_damageType;
			shred=_shred;
			maxStacks=_maxStacks;
		}
		
		override public function modify(_v:SpriteModel,_moreMult:Number=1):BuffBase{
			var m:BuffDelayedDmg=clone() as BuffDelayedDmg;
			m.modifyThis(_v,_moreMult);
			return m;
		}
		
		override public function modifyThis(_v:SpriteModel,_moreMult:Number=1){
			var _multValue:Number=_moreMult;
			
			if (mult>-1){
				_multValue*=_v.stats.getValue(mult);
				switch(mult){
					case StatModel.STRENGTH: case StatModel.INITIATIVE: case StatModel.MPOWER: case StatModel.BLOCK:
						_multValue/=100;
				}
			}
			
			damage*=_multValue;
			if (name==BuffData.DELAYED_DAMAGE && damageType==DamageModel.PHYSICAL){
				damageType=_v.actionList.attack.type;
			}
			
			switch(damageType){
				case DamageModel.HOLY: damage*=_v.stats.getValue(StatModel.HOLYEFF); break;
				case DamageModel.CHEMICAL: damage*=_v.stats.getValue(StatModel.CHEMEFF); break;
				case DamageModel.MAGICAL: damage*=_v.stats.getValue(StatModel.MAGICEFF); break;
				case DamageModel.PHYSICAL: damage*=_v.stats.getValue(StatModel.PHYSEFF); break;
				case DamageModel.DARK: damage*=_v.stats.getValue(StatModel.DARKEFF); break;
			}
			super.modifyThis(_v,_moreMult);
		}
		
		override public function clone():BuffBase{
			return new BuffDelayedDmg(index,name,level,charges,mult,damage,damageType,shred,maxStacks);
		}
		
		override public function addStacksFrom(_removed:BuffBase){
			if (_removed.stacks<maxStacks){
				damage+=(_removed as BuffDelayedDmg).damage;
			}else{
				damage=(_removed as BuffDelayedDmg).damage;
			}
			
			super.addStacksFrom(_removed);
		}
		
		override public function wasAddedTo(_v:SpriteModel,_existing:BuffBase=null){
			if (_existing==null){
				if (shred>0) _v.stats.subValue(StatModel.HEALMULT,shred);
			}else{
				if (_existing.view!=null) _existing.view.newModel(this);
				if (maxStacks>1){
					addStacksFrom(_existing);
				}
			}
		}
		
		override public function wasRemovedFrom(_v:SpriteModel){
			if (shred>0) _v.stats.addValue(StatModel.HEALMULT,shred);
		}
		
		override public function getDesc():String{
			var m:String=name;
			
			if (name==BuffData.DELAYED_DAMAGE && stacks==0){
				m+="<font color="+StringData.RED+"><b> "+String(Math.floor(damage*100))+"%"+DamageModel.shortTypeName[damageType].substr(0,1)+" x"+charges+"</b></font>";
			}else{
				m+="<font color="+StringData.RED+"><b> "+String(Math.floor(damage))+DamageModel.shortTypeName[damageType].substr(0,1)+" x"+charges+"</b></font>";
			}
			if (shred>0){
				m+="\n  HEAL: <font color="+StringData.RED+"><b>-"+String(Math.floor(shred*100))+"%</b></font>";
			}
			if (maxStacks>1){
				m+="\nMax Stacks: <font color="+StringData.RED+"><b>"+String(Math.floor(maxStacks))+"</b></font>";
			}
			return m;
		}
		
		override public function update(_v:SpriteModel,_dmg:DamageModel){
			_dmg.setDmg(damage,damageType);
			super.update(_v,_dmg);
			
			graphicUpdateBuff(_v);
		}
		
		override public function getTooltipDesc():String{
			var m:String="Damage: ";
			if (name==BuffData.DELAYED_DAMAGE && stacks==0){
				m+="<font color="+StringData.RED+"><b> "+String(Math.floor(damage*100))+"%"+DamageModel.shortTypeName[damageType].substr(0,1)+"</b></font>";
			}else{
				m+="<font color="+StringData.RED+"><b> "+String(Math.floor(damage))+DamageModel.shortTypeName[damageType].substr(0,1)+"</b></font>";
			}
			if (shred>0){
				m+="\nHEAL: <font color="+StringData.RED+"><b>-"+String(Math.floor(shred*100))+"%</b></font>";
			}
			
			return m;
		}
		
		override public function getEffectDesc():String{
			return "Deal "+DamageModel.fullTypeName[damageType]+" damage over time"+(name==BuffData.DELAYED_DAMAGE?" based on damage dealt.":".");
		}
		
		override public function getSpecialDesc():String{
			return "Takes "+DamageModel.fullTypeName[damageType]+" damage over time.";
		}
	}
}