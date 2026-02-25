package utils {
	import flash.net.SharedObject;
	import flash.events.Event;
	import flash.display.Sprite;
	import ui.windows.ConfirmWindow;
	import items.ItemData;
	import ui.assets.ScrollAnnounce;
	import items.ItemModel;
	//import tournament.TournamentData;
	import sprites.BallHead;
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
							SCORE_CLOCKS:int=13;
							
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
							
		public static const ACHIEVE_DEFT:int=0,
							ACHIEVE_CLEVER:int=1,
							ACHIEVE_UNGIFTED:int=2,
							ACHIEVE_STUDIOUS:int=3,
							ACHIEVE_ENLIGHTENED:int=4,
							ACHIEVE_POWERFUL:int=5,
							ACHIEVE_HOLY:int=6,
							ACHIEVE_WILD:int=7,
							ACHIEVE_NOBLE:int=8,
							// ACHIEVE_TURBO:int=9,
							ACHIEVE_ACOLYTE:int=10,
							ACHIEVE_PALADIN:int=11,
							ACHIEVE_ORDINARY_COSMO:int=12,
							ACHIEVE_DEFT_COSMO:int=13,
							ACHIEVE_CLEVER_COSMO:int=14,
							ACHIEVE_UNGIFTED_COSMO:int=15,
							ACHIEVE_STUDIOUS_COSMO:int=16,
							ACHIEVE_ENLIGHTENED_COSMO:int=17,
							ACHIEVE_POWERFUL_COSMO:int=18,
							ACHIEVE_HOLY_COSMO:int=19,
							ACHIEVE_WILD_COSMO:int=20,
							ACHIEVE_NOBLE_COSMO:int=21,
							ACHIEVE_ASCEND_50:int=22,
							ACHIEVE_ROGUE:int=23,
							ACHIEVE_FORGE:int=24,
							ACHIEVE_EPIC:int=25,
							ACHIEVE_BERSERKER:int=26,
							ACHIEVE_LEVEL_70:int=27;
							
		public static const ACHIEVEMENTS:String="achievements",
							ARTIFACTS:String="artifacts",
							STASH:String="stash",
							OVERFLOW:String="overflow",
							SCORES:String="scores",
							FLAGS:String="flags",
							LASTCHAR:String="lastChar",
							COSMETICS:String="cosmetics",
							REWARDS:String="rewards",
							TIME:String="LastTime",
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
			Facade.steamAPI.submitHighscoreScript(hardcore);
			submitDataQueue([[HARDCORE,hardcore]]);
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
		
		public static var artifacts:Array;
		public static var stash:Array;
		public static var overflow:Array;
		public static var lastChar:int;
		private static var achievements:Array;
		private static var scores:Array; //[0-kills,1-deaths,2-damage,3-furthest,4-time,5-chars::
										 //6-boost,7-suns,8-souls,9-kreds,10-ascends,11-gold,12-refresh,13-clocks]
		private static var flags:Array;
		private static var cosmetics:Array=[[],[],[],[],[],[]];
		private static var lastTime:String;
		private static var rewards:Array=[];
		public static var epics:Array=[0,0]; // [0] = area, [1] = eCount
		public static var zone:Array=[0,0,0,0];
		
		public static function setupZone(i:int,resetProgress:Boolean=true){
			//zone - 0: AreaType, 1: MonsterType, 2: MonsterLevel, 3: ETotal
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
		
		public static function setScore(i:int,value:int){
			scores[i]=value;
		}
		
		public static function addScore(i:int,value:int){
			scores[i]+=value;
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
			flags[i]=b;
			saveThis(FLAGS);
		}
		
		//========= PRINCIPLE FUNCTIONS ==========================
		
		public static function achieve(i:int){
			if (i==313){
				for (var j:int=0;j<28;j+=1){
					if (!achievements[j]){
						achievements[j]=true;
						new AchievementDisplay(i);
					}
				}
				return;
			}
			
			if (!achievements[i]){
				new AchievementDisplay(i);
				achievements[i]=true;
				if (i>=ACHIEVE_ORDINARY_COSMO && i<=ACHIEVE_NOBLE_COSMO){
					i-=ACHIEVE_ORDINARY_COSMO;
					sprites.BallHead.setTalentCosmetics(cosmetics,i);
					saveThis(COSMETICS);
				}else if (i==ACHIEVE_ASCEND_50){
					cosmetics[4].push(BallHead.DARK_HALO);
					saveThis(COSMETICS);
				}
				saveThis(ACHIEVEMENTS);
			}
		}
		
		public static function hasAchieved(i:int):Boolean{
			return achievements[i];
		}
		
		public static function maxLevel(_v:SpriteModel){
			if (_v.level>=60){
				achieve(_v.skillBlock.getTalentIndex()+ACHIEVE_ORDINARY_COSMO);
			}
		}
		
		public static function getMaxLevel():int{
			if (hasAchieved(ACHIEVE_LEVEL_70)){
				return 70;
			}else{
				return 60;
			}
		}
		
		public static function checkArenaSubmit(f:Function){
			Facade.steamAPI.retrievePlayerData(["T1Submit"],function (_Data:Object){ f(_Data.T1Submit==null?false:_Data.T1Submit.Value) });
		}
		
		public static function getCharacterArray(f:Function){
			Facade.steamAPI.retrievePlayerData(["player0","player1","player2","player3","player4"],function (_Data:Object){ finishGetCharacterArray(_Data,f); });
		}
		
		public static function finishGetCharacterArray(_Data:Object,f:Function){
			var a:Array=new Array();
			for (var i:int=0;i<5;i+=1){
				if (_Data["player"+String(i)]!=null){
					a.push(stringToArray(_Data["player"+String(i)].Value));
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
										  	f(stringToArray(_Data["player"+String(i)].Value));
										  }else{
											  f(null);
										  }
										  });
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
			}
			if (_pair!=null){
				submitDataQueue([_pair]);
			}
		}
		
		public static function saveCharacterJust(_slot:int,a:Array,_override:Boolean=false){
			saveCharacter(_slot,a,_override);
		}
		
		public static function saveCharacterGame(_slot:int,a:Array){
			//When you kill an enemy, go to next level or die.
			//You may get an overflow item and scores will be changed for lots of stuff.
			saveCharacter(_slot,a);
			submitDataQueue([[OVERFLOW,overflow],[SCORES,scores]]);
			pingServer();
		}
		
		public static function saveCharacterEpics(_slot:int,a:Array){
			//When you kill an enemy, go to the next level or die in EPIC MODE
			//You may get an overflow item and scores will be changed for lots of stuff.
			saveCharacter(_slot,a);
			submitDataQueue([[OVERFLOW,overflow],[SCORES,scores],[EPICS,epics]]);
		}
		
		public static function saveCharacterDuel(_slot:int,a:Array){
			//from Dueling Arena when you defeat a Challenge Opponent. Save the character AND save scores since you add gold.
			saveCharacter(_slot,a);
			saveThis(SCORES);
			pingServer();
		}
		
		public static function saveCharacterMenu(_slot:int,a:Array){
			saveCharacter(_slot,a);
			submitDataQueue([[STASH,stash],[OVERFLOW,overflow],[SCORES,scores],[LASTCHAR,lastChar]]);
			pingServer();
		}
		
		public static function saveCharacterPrestige(_slot:int,a:Array){
			//before and after you prestige, save this
			saveCharacter(_slot,a);
			submitDataQueue[[ARTIFACTS,artifacts],[SCORES,scores]];
			pingServer();
		}
		
		public static function saveCharacterAll(_slot:int,a:Array){
			saveCharacter(_slot,a);
			submitDataQueue([[ARTIFACTS,artifacts],[STASH,stash],[OVERFLOW,overflow],[SCORES,scores],[LASTCHAR,lastChar]]);
			pingServer();
		}
		
		private static function saveCharacter(_slot:int,a:Array,_override:Boolean=false){
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
			submitDataQueue([["player"+String(_slot),a]],_override);
		}
		
		private static function saveAllPlayerData(_override:Boolean=false){
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
			submitDataQueue([[ACHIEVEMENTS,achievements],[ARTIFACTS,artifacts],[STASH,stash],[OVERFLOW,overflow],[SCORES,scores],
							[FLAGS,flags],[LASTCHAR,lastChar],[COSMETICS,cosmetics]],_override);
		}
		
		
