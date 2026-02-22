package items {
	import ui.windows.ConfirmWindow;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import utils.GameData;
	import utils.KongregateAPI;
	
	public class CraftShopUI extends BaseInventoryUI{
		public var dropTo:BaseInventoryUI;
		public var useSouls:Boolean=false;
		
		public function CraftShopUI(){
			IWIDTH=32.5;
			IHEIGHT=34;
			
			for (var i:int=0;i<4;i+=1){
				itemA[i]=makeBox(i,i*51,0);
			}
			restock();
		}
		
		override public function addItem(_item:ItemView):Boolean{
			return false;
		}
		
		override public function check(_item:ItemView,i:int):Boolean{
			return false;
		}
		
		override public function removeItem(_item:ItemView):Boolean{
			itemBuying=_item;
			//kred purchase window
			if ((dropTo as ForgeIngredientsUI).isFull()){
				new ConfirmWindow("Please clear out this slot before purchasing an essence.");
				return false;
			}
			if (_item.model.cost<=-1000){
				KongregateAPI.buyItemSouls(finishRemoveItem,-_item.model.cost,alsoUpdate);
			}else{
				KongregateAPI.buyItem(finishRemoveItem,-_item.model.cost,alsoUpdate);
			}
			
			return false;
		}
		
		var itemBuying:ItemView;
		
		public function finishRemoveItem(){
			//use kreds
			
			//ItemData.finishGamble(itemBuying); ???
			
			//itemBuying.model._Cost=500;
			
			itemA[itemBuying.index].removeItem();
			var _item:ItemModel=ItemData.spawnItem(itemBuying.model.level,itemBuying.model.index)
			if (itemBuying.model.enchantIndex>=0) _item=ItemData.enchantItem(_item,itemBuying.model.enchantIndex);
			
			dropTo.addItem(new ItemView(_item));
			
			if (alsoUpdate!=null) alsoUpdate();
			restock();
			Facade.saveC.saveChar();
		}
		
		override public function sell(_item:ItemView){
			
		}
		
		public function restock(_forced:Boolean=false){
			if (_forced){
				itemA[0].removeItem();
				itemA[1].removeItem();
				itemA[2].removeItem();
				itemA[3].removeItem();
			}
			if (useSouls){
				if (!itemA[0].hasItem()){
					addItemAt(new ItemView(ItemData.enchantItem(ItemData.spawnItem(15,135),0)),0);
					itemA[0].stored.model.cost=-25000;
				}
				if (!itemA[1].hasItem()){
					addItemAt(new ItemView(ItemData.spawnItem(15,135)),1);
					itemA[1].stored.model.cost=-300000;
				}
				if (!itemA[2].hasItem()){
					addItemAt(new ItemView(ItemData.enchantItem(ItemData.spawnItem(15,135),1)),2);
					itemA[2].stored.model.cost=-150000;
				}
				if (!itemA[3].hasItem()){
					addItemAt(new ItemView(ItemData.enchantItem(ItemData.spawnItem(15,135),2)),3);
					itemA[3].stored.model.cost=-50000;
				}
			}else{
				if (!itemA[0].hasItem()){
					addItemAt(new ItemView(ItemData.enchantItem(ItemData.spawnItem(15,135),0)),0);
					itemA[0].stored.model.cost=-10;
				}
				if (!itemA[1].hasItem()){
					addItemAt(new ItemView(ItemData.spawnItem(15,135)),1);
					itemA[1].stored.model.cost=-20;
				}
				if (!itemA[2].hasItem()){
					addItemAt(new ItemView(ItemData.enchantItem(ItemData.spawnItem(15,135),1)),2);
					itemA[2].stored.model.cost=-15;
				}
				if (!itemA[3].hasItem()){
					addItemAt(new ItemView(ItemData.spawnItem(15,136)),3);
					itemA[3].stored.model.cost=-15;
				}
			}
		}
	}
}
