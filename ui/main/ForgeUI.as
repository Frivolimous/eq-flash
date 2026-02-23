package ui.main{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ui.main.BaseUI;
	import items.InventoryUI;
	import items.StatisticsInventoryUI;
	import skills.SkillUI;
	import ui.windows.ActionWindow;
	import ui.assets.FadeTransition;
	import ui.windows.StatusWindow2;
	import ui.assets.GraphicButton;
	import ui.main.StatsTab;
	import ui.main.DuelUI;
	import ui.main.HomeUI;
	import utils.GameData;
	
	public class ForgeUI extends BaseUI{
		public static const INV_X:Number=343,
							SKILL_X:Number=425,
							STASH_X:Number=510;
							
		//public var transTo:BaseUI;
		public var custom:Boolean=true;
		public var toSave:Boolean=true;
		var craftLocked:Boolean=false;
		
		public function ForgeUI(_model:SpriteModel=null){
			//custom=_custom;
			clearB1.update(null,toggle1);
			clearB2.update(null,toggle2);
			
			doneB.update(StringData.DONE,navOut,true);
			soundB.update(null,muteSound,true);
			
			toTheTop(0);
			
			if (_model==null){
				origin=Facade.gameM.playerM;
			}else{
				origin=_model;
			}
			
			ingredientsUI.init(inventoryUI);
			upgradeUI.init(SingleInventoryUI.UPGRADE,inventoryUI);
			inventoryUI.alsoUpdate=stashW.powerT.updateDisplay;
			if (GameData.hasAchieved(GameData.ACHIEVE_EPIC)){
				craftLocked=false;
				if (contains(craftLockedO)) removeChild(craftLockedO);
			}else{
				craftLocked=true;
				addChild(craftLockedO);
				craftLockedO.setDesc("Essence Shop","Locked until Zone 400.  Unlock to purchase Essences and craft Epic Items.");
			}
			craftTooltip.setDesc("Basic Crafting","Combine two items to create a new item.\n- Not all items can combine.\n- Every Premium has at least 1 recipe\n- Try any regular Enchanted Item with a regular Unenchanted Item as an example!");
			upgradeTooltip.setDesc("Upgrade Item","Upgrade any regular item up to Level 15 or Epic Item up to Level 20.");
		}
		
		override public function openWindow(){
			soundB.toggled=Facade.soundC.mute;
			stashW.update(origin,inventoryUI);
			craftUI.update(origin,ingredientsUI);
			inventoryUI.update(origin);
			toTheTop(0);
		}
		
		public function navOut(){
			upgradeUI.removeValues();
			ingredientsUI.removeValues();
			new FadeTransition(this,Facade.menuUI);
		}
		
		override public function closeWindow(){
			inventoryUI.update(null);
			stashW.update();
		}
				
		function toggle1(){
			toggleGeneral(clearB1);
		}
		
		function toggle2(){
			toggleGeneral(clearB2);
		}
		
		function toggleGeneral(v:*){
			if (v.x==INV_X){
				toTheTop(0);
			}else if (v.x==SKILL_X && !craftLocked){
				toTheTop(1);
			}else if (v.x==STASH_X){
				toTheTop(2);
			}
		}
		
		public function toTheTop(i:int){
			if (i==0){
				addChild(inventoryUI);
				stashW.lockInventory(true);
				craftUI.lockInventory(true);
				inventoryUI.lockInventory(false);
				clearB1.x=SKILL_X;
				clearB2.x=STASH_X;
			}else if (i==1){
				addChild(craftUI);
				stashW.lockInventory(true);
				craftUI.lockInventory(false);
				inventoryUI.lockInventory(true);
				clearB1.x=INV_X;
				clearB2.x=STASH_X;
			}else if (i==2){
				addChild(stashW);
				stashW.lockInventory(false);
				craftUI.lockInventory(true);
				inventoryUI.lockInventory(true);
				clearB1.x=SKILL_X;
				clearB2.x=INV_X;
			}
			addChild(clearB1);
			addChild(clearB2);
			if (craftLocked){
				addChild(craftLockedO);
			}else {
				if (contains(craftLockedO)) removeChild(craftLockedO);
			}
		}
		
		public function muteSound(){
			Facade.soundC.mute=!Facade.soundC.mute;
			soundB.toggled=Facade.soundC.mute;
		}		
	}
}