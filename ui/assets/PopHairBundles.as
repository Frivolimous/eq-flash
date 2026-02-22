package ui.assets {
	import flash.display.Sprite;
	import utils.KongregateAPI;
	import utils.GameData;
	import items.ItemData;
	import ui.windows.ConfirmWindow;
	import items.ItemModel;
	
	public class PopHairBundles extends Sprite{
		
		public function PopHairBundles() {
			doneB.update(StringData.DONE,closeWindow);
			update();
			
			item0.update(null,nullFunction);
			item1.update(null,nullFunction);
			item2.update(null,nullFunction);
			item3.update(null,nullFunction);
			
			var _item:ItemModel=ItemData.spawnItem(0,124);
			item0.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(0,122);
			item1.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(0,123);
			item2.setDesc(_item.name,StringData.getItemDesc(_item));
			_item=ItemData.spawnItem(0,121);
			item3.setDesc(_item.name,StringData.getItemDesc(_item));
			
			if (Facade.currentUI!=null) Facade.currentUI.addChild(this);
			
			if (GameData.getFlag(GameData.FLAG_FREE_PACK)){
				new ConfirmWindow("Congratulations, You can select any single pack FOR FREE!",100,100);
			}
		}
		
		function update(){
			if (GameData.hasCosmetic(1,22)){
				button0.update("Purchased",nullFunction);
				button0.setDesc("Purchased","You have already purchased this bundle or cosmetics found in this bundle.");
				button0.disabled=true;
			}else{
				button0.update("50 Tokens!",buyBundle);
				button0.index=0;
				button0.setDesc("Purchase Pack!","Purchase this bundle for Power Tokens.");
			}
			if (GameData.hasCosmetic(2,27)){
				button1.update("Purchased",nullFunction);
				button1.setDesc("Purchased","You have already purchased this bundle or cosmetics found in this bundle.");
				button1.disabled=true;
			}else{
				button1.update("50 Tokens!",buyBundle);
				button1.index=1;
				button1.setDesc("Purchase Pack!","Purchase this bundle for Power Tokens");
			}
			if (GameData.hasCosmetic(1,21)){
				button2.update("Purchased",nullFunction);
				button2.setDesc("Purchased","You have already purchased this bundle or cosmetics found in this bundle.");
				button2.disabled=true;
			}else{
				button2.update("50 Tokens!",buyBundle);
				button2.index=2;
				button2.setDesc("Purchase Pack!","Purchase this bundle for Power Tokens");
			}
			if (GameData.hasCosmetic(1,20)){
				button3.update("Purchased",nullFunction);
				button3.setDesc("Purchased","You have already purchased this bundle or cosmetics found in this bundle.");
				button3.disabled=true;
			}else{
				button3.update("50 Tokens!",buyBundle);
				button3.index=3;
				button3.setDesc("Purchase Pack!","Purchase this bundle for Power Tokens");
			}
		}
		
		function closeWindow(){
			parent.removeChild(this);
		}
		
		var buying:int;
		function buyBundle(i:int){
			buying=i;
			if (GameData.getFlag(GameData.FLAG_FREE_PACK)){
				new ConfirmWindow("Use your FREE PACK to unlock this pack?",100,100,unlockFree,i);
			}else{
				KongregateAPI.buySpecial(finishBuyBundle,KongregateAPI.MINI_BUNDLE);
			}
		}
		
		function unlockFree(i:int){
			GameData.setFlag(GameData.FLAG_FREE_PACK,false);
			finishBuyBundle();
			GameData.saveThis(GameData.SCORES);
		}
		
		function finishBuyBundle(){
			new ConfirmWindow("Congratulations on your purchase!  Your item is in your overflow and your cosmetics are in the Cosmetics Tab.",50,50,null,0,null,3);
			
			if (buying==0){
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,124));
				GameData.addCosmetic(1,22);
				GameData.addCosmetic(2,29);
				GameData.addCosmetic(3,6);
				GameData.boost+=250;
				button0.update("Purchased",nullFunction);
				button0.setDesc("Purchased","You have already purchased this bundle or cosmetics found in this bundle.");
				button0.disabled=true;
			}else if (buying==1){
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,122));
				GameData.addCosmetic(2,27);
				GameData.addCosmetic(3,4);
				GameData.addCosmetic(4,10);
				GameData.boost+=250;
				button1.update("Purchased",nullFunction);
				button1.setDesc("Purchased","You have already purchased this bundle or cosmetics found in this bundle.");
				button1.disabled=true;
			}else if (buying==2){
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,123));
				GameData.addCosmetic(1,21);
				GameData.addCosmetic(2,28);
				GameData.addCosmetic(3,5);
				GameData.boost+=250;
				button2.update("Purchased",nullFunction);
				button2.setDesc("Purchased","You have already purchased this bundle or cosmetics found in this bundle.");
				button2.disabled=true;
			}else if (buying==3){
				Facade.gameM.addOverflowItem(ItemData.spawnItem(1,121));
				GameData.addCosmetic(1,20);
				GameData.addCosmetic(2,26);
				GameData.addCosmetic(3,3);
				GameData.addCosmetic(4,9);
				GameData.boost+=250;
				button3.update("Purchased",nullFunction);
				button3.setDesc("Purchased","You have already purchased this bundle or cosmetics found in this bundle.");
				button3.disabled=true;
			}
		}
		
		function nullFunction(i:int=0){
			
		}
	}
	
}
