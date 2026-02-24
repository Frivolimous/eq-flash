package ui.assets {
	import flash.display.Sprite;
	import utils.PurchaseManager;
	import utils.GameData;
	import items.ItemData;
	import ui.windows.ConfirmWindow;
	
	public class PopBundles extends Sprite{
		public var alldone:Boolean=false;

		public function PopBundles() {
			doneB.update(StringData.DONE,closeWindow);
			detailsAcolyte.update("Details",popDetailsAcolyte);
			detailsAcolyte.setDesc("Details","Click to view details about the current selection.");
			detailsPaladin.update("Details",popDetailsPaladin);
			detailsPaladin.setDesc("Details","Click to view details about the current selection.");
			
			if (!GameData.hasCosmetic(1,18)){
				buyAcolyte.update("Only 100 Tokens!",buyTree); buyAcolyte.index=5;
				buyAcolyte.setDesc("Purchase Acolyte Bundle","Purchase this bundle for Power Tokens.");
			}else{
				buyAcolyte.update("Already Purchased!",nullFunction);
				buyAcolyte.disabled=true;
				buyAcolyte.setDesc("Purchase Acolyte Bundle","You have already purchased this bundle.");
			}
			if (!GameData.hasCosmetic(4,8)){
				buyPaladin.update("Only 100 Tokens!",buyTree); buyPaladin.index=6;
				buyPaladin.setDesc("Purchase Paladin Bundle","Purchase this bundle for Power Tokens.");
			}else{
				buyPaladin.update("Already Purchased!",nullFunction);
				buyPaladin.disabled=true;
				buyPaladin.setDesc("Purchase Paladin Bundle","You have already purchased this bundle.");
			}
			if (buyAcolyte.disabled && buyPaladin.disabled) alldone=true;
		}
		
		
		function popDetailsAcolyte(){
			addChild(new PopAcolyte(update));
		}
		
		function popDetailsPaladin(){
			addChild(new PopPaladin);
		}
		function closeWindow(){
			parent.removeChild(this);
		}
		
		var buying:int;
		function buyTree(i:int){
			buying=i;
			PurchaseManager.buySpecial(finishBuyTree,PurchaseManager.PREMIUM_BUNDLE);
		}
		
		function update(){
			if (!GameData.hasCosmetic(1,18)){
				buyAcolyte.update("Only 100 Tokens!",buyTree); buyAcolyte.index=5;
				buyAcolyte.setDesc("Purchase Acolyte Bundle","Purchase this bundle for Power Tokens.");
			}else{
				buyAcolyte.update("Already Purchased!",nullFunction);
				buyAcolyte.disabled=true;
				buyAcolyte.setDesc("Purchase Acolyte Bundle","You have already purchased this bundle.");
			}
			if (!GameData.hasCosmetic(4,8)){
				buyPaladin.update("Only 100 Tokens!",buyTree); buyPaladin.index=6;
				buyPaladin.setDesc("Purchase Paladin Bundle","Purchase this bundle for Power Tokens.");
			}else{
				buyPaladin.update("Already Purchased!",nullFunction);
				buyPaladin.disabled=true;
				buyPaladin.setDesc("Purchase Paladin Bundle","You have already purchased this bundle.");
			}
		}
		
		function finishBuyTree(){
			if (buying==5){
				GameData.achieve(GameData.ACHIEVE_ACOLYTE);
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,112));
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,116));
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,117));
				GameData.addCosmetic(1,18);
				GameData.boost+=500;
				buyAcolyte.update("Already Purchased!",nullFunction);
				buyAcolyte.disabled=true;
				buyAcolyte.setDesc("Purchase Acolyte Bundle","You have already purchased this bundle.");
				new ConfirmWindow("Congratulations on your purchase!  Respec your character to gain access to those trees and look in Overflow for your items.",50,50,null,0,null,3);
			}else if (buying==6){
				GameData.achieve(GameData.ACHIEVE_PALADIN);
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,113));
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,114));
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,115));
				GameData.addCosmetic(4,8);
				GameData.boost+=500;
				buyPaladin.update("Already Purchased!",nullFunction);
				buyPaladin.disabled=true;
				buyPaladin.setDesc("Purchase Paladin Bundle","You have already purchased this bundle.");
				new ConfirmWindow("Congratulations on your purchase!  Respec your character to gain access to those trees and look in Overflow for your items.",50,50,null,0,null,3);
			}
		}
		
		function nullFunction(i:int=0){
			
		}
	}
	
}
