package items{
	import system.actions.ActionBase;
	import system.effects.EffectData;
	
	public class ItemEquipment extends ItemModel{
		public function ItemEquipment(_index:int,_name:String,_level:int,_primary:String,_secondary:String,_cost:int,_action:ActionBase=null,_values:Array=null,_tags:Array=null){
			index=_index;
			name=_name;
			level=_level;
			slot=ItemData.EQUIPMENT;
			primary=_primary;
			secondary=_secondary;
			
			tags=_tags;
			if (tags==null) tags=[];
			if (level>15) tags.push(EffectData.EPIC);
			
			if (_level<0){
				cost=_cost;
			}else{
				cost=_cost*(1+_level/2);
			}
			_Charges=-1;
			
			action=_action;
			if (action!=null){
				action.addSource(this);
			}
			
			if (_values==null){
				values=[];
			}else{
				values=_values;
			}
			
			enchantIndex=-1;
			suffixIndex=-1;
			if (level>15){
				levelModValues(values,level);
			}
		}
	}
}