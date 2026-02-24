package ui.assets {
	import flash.display.Sprite;
	import items.ItemData;
	import skills.SkillBed;
	import items.ItemView;
	import items.ItemModel;
	import utils.GameData;
	import utils.PurchaseManager;
	import ui.windows.ConfirmWindow;
	
	public class PopAcolyte extends Sprite{
		var onClose:Function;
		public function PopAcolyte(_onClose:Function=null) {
			onClose=_onClose;
			
			setTreeB(!GameData.hasAchieved(GameData.ACHIEVE_ACOLYTE));
			setPackB(!GameData.hasCosmetic(1,18));
			setBundleB(!GameData.hasCosmetic(1,18) && !GameData.hasAchieved(GameData.ACHIEVE_ACOLYTE));
			
			doneB.update(StringData.DONE,closeWindow);
			var _skillBed:SkillBed=new SkillBed(5);
			_skillBed.x=400;
			_skillBed.y=105;
			addChild(_skillBed);
			var _item:ItemModel=ItemData.spawnItem(0,117);
			item0.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(0,116);
			item1.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(0,112);
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
			GameData.achieve(GameData.ACHIEVE_ACOLYTE);
			setTreeB(false);
			setBundleB(false);
			new ConfirmWindow("Congratulations on your purchase!  Respec your character to gain access to those trees.",50,50,null,0,null,3);
		}
		
		function buyBundle(i:int){
			PurchaseManager.buySpecial(finishBuyBundle,PurchaseManager.PREMIUM_BUNDLE);
		}
		
		function finishBuyBundle(){
			GameData.achieve(GameData.ACHIEVE_ACOLYTE);
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,112));
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,116));
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,117));
			GameData.addCosmetic(1,18);
			GameData.boost+=500;
			setTreeB(false);
			setBundleB(false);
			setPackB(false);
			new ConfirmWindow("Congratulations on your purchase!  Respec your character to gain access to those trees and look in Overflow for your items.",50,50,null,0,null,3);
		}
		
		function buyPack(){
			PurchaseManager.buySpecial(finishBuyPack,PurchaseManager.MINI_BUNDLE2);
		}
		
		function finishBuyPack(){
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,112));
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,116));
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,117));
			GameData.addCosmetic(1,18);
			GameData.boost+=500;
			setPackB(false);
			setBundleB(false);
			new ConfirmWindow("Congratulations on your purchase!  Look in Overflow for your items.",50,50,null,0,null,3);
		}
		
		function setTreeB(b:Boolean){
			if (b){
				buySkill.update("55 Tokens",buySkillTree);
				buySkill.setDesc("Buy Skill Tree ONLY","Purchase the Acolyte Skill Tree for 55 Power Tokens without the bundled goods.");
			}else{
				buySkill.update("Purchased",nullFunction);
				buySkill.setDesc("Skill Tree Owned","You have already unlocked this skill tree.");
				buySkill.disabled=true;
			}
		}
		
		function setBundleB(b:Boolean){
			if (b){
				buyAcolyte.update("Only 100 Tokens!",buyBundle); buyAcolyte.index=5;
				buyAcolyte.setDesc("Purchase Acolyte Bundle","Purchase this bundle for Tokens.");
			}else{
				buyAcolyte.update("Already Purchased!",nullFunction);
				buyAcolyte.setDesc("Purchase Acolyte Bundle","You have already purchased this bundle.");
				buyAcolyte.disabled=true;
			}
		}
		
		function setPackB(b:Boolean){
			if (b){
				packB.update("55 Tokens",buyPack);
				packB.setDesc("Purchase Pack without Class","Purchase the items, cosmetic and boosts without the Acolyte Class.");
			}else{
				if (contains(packB)) removeChild(packB);
			}
		}
	}
	
}
