package items {
	import ui.windows.ConfirmWindow;
	import ui.main.PremiumTab;
	import utils.GameData;
	import utils.PurchaseManager;
	
	public class SinglePremiumUI extends BaseInventoryUI{
		public function SinglePremiumUI(){
			itemA=[];
			NUM_SLOTS=1;
			itemA[0]=makeBox(0,0,0);
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
			
			PurchaseManager.buyItem(finishRemoveItem,-_item.model.cost,alsoUpdate);
			
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
