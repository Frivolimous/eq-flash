package ui.main{
	import artifacts.*;
	import ui.windows.ConfirmWindow;
	import ui.assets.FadeTransition;
	import utils.GameData;
	import ui.assets.TutorialWindow;
	import ui.windows.AscendZoneWindow;
	
	public class ArtifactUI extends BaseUI{
		/*
		stashInv
		playerInv
		gambleInv
		soulGold
		nameTitle
		doneB
		*/
		//var origin:SpriteModel;
		public var resetCharacter:Boolean=true;
		var transTo:BaseUI;
		
		public function ArtifactUI(_transTo:BaseUI=null){
			origin=Facade.gameM.playerM;
			transTo=_transTo;
			
			doneB.update(StringData.REVIVE,navOut,true);
			//soundB.update(null,muteSound,true);
			playerInv.update(origin);
			stashInv.update(origin);
			stashInv.updateStash(GameData.artifacts,origin);
			gambleInv.update(origin);
			playerInv.drop=stashInv;
			upgradeInv.init(stashInv);
			stashInv.init(playerInv);
			gambleInv.init(stashInv);
			if (transTo==null){
				stashInv.gold=soulGold.gold;
				playerInv.gold=soulGold.gold;
				upgradeInv.gold=soulGold.gold;
				stashInv.updateGold();
			}
			//nameTitle.htmlText=origin.label+" "+origin.title+"\n<font size='16'>"+StringData.level(origin.level)+"</font>";
			
			restock();
			
		}
		
		public function restock(){
			gambleInv.clear();
			if (Facade.gameM.area<101) return;
			
			var _artifacts=GameData.artifacts;
			var _possibles:Array=new Array;
			for (var i:int=0;i<_artifacts.length;i+=1){
				if (_artifacts[i]==-1 && ArtifactData.spawnArtifact(i,0)!=null){
					_possibles.push(i);
				}
			}
			for (i=0;i<3;i+=1){
				if (_possibles.length>0){
					var _this:int=Math.floor(Math.random()*_possibles.length);
					gambleInv.addItemAt(new ArtifactView(ArtifactData.spawnArtifact(_possibles[_this],0)),i);
					_possibles.splice(_this,1);
				}
			}
		}
				
		/*public function noGold(){
			new ConfirmWindow(StringData.CONF_SOUL,225,100,null,0,null,2);
		}*/
		
		override public function openWindow(){
			Facade.currentUI=this;
			
			if (resetCharacter) {
				Facade.saveC.ascendChar(Facade.gameM.playerM);
				if (!GameData.getFlag(GameData.FLAG_ARTIFACTS)){
					GameData.setFlag(GameData.FLAG_ARTIFACTS,true);
					addChild(new ArtifactTutorial);
				}
			}
		}
		
		public function navOut(){
			if (transTo==null){
				new ConfirmWindow("Are you sure?  You cannot return to this screen until you Ascend once more.",225,100,popAscendZoneWindow,0,null,2);
			}else{
				new FadeTransition(this,transTo);
			}
		}
		
		public function popAscendZoneWindow(i:int){
			new AscendZoneWindow(restartCharacter);
		}
		
		public function restartCharacter(_area:int,_level:int){
			var _home:NewCharacterUI=new NewCharacterUI(new HomeUI);
			_home.fromPrestige(_level,_area);
			
			new FadeTransition(this,_home);
		}
		
		//public function muteSound(){
			//Facade.soundC.mute=!Facade.soundC.mute;
			//soundB.toggled=Facade.soundC.mute;
		//}
	}
}