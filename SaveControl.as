package {
	import skills.SkillData;
	import items.ItemModel;
	import items.ItemData;
	import ui.windows.ConfirmWindow;
	import utils.KongregateAPI;
	import artifacts.ArtifactData;
	import artifacts.ArtifactModel;
	import utils.GameData;
	import flash.events.Event;
	import utils.PlayfabAPI;
	import limits.LimitModel;
	import limits.LimitData;
	
	public class SaveControl{
		public var _Challenge:Array=[
			["Bobo",1,10,[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[[8,0,0,-1,0],[11,0,0,-1,0],[14,0,0,-1,0],null,null,[31,0,6,-1,0]]],
			["Tubor",5,11,[1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[[1,0,0,-1,0],[12,0,0,25,0],[24,0,0,-1,0],null,null,[31,0,6,-1,0],[33,0,6,-1,0],[61,0,10,-1,0]]],
			["Juliette",10,20,[0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2],
			[[120,2,-1,-1,0],[12,2,-1,23,0],[24,2,-1,-1,0],[25,2,-1,-1,0],[22,2,-1,-1,0],[43,2,-1,1,0],[41,2,-1,9,0],[44,2,-1,15,0],[44,2,-1,22,0],[44,2,-1,6,0]]],
			["Twick",15,13,[3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,0,0,0,0,0,0,0],
			[[3,1,0,13,0],[11,1,0,26,0],null,null,null,[31,1,6,-1,0],[38,1,25,0,0],[37,1,25,9,0],[37,1,25,7,0],[40,1,0,15,0]]],
			["Branador",20,14,[0,0,0,4,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,4,4,0,4,0,4],
			[[8,2,0,-1,0],[13,2,0,20,0],[21,2,0,-1,0],null,null,[31,2,6,-1,0],[34,2,6,-1,0],[34,2,6,-1,0],[35,2,6,-1,0],[36,2,6,-1,0]]],
			["Gardas",25,15,[0,5,5,5,0,0,0,0,0,0,5,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0],
			[[6,2,0,13,0],[13,2,0,27,0],[18,2,0,-1,0],null,null,[31,2,6,-1,0],[31,2,6,-1,0],[35,2,10,-1,0],[40,2,0,29,0],[41,2,0,12,0]]],
			["Steph",35,16,[0,7,0,0,0,0,0,0,0,7,0,0,0,0,0,0,7,7,7,0,0,0,0,0,0,0],
			[[5,3,0,0,0],[9,3,0,20,0],[24,3,0,-1,0],null,null,[31,3,6,-1,0],[40,3,0,8,0],[41,3,0,9,0],[42,3,0,7,0],[43,3,0,20,0]]],
			["Luca",40,18,[0,0,8,0,0,8,8,0,0,0,0,8,8,0,0,0,8,0,8,0,0,0,0,8,8],
			[[4,4,0,14,0],[11,4,0,17,0],[16,4,0,-1,0],[22,4,0,-1,0],null,[32,4,6,-1,0],[36,4,6,-1,0],[35,4,6,-1,0],[38,4,10,4,0],[40,4,0,11,0]]],
			["Yue",45,19,[0,0,0,0,0,9,9,9,0,0,0,9,9,0,0,0,9,0,9,0,0,0,9,0,0,0],
			[[4,4,0,4,0],[10,4,0,15,0],null,null,null,[31,4,6,-1,0],[31,4,6,-1,0],[32,4,6,-1,0],[40,4,0,14,0],[40,4,0,25,0]]],
			["Yermiyah",50,17,[0,0,10,10,0,0,0,0,0,0,10,10,10,10,10,0,0,0,0,0,0,0,0,0,0,0],
			[[2,5,0,1,0],[11,5,0,16,0],[15,5,0,-1,0],[14,5,0,-1,0],[19,5,0,-1,0],[32,5,6,-1,0],[33,5,6,-1,0],[58,5,2,6,0],[53,5,2,6,0],[40,6,0,18,0]]]
			];
			//["Gars",10,12,[0,0,2,0,0,0,0,0,0,0,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0],
			//[[2,1,0,1,0],[10,1,0,21,0],[17,1,0,-1,0],[14,1,0,-1,0],null,[31,1,6,-1,0],[32,1,6,-1,0],[58,1,2,1,0]]],
			
		public var _Tournament1:Array=[
			["pizza87760",25,1,[0,0,3,3,0,0,0,0,0,0,3,0,0,0,0,0,0,0,3,0,0,3,3,0,0,0,0,0,0,0,0,0,0,0,0],
			[[105,9,-1,-1],[90,9,-1,-1],[55,9,-1,-1],null,null,[31,9,12,6],[43,9,-1,14],[43,9,-1,25],[43,9,-1,25],[43,9,-1,25]]],
			["dombeek",30,23,[0,0,0,4,0,0,0,0,0,0,4,4,0,0,0,0,0,0,4,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0],
			[[81,10,-1,-1],[90,10,-1,-1],[20,10,-1,-1],[20,10,-1,-1],[20,10,-1,-1],[31,10,12,6],[43,10,-1,1],[44,10,-1,11],[41,10,-1,13],[40,10,-1,30]]],
			["murtagh98",35,7,[0,0,5,5,0,0,0,0,0,0,5,0,0,0,5,0,0,0,0,0,0,0,5,5,0,0,0,0,0,0,0,0,0,0,0],
			[[6,11,-1,14],[13,11,-1,17],[20,11,-1,-1],null,null,[40,11,-1,30],[31,11,12,6],[40,11,-1,27],[42,11,-1,17],[42,11,-1,17]]],
			["Hirolla",40,3,[0,0,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0],
			[[105,15,-1,-1,0,0],[88,15,-1,-1,0,0],[22,15,-1,-1,1,0],null,null,[31,15,12,6,0,0],[98,15,12,6,0,0],[33,15,12,6,0,0],[36,15,12,6,0,0],[40,15,-1,30,0,0]]],
			["8z8z",45,21,[0,7,0,0,0,0,0,0,7,7,0,0,0,0,0,0,0,0,7,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[[81,12,-1,-1],[69,12,-1,-1],[20,12,-1,-1/*,NEAR*/],null,null,[40,12,-1,13],[40,12,-1,13],[40,12,-1,13],[43,12,-1,14],[40,12,-1,30]]],
			["Shynygami",50,22,[0,0,0,0,0,0,0,0,8,0,8,8,8,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[[84,13,-1,-1],[65,13,-1,-1],[20,13,-1,-1,0],[23,13,-1,-1/*,FAR*/],[24,13,-1,-1/*,NEAR*/],[53,13,2,6],[53,13,2,6],[42,13,-1,25],[42,13,-1,24],[40,13,-1,30]]],
			["j6u6fu0",55,21,[0,9,0,0,9,0,0,0,9,0,0,0,0,0,0,0,0,0,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[[81,14,-1,-1],[69,14,-1,-1],null,null,null,[42,14,-1,19],[42,14,-1,19],[42,14,-1,19],[42,14,-1,19],[40,14,-1,30]]],
			["AlexD110",60,21,[0,0,0,10,0,0,0,0,0,0,10,0,0,0,10,0,0,0,10,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0],
			[[107,15,-1,-1],[90,15,-1,-1],[20,15,-1,-1],null,null,[42,15,-1,10],[42,15,-1,10],[42,15,-1,10],[42,15,-1,10],[31,15,12,6]]]
			];
			

		
		public var temp:Array=new Array(2);
		
		public static var BUSY:int=0;
		
		public function newChar(_player:SpriteModel,_updateUI=false){
			_player.newPlayer(_updateUI);
			
			_player.saveSlot=GameData.numCharacters;
			_player.flags=new Array();
			for (var i:int=0;i<20;i+=1){
				_player.flags.push(false);
			}
			if (_updateUI){
				Facade.gameM.setupArea(1,0,0,0,1);
			}
		}
		
		public function ascendChar(_player:SpriteModel){
			var prestigeStorage:Array=[Facade.gameM.playerM.equipment,Facade.gameM.playerM.belt,Facade.gameM.playerM.inventory,Facade.gameM.playerM.arts,Facade.gameM.playerM.saveSlot,Facade.gameM.playerM.stash,0/*[Facade.gameM.playerM.limitEquip,Facade.gameM.playerM.limitStored]*/];
			prestigeStorage[7]=_player.skillBlock.getTalentIndex();
			prestigeStorage[8]=_player.label;
			prestigeStorage[9]=_player.flags;
			prestigeStorage[10]=_player.cosmetics;
			prestigeStorage[11]=_player.skillBlock.skillT;
			newChar(_player,true);
			Facade.gameM.setupArea(1,-1,-1,0,1);
			_player.deathsSinceAscension=0;
			_player.respecsSinceAscension=0;
			_player.equipment=prestigeStorage[0];
			_player.belt=prestigeStorage[1];
			_player.inventory=prestigeStorage[2];
			_player.arts=prestigeStorage[3];
			_player.saveSlot=prestigeStorage[4];
			_player.stash=prestigeStorage[5];
			//_player.limitEquip=prestigeStorage[6][0];
			//_player.limitStored=prestigeStorage[6][1];
			_player.skillBlock.addTalent(prestigeStorage[7]);
			_player.label=prestigeStorage[8];
			_player.flags=prestigeStorage[9];
			_player.cosmetics=prestigeStorage[10];
			_player.skillBlock.skillT=prestigeStorage[11];
			
			reloadChar(_player);
		}
		
		public function startLoadChar(_player:SpriteModel,i:int,_updateUI:Boolean=true,_save:Array=null,_listener:Function=null){
			if (i==-1) i=0;
			Facade.menuUI.newChar(false);
			newChar(_player,_updateUI);
			
			if (_save==null){
				if (i<5){
					if (_updateUI && i>=0) GameData.lastChar=i;
					playerToUpdate=_player;
					_player.saveSlot=i;
					GameData.loadCharacter(i,finishLoadChar);
					BUSY+=1;
					if (_listener!=null){
						var _function:Function= function(e:Event){
							if (BUSY<=0){
								BUSY=0;
								_listener();
								Facade.stage.removeEventListener(Event.ENTER_FRAME,_function);
							}
						}
						Facade.stage.addEventListener(Event.ENTER_FRAME,_function);
					}
				}else{
					loadShort(_player,challengeArray(i-5),i);
					if (_listener!=null) _listener();
				}
			}else{
				playerToUpdate=_player;
				_player.saveSlot=i;
				finishLoadChar(_save);
				BUSY+=1;
				if (_listener!=null) _listener();
			}
		}
		
		var playerToUpdate:SpriteModel;
		
		public function finishLoadChar(_save:Array){
			if (_save==null){
				if (playerToUpdate!=null) playerToUpdate.saveSlot=-1;
				BUSY-=1;
				return;
			}
			
			if (playerToUpdate==null || _save==null || _save[0]==null){
				PlayfabAPI.expiredSession();
				PlayfabAPI.expiredMC.display.text="An error has occurred loading your character.  Please refresh the page to continue.";
				return;
			}
			
			if (_save.length<10){
				loadShort(playerToUpdate,_save,playerToUpdate.saveSlot,false);
				BUSY-=1;
				return;
			}
			
			var _player:SpriteModel=playerToUpdate;
			_player.label=_save[0];
			_player.level=_save[1];
			_player.setMaxXP();
			_player.xp=_save[2];
			_player.challenge=_save[14];
			_player.deathsSinceAscension=_save[3];
			_player.respecsSinceAscension=_save[21];
			_player.skillBlock.loadCharacter(_save[13],_save[5],_save[12],_save[4]);
			
			loadItems(_save[6],_player);
			
			if (_save[15]==0) _player.flags=[];
			else _player.flags=_save[15];
			
			Facade.menuUI.shopUI.setItemsFromArray(_save[16],_save[17]);
			
			_player.stash=_save[18];
			loadArtifacts(_save[19],_player);
			if (_save[20]==null){
				_player.loadCosmetics([-1,-1,-1,-1,-1,-1,-1,-1]);
			}else if (_save[20] is Array){
				while(_save[20].length<8) _save[20].push(-1);
				_player.loadCosmetics(_save[20]);
			}else{
				_player.loadCosmetics([-1,-1,-1,-1,-1,-1,-1,-1]);
			}
			
			if (_player.skillBlock.checkTalent(SkillData.UNGIFTED)) _player.skillBlock.skillT[SkillData.WIZARD]=false;
			if (_save[21]!=null){
				//loadLimits(_save[21],_player);
			}
			
			_player.dead=false;
			_player.maxHM();
			
			BUSY-=1;
			
			if (_player.updateUI){
				Facade.gameM.setupArea(_save[8],_save[9],_save[10],_save[11],_save[7]);
				
				Facade.gameUI.background.clear();
			}
			KongregateAPI.submitAll();
			if (_player.level>=60) GameData.maxLevel(_player);
		}
		
		public function loadShort(_player:SpriteModel,_save:Array,i:int=-1,_updateUI:Boolean=false){
			_player.newPlayer(false);
			
			_player.label=_save[0];
			_player.level=_save[1];
			_player.setMaxXP();
			
			_player.saveSlot=i;
			
			_player.skillBlock.loadCharacter(_save[2],_save[3]);
			
			if (_save[5]!=null){
				if (_save[5] is Array){
					loadArtifacts(_save[5],_player);
				}else{
					
				}
				if (_save[6]!=null){
					_player.loadCosmetics(_save[6]);
				}else{
					_player.loadCosmetics();
				}
			}
			
			loadItems(_save[4],_player);
			
			_player.dead=false;
			_player.maxHM();
		}
		
		public function loadChallenge(_player:SpriteModel,i:int,_list:int){
			newChar(_player,false);
			loadShort(_player,challengeArray(i,_list),i+5,false);
		}
		
		public function challengeArray(i:int,_arrayIndex:int=0):Array{
			
			if (_arrayIndex==0){
				var _level:int=Math.floor(i/_Challenge.length);
				i=i%_Challenge.length;
				return levelUpArray(_Challenge[i],_level);
			}else if (_arrayIndex==1){
				_level=Math.floor(i/_Tournament1.length);
				i=i%_Tournament1.length;
				return levelUpArray(_Tournament1[i],_level);
			}
			return null;
		}
		
		public function levelUpArray(a:Array,_level:int):Array{
			if (_level==0){
				return a;
			}else{
				var _temp:Array=GameData.stringToArray(GameData.arrayToString(a));
				_temp[0]=a[0];
				_temp[1]+=(50*_level);
				for (var j:int=0;j<_temp[3].length;j+=1){
					if (_temp[3][j]>0) _temp[3][j]=10;
				}

				for (j=0;j<_temp[4].length;j+=1){
					if (_temp[4][j]!=null) {
						_temp[4][j][1]=Math.floor(_temp[1]/10);
						//_temp[4][j][1]+=_level;
					}
				}
				return _temp;
			}
		}
		
		public function saveTemp(i:int,_v:SpriteModel){
			if ((_v.saveSlot>=0)&&(_v.saveSlot<5)){
				temp[i]=getArray(_v);
			}else{
				temp[i]=getShortArray(_v);
			}
		}
				
		public function loadTemps(i:int=-1){
			if (i!=1){
				startLoadChar(Facade.gameM.playerM,Facade.gameM.playerM.saveSlot,false,temp[0]);
			}
			if (i!=0){
				if (temp[1].length<=7){
					loadShort(Facade.gameM.enemyM,temp[1],Facade.gameM.enemyM.saveSlot);
				}else{
					startLoadChar(Facade.gameM.enemyM,-1,false,temp[1]);
				}
			}
		}
		
		public function reloadChar(_v:SpriteModel){
			var _array:Array=getArray(_v);
			var i:int=_v.saveSlot;
			newChar(_v,_v.updateUI);
			_v.saveSlot=i;
			if (_v.updateUI && i>=0) GameData.lastChar=i;
			if (_v.saveSlot+1 > GameData.numCharacters) GameData.numCharacters=_v.saveSlot+1;
			//_v.saveSlot=i;
			BUSY+=1;
			playerToUpdate=_v;
			finishLoadChar(_array);
			GameData.saveCharacterAll(_v.saveSlot,_array);
		}
		
		public function justSaveChar(_v:SpriteModel=null){
			if (_v==null) _v=Facade.gameM.playerM;
			GameData.saveCharacterJust(_v.saveSlot,getArray(_v));
		}
		
		public function reloadJust(_v:SpriteModel){
			var _array:Array=getArray(_v);
			var i:int=_v.saveSlot;
			newChar(_v,_v.updateUI);
			_v.saveSlot=i;
			BUSY+=1;
			playerToUpdate=_v;
			finishLoadChar(_array);
			GameData.saveCharacterJust(_v.saveSlot,_array);
		}
		
		public function saveFromGame(){
			var _v:SpriteModel=Facade.gameM.playerM;
			if ((_v.saveSlot<0)||(_v.saveSlot>5)) return;
			
			GameData.lastChar=_v.saveSlot;
			GameData.saveCharacterGame(_v.saveSlot,getArray(_v,false));
			if (_v.saveSlot+1 > GameData.numCharacters) GameData.numCharacters=_v.saveSlot+1;
		}
		
		public function saveFromEpic(){
			var _v:SpriteModel=Facade.gameM.playerM;
			
			GameData.lastChar=_v.saveSlot;
			GameData.saveCharacterEpics(_v.saveSlot,getArray(_v));
			if (_v.saveSlot+1 > GameData.numCharacters) GameData.numCharacters=_v.saveSlot+1;
		}
		
		public function saveChar(_v:SpriteModel=null){
			if (_v==null) _v=Facade.gameM.playerM;
			if ((_v.saveSlot<0)||(_v.saveSlot>5)) return;
			
			GameData.lastChar=_v.saveSlot;
			GameData.saveCharacterAll(_v.saveSlot,getArray(_v));
			if (_v.saveSlot+1 > GameData.numCharacters) GameData.numCharacters=_v.saveSlot+1;
		}
		
		public function getArray(_v:SpriteModel,saveProgress:Boolean=true):Array{
			/************************
			* 0 - label
			* 1 - level
			* 2 - cXP
			* 3 - deaths since Ascension
			* 4 - skillT
			* 5 - skills
			* 6 - items
			* 7 - revived zone
			* 8 - area
			* 9 - areaType
			* 10- enemyType
			* 11- eCount
			* 12- skillPoints
			* 13- talent index
			* 14- challenges
			* 15- flags
			* 16- black market
			* 17- premium items
			* 18- stash items
			* 19- artifacts
			* 20- cosmetics
			* 21- respecs since Ascension
			************************/
			return [_v.label,_v.level,_v.xp,_v.deathsSinceAscension,_v.skillBlock.skillT,_v.skillBlock.getSkillArray(),getItems(_v),Facade.gameM.revivedArea,Facade.gameM._Area,
			Facade.gameM._AreaType,Facade.gameM._EnemyType,saveProgress?Facade.gameM._ECount:0,_v.skillBlock.skillPoints,_v.skillBlock.getTalentIndex(),_v.challenge,
			GameData.getFlag(GameData.FLAG_TUTORIAL)?0:_v.flags,Facade.menuUI.shopUI.getBlackArray(),Facade.menuUI.shopUI.getPremiumArray(),_v.stash,getArtifacts(_v),_v.cosmetics,_v.respecsSinceAscension];
		}
		
		public function getShortArray(_v:SpriteModel):Array{
			return [_v.label,_v.level,_v.skillBlock.getTalentIndex(),_v.skillBlock.getSkillArray(),getItems(_v,false),getArtifacts(_v),_v.cosmetics];
		}
		
		public function getTournamentCharacter(_v:SpriteModel):String{
			//var a:Array=getShortArray(_v);
			var m:String="T01x";
			m+="["+_v.label+",";
			m+=numberToChar(_v.level,2)+",";
			m+=numberToChar(_v.skillBlock.getTalentIndex(),1)+",";
			var a:Array=_v.skillBlock.getSkillArray();
			for (var i:int=0;i<a.length;i+=1){
				m+=numberToChar(a[i],1);
			}
			m+=",";
			a=getItems(_v,true);
			for (i=0;i<15;i+=1){
				if (a[i]!=null){
					m+=numberToChar(a[i][0],2);
					m+=numberToChar(a[i][1],2);
					m+=numberToChar(a[i][2],2);
					m+=numberToChar(a[i][3],2);
					m+=numberToChar(a[i][4],1);
				}
				m+=",";
			}
			m+=numberToChar(_v.cosmetics[5],1);
			m+="]";
			return m;
		}
		
		function numberToChar(num:int,digits:int):String{
			var m:String="";
			if (digits==2){
				var tens:int=Math.floor(num/16);
				var ones:int=num%16;
				return (toHex(tens)+toHex(ones));
			}else{
				return toHex(num);
			}
		}
		
		function toHex(num:int):String{
			if (num>=0 && num<=9){
				return String(num);
			}else{
				switch (num){
					case -1: return "z";
					case -2: return "y";
					case 10: return "a";
					case 11: return "b";
					case 12: return "c";
					case 13: return "d";
					case 14: return "e";
					case 15: return "f";
					default: return "M";
				}
			}
			return "M";
		}

		function getItems(_v:SpriteModel,_inv:Boolean=true):Array{
			if (_inv){
				var _items:Array=new Array(30);
			}else{
				_items=new Array(10);
			}
			for (var i:int=0;i<5;i+=1){
				if (_v.equipment[i]!=null) _items[i]=_v.equipment[i].exportArray();
				if (_v.belt[i]!=null) _items[i+5]=_v.belt[i].exportArray();
			}
			
			if (_inv){
				for (i=0;i<20;i+=1){
					if (_v.inventory[i]!=null) _items[i+10]=_v.inventory[i].exportArray();
				}
			}
			return _items;
		}
		
		function getLimits(_v:SpriteModel):Array{
			var _limits:Array=new Array(13);
			
			for (var i:int=0;i<_v.limitEquip.length;i+=1){
				if (_v.limitEquip[i] is LimitModel){
					_limits[i]=saveLimit(_v.limitEquip[i]);
				}else{
					_limits[i]=_v.limitEquip[i];
				}
			}
			for (i=0;i<_v.limitStored.length;i+=1){
				if (_v.limitStored[i] is LimitModel){
					_limits[i+3]=saveLimit(_v.limitStored[i]);
				}else{
					_limits[i+3]=_v.limitStored[i];
				}
			}
			return _limits;
		}
		
		public function exportSave(_v:SpriteModel):String{
			var _a:Array=getShortArray(_v);
			var _string:String=GameData.arrayToString(_a);
			return _string;
		}
		
		public function importSave(_player:SpriteModel,_string:String){
			var _a:Array=GameData.stringToArray(_string);
			_player=loadShort(_player,_a,-1,false);
		}
		
		public function loadItems(_a:Array,_o:SpriteModel=null){
			if (_o==null) _o=Facade.gameM.playerM;
			
			for (var i:int=0;i<_a.length;i+=1){				
				if ((_a[i]==null)||(_a[i][0]<0)) continue;
				var m:ItemModel=ItemModel.importArray(_a[i]);
				_o.addItemAt(m,i);
			}
		}
		
		public function getArtifacts(_v:SpriteModel):Array{
			var _arts:Array=new Array(5);
			if (_v.arts==null) return [];
			
			for (var i:int=0;i<_v.arts.length;i+=1){
				if (_v.arts[i] is ArtifactModel){
					_arts[i]=_v.arts[i].exportArray();
				}else{
					_arts[i]=_v.arts[i];
				}
			}
			return _arts;
		}
		
		public function loadArtifacts(_a:Array,_o:SpriteModel=null){
			if (_o==null) _o=Facade.gameM.playerM;
			
			for (var i:int=0;i<_a.length;i+=1){
				if (_a[i] is Array){
					var m:ArtifactModel=ArtifactModel.importArray(_a[i]);
					_o.addArtifactAt(m,i);
				}else{
					_o.arts[i]=_a[i];
				}
			}
		}
		
		public function saveLimit(_v:LimitModel):Array{
			if (_v==null){
				return null;
			}
			var m:Array=[_v.index,_v.charges];
			return m;
		}
		
		public function loadLimits(_a:Array,_o:SpriteModel=null){
			if (_o==null) _o=Facade.gameM.playerM;
			
			for (var i:int=0;i<_a.length;i+=1){
				if (_a[i] is Array){
					var m:LimitModel=loadLimit(_a[i]);
					_o.addLimitAt(m,i);
				}else{
					_o.addLimitAt(_a[i],i);
				}
			}
		}
		
		public function loadLimit(_a:Array):LimitModel{
			var m:LimitModel=LimitData.spawnLimit(_a[0],_a[1]);
			
			return m;
		}
	}
}