package ui.assets {
	import flash.display.Sprite;
	import utils.KongregateAPI;
	import utils.GameData;
	import items.ItemData;
	import ui.windows.ConfirmWindow;
	import items.ItemModel;
	
	public class PopRelicBundles extends Sprite{
		
		public function PopRelicBundles() {
			doneB.update(StringData.DONE,closeWindow);
			update();
			
			visorO.update(null,nullFunction);
			heartO.update(null,nullFunction);
			gogglesO.update(null,nullFunction);
			monacleO.update(null,nullFunction);
			screamO.update(null,nullFunction);
			muzzleO.update(null,nullFunction);
			puzzleO.update(null,nullFunction);
			wolfO.update(null,nullFunction);
			
			var _item:ItemModel=ItemData.spawnItem(1,137);
			screamO.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(1,138);
			puzzleO.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(1,139);
			wolfO.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(1,140);
			muzzleO.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(1,141);
			visorO.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(1,142);
			heartO.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(1,143);
			monacleO.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(1,144);
			gogglesO.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(1,145);
			
			if (Facade.currentUI!=null) Facade.currentUI.addChild(this);
		}
		
		function update(){
			button0.update("55 Tokens!",buyBundle);
			button0.index=1;
			button0.setDesc("Purchase Pack!","Purchase this bundle for Power Tokens.");
			
			button1.update("55 Tokens!",buyBundle);
			button1.index=0;
			button1.setDesc("Purchase Pack!","Purchase this bundle for Power Tokens.");
		}
		
		function closeWindow(){
			parent.removeChild(this);
		}
		
		var buying:int;
		function buyBundle(i:int){
			buying=i;
			KongregateAPI.buySpecial(finishBuyBundle,KongregateAPI.MINI_BUNDLE2);
		}
		
		function finishBuyBundle(){
			new ConfirmWindow("Congratulations on your purchase!  Your items are in your overflow.",50,50,null,0,null,3);
			
			if (buying==0){
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,137));
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,138));
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,139));
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,140));
				GameData.boost+=250;
			}else if (buying==1){
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,141));
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,142));
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,143));
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,144));
				GameData.boost+=250;
				
			}
		}
		
		function nullFunction(i:int=0){
			
		}
	}
	
}
