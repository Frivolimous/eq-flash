package hardcore{
	
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
	
	public class HardcoreDuelControl extends DuelControl{		
		override public function finishRound(i:int){
			if (i==-2){ //TIMED OUT
				new EndWindow(StringData.getEndText(StringData.END_TIE,gameM.playerM,gameM.enemyM),gameUI.navOut,gameUI.restart);
			}else if (i==-1){ //TIE
				new EndWindow("Somehow, you both died at once... round ends in a DRAW!",gameUI.navOut,gameUI.restart);
			}else if (i==0){ //WIN
				//var _reward:Number=Facade.menuUI.duelUI.duelReward();
				GameData.hardcore+=1;
				Facade.saveC.temp[1]=Facade.saveC.challengeArray(GameData.hardcore,0);
				Facade.gameM.enemyM.saveSlot=GameData.hardcore+5;
				GameData.saveHardcore();
				GameEventManager.addGameEvent(GameEvent.HARDCORE_CHALLENGE_DEFEATED);
				new EndWindow("You defeated "+gameM.enemyM.label+", and move on to round "+String(GameData.hardcore+1)+"!",gameUI.navOut,gameUI.restart,false,true);
			}else{ //LOSE
				GameData.hardcore=0;
				Facade.saveC.temp[1]=Facade.saveC.challengeArray(GameData.hardcore,0);
				Facade.gameM.enemyM.saveSlot=GameData.hardcore+5;
				GameData.saveHardcore();
				new EndWindow("NOOOOOOOOOOOOOOOOOOO!!!!!!!!!!!\nYou lost the round!  You must restart from Bobo 1.",gameUI.navOut,gameUI.restart);
			}
		}

		public static var eliminated:Array=["8z8z","Time_Master","dja410","wizardness","Furball777","neit314","yamahaclavinova1","pizza87760","niconicolas","Battenberger","bonez893","lounsbery","GelanderLexC","opacitythebomb","archaeryon","fasman1234","himoo1","norgath","User2351","TrcKMaIsTeR","greatzar","Jarty","Zais764",	"Captain_Catface","virtual_maniac","VerboseandMorose","zver8","lPro100xl","owerske","lenchiko","Dejection","wtfzoids","TheRelic","lordasmodai","Batmanlin","wiffasniffa","Zgabouften","kasugol","tepduang","AgithS","matjdavis","romain5279","denbart93","EchoStar37","sryker","j6u6fu0","Hunterstyle89","Celebris","thegameslayer","Methangas","ohjajaja"];
		public static function getEliminatedPosition():int{
			var _name:String=Facade.steamAPI.getName();
			for (var i:int=0;i<eliminated.length;i+=1){
				if (eliminated[i]==_name){
					 return 1+i;
				}
			}
			return 0;
		}
	}
}