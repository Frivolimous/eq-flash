package ui.assets {
	import flash.display.Sprite;
	import items.ItemData;
	import skills.SkillBed;
	import items.ItemView;
	import items.ItemModel;
	import utils.GameData;
	import utils.PurchaseManager;
	import ui.windows.ConfirmWindow;
	
	public class PopRanger extends Sprite{
		var onClose:Function;
		public function PopRanger(_onClose:Function=null) {
			onClose=_onClose;
			
			if (!GameData.hasCosmetic(4,27)){
				buyAcolyte.update("Only 55 Tokens!",buyBundle); buyAcolyte.index=8;
				buyAcolyte.setDesc("Purchase Ranger Pack","Purchase this bundle for Power Tokens.");
			}else{
				buyAcolyte.update("Already Purchased!",nullFunction);
				buyAcolyte.setDesc("Purchase Ranger Pack","You have already purchased this pack.");
				buyAcolyte.disabled=true;
			}
			doneB.update(StringData.DONE,closeWindow);
			icon0.front.gotoAndStop(130);
			icon0.back.gotoAndStop(1); icon0.border.gotoAndStop(1);
			icon1.front.gotoAndStop(131);
			icon1.back.gotoAndStop(1); icon1.border.gotoAndStop(1);
			icon2.front.gotoAndStop(132);
			icon2.back.gotoAndStop(2); icon2.border.gotoAndStop(2);
			var _item:ItemModel=ItemData.spawnItem(0,129);
			item0.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(0,130);
			item1.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(0,131);
			item2.setDesc(_item.name,StringData.getItemDesc(_item));
			item0.update(null,nullFunction);
			item1.update(null,nullFunction);
			item2.update(null,nullFunction);
		}
		
		
		function closeWindow(){
			if (onClose!=null) onClose();
			parent.removeChild(this);
		}
		
		function nullFunction(){
			
		}
		
		function buyBundle(i){
			PurchaseManager.buySpecial(finishBuyBundle,PurchaseManager.MINI_BUNDLE2);
		}
		
		function finishBuyBundle(){
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,129));
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,130));
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,131));
			GameData.addCosmetic(3,7);
			GameData.addCosmetic(4,25);
			GameData.addCosmetic(4,27);
			GameData.boost+=500;
			buyAcolyte.update("Already Purchased!",nullFunction);
			buyAcolyte.disabled=true;
			buyAcolyte.setDesc("Purchase Ranger Pack","You have already purchased this pack.");
			new ConfirmWindow("Congratulations on your purchase!  Respec your character to gain access to those trees and look in Overflow for your items.",50,50,null,0,null,3);
		}
	}
	
}
