package{
	
	import flash.events.Event;
	import flash.display.Sprite;
	import items.ItemData;
	import items.ItemView;
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
	
	public class GameControl{
		public static const TURN_LENGTH:int=30;
		public static const BUFF_DELAY:int=10;

		public var gameM:GameModel;
		public var gameV:Sprite;
		public var gameUI:GameUI;
		
		public var delay:int;
		public var spawn:int;
		public var turboB:Boolean;
		public var running:Boolean;
		
		public var roundWait:Boolean=false;
		
		public function GameControl(){
			gameM=Facade.gameM;
			gameUI=Facade.gameUI;
			gameV=gameUI.gameV;
			Facade.stage.addEventListener(Event.ENTER_FRAME,onTick);
		}
		
		public var _TempECount:int=-1;
		public function playerDead(_v:SpriteModel){
			if (!running) return;
			//You Die!
			GameData.addScore(GameData.SCORE_DEATHS,1);
			gameM.deathStreak+=1;
			gameM.playerM.deathsSinceAscension+=1;
			if (gameM.eCount>gameM.eTotal){
				//nextLevel();
			}else{
				_TempECount=gameM.eCount;
				gameM.eCount=0;
			}
			
			Facade.saveC.saveFromGame();
			
			if (gameUI.goingTown){
				gameUI.navOut();
			}else{
				new EndWindow("You have died!\nSuch a shame...\n\nDeath Streak: "+String(gameM.deathStreak),navOut,revive,true,false,Math.ceil(_TempECount/gameM.eTotal*5),progressRevive);
			}
		}
		
		function progressRevive(){
			gameM.eCount=_TempECount;
			revive();
		}
		
		public function navOut(){
			gameUI.background.clear();
			gameM.playerM.maxHM();
			gameUI.navOut();
		}
		
		public function revive(){
			gameUI.background.clear();
			gameM.playerM.maxHM();
			gameUI.restart();
		}
		
		public function killEnemy(_v:SpriteModel){
			if (_v.player){
				GameEventManager.addGameEvent(GameEvent.KILL_SHADOW,gameM.area);
			}
			gameUI.actionText.addKill(_v.label);
			_v.tFunction=enemyDead;
			_v.view.action(SpriteView.DIE);
			_v.buffList.reset();
			gameUI.clearBuffs(false);
		}
		
		public function enemyDead(_o:SpriteModel, _t:SpriteModel){
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
				if (gameM.eCount<gameM.eTotal && GameData.clocks>0){
					getMobReward();
					GameData.clocks-=1;
					if (GameData.clocks==0){
						gameUI.removeBuff(true,BuffData.PROGRESS_BOOST);
						new ConfirmWindow("Your last progress boost ran out!  Progress Speed back to normal.");
					}
				}
				
				Facade.saveC.saveFromGame();
			}
		}
		
		function getBossReward(){
			if (GameData.boost>0){
				applyBoost(5);
			}else{
				gameM.playerM.xp+=5;
			}
			if (gameM.playerM.stats.findDisplay(EffectData.AWARD)!=null){
				gameM.playerM.xp+=1;
			}
			var _effect:EffectBase=gameM.playerM.stats.findDisplay(EffectData.GOLD_PER_KILL);
			if (_effect!=null){
				GameData.gold+=_effect.values;
				gameUI.inventoryUI.updateGold();
			}
			if (gameM.areaType>2){
				var _item:ItemView=new ItemView(ItemData.shadowItem());
			}else{
				_item=new ItemView(ItemData.findItem(gameM.area,1));
			}
			gameUI.progress+=1;
			gameUI.addItem(_item);
		}
			
		function getMobReward(){
			if (GameData.boost>0){
				applyBoost(1);
			}else{
				gameM.playerM.xp+=1;
			}
			if (gameM.playerM.stats.findDisplay(EffectData.AWARD)!=null){
				gameM.playerM.xp+=1;
			}
			var _effect:EffectBase=gameM.playerM.stats.findDisplay(EffectData.GOLD_PER_KILL);
			if (_effect!=null){
				GameData.gold+=_effect.values;
				gameUI.inventoryUI.updateGold();
			}
			if (GameData.getFlag(GameData.FLAG_TUTORIAL) && Math.random()<gameM.playerM.stats.getValue(StatModel.ILOOT)){
				var _item:ItemView=new ItemView(ItemData.findItem(gameM.area,gameM.playerM.stats.getValue(StatModel.ILOOT)));
				gameUI.addItem(_item);
			}
			gameUI.progress+=1;
			GameData.addScore(GameData.SCORE_KILLS,1);
		}
		
		public function applyBoost(_xp:Number){
			gameM.playerM.xp+=_xp*2;
			GameData.gold+=1000;
			gameUI.inventoryUI.updateGold();
			GameData.boost-=1;
			if (GameData.boost==0){
				gameUI.removeBuff(true,BuffData.XP_BOOST);
				new ConfirmWindow("Your last boost ran out!  XP Gain back to normal, no Gold per kill :(\nBuy more boosts in the Temple.");
			}
		}
		
		public function clearLevel(){
			if (gameM.eCount>gameM.eTotal){
				//nextLevel();
			}
			gameUI.background.clear();
			spawn=3;
			gameM.playerM.maxHM();
			gameM.playerM.view.display.gotoAndStop(0);
			try{gameM.enemyM.view.display.gotoAndStop(0);}catch(e:Error){}
			if (gameM.enemyM.exists){
				gameV.removeChild(gameM.enemyM.view);
				gameM.enemyM.exists=false;
			}
			while(gameM.enemyM.buffList.numBuffs()>0){
				gameM.enemyM.buffList.removeBuff(0);
			}
			
			while(gameM.playerM.buffList.numBuffs()>0){
				gameM.playerM.buffList.removeBuff(0);
			}
			gameV.removeChild(gameM.playerM.view);
			
			removeProjectile();
			pauseGame(true);
		}
		
		public function removeProjectile(i:int=-1){
			if (i==-1){
				while(gameM.projectiles.length>0){
					gameM.projectiles[0].remove();
					gameM.projectiles.shift();
				}
			}else{
				gameM.projectiles[i].remove();
				gameM.projectiles.splice(i,1);
			}
		}
		
		public function nextLevel(_areaType:int=-1){
			gameUI.background.addLast();
			gameM.setupArea(gameM.area+1);
			gameM.deathStreak=0;
			spawn=99;
			
			GameData.suns*=0.97;
			GameEventManager.addGameEvent(GameEvent.AREA_REACHED,gameM.area);
			
			if (gameM.area>GameData.getScore(GameData.SCORE_FURTHEST)){
				GameData.setScore(GameData.SCORE_FURTHEST,gameM.area);
			}
			
			//gameUI.background.clear();
			GameData.addRefresh();
			Facade.menuUI.shopUI.restock();
			Facade.saveC.saveFromGame();
		}
			
		public function chooseInit(){
			gameM.round=0;
			if (GameModel.replay){
				GameModel.cReplay=0;
			}
			gameM.playerM.attackTarget=gameM.enemyM;
			gameM.enemyM.attackTarget=gameM.playerM;
			if ((gameM.playerM.stats.getValue(StatModel.INITIATIVE)*(1+GameModel.random()))>(gameM.enemyM.stats.getValue(StatModel.INITIATIVE)*(1+GameModel.random()))){
				gameM.turn=true;
			}else{
				gameM.turn=false;
			}
			gameM.playerM.stats.useEffects(EffectBase.INITIAL,new DamageModel,gameM.playerM,gameM.enemyM);
			gameM.enemyM.stats.useEffects(EffectBase.INITIAL,new DamageModel,gameM.enemyM,gameM.playerM);
		}
		
		public function onTick(e:Event){
			if (!running) return;
			
			if (roundWait){
			
			}else if (delay>BUFF_DELAY){
				delay-=1;
			}else if (delay==BUFF_DELAY){
				if (gameM.playerM.checkDone() && gameM.enemyM.checkDone() ){
					if (gameM.distance==GameModel.BETWEEN){
						gameM.playerM.onTurnStart(true);
						gameM.playerM.stats.useDisplays(EffectBase.CONSTANT,null,gameM.playerM,null);
						gameM.playerM.stats.useEffects(EffectBase.SAFE,null,gameM.playerM,null);
					}else if (!gameM.turn){
						gameUI.updateRound();
						gameM.playerM.onTurnStart(false);
						gameM.enemyM.stats.useDisplays(EffectBase.CONSTANT,null,gameM.enemyM,gameM.playerM);
						GameEventManager.addGameEvent(GameEvent.PLAYER_TURN);
					}else{
						gameUI.updateRound();
						gameM.enemyM.onTurnStart(false);
						gameM.playerM.stats.useDisplays(EffectBase.CONSTANT,null,gameM.playerM,gameM.enemyM);
					}
					delay-=1;
				}
			}else if (delay>0){
				delay-=1;
				if (delay==0 && gameM.distance!=GameModel.BETWEEN && gameM.turn){
					checkAutoPause();
				}
			}else if ((gameM.playerM.checkDone())&&(gameM.enemyM.checkDone())){
				delay=TURN_LENGTH;
				if (gameM.distance==GameModel.BETWEEN){ // not in a fight
					if (spawn>0){
						spawn-=1;
					}else{
						if (gameM.eCount<gameM.eTotal){
							if (gameM.enemyM.exists==false){
								newEnemy();
								spawn=Math.ceil(Math.random()*4)+1;
							}
						}else if (gameM.eCount==gameM.eTotal){
							if (gameUI.background.cList[0].index>=gameUI.background.backs.length-3){
								newBoss();
								spawn=Math.ceil(Math.random()*4)+1;
							}
						}
					}
					gameM.playerM.view.action(SpriteView.IDLE);
					gameM.playerM.beginAction();
				}else{ //in a fight
					if (gameM.enemyM.exists==false){
						gameM.distance=GameModel.BETWEEN;
						gameM.playerM.attackTarget=null;
						gameM.enemyM.attackTarget=null;
					}else if (gameM.turn){
						if (gameV.getChildIndex(gameM.enemyM.view)>gameV.getChildIndex(gameM.playerM.view)){
							gameV.swapChildren(gameM.enemyM.view,gameM.playerM.view);
						}
						
						gameM.playerM.beginAction();
						
					}else{
						if (gameV.getChildIndex(gameM.enemyM.view)<gameV.getChildIndex(gameM.playerM.view)){
							gameV.swapChildren(gameM.enemyM.view,gameM.playerM.view);
						}
						gameM.enemyM.beginAction();
					}
					gameM.turn=!gameM.turn;
				}
			}
			
			for (var i:int=0;i<gameM.projectiles.length;i+=1){
				if (gameM.projectiles[i].exists){
					gameM.projectiles[i].tick();
				}else{
					removeProjectile(i);
					i-=1;
				}
			}
			
			gameM.playerM.view.tick();
			if (gameM.enemyM.exists){
				gameM.enemyM.view.tick();
			}
			
			if ((gameM.distance==GameModel.BETWEEN)&&(gameUI.cDistance()<=GameUI.FAR)){
				startFight();
			}
			
			GameEventManager.addGameEvent(GameEvent.PLAYER_HEALTH,gameM.playerM._Health/gameM.playerM.stats.getValue(StatModel.HEALTH));
			
			gameUI.background.shiftBack(GameUI.PLAYER_X-gameM.playerM.view.x);
			gameUI.setBattleState(gameM.distance);
			if (!GameData.getFlag(GameData.FLAG_TUTORIAL)){
				TutorialWindow.checkTutorial();
			}
			
			if (checkDeath(gameM.enemyM)){
				kill(gameM.enemyM);
				killEnemy(gameM.enemyM);
			}
			if (checkDeath(gameM.playerM)){
				kill(gameM.playerM);
				playerDead(gameM.playerM);
			}
		}
		
		public function checkDeath(_v:SpriteModel):Boolean{
			if (_v.exists && !_v.dead && _v.getHealth()<=0){
				if (!Facade.effectC.tryRevive(_v)){
					return true;
				}
			}
			return false;
		}
		
		public function kill(_v:SpriteModel){
			_v.dead=true;
			gameM.playerM.clearTimer();
			gameM.playerM.view.toIdle();
			gameM.enemyM.clearTimer();
			gameM.enemyM.view.toIdle();
			removeProjectile();
			gameM.playerM.strike=0;
			gameM.playerM.shots=0;
			gameM.enemyM.strike=0;
			gameM.enemyM.shots=0;
			gameM.playerM.attackTarget=null;
			gameM.enemyM.attackTarget=null;
		}
		
		public function startFight(){
			gameM.distance=GameModel.FAR;
			gameM.playerM.view.action(SpriteView.IDLE);
			gameM.enemyM.view.action(SpriteView.IDLE);
			gameUI.setPositions();
			chooseInit();
			delay=1;
			if (gameM.enemyM.player){
				GameEventManager.addGameEvent(GameEvent.MEET_SHADOW,gameM.area);
			}
		}
		
		public function newEnemy(){
			EnemyData.newCreature(gameM.enemyM);
			gameM.enemyM.view.y=GameUI.FLOOR_Y;
			gameM.enemyM.view.x=GameUI.VIEW_WIDTH+100;
			gameV.addChild(gameM.enemyM.view);
		}

		public function newBoss(){
			EnemyData.newBoss(gameM.enemyM);
			gameM.enemyM.view.y=GameUI.FLOOR_Y;
			gameM.enemyM.view.x=GameUI.VIEW_WIDTH+50;
			gameV.addChild(gameM.enemyM.view);
			GameEventManager.addGameEvent(GameEvent.ENCOUNTER_BOSS,gameM.enemyM);
		}
				
		public function turbo(){
			if (turboB){
				Facade.stage.frameRate=Facade.FRAMERATE;
				turboB=false;
				gameUI.turboB.toggled=false;
			}else{
				Facade.stage.frameRate=Facade.FRAMERATE*2;
				turboB=true;
				gameUI.turboB.toggled=true;
			}
		}
		
		public function pauseGame(b:Boolean,o:Boolean=false){
			if (b){
				gameM.playerM.view.action(SpriteView.PAUSE);
				if (gameM.enemyM.exists) gameM.enemyM.view.action(SpriteView.PAUSE);
				
				running=false;
			}else{
				gameM.playerM.view.action(SpriteView.UNPAUSE);
				if (gameM.enemyM.exists) gameM.enemyM.view.action(SpriteView.UNPAUSE);
				
				running=true;
			}
		}
		
		public function checkAutoPause(){
			if (GameData._Save.data.pause[GameData.PAUSE_TURN]){
				Facade.gameUI.setPause(true);
				Facade.gameM.playerM.actionList.itemC.remove();
			}else if (GameData._Save.data.pause[GameData.PAUSE_HEALTH] && Facade.gameM.playerM.healthPercent()<0.25){
				gameUI.setPause(true);
			}
		}
		
		public function dispose(){
			Facade.stage.removeEventListener(Event.ENTER_FRAME,onTick);
		}
	}
}