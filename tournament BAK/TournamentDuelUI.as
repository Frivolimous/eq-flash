package ui.main{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ui.assets.NumberButton;
	import ui.StatusUI;
	import ui.windows.ExportWindow;
	import flash.display.MovieClip;
	import ui.assets.FadeTransition;
	import ui.main.assets.PopLoadUI;
	import utils.KongregateAPI;
	import ui.windows.ExportWindow;
	import utils.PlayfabAPI;
	import tournament.TournamentData;

	public class TournamentDuelUI extends BaseUI{
		var charView0:SpriteModel=new SpriteModel();
		var charView1:SpriteModel=new SpriteModel();
		
		var duelButtons:Sprite=new Sprite;
		var popLoadUI:PopLoadUI;
		
		var leaveLoad:int;
		
		var transType:int=0;
		var transTo:BaseUI;
		
		public function TournamentDuelUI(_transTo:BaseUI){
			transTo=_transTo;
			
			doneB.update(StringData.DONE,goMenu);
			soundB.update(null,muteSound,true);
			fightB.update(StringData.FIGHT,goFight);
			
			stats1B.update(StringData.STATUS,goStatistics);
			stats1B.index=0;
			stats2B.update(StringData.STATUS,goStatistics);
			stats2B.index=1;
			challengeLoad1B.update("Set 1",popLoadExhibition);
			challengeLoad1B.index=0;
			challengeLoad2B.update("Set 2",popLoadExhibition);
			challengeLoad2B.index=1;
			opponentB.update("Opponent",popLoadOpponent);
			challengeLoad1B.setDesc("Tournament Set 1","Shows you the first half of the current Tournament Opponents.  Wait, where's the second?");
			//challengeLoad2B.setDesc("Tournament Set 2","Shows you the second half of the current Tournament Opponents.");
			opponentB.setDesc("Opponent","Shows your current opponent in the arena.");
			
			charView0.view.x=145;
			charView0.view.y=280;
			addChild(charView0.view);
			
			charView1.view.x=510;
			charView1.view.y=280;
			addChild(charView1.view);
		}
		
		var popping:Boolean=false;
		const sectionLength:int=8;
		var sectionStart:int=0;
		function popLoadExhibition(_section:int){
			if (popLoadUI!=null){
				removeChild(popLoadUI);
			}
			sectionStart=_section*sectionLength;
			popLoadUI=new PopLoadUI(TournamentData.getExhibitionArray(sectionStart,sectionLength),loadExhibition,1);
			popLoadUI.x=406.6;
			popLoadUI.y=84.5;
			addChild(popLoadUI);
		}
		
		function loadExhibition(i:int,player:int=1){
			Facade.saveC.loadShort(Facade.gameM.enemyM,TournamentData.exhibitionChars[i+sectionStart][1]);
			finishLoadChar();
		}
		
		function popLoadOpponent(){
			Facade.saveC.loadShort(Facade.gameM.enemyM,TournamentData.getOpponent());
			finishLoadChar();
		}
		
		function popLoadChallenge1(){
			if (popLoadUI!=null){
				removeChild(popLoadUI);
			}
			popLoadUI=new PopLoadUI(TournamentData.championTest[0],loadPractice1,1,0);
			popLoadUI.x=406.6;
			popLoadUI.y=84.5;
			addChild(popLoadUI);
		}
		
		public function loadPractice1(i:int,player:int=1){
			Facade.saveC.loadShort(Facade.gameM.enemyM,TournamentData.championTest[0][i],-1,false);
			finishLoadChar();
		}
		
		function popLoadChallenge2(){
			if (popLoadUI!=null){
				removeChild(popLoadUI);
			}
			popLoadUI=new PopLoadUI(TournamentData.championTest[1],loadPractice2,1,0);
			popLoadUI.x=406.6;
			popLoadUI.y=84.5;
			addChild(popLoadUI);
		}
		
		public function loadPractice2(i:int,player:int=1){
			Facade.saveC.loadShort(Facade.gameM.enemyM,TournamentData.championTest[1][i],-1,false);
			finishLoadChar();
		}
		
		function popLoadChallenge3(){
			if (popLoadUI!=null){
				removeChild(popLoadUI);
			}
			popLoadUI=new PopLoadUI(TournamentData.championTest[2],loadPractice3,1,0);
			popLoadUI.x=406.6;
			popLoadUI.y=84.5;
			addChild(popLoadUI);
		}
		
		public function loadPractice3(i:int,player:int=1){
			Facade.saveC.loadShort(Facade.gameM.enemyM,TournamentData.championTest[2][i],-1,false);
			finishLoadChar();
		}
		
		function finishLoadChar(){
			display(Facade.gameM.enemyM,1);
			
			if (popLoadUI!=null){
				removeChild(popLoadUI);
				popLoadUI=null;
			}
		}
		
		public function goStatistics(i:int){
			transType=-1;
			if (i==0){
				new FadeTransition(this,new StatusUI(this,Facade.gameM.playerM));
			}else{
				new FadeTransition(this,new StatusUI(this,Facade.gameM.enemyM,false));
			}
			
		}
		
		public function goMenu(){
			Facade.gameUI.background.clear();
			transType=0;
			new FadeTransition(this,transTo);
		}
		
		public function goFight(){
			Facade.gameUI.background.clear();
			Facade.gameUI.background.loadBacks(Math.floor(Math.random()*13),Math.floor(Math.random()*3));
			Facade.gameM.duel=true;
			Facade.gameUI.transTo=this;
			transType=1;
			new FadeTransition(this,Facade.gameUI);
		}
		
		var _tempSave:Array;
		
		override public function closeWindow(){
			Facade.gameUI.background.clear();
			if (transType==0){
				//back to main menu
				Facade.gameM.enemyM.exists=false;
			}else if (transType==1){
				//to DuelUI
				_tempSave=Facade.saveC.getArray(Facade.gameM.playerM);
				Facade.saveC.saveTemp(0,Facade.gameM.playerM);
				Facade.saveC.saveTemp(1,Facade.gameM.enemyM);
				Facade.saveC.loadTemps();
			}else if (transType==-1){
				//to Statistics
			}
		}
		
		override public function openWindow(){
			soundB.toggled=Facade.soundC.mute;
			
			if (transType==0){
				//from Menu
				if (TournamentData.isActive()){
					popLoadOpponent();
				}else{
					loadExhibition(0);
					removeChild(opponentB);
				}
			}else if (transType==1){
				//from Duel
				Facade.saveC.loadTemps();
				if (_tempSave!=null){
				Facade.saveC.startLoadChar(Facade.gameM.playerM,-100,false,_tempSave);
					_tempSave=null;
				}
			}else if (transType==-1){
				//from Statistics
			}
			
			display(Facade.gameM.playerM,0);
			display(Facade.gameM.enemyM,1);
			
			Facade.gameM.duel=false;
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
	}
}