package ui.main{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import ui.assets.*;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import ui.windows.ConfirmWindow;
	import utils.GameData;
	import utils.AchieveData;
	import flash.display.Sprite;
	import hardcore.*;
	import ui.StatusUI;
	import items.ItemData;
	
	public class MenuUI extends BaseUI{
		public var shopUI:ShopUI;
		public var duelUI:DuelUI;
		var treasureIndex:int;
		var blinkT:Timer=new Timer(1000);
		
		var SPECIAL_EVENT:Boolean=false;
		
		public function init(){
			soundB.update(null,muteSound,true);
			
			shopUI=new ShopUI;
			duelUI=new DuelUI;
			
			scaleX=scaleY=Facade.SCALE;
			setupButton(startB,beginGame);
			setupButton(homeB,popHome);
			setupButton(shopB,popShop);
			setupButton(premiumB,popPremium);
			setupButton(blackB,popBlack);
			setupButton(libraryB,popLibrary);
			setupButton(duelB,popDuel);
			setupButton(hallB,popHall);
			setupButton(arcadeB,popArcade);
			setupButton(announceB,popAnnouncement);
			setupButton(forgeB,popForge);
			setupButton(epicB,goEpic);
			setupButton(stashB,popStash);
			
			if (Facade.DEBUG || (SPECIAL_EVENT && GameData.getFlag(GameData.FLAG_TUTORIAL))){
				setupButton(tentB,popEvent);
			}else{
				removeChild(tentB);
			}
			
			tombstone.addEventListener(MouseEvent.CLICK,popTombstone,false,0,true);
			treasureIndex=getChildIndex(treasure);
			blinkT.addEventListener(TimerEvent.TIMER,startBlink);
		}
		
		function setupButton(v:MovieClip,f:Function){
			v.mouseChildren=false;
			v.buttonMode=true;
			v.addEventListener(MouseEvent.CLICK,f);
			v.addEventListener(MouseEvent.MOUSE_OVER,goOver);
			v.addEventListener(MouseEvent.MOUSE_OUT,goOut);
			v.greyMode=false;
		}
		
		function goOver(e:MouseEvent){
			if (e.target.greyMode){
				e.target.gotoAndStop(4);
			}else{
				e.target.gotoAndStop(2);
			}
		}
		
		function goOut(e:MouseEvent){
			if (e.target.greyMode){
				e.target.gotoAndStop(3);
			}else{
				e.target.gotoAndStop(1);
			}
		}
		
		public function newChar(b:Boolean=true){
			if (b){
				blinkT.start();
			}else{
				blinkT.stop();
			}
		}
		
		public function startBlink(e:TimerEvent){
			if (startB.currentFrame==1){
				startB.gotoAndStop(2);
			}else{
				startB.gotoAndStop(1);
			}
		}
		
		public function beginGame(e:MouseEvent){
			Facade.gameM.duel=false;
			Facade.soundC.fadeOut();
			
			if (blinkT.running){
				newChar(false);
			}
			Facade.gameC=new GameControl();//Facade.worldC;
			Facade.gameUI.transTo=this;
			new FadeTransition(this,Facade.gameUI);
			/*if (blinkT.running){
				newChar(false);
				new ConfirmWindow(StringData.CONF_TUTORIAL,70,30,beginTutorial,0,beginGame);
			}else{
				new FadeTransition(this,Facade.gameUI);
			}*/
		}
		
		public function popHome(e:MouseEvent){
			new FadeTransition(this,new HomeUI);
		}
		
		public function popShop(e:MouseEvent){
			if (shopB.greyMode) return;
			shopUI.toTheTop(0);
			new FadeTransition(this,shopUI);
		}
		
		public function popPremium(e:MouseEvent){
			if (premiumB.greyMode) return;
			shopUI.toTheTop(1);
			new FadeTransition(this,shopUI);
		}
		
		public function popBlack(e:MouseEvent){
			if (blackB.greyMode) return;
			shopUI.toTheTop(2);
			new FadeTransition(this,shopUI);
		}
		
		public function popLibrary(e:MouseEvent){
			if (libraryB.greyMode) return;
			new FadeTransition(this,new LibraryUI);
		}
		
		public function popTemple(e:MouseEvent){
			//if (templeB.greyMode) return;
			//new FadeTransition(this,templeUI);
		}
		
		public function popPrestige(){
			new FadeTransition(Facade.currentUI,new ArtifactUI);
		}
		
		public function popEvent(e:MouseEvent){
			//new FadeTransition(this,new TournamentUI);
			//new FadeTransition(this,new HardcoreDuelUI);
			new FadeTransition(this,new HardcoreHomeUI);
		}
		
		public function popDuel(e:MouseEvent){
			if (duelB.greyMode) return;
			//Facade.gameC=new DuelControl();//Facade.duelC;
			new FadeTransition(this,duelUI);
			//addChild(new DuelSelect);
		}
		
		public function popHall(e:MouseEvent){
			if (hallB.greyMode) return;
			new FadeTransition(this,new HallUI);
		}
		
		public function popArcade(e:MouseEvent){
			new FadeTransition(this,new TempleUI);
			
			//new ConfirmWindow("This will link to our sponsor's site.");
		}
		
		public function popForge(e:MouseEvent){
			if (forgeB.greyMode) return;
			new FadeTransition(this,new ForgeUI);
		}
		
		public function popStash(e:MouseEvent){
			var _statusUI:StatusUI=new StatusUI(this,Facade.gameM.playerM);
			_statusUI.toTheTop(2);
			new FadeTransition(this,_statusUI);
		}
		
		public function goEpic(e:MouseEvent){			
			Facade.gameC=new EpicGameControl();
			Facade.gameUI.transTo=this;
			new FadeTransition(this,Facade.gameUI);
		}
		
		var newMessage:Sprite=new Exclamation;
		public function popAnnouncement(e:MouseEvent){
			GameData.setFlag(GameData.FLAG_MESSAGE,false);
			if (announceB.contains(newMessage)) announceB.removeChild(newMessage);
			new ScrollAnnounce(GameData.getAnnounceText());
		}
		
		public function collectTreasure(){
			removeChild(treasure);
			GameData.setFlag(GameData.FLAG_TREASURE,true);
			GameData.gold+=500;
		}
		
		override public function openWindow(){
			//Facade.actionC.itemCover.remove();
			soundB.toggled=Facade.soundC.mute;
			Facade.gameC=null;
			Facade.gameM.playerM.maxHM();
			//shopUI.restock();
			//blackUI.restock();
			Facade.soundC.startMusic(1);
			if (GameData.getFlag(GameData.FLAG_TREASURE)){
				if (contains(treasure)) removeChild(treasure);
			}else{
				addChildAt(treasure,treasureIndex);
			}
			if (GameData.getFlag(GameData.FLAG_MESSAGE)){
				newMessage.y=-45;
				newMessage.scaleX=newMessage.scaleY=0.7;
				announceB.addChild(newMessage);
			}else{
				if (announceB.contains(newMessage)) announceB.removeChild(newMessage);
			}
			
			// if (!GameData.getFlag(GameData.FLAG_GIFT) && Facade.gameM.area>10){
			// 	new TutorialWindow(TutorialWindow.GIFT);
			// }
			// if (Facade.gameM.area>=80 && !GameData.getFlag(GameData.FLAG_GIFT2)){
			// 	new TutorialWindow(TutorialWindow.GIFT3);
			// 	GameData.setFlag(GameData.FLAG_GIFT2,true);
			// }
			
			makeGrey(shopB,(GameData.getScore(GameData.SCORE_LEVEL)<3));
			makeGrey(premiumB,(GameData.getScore(GameData.SCORE_LEVEL)<3));
			makeGrey(hallB,(GameData.getScore(GameData.SCORE_LEVEL)<5));
			makeGrey(duelB,(GameData.getScore(GameData.SCORE_LEVEL)<8));
			makeGrey(libraryB,(GameData.getScore(GameData.SCORE_LEVEL)<10));
			makeGrey(blackB,(GameData.getScore(GameData.SCORE_LEVEL)<12));
			makeGrey(forgeB,!AchieveData.hasAchieved(AchieveData.ZONE_300));
			
			if (AchieveData.hasAchieved(AchieveData.ZONE_400)){
				addChild(epicB);
			}else{
				if (contains(epicB)){
					removeChild(epicB);
				}
			}
			
			if (GameData.getScore(GameData.SCORE_LEVEL)>2){
				addChild(stashB);
			}else{
				if (contains(stashB)){
					removeChild(stashB);
				}
			}
			
			tryReward();
			
			Facade.saveC.reloadChar(Facade.gameM.playerM);
		}
		
		public function tryReward(){
			var _save:Boolean=false;
			while (GameData.getFirstReward()){
				_save=true;
			}
			if (_save){
				GameData.saveThis(GameData.REWARDS);
			}
		}
		
		public function makeGrey(v:MovieClip,b:Boolean){
			if (b){
				v.greyMode=true;
				v.gotoAndStop(3);
			}else{
				v.greyMode=false;
				v.gotoAndStop(1);
			}
		}
		
		function popTombstone(e:MouseEvent){
			AchieveData.achieve(AchieveData.VISIT_GRAVE);
			Facade.stage.addChild(new PopTombstone);
		}
		
		public function muteSound(){
			Facade.soundC.mute=!Facade.soundC.mute;
			soundB.toggled=Facade.soundC.mute;
		}
	}
}