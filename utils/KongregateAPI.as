package utils {
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.system.Security;
	import items.ItemView;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import ui.windows.ConfirmWindow;
	import gameEvents.GameEvent;
	import ui.windows.TokenWindow;
	import hardcore.HardcoreGameControl;

	public class KongregateAPI {
		public static var _Success:Function;

		// public static const LEVEL_REACHED:String="levelReached",
		// 					AREA_REACHED:String="areaReached",
		// 					CHALLENGE_REACHED:String="challengeReached",
		// 					HARDCORE_CHALLENGE_REACHED:String="warriorCReached",
		// 					TOURNAMENT1_REACHED:String="tournament1Reached",
		// 					ASCEND_REACHED:String="numAscends",
		// 					EPIC_REACHED:String="epicReached";
								
		// public static var disabled:Boolean = true;
		
		// public static function submitAll(){
		// 	if (disabled) return;
			
		// 	submit(AREA_REACHED);
		// 	submit(LEVEL_REACHED);
		// 	submit(CHALLENGE_REACHED);
		// 	submit(HARDCORE_CHALLENGE_REACHED);
		// 	submit(TOURNAMENT1_REACHED);
		// 	submit(ASCEND_REACHED);
		// 	submit(EPIC_REACHED);
			
		// }
		
		// public static function submit(s:String){
		// 	if (disabled) return;
			
		// 	var i:int=0;
		// 	switch(s){
		// 		case LEVEL_REACHED:
		// 			if (Facade.gameC is HardcoreGameControl) return;
		// 			i=Facade.gameM.playerM.level;
		// 			break;
		// 		case AREA_REACHED:
		// 			if (Facade.gameC is HardcoreGameControl) return;
		// 			i=Facade.gameM.area;
		// 			break;
		// 		case CHALLENGE_REACHED:
		// 			if (Facade.gameM.playerM.challenge[0]>0){
		// 				i=Facade.saveC.challengeArray(Facade.gameM.playerM.challenge[0]-1,0)[1];
		// 			}
		// 			testChallengeDefeated(i);
		// 			break;
		// 		case TOURNAMENT1_REACHED:
		// 			if (Facade.gameM.playerM.challenge[1]>0){
		// 				i=Facade.saveC.challengeArray(Facade.gameM.playerM.challenge[1]-1,1)[1];
		// 			}
		// 			break;
		// 		case HARDCORE_CHALLENGE_REACHED:
		// 			//return;
		// 			i=GameData.hardcore;
		// 			/*if (GameData.hardcore>0){
		// 				i=Facade.saveC.challengeArray(GameData.hardcore-1,0)[1];
		// 			}*/
		// 			break;
		// 		case ASCEND_REACHED:
		// 			i=GameData.getScore(GameData.SCORE_ASCENDS);
		// 			if (i>=50){
		// 				GameData.achieve(GameData.ACHIEVE_ASCEND_50);
		// 			}
		// 			break;
		// 		case EPIC_REACHED:
		// 			i=GameData.epics[0];
		// 			break;
		// 	}
		// 	// api.stats.submit(s,i);
		// }
		
		// public static function checkEvent(e:GameEvent){
		// 	switch(e.type){
		// 		case GameEvent.AREA_REACHED: submit(AREA_REACHED); break;
		// 		case GameEvent.EPIC_AREA_REACHED: submit(EPIC_REACHED); break;
		// 		case GameEvent.CHALLENGE_DEFEATED: submit(CHALLENGE_REACHED); submit(TOURNAMENT1_REACHED);break;
		// 		case GameEvent.ASCEND: submit(ASCEND_REACHED); break;
		// 		case GameEvent.LEVEL_UP: submit(LEVEL_REACHED); break;
		// 		case GameEvent.CHALLENGE_AREA_REACHED:
		// 		case GameEvent.HARDCORE_CHALLENGE_DEFEATED: submit(HARDCORE_CHALLENGE_REACHED); break;
		// 	}
		// }
		
		// public static function testChallengeDefeated(i:int=-1){
		// 	if (i==-1){
		// 		if (Facade.gameM.playerM.challenge[0]>0){
		// 			var i:int=Facade.saveC.challengeArray(Facade.gameM.playerM.challenge[0]-1,0)[1];
		// 		}
		// 	}
		// 	if (i>=800){
		// 		GameData.achieve(GameData.ACHIEVE_ROGUE);
		// 	}
		// }

		public static function buyTokens(rSuccess:Function,amount:int){
			_Success=rSuccess;
			new ConfirmWindow("Finish purchasing this item using 0 Power Tokens?",50,50,finishIngamePurchase,0);
		}

		public static function finishIngamePurchase(_amount:int){
			_Success();
			_Success=null;
		}
	}	
}
