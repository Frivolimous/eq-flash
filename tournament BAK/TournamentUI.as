package ui.main{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import ui.StatusUI;
	import ui.windows.ConfirmWindow;
	import ui.assets.FadeTransition;
	import ui.assets.InstantTransition;
	import utils.GameData;
	import ui.assets.ScrollAnnounce;
	import tournament.ExhibitionUI;
	import utils.KongregateAPI;
	import tournament.TournamentData;
	
	public class TournamentUI extends BaseUI{
		public static const SAVESLOT:int=-100;
		
		var gameM:GameModel=Facade.gameM;
		var newCUI:NewCharacterUI;
		const submissionsLocked:Boolean=true;
		//var nextRound:Boolean=false;
		
		public function TournamentUI(){
			if (!submissionsLocked){
				newCharB.update(StringData.NEW_CHAR,popNew);
				submitB.update("Submit",popSubmit);
			}
			
			statusB.update(StringData.STATUS,popStatistics);
			simulateB.update("Simulate",popSim);
			duelB.update("Duel",popDuel);
			
			rulesB.update("Rules",popRules);
			resultsB.update("Results",popResults);
			//removeChild(resultsB);
			
			doneB.update(StringData.LEAVE,navOut,true);
			soundB.update(null,muteSound,true);
			
			newCUI=new NewCharacterUI(this);
			newCUI.saveSlot=SAVESLOT;
		}
		
		public function popNew(){
			new FadeTransition(this,newCUI);
		}
		
		public function popStatistics(){
			var _status:StatusUI=new StatusUI(this,gameM.playerM);
			if (submissionsLocked) {
				_status.stashLocked=true;
				if (TournamentData.isActive()) _status.skillUI.locked=true;
			}
			new FadeTransition(this,_status);
		}
		
		public function popRules(){
			//new ScrollAnnounce("Welcome to the first official EQ Player Tournament!\n\n<b>Tournament Structure:\n\nRound 1: Exhibition Qualifier</b>\n<font color='#ff5500'>Submission Deadline: April 7 2017 12am EST</font>\nAll Applicants will battle every other applicant once. Top 16 Winrate will move on to Round 2\n\n<b>Round 2 - Round 5: Matchup</b>\n<font color='#ff5500'>1 day between submission deadlines, until roughly April 14th</font>\nBefore each round, qualifying players can view their opponents and swap out equipment from their Reserve Items.\nOnly loadout from previous round can be viewed.\n100 battles will be simulated each round and the higher win rate will move onto next round.\n\n<b>Rewards:\nParticipant:</b> 500 Soul Power\n<b>Rank 9-16:</b> 1,000 Soul Power, Special Reward (TBD)\n<b>Rank 5-8:</b> 2,000 SP, Special and permanent place in the Dueling Arena\n<b>Rank 3-4:</b> 3,000 SP, Special, Duel and 20 Power Tokens\n<b>Rank 2:</b> 4,000 SP, Special, Duel and 50 Power Tokens\n<b>Rank 1:</b> 5,000 SP, Special, Duel and 100 Power Tokens\n\n<b>Applications:</b>\nFresh Level 60 Characters will be created\nCopies of any item in your stash can be used to equip your character\nFive (5) Items of any type can be placed in your inventory to swap out between rounds\nArtifacts cannot be equipped\nOnly ONE submission can be made per player and once submitted there will be no takebacks.\nSubmissions will be filtered for legality before being run through the system and if anything outside the rules is found those characters will be disqualified.");
			//new ScrollAnnounce("First Official EQ Player Tournament!\n\n<b>Round 1 Complete!</b>\nThere were 337 particiants in the first round, a much larger number than anticipated.  Because of this I had to change the format of the tournament slightly.\nInstead of a full on Round Robin, all characters were split up into 5 Leagues of ~68.  These leagues each had their own round robins and players were ranked within them based on Winrate (Win = 1pt, Loss = 0pts, Tie = 0.5pts).  After these leagues were completed the top 16 players of each league (80 total) faced off in the Champion League.  The top 32 characters in each league are now moving on to Round 2!All participants can now see their ranking after the first round.  If you have been eliminated then worry not!  You will still get 500 Souls and a Participation Trophy at the end of the Tournament.\n\nFor those of you that Qualified for Round 2, congratulations!  Due to the OVERWHELMING number of participants you will now face a new round of PLAYOFFS to see who will get into the top 16!\n\n<b>Playoff Rules</b>\n<font color='#ff5500'>Submission Deadline: April 9 2017 12am EST</font>\nAll participants will now be able to view and challenge the current builds of all 32 Playoff Characters.  You will only be able to see their builds from last round, and not their secret backup inventory.\nYou may change your build however you desire and whatever state you leave it in will be used for the next round.  No further submissions are necessary!\nEach character will face every other character 10 times for a total of 310 matches.\nTop 16 Winrate Players will move on to the Tournament Ladder and will face off in a classic tournament.  These players will be able to change their gear between rounds and will have 24-48 hours to do so.\n\n<b>Further Rounds</b>\nEach further round will be a 1-on-1 challenge for 100 rounds.  Winner will move up the ladder until the final championship which will determine the winner!\n\n<b>Rewards:\nParticipant:</b> 500 Soul Power\n<b>Rank 9-16:</b> 1,000 Soul Power, Special Reward (TBD)\n<b>Rank 5-8:</b> 2,000 SP, Special and permanent place in the Dueling Arena\n<b>Rank 3-4:</b> 3,000 SP, Special, Duel and 20 Power Tokens\n<b>Rank 2:</b> 4,000 SP, Special, Duel and 50 Power Tokens\n<b>Rank 1:</b> 5,000 SP, Special, Duel and 100 Power Tokens\n\n<b>Applications:</b>\nFresh Level 60 Characters will be created\nCopies of any item in your stash can be used to equip your character\nFive (5) Items of any type can be placed in your inventory to swap out between rounds\nArtifacts cannot be equipped\nOnly ONE submission can be made per player and once submitted there will be no takebacks.\nSubmissions will be filtered for legality before being run through the system and if anything outside the rules is found those characters will be disqualified.");
			new ScrollAnnounce("<b>First Official EQ Player Tournament!</b>\nFor detailed results go to <a href='https://docs.google.com/spreadsheets/d/17kMc07uXUpdqkLqcbf6Dp4MNXFWFLp0RA_G7zEFWvoM/edit?usp=sharing'><font color='#5555ff'><u>this spreadsheet!</u></font></a> (right click and select 'new window' if u have ad-blocker)\n\n<b>Semifinals Complete!</b>\nCongratulations to the 2 remaining finalists!  You have now been placed in your brackets according to your seed position.  Please go to the Duel screen to see who you will be facing in the next round.  You are now allowed to change your equipment with your reseerves but your skills will be LOCKED IN for the remainder of the tournament.  Good luck!\n\n<b>Ladder Rules</b>\n<font color='#ff5500'>Submission Deadline: April 13 2017 12am EST</font>\nYou will only be able to see character builds from last round, and not their secret backup inventory.\nYou may change your equipment however you desire and whatever state you leave it in will be used for the next round.  No further submissions are necessary!\nYou will face your opponent 100 times and the highest winrate will move on to the next round.  Between each round you will be allowed to change your gear and will have 24-48 hours to do so.\n\n<b>Rewards:\nParticipant:</b> 500 Soul Power\n<b>Champion Tier:</b> 750 Soul Power\n<b>Rank 17-32:</b> 1000 Soul Power\n<b>Rank 8-16:</b> 1,250 Soul Power, Special Reward (TBD)\n<b>Rank 4-7:</b> 2,000 SP, Special and permanent place in the Dueling Arena\n<b>Rank 3:</b> 3,000 SP, Special, Duel and 20 Power Tokens\n<b>Rank 2:</b> 4,000 SP, Special, Duel and 50 Power Tokens\n<b>Rank 1:</b> 5,000 SP, Special, Duel and 100 Power Tokens");
		}
		
		public function popSim(){
			new FadeTransition(this,new ExhibitionUI(this));
		}
		
		public function popResults(){
			var _ex:ExhibitionUI=new ExhibitionUI(this);
			_ex.displayMode();
			new FadeTransition(this,_ex);
		}
		
		public function popDuel(){
			Facade.gameC=Facade.duelC;
			new FadeTransition(this,new TournamentDuelUI(this));
		}
		
		public function popSubmit(){
			new ConfirmWindow("*WARNING*\n You can only submit ONE Character to the Tournament and Submissions are FINAL",50,50,finishSubmit);
		}
		
		public function finishSubmit(i:int=0){
			utils.PlayfabAPI.submitArena(Facade.saveC.getTournamentCharacter(Facade.gameM.playerM));
			if (contains(newCharB)) removeChild(newCharB);
			if (contains(submitB)) removeChild(submitB);
			new ConfirmWindow("Congratulations, you have entered the Tournament Challenge!  Stay tuned for more information in the coming days!");
		}
		
		public function navOut(i:int=0){
			if (GameData.BUSY) return;
			Facade.gameM.duel=false;
			new FadeTransition(this,Facade.menuUI);
			Facade.saveC.startLoadChar(Facade.gameM.playerM,GameData.lastChar);
		}
		
		override public function openWindow(){
			if (contains(newCharB)) removeChild(newCharB);
			if (contains(submitB)) removeChild(submitB);
			if (submissionsLocked){
				if (contains(statusB)) removeChild(statusB);
				if (contains(simulateB)) removeChild(simulateB);
				if (contains(duelB)) removeChild(duelB);
			}
			
			Facade.gameM.duel=false;
			soundB.toggled=Facade.soundC.mute;
			
			GameData.checkArenaSubmit(finishOpen2);
		}
		
		function finishOpen2(b:Boolean){
			if (submissionsLocked){
				if (b){
					if (Facade.gameM.playerM.saveSlot==SAVESLOT){
						Facade.saveC.justSaveChar(Facade.gameM.playerM);
						finishOpenLOCKED();
					}else{
						Facade.saveC.startLoadChar(Facade.gameM.playerM,SAVESLOT,false,null,finishOpenLOCKED);
					}
				}else{
					new ConfirmWindow("Sorry, you are too late to participate in the Season 1 Tournament.  Hope to see you next time!");
					display.clear();
				}
			}else{
				if (!b){
					addChild(newCharB);
					addChild(submitB);
				}
				
				if (Facade.gameM.playerM.saveSlot==SAVESLOT){
					Facade.saveC.justSaveChar(Facade.gameM.playerM);
					finishOpen3();
				}else{
					Facade.saveC.startLoadChar(Facade.gameM.playerM,SAVESLOT,false,null,finishOpen3);
				}
			}
		}
		
		public function finishOpen3(){
			if (gameM.playerM.saveSlot==-1){
				new InstantTransition(this,newCUI);
				popRules();
			}else{
				display.update(gameM.playerM);
			}
		}
		
		public function finishOpenLOCKED(){
			display.update(gameM.playerM);
			if (TournamentData.isActive()){
				display.secondaryText("<p align='center'><font color='#22cc22'>QUALIFIED</font></p>");
			}else{
				var _rank:int=TournamentData.getEliminatedPosition();
				if (_rank>0){
					display.secondaryText("Playoffs Rank: #"+_rank+"\n<p align='center'><font color='#ff3300'>ELIMINATED</font></p>");
				}
			}
			

			addChild(statusB);
			addChild(simulateB);
			addChild(duelB);
			/*for (var i:int=0;i<TournamentData.leagueData.length;i+=1){
				for (var j:int=0;j<TournamentData.leagueData[i].length;j+=1){
					if (_kongName==TournamentData.leagueData[i][j][1]){
						if (i==0){
							display.secondaryText(ExhibitionUI.LEAGUE_NAMES[i]+" #"+TournamentData.leagueData[i][j][0].toString()+"\n<p align='center'><font color='#22cc22'>QUALIFIED</font></p>");
							//nextRound=true;
							addChild(statusB);
							addChild(simulateB);
							addChild(duelB);
							//do victory stuff
							return;
						}else{
							display.secondaryText(ExhibitionUI.LEAGUE_NAMES[i]+" #"+TournamentData.leagueData[i][j][0].toString()+"\n<p align='center'><font color='#ff5500'>ELIMINATED</font></p>");
							//nextRound=false;
							addChild(statusB);
							addChild(simulateB);
							addChild(duelB);
							//do eliminated stuff
							return;
						}
					}
				}
			}*/
			//display.clear();
			//new ConfirmWindow("You submit too late to be included in the contest.  Sorry!");
		}
		
		public function muteSound(){
			Facade.soundC.mute=!Facade.soundC.mute;
			soundB.toggled=Facade.soundC.mute;
		}
	}
}