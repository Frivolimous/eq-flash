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
	
	public class EpicGameControl extends GameControl{
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
			GameData.addScore(GameData.SCORE_DEATHS,1);
			gameM.deathStreak+=1;
			if (gameM.eCount>gameM.eTotal){
				//nextLevel();
			}else{
				gameM.eCount=0;
			}
			
			Facade.saveC.saveFromEpic();
			
			if (gameUI.goingTown){
				gameUI.navOut();
			}else{
				new EndWindow("You have died!\nSuch a shame...\n\nDeath Streak: "+String(gameM.deathStreak),navOut,revive,true);
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
				if (GameModel.random()<_effect.modify(gameM.playerM).userate){
					gameM.playerM.increaseBeltStack(_effect.values);
					new FlyingText(gameM.playerM,"Found Stacks!",0xaaffaa);
				}
			}
			gameM.playerM.buffList.clearEndFight();
			
			if (gameM.eCount==gameM.eTotal){
				getBossReward();
				nextLevel();
			}else{
				getMobReward();
				/*if (GameData.clocks>0){
					getMobReward();
					GameData.clocks-=1;
					if (GameData.clocks==0){
						gameUI.removeBuff(true,BuffData.PROGRESS_BOOST);
						new ConfirmWindow("Your last progress boost ran out!  Progress Speed back to normal.");
					}
				}*/
				Facade.saveC.saveFromEpic();
			}
		}
		
		override function getBossReward(){
			/*if (gameM.areaType>2){
				var _item:ItemView=new ItemView(ItemData.shadowItem());
			}else{
				_item=new ItemView(ItemData.findItem(gameM.area,1));
			}
			gameUI.addItem(_item);*/
			if (gameM.areaType==3){ //Shadow
				gameUI.addItem(new ItemView(ItemData.enchantItem(ItemData.spawnItem(15,135),0)));
			}else if ((gameM.area-3)%20==0){
				gameUI.addItem(new ItemView(ItemData.enchantItem(ItemData.spawnItem(15,135),1)));
			}else if ((gameM.area-13)%20==0){
				gameUI.addItem(new ItemView(ItemData.spawnItem(15,136)));
			}else if (gameM.area%3==1){
				gameUI.addItem(new ItemView(ItemData.spawnItem(15,135)));
			}else{
				gameUI.addItem(new ItemView(ItemData.suffixItem(ItemData.spawnItem(15,135),Math.floor(Math.random()*30))));
			}
			gameUI.progress+=1;
		}
			
		override function getMobReward(){
			/*if (Math.random()<gameM.playerM.stats.getValue(StatModel.ILOOT)){
				var _item:ItemView=new ItemView(ItemData.findItem(gameM.area,gameM.playerM.stats.getValue(StatModel.ILOOT)));
				gameUI.addItem(_item);
			}*/
			gameUI.progress+=1;
			GameData.addScore(GameData.SCORE_KILLS,1);
		}
		
		override public function nextLevel(_areaType:int=-1){
			gameUI.background.addLast();
			//gameM.area+=1;
			GameData.setupZone(gameM.area+1,true);
			//gameM.setupArea(gameM.area+1);
			gameM.deathStreak=0;
			spawn=99;
			
			GameEventManager.addGameEvent(GameEvent.EPIC_AREA_REACHED,gameM.area);
			
			Facade.saveC.saveFromEpic();
		}
		
		override public function newEnemy(){
			EnemyData.newCreature(gameM.enemyM,GameData.zone[2],gameM.enemyType,-1,gameM.areaType);
			gameM.enemyM.view.y=GameUI.FLOOR_Y;
			gameM.enemyM.view.x=GameUI.VIEW_WIDTH+100;
			gameV.addChild(gameM.enemyM.view);
		}

		override public function newBoss(){
			EnemyData.newBoss(gameM.enemyM,GameData.zone[2],gameM.area,gameM.enemyType,gameM.areaType);
			gameM.enemyM.view.y=GameUI.FLOOR_Y;
			gameM.enemyM.view.x=GameUI.VIEW_WIDTH+50;
			gameV.addChild(gameM.enemyM.view);
			GameEventManager.addGameEvent(GameEvent.ENCOUNTER_BOSS,gameM.enemyM);
		}
	}
}