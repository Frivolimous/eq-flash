package ui.assets {
	import flash.display.Sprite;
	import utils.KongregateAPI;
	import utils.GameData;
	import items.ItemData;
	import ui.windows.ConfirmWindow;
	
	public class PopCraft extends Sprite{

		public function PopCraft() {
			doneB.update(StringData.DONE,closeWindow);
			update();
		}
		
		public function update(){
			if (!GameData.hasAchieved(GameData.ACHIEVE_FORGE)){
				buyMini.update("Only 50 Tokens!",buyMiniBundle);
				buyMini.setDesc("Purchase Mini-Pack","Purchase this pack for 50 Power Tokens!  Can only be purchased once.");
			}else{
				buyMini.update("Already Purchased!",nullFunction);
				buyMini.disabled=true;
				buyMini.setDesc("Purchase Mini-Pack","You have already purchased this pack, or achieved this naturally.");
			}
			if (!GameData.getFlag(GameData.FLAG_CRAFT_MEGA) && !GameData.hasAchieved(GameData.ACHIEVE_EPIC)){
				if (!GameData.hasAchieved(GameData.ACHIEVE_FORGE)){
					buyMega.update("Only 150 Tokens!",buyMegaBundle);
					buyMega.setDesc("Purchase Mega-Pack","Purchase this pack for 150 Power Tokens!  Can only be purchased once. (Discounted from 200 because Forge is already unlocked)");
				}else{
					buyMega.update("Only 200 Tokens!",buyMegaBundle);
					buyMega.setDesc("Purchase Mega-Pack","Purchase this pack for 200 Power Tokens!  Can only be purchased once.");
				}
			}else{
				buyMega.update("Already Purchased!",nullFunction);
				buyMega.disabled=true;
				buyMega.setDesc("Purchase Mega-Pack","You have already purchased this pack, or achieved this naturally.");
			}
		}
		
		function closeWindow(){
			parent.removeChild(this);
		}
		
		function buyMegaBundle(){
			if (!GameData.hasAchieved(GameData.ACHIEVE_FORGE)){
				KongregateAPI.buyItem(finishBuyMega,200);
			}else{
				KongregateAPI.buyItem(finishBuyMega,150);
			}
		}
		
		function buyMiniBundle(){
			KongregateAPI.buyItem(finishBuyMini,50);
		}
		
		function finishBuyMega(){
			GameData.setFlag(GameData.FLAG_CRAFT_MEGA,true);
			GameData.achieve(GameData.ACHIEVE_FORGE);
			GameData.gold+=10000000;
			Facade.gameM.addOverflowItem(ItemData.spawnItem(15,135,1));
			Facade.gameM.addOverflowItem(ItemData.enchantItem(ItemData.spawnItem(15,135,1),1));
			update();
			new ConfirmWindow("Congratulations on your purchase!  Look in Overflow tab of your Stash for your items.",50,50,null,0,null,3);
		}
		
		function finishBuyMini(){
			GameData.achieve(GameData.ACHIEVE_FORGE);
			GameData.gold+=5000000;
			update();
			new ConfirmWindow("Congratulations on your purchase!  Go to town to find the Mystic Forge.",50,50,null,0,null,3);
		}
		
		function nullFunction(i:int=0){
			
		}
	}
	
}