//===============CONSTANTLY RUN======================

		public static function get BUSY():Boolean{
			if (SaveControl.BUSY>0 || queue.length>0 || DELETING>0){
				return true;
			}
			return false;
		}
		
		public static function set BUSY(b:Boolean){
			//null
		}
		
		static var timerExpired:int=0;
		public static function checkBusy(e:Event){			
			submitDataPerTick();
			if (ready && BUSY){
				//BUSY=true;
				Facade.stage.addChild(loading);
				timerExpired+=1;
				if (timerExpired>1000) {
					Facade.steamAPI.expiredSession("A save request has taken much longer than expected causing a fatal error.  Please refresh your browser to continue.");
				}
				
			}else{
				//BUSY=false;
				if (loading.parent!=null) loading.parent.removeChild(loading);
				timerExpired=0;
			}
		}
		
		public static function pingServer(){
			Facade.steamAPI.getTime(getPong);
		}
		
		public static function getPong(_date:String){
			pongClocks(_date,true);
			//lastTime=_date;
			//submitDataQueue([["LastTime",_date]]);
		}
		
		public static function pingForClocks(){
			Facade.steamAPI.getTime(pongClocks);
		}
		
		public static function pongClocks(_date:String,_now:Boolean=false){
			if (lastTime==null || clocks>=500){
				lastTime=_date;
				return;
			}
			var _hours:Number=compareTimes(_date,lastTime);
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
					
					saveThis(TIME);
					saveThis(SCORES);
				}else{
					addReward(["You were away for "+String(_hours)+" hours and "+String(_minutes)+" minutes",[SCORE_CLOCKS,_score]]);
					saveThis(TIME);
				}
			}else{
				saveThis(TIME);
			}
			
			//new ConfirmWindow("  You now have a total of "+String(clocks)+"Offline Progress Boosts!",50,50,null,0,null,3);
		}
		
		static function addReward(_reward:Array){
			rewards.push(_reward);
			saveThis(REWARDS);
		}
		
		public static function compareTimes(_current:String,_previous:String):Number{
			var _cA:Array=dateToArray(_current);
			var _pA:Array=dateToArray(_previous);
			var currentTime:Number=Date.UTC(_cA[0],_cA[1],_cA[2],_cA[3],_cA[4],_cA[5]);
			var previousTime:Number=Date.UTC(_pA[0],_pA[1],_pA[2],_pA[3],_pA[4],_pA[5]);
			return (currentTime-previousTime)/1000/60/60;
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
				if (_Data.scores==null){
					scores=[0,0,0,0,0,0,0,0,0,0,0,0,0,0];
				}else{
					scores=stringToValue(_Data.scores.Value);
					while (scores.length<14){
						scores.push(0);
					}
				}
				if (_Data.lastChar==null){
					lastChar=0;
				}else{
					lastChar=stringToValue(_Data.lastChar.Value);
				}
				if (_Data.achievements==null){
					achievements=[];
				}else{
					achievements=stringToValue(_Data.achievements.Value);					
				}
				while(achievements.length<28){
					achievements.push(false);
				}
				
				if (_Data.artifacts==null){
					artifacts=new Array(50);
					for (i=0;i<50;i+=1){
						artifacts[i]=-1;
					}
				}
					artifacts=stringToValue(_Data.artifacts.Value);
					
				if (_Data.stash!=null){
					stash=stringToValue(_Data.stash.Value);
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
					overflow=stringToValue(_Data.overflow.Value);
				}
				if (_Data.flags==null){
					flags=[true,false,false,false,false,false,false,false,false];
				}else{
					flags=stringToValue(_Data.flags.Value);
					while (flags.length<9){
						flags.push(false);
					}
				}
				if (_Data.cosmetics==null || _Data.cosmetics.Value.length<6){
					cosmetics=[[],[],[],[],[],[]];
				}else{
					cosmetics=stringToValue(_Data.cosmetics.Value);
					for (i=0;i<cosmetics.length;i+=1){
						for (var j:int=0;j<cosmetics[i].length;j+=1){
							if (cosmetics[i][j]==null){
								cosmetics[i].splice(j,1);
							}
						}
					}
				}
				
				if (_Data.rewards!=null && _Data.rewards.Value.length>0){
					rewards=stringToArray(_Data.rewards.Value);
				}
				
				if (_Data.LastTime!=null){
					lastTime=_Data.LastTime.Value;
				}
				
				if (_Data.epics!=null){
					epics=stringToArray(_Data.epics.Value);
				}
				
				if (_Data.Hardcore!=null){
					hardcore=_Data.Hardcore.Value;
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
							m["player"+String(i)]=_Data["player"+String(i)].Value;
						}
					}
					Facade.steamAPI.submitPlayerData(m,true);
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
				var _version:int=stringToValue(_Data.version.Value);
			}
			
			var m:Object=new Object;
			var _resubmit:Boolean;
			
			if (_version<VERSION){
				//UPDATES SINCE LAST VERSION
				// if (_version<99){
				// 	if (_Data.Hardcore!=null){
				// 		hardcore=_Data.Hardcore.Value;
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
				// 	submitDataQueue([[HARDCORE,hardcore]]);
				// 	achievements[ACHIEVE_LEVEL_70]=false;
				// 	_Save=SharedObject.getLocal("HC_OPTIONS");
				// 	resetSave();
				// 	_Save=SharedObject.getLocal("OPTIONS");
				// }
				if (_resubmit) Facade.steamAPI.submitPlayerData(m,true);
				
				new ScrollAnnounce(getVersionLog());
				Facade.addLine("Version "+_version.toString()+" is not current, updating now...");
				submitDataQueue([["version",VERSION]],true);
				saveAllPlayerData(true);
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
			scores=new Array(14);
			for (i=0;i<scores.length;i+=1){
				scores[i]=0;
			}
			flags=[false,false,false,false,false,false,false,false,false];
			achievements=[];
			while(achievements.length<23){
				achievements.push(false);
			}
			submitDataQueue([["version",VERSION],["firstVersion",VERSION],
							 ["cosmetics",cosmetics],["achievements",achievements], ["flags",flags],["artifacts",artifacts],["stash",stash],["overflow",overflow],["scores",scores],["lastChar",lastChar],
							 ["player0",null],["player1",null],["player2",null],["player3",null],["player4",null]],true);
							 
			//RESET CHARACTER DATA AS WELL
		}
		
