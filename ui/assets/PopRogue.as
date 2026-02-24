package ui.assets {
	import flash.display.Sprite;
	import items.ItemData;
	import skills.SkillBed;
	import items.ItemView;
	import items.ItemModel;
	import utils.GameData;
	import utils.PurchaseManager;
	import ui.windows.ConfirmWindow;
	
	public class PopRogue extends Sprite{
		var onClose:Function;
		public function PopRogue(_onClose:Function=null) {
			onClose=_onClose;
			
			setTreeB(!GameData.hasAchieved(GameData.ACHIEVE_ROGUE));
			setPackB(!GameData.hasCosmetic(4,26));
			setBundleB(!GameData.hasAchieved(GameData.ACHIEVE_ROGUE) && !GameData.hasCosmetic(4,26));
			
			doneB.update(StringData.DONE,closeWindow);
			var _skillBed:SkillBed=new SkillBed(7);
			_skillBed.x=400;
			_skillBed.y=105;
			addChild(_skillBed);
			icon0.front.gotoAndStop(133);
			icon0.back.gotoAndStop(1); icon0.border.gotoAndStop(1);
			icon1.front.gotoAndStop(134);
			icon1.back.gotoAndStop(1); icon1.border.gotoAndStop(1);
			icon2.front.gotoAndStop(135);
			icon2.back.gotoAndStop(2); icon2.border.gotoAndStop(2);
			var _item:ItemModel=ItemData.spawnItem(0,132);
			item0.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(0,133);
			item1.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(0,134);
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
		
		function buySkillTree(){
			PurchaseManager.buySpecial(finishBuyTree,PurchaseManager.PREMIUM_CLASS);
		}
		
		function finishBuyTree(){
			GameData.achieve(GameData.ACHIEVE_ROGUE);
			setTreeB(false);
			setBundleB(false);
			new ConfirmWindow("Congratulations on your purchase!  Respec your character to gain access to those trees.",50,50,null,0,null,3);
		}
		
		function buyBundle(i){
			PurchaseManager.buySpecial(finishBuyBundle,PurchaseManager.PREMIUM_BUNDLE2);
		}
		
		function finishBuyBundle(){
			GameData.achieve(GameData.ACHIEVE_ROGUE);
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,132));
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,133));
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,134));
			GameData.addCosmetic(1,23);
			GameData.addCosmetic(3,8);
			GameData.addCosmetic(4,26);
			GameData.boost+=500;
			setPackB(false);
			setBundleB(false);
			setTreeB(false);
			new ConfirmWindow("Congratulations on your purchase!  Respec your character to gain access to those trees and look in Overflow for your items.",50,50,null,0,null,3);
		}
		
		function buyPack(){
			PurchaseManager.buySpecial(finishBuyPack,PurchaseManager.MINI_BUNDLE3);
		}
		
		function finishBuyPack(){
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,132));
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,133));
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,134));
			GameData.addCosmetic(1,23);
			GameData.addCosmetic(3,8);
			GameData.addCosmetic(4,26);
			GameData.boost+=500;
			setPackB(false);
			setBundleB(false);
			new ConfirmWindow("Congratulations on your purchase!  Look in Overflow for your items.",50,50,null,0,null,3);
		}
		
		function setTreeB(b:Boolean){
			if (b){
				buySkill.update("55 Tokens",buySkillTree);
				buySkill.setDesc("Buy Skill Tree ONLY","Purchase the Rogue Skill Tree for 55 Power Tokens without the bundled goods.");
			}else{
				buySkill.update("Purchased",nullFunction);
				buySkill.setDesc("Skill Tree Owned","You have already unlocked this skill tree.");
				buySkill.disabled=true;
			}
		}
		
		function setBundleB(b:Boolean){
			if (b){
				buyAcolyte.update("Only 100 Tokens!",buyBundle); buyAcolyte.index=5;
				buyAcolyte.setDesc("Purchase Rogue Bundle","Purchase this bundle for Tokens.");
			}else{
				buyAcolyte.update("Already Purchased!",nullFunction);
				buyAcolyte.setDesc("Purchase Rogue Bundle","You have already purchased this bundle.");
				buyAcolyte.disabled=true;
			}
		}
		
		function setPackB(b:Boolean){
			if (b){
				packB.update("75 Tokens",buyPack);
				packB.setDesc("Purchase Pack without Class","Purchase the items, cosmetic and boosts without the Rogue Class.");
			}else{
				if (contains(packB)) removeChild(packB);
			}
		}
	}
	
}
