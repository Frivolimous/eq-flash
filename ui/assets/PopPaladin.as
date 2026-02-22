package ui.assets {
	import flash.display.Sprite;
	import items.ItemData;
	import skills.SkillBed;
	import items.ItemView;
	import items.ItemModel;
	import utils.GameData;
	import utils.KongregateAPI;
	import ui.windows.ConfirmWindow;
	
	public class PopPaladin extends Sprite{
		var onClose:Function;
		public function PopPaladin(_onClose:Function=null) {
			onClose=_onClose;
			
			setTreeB(!GameData.hasAchieved(GameData.ACHIEVE_PALADIN));
			setBundleB(!GameData.hasCosmetic(4,8) && !GameData.hasAchieved(GameData.ACHIEVE_PALADIN));
			setPackB(!GameData.hasCosmetic(4,8));
			
			doneB.update(StringData.DONE,closeWindow);
			var _skillBed:SkillBed=new SkillBed(6);
			_skillBed.x=400;
			_skillBed.y=105;
			addChild(_skillBed);
			var _item:ItemModel=ItemData.spawnItem(0,115);
			item0.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(0,114);
			item1.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(0,113);
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
			KongregateAPI.buySpecial(finishBuyTree,KongregateAPI.PREMIUM_CLASS);
		}
		
		function finishBuyTree(){
			GameData.achieve(GameData.ACHIEVE_PALADIN);
			setTreeB(false);
			setBundleB(false);
			new ConfirmWindow("Congratulations on your purchase!  Respec your character to gain access to those trees.",50,50,null,0,null,3);
		}
		
		function buyBundle(i){
			KongregateAPI.buySpecial(finishBuyBundle,KongregateAPI.PREMIUM_BUNDLE);
		}
		
		function finishBuyBundle(){
			GameData.achieve(GameData.ACHIEVE_PALADIN);
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,113));
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,114));
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,115));
			GameData.addCosmetic(4,8);
			GameData.boost+=500;
			setTreeB(false);
			setBundleB(false);
			setPackB(false);
			new ConfirmWindow("Congratulations on your purchase!  Respec your character to gain access to those trees and look in Overflow for your items.",50,50,null,0,null,3);
		}
		
		function buyPack(){
			KongregateAPI.buySpecial(finishBuyPack,KongregateAPI.MINI_BUNDLE2);
		}
		
		function finishBuyPack(){
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,113));
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,114));
			Facade.gameM.addOverflowItem(ItemData.spawnItem(1,115));
			GameData.addCosmetic(4,8);
			GameData.boost+=500;
			setPackB(false);
			setBundleB(false);
			new ConfirmWindow("Congratulations on your purchase!  Look in Overflow for your items.",50,50,null,0,null,3);
		}
		
		function setTreeB(b:Boolean){
			if (b){
				buySkill.update("55 Tokens",buySkillTree);
				buySkill.setDesc("Buy Skill Tree ONLY","Purchase the Paladin Skill Tree for 55 Power Tokens without the bundled goods.");
			}else{
				buySkill.update("Purchased",nullFunction);
				buySkill.setDesc("Skill Tree Owned","You have already unlocked this skill tree.");
				buySkill.disabled=true;
			}
		}
		
		function setBundleB(b:Boolean){
			if (b){
				buyAcolyte.update("Only 100 Tokens!",buyBundle); buyAcolyte.index=5;
				buyAcolyte.setDesc("Purchase Paladin Bundle","Purchase this bundle for Tokens.");
			}else{
				buyAcolyte.update("Already Purchased!",nullFunction);
				buyAcolyte.setDesc("Purchase Paladin Bundle","You have already purchased this bundle.");
				buyAcolyte.disabled=true;
			}
		}
		
		function setPackB(b:Boolean){
			if (b){
				packB.update("55 Tokens",buyPack);
				packB.setDesc("Purchase Pack without Class","Purchase the items, cosmetic and boosts without the Paladin Class.");
			}else{
				if (contains(packB)) removeChild(packB);
			}
		}
	}
	
}
