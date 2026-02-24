package items{
	
	public class ItemScroll extends ItemModel{
		public function ItemScroll(_level:int,_v:ItemModel,_charges:int){
			level=_level;
			slot=ItemData.USEABLE;
			primary=ItemData.SCROLL;
			
			if (_v==null){
				index=62;
				name="Scroll";
				secondary=null;
				cost=60;
				_Charges=-1;
			}else{
				index=_v.index+36;
				name=_v.name+" Scroll";
				secondary=_v.secondary;
				cost=60*(1+_level/2);
				_Charges=_charges;
				action=_v.action;
				values=_v.values;
				if (action!=null){
					action.addSource(this);
				}
				tags=[];
				/*tags=_tags;
				if (tags==null) tags=[];
				if (level>15) tags.push(EffectData.EPIC);*/
			}
			
			enchantIndex=-1;
			suffixIndex=-1;
		}
	}
}