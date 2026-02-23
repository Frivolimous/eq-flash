package ui{
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
	import ui.main.TournamentUI;
	import ui.main.TournamentDuelUI;
	import hardcore.HardcoreDuelUI;
	import hardcore.HardcoreHomeUI;
	
	public class StatusUI extends BaseUI{
		public static const STATS_X:Number=50,
							ACTION_X:Number=132,
							STASH_X:Number=216,
							
							INV_X:Number=343,
							SKILL_X:Number=425,
							ARTS_X:Number=510;
							
		public var stashLocked:Boolean=false;
		public var cosmeticsLocked:Boolean=false;
		public var stashFree:Boolean=false;
		
		public var transTo:BaseUI;
		public var custom:Boolean=true;
		public var toSave:Boolean=true;
		
		public function StatusUI(_transTo:BaseUI,_model:SpriteModel=null,_custom:Boolean=true){
			custom=_custom;
			clearB1.update(null,toggle1);
			clearB2.update(null,toggle2);
			clearB3.update(null,toggle3);
			clearB4.update(null,toggle4);
			
			doneB.update(StringData.DONE,navOut,true);
			soundB.update(null,muteSound,true);
			
			toTheTop(0);
			toTheTop(3);
			transTo=_transTo;
			if (transTo is DuelUI){
				inventoryUI.noSell=true;
			}
			if (transTo is hardcore.HardcoreHomeUI){
				stashLocked=true;
				addChild(stashLockedO);
				cosmeticsLocked=false;
				if (contains(cosmeticsLockedO)) removeChild(cosmeticsLockedO);
				stashW.noSave=true;
				inventoryUI.nullSell=true;
				toTheTop(0);
			}else if (transTo is DuelUI || Facade.gameM.playerM.level<2){
				stashLocked=true;
				cosmeticsLocked=true;
				skillUI.noCost=true;
				addChild(stashLockedO);
				addChild(cosmeticsLockedO);
			/*}else if (transTo is ui.main.TournamentUI || transTo is ui.main.TournamentDuelUI || transTo is hardcore.HardcoreDuelUI){
				if (transTo is ui.main.TournamentUI){
					stashLocked=false;
				}else{
					stashLocked=true;
					addChild(stashLockedO);
					addChild(cosmeticsLockedO);
					if (!_custom){
						inventoryUI.removeFirst5();
					}
				}
				stashW.noSave=true;
				//inventoryUI.rows15.alpha=0.5;
				//inventoryUI.removeLast15();
				//inventoryUI.NUM_SLOTS=5;
				inventoryUI.nullSell=true;
				toTheTop(0);*/
			}else{
				stashLocked=false;
				cosmeticsLocked=false;
				if (contains(stashLockedO)){
					removeChild(stashLockedO);
				}
				if (contains(cosmeticsLockedO)) removeChild(cosmeticsLockedO);
			}
			
			if (_model!=null){
				origin=_model;
			}
			
			if (!custom){
				stashLocked=true;
				cosmeticsLocked=true;
				inventoryUI.locked=true;
				skillUI.locked=true;
			}
			inventoryUI.alsoUpdate=stashW.powerT.updateDisplay;
		}
		
		override public function openWindow(){
			soundB.toggled=Facade.soundC.mute;
			statusW.update(origin);
			actionW.update(origin);
			stashW.update(origin,inventoryUI);
			skillUI.update(origin);
			inventoryUI.update(origin);
			cosmeticsUI.update(origin);
			
			if (custom){
				if (origin==Facade.gameM.enemyM){
					origin.updateUI=true;
				}
			}
		}
		
		override public function updateStats(_o:SpriteModel=null){
			if (_o!=null){
				origin=_o;
			}
			
			if (origin==null) return;
			
			statusW.update(origin);
			actionW.update(origin);
		}
		
		public function navOut(){
			new FadeTransition(this,transTo);
		}
		
		override public function closeWindow(){
			if (custom){
				if (origin==Facade.gameM.enemyM){
					origin.updateUI=false;
				}
			}
			inventoryUI.update(null);
			stashW.update();
			actionW.clearAction();
			if (transTo is HomeUI){
				Facade.saveC.saveChar();
			}
		}
				
		function toggle1(){
			toggleGeneral(clearB1);
		}
		
		function toggle2(){
			toggleGeneral(clearB2);
		}
		
		function toggle3(){
			toggleGeneral2(clearB3);
		}
		
		function toggle4(){
			toggleGeneral2(clearB4);
		}
		
		function toggleGeneral(v:*){
			if (v.x==STATS_X){
				toTheTop(0);
			}else if (v.x==ACTION_X){
				toTheTop(1);
			}else if (v.x==STASH_X && (!stashLocked)){
				toTheTop(2);
			}
		}
		
		function toggleGeneral2(v:*){
			if (v.x==INV_X){
				toTheTop(3);
			}else if (v.x==SKILL_X){
				toTheTop(4);
			}else if (v.x==ARTS_X && (!cosmeticsLocked)){
				toTheTop(5);
			}
		}
		
		public function toTheTop(i:int){
			if (i==0){
				addChild(statusW);
				stashW.lockInventory(true);
				clearB1.x=ACTION_X;
				clearB2.x=STASH_X;
			}else if (i==1){
				addChild(actionW);
				stashW.lockInventory(true);
				clearB1.x=STATS_X;
				clearB2.x=STASH_X;
			}else if (i==2){
				addChild(stashW);
				stashW.lockInventory(false);
				clearB1.x=STATS_X;
				clearB2.x=ACTION_X;
			}else if (i==3){
				addChild(inventoryUI);
				if (custom) inventoryUI.lockInventory(false);
				clearB3.x=SKILL_X;
				clearB4.x=ARTS_X;
			}else if (i==4){
				addChild(skillUI);
				inventoryUI.lockInventory(true);
				clearB3.x=INV_X;
				clearB4.x=ARTS_X;
			}else if (i==5){
				addChild(cosmeticsUI);
				cosmeticsUI.update(Facade.gameM.playerM);
				inventoryUI.lockInventory(true);
				clearB3.x=SKILL_X;
				clearB4.x=INV_X;
			}
			addChild(clearB1);
			addChild(clearB2);
			addChild(clearB3);
			addChild(clearB4);
			if (stashLocked){
				addChild(stashLockedO);
			}else{
				if (contains(stashLockedO)){
					removeChild(stashLockedO);
				}
			}
			
			if (cosmeticsLocked){
				addChild(cosmeticsLockedO);
			}else {
				if (contains(cosmeticsLockedO)) removeChild(cosmeticsLockedO);
			}
		}
		
		public function muteSound(){
			Facade.soundC.mute=!Facade.soundC.mute;
			soundB.toggled=Facade.soundC.mute;
		}
		
		/*override public function update(_o:SpriteModel){
			if (_o!=null){
				origin=_o;
				statusW.update(origin);
				actionW.update(origin);
			}
		}*/
	}
}