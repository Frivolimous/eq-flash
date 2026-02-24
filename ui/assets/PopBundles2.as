package ui.assets {
	import flash.display.Sprite;
	import utils.PurchaseManager;
	import utils.GameData;
	import items.ItemData;
	import ui.windows.ConfirmWindow;
	
	public class PopBundles2 extends Sprite{
		public var alldone:Boolean=false;

		public function PopBundles2() {
			doneB.update(StringData.DONE,closeWindow);
			detailsAcolyte.update("Details",popDetailsRogue);
			detailsAcolyte.setDesc("Details","Click to view details about the current selection.");
			detailsPaladin.update("Details",popDetailsRanger);
			detailsPaladin.setDesc("Details","Click to view details about the current selection.");
			
			if (!GameData.hasCosmetic(4,26)){
				buyAcolyte.update("Only 120 Tokens!",buyTree); buyAcolyte.index=7;
				buyAcolyte.setDesc("Purchase Rogue Bundle","Purchase this bundle for Power Tokens.");
			}else{
				buyAcolyte.update("Already Purchased!",nullFunction);
				buyAcolyte.disabled=true;
				buyAcolyte.setDesc("Purchase Rogue Bundle","You have already purchased this bundle.");
			}
			if (!GameData.hasCosmetic(4,27)){
				buyPaladin.update("Only 55 Tokens!",buyPack);
				buyPaladin.setDesc("Purchase Ranger Pack","Purchase this bundle for Power Tokens.");
			}else{
				buyPaladin.update("Already Purchased!",nullFunction);
				buyPaladin.disabled=true;
				buyPaladin.setDesc("Purchase Ranger Pack","You have already purchased this pack.");
			}
			if (buyAcolyte.disabled && buyPaladin.disabled) alldone=true;
		}
		
		
		function popDetailsRogue(){
			addChild(new PopRogue(update));
		}
		
		function popDetailsRanger(){
			addChild(new PopRanger(update));
		}
		function closeWindow(){
			parent.removeChild(this);
		}
		
		var buying:int;
		function buyTree(i:int=0){
			buying=i;
			PurchaseManager.buySpecial(finishBuyTree,PurchaseManager.PREMIUM_BUNDLE2);
		}
		
		function buyPack(i:int=0){
			PurchaseManager.buySpecial(finishBuyPack,PurchaseManager.MINI_BUNDLE2);
		}
		
		function update(){
			if (!GameData.hasCosmetic(4,26)){
				buyAcolyte.update("Only 120 Tokens!",buyTree); buyAcolyte.index=8;
				buyAcolyte.setDesc("Purchase Rogue Bundle","Purchase this bundle for Power Tokens.");
			}else{
				buyAcolyte.update("Already Purchased!",nullFunction);
				buyAcolyte.disabled=true;
				buyAcolyte.setDesc("Purchase Rogue Bundle","You have already purchased this bundle.");
			}
			if (!GameData.hasCosmetic(4,27)){
				buyPaladin.update("Only 55 Tokens!",buyPack);
				buyPaladin.setDesc("Purchase Ranger Pack","Purchase this bundle for Power Tokens.");
			}else{
				buyPaladin.update("Already Purchased!",nullFunction);
				buyPaladin.disabled=true;
				buyPaladin.setDesc("Purchase Ranger Pack","You have already purchased this pack.");
			}
		}
		
		function finishBuyTree(){
			if (buying==7){
				GameData.achieve(GameData.ACHIEVE_ROGUE);
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,132));
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,133));
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,134));
				GameData.addCosmetic(1,23);
				GameData.addCosmetic(3,8);
				GameData.addCosmetic(4,26);
				GameData.boost+=500;
				buyAcolyte.update("Already Purchased!",nullFunction);
				buyAcolyte.disabled=true;
				buyAcolyte.setDesc("Purchase Rogue Bundle","You have already purchased this bundle.");
				new ConfirmWindow("Congratulations on your purchase!  Respec your character to gain access to those trees and look in Overflow for your items.",50,50,null,0,null,3);
			}
		}
		
		function finishBuyPack(){
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,129));
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,130));
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,131));
			GameData.addCosmetic(3,7);
			GameData.addCosmetic(4,25);
			GameData.addCosmetic(4,27);
			GameData.boost+=500;
			buyPaladin.update("Already Purchased!",nullFunction);
			buyPaladin.disabled=true;
			buyPaladin.setDesc("Purchase Ranger Pack","You have already purchased this pack.");
			new ConfirmWindow("Congratulations on your purchase!  Respec your character to gain access to those trees and look in Overflow for your items.",50,50,null,0,null,3);
		}
		
		function nullFunction(i:int=0){
			
		}
	}
	
}
