package ui.main{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import skills.SkillData;
	import items.*
	import system.effects.EffectData;
	import ui.windows.ConfirmWindow;
	import ui.assets.FadeTransition;
	import utils.KongregateAPI;
	import utils.GameData;
	import ui.assets.PopBundles;
	import ui.assets.PopBundles2;
	import ui.assets.PopCraft;
	import ui.assets.PopHairBundles;
	import ui.assets.PopRelicBundles;
	
	public class PremiumTab extends Sprite{
		public var inventory:StoreInventoryUI;
		var restockAll:Function;
		
		public function PremiumTab(){
			bundleB.update("Paladin/Acolyte",popBundle);
			bundle2B.update("Rogue/Ranger",popBundle2);
			hairPackB.update("Hair Packs",popPacks);
			relicPackB.update("Relic Packs",popRelic);
			craftPackB.update("Crafting Packs",popCraft);
			refreshB.update(StringData.REFRESH,tryRestock);
		}
		
		public function popBundle(){
			Facade.stage.addChild(new PopBundles);
		}
		
		public function popBundle2(){
			Facade.stage.addChild(new PopBundles2);
		}
		
		public function popPacks(){
			new PopHairBundles;
		}
		
		public function popRelic(){
			new PopRelicBundles;
		}
		
		public function popCraft(){
			Facade.stage.addChild(new PopCraft);
		}
		
		public function init(_inventory:StoreInventoryUI,_restock:Function){
			inventory=_inventory;
			gambleUI.alsoUpdate=powerT.updateDisplay;
			inventory.alsoUpdate=powerT.updateDisplay;
			powerT.updateDisplay();
			restockAll=_restock;
		}
		
		public function lockInventory(b:Boolean){
			gambleUI.locked=b;
			//singleUI.locked=b;
		}
		
		public function update(_player:*){
			gambleUI.update(_player);
			//singleUI.update(_player);
			remainText.text=String(GameData.refreshes);
			powerT.updateDisplay();
		}
		
		var alreadyPaid:Boolean=false;
		function tryRestock(){
			if (GameData.refreshes>=1){
				GameData.refreshes-=1;
				restockAll();
			}else if (Facade.gameM.kreds>0){
				if (alreadyPaid){
					restockPT();
				}else{
					new ConfirmWindow("Use 1 Power Token to refresh the store slots?",50,50,restockPT);
				}
			}else{
				new ConfirmWindow("Not enough Refreshes or Power Tokens to refresh.")
			}
		}
		
		function restockPT(i:int=0){
			Facade.gameM.kreds-=1;
			alreadyPaid=true;
			restockAll();
			GameData.saveThis(GameData.SCORES);
		}
		
		public function restock(){
			remainText.text=String(GameData.refreshes);
			powerT.updateDisplay();
			gambleUI.clear();
			for (var i:int=0;i<3;i+=1){
				do{
					gambleUI.addItemAt(new ItemView(ItemData.spawnPremium(0,true)),i);
				}while(((i>0) && (gambleUI.itemA[i].stored.model.index==gambleUI.itemA[i-1].stored.model.index))||((i>1) && (gambleUI.itemA[i].stored.model.index==gambleUI.itemA[i-2].stored.model.index)))				
				if (gambleUI.itemA[i].stored.model.hasTag(EffectData.SUPER_PREMIUM)){
					gambleUI.itemA[i].stored.model.cost=-20;
				}else{
					gambleUI.itemA[i].stored.model.cost=-15;
				}
			}
		}
		
		public function restockSingle(){
			//singleUI.clear();
			//singleUI.addItemAt(new ItemView(ItemData.spawnItem(0,100)),0);
		}
		
		public function getItemArray():Array{
			var m:Array=new Array(4);
			for (var i:int=0;i<3;i+=1){
				if (gambleUI.itemA[i].stored!=null){
					m[i]=gambleUI.itemA[i].stored.model.index;
				}else{
					m[i]=-1;
				}
			}
			return m;
		}
		
		public function setItemsFromArray(_a:Array){
			gambleUI.clear();
			for (var i:int=0;i<3;i+=1){
				if (_a[i]!=null && _a[i]!=-1){
					gambleUI.addItemAt(new ItemView(ItemData.spawnItem(0,_a[i])),i);
					if (gambleUI.itemA[i].stored.model.hasTag(EffectData.SUPER_PREMIUM)){
						gambleUI.itemA[i].stored.model.cost=-20;
					}else{
						gambleUI.itemA[i].stored.model.cost=-15;
					}
				}
			}
		}
	}
}