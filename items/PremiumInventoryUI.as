package items {
	import ui.windows.ConfirmWindow;
	import ui.main.PremiumTab;
	import utils.KongregateAPI;
	import system.effects.EffectData;
	
	public class PremiumInventoryUI extends BaseInventoryUI{
		public function PremiumInventoryUI(){
			itemA=new Array(3);
			NUM_SLOTS=3;
			for (var i:int=0;i<3;i+=1){
				itemA[i]=makeBox(i,i*41.5,-1);
			}
		}
				
		override public function addItem(_item:ItemView):Boolean{
			return false;
		}
		
		override public function dropItem(_item:ItemView,i:int){
			_item.location.returnItem(_item);
		}
		
		override public function check(_item:ItemView,i:int):Boolean{
			return false;
		}

		
		override public function removeItem(_item:ItemView):Boolean{
			itemBuying=_item;
			//kred purchase window
			if ((parent as PremiumTab).inventory.isFull()){
				return false;
			}
			
			if (_item.model.hasTag(EffectData.SUPER_PREMIUM)){
				KongregateAPI.buyItem(finishRemoveItem,20,alsoUpdate);
			}else{
				KongregateAPI.buyItem(finishRemoveItem,15,alsoUpdate)
			}
			
			return false;
		}
		
		var itemBuying:ItemView;
		
		public function finishRemoveItem(){
			//use kreds
			
			//ItemData.finishGamble(itemBuying); ???
			
			//itemBuying.model._Cost=500;
			
			itemA[itemBuying.index].removeItem();
			
			(parent as PremiumTab).inventory.addItem(new ItemView(ItemData.spawnItem(itemBuying.model.level,itemBuying.model.index)));
			
			if (alsoUpdate!=null) alsoUpdate();
			Facade.saveC.saveChar();
		}
		
		override public function sell(_item:ItemView){
			
		}
	}
}
