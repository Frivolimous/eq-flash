package items{
	
	public class ItemScroll extends ItemModel{
		public function ItemScroll(_level:int,_v:ItemModel,_charges:int){
			level=_level;
			slot=ItemData.USEABLE;
			primary=ItemData.SCROLL;
			tags=[];

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
				cost=_v.cost*0.75;
				_Charges=_charges;
				action=_v.action;
				values=_v.values;
				if (action!=null){
					action.addSource(this);
				}
			}
			
			enchantIndex=-1;
			suffixIndex=-1;
		}
	}
}