//============================SUBFUNCS=======================
		
		public static function submitDataQueue(_queue:Array,_override:Boolean=false){
			timerExpired=0;
			if (_override){
				while(_queue.length>0){
					var i:int=0;
					while(i<overQueue.length){
						if (overQueue[i][0]==_queue[0][0]){
							overQueue.splice(i,1);
						}else{
							i+=1;
						}
					}
					overQueue.push(_queue.shift());
				}
				//overQueue=overQueue.concat(_queue);
			}else{
				while(_queue.length>0){
					i=0;
					while(i<queue.length){
						if (queue[i][0]==_queue[0][0]){
							queue.splice(i,1);
						}else{
							i+=1;
						}
					}
					if (_queue[0][1] is Array){
						_queue[0][1]=(_queue[0][1] as Array).concat();
					}
					queue.push(_queue.shift());
				}
				//queue=queue.concat(_queue);
			}
		}
		
		public static var queue:Array=new Array;
		public static var overQueue:Array=new Array;
		public static var delay:int=0;
		public static const DELAY:int=40;
		public static function submitDataPerTick(){
			if (delay>0){
				delay-=1;
				return;
			}
			
			if (overQueue.length>0){
				m=new Object;
				for (var i:int=0;(i<10 && overQueue.length>0);i+=1){
					var _pair:Array=overQueue.shift();
					m[_pair[0]]=valueToJSON(_pair[1]);
				}
				Facade.steamAPI.submitPlayerData(m,true);
				delay=DELAY;
			}else if (queue.length>0){
				var m:Object=new Object;
				for (i=0;(i<10 && queue.length>0);i+=1){
					_pair=queue.shift();
					m[_pair[0]]=valueToJSON(_pair[1]);
				}
				Facade.steamAPI.submitPlayerData(m,false);
				delay=DELAY;
			}
		}
		
		public static function valueToJSON(v:*):*{
			if (v is int || v is String || v is Boolean){
				return v;
			}else if (v is Array){
				return arrayToString(v);
			}else{
				return null;
			}
		}
		
		public static function stringToValue(s:String):*{
			if (s=="true"){
				return true;
			}else if (s=="false"){
				return false;
			}else if (s.search(/\d/)==0 || s.substr(0,1)=="-"){
				return Number(s);
			}else if (s.charAt(0)=="["){
				return stringToArray(s);
			}else{
				return s;
			}
		}
		
		public static function arrayToString(a:Array,_incNull:Boolean=false):String{
			var m:String="[";
			for (var i:int=0;i<a.length;i+=1){
				if (a[i] is Array){
					m+=arrayToString(a[i],_incNull);
				}else if (_incNull){
					if (a[i]==null){
						m+="null";
					}else if (a[i] is String){
						m+='"'+String(a[i])+'"';
					}else{
						m+=String(a[i]);
					}
				}else if (a[i]!=null){
					m+=String(a[i]);
				}
				if (i<a.length-1){
					m+=",";
				}
			}
			
			m+="]";
			return m;
		}
				
		public static function stringToArray(s:String):*{
			var m:Array=new Array;
			//var j:*=JSON.parse("{a:"+s+"}");
			s=s.substring(1);
			
			while(s.length>0){
				if (s.charAt(0)=="["){
					var i:int=1;
					char=0
					var r:int=0;
					s2=s;
					while (i>0){
						var s2:String=s2.substring(char+1);
						r+=char+1;
						char=s2.search(/(\[|\])/);
						if (s.charAt(char+r)=="["){
							i+=1;
						}else{
							i-=1;
						}
					}
					m.push(stringToArray(s.substring(0,char+r+1)));
					s=s.substring(char+r+2);
					
				}else{
					var char:int=s.indexOf(",");
					if (char==-1){
						char=s.indexOf("]");
						if (char==0){
							m.push(null);
						}else{
							m.push(stringToValue(s.substring(0,char)));
						}
						s="";
					}else{
						if (char==0){
							m.push(null);
							s=s.substring(1);
						}else{
							m.push(stringToValue(s.substring(0,char)));
							s=s.substring(char+1);
						}
					}
				}
			}
			return m;
		}
	}
}
