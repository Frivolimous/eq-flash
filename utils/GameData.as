package utils {
	import flash.net.SharedObject;
	import flash.events.Event;
	import flash.display.Sprite;
	import ui.windows.ConfirmWindow;
	import items.ItemData;
	import ui.assets.ScrollAnnounce;
	import items.ItemModel;
	//import tournament.TournamentData;
	import ui.assets.AchievementDisplay;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import hardcore.HardcoreGameControl;
	
	/****************
	HOW TO USE:
	(1) onFinishCheckVersion should be updated with any version related changes
	(2) resetPlayerData should be called when you want to wipe the game
	(3) updateData should be called when you want to update game data to be in line with server data (only at beginning of the game)
	(4) savePlayerData should be called when you want to update the server data to be in line with game data (Saving the Game - see savePlayerData for details)
	****************/
	
	public class GameData {
		public static const VERSION:int=102;
		
		public static const FLAG_TUTORIAL:int=0,
							FLAG_ARTIFACTS:int=1,
							FLAG_MESSAGE:int=2,
							FLAG_GIFT:int=3,
							FLAG_GIFT2:int=4,
							FLAG_TREASURE:int=5,
							FLAG_FREE_PACK:int=6,
							FLAG_CRAFT_MEGA:int=7,
							
							SCORE_KILLS:int=0,
							SCORE_DEATHS:int=1,
							SCORE_DAMAGE:int=2,
							SCORE_FURTHEST:int=3,
							SCORE_TIME:int=4,
							SCORE_CHARS:int=5,
							SCORE_BOOST:int=6,
							SCORE_SUNS:int=7,
							SCORE_SOULS:int=8,
							SCORE_KREDS:int=9,
							SCORE_ASCENDS:int=10,
							SCORE_GOLD:int=11,
							SCORE_REFRESH:int=12,
							SCORE_CLOCKS:int=13,
							SCORE_LEVEL:int=14,
							SCORE_DUEL:int=15,
							SCORE_EPICS:int=16,
							NUM_SCORES:int=17;
							
		public static var _Save:SharedObject=SharedObject.getLocal("OPTIONS");
		public static const PAUSE_TURN:int=0,
							PAUSE_SKIP:int=1,
							AUTO_FILL:int=2,
							FOCUS_CINEMATIC:int=3,
							FOCUS_SIMPLE:int=4,
							PAUSE_BOSS:int=5,
							PAUSE_BOSS_ALL:int=6,
							PAUSE_ITEMS:int=7,
							PAUSE_HEALTH:int=8,
							CURSOR:int=9,
							PAUSE_LEVEL:int=10,
							PAUSE_SKIP_TIMER:int=11,
							OPTION_SUBTITLE:int=12,
							
							SELL_GEM:int=0,
							SELL_NONMAGIC:int=1,
							SELL_MAGIC:int=2,
							SELL_POTION:int=3,
							SELL_GRENADE:int=4,
							SELL_SPELL:int=5,
							SELL_SCROLL:int=6,
							SELL_CHARM:int=7;
														
		public static const ACHIEVEMENTS:String="achievements",
							ARTIFACTS:String="artifacts",
							STASH:String="stash",
							OVERFLOW:String="overflow",
							SCORES:String="scores",
							FLAGS:String="flags",
							LASTCHAR:String="lastChar",
							COSMETICS:String="cosmetics",
							REWARDS:String="rewards",
							TIME:String="lastTime",
							EPICS:String="epics";
							
		public static const HARDCORE:String="Hardcore";
		public static var hardcore:int=0;
		
		public static function setHardcore(i:int){
			if (i>hardcore){
				hardcore=i;
				getHardcoreReward(i);
				saveHardcore();
			}
		}
		public static function saveHardcore(){
			saveThis(HARDCORE);
			pingServer();
		}
		
		public static function getHardcoreReward(_zone:int){
			switch(_zone){
				case 100: addReward(["Congratulations! For reaching Hardcore Zone "+_zone+" you have earned:",[9,5]]); break;
				case 200: addReward(["Congratulations! For reaching Hardcore Zone "+_zone+" you have earned:",[-1,[135,15,-1,2]]]); break;
				case 400: addReward(["Congratulations! For reaching Hardcore Zone "+_zone+" you have earned:",[9,10]]); break;
				case 700: addReward(["Congratulations! For reaching Hardcore Zone "+_zone+" you have earned:",[-1,[135,15,-1,1]]]); break;
				case 1000: addReward(["Congratulations! For reaching Hardcore Zone "+_zone+" you have earned:",[9,15]]); break;
				case 1500: addReward(["Congratulations! For reaching Hardcore Zone "+_zone+" you have earned:",[-1,[135,15,-1,-1]]]); break;
				case 2000: addReward(["Congratulations! For reaching Hardcore Zone "+_zone+" you have earned:",[9,20]]); break;
				case 2500: addReward(["Congratulations! For reaching Hardcore Zone "+_zone+" you have earned:",[-1,[136,15,-1,-1]]]); break;
				case 3000: addReward(["Congratulations! For reaching Hardcore Zone "+_zone+" you have earned:",[9,25]]); break;
				case 4000: addReward(["Congratulations! For reaching Hardcore Zone "+_zone+" you have earned:",[-1,[135,15,5,-1]]]); break;
			}
		}
		//public static var _BUSY:Boolean=false;
		    
    public static var achievements:Array;
		public static var artifacts:Array;
		public static var stash:Array;
		public static var overflow:Array;
		public static var lastChar:int;
		public static var scores:Array; //[0-kills,1-deaths,2-damage,3-furthest,4-time,5-chars::
										 //6-boost,7-suns,8-souls,9-kreds,10-ascends,11-gold,12-refresh,13-clocks]
		public static var flags:Array;
		public static var cosmetics:Array=[[],[],[],[],[],[]];
		public static var lastTime:Number=0;
		public static var rewards:Array=[];
		public static var epics:Array=[0,0]; // [0] = area, [1] = eCount
		public static var zone:Array=[0,0,0,0];
		
		public static function setupZone(i:int,resetProgress:Boolean=true){
			//zone - 0: AreaType, 1: MonsterType, 2: MonsterLevel, 3: ETotal
			setHigherScore(SCORE_EPICS,i);
			epics[0]=i;
			if (resetProgress) epics[1]=0;
			if (i==0 || i==10 || i==25 || i==50 || i==100 || i==200 || i==300 || i==400 || i==1000){
				zone[0]=3;
				zone[1]=3;
			}else{
				zone[0]=Math.floor((i-1)/3)%3;
				zone[1]=(i-1)%3;
			}
			zone[2]=400+(i-1)*10;
			if (i==0){
				zone[3]=0;
			}else{
				zone[3]=7+70*(1-(100/(100+i)));
			}
		}
		
		public static var numCharacters:int=0;
		public static var versionChecked:int=0;
		public static var dataUpdated:int=0;
		
		
		public static var ready:Boolean=false;
		//public static var currentCharacterData:Array;
		public static var loading:Sprite;
		
		
		public static function getScore(i:int):int{
			return scores[i];
		}

		public static function setHigherScore(i:int,value:int){
			if(value>scores[i]){
				if (i == SCORE_LEVEL){
					switch(value){
						case 3: new AchievementDisplay(105); break;
						case 5: new AchievementDisplay(101); break;
						case 8: new AchievementDisplay(102); break;
						case 10: new AchievementDisplay(103); break;
						case 12: new AchievementDisplay(104); break;
					}
				}
				setScore(i,value);
			}
		}
		
		public static function setScore(i:int,value:int){
			AchieveData.checkScore(i,value);
			scores[i]=value;
		}
		
		public static function addScore(i:int,value:int){
			setScore(i,scores[i]+value);
		}
		
		public static function addAscend(){
			scores[SCORE_ASCENDS]+=1;
		}
		
		public static function get boost():int{
			return scores[SCORE_BOOST];
		}
		
		public static function set boost(i:int){
			scores[SCORE_BOOST]=i;
		}
		
		public static function get suns():int{
			return scores[SCORE_SUNS];
		}
		
		public static function set suns(i:int){
			scores[SCORE_SUNS]=i;
		}
		
		public static function get souls():int{
			return scores[SCORE_SOULS];
		}
		
		public static function set souls(i:int){
			scores[SCORE_SOULS]=i;
		}
		
		public static function get kreds():int{
			return scores[SCORE_KREDS];
		}
		
		public static function set kreds(i:int){
			scores[SCORE_KREDS]=i;
		}
		
		public static function get gold():int{
			return scores[SCORE_GOLD];
		}
		
		public static function set gold(i:int){
			scores[SCORE_GOLD]=i;
		}
		
		public static function get refreshes():int{
			return Math.floor(scores[SCORE_REFRESH]/10);
		}
		
		public static function set refreshes(i:int){
			scores[SCORE_REFRESH]=i*10;
		}
		
		public static function addRefresh(){
			scores[SCORE_REFRESH]+=1;
			if (scores[SCORE_REFRESH]>150) scores[SCORE_REFRESH]=150;
		}
		
		public static function get clocks():int{
			return scores[SCORE_CLOCKS];
		}
		
		public static function set clocks(i:int){
			scores[SCORE_CLOCKS]=i;
		}
		
		public static function hasCosmetic(_type:int,index:int):Boolean{
			for (var i:int=0;i<cosmetics[_type].length;i+=1){
				if (cosmetics[_type][i]==index) return true;
			}
			return false;
		}
		
		public static function addCosmetic(_type:int,index:int){
			if (!hasCosmetic(_type,index)){
				cosmetics[_type].push(index);
				saveThis(COSMETICS);
			}
		}
		
		public static function getCosmetics(_type:int):Array{
			return cosmetics[_type];
		}
		
		public static function getFlag(i:int):Boolean{
			return flags[i];
		}
		
		public static function setFlag(i:int,b:Boolean){
			if (b) {
				AchieveData.checkFlag(i);
			}
			flags[i]=b;
			saveThis(FLAGS);
		}
		
		//========= PRINCIPLE FUNCTIONS ==========================
				
		public static function getMaxLevel():int{
			if (AchieveData.hasAchieved(AchieveData.REACH_LEVEL_70)){
				return 70;
			}else{
				return 60;
			}
		}
		
		public static function getCharacterArray(f:Function){
			Facade.steamAPI.retrievePlayerData(["player0","player1","player2","player3","player4"],function (_Data:Object){ finishGetCharacterArray(_Data,f); });
		}
		
		public static function finishGetCharacterArray(_Data:Object,f:Function){
			var a:Array=new Array();
			for (var i:int=0;i<5;i+=1){
				if (_Data["player"+String(i)]!=null){
					a.push(_Data["player"+String(i)]);
				}
			}
			
			f(a);
		}
		
		public static var DELETING:int=0;
		public static function deleteCharacter(i:int,f:Function){
			numCharacters-=1;
			
			for (var j:int=i;j<numCharacters;j+=1){
				DELETING+=1;
				shuffleCharacter(j,j+1);
			}
			
			var doneDeleting:Function=function (e:Event){
				if (!BUSY){
					if (j>0){
						Facade.steamAPI.deletePlayerData(["player"+String(numCharacters)]);
						j=-1;
					}else{
						Facade.stage.removeEventListener(Event.ENTER_FRAME,doneDeleting);
						f();
					}
				}
			}
			
			Facade.stage.addEventListener(Event.ENTER_FRAME,doneDeleting);
		}
		
		public static function shuffleCharacter(_to:int,_from:int){
			loadCharacter(_from,function(a:Array){ saveCharacter(_to,a); DELETING-=1; });
		}
		
		public static function loadCharacter(i:int,f:Function){ //returns a character array to be converted into a character for use in the game
			Facade.steamAPI.retrievePlayerData(["player"+String(i)],function(_Data:Object){
										  if (_Data["player"+String(i)]!=null){
										  	f(_Data["player"+String(i)]);
										  }else{
											  f(null);
										  }
										  });
		}

		public static function saveThese(a:Array){
			for (var i=0;i<a.length;i+=1){
				saveThis(a[i]);
			}
		}
		
		public static function saveThis(s:String){
			var _pair:Array;
			switch(s){
				case ACHIEVEMENTS: _pair=[ACHIEVEMENTS,achievements]; break;
				case ARTIFACTS: _pair=[ARTIFACTS,artifacts]; break;
				case STASH: _pair=[STASH,stash]; break;
				case OVERFLOW: _pair=[OVERFLOW,overflow]; break;
				case SCORES: _pair=[SCORES,scores]; break;
				case FLAGS: _pair=[FLAGS,flags]; break;
				case LASTCHAR: _pair=[LASTCHAR,lastChar]; break;
				case COSMETICS: _pair=[COSMETICS,cosmetics]; break;
				case REWARDS: _pair=[REWARDS,rewards]; break;
				case TIME: _pair=[TIME,lastTime]; break;
				case EPICS: _pair=[EPICS,epics]; break;
				case HARDCORE: _pair=[HARDCORE,hardcore]; break;
			}
			if (_pair!=null){
				Facade.steamAPI.setPlayerProperty(_pair[0],_pair[1]);
			}
		}
		
		public static function saveCharacterJust(_slot:int,a:Array){
			saveCharacter(_slot,a);
		}
		
		public static function saveCharacterGame(_slot:int,a:Array){
			//When you kill an enemy, go to next level or die.
			//You may get an overflow item and scores will be changed for lots of stuff.
			saveCharacter(_slot,a);
			saveThese([OVERFLOW,SCORES]);
			pingServer();
		}
		
		public static function saveCharacterEpics(_slot:int,a:Array){
			//When you kill an enemy, go to the next level or die in EPIC MODE
			//You may get an overflow item and scores will be changed for lots of stuff.
			saveCharacter(_slot,a);
			saveThese([OVERFLOW,SCORES,EPICS]);
		}
		
		public static function saveCharacterDuel(_slot:int,a:Array){
			//from Dueling Arena when you defeat a Challenge Opponent. Save the character AND save scores since you add gold.
			saveCharacter(_slot,a);
			saveThis(SCORES);
			pingServer();
		}
		
		public static function saveCharacterMenu(_slot:int,a:Array){
			saveCharacter(_slot,a);
			saveThese([STASH,OVERFLOW,SCORES,LASTCHAR]);
			pingServer();
		}

		public static function saveCharacterAll(_slot:int,a:Array){
			saveCharacter(_slot,a);
			saveThese([ARTIFACTS,STASH,OVERFLOW,SCORES,LASTCHAR]);
			pingServer();
		}
		
		private static function saveCharacter(_slot:int,a:Array){
				/* This is the only way to save a Character.  Call this when you need to save, Notably:
				/ (4) Transition into Town Menu
				/ (5) Entering or Exiting Prestige Menu, along with Player Data Save
				/ (6) Exiting Status Screen where Stash is enabled, along with Player Data Save
				/ (7) Before you load another character
				/ (8) On Character Creation
				*/
			if (a[0]==null || !(a[0] is String) || (a[0] is String && a[0].length==0)){
				Facade.steamAPI.expiredSession("An error has occurred loading your character.  Please refresh the page to continue.");
				return;
			}
			Facade.steamAPI.setPlayerProperty("player"+String(_slot),a);
		}
		
		private static function saveAllPlayerData(){
				/* This is the only way to save the Player Data.  Call this whenever you need to save the game in the following instances:
				/ (1) Achievement Earned
				/ (2) Entering or Exiting Prestige Menu, along with Character Data Save
				/ (3) Kreds Granted from Failed Purchase
				/ (4) Exiting Status Screen where Stash is enabled, along with Character Data Save
				/ (5) When Tutorial is Complete
				/ (6) When a New Message is read
				/ (7) When you load a character
				/ (8) When scores are updated?  Or just every time you go to Town Menu, just to be safe.
				/
				/ DO NOT need to SavePlayerData during gameplay.
				*/
			saveThese([ACHIEVEMENTS,ARTIFACTS,STASH,OVERFLOW,SCORES,FLAGS,LASTCHAR,COSMETICS]);
		}
		
		
//===============CONSTANTLY RUN======================

		public static function get BUSY():Boolean{
			if (SaveControl.BUSY>0 || Facade.steamAPI.BUSY>0 || DELETING>0){
				return true;
			}
			return false;
		}
		
		public static function set BUSY(b:Boolean){
			//null
		}
		
		public static function checkBusy(e:Event){			
			Facade.steamAPI.submitDataPerTick();
			if (ready && BUSY){
				Facade.stage.addChild(loading);				
			}else{
				if (loading.parent!=null) loading.parent.removeChild(loading);
			}
		}
		
		public static function pingServer(){
			Facade.steamAPI.getTime(getPong);
		}
		
		public static function getPong(_date:Number){
			pongClocks(_date,true);
		}
		
		public static function pingForClocks(){
			Facade.steamAPI.getTime(pongClocks);
		}
		
		public static function pongClocks(_date:Number,_now:Boolean=false){
			Facade.addLine(lastTime+" "+_date);

			if (lastTime==0 || clocks>=500){
				lastTime=_date;
				saveThis(TIME);
				return;
			}

			var _hours:Number = (_date - lastTime) / 1000 / 60 / 60;
			var _score:int=_hours*20;
			lastTime=_date;
			
			if (_hours>=1){
				var _minutes:int=Math.floor((_hours-Math.floor(_hours))*60);
				_hours=Math.floor(_hours);
				
				if (_now){
					var s:String="You were away for "+String(_hours)+" hours and "+String(_minutes)+" minutes";
					s+="- PROGRESS BOOSTS";
					if (clocks+_score>500){
						_score=500-clocks;
						clocks+=_score;
						s+=" +"+String(_score);
						s+="\n You are at max boosts: "+String(clocks);
					}else{
						clocks+=_score;
						s+=" +"+String(_score);
						s+="\n Current boosts: "+String(clocks);
					}
					new ConfirmWindow(s,50,50,null,0,null,3);
					
					saveThis(SCORES);
				}else{
					addReward(["You were away for "+String(_hours)+" hours and "+String(_minutes)+" minutes",[SCORE_CLOCKS,_score]]);
				}
			}

			saveThis(TIME);
			Facade.addLine("Time should be saved: "+TIME+" "+lastTime);
		}
		
		static function addReward(_reward:Array){
			rewards.push(_reward);
			saveThis(REWARDS);
		}
		
		public static function dateToArray(s:String):Array{
			var m:Array=[];
			m.push(s.substr(0,s.indexOf("-")));
			m.push(s.substring(s.indexOf("-")+1,s.lastIndexOf("-")));
			m.push(s.substring(s.lastIndexOf("-")+1,s.indexOf("T")));
			m.push(s.substring(s.indexOf("T")+1,s.indexOf(":")));
			m.push(s.substring(s.indexOf(":")+1,s.lastIndexOf(":")));
			m.push(s.substring(s.lastIndexOf(":")+1,s.indexOf("Z")));
			return m;
		}
		
//=========================INITIALIZATION PROTOCOLS===============================
		public static function init(){
			if (_Save.size==0){
				resetSave();
			}else{
				while(_Save.data.pause.length<13) _Save.data.pause.push(false);
				if (_Save.data.quality==null) _Save.data.quality=2;
				while(_Save.data.sell.length<8) _Save.data.sell.push(false);
				Facade.setQuality(_Save.data.quality);
			}
			Facade.stage.addEventListener(Event.ENTER_FRAME,waiting);

			Facade.steamAPI.init();
			Facade.stage.addEventListener(Event.ENTER_FRAME,waitingSteam);

			Facade.stage.addEventListener(Event.ENTER_FRAME,checkBusy);
			loading=new LoadingOrb;
			loading.x=616.6;
			loading.y=397.35;
			loading.width=loading.height=20;
		}
		
		public static function resetSave(){
			_Save.data.sound=[0.8,0.2];
			_Save.data.pause=[false,false,false,false,false,false,false,false,false,false,false,false,false];
			_Save.data.sell=[false,false,false,false,false,false,false,false];
			_Save.data.quality=2;
		}
		
		public static function waiting(e:Event){
			if (!Facade.steamAPI.connected) return;
						
			if (dataUpdated==0){
				dataUpdated=1;
				updateData();
				return;
			}else if (dataUpdated<2) return;
			
			if (versionChecked<2) return;
			
			ready=true;
			Facade.stage.removeEventListener(Event.ENTER_FRAME,waiting);
		}
		
		public static function waitingSteam(e:Event){
			if (Facade.steamAPI.connected){
				Facade.addLine("Steam Connected!");
				Facade.stage.removeEventListener(Event.ENTER_FRAME,waitingSteam);
			}
		}
		
		public static function updateData(){
			Facade.steamAPI.retrieveAllPlayerData(finishUpdateData);
		}
		
		public static function finishUpdateData(_Data:Object){
			if (_Data.version == null && _Data.firstVersion == null){
				Facade.addLine("New Game!");
				resetPlayerData();
				versionChecked=2;
				dataUpdated=2;
			}else{
				if (_Data.scores==null) {
					scores=new Array(NUM_SCORES);
				}else{
					scores=_Data.scores;
				}
				while (scores.length<NUM_SCORES){
					scores.push(0);
				}
				
				if (_Data.lastChar==null){
					lastChar=0;
				}else{
					lastChar=_Data.lastChar;
				}
				if (_Data.achievements==null){
					achievements=[];
				}else{
					achievements=_Data.achievements;					
				}
				while(achievements.length<AchieveData.NUM_ACHIEVEMENTS){
					achievements.push(false);
				}
				if (_Data.artifacts==null){
					artifacts=new Array(50);
					for (i=0;i<50;i+=1){
						artifacts[i]=-1;
					}
				}
				artifacts=_Data.artifacts;
				if (_Data.stash!=null){
					stash=_Data.stash;
					for (i=0;i<8;i+=1){
						if (stash[i]==null || stash[i].length==0){
							stash[i]=["Shared Stash "+String(i+1),false,new Array(20)];
						}
						if (stash[i].length==1){
							stash[i].push(false);
						}
						if (stash[i].length==2){
							stash[i].push(new Array(20));
						}
					}
				}else{
					stash=new Array(8);
					for (i=0;i<8;i+=1){
						stash[i]=["Shared Stash "+String(i+1),true,new Array(20)];
					}
					stash[0][1]=false;
				}
				if (_Data.overflow==null){
					overflow=[];
				}else{
					overflow=_Data.overflow;
				}
				if (_Data.flags==null){
					flags=[true,false,false,false,false,false,false,false,false];
				}else{
					flags=_Data.flags;
					while (flags.length<9){
						flags.push(false);
					}
				}
				if (_Data.cosmetics==null || _Data.cosmetics.length<6){
					cosmetics=[[],[],[],[],[],[]];
				}else{
					cosmetics=_Data.cosmetics;
					for (i=0;i<cosmetics.length;i+=1){
						for (var j:int=0;j<cosmetics[i].length;j+=1){
							if (cosmetics[i][j]==null){
								cosmetics[i].splice(j,1);
							}
						}
					}
				}
				if (_Data.rewards!=null && _Data.rewards.length>0){
					rewards=_Data.rewards;
				}
				if (_Data.lastTime!=null && _Data.lastTime!=null){
					lastTime=_Data.lastTime;
				}
				
				if (_Data.epics!=null){
					epics=_Data.epics;
				}
				if (_Data.Hardcore!=null){
					hardcore=_Data.Hardcore;
				}
				pingForClocks();
				var _resubmit:Boolean=false;
				for (i=0;i<4;i+=1){
					if (_Data["player"+String(i)]==null && _Data["player"+String(i+1)]!=null){
						_Data["player"+String(i)]=_Data["player"+String(i+1)];
						_Data["player"+String(i+1)]=null;
						_resubmit=true;
					}
				}
				if (_resubmit){
					var m:Object=new Object;
					for (i=0;i<5;i+=1){
						if (_Data["player"+String(i)]==null){
							m["player"+String(i)]=null;
						}else{
							m["player"+String(i)]=_Data["player"+String(i)];
						}
					}
					Facade.steamAPI.submitPlayerData(m);
				}
				
				for (var i:int=4;i>=0;i-=1){
					if (_Data["player"+String(i)]!=null){
						numCharacters=i+1;
						break;
					}
				}
				if (lastChar>=numCharacters){
					lastChar=0;
				}
				
				dataUpdated=2;
				checkVersion(_Data);
			}
		}
		
		public static function checkVersion(_Data:*){
			if (_Data.version==null){
				_version=88;
			}else{
				var _version:int=_Data.version;
			}
			
			var m:Object=new Object;
			var _resubmit:Boolean;
			
			if (_version<VERSION){
				//UPDATES SINCE LAST VERSION
				// if (_version<99){
				// 	if (_Data.Hardcore!=null){
				// 		hardcore=_Data.Hardcore;
				// 		if (hardcore>=0){
				// 			var _rank:int=HardcoreGameControl.getEliminatedPosition();
				// 			if (_rank==1){
				// 				rewards.push(["Congratulations!  Hardcore Challenge has ended!  You have reached Rank #"+_rank+"!",[SCORE_KREDS,30],[-1,[119,1,-1,_rank]],[-1,[136,15,-1,-1]],[-1,[135,15,2,-1]],[-1,[135,15,3,1]]]);
				// 			}else if (_rank==2){
				// 				rewards.push(["Congratulations!  Hardcore Challenge has ended!  You have reached Rank #"+_rank+"!",[SCORE_KREDS,25],[-1,[119,1,-1,_rank]],[-1,[135,15,2,-1]],[-1,[135,15,2,1]]]);
				// 			}else if (_rank==3){
				// 				rewards.push(["Congratulations!  Hardcore Challenge has ended!  You have reached Rank #"+_rank+"!",[SCORE_KREDS,20],[-1,[119,1,-1,_rank]],[-1,[135,15,-1,-1]],[-1,[135,15,2,1]]]);
				// 			}else if (_rank<=10){
				// 				rewards.push(["Congratulations!  Hardcore Challenge has ended!  You have reached Rank #"+_rank+"!",[-1,[119,1,-1,_rank]],[-1,[135,15,2,1]]]);
				// 			}else if (_rank<=25){
				// 				rewards.push(["Congratulations!  Hardcore Challenge has ended!  You have reached Rank #"+_rank+"!",[-1,[119,1,-1,_rank]],[-1,[135,15,-1,1]]]);
				// 			}else if (_rank<=50){
				// 				rewards.push(["Congratulations!  Hardcore Challenge has ended!  You have reached Rank #"+_rank+"!",[-1,[118,1,-1,-1]],[-1,[135,15,-1,2]]]);
				// 			}else{
				// 				rewards.push(["Congratulations!  Hardcore Challenge has ended!  Thank you for participating!",[-1,[118,1,-1,-1]]]);
				// 			}
				// 		}
				// 	}
				// }
				
				// if (_version<100){
				// 	_resubmit=true;
				// 	m["player-100"]=null;
				// 	hardcore=0;
				// Facade.steamAPI.setPlayerProperty(HARDCORE,hardcore);
				// 	_Save=SharedObject.getLocal("HC_OPTIONS");
				// 	resetSave();
				// 	_Save=SharedObject.getLocal("OPTIONS");
				// }
				if (_resubmit) Facade.steamAPI.submitPlayerData(m);
				
				new ScrollAnnounce(getVersionLog());
				Facade.addLine("Version "+_version.toString()+" is not current, updating now...");
				Facade.steamAPI.setPlayerProperty("version",VERSION);
				saveAllPlayerData();
			}else{
				Facade.addLine("Version "+_version.toString()+" is Current");
			}
			versionChecked=2;
		}
		
		/*
		Rewards:
		[["Replace Lost Item and Gift of Boosts",[-1,[39,15,-1,-1,0]],[6,500]]];
		*/
		public static function getFirstReward():Boolean{
			if (rewards==null) return false;
			
			while(rewards.length>0 && rewards[0]==null){
				rewards.shift();
			}
			if (rewards.length>0 && rewards[0]!=null){
				var s:String=rewards[0][0];
				for (var i:int=1; i<rewards[0].length;i+=1){
					if (rewards[0][i][0]>=0){
						
						
						s+="\n - "
						switch(rewards[0][i][0]){
							case SCORE_BOOST: s+="BOOSTS"; break;
							case SCORE_SUNS: s+="SUNS"; break;
							case SCORE_SOULS: s+="SOUL POWER"; break;
							case SCORE_KREDS: s+="POWER TOKENS"; break;
							case SCORE_GOLD: s+="GOLD"; break;
							case SCORE_REFRESH: s+="REFRESH"; break;
							case SCORE_CLOCKS:
								s+="PROGRESS BOOSTS";
								if ((clocks+rewards[0][i][1])>500) {
									rewards[0][i][1]=500-clocks;
									clocks+=rewards[0][i][1];
									s+=" +"+rewards[0][i][1].toString();
									s+="\n You are at max boosts: "+String(clocks);
									new ConfirmWindow(s,50,50,null,0,null,3);
									rewards.shift();
									return true;
								}
								
								break;
						}
						
						scores[rewards[0][i][0]]+=rewards[0][i][1];
						s+=" +"+rewards[0][i][1].toString();
					}else if (rewards[0][i][0]==-1){
						var _item:ItemModel=ItemModel.importArray(rewards[0][i][1]);
						Facade.gameM.addOverflowItem(_item);
						s+="\n - "+_item.name+" added to Overflow";
					}else if (rewards[0][i][0]==-2){
						resetSave();
						s+="\n - Local Option Save Reset";
					}
				}
				new ConfirmWindow(s,50,50,null,0,null,3);
				rewards.shift();
				
				return true;
			}else{
				return false;
			}
		}
		
		public static function getAnnounceText():String{
			var m:String="";
			m+="<p align='center'><font size='25'>Version Updates</font></p>\nThis probably won't change very much, since this is just a STEAM REVIVAL of an old flash game. But here you go, update notes!\n\n";
			m+="\n\n"
			m+=getVersionLog();
			return m;
		}
		
		public static function getVersionLog(_numBack:int=10):String{
			var m:String="";
			var i:int=0;
			m+="<b>Steam Release Update 102</b>\nThe game is finally updated, and released on STEAM! It has been 9 years since the final FLASH update\nI hope you enjoy the game, and if we get a bunch of players I'll do more updates!.";
			i+=1;
			if (i>=_numBack) return m;
			// m+="\n\n";
			// m+="<b>Warrior Challenge Update 100</b>- Warrior Challenge Event is now Released!\n- Enemy Damage Dealt is now significantly reduced from z1000+\n- New z1000 Shadow Boss, including one-time reward and farmable reward.\n- Enemy Resistances now only scale up to 90% and the scaling values are slightly modified each level.\n- Certain other runaway stats will be capped.";
			// i+=1;
			// if (i>=_numBack) return m;


			return m;
		}
		
		public static function resetPlayerData(){ //Populate the player data with brand new game data.  Call on initial launch with no export and data wipe.
			artifacts=new Array(50);
			for (var i:int=0;i<artifacts.length;i+=1){
				artifacts[i]=-1;
			}
			stash=new Array(8);
			for (i=0;i<8;i+=1){
				stash[i]=["Shared Stash "+String(i+1),false,new Array(20)];
			}
			stash[0][1]=false;
			overflow=[];
			numCharacters=0;
			lastChar=0;
			cosmetics=[[],[],[],[],[],[]]
			scores=new Array(NUM_SCORES);
			for (i=0;i<scores.length;i+=1){
				scores[i]=0;
			}
			flags=[false,false,false,false,false,false,false,false,false];
			achievements=[];
			while(achievements.length<AchieveData.NUM_ACHIEVEMENTS){
				achievements.push(false);
			}
			saveThese([COSMETICS,ACHIEVEMENTS,FLAGS,ARTIFACTS,STASH,OVERFLOW,SCORES,LASTCHAR]);
			Facade.steamAPI.setPlayerProperties([["version",VERSION],["firstVersion",VERSION],
							 ["player0",null],["player1",null],["player2",null],["player3",null],["player4",null]]);
		}
	}
}
