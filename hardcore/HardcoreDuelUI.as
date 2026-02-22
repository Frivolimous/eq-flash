package hardcore{
	import flash.display.Sprite;
	import ui.StatusUI;
	import ui.windows.ExportWindow;
	import flash.display.MovieClip;
	import ui.assets.FadeTransition;
	import ui.main.assets.PopLoadUI;
	import utils.KongregateAPI;
	import ui.windows.ExportWindow;
	import utils.GameData;
	import utils.PlayfabAPI;
	import ui.main.BaseUI;
	import ui.assets.ScrollAnnounce;

	public class HardcoreDuelUI extends BaseUI{
		var charView0:SpriteModel=new SpriteModel();
		var charView1:SpriteModel=new SpriteModel();
		
		var duelButtons:Sprite=new Sprite;
		var popLoadUI:PopLoadUI;
		
		var leaveLoad:int;
		
		var transType:int=0;
		var topChallenge:Boolean;
		var challengeList:int=0;
		
		public function HardcoreDuelUI(){
			challengeB.update(StringData.CHALLENGE,nullFunction,true);
			rulesB.update("Rules",popRules);
			
			doneB.update(StringData.LEAVE,goMenu);
			soundB.update(null,muteSound,true);
			fightB.update(StringData.FIGHT,goFight);
			load1B.update(StringData.LOAD_CHAR,popLoad);
			stats1B.update(StringData.STATUS,goStatistics);
			stats1B.index=0;
			stats2B.update(StringData.STATUS,goStatistics);
			stats2B.index=1;
			
			charView0.view.x=145;
			charView0.view.y=280;
			addChild(charView0.view);
			
			charView1.view.x=510;
			charView1.view.y=280;
			addChild(charView1.view);
		}
		
		var popping:int=-1;
		public function popLoad(){ //creates the PopLoadUI to select which PLAYER CHARACTER to load for _char
			if (popping!=-1) return;
			
			if (popLoadUI!=null){
				removeChild(popLoadUI);
			}
			popping=0;
			GameData.getCharacterArray(popLoad2);
		}
		
		public function popLoad2(a:Array){ //finishes popping the PopLoadUI IN GENERAL
			popLoadUI=new PopLoadUI(a,loadChar,popping);
			popLoadUI.x=41.5+popping*365.1;
			popLoadUI.y=84.5;
			addChild(popLoadUI);
			popping=-1;
		}
		
		public function loadChar(i:int,_char:int=0){
			Facade.saveC.startLoadChar(Facade.gameM.playerM,i,false,null,finishLoadChar0);
		}
		
		function finishLoadChar0(){
			display(Facade.gameM.playerM,0); 
			if (Facade.gameM.playerM.saveSlot>=0 && Facade.gameM.playerM.saveSlot<5){
				leaveLoad=Facade.gameM.playerM.saveSlot;
			}
			
			if (popLoadUI!=null){
				removeChild(popLoadUI);
				popLoadUI=null;
			}
		}
		
		public function switchChallenge(){
			Facade.saveC.loadChallenge(Facade.gameM.enemyM,GameData.hardcore,0);
			display(Facade.gameM.enemyM,1);
			
			topChallenge=true;
		}
		
		public function goStatistics(i:int){
			var _model:SpriteModel;
			if (i==0){
				_model=Facade.gameM.playerM;
			}else{
				_model=Facade.gameM.enemyM;
			}
			transType=-1;
			new FadeTransition(this,new StatusUI(this,_model,(_model.saveSlot>=0 && _model.saveSlot<5)));
		}
		
		public function goMenu(){
			Facade.gameUI.background.clear();
			transType=0;
			new FadeTransition(this,Facade.menuUI);
		}
		
		public function goFight(){
			Facade.gameUI.background.clear();
			Facade.gameUI.background.loadBacks(Math.floor(Math.random()*13),Math.floor(Math.random()*3));
			Facade.gameM.duel=true;
			Facade.gameUI.transTo=this;
			transType=1;
			Facade.gameC=new HardcoreDuelControl;
			new FadeTransition(this,Facade.gameUI);
		}
		
		override public function openWindow(){
			soundB.toggled=Facade.soundC.mute;
			
			if (transType==0){
				//from Menu
				leaveLoad=Facade.gameM.playerM.saveSlot;
				switchChallenge();
			}else if (transType==1){
				//from Duel
				Facade.saveC.loadTemps();
				switchChallenge();
			}else if (transType==-1){
				//from Statistics
			}
			
			display(Facade.gameM.playerM,0);
			display(Facade.gameM.enemyM,1);
			
			Facade.gameM.duel=false;
		}
		
		override public function closeWindow(){
			if (transType==0){
				//back to main menu
				Facade.gameM.enemyM.exists=false;
				Facade.saveC.startLoadChar(Facade.gameM.playerM,leaveLoad,true);
				Facade.gameUI.background.clear();
			}else if (transType==1){
				//to DuelUI
				Facade.saveC.saveTemp(0,Facade.gameM.playerM);
				Facade.saveC.saveTemp(1,Facade.gameM.enemyM);
				Facade.saveC.loadTemps();
			}else if (transType==-1){
				//to Statistics
			}
		}
		
		function display(_v:SpriteModel,i:int){
			var s:String=_v.label+" "+_v.title+"\n<font size='18'>"+StringData.level(_v.level)+"</font>";
			
			if (i==0){
				Facade.saveC.loadShort(charView0,Facade.saveC.getShortArray(_v));
				charView0.view.makeSepia(1.5);
				
				nameTitle0.htmlText=s;
			}else{
				Facade.saveC.loadShort(charView1,Facade.saveC.getShortArray(_v));
				charView1.view.makeSepia(1.5);
			
				nameTitle1.htmlText=s;
			}
		}
		
		public function muteSound(){
			Facade.soundC.mute=!Facade.soundC.mute;
			soundB.toggled=Facade.soundC.mute;
		}
		
		function popRules(){
			new ScrollAnnounce("<b>Hardcore Challenge Arena</b>\n\nWelcome to the Hardcore Challenge Arena!  See how far you can get without dying.  One death resets the whole thing!  Use any character or combination of characters to press onwards - progress is saved by account and not by character.\n\nThe Challenge Arena will close on June 4th 2017 and all participants will get special prizes!  Top players based on challenge level defeated will get bonus prizes!\n\n<b>Rewards:\nParticipant:</b> Participation Award\n<b>Rank 25-50:</b> 5 Power Tokens and Participation Award\n<b>Rank 10-25:</b> 10 Power Tokens, Participation Award and a Common Crafting Ingredient\n<b>Rank 4-10:</b> 15 Power Tokens, a Trophy and a Common Crafting Ingredient\n<b>Rank 3:</b> 30 Power Tokens, a Trophy and a Rare Crafting Ingredient\n<b>Rank 2:</b> 50 Power Tokens, a Trophy and a Rare Crafting Ingredient\n<b>Rank 1:</b> 100 Power Tokens, a Trophy and a Rare Crafting Ingredient");
		}
		
		public function nullFunction(){}
	}
}