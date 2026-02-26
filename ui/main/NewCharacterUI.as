package ui.main{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import ui.windows.ConfirmWindow;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import items.ItemData;
	import skills.SkillData;
	import ui.assets.*;
	import flash.text.TextField;
	import utils.GameData;
	import utils.AchieveData;
	import ui.StatusUI;
	import skills.SkillTreeWindow;
	import hardcore.HardcoreHomeUI;
	
	public class NewCharacterUI extends BaseUI{
		var gameM:GameModel=Facade.gameM;
		public var homeUI:BaseUI;

		var charView:SpriteModel=new SpriteModel();
		var blinkLine:Sprite=new Sprite;
		
		var talents:Array=new Array(10);
		var cTalent:int;
		var count:int=10;
		
		var prestige:Boolean=false;
		var prestigeStorage:Array;
		public var saveSlot:int=-1;
		
		public function NewCharacterUI(_home:BaseUI){
			homeUI=_home;
			
			talents=[talent0,talent1,talent2,talent3,talent4,talent5,talent6,talent7,talent8,talent9];
			for (var i:int=0;i<10;i+=1){
				talents[i].update(SkillData.talentName[i],selectTalent,true);
				talents[i].index=i;
			}
			
			charView.view.x=480;
			charView.view.y=250;
			addChild(charView.view);
			
			doneB.update(StringData.SAVE,navSave);
			cancelB.update(StringData.CANCEL,navCancel);
			soundB.update(null,muteSound,true);
			
			blinkLine.graphics.lineStyle(3,inputName.textColor);
			blinkLine.graphics.moveTo(0,0);
			blinkLine.graphics.lineTo(0,18);
			blinkLine.y=inputName.y+7;
			addChild(blinkLine);
		}
		
		public function fromPrestige(_level:int=0,_area:int=0){
			prestige=true;
			prestigeStorage=[Facade.gameM.playerM.equipment,Facade.gameM.playerM.belt,Facade.gameM.playerM.inventory,Facade.gameM.playerM.arts,Facade.gameM.playerM.saveSlot,Facade.gameM.playerM.stash,Facade.gameM.playerM.flags,[Facade.gameM.playerM.limitEquip,Facade.gameM.playerM.limitStored],_area,_level,Facade.gameM.playerM.cosmetics,Facade.gameM.playerM.skillBlock.skillT];
			displayName.text=Facade.gameM.playerM.label;
			selectTalent(Facade.gameM.playerM.skillBlock.getTalentIndex());
		}
		
		public function onTick(e:Event){
			count-=1;
			if (count==10){
				blinkLine.visible=false;
			}else if (count==0){
				blinkLine.visible=true;
				count=20;
			}
		}
		
		public function keyDown(e:KeyboardEvent){
			if (e.keyCode==8){
				if (inputName.length>0){
					
					inputName.text=inputName.text.substring(0,inputName.text.length-1);
					//inputName.backspace();
					blinkLine.x=inputName.x+inputName.textWidth+5;
					if (inputName.length==0){
						doneB.disabled=true;
					}
				}
			}else if (e.keyCode==13){
				if (inputName.length>0){
					if (skillWindow!=null){
						finishSave();
					}else{
						navSave();
					}
				}
			}else if (inputName.length<10){
				var letter:String=String.fromCharCode(e.charCode);
				if (letter.match(/\w/)){
					inputName.appendText(letter);
					blinkLine.x=inputName.x+inputName.textWidth+5;
					doneB.disabled=false;
				}
			}
		}
				
		public function selectTalent(i:int){
			if (!talents[i].disabled){
				if (!talents[i].toggled){
					talents[cTalent].toggled=false;
					talents[i].toggled=true;
					cTalent=i;
					gameM.playerM.skillBlock.addTalent(i);
					if (!prestige) reEquip(i);
					display(gameM.playerM);
					nameTitle.text=gameM.playerM.title;
					desc1.text=StringData.talent(gameM.playerM.skillBlock.getTalentIndex());
					desc2.htmlText=StringData.talentDesc(gameM.playerM.skillBlock.getTalentIndex());
				}
			}else{
				new ConfirmWindow(StringData.CONF_LOCKED);
			}
		}
		
		var skillWindow:SkillTreeWindow;
		public function navSave(){
			if (GameData.getFlag(GameData.FLAG_TUTORIAL)){
				if (skillWindow==null || skillWindow.parent==null){
					skillWindow=new SkillTreeWindow(gameM.playerM,finishSave);
					addChild(skillWindow);
				}
			}else{
				finishSave();
			}
		}
		
		public function finishSave(){
			if (Facade.DEBUG){
				if (inputName.text.substr(0,4)=="TEST"){
					gameM.playerM.skillBlock.skillPoints=59;
					gameM.playerM.level=59;
					gameM.playerM.levelup();
					gameM.souls=100000;
					gameM.playerM.addItem(ItemData.spawnItem(0,31,-1));
					gameM.playerM.addItem(ItemData.spawnItem(15,26));
					gameM.playerM.addItem(ItemData.enchantItem(ItemData.spawnItem(0,40),30));
					gameM.playerM.addItem(ItemData.enchantItem(ItemData.spawnItem(0,40),30));
					gameM.playerM.addItem(ItemData.enchantItem(ItemData.spawnItem(0,40),30));
					gameM.playerM.addItem(ItemData.enchantItem(ItemData.spawnItem(0,40),30));
					gameM.playerM.addItem(ItemData.enchantItem(ItemData.spawnItem(0,40),30));
					if (inputName.text.length>4){
						gameM.area=int(inputName.text.substring(4));
					}
				}else if (inputName.text=="ARTIFACT"){
					gameM.playerM.skillBlock.skillPoints=60;
					gameM.playerM.level=60;
					gameM.souls=100000;
					for (i=0;i<GameData.artifacts.length;i+=1){
						GameData.artifacts[i]=0;
					}
				}else if (inputName.text=="BOSS"){
					gameM.playerM.skillBlock.skillPoints=50;
					gameM.playerM.level=50;
					gameM.playerM.challenge=[9,7];
					gameM.eCount=7;
				}else if (inputName.text=="EXHIBIT"){
					//Facade.menuUI.addChild(Facade.menuUI.exhibitionB);
				}else if (inputName.text=="ACHIEVE"){
					AchieveData.achieve(313);
				}else if (inputName.text=="MAGIC"){
					for (var i:int=14;i<26;i+=1){
						gameM.playerM.addItem(ItemData.spawnItem(0,i));
					}
					
					gameM.playerM.addItem(ItemData.enchantItem(ItemData.spawnItem(0,39),20));
					gameM.playerM.skillBlock.skillPoints=50;
					gameM.playerM.level=50;
					gameM.playerM.challenge=[9,7];
				}else if (inputName.text.substring(0,6)=="SHADOW"){
					Facade.gameM.area=int(inputName.text.substring(6,9));
					Facade.gameM.areaType=Facade.gameM.enemyType=3;
					Facade.gameM.eCount=Facade.gameM.eTotal;
					gameM.playerM.level=50;
					gameM.playerM.skillBlock.skillPoints=50;
					for (i=0;i<20;i+=1){
						gameM.playerM.addItem(ItemData.enchantItem(ItemData.spawnItem(0,2),i));//ItemData.randomItem(ItemData.WEAPON,0),i));
					}
				}else if (inputName.text=="WEAPON"){
					gameM.playerM.level=50;
					gameM.playerM.skillBlock.skillPoints=50;
					for (i=0;i<20;i+=1){
						gameM.playerM.addItem(ItemData.enchantItem(ItemData.spawnItem(0,2),i));
					}
				}else if (inputName.text=="HELMET"){
					gameM.playerM.skillBlock.skillPoints=50;
					gameM.playerM.level=50;
					for (i=15;i<30;i+=1){
						gameM.playerM.addItem(ItemData.enchantItem(ItemData.spawnItem(0,10),i));
					}
				}else if (inputName.text=="CHARM1"){
					for (i=0;i<=15;i+=1){
						var j:int=0;
						switch(i){
							case 11: case 12: case 13: case 27: case 28: case 29: j=40; break;
							case 3: case 4: case 7: case 8: case 9: case 10: j=41; break;
							case 5: case 15: case 17: case 19: case 24: case 26: j=42; break;
							case 1: case 2: case 14: case 16: case 18: j=43; break;
							case 6: case 20: case 21: case 22: case 23: case 25: j=44; break;
						}
						gameM.playerM.addItem(ItemData.enchantItem(ItemData.spawnItem(0,j),i));
					}
				}else if (inputName.text=="CHARM2"){
					for (i=16;i<30;i+=1){
						j=0;
						switch(i){
							case 11: case 12: case 13: case 27: case 28: case 29: j=40; break;
							case 3: case 4: case 7: case 8: case 9: case 10: j=41; break;
							case 5: case 15: case 17: case 19: case 24: case 26: j=42; break;
							case 1: case 2: case 14: case 16: case 18: j=43; break;
							case 6: case 20: case 21: case 22: case 23: case 25: j=44; break;
						}
						gameM.playerM.addItem(ItemData.enchantItem(ItemData.spawnItem(0,j),i));
					}
				}else if (inputName.text=="EQUIP"){
					for (i=0;i<14;i+=1){
						gameM.playerM.addItem(ItemData.spawnItem(0,i));
					}
				}else if (inputName.text=="STACK"){
					for (i=0;i<7;i+=1){
						gameM.playerM.addItem(ItemData.spawnItem(0,31,1));
					}
					for (i=0;i<7;i+=1){
						gameM.playerM.addItem(ItemData.spawnItem(1,31,1));
					}
					gameM.playerM.level=50;
					gameM.playerM.addItem(ItemData.enchantItem(ItemData.spawnItem(0,40),20));
				}else if (inputName.text=="FOREST"){
					gameM.areaType=0;
				}else if (inputName.text=="DESERT"){
					gameM.areaType=1;
				}else if (inputName.text=="DEMON"){
					gameM.areaType=2;
				}else if (inputName.text=="PREMIUM"){
					for (i=64; i<=148;i+=1){
						gameM.addOverflowItem(ItemData.spawnItem(0,i));
					}
					gameM.playerM.skillBlock.skillPoints=59;
					gameM.playerM.level=59;
					gameM.playerM.levelup();
				}else if (inputName.text=="DLC"){
					AchieveData.unlockDLCCosmetics();
				}
			}
			
			gameM.playerM.deathsSinceAscension=0;
			
			if (prestige){
				var _player:SpriteModel=gameM.playerM;
				var _talent:int=_player.skillBlock.getTalentIndex();
				var _skillTree:Array=_player.skillBlock.skillT;
				Facade.saveC.newChar(_player);
				gameM.playerM.skillBlock.loadCharacter(_talent,null,0,_skillTree);
				
				if (contains(displayName)){
					_player.label=displayName.text;
				}else{
					_player.label=inputName.text;
				}
				
				
				_player.equipment=prestigeStorage[0];
				_player.belt=prestigeStorage[1];
				_player.inventory=prestigeStorage[2];
				_player.arts=prestigeStorage[3];
				_player.saveSlot=prestigeStorage[4];
				_player.stash=prestigeStorage[5];
				_player.flags=prestigeStorage[6];
				_player.limitEquip=prestigeStorage[7][0];
				_player.limitStored=prestigeStorage[7][1];
				Facade.gameM.setupArea(prestigeStorage[8],-1,-1,0,prestigeStorage[8]);
				gameM.playerM.level=prestigeStorage[9];
				if (prestigeStorage[9]>1){
					gameM.playerM.skillBlock.skillPoints=prestigeStorage[9];
					if (gameM.playerM.skillBlock.checkTalent(SkillData.NOBLE)){
						gameM.playerM.skillBlock.skillPoints+=Math.floor(prestigeStorage[9]/12);
					}
				}
				_player.cosmetics=prestigeStorage[10];
				_player.skillBlock.skillT=prestigeStorage[11];
				//Facade.saveC.reloadChar(_player);
			}else{
				gameM.playerM.label=inputName.text;
				if (GameData.getFlag(GameData.FLAG_TUTORIAL)){
					gameM.playerM.addItemAt(ItemData.spawnItem(0,31,6),5);
					if (!gameM.playerM.skillBlock.checkTalent(SkillData.UNGIFTED)){
						gameM.playerM.addItemAt(ItemData.startingItem(gameM.playerM.skillBlock.getTalentIndex(),ItemData.MAGIC),2);
						gameM.playerM.addItemAt(ItemData.spawnItem(0,32,6),6);
					}
					gameM.playerM.addItemAt(ItemData.startingItem(gameM.playerM.skillBlock.getTalentIndex(),ItemData.THROW),7);
					gameM.playerM.addItem(ItemData.spawnItem(1,45));
				}else{
					Facade.menuUI.newChar();
				}
				//Facade.saveC.saveChar(gameM.playerM);
				Facade.gameM.setupArea(1,0,0,0,1);
			}
			
			if (gameM.playerM.skillBlock.checkTalent(SkillData.UNGIFTED)){
				gameM.playerM.skillBlock.skillT[2]=false;
			}
			
			navOut();
			GameData.addScore(GameData.SCORE_CHARS,1);
			Facade.menuUI.shopUI.restock();

			if (saveSlot==-1){
				new FadeTransition(this,Facade.menuUI);
			}else{
				/*gameM.playerM.level=60;
				gameM.playerM.skillBlock.skillPoints=60;
				gameM.playerM.challenge=[20,16];*/
				gameM.playerM.saveSlot=saveSlot;
				gameM.playerM.arts=[false,false,null,false,false];
				(homeUI as HardcoreHomeUI).popArtifacts();
				//new FadeTransition(this,homeUI);
				//if (gameM.playerM.skillBlock.checkTalent(SkillData.NOBLE)) gameM.playerM.skillBlock.skillPoints+=5;
				//new FadeTransition(this,new StatusUI(homeUI,gameM.playerM));
			}
		}
		
		public function popRename(){
			new ConfirmWindow("Rename your character?",50,50,finishRename);
		}
		
		public function finishRename(i:int=0){
			removeChild(displayName);
			removeChild(renameB);
			
			addChild(inputBG);
			addChild(inputName);
			addChild(blinkLine);
			inputName.text=displayName.text;
			blinkLine.x=inputName.x+inputName.textWidth+5;
			
			addEventListener(Event.ENTER_FRAME,onTick);
			Facade.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
			Facade.stage.focus=Facade.stage;
		}
		
		override public function openWindow(){
			soundB.toggled=Facade.soundC.mute;
			
			if (!prestige){
				if (contains(displayName)) removeChild(displayName);
				if (contains(renameB)) removeChild(renameB);
				addEventListener(Event.ENTER_FRAME,onTick);
				Facade.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
				Facade.stage.focus=Facade.stage;
			
				Facade.saveC.newChar(Facade.gameM.playerM,true);
				if (saveSlot!=-1) Facade.gameM.playerM.saveSlot=saveSlot;
				reEquip(0);
				inputName.text="Hero";
				blinkLine.x=inputName.x+inputName.textWidth+5;
				
				selectTalent(0);
			}else{
				if (contains(inputBG)){
					removeChild(inputBG);
				}
				if (contains(blinkLine)){
					removeChild(blinkLine);
				}
				if (contains(inputName)) removeChild(inputName);
				
				renameB.update("Rename",popRename);
				renameB.setDesc("Rename Character","Give your new character a new name?");
			}
			
			display(gameM.playerM);
			
			doneB.disabled=false;
			
			talents[0].setDesc(talents[0].label.text+StringData.locked(0,false),StringData.talentDesc(0));
			for (var i:int=1;i<10;i+=1){
				talents[i].disabled=!AchieveData.hasAchieved(i-1);
				if (talents[i].disabled){
					talents[i].setDesc(talents[i].label.text+StringData.locked(0,true),StringData.talentDesc(i));
				}else{
					talents[i].setDesc(talents[i].label.text+StringData.locked(0,false),StringData.talentDesc(i));
				}
			}
		}
		
		public function navCancel(){
			if (GameData.numCharacters==0 || prestige || saveSlot!=-1){
				new ConfirmWindow(StringData.CONF_MUST_NEW);
				return;
			}else{
				Facade.saveC.startLoadChar(gameM.playerM,GameData.lastChar,true);
				navOut();
				new FadeTransition(this,homeUI);
			}
		}
		
		public function navOut(){
			if (contains(inputName)){
				removeEventListener(Event.ENTER_FRAME,onTick);
				Facade.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDown);
			}
		}
		
		public function reEquip(i:int){
			for (var j:int=0;j<30;j+=1){
				gameM.playerM.removeItemAt(j);
			}
			gameM.playerM.addItemAt(ItemData.startingItem(i,ItemData.WEAPON),0);
			gameM.playerM.addItemAt(ItemData.startingItem(i,ItemData.HELMET),1);
			gameM.playerM.maxHM();
		}
		
		function display(_v:SpriteModel){
			Facade.saveC.loadShort(charView,Facade.saveC.getShortArray(_v));
			charView.view.makeSepia(1.5);
		}
		
		public function muteSound(){
			Facade.soundC.mute=!Facade.soundC.mute;
			soundB.toggled=Facade.soundC.mute;
		}
	}
}