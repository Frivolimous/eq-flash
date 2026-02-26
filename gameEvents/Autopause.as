package gameEvents {
	import utils.GameData;
	import ui.DialogueUI;
	
	public class Autopause {
		public static var below25:Boolean=false;
		
		public static function checkEvent(e:GameEvent){
			switch(e.type){
				case GameEvent.ENCOUNTER_BOSS:
					if (!GameData._Save.data.pause[GameData.PAUSE_TURN]){
						if (GameData._Save.data.pause[GameData.PAUSE_BOSS_ALL]){
							Facade.gameUI.setPause(true);
						}else if (GameData._Save.data.pause[GameData.PAUSE_BOSS]){
							Facade.gameUI.setPause(true);
							GameData._Save.data.pause[GameData.PAUSE_BOSS]=false;
						}
					}
					break;
				/*case GameEvent.PLAYER_HEALTH:
					if (e.values<0.25){
						if (!below25 && GameData._Save.data.pause[GameData.PAUSE_HEALTH]){
							Facade.gameUI.setPause(true);
						}
						below25=true;
					}else{
						below25=false;
					}
						
					break;
				case GameEvent.PLAYER_TURN:
					if (GameData._Save.data.pause[GameData.PAUSE_TURN]){
						Facade.gameUI.setPause(true);
					}
					break;*/
				case GameEvent.MEET_SHADOW:
					if (e.values==0 || (!GameData._Save.data.pause[GameData.PAUSE_SKIP] && (e.values==10 || e.values==25 || e.values==50 || e.values==100 || e.values==200 || e.values==300 || e.values==400 || e.values==1000))){
						new DialogueUI(true,e.values);
					}
					break;
				case GameEvent.KILL_SHADOW:
					if (e.values==0 || (!GameData._Save.data.pause[GameData.PAUSE_SKIP] && (e.values==10 || e.values==25 || e.values==50 || e.values==100 || e.values==200 || e.values==300 || e.values==400 || e.values==1000))){
						new DialogueUI(false,e.values);
					}
					break;
				case GameEvent.INVENTORY_FULL:
					if (GameData._Save.data.pause[GameData.PAUSE_ITEMS]){
						Facade.gameUI.setPause(true);
					}
					break;
				case GameEvent.COVER_ITEM:
					if (GameData._Save.data.pause[GameData.PAUSE_TURN]){
						Facade.gameUI.setPause(false);
					}
					break;
				case GameEvent.LEVEL_UP:
					if (GameData._Save.data.pause[GameData.PAUSE_LEVEL]){
						Facade.gameUI.setPause(true);
					}
					break;
			}
		}
	}
	
}
