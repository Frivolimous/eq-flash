package ui.main{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import skills.SkillData;
	import items.*
	import ui.windows.ConfirmWindow;
	import ui.assets.FadeTransition;
	
	public class ShopTab extends Sprite{
		
		public var shopInv:ShopInventoryUI;
		public var inventory:StoreInventoryUI;
		
		public function ShopTab(){
			fillTabB.update(StringData.FILLSTACK,toggleFill);
			removeChild(fillAllUI);
			shopInv=new ShopInventoryUI();
			addChild(shopInv);
		}
		
		public function setInventory(_inventory:StoreInventoryUI){
			inventory=_inventory;
			restackUI.init(SingleInventoryUI.STACK,_inventory);
			fillAllUI.init(_inventory);
			_inventory.alsoUpdate=fillAllUI.update;
		}
		
		public function lockInventory(b:Boolean){
			shopInv.locked=b;
			restackUI.locked=b;
		}
		
		public function update(_player:*){
			shopInv.update(_player);
			fillAllUI.update(_player);
		}
		
		/*public function noGold(){
			new ConfirmWindow(StringData.CONF_GOLD);
		}*/
		
		public function restock(){
			shopInv.clear();
			var _level:int=Math.ceil(Facade.gameM.area/10);
			if (_level>15) _level=15;
			
			shopInv.addItemAt(new ItemView(ItemData.spawnItem(_level,1)),0);
			shopInv.addItemAt(new ItemView(ItemData.spawnItem(_level,3)),1);
			shopInv.addItemAt(new ItemView(ItemData.spawnItem(_level,5)),2);
			shopInv.addItemAt(new ItemView(ItemData.spawnItem(_level,7)),3);
			shopInv.addItemAt(new ItemView(ItemData.spawnItem(_level,8)),4);
			
			shopInv.addItemAt(new ItemView(ItemData.spawnItem(_level,11)),5);
			shopInv.addItemAt(new ItemView(ItemData.spawnItem(_level,12)),6);
			shopInv.addItemAt(new ItemView(ItemData.spawnItem(_level,126)),7);
			
			shopInv.addItemAt(new ItemView(ItemData.spawnItem(_level,37,10)),10);
			shopInv.addItemAt(new ItemView(ItemData.spawnItem(_level,38,10)),11);
			shopInv.addItemAt(new ItemView(ItemData.spawnItem(_level,39,25)),12);
			shopInv.addItemAt(new ItemView(ItemData.spawnItem(_level,34,6)),13);
			shopInv.addItemAt(new ItemView(ItemData.spawnItem(_level,35,6)),14);
			
			shopInv.addItemAt(new ItemView(ItemData.spawnItem(_level,31,6)),15);
			shopInv.addItemAt(new ItemView(ItemData.spawnItem(_level,31,6)),16);
			shopInv.addItemAt(new ItemView(ItemData.spawnItem(_level,31,6)),17);
			shopInv.addItemAt(new ItemView(ItemData.spawnItem(_level,32,6)),18);
			shopInv.addItemAt(new ItemView(ItemData.spawnItem(_level,32,6)),19);
			
			for (var i:int=0;i<20;i+=1){
				if (shopInv.itemA[i].stored!=null){
					shopInv.itemA[i].stored.model.cost*=4;
				}
			}
		}
		
		public function toggleFill(){
			if (contains(restackUI)){
				removeChild(restackUI);
				addChild(fillAllUI);
				fillTabB.updateLabel(StringData.FILLALL);
				restackUI.removeValues();
			}else{
				removeChild(fillAllUI);
				addChild(restackUI);
				fillTabB.updateLabel(StringData.FILLSTACK);
			}
		}
		
		public function closeWindow(){
			restackUI.removeValues();
		}
	}
}