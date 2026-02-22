package utils {
	import flash.net.SharedObject;
	import flash.events.Event;
	import flash.display.Sprite;
	import ui.windows.ConfirmWindow;
	import items.ItemData;
	import ui.assets.ScrollAnnounce;
	import ui.assets.PopBundles;
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
		public static const VERSION:int=101;
		
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
							ACHIEVE_TURBO:int=9,
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
			PlayfabAPI.submitHighscoreScript(hardcore);
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
		public static var epics:Array=[0,0];
		public static var zone:Array=[0,0,0,0];
		
		public static function setupZone(i:int,resetProgress:Boolean=true){
			//0: AreaType, 1: MonsterType, 2: MonsterLevel, 3: ETotal
			epics[0]=i;
			if (resetProgress) epics[1]=0;
			if (i==0 || i==10 || i==25 || i==50 || i==100 || i==200 || i==300 || i==400 || i==1000){
				zone[0]=3;
				zone[1]=3;
			}else{
				zone[0]=Math.floor((i-1)/3)%3;
				zone[1]=(i-1)%3;
			}
			zone[2]=400+i*10;
			if (i==0){
				zone[3]=0;
			}else{
				zone[3]=7+70*(1-(100/(100+i)));
			}
		}
		
		public static var numCharacters:int=0;
		public static var oldSaveChecked:int=0;
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
			if (scores[SCORE_REFRESH]>100) scores[SCORE_REFRESH]=100;
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
				for (var j:int=0;j<10;j+=1){
					if (!achievements[j]){
						achievements[j]=true;
						new AchievementDisplay(i);
					}
				}
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
			PlayfabAPI.retrievePlayerData(["T1Submit"],function (_Data:Object){ f(_Data.T1Submit==null?false:_Data.T1Submit.Value) });
		}
		
		public static function getCharacterArray(f:Function){
			PlayfabAPI.retrievePlayerData(["player0","player1","player2","player3","player4"],function (_Data:Object){ finishGetCharacterArray(_Data,f); });
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
						PlayfabAPI.deletePlayerData(["player"+String(numCharacters)]);
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
			PlayfabAPI.retrievePlayerData(["player"+String(i)],function(_Data:Object){
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
				PlayfabAPI.expiredSession();
				PlayfabAPI.expiredMC.display.text="There was an issue saving your character.  Please refresh the game to continue.";
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
			if (SaveControl.BUSY>0 || queue.length>0 || PlayfabAPI.SUBMITTING>0 || DELETING>0){
				return true;
			}
			return false;
		}
		
		public static function set BUSY(b:Boolean){
			//null
		}
		
		static var timerExpired:int=0;
		public static function checkBusy(e:Event){
			if (PlayfabAPI.expired) return;
			
			submitDataPerTick();
			if (ready && BUSY){
				//BUSY=true;
				Facade.stage.addChild(loading);
				timerExpired+=1;
				if (timerExpired>1000) {
					PlayfabAPI.expiredSession();
					PlayfabAPI.expiredMC.display.text="A save request has taken much longer than expected causing a fatal error.  Please refresh your browser to continue.";
				}
				
			}else{
				//BUSY=false;
				if (loading.parent!=null) loading.parent.removeChild(loading);
				timerExpired=0;
			}
		}
		
		public static function pingServer(){
			PlayfabAPI.getTime(getPong);
		}
		
		public static function getPong(_date:String){
			pongClocks(_date,true);
			//lastTime=_date;
			//submitDataQueue([["LastTime",_date]]);
		}
		
		public static function pingForClocks(){
			PlayfabAPI.getTime(pongClocks);
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
			if (!KongregateAPI.upload){
				PlayfabAPI.initNoKong();
				Facade.stage.addEventListener(Event.ENTER_FRAME,waitingPlayfab);
			}else{
				KongregateAPI.init();
				Facade.stage.addEventListener(Event.ENTER_FRAME,waitingKong);
			}
			Facade.stage.addEventListener(Event.ENTER_FRAME,checkBusy);
			loading=new LoadingOrb;
			/*loading.x=578;
			loading.y=325;
			loading.width=loading.height=41;*/
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
			if (PlayfabAPI.SUBMITTING>0) return;
			if (!KongregateAPI.connected && KongregateAPI.upload) return;
			if (!PlayfabAPI.connected) return;
			
			if (oldSaveChecked==0){
				oldSaveChecked=1;
				getOldSave();
				return;
			}else if (oldSaveChecked<2) return;
			
			if (dataUpdated==0){
				dataUpdated=1;
				updateData();
				return;
			}else if (dataUpdated<2) return;
			
			if (versionChecked<2) return;
			
			ready=true;
			KongregateAPI.postConnection();
			Facade.stage.removeEventListener(Event.ENTER_FRAME,waiting);
		}
		
		public static function waitingKong(e:Event){
			if (KongregateAPI.connected){
				if (!KongregateAPI.upload){
					Facade.addLine("Offline Mode Enabled");
					PlayfabAPI.initNoKong();
				}else{
					Facade.addLine("Kong Connected! Trying Playfab...");
					PlayfabAPI.init();
				}
				Facade.stage.removeEventListener(Event.ENTER_FRAME,waitingKong);
				Facade.stage.addEventListener(Event.ENTER_FRAME,waitingPlayfab);
			}
		}
		
		public static function waitingPlayfab(e:Event){
			if (PlayfabAPI.connected){
				Facade.addLine("Playfab Connected!");
				Facade.stage.removeEventListener(Event.ENTER_FRAME,waitingPlayfab);
			}
		}
		
		public static function updateData(){
			PlayfabAPI.retrieveAllPlayerData(finishUpdateData);
		}
		
		public static function finishUpdateData(_Data:Object){
			if (_Data.logins==null){
				PlayfabAPI.loginCount=1;
			}else{
				PlayfabAPI.loginCount=int(_Data.logins.Value)+1;
			}
			submitDataQueue([["logins",PlayfabAPI.loginCount]],true);
		
			if (_Data.version == null && _Data.firstVersion == null){
				Facade.addLine("New Game!");
				resetPlayerData();
				versionChecked=2;
				dataUpdated=2;
			}else{				
				if (_Data.DevMode) KongregateAPI.disabled=true;
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
							stash[i]=["Shared Stash "+String(i+1),true,new Array(20)];
						}
						if (stash[i].length==1){
							stash[i].push(true);
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
					flags=[true,false,true,false,false,false,false,false,false];
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
					PlayfabAPI.submitPlayerData(m,true);
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
				if (_version<=40){
					flags=[stringToValue(_Data.tutorialComplete.Value),false,stringToValue(_Data.newMessage.Value),false];
					scores=scores.concat([_Data.boost!=null?stringToValue(_Data.boost.Value):0,_Data.suns!=null?stringToValue(_Data.suns.Value):0,
										  stringToValue(_Data.souls.Value),stringToValue(_Data.kreds.Value),0]);
					PlayfabAPI.deletePlayerData(["boost","kreds","newMessage","souls","suns","tutorialComplete"]);
				}
				/*if (_version<=41){
					options=[0.8,0.2,false,false,false,false,false,false,false];
				}*/
				
				if (_version<43){
					var _artBoost:int=0;
					for (var i:int=0;i<artifacts.length;i+=1){
						if (artifacts[i]>_artBoost-1) _artBoost=artifacts[i]+1
					}
					scores[SCORE_ASCENDS]=_artBoost;
				}
				
				if (_version<45){
					scores[SCORE_GOLD]=0;
					for (i=0;i<5;i+=1){
						if (_Data["player"+String(i)]!=null){
							scores[SCORE_GOLD]+=stringToArray(_Data["player"+String(i)].Value)[7];
						}
					}
				}
				if (_version<46){
					_Save.data.pause=[false,false,false,false,false,false,false,false,false,true,false,false,false];
				}
				
				if (_version<55){
					_resubmit=true;
					if (_Data.firstVersion!=null && _Data.firstVersion.Value<39){
						cosmetics=[[],[],[],[],[],[1]];
					}else{
						cosmetics=[[],[],[],[],[],[]];
					}
					for (i=0;i<5;i+=1){
						if (_Data["player"+String(i)]==null){
							m["player"+String(i)]=null;
						}else{
							var _player:Array=stringToArray(_Data["player"+String(i)].Value);
							
							for (var j:int=25;j<35;j+=1){
								_player[5][j]=0;
							}
							_player[4]=[true,true,true,true,true,false,false];
							_player[20]=[-1,-1,-1,-1,-1,-1];
							_player[21]=0;
							m["player"+String(i)]=arrayToString(_player);
						}
					}
				}
				
				if (_version<56){
					if (scores[SCORE_FURTHEST]>200) achieve(ACHIEVE_ACOLYTE);
					if (scores[SCORE_FURTHEST]>300) achieve(ACHIEVE_PALADIN);
				}
				
				if (_version<59){
					_Save.data.sell=[false,false,false,false,false,false,false,false];
				}
				
				if (_version<60){
					/*if (_Data.T1Submit!=null){
						if (TournamentData.isEliminated()){
							var _rank:int=TournamentData.getEliminatedPosition();
							if (_rank==1){
								rewards.push(["Congratulations!  Season 1 Tournament has ended!\n\nTournament Reward: Rank #"+String(_rank)+"\n\n - Create Your Own Arena Champion! (ThePeasant will contact you with details).",[SCORE_SOULS,5000],[SCORE_KREDS,100],[-1,[119,1,-1,_rank,0]]]);
							}else if (_rank==2){
								rewards.push(["Congratulations!  Season 1 Tournament has ended!\n\nTournament Reward: Rank #"+String(_rank)+"\n\n - Create Your Own Arena Champion! (ThePeasant will contact you with details).",[SCORE_SOULS,4000],[SCORE_KREDS,50],[-1,[119,1,-1,_rank,0]]]);
							}else if (_rank==3){
								rewards.push(["Congratulations!  Season 1 Tournament has ended!\n\nTournament Reward: Rank #"+String(_rank)+"\n\n - Create Your Own Arena Champion! (ThePeasant will contact you with details).",[SCORE_SOULS,3000],[SCORE_KREDS,20],[-1,[119,1,-1,_rank,0]]]);
							}else if (_rank>=7){
								rewards.push(["Congratulations!  Season 1 Tournament has ended!\n\nTournament Reward: Rank #"+String(_rank)+"\n\n - Create Your Own Arena Champion! (ThePeasant will contact you with details).",[SCORE_SOULS,2000],[-1,[119,1,-1,_rank,0]]]);
							}else if (_rank>=16){
								rewards.push(["Congratulations!  Season 1 Tournament has ended!\n\nTournament Reward: Rank #"+String(_rank),[SCORE_SOULS,1250],[-1,[119,1,-1,_rank,0]]]);
							}else{
								rewards.push(["Congratulations!  Season 1 Tournament has ended!\n\nTournament Reward: Playoffs\n",[SCORE_SOULS,1000],[-1,[118,1,-1,-1,0]]]);
							}
						}else if (TournamentData.isChampion()){
							rewards.push(["Congratulations!  Season 1 Tournament has ended!\n\nTournament Reward: Champion Tier!\n",[SCORE_SOULS,750],[-1,[118,1,-1,-1,0]]]);
						}else{
							rewards.push(["Congratulations!  Season 1 Tournament has ended!\n\nTournament Reward: Participant!\n",[SCORE_SOULS,500],[-1,[118,1,-1,-1,0]]]);
						}
					}*/
				}
				
				if (_version<65){
					scores[SCORE_REFRESH]=0;
				}
				
				if (_version<71){
					_resubmit=true;
					for (i=0;i<5;i+=1){
						if (_Data["player"+String(i)]==null){
							m["player"+String(i)]=null;
						}else{
							if (m["player"+String(i)]!=null){
								_player=stringToArray(m["player"+String(i)]);
							}else{
								_player=stringToArray(_Data["player"+String(i)].Value);
							}
							for (j=35;j<40;j+=1){
								_player[5][j]=0;
							}
							_player[4][7]=false;
							_player[14]=[_player[14],0];
							m["player"+String(i)]=arrayToString(_player);
						}
					}
					achievements[ACHIEVE_ROGUE]=false;
					_Save.data.bundlePopped=false;
					clocks=0;
				}
				
				if (_version<73){
					_resubmit=true;
					for (i=0;i<5;i+=1){
						if (_Data["player"+String(i)]==null){
							m["player"+String(i)]=null;
						}else{
							if (m["player"+String(i)]!=null){
								_player=stringToArray(m["player"+String(i)]);
							}else{
								_player=stringToArray(_Data["player"+String(i)].Value);
							}
							if (_player[4].length<8) _player[4][7]=false;
							m["player"+String(i)]=arrayToString(_player);
						}
					}
				}
				
				/*if (_version<80){
					/*if (_Data.Hardcore!=null){
						hardcore=_Data.Hardcore.Value;
						if (hardcore>=0){
							var _rank:int=HardcoreDuelControl.getEliminatedPosition();
							if (_rank==1){
								rewards.push(["Congratulations!  Hardcore Arena has ended!  You have reached Rank #"+_rank+"!",[SCORE_KREDS,100],[-1,[119,1,-1,_rank,0]],[-1,[136,15,-1,-1]]]);
							}else if (_rank==2){
								rewards.push(["Congratulations!  Hardcore Arena has ended!  You have reached Rank #"+_rank+"!",[SCORE_KREDS,50],[-1,[119,1,-1,_rank,0]],[-1,[136,15,-1,-1]]]);
							}else if (_rank==3){
								rewards.push(["Congratulations!  Hardcore Arena has ended!  You have reached Rank #"+_rank+"!",[SCORE_KREDS,30],[-1,[119,1,-1,_rank,0]],[-1,[136,15,-1,-1]]]);
							}else if (_rank>=10){
								rewards.push(["Congratulations!  Hardcore Arena has ended!  You have reached Rank #"+_rank+"!",[SCORE_KREDS,15],[-1,[119,1,-1,_rank,0]],[-1,[135,15,-1,-1]]]);
							}else if (_rank>=25){
								rewards.push(["Congratulations!  Hardcore Arena has ended!  You have reached Rank #"+_rank+"!",[SCORE_KREDS,10],[-1,[118,1,-1,-1,0]],[-1,[135,15,-1,-1]]]);
							}else if (_rank>=50){
								rewards.push(["Congratulations!  Hardcore Arena has ended!  You have reached Rank #"+_rank+"!",[SCORE_KREDS,5],[-1,[118,1,-1,-1,0]]]);
							}else{
								rewards.push(["Congratulations!  Hardcore Arena has ended!  Thank you for participating!",[-1,[118,1,-1,-1,0]]]);
							}
						}
					}
				}*/
				
				/*if (_version<91){
					if (_Data.Hardcore!=null){
						hardcore=_Data.Hardcore.Value;
						if (hardcore>=0){
							var _rank:int=HardcoreGameControl.getEliminatedPosition();
							if (_rank==1){
								rewards.push(["Congratulations!  Hardcore Challenge has ended!  You have reached Rank #"+_rank+"!",[SCORE_KREDS,60],[-1,[119,1,-1,_rank,0]],[-1,[136,15,-1,-1]],[-1,[135,15,3,-1]],[-1,[135,15,5,1]]]);
							}else if (_rank==2){
								rewards.push(["Congratulations!  Hardcore Challenge has ended!  You have reached Rank #"+_rank+"!",[SCORE_KREDS,40],[-1,[119,1,-1,_rank,0]],[-1,[135,15,2,-1]],[-1,[135,15,3,1]]]);
							}else if (_rank==3){
								rewards.push(["Congratulations!  Hardcore Challenge has ended!  You have reached Rank #"+_rank+"!",[SCORE_KREDS,20],[-1,[119,1,-1,_rank,0]],[-1,[135,15,-1,-1]],[-1,[135,15,2,1]]]);
							}else if (_rank<=10){
								rewards.push(["Congratulations!  Hardcore Challenge has ended!  You have reached Rank #"+_rank+"!",[-1,[119,1,-1,_rank,0]],[-1,[135,15,2,1]]]);
							}else if (_rank<=25){
								rewards.push(["Congratulations!  Hardcore Challenge has ended!  You have reached Rank #"+_rank+"!",[-1,[119,1,-1,_rank,0]],[-1,[135,15,-1,1]]]);
							}else if (_rank<=50){
								rewards.push(["Congratulations!  Hardcore Challenge has ended!  You have reached Rank #"+_rank+"!",[-1,[118,1,-1,-1,0]],[-1,[135,15,-1,1]]]);
							}else{
								rewards.push(["Congratulations!  Hardcore Challenge has ended!  Thank you for participating!",[-1,[118,1,-1,-1,0]]]);
							}
						}
					}
				}*/
				
				if (_version<93){
					_resubmit=true;
					for (i=0;i<5;i+=1){
						if (_Data["player"+String(i)]==null){
							m["player"+String(i)]=null;
						}else{
							if (m["player"+String(i)]!=null){
								_player=stringToArray(m["player"+String(i)]);
							}else{
								_player=stringToArray(_Data["player"+String(i)].Value);
							}
							for (j=41;j<44;j+=1){
								_player[5][j]=0;
							}
							_player[4][8]=false;
							m["player"+String(i)]=arrayToString(_player);
						}
					}
					achievements[ACHIEVE_BERSERKER]=false;
				}
				if (_version<94){
					
					_Save.data.bundlePopped=false;
					m["player-100"]=null;
					//PlayfabAPI.deletePlayerData(["player-100"]);
				}
				
				if (_version<95){
					_resubmit=true;
					m["player-100"]=null;
					hardcore=0;
					submitDataQueue([[HARDCORE,hardcore]]);
					//PlayfabAPI.deletePlayerData(["player-100"]);
				}
				
				if (_version<99){
					if (_Data.Hardcore!=null){
						hardcore=_Data.Hardcore.Value;
						if (hardcore>=0){
							var _rank:int=HardcoreGameControl.getEliminatedPosition();
							if (_rank==1){
								rewards.push(["Congratulations!  Hardcore Challenge has ended!  You have reached Rank #"+_rank+"!",[SCORE_KREDS,30],[-1,[119,1,-1,_rank]],[-1,[136,15,-1,-1]],[-1,[135,15,2,-1]],[-1,[135,15,3,1]]]);
							}else if (_rank==2){
								rewards.push(["Congratulations!  Hardcore Challenge has ended!  You have reached Rank #"+_rank+"!",[SCORE_KREDS,25],[-1,[119,1,-1,_rank]],[-1,[135,15,2,-1]],[-1,[135,15,2,1]]]);
							}else if (_rank==3){
								rewards.push(["Congratulations!  Hardcore Challenge has ended!  You have reached Rank #"+_rank+"!",[SCORE_KREDS,20],[-1,[119,1,-1,_rank]],[-1,[135,15,-1,-1]],[-1,[135,15,2,1]]]);
							}else if (_rank<=10){
								rewards.push(["Congratulations!  Hardcore Challenge has ended!  You have reached Rank #"+_rank+"!",[-1,[119,1,-1,_rank]],[-1,[135,15,2,1]]]);
							}else if (_rank<=25){
								rewards.push(["Congratulations!  Hardcore Challenge has ended!  You have reached Rank #"+_rank+"!",[-1,[119,1,-1,_rank]],[-1,[135,15,-1,1]]]);
							}else if (_rank<=50){
								rewards.push(["Congratulations!  Hardcore Challenge has ended!  You have reached Rank #"+_rank+"!",[-1,[118,1,-1,-1]],[-1,[135,15,-1,2]]]);
							}else{
								rewards.push(["Congratulations!  Hardcore Challenge has ended!  Thank you for participating!",[-1,[118,1,-1,-1]]]);
							}
						}
					}
				}
				
				if (_version<100){
					_resubmit=true;
					m["player-100"]=null;
					hardcore=0;
					submitDataQueue([[HARDCORE,hardcore]]);
					achievements[ACHIEVE_LEVEL_70]=false;
					_Save=SharedObject.getLocal("HC_OPTIONS");
					resetSave();
					_Save=SharedObject.getLocal("OPTIONS");
				}
				if (_resubmit) PlayfabAPI.submitPlayerData(m,true);
				
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
			m+="<p align='center'><font size='25'>Reddit is Up!</font></p>\nWe have a new fan-created Subreddit! Find all the information you need, including FAQ, previews, spoilers and updates  <a href='https://www.reddit.com/r/EternalAscended/'><font color='#5555ff'><u>on the subredit!</u></font></a> (right click and select 'new window' if u have ad-blocker).\n\n";
			m+="\n\n"
			m+=getVersionLog();
			return m;
		}
		
		public static function getVersionLog(_numBack:int=10):String{
			var m:String="";
			var i:int=0;
			m+="<b>Warrior Challenge Patch 101</b>\nMecha Police Visor now works correctly\nFixed at least 1 bug connected to Sapien Hair\nReduced difficulty of Warrior Challenge at early levels\nFixed a crash bug connected to Warrior Challenge\nSpecified in current line of patch notes that z1000 one-time reward is raising your level cap to 70. Earned by completing any single zone higher than z1000.";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Warrior Challenge Update 100</b>- Warrior Challenge Event is now Released!\n- Enemy Damage Dealt is now significantly reduced from z1000+\n- New z1000 Shadow Boss, including one-time reward and farmable reward.\n- Enemy Resistances now only scale up to 90% and the scaling values are slightly modified each level.\n- Certain other runaway stats will be capped.";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>End of the Wizard Update 99</b>-Fixed not working recipe for: Plumber Gloves, Dark Half Hood, Poison Bolt\n-Shucked some code to an external swf file. This will hopefully have no impact on gameplay, but if it works properly may improve performance slightly (and will make things easier on me).\n-Wizard Challenge ended! Rewards are granted to all participants";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Potion Crafting Update 98</b>\n- Potion Crafting! z300 and z400 recipes are now available!";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Random Fixes Update 97</b>\n- Reduced the values of Mecha Visor\n- of Initiation now reduces buff duration by 2\n- Whispered Bug fixed\n- DARK is temporarily added to Crown Chakra\n- of the Nail effect reduced\n- Goblin Warrior block is now truly capped in all cases";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Wizard Challenge Update 96</b>\n- Wizard Challenge is released!\n-Reduced the values of Mecha Visor\n- BBM now displays correctly.";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Dark Patch 95</b>\n- Added in higher ascension zones: 1001, 2001, 3001\n- Tweaked the soul costs of all ascensions\n- Did some work on the SAVE code to fix some overload errors\n- Items in your Personal and Shared Stashes no longer have their priorities saved\n- SBBM effect now displays correctly\n- Tooltips corrected on a few items\n- Effects of Silencing, Screamer and Whisperer slightly reduced";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Dark Update 94</b>\n- 4 new Premiums and 4 new Super Premiums are added to the game in two new bundles!\n- DARK Damage was added as a damage type for players.\n- The following skills were altered: Monk Tree, Acolyte Tree, Hollow Eccho\n- The following items were altered: Dark Half Hood, Dark Half Swords\n- Crafting Recipes were added to the following items: Saruman's Staff, Hood, Dark Half Hood, Magic Bolt, Poison Bolt, Enchant Weapon, Classic Bomb, Flying Rat, Demon Sickles, Multibolt, Hylian Sword, Plumber Gloves\n- Following suffixes were altered: Half Darkened\n- Tooltips for Manufacturing equipment were clarified.\n- Shadow Hat effect was altered to grant Manufacturing Points instead of a chance to find full stacks\n- Added a UI element to show Manufacturing Points charging up\n- Demon Realm enemies now properly deal Dark Damage instead of Holy\n- Rogue Tree Bonus increased\n- Defensive Roll now also adds a bit of Health";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Internal Testing 93</b>\n- Minor bug fixes and tooltip errors\n- Updates some player stats in the background to prepare for a bigger update.";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Some Fixes 92</b>\n- Modifiers to damage on Temp Bow and Eternal Tome will now properly affect throwing items\n- Chain Attacks on Ranged Attacks now count as Multishots.\n- Fixed up a bunch more blue tooltip text\n- Your health can no longer drop below 0 when you take damage between fights (ie. from Damage Over Time)\n- Mega Boar's Toxic Spines have been restored!\n- Fixed an issue involving Nullifying Damaging Spells"
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>The One Patch 91</b>\n- Leech from Projectiles is fixed\n- Hardcore Challenge Event is OVER!  Congratulations to all winners!\n- Text on Explosive Charm and several other effects are fixed\n- New Artifact Tree is released!\n- The following artifacts have their effect increased: Phoenix Feather, Solar Plexus, Valkyrie's Cry, Gaia's Song, Archangel's Feather, Spirit Dragon's Breath\n- The following artifacts have their effect decreased: Valkyrie's Spear, 3rd Eye Chakra, Spirit Dragon's Claw";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Soulforge Patch 90</b>\n- Items that cost Power Tokens now properly show 'PT'\n- Quickstrike Tooltip is displayed correctly\n- Sapien Hair got increased Nullify but RSpecial was removed\n- Removed (hopefully) all remaining references to RSpecial\n- Fixed a couple new Rounding Errors\n- z50 and z100 bosses should now grant you items again\n- Sell Shadow Item popup fixed\n- Enlightened is once more earnable from any skill";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Soulforge Update 88</b>\n- Can now sell Essences for souls\n- Can now purchase Essences for souls in the Essence tab of the Forge\n- New Essence: Minor Chaos Essence, only available from the Soul Shop.  All players are granted one of these, FREE! (yes, it can be recycles for souls if you want :P)\n- Soul Gain increased and normalized at higher zones (z400+)\n- Leveling up Vessel should now always unlock the spell slot instantly\n- Many blue-text typos were fixed - please report any more that you find!\n- At Foot effects in Arena should now properly reset between opponents\n- further Highscores from Hardcore Mode will no longer spill over into normal mode... existing highscores will remain as they are, unfortunately.\n- Autopot now correctly uses Mana Potions when your mana drops low\n- Clarified tooltips on Strength, MPow and Initiative\n- Removed RSpecial from the game.  All sources now instead list the three resistances individually.\n- Crown Loot Chance slightly improved\n- Changed a bunch of background code connected to on-hit effects in order to make it more efficient.  Hopefully everything still works.";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Monk Update 87</b>\n- Fixing a save error where progressing too quickly caused the save system to crash.\n- Standardizing blue tooltip text and correcting it for certain crafted items.\n- Hardcore 4,000 reward is now correct\n- Fixed a bug that stopped some new players from progressing through the tutorial\n- Some enemy stats have been adjusted\n- Heck Horns now scales properly\n- Monk Mini-Rework is complete!\n- Shadow Gloves and Rending Claw have been improved";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Crafting Balance Update 86</b>- Hardcore Mode now also grants Milestone Rewards\n- Constant Effects (ie. Cleanse, Free Spell, Roasted) now happen at the beginning of your turn\n- Enemy Damage and Spells increase at a reduced rate past z300\n- Increased damage of Breaker and Breaking Sword, Dazzling Strike, Searing Blast and Smothering Poison\n- Increased effect of Pentagram, Demon Horns and Reversed, Defensive Sais\n- Increased effectiveness of 'of Neptune', 'of Carousing', 'Upturned', 'of Closeness'\n- Divine Protection Healing increased\n- Surestrike effect increased\n- Added Accuracy to Monk Base Skill\n- Reduced damage of Surmounting Poison\n- Reduced health of base Turban\n- Shadow Sparrow's Bow's Accuracy is reduced in all recipes\n- Radiating Aura damage is fixed (was dealing x2 dmg), but damage also slightly increased.\n- Reduced the Crit Rate and Damage of Vorpal Weapon\n- SQS Recipe should now work\n- You can no longer go into Token Debt\n- Stealth properly activates when dodging Grenades\n- Quick Strike can no longer occasionally activate with throwing weapons (other than Shuriken)\n- Clarified tooltips for Surmounting Poison and Shield spells as well as any effect with multiple stacks.";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Buff Gixes Patch 84</b>\n- Hardcore Mode is Released!\n- 'of Initiation' now has Reserve Mana\n- 'of the Sapien' numbers increased and can be placed on Relics\n- Real Tramp is improved\n- Abuse has been reduced slightly\n- Reduced 'of Dazzling', increased 'of the Rat'\n- Gold cost of epic upgrades reduced\n- Quick Strike no longer applies to bows\n- You can now properly turn a Special Premium epic by combining with the Vanilla version\n- Fixed a bunch of typos";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Crafting Clarity Patch 83</b>\n- You can now rename your character on Ascension\n- Fixed up minor issues in the New Character screen\n- SQS is fixed\n- Cantrip Curses no longer cast when enemy already has the debuff\n- Openned up several basic essences to be used with Spells and Grenades\n- Allowed certain essences to also affect Scrolls and Potions\n- Fixed another essence stack disappearing issue\n- Added a 'Crafting Preview' option";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Crafting Patch 82</b>\n- All suffix essences now have unique colors\n- Suffix Essences now properly block being added to the same item\n- Confirmation added to Death Screen when spending kreds\n- Essence of Efficiency tooltip fixed\n- Master's Statue removed from the game\n- You can no longer craft suffixes from basic charms (since you can acquire them en masse)\n- Essence of the Master can now apply to other things";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Crafting Update 81</b>\n- Crafting System is now available with over 300 recipes!\n- Two new pay bundles are now available in the Premium Shop\n- z300 and z400 Shadow Bosses have entered the realm\n- You may now only ascend to a zone you have already reached\n- You can revive at your current zone progress by paying Tokens";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Bug Fixes 80</b>\nUpdate 80:\n- Stealth is now broken when dealing any form of damage\n- Withdraw Userate should now work properly\n- Basic Stats Tab restored\n- Archangel’s Halo and Phoenix Flame are now working correctly\n-Autopot and Divine Protection now work again";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>End of Hardcore 79</b>\nHardcore Challenge Event has ended!  Rewards are now being distributed.  Note that the actual highscore list is different from that shown on Kongregate, to account for accused hackers and certain scores not being submit.\n- Lots of code was reworked, expect some bugs until the next hotfix\n- Vulnerability now properly affects R.Chem and R.Spirit\n- Scrolls are no longer marked 'Epic'\n- Fixed a bug where offline rewards were occasionally not being granted";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Upgrade Fix 78</b>\nATTENTION! There was a bug where some people lost items when trying to Upgrade. If you lost an item please send a Bug Report and I will refund it as quickly as possible.\n- Upgrading Fixed\n- Leap Attack fixed";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Just Bugs 77</b>\n- Fixed several tooltip errors\n- Dodging Ranged Attacks now properly sets of Stealth\n- Valkyrie's Cry now carries over between fights\n- Item Drops can once more be enchanted\n- Strength has returned to the Stats Menu\n- Distance Priorities should now work again\n- Resistances, Dodge and Turn are now hard-capped at 100%\n- Sapien Normal Form should add and remove stats properly\n- You should not longer approach and hit people with books or bows\n- Reduced soul costs for ascending to z400 and z600\n- Root Chakra Tooltip is fixed";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Small Patch 76</b>\n- Quality in town is returned to normal\n- Increased global text quality, especially for low graphic settings\n- Fixed yet another dupe bug\n- Changed some reference types to make runtime more efficient\n- Shuriken Base Damage no longer scales off of Base Monk Damage\n- Removed the Basic tab from the Stats Window in game\n- Raised the Ascend Zones up to z600\n- Goblin Shaman learned a new spell\n- Defensive Roll effect is reduced, but it has a chance to proc whenever you take damage\n- Deaths since Last Ascension now displayed in the LOG screen\n- Closing the game from the Adventure will now reset current zone progress to 0.  Closing from town will save your progress.";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Pack Patch 75</b>\n- Class Packs can now be purchased separately from Class Bundles if you don't want to buy the class\n- Weapon/Helmet Priority Buttons are in the Arena\n- Quality is automatically set to BEST in all town areas (let me know if this negatively affects anyone's performance)\n- Fixed some display errors in the Statistics screen\n- Continued to work on some runtime issues\n- 'Didn't Happen' is now used before other defenses are checked\n- You can no longer use your stash in Hardcore Arena\n- Slightly increased health scaling of all monster\n- Direct Damage increases from different sources are now ADDITIVE instead of MULTIPLICATIVE";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Hardcore Patch 74</b>\n- Leap Tooltip fixed\n- Nullify now works correctly\n- Shurikens now truly work with Holy\n- Withdraw > Leap works again...\n- Leap Attack is once more classified as NEAR\n- Smite only works on the first hit of a multi\n- No more arena ghosts\n- Negative Stats are now calculated separately from Positive Stats\n- Forced Actions are now cleared when you go to town.\n- Forced Actions should no longer be carried over between characters";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Hardcore Update 73</b>\n- Hardcore Challenge Arena is Live!\n- Healing and Mana Potions now both count as CHEMICAL and Healing Spell is indicated that it is HOLY\n- Mana Potions now also scale with HEAL\n- Mana Shield effectiveness increased\n- Mana Shield no longer consumes mana if you would die anyways\n- Phoenix Flame Duration increased to 3\n- Class Skills are added and class stats have been moved there\n- Tooltip for Assassinate has been corrected\n- Enemies have increased health scaling but reduced damage scaling\n- Rogue Tree should now properly unlock for all characters\n- Modified a lot of code surrounding various actions to make it more efficient.\n- Modified a lot of code surrounding saving the game to make it more efficient.\n- Deathstreak is now visible in the LOG tab\n- 8z8z no longer becomes NaN\n- Shurikens now work with Holy trait";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Rogue Patch 72</b>\n- Rending Claws and Shred now work properly.\n- Quiver is now classified as a 'Buffing Trinket'\n- New players can now properly create character\n- Shadow Shortbow now spawns with the correct stats\n- Renamed 'Battle Cleanse' to 'Purge'\n- Toxic Gas and Classic Bomb now stack twice\n- Tooltip on Demon Sickles and Bleeding fixed\n- Leap Attack again uses all flurries\n- Rogue Titles now working\n- Rogue Shadow Items properly spawning";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Rogue Update 71</b>\n- Introducing The Rogue! Now available individually or through a bundle\n- The two first tier Ranger Skills have been reworked and a Ranger Pack is available!\n- Offline Progress can now be earned\n- Season 1 Tournament winners are officially posted in the Arena!  Check 'em out!\n- Arena Opponents now have properly scaling items after ascension\n- All trees now have a Class Stat that is the same across all skills\n- Radiating Aura Damage is reduced slightly (should be around the same with new Tree Bonus)\n- Guided and Defender enchantments are improved\n- Archangel's Feather is improved\n- Blood of the Minotaur now only has one chance to activate per round and only if you do not hit with any attack.\n- Classic Bomb has a TEMPORARY fix until I have a chance to rework it properly\n- Crusader's Mace now works correctly from Mid Range\n- Paladin's Buff Boost increases at level 7 instead of level 10\n- Increased the effect of Vulnerability, decreased Duration slightly\n- Decreased duration of Enchant Weapon\n- All bolts from Multibolt can now be potentially defended against\n- Gaia's Song effect increased at lower levels\n- Reduced the Approach penalty to 10% Accuracy/Spell Pen\n- Hylian Sword has slightly lower Base Damage but significantly higher Magic Damage\n- Captain's Shield only deals half x2 dmg at range\n- Quickstrike no longer applies to Ranged Weapons\n- Ranged Attacks no longer proc Thorns\n- Far and Mid are now modified only by the FAR multiplier\n- Berserk now also adds Tenacity\n- Added a Priorities Button under the Weapon and Helmet\n- Prioritizing Attack from Near will now use Withdraw > Leap if available\n- You can now change the priority tiers of your items\n- Buff Names only appear in game and in text when it is a fresh application, not when it increases stacks or refreshes a buff\n- Buff Tooltips now show details about the buff\n- Premium Shop is now accessible from the Town screen\n- Changed the Purchase Flow to only use Power Tokens, which can be purchased in bulk!\n- Skipping Zones is cheaper and can now be done with Power Tokens, but you don't gain souls for zone you've skipped.\n- XP Boosts can now be stacked\n- Added some extra safeguards to the Save System.  Certain in-town transitions may take longer but there should be fewer disconnects."
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Ranged Update 70</b>\n- Changed enemy scaling in many ways.\n- Withdraw will not occur if you have nothing to use at the withdrawn distance (aka. set everything NEAR and you will never withdraw)\n- You can still fail userate post withdraw, however\n- Additionally, Withdraw is placed FIRST in your action list, to be tested before any NEAR action\n- Added a new range category!  How do you access it??\n- Reworked the Baseball Bat, Captain's Shield and Hylian Sword\n- Clicking on the Priority button now scrolls classically\n- Hold the Priority Button to access the Advanced Menu\n- Distance is now an Inclusive List in the Advanced Menu\n- Split the -10 R.Spirit between the two basic Acolyte skills\n- Archangel Header is now correct\n- updated tooltip for Archangel's Whisper\n- Wider Tooltips!\n- Toggle Subtitles option is saved\n- Going back to town after defeating a boss also resets Premium Shop\n- No more 'Suns to skip boss' exploit\n- No more Arena Priority exploit\n- Items held when a level ends should now be returned to your inventory";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Archangel Update 69</b>\n- Archangel Artifacts are officially finished and released!\n- A new Premium Spell is now in rotation!\n- Masta Rasta change was reverted... Spell Pen removed and Mana increased greatly.\n- Reduced Smite dmg at lower levels, increased dmg at max level\n- Enemy Abilities are now all set by zone to increase predictability, instead of some being random\n- You can no longer choose to fight a boss again\n- Generic Spells are removed from the Premium Shop\n- Current Souls in the Temple correctly updates";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Priorities 1.5b: Update 68</b>\n- 3rd Eye Chakra now grants Initiative Scaling to Strength weapons and vice versa\n- Ratio of 3rd Eye Chakra increased\n- Swapped the effects of Dragon's Breath and Neptune's Trident and adjusted their values\n- Increased G.Rate from Deadly Alchemist and Shadow Armet\n- You can now click on the title in the Statistics Tab (in game) to switch to the enemy\n- Statistics are no longer cleared when an enemy dies\n- Enemy Leap Damage is now capped out at +200% at z200\n- Enemy Resistances now progress with Diminishing Returns\n- Enemies start to get Physical Resistance from z200 (when Block stops scaling)\n- Adjusted the Priorities 1.5 system slightly.  I would like feedback on which you like better.\n- Added a new priority list to Buffs and Curses\n- Shadow Axe and Masters are working\n- 4 Hairs are now found in the Premium Shop... Cosmetics shop isn't ready yet though!\n- tooltips for Leap and Withdraw are fixed\n- Many tooltips in general are cleaned up\n- Hopefully fixed the save issue after ascending.  Safeguards are still in place just in case.\n- SEMANTICS CHANGE: All players get 10% Dodge by default.  10% dodge was removed from Light Helmets and -10% Dodge was given to Medium Helmets.  PoF also lost equivalent of ~10% Dodge at max level.";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Priorities 1.5: Update 67</b>\n- Changed the priority system to a Combo Box with a secondary option\n- Currently there is a different option just for Healing effects.  Please give feedback on this system in the forums.\n- Replaced 'Ornate' with 'Homing'\n- Granted a lesser Homing effect to all premium throwing weapons\n- Increased health of base Bandana\n- Shifted some HP from Sapien to Base (increasing Super Sapien HP)\n- Got rid of Sapien's +1 M Dmg\n- Pact now grants a flat -10% R.Spirit\n- Everyone is granted +10% FAR Damage by default\n- Classic Bomb now works correctly\n- Charms are now color coded\n- Changed name of Rhino\n- Changed name of Phoenix Flame's Debuff\n- Changed the Subtitle Font";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Hair Patch 66</b>\n- Added a new effect to Super Sapien\n- Added a new effect to Rasta and reduced Mana slightly\n- Embraced is now properly classified as a buff.\n- Tooltip for Rending Claws is fixed\n- Premium Shop again refreshes every zone in addition to granting tokens every 10";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Hair Update 65:</b>\n- 4 new Packs are available in the Premium Tab!  For a limited time, get 1 pack FREE!\n- Changed ascension levels to 30 at z50 and 45 at z100\n- Creating a new character now properly sets you at zone 1\n- Mousing over a buff icon will now show you its type (buff or curse) and number of stacks.\n- You now use Refresh Tokens to refresh the shops, earned by clearing zones."
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Hotfix 64:</b> Your zone should no longer be reset to 1 occasionally, expecially if you defeat an arena opponent.  All affected players were compensated."
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Prep Update 63:</b>\n- Wild now properly has +/- 60% damage (was acting like 30% previously)\n- Values on Crusader Helmet were shuffled slightly\n- Changed the tooltips on Lingering Depths, Ally of Light and Hockey Mask to reflect their current effects\n- Valkyrie's Cry no longer persists between fights.\n- Changed the formula for soul gains to be reduced at higher levels (360+)\n- No longer allowed to use the following characters in a stash name: [ ] ,\n- Icons now look better while still being prerendered to save on performance\n- Yermiyah has a beard now\n- Added new achievements when you level up each talent to 60 for the first time.\n- Prepared the Cosmetics Tab for a bunch of new cosmetics\n- Enemies who used stats from Heavy Weapons no longer have the 150% Strength Scaling (ie. Guardians)\n- You can now truly sell from the Stash"
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Moar Update 62:</b>\n- Added 4 more Stash Tabs... and #5 is free for existing players!\n- Added 3 new Skin Colors!\n- Juliette has officially entered the arena!\n- No enemy damage scales off of Initiative\n- Enemy Initiative is now split into several categories and only scales up to z200\n- Phoenix Feather now scales up to 100% chance, but only one revive can occur per fight\n- Change the effect on Holy Grail\n- Death Jester no longer allows you to revive through any other means (heal and prevent dmg yes)\n- Added Heavy Weapon to all two handed weapons, including Light Sword and all Staves\n- Heavy Weapon now properly scales with alternate sources (ie. MPow from the artifact)\n- Enchant Weapon duration can increase again with Duration artifacts\n- Divine Protection now triggers off of DoT\n- Overflow is now checked for condensing every time you open the tab\n- Icons are new rendered to hopefully save a bit on performance\n- Made all healing numbers the same color\n- Relics can now be swapped with each other\n- You can now sell items directly from your stash"
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Bye Bugs Update 61:</b>\n- Auto-sell should once more be disabled when turbo is not achieved\n- Fixed an error where the background would occasionally load incorrectly or start as a white screen\n- Increased the counter size on buff icons\n- Lightened up the blue on Heals\n- Full Titles can now be earned with fewer skill points in your main tree\n- All stats in the Stat Tab in game are now fully rounded\n- DOTEFF was renamed DOT and PROCEFF was renamed PROC\n- REND now only procs on Crit, but does x3 damage, lasts 1 extra round and still stacks up to 20\n- EXPLOSIVE effect no longer is affected by RCrit (bad idea... sry...), but had its damage reduced slightly instead\n- Cleanse can no longer remove 'Delayed Damage'\n- Auto-Buff now correctly only uses one instance of a buff";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Big Rebalance Update 60:</b>\n- Significantly reduced the Fear Effect on Chainsaw, slightly reduced Crit Rate\n- Significantly reduced Death Jester's Health Regen while alive\n- Undying is no longer reset when climbing above 0 hp, only when the buff runs out.\n- Slightly increased Rending Claws' Crit Rate, Removed its Crit Mult and gave it a stacking DoT.\n- Gave Crusader's Helm some non-buffed effects as well\n- Envenomed Mask now has Auto-Buff instead of Auto-Pot\n- Hockey Mask is now a Medium Helmet\n- Captain's Shield has increased base damage\n- All standard procs have slightly increased damage\n- Explosive is now resisted by R.Crit\n- All Light Helmets (except DJ) had their hitpoints increased\n- All Light Helmets now have an innate 10% Dodge\n- All Medium Helmets had their hitpoints increased\n- Added Heal Reduction to many Damage Over Time Effects (including MEGA BOAR)\n- Most two-handed weapons now have 150% Strength Scaling\n- Increased Fireball's BURN damage\n- Every point in the Wizard tree now also grants +1% MAGIC\n- Vessel now gives you a 3rd spell slot at level 7\n- Increased Autopotion Proc Rate\n- Decreased SUNS Decay Rate\n- Added small numbers in the health bar when your health drops below 0 (after death or during Undying)\n- Buff icons are now smaller and take multiple rows\n- Autopause should now work in the arena again.\n- Slightly increased Premium Drops from all monsters at higher zones\n- Dodge and Turn are now capped on normal monsters at 25%, but may go higher on certain monsters";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Version 59:</b>- Added a new option to the Autopause menu\n- Skill Tree Selection now appears after you create a new character or ascend\n- Made it more clear which skill trees are selected and which are not\n- Modified Autopause Low Health and Every Turn to happen right at the beginning of your turn\n- Autopause Every Turn also clears priorities when it happens.\n- Autosell Options now exist!  Find them off the Turbo Button\n- Slightly reduced Golem's Crit Mult and Resistances";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Version 58:</b>**NOTE** Some people may have lost some time or items during this pre-patch blunder.  So I'm giving everyone 15 Power Tokens as a 'sorry' and if anyone lost items please let me know.\n- Bundles Button in town now works correctly\n- Increased base cost of all stacking items\n- Refilling stacks now has a standardized cost across all items and scales off Zone instead of Item\n- Gem Level can now scale infinitely\n- Reworded Dragon Scale";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Version 57:</b>- Moved the Bundles to the Premium Shop\n- Fixed floating point errors with some damage values\n- Fixed upgrade and restack costs of Holy Grail and Pentagram\n- HEAL stat now properly works with lifesteal, spellsteal and paladin's healing\n- Valkyrie's Cry will no longer stall out the game\n- Radiating Aura now counts as a DOT for purposes of DOTEFF";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Version 56:</b>- Two new Classes are released, complete with Super-Premium Item Set!\n- Quarter Finals are complete!\n- Four free Cosmetic Skin Colours for your viewing pleasure!\n- Fixed Statistics screen in Arena\n- Cosmetics Tab is more prettier";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Version 55:</b>- Changed the text when your save requests time out to reflect that error instead of 'log in from different device'\n- Increased the timeout time.  This should make it clearer what is happening and prevent preventable timeouts\n- Fixed floating point error with Leech\n- Fixed Withdraw allowing heroes to Approach afterwards.\n- Fixed Enchant Weapon not scaling properly\n- Two new Premium Items are released!\n- Removed MPow from the Light Sword and added an extra ability";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Version 54b:</b>- Tournament Octofinals Complete!\n- Boost will now correctly give 2xp per kill (instead of accidentally giving 4)\n- Cleaned up the tooltips on Leap Attack and Withdraw\n- Limited transitions to only occur if nothing is saving or loading.  This will hopefully prevent unexpected data replacement issues.";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Version 54:</b>- Playoffs Round Results are in!\n- Changed Health Potion to only trigger if you are also below 50% health.\n- Fear Powered no longer includes fears applied from the action being checked\n- Fixed a bug where SL Scrolls were using full MPow for Damage.  This will unfortunately affect the current tournament but we will not go back over previous rounds.";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Version 53:</b>- Round 1 Tournament Results are in!  See the challengers in the tent!";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Version 52:</b>\n- Tournament Submissions are now closed!\n- If you die and kill in the same action during a Duel (ie. Thorns, Kabuto) then the match ends in a TIE (formerly always went to the Player: LEFT)\n- Fixed certain cases where tournament characters could enter the real world\n- Fixed an issue that allowed you to duplicate items\n- Fixed an issue that allowed you to gain free power tokens\n- Added 'Level Up' to the Autopause menu\n- After respec-ing, you can now respec for free until you close the Statistics Window\n- Reduced the CMult of all Demonic Beasts (including Golem)\n- Modified the difficulty curve to ramp up slower until z100.  This should make it easier for new players to reach their first ascension.  Curve is back to normal at z150+\n- Fixed text on Valkyrie's Shield";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Version 51:</b>\n- Hotfixed a few issues with the Tournament Simulator.";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Version 50:</b>\n<font color='#ff5500'>NOTE: THIS IS THE LAST BALANCE UPDATE UNTIL AFTER THE TOURNAMENT.</font>\n- Tournament has begun!\n- Changed the effect of the Shadow Cone\n- Increased effect of Spirit Dragon's Eye and Blood of the Titan Artifacts, Gaia's Dream and Blood of the Minotaur\n- Fear and Confuse no longer activate defensively when Cursed\n- Updated tooltips of Berserk and Root to include 'hurt or cursed'\n- Craft Belt formula changes.  It now starts at 5 and goes up to 25, which indicates Work/Turn.  100 Work = Belt.  (End effect is slightly stronger).\n- Fireball and Lightning Strike have reduced scaling mana cost\n- Poison Bolt has slightly increased scaling mana cost\n- Yermiyah and Gars found Plentiful Scrolls!\n- z200 reward now starts at level 15\n- Charms will now spawn with different subsets of enchantments per type (no new enchantments)\n- Quality Setting now saves\n- Death Streak counter in your Death Window\n- You can now choose which zone to respawn at after ascending, for a price\n- Renamed 'R.ALL' to 'R.SPECIAL'\n- Loading Orb returned from vacation\n- Items in locked spell slots will remain equipped but you will not cast them until the slot is unlocked.\n- Arena characters no longer upgrade after dying";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Version 49:</b>\n- Added 'Every Turn' to the Pause menu for those maximum control moments\n- Fixed an exploit that allowed you to equip two Relics at once\n- Gave everyone Manufacturing 20 by default\n- Arena Opponents are now considered Bosses for Priorities\n- Items will no longer autostack when being added to your inventory from drops or otherwise (you can still stack manually\n- Reduced Beezelpuff's NULLIFY, but increased his R.ALL\n- Reduced the NULLIFY of all Demonic enemies\n- Fixed a memory leak causing occasional undue lag\n- Turned certain effects into Tags in the tooltips\n- Changed colour of Physical Damage and position of Buff Text\n- Removed 'isQuickisMomentumisQuick' from the action log\n- Phoenix Ash and Valkyrie's Wing now state 'damage or curse an opponent'\n- Blood of Vampire and Blood of the Unicorn no longer proc when cursing\n- New z200 event, for anyone who gets there!";
			i+=1;
			if (i>=_numBack) return m;
			m+="\n\n";
			m+="<b>Version 48:</b>\n- Added 1 new Premium Item, the 'Temporary Bow'\n- Power Tokens have been added to the game!  These can be used instead of Kreds to purchase anything Premium.  Gain Power Tokens by selling Premium Items, and as special gifts\n- Everyone has been granted 15 free Power Tokens!\n- Added a Mini-Shop also when you die";
			return m;
		}
		
		public static function resetPlayerData(){ //Populate the player data with brand new game data.  Call on initial launch with no export and data wipe.
			artifacts=new Array(50);
			for (var i:int=0;i<artifacts.length;i+=1){
				artifacts[i]=-1;
			}
			stash=new Array(8);
			for (i=0;i<8;i+=1){
				stash[i]=["Shared Stash "+String(i+1),true,new Array(20)];
			}
			stash[0][1]=false;
			overflow=[];
			PlayfabAPI.loginCount=1;
			numCharacters=0;
			lastChar=0;
			cosmetics=[[],[],[],[],[],[]]
			scores=new Array(14);
			for (i=0;i<scores.length;i+=1){
				scores[i]=0;
			}
			flags=[false,false,true,false,false,false,false,false,false];
			achievements=[];
			while(achievements.length<23){
				achievements.push(false);
			}
			submitDataQueue([["version",VERSION],["firstVersion",VERSION],["logins",1],
							 ["cosmetics",cosmetics],["achievements",achievements], ["flags",flags],["artifacts",artifacts],["stash",stash],["overflow",overflow],["scores",scores],["lastChar",lastChar],
							 ["player0",null],["player1",null],["player2",null],["player3",null],["player4",null]],true);
							 
			//RESET CHARACTER DATA AS WELL
		}
		
		//==============OLD SAVE EXPORT IMPORT==========================================
		
		public static function saveAsk(){
			new ConfirmWindow("Do you want to export your save data for use in Eternal Quest: Ascended?",50,50,saveOldData,0,dontSaveData);
		}
		
		public static function saveOldData(i:int=0){
			var a:Array=new Array(10);
			
			PlayfabAPI.submitOldSave(arrayToString(a),onSaveComplete);
		}
		
		public static function dontSaveData(i:int=0){
			new ConfirmWindow("You can save your data from your HOME.  Save Transfers are only available for a limited time!");
		}
		
		public static function onSaveComplete(){
			new ConfirmWindow("Old Save Submitted Successfully!\nPlease load Eternal Quest: Ascended to continue.");
		}
		
		//START LOAD HERE!
		public static function getOldSave(){
			PlayfabAPI.getOldSave(oldSaveQuery);
		}
		
		static var _OldSave:Array;
		public static function oldSaveQuery(s:String){
			if (s==null){ //NOTHING SAVED
				endOldSave();
			}else{
				_OldSave=stringToArray(s);
				new ConfirmWindow("Old Save Detected!\n\n"+getPlayerNames(_OldSave)+"\nReplace all your game data with this save?",50,50,loadOldSave,0,refuseOldSave,3);
			}
		}
		
		public static function refuseOldSave(i:int=0){
			new ConfirmWindow("Delete this data permanently?",50,50,deleteOldSave,0,endOldSave);
		}
		
		public static function deleteOldSave(i:int=0){
			PlayfabAPI.clearOldSave(deleteConfirmed);
		}
		
		public static function deleteConfirmed(){
			new ConfirmWindow("Data deleted successfully.");
			endOldSave();
		}
		
		public static function endOldSave(i:int=0){
			oldSaveChecked=2;
		}
		
		public static function loadOldSave(i:int=0){
			var a:Array=_OldSave;
			/*achievements=a[0];
			kreds=a[1];
			stash=a[2];
			scores=a[3];
			firstVersion=a[4];
			var _player0:Array=a[5];
			var _player1:Array=a[6];
			var _player2:Array=a[7];
			var _player3:Array=a[8];
			var _player4:Array=a[9];*/
			
			/*souls=0;
			tutorialComplete=true;
			newMessage=false;
			lastChar=0;
			boost=0;
			cosmetics=[];*/
			
			artifacts=new Array(50);
			for (var i:int=0;i<artifacts.length;i+=1){
				artifacts[i]=-1;
			}
			
			a[2][4]=[];
			
			if (a[4]<39){
				cosmetics=[[],[],[],[],[],[1]];
				a[2][4].push([Math.floor(64+Math.random()*28),0,-1,-1,0]);
			}else{
				cosmetics=[[],[],[],[],[],[]];
			}
			stash=a[2];
			scores=a[3].concat([0,0,0,a[1],0]);
			lastChar=0;
			flags=[true,false,true,false,false,false,false,false,false];
			achievements=a[0];
			
			saveAllPlayerData(true);
			
			submitDataQueue([["version",VERSION],["firstVersion",a[4]],["player0",a[5]],["player1",a[6]],["player2",a[7]],["player3",a[8]],["player4",a[9]]],true);
			PlayfabAPI.clearOldSave(finishLoadOldSave);
		}
		
		public static function finishLoadOldSave(){
			if (cosmetics.length>0){
				new ConfirmWindow("Old Save Data loaded successfully!\n As a founder you are rewarded with the first ever cosmetic item!");
			}else{
				new ConfirmWindow("Old Save Data loaded successfully! Enjoy the game!");
			}
			oldSaveChecked=2;
		}
		
		public static function getPlayerNames(a:Array):String{
			var m:String="";
			for (var i:int=5;i<a.length;i+=1){
				if (a[i]!=null){
					m+=a[i][0]+" Lvl."+String(a[i][1])+"\n";
				}
			}
			return m;
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
			if (PlayfabAPI.SUBMITTING>0){
				delay=DELAY;
				return;
			}else if (delay>0){
				delay-=1;
				return;
			}
			
			if (overQueue.length>0){
				m=new Object;
				for (var i:int=0;(i<10 && overQueue.length>0);i+=1){
					var _pair:Array=overQueue.shift();
					m[_pair[0]]=valueToJSON(_pair[1]);
				}
				PlayfabAPI.submitPlayerData(m,true);
				delay=DELAY;
			}else if (queue.length>0){
				var m:Object=new Object;
				for (i=0;(i<10 && queue.length>0);i+=1){
					_pair=queue.shift();
					m[_pair[0]]=valueToJSON(_pair[1]);
				}
				PlayfabAPI.submitPlayerData(m,false);
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
