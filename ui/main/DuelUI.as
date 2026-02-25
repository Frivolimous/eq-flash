package ui.main{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ui.assets.NumberButton;
	import ui.StatusUI;
	import flash.display.MovieClip;
	import ui.assets.FadeTransition;
	import ui.main.assets.PopLoadUI;
	import ui.windows.ExportWindow;
	import utils.GameData;

	public class DuelUI extends BaseUI{
		var charView0:SpriteModel=new SpriteModel();
		var charView1:SpriteModel=new SpriteModel();
		
		var duelButtons:Sprite=new Sprite;
		var popLoadUI:PopLoadUI;
		
		var leaveLoad:int;
		
		var transType:int=0;
		var topChallenge:Boolean;
		var challengeList:int=0;
		
		public function DuelUI(){
			challengeB.update(StringData.CHALLENGE,switchChallenge,true);
			// season1B.update(StringData.SEASON1,switchSeason1,true);
			duelB.update(StringData.DUEL,switchDuel,true);
			exportB.update(StringData.EXPORT,popExport);
			
			doneB.update(StringData.LEAVE,goMenu);
			soundB.update(null,muteSound,true);
			fightB.update(StringData.FIGHT,goFight);
			load1B.update(StringData.LOAD_CHAR,popLoad);
			load1B.index=0;
			load2B.update(StringData.LOAD_CHAR,popLoad);
			load2B.index=1;
			stats1B.update(StringData.STATUS,goStatistics);
			stats1B.index=0;
			stats2B.update(StringData.STATUS,goStatistics);
			stats2B.index=1;
			importB.update(StringData.IMPORT,popImport);
			challengeLoadB.update(StringData.LOAD_CHAR,popLoadChallenge);
			
			charView0.view.x=145;
			charView0.view.y=280;
			addChild(charView0.view);
			
			charView1.view.x=510;
			charView1.view.y=280;
			addChild(charView1.view);
			
			duelButtons.addChild(load2B);
			duelButtons.addChild(importB);
			
			switchChallenge();
		}
		
		var popping:int=-1;
		public function popLoad(_char:int){ //creates the PopLoadUI to select which PLAYER CHARACTER to load for _char
			if (popping!=-1) return;
			
			if (popLoadUI!=null){
				removeChild(popLoadUI);
			}
			popping=_char;
			GameData.getCharacterArray(popLoad2);
		}
		
		public function popLoad2(a:Array){ //finishes popping the PopLoadUI IN GENERAL
			popLoadUI=new PopLoadUI(a,loadChar,popping);
			popLoadUI.x=41.5+popping*365.1;
			popLoadUI.y=84.5;
			addChild(popLoadUI);
			popping=-1;
		}
		
		function popLoadChallenge(){ //creates the PopLoadUI to select which CHALLENGE CHARACTER to load for char 1
			if (popLoadUI!=null){
				removeChild(popLoadUI);
			}
			if (Facade.gameM.challengeList==0){
				popLoadUI=new PopLoadUI(Facade.saveC._Challenge,loadChallenge,1,0,Facade.gameM.playerM.challenge[Facade.gameM.challengeList]);
			}else if (Facade.gameM.challengeList==1){
				popLoadUI=new PopLoadUI(Facade.saveC._Tournament1,loadChallenge,1,0,Facade.gameM.playerM.challenge[Facade.gameM.challengeList]);
			}
			popLoadUI.x=406.6;
			popLoadUI.y=84.5;
			addChild(popLoadUI);
		}
		
		public function loadChar(i:int,_char:int){
			if (_char==0){
				Facade.saveC.startLoadChar(Facade.gameM.playerM,i,true,null,finishLoadChar0);
			}else{
				Facade.saveC.startLoadChar(Facade.gameM.enemyM,i,false,null,finishLoadChar1);
			}
		}
		
		function finishLoadChar0(){
			display(Facade.gameM.playerM,0); 
			if (Facade.gameM.playerM.saveSlot>=0 && Facade.gameM.playerM.saveSlot<5){
				leaveLoad=Facade.gameM.playerM.saveSlot;
			}
			if (Facade.gameM.enemyM.saveSlot>=Facade.gameM.playerM.challenge[Facade.gameM.challengeList] || topChallenge){
				switchChallenge();
			}
			if (popLoadUI!=null){
				removeChild(popLoadUI);
				popLoadUI=null;
			}
		}
		
		function finishLoadChar1(){
			display(Facade.gameM.enemyM,1);
			if (Facade.gameM.enemyM.saveSlot==Facade.gameM.playerM.challenge[Facade.gameM.challengeList]+5){
				topChallenge=true;
			}else{
				topChallenge=false;
			}
			if (popLoadUI!=null){
				removeChild(popLoadUI);
				popLoadUI=null;
			}
		}
		
		
		public function loadChallenge(i:int,_char:int){
			if (_char==0){
				Facade.saveC.loadChallenge(Facade.gameM.playerM,i,Facade.gameM.challengeList);
			}else{
				Facade.saveC.loadChallenge(Facade.gameM.enemyM,i,Facade.gameM.challengeList);
			}
			finishLoadChar1();
		}
		
		public function switchChallenge(){
			challengeB.toggled=true;
			// season1B.toggled=false;
			duelB.toggled=false;
			if (contains(duelButtons)){
				removeChild(duelButtons);
			}
			if (popLoadUI!=null){
				removeChild(popLoadUI);
				popLoadUI=null;
			}
			Facade.gameM.challengeList=0;
			addChild(challengeLoadB);
			//loadChar(Facade.gameM.playerM.challenge[Facade.gameM.challengeList]+5,1);
			loadChallenge(Facade.gameM.playerM.challenge[Facade.gameM.challengeList],1);
		}
		
		public function switchSeason1(){
			challengeB.toggled=false;
			// season1B.toggled=true;
			duelB.toggled=false;
			if (contains(duelButtons)){
				removeChild(duelButtons);
			}
			if (popLoadUI!=null){
				removeChild(popLoadUI);
				popLoadUI=null;
			}
			Facade.gameM.challengeList=1;
			addChild(challengeLoadB);
			//loadChar(Facade.gameM.playerM.challenge[Facade.gameM.challengeList]+5,1);
			loadChallenge(Facade.gameM.playerM.challenge[Facade.gameM.challengeList],1);
		}
		
		public function switchDuel(){
			challengeB.toggled=false;
			// season1B.toggled=false;
			duelB.toggled=true;
			addChild(duelButtons);
			if (popLoadUI!=null){
				removeChild(popLoadUI);
				popLoadUI=null;
			}
			if (contains(challengeLoadB)){
				removeChild(challengeLoadB);
			}
			loadChar(0,1);
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
			Facade.gameC=new DuelControl();
			transType=1;
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
				if (topChallenge){
					switchChallenge();
				}
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
		
		public function popExport(){
				new ExportWindow(Facade.saveC.exportSave(Facade.gameM.playerM));

			// STEAM SHARE?

				// var _toSave:SpriteModel=Facade.gameM.playerM;
				// *.shareSave(Facade.saveC.exportSave(_toSave),_toSave.level,_toSave.view);
		}
		
		function popImport(){
			new ExportWindow(null,finishImport);

			// STEAM IMPORT?
			//*.shareBrowse();
		}
		
		public function finishImport(s:String){
			if (Facade.currentUI==this){
				Facade.saveC.importSave(Facade.gameM.enemyM,s);
				display(Facade.gameM.enemyM,1)
			}
		}
		
		public function muteSound(){
			Facade.soundC.mute=!Facade.soundC.mute;
			soundB.toggled=Facade.soundC.mute;
		}
	}
}