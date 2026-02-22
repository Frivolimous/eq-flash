package ui.main{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import skills.SkillData;
	import items.*
	import ui.windows.ConfirmWindow;
	import ui.assets.FadeTransition;
	import utils.GameData;
	
	public class MiniShopUI extends Sprite{
		
		public function MiniShopUI(){
			autoB.update(null,toggleAuto,true);
			autoB.toggled=GameData._Save.data.pause[GameData.AUTO_FILL];
			fillAllUI.init(Facade.gameUI.inventoryUI);
			fillAllUI.update(Facade.gameM.playerM);
			
			Facade.gameUI.inventoryUI.alsoUpdate=fillAllUI.update;
			if (GameData._Save.data.pause[GameData.AUTO_FILL]) fillAllUI.confirmBuy(true);
		}
		
		public function close(){
			Facade.gameUI.inventoryUI.alsoUpdate=null;
		}
		
		public function toggleAuto(){
			GameData._Save.data.pause[GameData.AUTO_FILL]=!GameData._Save.data.pause[GameData.AUTO_FILL]
			autoB.toggled=GameData._Save.data.pause[GameData.AUTO_FILL];
			if (GameData._Save.data.pause[GameData.AUTO_FILL]) fillAllUI.confirmBuy(true);
		}
	}
}