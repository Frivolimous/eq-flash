package system.buffs{
	import system.actions.ActionBase;
	import system.effects.EffectData;
	
	public class BuffEnchantWeapon extends BuffStats{
		//public var values:Array;
		public var mult:int;
		public var effect:String;
		
		public function BuffEnchantWeapon(_index:int,_name:String,_level:int,_charges:int,_mult:int,_values:Array,_maxStacks:int=1){
			super(_index,_name,_level,BuffBase.BUFF,_charges,_values,_maxStacks);
			//effect=_effect;
			mult=_mult;
			
		}
		
		
		override public function modify(_v:SpriteModel,_moreMult:Number=1):BuffBase{
			//var m:BuffStats=new BuffStats(index,name,level,type,charges,values,maxStacks);
			var m:BuffEnchantWeapon=clone() as BuffEnchantWeapon;
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
			
			values[0][2].damage*=(_multValue+1)/2;
			
			super.modifyThis(_v,_moreMult);
		}
		
		override public function clone():BuffBase{
			return new BuffEnchantWeapon(index,name,level,charges,mult,cloneValues(),maxStacks);
		}
		
		override public function addStacksFrom(_removed:BuffBase){
			if (_removed.stacks<maxStacks){
				values[0][2]+=(_removed as BuffStats).values[0][2];
			}else{
				values[0][2]=(_removed as BuffStats).values[0][2];
			}
			
			super.addStacksFrom(_removed);
		}
		
		override public function wasAddedTo(_v:SpriteModel,_existing:BuffBase=null){
			if (_existing!=null){
				_v.statRemove(values);
				
				if (_existing.view!=null) _existing.view.newModel(this);
				if (maxStacks>1){
					addStacksFrom(_existing);
				}
			}
			_v.statAdd(values);
		}
				
		override public function wasRemovedFrom(_v:SpriteModel){
			_v.statRemove(values);
		}
		
		override public function getDesc():String{
			var m:String=name;
			
			if (charges>0){
				m+="<font color="+StringData.RED+"> x"+charges+"</font>\n";
			}else{
				m+="\n";
			}
			//if (values.length>0) m+=StringData.statDesc(values,_tabs+1);
			if (values.length>0) m+=StringData.statDesc(values,2);
			
			return m;
		}
	}
}