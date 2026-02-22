package tournament{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import ui.assets.FadeTransition;
	import ui.main.BaseUI;
	import utils.PlayfabAPI;
	import ui.assets.ScrollBoxSmooth;
	import ui.windows.ConfirmWindow;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import utils.GameData;
	
	public class ExhibitionUI extends BaseUI{
		public static const TITLE_SIMULATE:Array=[MatchResult.P2_NAME,MatchResult.WINS,MatchResult.LOSSES,MatchResult.TIES,MatchResult.TURNS,MatchResult.RESOURCES_L],
							TITLE_EXHIBITION:Array=[MatchResult.LEAGUE,MatchResult.RANK,MatchResult.PLAYER,MatchResult.P1_NAME,MatchResult.WINRATE,MatchResult.TURNS,MatchResult.RESOURCES_L],
							TITLE_PLAYOFFS:Array=[MatchResult.RANK,MatchResult.PLAYER,MatchResult.WINRATE,MatchResult.TURNS,MatchResult.RESOURCES_L],
							TITLE_DUEL:Array=[MatchResult.P1_NAME,MatchResult.P2_NAME,MatchResult.WINRATE,MatchResult.TURNS,MatchResult.RESOURCES_L,MatchResult.RESOURCES_R];
		
		public static const LEAGUE_NAMES:Array=["Champion", "Dragon", "Phoenix", "Archangel", "Gaia", "Valkyrie", "Beast", "Chakra", "Esper"];
		var count:int=10;
		
		var exC:ExhibitionControl=new ExhibitionControl;
		
		var timerT:Timer=new Timer(0,0);
		var cChar:int=0;
		var toTest:Array;
		var duelResults:Array=new Array();
		var testChar:Array;
		var tempChar:Array;
		
		var transTo:BaseUI;
		
		var title:TournamentTextBar;
		var titleWas:Array;
		var scrollBox:ScrollBoxSmooth;
		
		var league:int=-1;
		var leagueResults:Array;
		
		var displayOnly:Boolean=false;
		
		public function ExhibitionUI(_transTo:BaseUI){
			tempChar=Facade.saveC.getArray(Facade.gameM.playerM);
			testChar=Facade.saveC.getShortArray(Facade.gameM.playerM);
			
			scrollBox=new ScrollBoxSmooth(31.5,124.5,552,240);
			scrollBox.leftMargin=5.65;
			addChild(scrollBox);
			scrollB.init(scrollBox.setPosition,1,2);
			
			transTo=_transTo;
			
			timerT.addEventListener(TimerEvent.TIMER,onTickSim);
			timerT.addEventListener(TimerEvent.TIMER_COMPLETE,onCompleteSim);
			if (Facade.DEBUG) Facade.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
			exC.init();
			
			runStuff.runB.update("Simulate",runSimulation);
			doneB.update("Done",navOut);
			backB.update("Back",closeDetails);
			removeChild(backB);
		}
		
		public function displayMode(){
			displayOnly=true;
			//populateLeagueArray(TournamentData.leagueData);
			populateReplay(TournamentData.replayData);
			if (contains(runStuff)) removeChild(runStuff);
			displayMatches(TITLE_PLAYOFFS);
		}
		
		public function navOut(){ //back to wherever
			timerT.stop();
			exC.simMode(false);
			new FadeTransition(this,transTo);
		}
		
		override public function openWindow(){
			if (tempChar!=null){
				Facade.saveC.startLoadChar(Facade.gameM.playerM,-100,false,tempChar);
			}
			if (GameModel.replay){
				GameModel.endReplay();
			}
		}
		
		override public function closeWindow(){
			timerT.stop();
			if (tempChar!=null){
				Facade.saveC.startLoadChar(Facade.gameM.playerM,-100,false,tempChar);
			}
		}
		
//=====================TEMP DEBUG
		public function keyDown(e:KeyboardEvent){
			if (Facade.DEBUG && e.keyCode==Keyboard.O){
				timerT.removeEventListener(TimerEvent.TIMER,onTickSim);
				timerT.removeEventListener(TimerEvent.TIMER_COMPLETE,onCompleteSim);
				timerT.addEventListener(TimerEvent.TIMER,onTickDuel);
				timerT.addEventListener(TimerEvent.TIMER_COMPLETE,onCompleteDuel);
				setupMatches();
			}
			
			if (Facade.DEBUG && e.keyCode==Keyboard.P){
				runDuel();
			}
			if (Facade.DEBUG && e.keyCode==Keyboard.I){
				makeSpreadsheetMatches();
			}
			if (Facade.DEBUG && e.keyCode==Keyboard.U){
				makeSpreadsheetRounds();
			}
			if (Facade.DEBUG && e.keyCode==Keyboard.Y){
				finalizeMatches();
				makeSpreadsheetTotal();
			}
			
			if (Facade.DEBUG && e.keyCode==Keyboard.T){
				//var a:Array=getLeagueArrays();
				//var a:Array=getTotalArrays();
				var a:Array=duelResults[0].getMatchArray();
				var s:String=GameData.arrayToString(a,true);
				trace(s);
			}
			if (Facade.DEBUG && e.keyCode==Keyboard.R){
				//populateLeagueArray(TournamentData.leagueData);
				//closeToLeague();
			}
		}

		public function makeSpreadsheetMatches(){
			var m:String="";
			for (var i:int=0;i<duelResults.length;i+=1){
				m+=duelResults[i].getSpreadsheetRow()+"\n";
			}
			trace(m);
		}
		
		public function makeSpreadsheetRounds(){
			var m:String="";
			for (var i:int=0;i<duelResults.length;i+=1){
				for (var j:int=0;j<duelResults[i].rounds.length;j+=1){
					m+=duelResults[i].rounds[j].getSpreadsheetRow(duelResults[i].player)+"\n";
				}
			}
			trace(m);
		}
		
		public function makeSpreadsheetTotal(){
			var m:String="";
			for (var i:int=0;i<finalMatches.length;i+=1){
				m+=finalMatches[i].getSpreadsheetRow()+"\n";
			}
			trace(m);
		}
		
		public function getTotalArrays():Array{
			var a:Array=new Array;
			for (var i:int=0;i<duelResults.length;i+=1){
				a.push(duelResults[i].getMatchArray());
			}
			return a;
		}
		
		/*public function makeSpreadsheetLeagues(){
			var m:String="";
			for (var i:int=0;i<leagueResults.length;i+=1){
				for (var j:int=0;j<leagueResults[i].length;j+=1){
					var _match:MatchResult=leagueResults[i][j];
					m+=_match.getSpreadsheetRow()+"\n";
				}
			}
			trace(m);
		}
		
		public function makeSpreadsheetLeagueRounds(){
			var m:String="";
			for (var i:int=0;i<leagueResults.length;i+=1){
				for (var j:int=0;j<leagueResults[i].length;j+=1){
					for (var k:int=0;k<leagueResults[i][j].rounds.length;k+=1){
						m+=leagueResults[i][j].rounds[k].getSpreadsheetRow(leagueResults[i][j].player)+"\n";
					}
				}
			}
			trace(m);
		}
		
		public function getLeagueArrays():Array{
			var a:Array=new Array;
			for (var i:int=0;i<leagueResults.length;i+=1){
				a[i]=new Array;
				for (var j:int=0;j<leagueResults[i].length;j+=1){
					var _match:MatchResult=leagueResults[i][j];
					a[i].push(_match.getMatchArray());
				}
			}
			return a;
		}
		
		public function populateLeagueArray(a:Array){
			leagueResults=new Array;
			for (var i:int=0;i<a.length;i+=1){
				leagueResults[i]=new Array;
				for (var j:int=0;j<a[i].length;j+=1){
					var _match:MatchResult=MatchResult.fromMatchArray(a[i][j]);
					_match.league=LEAGUE_NAMES[i];
					leagueResults[i].push(_match);
				}
			}
		}*/
		
		public function populateReplay(a:Array){
			duelResults=new Array;
			for (var i:int=0;i<a.length;i+=1){
				var _match:MatchResult=MatchResult.fromMatchArray(a[i]);
				duelResults.push(_match);
			}
		}
		
//============================================== Sims
		public function runSimulation(){ //runs current playerM through all opponents in toTest
			league=-1;
			//toTest=TournamentData.exhibitionTest;
			toTest=TournamentData.getExhibitionArray();
			exC.simMode(true);
			scrollBox.clear();
			scrollB.setPosition(1);
			duelResults=new Array;
			
			cChar=0;
			
			duelResults[cChar]=new MatchResult();
			
			titleWas=TITLE_SIMULATE;
			makeTitle(TITLE_SIMULATE);
			
			timerT.repeatCount=count;
			timerT.reset();
			timerT.start();
		}
		
		public function onTickSim(e:TimerEvent){
			duelResults[cChar].addRound(exC.fastDuel(new DuelResult(testChar,toTest[cChar]),true));
			runStuff.runText.text="Running: "+String(timerT.currentCount);
		}
		
		public function onCompleteSim(e:TimerEvent=null){
			duelResults[cChar].deriveAllStats();
			makeMatchBar(duelResults[cChar],cChar);
			
			cChar+=1;
			if (cChar<toTest.length){
				duelResults[cChar]=new MatchResult();
				timerT.reset();
				timerT.start();
			}
			Facade.saveC.startLoadChar(Facade.gameM.playerM,-100,false,tempChar);
		}
		
		//===EXHIBITION SIM===
		var finalMatches:Array=new Array();
		var heat:int=0;
		
		public function setupMatches(){
			for (var i:int=0;i<TournamentData.exhibitionChars.length;i+=1){
				finalMatches[i]=new MatchResult();
				finalMatches[i].player=TournamentData.exhibitionChars[i][0];
			}
		}
		
		public function finalizeMatches(){
			for (var i:int=0;i<finalMatches.length;i+=1){
				finalMatches[i].deriveAllStats();
			}
			sortWins(finalMatches);
			runStuff.runText.text="FINALIZED!!!!";
		}
		
		public function runExhibition(){
			//run through 1 heat (32 x 32).  Then put the rounds into appropriate final matches and reorder.
			heat+=1;
			duelResults=new Array;
			exC.simMode(true);
			scrollBox.clear();
			scrollB.setPosition(1);
			
			makeTitle(TITLE_PLAYOFFS);
			
			toTest=TournamentData.exhibitionChars;
			
			cChar=0;
			
			for (var i:int=0;i<toTest.length;i+=1){
				var _match:MatchResult=new MatchResult();
				_match.player=toTest[i][0];
				duelResults.push(_match);
			}
			
			timerT.repeatCount=toTest.length-1;
			timerT.reset();
			timerT.start();
		}
		
		public function onTickEx(e:TimerEvent){
			var _opponent:int=timerT.currentCount+cChar;
			var _round:DuelResult=exC.fastDuel(new DuelResult(toTest[cChar][1],toTest[_opponent][1]),false);
			duelResults[cChar].addRound(_round);
			finalMatches[cChar].addRound(_round);
			duelResults[_opponent].addRound(_round.flip());
			finalMatches[_opponent].addRound(_round.flip());
			runStuff.runText.text="Run: "+heat+"-"+String(cChar)+"-"+String(timerT.currentCount);
		}
		
		public function onCompleteEx(e:TimerEvent=null){
			duelResults[cChar].deriveAllStats();
			cChar+=1;
			if (cChar<toTest.length-1){
				timerT.repeatCount=toTest.length-cChar-1;
				timerT.reset();
				timerT.start();
			}else{
				duelResults[cChar].deriveAllStats();
				sortWins(duelResults);
				runStuff.runText.text="DONE!";
			}
		}
		
		//DUELS!!!
		
		public function runDuel(){
			//heat+=1;
			//duelResults=new Array;
			exC.simMode(true);
			scrollBox.clear();
			scrollB.setPosition(1);
			
			makeTitle(TITLE_DUEL);
			
			toTest=[TournamentData.championTest[heat*2][1],TournamentData.championTest[heat*2+1][1]];
			heat+=1;
			duelResults=[new MatchResult()];
			duelResults[0].player=toTest[0][0];
			
			timerT.repeatCount=100;
			timerT.reset();
			timerT.start();
		}
		
		public function onTickDuel(e:TimerEvent){
			duelResults[0].addRound(exC.fastDuel(new DuelResult(toTest[0],toTest[1]),true));
			runStuff.runText.text="Running: "+String(timerT.currentCount);
		}
		
		public function onCompleteDuel(e:TimerEvent=null){
			duelResults[0].deriveAllStats();
		}
		
		
		//var league:int=-1;
		//var leagueResults:Array;
		//var testStart:int=0;
		//const testCount:int=90;
		/*public function runExhibition(){ //Matches up to testCount opponents against each other from the exhibitionChars array
			duelResults=new Array;
			leagueResults=new Array;
			league=-1;
			
			exC.simMode(true);
			scrollBox.clear();
			scrollB.setPosition(1);
			
			makeTitle([MatchResult.LEAGUE]);
			
			nextRoundEx();
		}
		
		function nextRoundEx(){
			league+=1;
			testStart=league*testCount;
			if (testStart>=TournamentData.exhibitionChars.length){
			//if (league>7){
				runStuff.runText.text="DONE!";
				return;
			}
			
			toTest=new Array();
			for (var i:int=testStart;(i<(testStart+testCount) && i<TournamentData.exhibitionChars.length);i+=1){
				toTest.push(TournamentData.exhibitionChars[i]);
			}
			
			leagueResults[league]=new Array;
			cChar=0;
			
			for (i=0;i<toTest.length;i+=1){
				var _match:MatchResult=new MatchResult();
				_match.player=toTest[i][0];
				_match.league=LEAGUE_NAMES[league];
				
				leagueResults[league].push(_match);
			}
			
			timerT.repeatCount=toTest.length-1;
			timerT.reset();
			timerT.start();
		}
		
		public function onTickEx(e:TimerEvent){
			var _opponent:int=timerT.currentCount+cChar;
			var _round:DuelResult=exC.fastDuel(new DuelResult(toTest[cChar][1],toTest[_opponent][1]),false);
			leagueResults[league][cChar].addRound(_round);
			leagueResults[league][_opponent].addRound(_round.flip());
			runStuff.runText.text="Run: "+String(league)+"-"+String(cChar)+"-"+String(timerT.currentCount);
		}
		
		public function onCompleteEx(e:TimerEvent=null){
			leagueResults[league][cChar].deriveAllStats();
			cChar+=1;
			if (cChar<toTest.length-1){
				timerT.repeatCount=toTest.length-cChar-1;
				timerT.reset();
				timerT.start();
			}else{
				leagueResults[league][cChar].deriveAllStats();
				sortWins(leagueResults[league]);
				makeLeagueBar(league);
				nextRoundEx();
			}
		}*/
		
		public function sortWins(a:Array){
			a.sort(orderMatches);
			for (var i:int=0;i<a.length;i+=1){
				a[i].rank=i+1;
			}
		}
		
		function orderMatches(a,b):int{
			if (a.winrate>b.winrate){
				return -1;
			}else if (a.winrate<b.winrate){
				return 1;
			}else{
				return 0;
			}
		}
		
		
//=========================DISPLAY STUFF==========================
		public function makeTitle(a:Array){
			if (title!=null && contains(title)) removeChild(title);
			title=MatchResult.getTitleBar(a,537);
			title.x=37;
			title.y=89;
			addChild(title);
		}
		
		var _temp:Sprite;
		
		public function displayMatches(_title:Array){
			scrollBox.clear();
			scrollB.setPosition(1);
			
			titleWas=_title;
			makeTitle(_title);
			for (var i:int=0;i<duelResults.length;i+=1){
				makeMatchBar(duelResults[i],i);
			}
		}
		
		public function showDetails(i:int){
			cChar=i;
			timerT.stop();
			_temp=scrollBox.display;
			scrollBox.clear();
			makeTitle(DuelResult.FORMAT);
			
			for (var j:int=0;j<duelResults[i].rounds.length;j+=1){
				var _bar:TournamentTextBar=duelResults[i].getRoundTextBar(j);
				if (duelResults[i].rounds[j].replay!=null){
					_bar.makeButton(preReplay,j);
				}
				scrollBox.addObject(_bar);
			}
			scrollB.setPosition(1);
			if (contains(runStuff)) removeChild(runStuff);
			backB.update("Back",closeDetails);
			addChild(backB);
		}
		
		public function closeDetails(){
			timerT.stop();
			scrollBox.setDisplay(_temp);
			_temp=null;
			makeTitle(titleWas);
			scrollB.setPosition(1);
			
			if (league>=0){
				backB.update("Back",closeToLeague);
			}else{
				if (contains(backB)) removeChild(backB);
				if (!displayOnly) addChild(runStuff);
			}
		}
		
		public function preReplay(i:int){
			new ConfirmWindow("Do you want to watch the replay for this match?",100,100,replayIndex,i);
		}
		
		public function replayIndex(i:int){
			exC.fullDuel(duelResults[cChar].rounds[i],true);
		}
		
		function makeLeagueBar(_league:int){
			var _bar:TournamentTextBar=new TournamentTextBar([LEAGUE_NAMES[_league]+" League"],MatchResult.width,false);
			_bar.makeButton(matchesFromLeague,_league);
			scrollBox.addObject(_bar);
			//makeMatchBar(leagueResults[l[i],i);
		}
		
		function matchesFromLeague(_league:int){
			league=_league;
			timerT.stop();
			scrollBox.clear();
			
			titleWas=TITLE_EXHIBITION;
			makeTitle(TITLE_EXHIBITION);
			duelResults=leagueResults[_league];
			for (var i:int=0;i<duelResults.length;i+=1){
				makeMatchBar(duelResults[i],i);
			}
			
			scrollB.setPosition(1);
			if (contains(runStuff)) removeChild(runStuff);
			backB.update("Back",closeToLeague);
			addChild(backB);
		}
		
		function closeToLeague(){
			timerT.stop();
			scrollBox.clear();
			
			makeTitle([MatchResult.LEAGUE]);
			for (var i:int=0;i<leagueResults.length;i+=1){
				makeLeagueBar(i);
			}
			scrollB.setPosition(1);
			if (contains(backB)) removeChild(backB);
			if (!displayOnly) addChild(runStuff);
		}
		
		function makeMatchBar(_matchResult:MatchResult,i:int){
			var _bar:TournamentTextBar=_matchResult.getTextBar();
			if (_matchResult.rounds!=null){
				_bar.makeButton(showDetails,i);
			}
			scrollBox.addObject(_bar);
		}
	}
}