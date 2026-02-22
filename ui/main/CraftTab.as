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
	
	public class CraftTab extends Sprite{
		public var inventory:StoreInventoryUI;
		
		public function CraftTab(){
			inventory2UI.useSouls=true;
			inventory2UI.restock(true);
		}
		
		public function lockInventory(b:Boolean){
			inventoryUI.locked=b;
			inventory2UI.locked=b;
			powerT.updateDisplay();
			soulT.updateDisplay();
		}
		
		public function update(_player:*,_inventory:BaseInventoryUI){
			inventoryUI.update(_player);
			inventoryUI.dropTo=_inventory;
			inventoryUI.alsoUpdate=powerT.updateDisplay;
			powerT.updateDisplay();
			
			inventory2UI.update(_player);
			inventory2UI.dropTo=_inventory;
			inventory2UI.alsoUpdate=soulT.updateDisplay;
			soulT.updateDisplay();
		}
	}
}