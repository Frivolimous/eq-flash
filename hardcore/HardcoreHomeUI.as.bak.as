package hardcore{
	//for the hardcore challenge event, also with HardcoreGameControl
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import ui.StatusUI;
	import ui.windows.ConfirmWindow;
	import ui.assets.FadeTransition;
	import ui.assets.InstantTransition;
	import utils.GameData;
	import ui.assets.ScrollAnnounce;
	import utils.KongregateAPI;
	import ui.main.NewCharacterUI;
	import ui.main.BaseUI;
	import ui.main.ArtifactUI;
	
	public class HardcoreHomeUI extends BaseUI{
		public static const SAVESLOT:int=-100;
		
		var gameM:GameModel=Facade.gameM;
		
		public function HardcoreHomeUI(){
			newCharB.update(StringData.NEW_CHAR,popNew);
			
			statusB.update(StringData.STATUS,popStatistics);
			artifactsB.update("Artifacts",popArtifacts);
			adventureB.update("Adventure",goAdventure);
			
			rulesB.update("Rules",popRules);
			
			doneB.update(StringData.LEAVE,navOut,true);
			soundB.update(null,muteSound,true);
		}
		
		public function popNew(){
			new ConfirmWindow("Create a new character?  This will overwrite your current character!",50,50,finishPopNew);
		}
		
		public function finishPopNew(i:int=0){
			var _newCUI:NewCharacterUI=new NewCharacterUI(this);
			_newCUI.saveSlot=SAVESLOT;
			new FadeTransition(this,_newCUI);
		}
		
		public function popStatistics(){
			var _status:StatusUI=new StatusUI(this,gameM.playerM);
			_status.stashLocked=true;
			//_status.skillUI.locked=false;
			new FadeTransition(this,_status);
		}
		
		public function popArtifacts(){
			var _artifactUI:ArtifactUI=new ArtifactUI(this);
			_artifactUI.resetCharacter=false;
			_artifactUI.stashInv.maxStash(gameM.playerM,getArtifactLevel(gameM.area));
			_artifactUI.playerInv.blankLocks();
			_artifactUI.playerInv.update(gameM.playerM,_artifactUI.stashInv._Source);
			_artifactUI.soulGold.gold.text="---";
			_artifactUI.upgradeInv.locked=true;
			_artifactUI.upgradeInv.box.gotoAndStop(2);
			_artifactUI.doneB.update("Continue",_artifactUI.navOut,true);
			new FadeTransition(Facade.currentUI,_artifactUI);
		}
		
		public function getArtifactLevel(_zone:int):int{
			return Math.min(Math.max((_zone-100)/20,0),10)
		}
		
		public function goAdventure(){
			Facade.gameC=new HardcoreGameControl();//Facade.worldC;
			Facade.gameUI.transTo=this;
			new FadeTransition(this,Facade.gameUI);
		}
		
		public function popRules(){
			new ScrollAnnounce("<b>Hardcore Challenge Mode!</b>\n Dates: June 19 2017 - July 9 2017\n\nIntroducing the first Alternate Adventure Challenge!  See how far you can push with one character into the Hardcore World!\n\n<u>Rules</u>\n- One Life: you die, you die!\n- Only 3 monsters per zone\n- Gain one character level every number of zones with no level cap\n- Acquire one magic item after every monster and one premium (with a chance for super-prem) after every boss withnolevelcap\n- Items automatically refill each zone- Start with one Artifact and Artifact Slots and Levels increase as you travel further\n-No Shadow Realms\n\n<b>Milestone Rewards instantly earned:</b>\nz100: 10pt ; z200: Chaos Essence ; z400: 15pt ; z700: Essence ; z1000: 20pt ; z1500: Epic Essence; z2000: 25pt ; z2500: Chaos Essence x5 ; z3000: 30pt ; z4000: Essence x5\n\n<u>Rewards</u> (granted at the end of the event):\n<b>Rank 1:</b> Trophy, 1 Epic Essence, 3 Essences, 5 Chaos Essences, 60 Power Tokens\n<b>Rank 2:</b> Trophy, 2 Essences, 3 Chaos Essences, 40 Power Tokens\n<b>Rank 3:</b> Trophy, 1 Essence, 2 Chaos Essences, 20 Power Tokens\n<b>Rank 4-10:</b> Trophy, 2 Chaos Essences\n<b>Rank 11-25:</b> Trophy, 1 Chaos Essence\n<b>Rank 26-50:</b> Participation Award, 1 Chaos Essence\n<b>Participant:</b> Participation Award\n");
		}
		
		public function navOut(i:int=0){
			if (GameData.BUSY) return;
			Facade.gameM.duel=false;
			new FadeTransition(this,Facade.menuUI);
			Facade.saveC.startLoadChar(Facade.gameM.playerM,GameData.lastChar);
		}
		
		override public function openWindow(){
			soundB.toggled=Facade.soundC.mute;
			if (Facade.gameM.playerM.saveSlot==SAVESLOT){
				Facade.saveC.reloadJust(Facade.gameM.playerM);
				finishOpen();
			}else{
				Facade.saveC.startLoadChar(Facade.gameM.playerM,SAVESLOT,true,null,finishOpen);
			}
		}
		
		public function finishOpen(){
			if (gameM.playerM.saveSlot==-1){
				var _newCUI:NewCharacterUI=new NewCharacterUI(this);
				_newCUI.saveSlot=SAVESLOT;
				new InstantTransition(this,_newCUI);
				popRules();
			}else{
				display.update(gameM.playerM);
				zones.text=String(Facade.gameM.area)+"\n"+String(GameData.hardcore);
			}
		}
		
		
		public function muteSound(){
			Facade.soundC.mute=!Facade.soundC.mute;
			soundB.toggled=Facade.soundC.mute;
		}
	}
}