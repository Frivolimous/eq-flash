package items{
	import system.actions.ActionData;
	
	public class ItemUnarmed extends ItemModel{
		
		public function ItemUnarmed(){
			index=-2;
			name=ItemData.UNARMED;
			level=0;
			slot=ItemData.EQUIPMENT;
			primary=ItemData.WEAPON;
			secondary=ItemData.UNARMED;
			
			tags=[];
			cost=0;
			_Charges=-1;
			
			action=ActionData.makeWeapon(10);
			action.addSource(this);
			values=[[SpriteModel.STAT,StatModel.BLOCK,0]];
			
			enchantIndex=-1;
			suffixIndex=-1;
		}
	}
}