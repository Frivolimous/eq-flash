package hardcore{
	//For the hardcore challenge event, also with HardcoreHomeUI
	//wizard challenge version
	import flash.events.Event;
	import flash.display.Sprite;
	import items.ItemData;
	import items.ItemView;
	import items.ItemModel;
	import flash.geom.Matrix;
	import ui.GameUI;
	import ui.windows.EndWindow;
	import ui.assets.TutorialWindow;
	import utils.GameData;
	import ui.effects.FlyingText;
	import gameEvents.*;
	import ui.windows.ConfirmWindow;
	import system.buffs.BuffData;
	import system.actions.ActionBase;
	import system.effects.EffectBase;
	import system.effects.EffectData;
	import utils.NoSteamXAPI;
	import ui.assets.AchievementDisplay;
	
	public class HardcoreGameControl extends GameControl{
		/*public static const TURN_LENGTH:int=30;
		public static const BUFF_DELAY:int=10;

		public var gameM:GameModel;
		public var gameV:Sprite;
		public var gameUI:GameUI;
		
		public var delay:int;
		var spawn:int;
		public var turboB:Boolean;
		public var running:Boolean;
		
		public var roundWait:Boolean=false;*/
		override public function playerDead(_v:SpriteModel){
			if (!running) return;
			//You Die!
			
			NoSteamXAPI.deletePlayerData(["player-100"]);
			Facade.gameM.playerM.saveSlot=-1;
			if (gameUI.goingTown){
				gameUI.navOut();
			}else{
				new EndWindow("You have died!\nYour challenge is ended... sorry... :(",navOut,navOut,false);
			}
		}
		
		override public function enemyDead(_o:SpriteModel, _t:SpriteModel){
			gameM.turn=true;
			
			gameUI.background.addObject(gameM.enemyM.view.getBitmap());
			gameM.enemyM.exists=false;
			gameM.enemyM.view.parent.removeChild(gameM.enemyM.view);
			//gameUI.updateStatus(gameM.playerM);
			gameUI.updateStatus(gameM.enemyM,true);
			
			gameM.distance=GameModel.BETWEEN;
			gameM.playerM.attackTarget=null;
			gameM.enemyM.attackTarget=null;
			var _effect:EffectBase=gameM.playerM.stats.findDisplay(EffectData.FIND_STACKS);
			if (_effect!=null){
				gameM.playerM.craftB+=_effect.values;
				new FlyingText(gameM.playerM,"Found Stacks!",0xaaffaa);
			}
			gameM.playerM.buffList.clearEndFight();
			
			if (gameM.eCount==gameM.eTotal){
				getBossReward();
				nextLevel();
			}else{
				getMobReward();
				GameData.saveCharacterGame(Facade.gameM.playerM.saveSlot,Facade.saveC.getArray(Facade.gameM.playerM));
			}
		}
		
		function getZoneItemLevel(_zone:int):int{
			var m:int=_zone/10;
			for (var i:int=10;m>i;i+=10){
				m=i+(m-i)/2;
			}
			return Math.min(m,25);
		}
		
		function zoneLevelup(_zone:int):Boolean{
			var i:int=_zone+20;
			var mod:int=0;
			while (i>20){
				i/=1.75;
				mod+=1;
			}
			if (_zone%mod==0) return true;
			
			return false;
		}
		
		function findItem(level:int):ItemModel{
			var m:ItemModel;
			switch(Math.floor(Math.random()*14)){
				case 0: case 1: case 2: //weapon
					m=ItemData.spawnItem(level,weapons[Math.floor(Math.random()*weapons.length)]);
					a=[0,3,4,6,7,8,9,10,11,12,13,14,100];
					ItemData.enchantItem(m,a[Math.floor(Math.random()*a.length)]);
					break;
				case 3: case 4: case 5://hat
					m=ItemData.spawnItem(level,helmets[Math.floor(Math.random()*helmets.length)]);
					a=[15,17,19,20,21,22,23,25,27,28,29];
					ItemData.enchantItem(m,a[Math.floor(Math.random()*a.length)]);
					break;
				case 10: case 11: // spell
					var i:int=spells[Math.floor(Math.random()*spells.length)];
					m=ItemData.spawnItem(level,i);
					break;
				case 6: case 7:  // throwing
					i=37+Math.floor(Math.random()*2);
					m=ItemData.enchantItem(ItemData.spawnItem(level,i),6);
					a=[0,1,2,3,4,6,7,8,9,10,11,12,13,14,100];
					ItemData.enchantItem(m,a[Math.floor(Math.random()*a.length)]);
					break;
				case 8: case 9: //charm
					var j:int;
					var a:Array;
					i=prefixes[Math.floor(Math.random()*prefixes.length)];
					switch(i){
						case 11: case 12: case 13: case 27: case 28: case 29: j=40; break;
						case 3: case 4: case 7: case 8: case 9: case 10: j=41; break;
						case 5: case 15: case 17: case 19: case 24: case 26: j=42; break;
						case 1: case 2: case 14: case 16: case 18: j=43; break;
						case 6: case 20: case 21: case 22: case 23: case 25: j=44; break;
					}
					m=ItemData.enchantItem(ItemData.spawnItem(level,j),i);
					break;
				case 12: //heal pot
					m=ItemData.enchantItem(ItemData.spawnItem(level,31),6);
					break;
				case 13: //buff potion
					i=Math.floor(Math.random()*4);
					switch(i){
						case 0: i=33; break;
						case 1: i=96; break;
						case 2: i=98; break;
						case 3: i=99; break;
					}
					m=ItemData.enchantItem(ItemData.spawnItem(level,i),6);
					break;
				default: null;
			}
			suffixItem(m);
			return m;
		}
		
		function findPremium(level:int):ItemModel{
			var m:ItemModel;
			switch(Math.floor(Math.random()*10)){
				case 0:
					if (Math.random()<0.5){
						m=ItemData.enchantItem(ItemData.spawnItem(level,weapons[Math.floor(Math.random()*weapons.length)]),shadowWeap[Math.floor(Math.random()*shadowWeap.length)]);
					}else{
						m=ItemData.enchantItem(ItemData.spawnItem(level,helmets[Math.floor(Math.random()*helmets.length)]),shadowHat[Math.floor(Math.random()*shadowHat.length)]);
					}
					break;
				case 1: case 2:
					var _premAlt:Array=premAlts[Math.floor(Math.random()*premAlts.length)];
					m=ItemData.enchantItem(ItemData.spawnItem(level,_premAlt[0]),_premAlt[1]);
					break;
				case 3:
					_premAlt=spellAlts[Math.floor(Math.random()*spellAlts.length)];
					m=ItemData.enchantItem(ItemData.spawnItem(level,_premAlt[0]),_premAlt[1]);
					break;
				case 4:
					_premAlt=potAlts[Math.floor(Math.random()*potAlts.length)];
					m=ItemData.enchantItem(ItemData.spawnItem(level,_premAlt[0]),_premAlt[1]);
				default:
					m=ItemData.spawnItem(level,premiums[Math.floor(Math.random()*premiums.length)]);
					break;
			}
			
			suffixItem(m);
			return m;
		}
		
		var weapons:Array=[0,1,3,6,7,8];
		var helmets:Array=[9,11,12,13];
		var spells:Array=[18,19,20,22,24,25,26,29];
		
		var premiums:Array=[64,66,68,69,71,88,89,90,91,101,102,103,104,115,117,121,124,133,72, 73, 75, 
							79, 80,85,86,87,105,107,111,114,95,113,137,138,140,143];
		
		var premAlts:Array=[[66,0],[66,1],[68,0],[68,1],[68,2],[68,3],[69,0],[71,0],[72,0],[79,0],[79,1],[80,0],[85,0],[86,0],
							[87,0],[87,1],[87,2],[88,0],[89,0],[90,0],[91,0],[91,1],[91,2],[91,3],[95,0],[101,0],[102,0],
							[103,0],[103,1],[103,2],[104,0],[105,0],[107,0],[107,1],[107,2],[110,1],[112,0],[113,0],[113,1],[113,2],[113,3],
							[115,0],[117,0],[122,0],[123,0],[124,0],[124,1],[133,0],[133,1],[133,2],[133,3],[133,4],[137,0],[138,0],[138,1],
							[141,2],[143,0],[144,0],[40,30],[40,31]];
							
		var spellAlts:Array=[[20,0],[21,0],[22,0],[23,0],[24,0],[25,0],[25,1],[25,2]];
		var potAlts:Array=[[31,0],[31,1],[33,0],[35,1],[96,0],[97,0],[99,0]];
		
		var shadowWeap:Array=[15,18,20];
		var shadowHat:Array=[8,9,10,11,13];
		
		var prefixes:Array=[0,3,4,6,7,8,9,10,11,12,13,14,15,17,19,20,21,22,23,25,27,28,29];
		var suffixes:Array=[0,3,4,6,7,8,9,10,11,12,13,14,15,17,19,20,21,22,23,25,27,28,29,
							64,66,68,69,71,72,73,74,75,76,77,78,79,80,81,85,86,87,88,89,90,
							91,93,94,101,102,103,104,105,106,107,109,112,113,114,115,116,117,
							121,123,124,129,132,133,137,138,140,143];
		
		function suffixItem(m:ItemModel){
			var _suffix:int;
			if (m.primary==ItemData.POTION){
				do{
					_suffix=42+Math.floor(Math.random()*12);
				}while(!ItemData.testSuffix(m,_suffix));
				ItemData.suffixItem(m,_suffix);
			}else if (m.primary==ItemData.MAGIC){
				do{
					_suffix=30+Math.floor(Math.random()*12);
				}while(!ItemData.testSuffix(m,_suffix));
				ItemData.suffixItem(m,_suffix);
			}else if (m.primary==ItemData.CHARM){
				ItemData.suffixItem(m,prefixes[Math.floor(Math.random()*prefixes.length)]);
			}else{
				do{
					_suffix=suffixes[Math.floor(Math.random()*suffixes.length)];
				}while(!ItemData.testSuffix(m,_suffix));
				ItemData.suffixItem(m,_suffix);
			}
		}
		
		/*
		base weapons:
0	Greatsword
1	Battle Axe
3	Short Swords
6	Sw & Shield
7	Ax & Shield
8	Mace & Shield

base hats:
9	Bandana
11	Cap
12	Helm
13	Armet

spells:
18	Poison Bolt
19	Confusion
20	Cripple
22	Healing
24	Haste
25	Enchant Weapon
26	Berzerk
29	Terrify

Alts:
20	0
21	0
22	0
23	0
24	0
25	0,1,2

potions:
31	Healing
33	Amplify
97	Celerity
98	Turtle
99	Purity

Alts:
31	0,1
33	0
35	1
96	0
97	0
99	0

throwing:
37	Daggers
38	Axe

charms:
40-44	Any

scrolls
none

Prem Helms
Kabuto, Phrygian, Boxing Gear, Turban, Protector
Mullet, Ampersand, Death Jester, Envenomed Mask
Riot Helm, Hell Horns, Hockey Mask, Propeller Beanie
Crusader Helm, Demon Horns
Tramp, Sapien, Fukumen

64,66,68,69,71
88,89,90,91
101,102,103,104
115,117
121,124,133

Prem Weapons
Katanas, Light Sword, Hylian Sword, Mjolnir, Captain's Shield
Baseball Bat, Breaker Sword, Board with a Nail
Riot Gear, Chainsaw, DHS
Crusader Mace

72, 73, 75, 79, 80
85,86,87
105,107,111
114

Prem Other
Chakram, Grail
Screamer, Puzzling, Muzzle, Monacle

95,113
137,138,140,143

Alts:
66	0,1	Phrygian
68	0,1,2,3	Boxing
69	0	Turban
71	0	Protector

72	0	Katana
79	0,1	Mjolnir
80	0	Captain
85	0	Baseball
86	0	Breaker
87	0,1,2	Board

88	0	Mullet
89	0	Ampersand
90	0	Jester
91	0,1,2,3	Envenomed
95	0	Chakram
101	0	Riot Helm
102	0	Hell Horns
103	0,1,2	Hockey
104	0	Beanie
105	0	Riot Shield
107	0,1,2	Chainsaw
110	1	Hood
112	0	Pentagram
113	0,1,2,3	Grail
115	0	Crusader
117	0	Demon Horns
122	0	Princess
123	0	Rasta
124	0,1	Sapien
133	0,1,2,3,4 Fukumen
137	0	Screamer
138	0,1	Puzzling
141	2	Visor
143	0	Monacle
144	0	Goggles
40	30,31	Shadow Statue

Enchantments:
Weap: 0,3,4,6,7,8,9,10,11,12,13,14
Helm: 15,17,19,20,21,22,23,25,27,28,29

Shadow:
Weap: 15,16,18,20
Helm: 7,10,12,13

Suffixes:
Magic: 35,36,38,39,40,41
Alchemy: 42,44,48,49,50,51

Prem:
64,66,68,69,71,72,73,74,75,76,77,78,79,80,81,85,86,87,88,89,90,91,93,94,101,102,103,104,105,106,107,109,112,113,114,115,116,117,121,123,124,129,132,133,137,138,140,143
		*/
		
		function getBossReward(){
			gameUI.addItem(new ItemView(findPremium(getZoneItemLevel(gameM.area))),-1,true);
			gameUI.progress+=1;
			
			if (gameM.playerM.level<70 && zoneLevelup(gameM.area)){
				gameM.playerM.levelup();
			}
			
			if (gameM.area>100 && gameM.area<=400 && (gameM.area-100)%20==0){
				new AchievementDisplay(316);
			}
			switch(gameM.area){
				case 50:
					gameM.playerM.arts[1]=null;
					new AchievementDisplay(317);
					break;
				case 100:
					gameM.playerM.arts[3]=null;
					new AchievementDisplay(317);
					break;
				case 150:
					gameM.playerM.arts[0]=null;
					new AchievementDisplay(317);
					break;
				case 250:
					gameM.playerM.arts[4]=null;
					new AchievementDisplay(317);
					break;
			}
		}
			
		public function getArtifactLevel(_zone:int):int{
			return Math.min(Math.max((_zone-100)/20,0),10)
		}
		
		function getHealthRatio(_zone:int):Number{
			var m:Number=0.5+_zone/200;
			return Math.min(3,m);
		}
		
		function getMobReward(){
			gameUI.addItem(new ItemView(findItem(getZoneItemLevel(gameM.area))),-1,true);
			gameUI.progress+=1;
			GameData.addScore(GameData.SCORE_KILLS,1);
		}
		
		override public function nextLevel(_areaType:int=-1){
			gameUI.background.addLast();
			
			do{
				var _aType:int=Math.floor(Math.random()*3);
			}while(_aType==gameM.areaType);
			do{
				var _eType:int=Math.floor(Math.random()*3);
			}while(_eType==gameM.enemyType);
			gameM.setupArea(gameM.area+1,_aType,_eType);
			
			gameM.deathStreak=0;
			spawn=99;
			for (var i:int=0;i<Facade.gameM.playerM.belt.length;i+=1){
				var _item:ItemModel=Facade.gameM.playerM.belt[i];
				if (_item!=null){
					if (_item.slot==ItemData.USEABLE && _item.charges>=0 && _item.charges<_item.maxCharges()){
						_item.charges=_item.maxCharges();
					}
				}
			}
			GameData.setHardcore(gameM.area);
			GameEventManager.addGameEvent(GameEvent.CHALLENGE_AREA_REACHED,gameM.area);
			
			GameData.saveCharacterGame(Facade.gameM.playerM.saveSlot,Facade.saveC.getArray(Facade.gameM.playerM));
		}
		
		override public function newEnemy(){
			EnemyData.newCreature(gameM.enemyM);
			gameM.enemyM.stats.addValue(StatModel.HEALTH,gameM.enemyM.stats.getValue(StatModel.HEALTH)*getHealthRatio(gameM.area));
			gameM.enemyM.maxHM();
			gameM.enemyM.view.y=GameUI.FLOOR_Y;
			gameM.enemyM.view.x=GameUI.VIEW_WIDTH+100;
			gameV.addChild(gameM.enemyM.view);
		}

		override public function newBoss(){
			EnemyData.newBoss(gameM.enemyM);
			gameM.enemyM.stats.addValue(StatModel.HEALTH,gameM.enemyM.stats.getValue(StatModel.HEALTH)*getHealthRatio(gameM.area));
			gameM.enemyM.maxHM();
			gameM.enemyM.view.y=GameUI.FLOOR_Y;
			gameM.enemyM.view.x=GameUI.VIEW_WIDTH+50;
			gameV.addChild(gameM.enemyM.view);
			GameEventManager.addGameEvent(GameEvent.ENCOUNTER_BOSS,gameM.enemyM);
		}
		
		public static var eliminated:Array=["shanekukacka","killaruna66","ThePokemonMew","Checkursyx","dja410","JustinL637","wazzur","Krelian970","denbart93","Zianzix","gromanakk","8z8z","slaaackin","Lycantroph","LSpike","WoeWei","KeithP23","nn330303","tocooljim","huangex","Captain_Catface","lounsbery","yamahaclavinova1","squetle","squidie","User2351","kbzalol","swordyo","Battenberger","KuroShiroi","brakerboi","keldariel","marcostonelo","demonspawn0001","Rygaive461","jubssmadder","fasman1234","lordasmodai","heybob","ICONAT","rjfc","frithjofbau","zver8","ChiefFishy","777588","Oooooo661","deathtyrant","WolfPackXV","OneWingedDevil","TitusLeoL"];
		public static function getEliminatedPosition():int{
			var _name:String=NoSteamXAPI.getName();
			for (var i:int=0;i<eliminated.length;i+=1){
				if (eliminated[i]==_name){
					 return 1+i;
				}
			}
			return 99;
		}
	}
}