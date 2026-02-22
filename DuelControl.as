package{
	
	import flash.events.Event;
	import flash.display.Sprite;
	import items.ItemData;
	import items.ItemView;
	import flash.geom.Matrix;
	import ui.GameUI;
	import ui.windows.EndWindow;
	import gameEvents.GameEventManager;
	import gameEvents.GameEvent;
	import utils.GameData;
	import system.effects.EffectBase;
	
	public class DuelControl extends GameControl{
		/*var gameM:GameModel;
		var gameV:Sprite;
		var gameUI:GameUI;
		public var delay:int;
		var turboB:Boolean;
		public var running:Boolean;
		
		public var roundWait:Boolean=false;*/
		
		/*override public function init(){
			gameM=Facade.gameM;
			gameUI=Facade.gameUI;
			gameV=gameUI.gameV;
			Facade.stage.addEventListener(Event.ENTER_FRAME,onTick);
		}*/
		
		public function finishRound(i:int){
			if (i==-2){ //TIMED OUT
				new EndWindow(StringData.getEndText(StringData.END_TIE,gameM.playerM,gameM.enemyM),gameUI.navOut,gameUI.restart);
			}else if (i==-1){ //TIE
				new EndWindow("Somehow, you both died at once... round ends in a DRAW!",gameUI.navOut,gameUI.restart);
			}else if (i==0){ //WIN
				if (gameM.enemyM.saveSlot>=5){
					var _reward:Number=duelReward();
					if (_reward>0){
						GameEventManager.addGameEvent(GameEvent.CHALLENGE_DEFEATED);
					}
					new EndWindow(StringData.getEndText(StringData.END_CHALLENGE_W,gameM.playerM,gameM.enemyM,_reward),gameUI.navOut,gameUI.restart,false,true);
				}else{
					new EndWindow(StringData.getEndText(StringData.END_REMATCH_R,gameM.playerM,gameM.enemyM),gameUI.navOut,gameUI.restart);
				}
			}else{ //LOSE
				if (gameM.enemyM.saveSlot>=5){
					new EndWindow(StringData.getEndText(StringData.END_CHALLENGE_L,gameM.playerM,gameM.enemyM),gameUI.navOut,gameUI.restart);
				}else{
					new EndWindow(StringData.getEndText(StringData.END_REMATCH_L,gameM.playerM,gameM.enemyM),gameUI.navOut,gameUI.restart);
				}
			}
		}
		
		//public function killEnemy(_v:SpriteModel){
		//public function clearLevel(){
		//public function chooseInit(){
		
		override public function onTick(e:Event){
			if (!running) return;
			
			if (roundWait){
			
			}else if (delay>GameControl.BUFF_DELAY){
				delay-=1;
			}else if (delay==GameControl.BUFF_DELAY){
				if (gameM.playerM.checkDone() && gameM.enemyM.checkDone()){
					if (gameM.turn){
						gameM.playerM.onTurnStart(false);
						gameM.enemyM.stats.useDisplays(EffectBase.CONSTANT,null,gameM.enemyM,gameM.playerM);
						GameEventManager.addGameEvent(GameEvent.PLAYER_TURN);
					}else{
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
				gameUI.updateRound();
				
				delay=GameControl.TURN_LENGTH;
				
				if (gameM.enemyM.exists==false){
					gameM.distance=GameModel.BETWEEN;
					
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
			
			GameEventManager.addGameEvent(GameEvent.PLAYER_HEALTH,gameM.playerM._Health/gameM.playerM.stats.getValue(StatModel.HEALTH));
			
			gameUI.background.shiftBack(GameUI.PLAYER_X-gameM.playerM.view.x);
			
			if (checkDeath(gameM.playerM)){
				kill(gameM.playerM);
			}
			if (checkDeath(gameM.enemyM)){
				kill(gameM.enemyM);
			}
			
			if (gameM.playerM.dead){
				if (gameM.enemyM.dead){
					finishRound(-1);
				}else{
					finishRound(1);
				}
			}else if (gameM.enemyM.dead){
				finishRound(0);
			}
		}
		
		public function startDuel(){
			gameM.distance=GameModel.FAR;
			gameUI.setPositions();
			gameM.playerM.view.action(SpriteView.IDLE);
			gameM.enemyM.view.action(SpriteView.IDLE);
			chooseInit();
			delay=1;
		}
		
		public function duelReward():Number{
			if ((Facade.gameM.enemyM.saveSlot-5)>=Facade.saveC.temp[0][14][gameM.challengeList]){
				var _reward=reward(Facade.gameM.enemyM.saveSlot);
				
				Facade.saveC.temp[0][14][gameM.challengeList]+=1;
				GameData.gold+=_reward;
				GameData.saveCharacterDuel(Facade.gameM.playerM.saveSlot,Facade.saveC.temp[0]);
				
				Facade.saveC.temp[1]=Facade.saveC.challengeArray(Facade.saveC.temp[0][14][gameM.challengeList],gameM.challengeList);
				Facade.gameM.enemyM.saveSlot+=1;
				if (Facade.saveC.temp[0][14][0]>10) GameData.achieve(GameData.ACHIEVE_POWERFUL);
				
				return _reward;
			}else{
				return 0;
			}
		}
		
		public function reward(i:int):int{
			var m:int=(i-4)*(i-4)*60;
			if (m>50000) m=50000;
			return m;
		}
		
		//public function startOfTurn(_v:SpriteModel){
		//public function turbo(){
		//public function pauseGame(b:Boolean,o:Boolean=false){
	}
}