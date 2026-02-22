package ui.main{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import skills.SkillData;
	import items.*
	import ui.windows.ConfirmWindow;
	import ui.assets.FadeTransition;
	
	public class ShopUI extends BaseUI{
		public static const SHOP_X:Number=37,
							PREMIUM_X:Number=121,
							BLACK_X:Number=203;
		
		public var shopLocked:Boolean=false;
		public var blackLocked:Boolean=false;
		
		public var inventory:StoreInventoryUI;
		
		public function ShopUI(){
			clearB1.update(null,toggle1);
			clearB2.update(null,toggle2);
			
			doneB.update(StringData.LEAVE,navOut,true);
			soundB.update(null,muteSound,true);
			
			inventory=new StoreInventoryUI();
			addChild(inventory);
			
			shopTab.setInventory(inventory);
			blackTab.init(inventory,restock);
			premiumTab.init(inventory,restock);
		}
				
		/*public function noGold(){
			new ConfirmWindow(StringData.CONF_GOLD);
		}*/
		
		override public function openWindow(){
			Facade.currentUI=this;
			soundB.toggled=Facade.soundC.mute;
			
			inventory.update(Facade.gameM.playerM);
			shopTab.update(Facade.gameM.playerM);
			premiumTab.update(Facade.gameM.playerM);
			blackTab.update(Facade.gameM.playerM);
			
			shopTab.restock();
			//premiumTab.restockSingle();
			
			if (Facade.gameM.playerM.level>=3){
				shopLocked=false;
				if (contains(shopLockedO)){
					removeChild(shopLockedO);
				}
			}else{
				shopLocked=true;
				addChild(shopLockedO);
			}
			if (Facade.gameM.playerM.level>=12){
				blackLocked=false;
				if (contains(blackLockedO)){
					removeChild(blackLockedO);
				}
			}else{
				blackLocked=true;
				addChild(blackLockedO);
			}
		}
		
		override public function closeWindow(){
			blackTab.closeMarkets();
			shopTab.closeWindow();
		}
		
		public function restock(){
			//shopTab.restock();
			blackTab.restock();
			premiumTab.restock();
		}
		
		public function setItemsFromArray(_gamble:Array,_premium:Array){
			blackTab.setItemsFromArray(_gamble);
			premiumTab.setItemsFromArray(_premium);
		}
		
		public function getBlackArray():Array{
			return blackTab.getItemArray();
		}
		
		public function getPremiumArray():Array{
			return premiumTab.getItemArray();
		}
		
		public function navOut(){
			new FadeTransition(this,Facade.menuUI);
		}
		
		function toggle1(){
			toggleGeneral(clearB1);
		}
		
		function toggle2(){
			toggleGeneral(clearB2);
		}
		
		function toggleGeneral(v:*){
			if (v.x==SHOP_X && !(shopLocked)){
				toTheTop(0);
			}else if (v.x==PREMIUM_X){
				toTheTop(1);
			}else if (v.x==BLACK_X && (!blackLocked)){
				toTheTop(2);
			}
		}
		
		public function toTheTop(i:int){
			if (i==0){
				addChild(shopTab);
				clearB1.x=PREMIUM_X;
				clearB2.x=BLACK_X;
				shopTab.lockInventory(false);
				premiumTab.lockInventory(true);
				blackTab.lockInventory(true);
			}else if (i==1){
				addChild(premiumTab);
				clearB1.x=SHOP_X;
				clearB2.x=BLACK_X;
				shopTab.lockInventory(true);
				premiumTab.lockInventory(false);
				blackTab.lockInventory(true);
			}else if (i==2){
				addChild(blackTab);
				clearB1.x=PREMIUM_X;
				clearB2.x=SHOP_X;
				shopTab.lockInventory(true);
				premiumTab.lockInventory(true);
				blackTab.lockInventory(false);
			}
			addChild(clearB1);
			addChild(clearB2);
			if (shopLocked){
				addChild(shopLockedO);
			}else if (contains(shopLockedO)){
				removeChild(shopLockedO);
			}
			if (blackLocked){
				addChild(blackLockedO);
			}else if (contains(blackLockedO)){
				removeChild(blackLockedO);
			}
		}
		
		public function muteSound(){
			Facade.soundC.mute=!Facade.soundC.mute;
			soundB.toggled=Facade.soundC.mute;
		}
	}
}