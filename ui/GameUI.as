package ui{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import ui.main.BaseUI;
	import skills.SkillUI;
	import items.InventoryUI;
	import items.ItemData;
	import ui.assets.SoundBar;
	import ui.assets.ClockUI;
	import ui.game.GaugeWindow;
	import ui.windows.EndWindow;
	import ui.assets.FadeTransition;
	import ui.assets.DuelOver;
	import items.ItemView;
	import utils.GameData;
	import ui.assets.PauseBar;
	import ui.effects.FlyingText;
	import ui.effects.AnimatedEffect;
	import ui.assets.SellBar;
	import gameEvents.GameEvent;
	import gameEvents.GameEventManager;
	import ui.assets.TutorialWindow;
	import ui.assets.QualityBar;
	import system.buffs.BuffBase;
	import system.buffs.BuffData;
	import hardcore.HardcoreGameControl;
	
	public class GameUI extends BaseUI{
		public static const PROJ_Y:int=50;
		public static const FLOOR_Y:int=245;//150;//220
		public static var PLAYER_X:int=140;
		public static var ENEMY_X_NEAR:int=280;
		public static var ENEMY_X_FAR:int=380;
		public static var ENEMY_X_VERY:int=480;
		public static const VIEW_WIDTH:int=640;
		public static const VIEW_HEIGHT:int=420;
		public static const NEAR:int=140;
		public static const FAR:int=240;
		public static const VERY:int=340;
		public static const BUFF_Y:int=110;
		public static var BUFF_P_X:int=5;
		public static var BUFF_E_X:int=400;
		
		public static const GAME_PLAYER_X:int=140;
		public static const GAME_ENEMY_X_NEAR:int=280;
		public static const GAME_ENEMY_X_FAR:int=380;
		public static const GAME_ENEMY_X_VERY:int=480;
		public static const GAME_BUFF_P_X:int=5;
		public static const GAME_BUFF_E_X:int=400;
		
		public static const DUEL_PLAYER_X:int=250;
		public static const DUEL_ENEMY_X_NEAR:int=390;
		public static const DUEL_ENEMY_X_FAR:int=490;
		public static const DUEL_ENEMY_X_VERY:int=590;
		public static const DUEL_BUFF_P_X:int=5;
		public static const DUEL_BUFF_E_X:int=585;
		
		var gameM:GameModel;
		public var background:Background;
		
		public var cinematicMode:Boolean=false;
		public var simpleMode:Boolean=false;
		
		public var transTo:BaseUI;
				
		var pBuff:Array=new Array();
		var eBuff:Array=new Array();
		
		var pauseOver:Sprite;
		
		var skillSliding:Boolean;
		var inventorySliding:Boolean;
		var statSliding:Boolean;
		var logSliding:Boolean
		
		public function init(){
			gameM=Facade.gameM;
					
			background=new ui.Background;
			
			gameV.addChild(background);
			
			update();
			
			pauseOver=new Sprite;
			pauseOver.graphics.beginFill(0,0.6);
			pauseOver.graphics.drawRect(0,0,VIEW_WIDTH,VIEW_HEIGHT);
			addEventListener(Event.ENTER_FRAME,onTick);
		}
		
		function update(){
			pauseB.update(null,togglePause,true);
			muteB.update(null,toggleMute,true);
			turboB.update(null,toggleTurbo,true);
			qualityB.update(null,function(){},true);
			muteB.over=popSound;
			pauseB.over=popPause;
			turboB.over=popSell;
			qualityB.over=popQuality;
			
			if (currentFrame==1){
				pullWindow();
				skillUI.pullB.update("Skills",pullWindow);
				skillUI.pullB.index=0;
				statusW.pullB.update("Stats",pullWindow);
				statusW.pullB.index=1;
				actionText.pullB.update("Log",pullWindow);
				actionText.pullB.index=2;
				inventoryUI.pullB.update(null,pullInventory);
				zoneW.townB.update(StringData.TOWN,goToTown,true);
				//limitUI.pullB.update(null,pullLimit);
			}else{
				townB.update(StringData.TOWN,goToTown,true);
				if (contains(actionText)){
					removeChild(actionText);
				}
			}
		}
		
		public var goingTown:Boolean;
		public function goToTown(){
			if (gameM.duel){
				new EndWindow(StringData.getEndText(StringData.END_FORFEIT,gameM.playerM,gameM.enemyM),navOut,resume);
			}else{
				if (goingTown){
					removeBuff(true,BuffData.TOWN);
					townToggle(false);
				}else{
					townToggle(true);
					addBuff(true,BuffData.makeBuff(BuffData.TOWN));
				}
			}
		}
		
		public function resume(){
			Facade.gameC.pauseGame(false);
		}
		
		public function townToggle(b:Boolean){
			if (currentFrame==1){
				zoneW.townB.toggled=b;
			}else{
				townB.toggled=b;
			}
			goingTown=b;
		}
		
		function popSound(){
			if (!Facade.soundC.mute){
				new SoundBar(muteB.x,muteB.y,muteB);
			}
		}
		
		function popPause(){
			new PauseBar(pauseB.x,pauseB.y,pauseB);
		}
		
		function popQuality(){
			new QualityBar(qualityB.x,qualityB.y,qualityB);
		}
		
		function popSell(){
			new SellBar(turboB.x,turboB.y,turboB);
		}

//-------Control Functions--------\

		public function onTick(e:Event){
			//1 = Adventure Frame
			//2 = Dueling Frame
			if (currentFrame==1){
				gaugeW.update(gameM.playerM);
				if (gameM.playerM.craftB > 0) inventoryUI.manuBar.visible = true;
				inventoryUI.manuBar.count(gameM.playerM.craftB,100);
				
				if (skillUI.y==fullIn){
					if (gameM.playerM.skillBlock.skillPoints>0){
						flashingSkill=true;
					}else{
						if (flashingSkill){
							flashingSkill=false;
						}
					}
				}else{
					skillUI.remainText.text=String(gameM.playerM.skillBlock.skillPoints);
					if (flashingSkill){
						flashingSkill=false;
					}
				}
				if (skillSliding){
					if (Math.abs(skillUI.y-skillUITo)<1){
						skillUI.y=skillUITo;
						skillSliding=false;
					}else{
						skillUI.y+=(skillUITo-skillUI.y)*.2;
					}
				}
				if (statSliding){
					if (Math.abs(statusW.y-statusWTo)<1){
						statusW.y=statusWTo;
						statSliding=false;
					}else{
						statusW.y+=(statusWTo-statusW.y)*.2;
					}
				}
				if (logSliding){
					if (Math.abs(actionText.y-actionTextTo)<1){
						actionText.y=actionTextTo;
						logSliding=false;
					}else{
						actionText.y+=(actionTextTo-actionText.y)*.2;
					}
				}
				if (inventorySliding){
					if (Math.abs(inventoryUI.y-inventoryUITo)<1){
						inventoryUI.y=inventoryUITo;
						inventorySliding=false;
					}else{
						inventoryUI.y+=(inventoryUITo-inventoryUI.y)*.3;
					}
				}
				if (goingTown && gameM.distance==GameModel.BETWEEN){
					navOut();
				}
				
				trulyUpdateStats();
				/*if (Math.abs(limitUI.y-limitUITo)<1){
					limitUI.y=limitUITo;
				}else{
					limitUI.y+=(limitUITo-limitUI.y)*.3;
				}*/
			}else{
				//duel
				gaugeW0.update(gameM.playerM);
				gaugeW2.update(gameM.enemyM);
			}
		}
		
		public function set progress(i:int){
			gameM.eCount=i;
			if (gameM.eCount<gameM.eTotal){
				zoneW.atBoss=false;
				zoneW.progB.count(gameM.eCount,gameM.eTotal);
			}else{
				zoneW.atBoss=true;
			}
		}
		
		public function get progress():int{
			return gameM.eCount;
		}
		
		public function addBuff(player:Boolean,buff:BuffBase){
			if (buff.index<0) return;
			
			if (player){
				var _player:SpriteModel=gameM.playerM;
				var _buffs:Array=pBuff;
				var _offset:Number=30;
				var _startX:Number=BUFF_P_X;
			}else{
				_player=gameM.enemyM;
				_buffs=eBuff;
				_offset=-30;
				_startX=BUFF_E_X;
			}
			
			if (buff.view==null){
				_buffs.push(new BuffView(buff));
				buff.view.x=_startX+_offset*((_buffs.length-1)%4);
				buff.view.y=BUFF_Y+30*Math.floor((_buffs.length-1)/4);
				
				buff.view.index=_buffs.length-1;
				//buff.view.scaleX=buff.view.scaleY=0.6;
				
				if (cinematicMode) buff.view.visible=false;
				addChild(buff.view);
				
				if (buff.name!=BuffData.CRIT_ACCUM && buff.name!=BuffData.ATTACK_IGNORED){
					if (buff.name==BuffData.HIGH){
						new FlyingText(_player,"Getting High",0xffffff,0,50);
					}else{
						new FlyingText(_player,buff.name+"!",0xffffff,0,50);
					}
					actionText.addBuff(_player.label,buff.name);
				}
			}else{
				if (buff.name==BuffData.HIGH){
					new FlyingText(_player,"Getting High",0xffffff,0,50);
				}else if (buff.name==BuffData.BARRIER){
					new FlyingText(_player,buff.name+"!",0xffffff,0,50);
				}
			}
		}
		
		public function removeBuff(player:Boolean,s:String){
			if (player){
				var _buffs:Array=pBuff;
				var _offset:Number=30;
				var _startX=BUFF_P_X;
			}else{
				_buffs=eBuff;
				_offset=-30;
				_startX=BUFF_E_X;
			}
			
			for (var i:int=0;i<_buffs.length;i+=1){
				if (_buffs[i].model.name==s){
					break;
				} 
			}
			if (i<0 || i>=_buffs.length) return;
			
			if (_buffs[i]!=null){
				_buffs[i].dispose();
			}
			_buffs.splice(i,1);
			for (i;i<_buffs.length;i+=1){
				_buffs[i].x=_startX+_offset*(i%4);
				_buffs[i].y=BUFF_Y+30*Math.floor(i/4);
				_buffs[i].index-=1;
			}
		}
		
		public function clearBuffs(_player:Boolean){
			if (_player){
				while(pBuff.length>0){
					pBuff.shift().dispose();
				}
			}else{
				while(eBuff.length>0){
					eBuff.shift().dispose();
				}
			}
		}
		
		public function addItem(_item:ItemView,_location:int=-1,_noFilter:Boolean=false){
			if (!checkFilter(_item)){
				if (!_noFilter){
					_gold=_item.model.cost;
					addGold(_gold);
					actionText.addText(_item.model.name+" Auto-Sold.  Got "+_gold+"gp.");
				}
				return;
			}
			if (_location==-1){
				if (inventoryUI.addItem(_item)){
					actionText.addFind(_item.model.name);
					flashingInv=true;
				}else{
					if (_noFilter) return;
					
					GameEventManager.addGameEvent(GameEvent.INVENTORY_FULL,_item);
					
					if (_item.model.isSpecial()){
						gameM.addOverflowItem(_item.model);
					}else{
						var _gold:int=_item.model.cost;
						addGold(_gold);
						actionText.addText("Inventory Full.  Got "+_gold+"gp.");
						flashingInv=true;
					}
				}
			}else{
				inventoryUI.addItemAt(_item,_location);
			}
		}
		
		public function checkFilter(_item:ItemView):Boolean{
			if (_item.model.isSpecial()) return true;
			if (!GameData.getFlag(GameData.FLAG_TUTORIAL)) return true;
			
			if (_item.model.slot==ItemData.TRADE){
				if (GameData._Save.data.sell[GameData.SELL_GEM]) return false;
			}else if (_item.model.slot==ItemData.EQUIPMENT){
				if (_item.model.primary==ItemData.MAGIC){
					if (GameData._Save.data.sell[GameData.SELL_SPELL]) return false;
				}else if (_item.model.enchantIndex<0){
					if (GameData._Save.data.sell[GameData.SELL_NONMAGIC]) return false;
				}else{
					if (GameData._Save.data.sell[GameData.SELL_MAGIC]) return false;
				}
			}else if (_item.model.slot==ItemData.USEABLE){
				if (_item.model.primary==ItemData.PROJECTILE){
					if (_item.model.enchantIndex<0){
						if (GameData._Save.data.sell[GameData.SELL_NONMAGIC]) return false;
					}else{
						if (GameData._Save.data.sell[GameData.SELL_MAGIC]) return false;
					}
				}else if (_item.model.primary==ItemData.CHARM){
					if (GameData._Save.data.sell[GameData.SELL_CHARM]) return false;
				}else if (_item.model.primary==ItemData.SCROLL){
					if (GameData._Save.data.sell[GameData.SELL_SCROLL]) return false;
				}else if (_item.model.secondary==ItemData.DAMAGING || _item.model.secondary==ItemData.CURSE){
					if (GameData._Save.data.sell[GameData.SELL_GRENADE]) return false;
				}else{
					if (GameData._Save.data.sell[GameData.SELL_POTION]) return false;
				}
			}
			
			return true;
		}
		
		public function addGold(_value:int){
			if (Facade.gameC is HardcoreGameControl) return;
			GameData.gold+=_value;
			inventoryUI.updateGold();
		}
		
		override public function openWindow(){
			Facade.gameC.pauseGame(false);
			
			if (contains(pauseOver)) removeChild(pauseOver);
			
			if (gameM.duel){
				PLAYER_X=DUEL_PLAYER_X;
				ENEMY_X_NEAR=DUEL_ENEMY_X_NEAR;
				ENEMY_X_FAR=DUEL_ENEMY_X_FAR;
				ENEMY_X_VERY=DUEL_ENEMY_X_VERY;
				BUFF_P_X=DUEL_BUFF_P_X;
				BUFF_E_X=DUEL_BUFF_E_X;
				
				startDuel();
			}else{
				if (Facade.gameC is EpicGameControl){
					GameData.setupZone(GameData.epics[0],false);
				}else if (Facade.gameC is HardcoreGameControl){
					gameM.eTotal=2;
				}else{
					if (GameData.boost>0){
						addBuff(true,BuffData.makeBuff(BuffData.XP_BOOST));
					}
					if (GameData.clocks>0){
						addBuff(true,BuffData.makeBuff(BuffData.PROGRESS_BOOST));
					}
				}
				PLAYER_X=GAME_PLAYER_X;
				ENEMY_X_NEAR=GAME_ENEMY_X_NEAR;
				ENEMY_X_FAR=GAME_ENEMY_X_FAR;
				ENEMY_X_VERY=GAME_ENEMY_X_VERY;
				BUFF_P_X=GAME_BUFF_P_X;
				BUFF_E_X=GAME_BUFF_E_X;
				
				gaugeW.init(gameM.playerM);
				skillUI.update(gameM.playerM);
				statusW.update(gameM.playerM);
				inventoryUI.update(gameM.playerM);
				inventoryUI.manuBar.setTooltipName("Manufacturing Points");
				inventoryUI.manuBar.visible = false;
				//limitUI.update(gameM.playerM);
				//Facade.saveC.saveFromGame();
				gameM.enemyM.exists=false;
				gameM.active=true;
				setProg();
				Facade.effectC.openEffects(gameM.playerM);
				
				updateStatus(gameM.playerM);
				actionText.updateStreak(gameM.deathStreak,gameM.playerM.deathsSinceAscension);
			}
			muteB.toggled=Facade.soundC.mute;
			
			if (GameData.getFlag(GameData.FLAG_TUTORIAL)){
				addChildAt(turboB,getChildIndex(pauseB)-1);
				if (Facade.stage.frameRate>Facade.FRAMERATE){
					turboB.toggled=Facade.gameC.turboB=true;
				}else{
					turboB.toggled=Facade.gameC.turboB=false;
				}
				turboB.toggled=Facade.gameC.turboB;
			}else{
				if (contains(turboB)){
					removeChild(turboB);
				}
			}
			
			gameM.playerM.view.x=PLAYER_X;
			gameV.addChild(gameM.playerM.view);
			gameM.playerM.view.action(SpriteView.IDLE);
			
			Facade.soundC.startMusic(gameM.areaType+2);
			
			if (!background.isLoaded()){
				background.loadBacks(-1,gameM.areaType);
			}
			background.setBackground();
			Facade.gameM.playerM.actionList.itemC.recover();
			setCinematicMode(cinematicMode);
			setSimpleMode(simpleMode);
			//Facade.setQuality(GameData._Save.data.quality);
		}
		
		public function navOut(){
			Facade.soundC.fadeOut();
			gameM.deathStreak=0;
			removeBuff(true,BuffData.TOWN);
			townToggle(false);
			
			Facade.gameC.clearLevel();
			Facade.gameC.dispose();
			Facade.gameC=null;
			new FadeTransition(this,transTo);
			Facade.gameM.playerM.actionList.itemC.remove(false);
			//Facade.setQuality(2,false);
		}
		
		public function restart(){
			new FadeTransition(this,this);
		}
		
		override public function closeWindow(){
			//removeEventListener(Event.ENTER_FRAME,onTick);
			if (Facade.gameC!=null) Facade.gameC.clearLevel();
			removeBuff(true,BuffData.XP_BOOST);
			removeBuff(true,BuffData.PROGRESS_BOOST);
			Facade.mouseC.clearMouse();
			Facade.gameM.playerM.actionList.itemC.remove(true);
			if (contains(turboB)){
				removeChild(turboB);
			}
			if (currentFrame==2){
				endDuel();
			}
		}
		
		function startDuel(){
			if (contains(skillUI)) removeChild(skillUI);
			if (contains(statusW)) removeChild(statusW);
			if (contains(actionText)) removeChild(actionText);
			gotoAndStop(2);
			
			update();
			
			/*if (GameModel.replay){
				GameModel.replayA=GameModel.recordA;
				GameModel.recordA=new Array;
			}*/
			gameM.round=0;
			updateRound();
			gameM.distance=GameModel.FAR;
			
			Facade.saveC.loadTemps();
			gameM.enemyM.view.x=ENEMY_X_FAR;
			gameM.playerM.maxHM();
			gameM.enemyM.maxHM();
			
			if (gameM.enemyM.saveSlot<5){
				gameM.active=false;
				inventoryUI0.locked=true;
			}else{
				gameM.active=true;
				inventoryUI0.locked=false;
				inventoryUI0.noSell=true;
			}
			
			(Facade.gameC as DuelControl).startDuel();
			
			gaugeW0.init(gameM.playerM);
			gaugeW2.init(gameM.enemyM);
			
			inventoryUI0.update(gameM.playerM);
			inventoryUI2.locked=true;
			inventoryUI2.update(gameM.enemyM);
			
			if (gameM.enemyM.exists){
				gameV.addChild(gameM.enemyM.view);
				gameM.enemyM.view.action(SpriteView.IDLE);
			}
			Facade.effectC.openEffects(gameM.playerM);
			Facade.effectC.openEffects(gameM.enemyM);
			new DuelOver(gameM.playerM.label,gameM.playerM.title,gameM.enemyM.label,gameM.enemyM.title);
		}
		
		function endDuel(){
			gotoAndStop(1);
			update();
		}
		
		public function coverPause(_clear:Boolean=false){
			if (!contains(pauseOver)){
				pauseB.toggled=true;
				Facade.gameC.pauseGame(true);
			}
			addChildAt(pauseOver,getChildIndex(gameV)+1);
		}
		
		public function togglePause(){
			if (contains(pauseOver)){
				removeChild(pauseOver);
				Facade.gameC.pauseGame(false);
				pauseB.toggled=false;
				
			}else{
				addChildAt(pauseOver,getChildIndex(gameV)+1);
				Facade.gameC.pauseGame(true);
				pauseB.toggled=true;
			}
		}
		
		public function setPause(b:Boolean){
			if (b){
				addChildAt(pauseOver,getChildIndex(gameV)+1);
				Facade.gameC.pauseGame(true);
				pauseB.toggled=true;
			}else{
				if (contains(pauseOver)){
					removeChild(pauseOver);
				}
				Facade.gameC.pauseGame(false);
				pauseB.toggled=false;
			}
		}
				
		public function toggleMute(){
			Facade.soundC.mute=!Facade.soundC.mute;
			muteB.toggled=Facade.soundC.mute;
		}
		
		public function toggleTurbo(){
			Facade.gameC.turbo();
		}
				
		function setProg(){
			var _progName:String = StringData.enemyType[gameM.enemyType]+" "+StringData.areaType[gameM.areaType];
			zoneW.progF.text=_progName+" "+gameM.area;
			progress=gameM.eCount;
		}
		
		public function updateRound(){
			gameM.round+=0.5;
			if (gameM.duel){
				roundF.display.text=String(Math.floor(gameM.round))+"/"+String(GameModel.MAX_ROUNDS);
				if (gameM.round>GameModel.MAX_ROUNDS) (Facade.gameC as DuelControl).finishRound(-2);
			}
		}
		
		public function cDistance():Number{
			if (!gameM.enemyM.exists) return 9999;
			
			return (gameM.enemyM.view.x-gameM.playerM.view.x);
		}
		
		public function setPositions(){
			if (gameM.playerM.view.display==null) return;
			gameM.playerM.view.display.x=0;
			gameM.playerM.view.inverted=gameM.playerM.view.inverted;
			gameM.playerM.view.x=PLAYER_X;
			gameM.playerM.view.y=FLOOR_Y;
			if (gameM.enemyM.exists){
				gameM.enemyM.view.display.x=0;
				gameM.enemyM.view.inverted=gameM.enemyM.view.inverted;
				gameM.enemyM.view.y=FLOOR_Y;
				if (gameM.distance==GameModel.NEAR){
					gameM.enemyM.view.x=ENEMY_X_NEAR;
				}else if (gameM.distance==GameModel.FAR){
					gameM.enemyM.view.x=ENEMY_X_FAR;
				}else if (gameM.distance==GameModel.VERY){
					gameM.enemyM.view.x=ENEMY_X_VERY;
				}
			}
		}
		
		public var _invOut:int=241;
		public var _invIn:int=324;
		public function pullInventory(){
			inventorySliding=true;
			if (inventoryUITo==_invOut){
				//inventoryUI.plusItems.enabled=false;
				inventoryUITo=_invIn;
				flashingInv=false;
			}else{
				inventoryUITo=_invOut;
				flashingInv=false;
			}
		}
		
		/*public var _limitOut:int=10;
		public var _limitIn:int=-87;
		public function pullLimit(){
			if (limitUITo==_limitOut){
				limitUITo=_limitIn;
			}else{
				limitUITo=_limitOut;
			}
		}*/
		
		var _flashingSkill:SkillFlash=new SkillFlash;
		public function get flashingSkill():Boolean{
			if (_flashingSkill.parent==null){
				return false;
			}else{
				return true;
			}
		}
		
		public function set flashingSkill(b:Boolean){
			if (b){
				_flashingSkill.x=38.2;
				_flashingSkill.y=6.3;
				skillUI.pullB.addChild(_flashingSkill);
			}else{
				if (_flashingSkill.parent!=null){
					_flashingSkill.parent.removeChild(_flashingSkill);
				}
			}
		}
		
		var _flashingInv:SkillFlash=new SkillFlash;
		public function get flashingInv():Boolean{
			if (_flashingInv.parent==null){
				return false;
			}else{
				return true;
			}
		}
		
		public function set flashingInv(b:Boolean){
			if (b && inventoryUI.y==_invIn){
				_flashingInv.x=98.05;
				_flashingInv.y=4.05;
				_flashingInv.scaleX=_flashingInv.scaleY=2.2;
				inventoryUI.pullB.addChild(_flashingInv);
			}else{
				if (_flashingInv.parent!=null){
					_flashingInv.parent.removeChild(_flashingInv);
				}
			}
		}
		
		public function setBattleState(_state:String){
			if (gaugeW==null) return;
			
			switch(_state){
				case GameModel.BETWEEN: gaugeW.state.text="Safe"; break;
				case GameModel.FAR: gaugeW.state.text="Fight (Far)"; break;
				case GameModel.NEAR: gaugeW.state.text="Fight (Near)"; break;
				case GameModel.VERY: gaugeW.state.text="Fight (Long)"; break;
			}
		}
		
		var topIndex:int;
		public var fullOut:Number=65;
		var fullIn:Number=-187;
		var skillUITo:Number=-197;
		var statusWTo:Number=-197;
		var actionTextTo:Number=-197;
		var inventoryUITo:Number=343;
		//var limitUITo:Number=-96.5;
		
		public function pullWindow(i:int=-1){
			if (currentFrame!=1) return;
			//in: y=fullIn;
			//out: y=fullOut;
			var _check:*;
			var _other1:*;
			var _other2:*;
			var _checkTo:Number;
			var _other1To:Number;
			var _other2To:Number;
			var forceOut:Boolean=false;
			topIndex=getChildIndex(zoneW)-1;
			//trace(getChildIndex(zoneW),getChildIndex(skillUI),getChildIndex(statusW),getChildIndex(actionText));
			switch(i){
				case -1:
					//default
					skillUI.y=skillUITo=fullIn;
					statusW.y=statusWTo=fullIn;
					actionText.y=actionTextTo=fullIn;
					inventoryUI.y=inventoryUITo=_invIn;
					//limitUI.y=limitUITo=_limitIn;
					return;
				case 0:
					//skillUI
					skillSliding=true;
					_check=skillUI;
					_other1=statusW;
					_other2=actionText;
					_other1To=statusWTo;
					_other2To=actionTextTo;
					break;
				case 3:
					//statusWForced
					forceOut=true;
				case 1:
					//statusW
					statSliding=true;
					_check=statusW;
					_other1=skillUI;
					_other2=actionText;
					_other1To=skillUITo;
					_other2To=actionTextTo;
					break;
				case 2:
					//actionText
					logSliding=true;
					_check=actionText;
					_other1=skillUI;
					_other2=statusW;
					_other1To=skillUITo;
					_other2To=statusWTo;
					break;
			}
			_checkTo=_check.y;
			if (_check.y==fullIn){
				_checkTo=fullOut;
				addChildAt(_check,topIndex);
				if (_other1To==fullIn){
					addChildAt(_other1,topIndex);
				}
				if (_other2To==fullIn){
					addChildAt(_other2,topIndex);
				}
			}else{
				//addChildAt(_check,getChildIndex(zoneW)-2);
				if (_other1To==fullOut && getChildIndex(_other1)>getChildIndex(_check)){
					addChildAt(_check,getChildIndex(_other1));
					if (_other2To==fullOut && getChildIndex(_other2)>getChildIndex(_check)){
						addChildAt(_check,getChildIndex(_other2));
					}
				}else if (_other2To==fullOut && getChildIndex(_other2)>getChildIndex(_check)){
					addChildAt(_check,getChildIndex(_other2));
				}else{
					if (forceOut){
						_checkTo=fullOut;
					}else{
						_checkTo=fullIn;
					}
				}
			}
			switch(i){
				case 0: skillUITo=_checkTo; break;
				case 1: case 3: statusWTo=_checkTo; break;
				case 2: actionTextTo=_checkTo; break;
			}
			//addChildAt(zoneW,topIndex);
		}
		
		public function addEffect(_v:SpriteModel,_label:String){
			switch(_label){
				case StatModel.TENACITY: new AnimatedEffect(_v,AnimatedEffect.WILL);
				default: break;
			}
		}
		
		public function toggleSimple(){
			setSimpleMode(!simpleMode);
		}
		
		public function setSimpleMode(b:Boolean){
			simpleMode=b;
			Facade.gameM.playerM.view.setSimpleMode(b);
			Facade.gameM.enemyM.view.setSimpleMode(b);
			//Facade.gameM.projM.setSimpleMode(b);
			if (simpleMode){
				background.visible=false;
			}else{
				background.visible=true;
			}
		}
		
		public function toggleCinematic(){
			setCinematicMode(!cinematicMode);
			
		}
		
		public function setCinematicMode(b:Boolean){
			cinematicMode=b;
			
			pauseB.visible=!b;
			muteB.visible=!b;
			turboB.visible=!b;
			//qualityB.visible=false;
			muteB.visible=!b;
			subtitle1.visible=!b;
			subtitle2.visible=!b;
			subtitle3.visible=!b;
			subtitle4.visible=!b;
				
			for (var i:int=0;i<pBuff.length;i+=1){
				pBuff[i].visible=!b;
			}
			
			for (i=0;i<eBuff.length;i+=1){
				eBuff[i].visible=!b;
			}
			if (currentFrame==1){
				skillUI.visible=!b;
				statusW.visible=!b;
				actionText.visible=!b;
				inventoryUI.visible=!b;
				gaugeW.visible=!b;
				skillUI.visible=!b;
				statusW.visible=!b;
				inventoryUI.visible=!b;
				zoneW.visible=!b;
			}else{
				townB.visible=!b;
				gaugeW0.visible=!b;
				gaugeW2.visible=!b;
				inventoryUI0.visible=!b;
				inventoryUI2.visible=!b;
				roundF.visible=!b;
			}
			
			gameM.playerM.view.displayBars(b);
		}
		
		public function updateStatus(_v:SpriteModel,_remove:Boolean=false){
			if (_remove){
				if (origin==_v) origin=null;
			}else{
				origin=_v;
			}
			
			if (origin!=null){
				statusW.update(origin);
			}
		}
		
		var toUpdate:Boolean=false;
		override public function updateStats(_o:SpriteModel=null){
			if (_o!=null){
				origin=_o;
			}
			
			if (origin==null) return;
			
			toUpdate=true;
			//statusW.update(origin);
		}
		
		function trulyUpdateStats(){
			if (toUpdate){
				toUpdate=false;
				statusW.update(origin);
			}
		}
		
		public function switchTarget(){
			if ((origin==null || origin==gameM.playerM) && gameM.enemyM.exists){
				updateStatus(gameM.enemyM);
			}else{
				updateStatus(gameM.playerM);
			}
		}
	}
}