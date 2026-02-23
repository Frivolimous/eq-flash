package ui.main{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import ui.StatusUI;
	import ui.windows.ConfirmWindow;
	import ui.assets.FadeTransition;
	import ui.assets.InstantTransition;
	import utils.GameData;
	import ui.assets.PopCraft;
	import ui.assets.PopRelicBundles;
	
	public class HomeUI extends BaseUI{
		var listUI:Sprite=new Sprite;
		var cOpen:*;
		
		public function HomeUI(){
			newCharB.update(StringData.NEW_CHAR,popNew);
			loadCharB.update(StringData.LOAD_CHAR,popLoad);
			statusB.update(StringData.STATUS,popStatistics);
			stashB.update(StringData.STASH,popStash);
			doneB.update(StringData.LETSGO,navOut,true);
			soundB.update(null,muteSound,true);
			
			addChild(listUI);
			cOpen=listUI;
		}
		
		public function popNew(){
			if (GameData.numCharacters<5){
				new FadeTransition(this,new NewCharacterUI(this));
			}else{
				new ConfirmWindow(StringData.CONF_TOO_MANY);
			}
		}
		
		public function popLoad(){
			new FadeTransition(this,new LoadCharacterUI(this));
		}
		
		public function popStatistics(){
			new FadeTransition(this,new StatusUI(this,Facade.gameM.playerM));
		}
		
		public function popStash(){
			if (!stashB.disabled){
				var _statusUI:StatusUI=new StatusUI(this,Facade.gameM.playerM);
				_statusUI.toTheTop(2);
				new FadeTransition(this,_statusUI);
			}
		}
		
		public function navOut(){
			new FadeTransition(this,Facade.menuUI);
		}
		
		override public function openWindow(){
			soundB.toggled=Facade.soundC.mute;
			if (GameData.numCharacters==0){
				new InstantTransition(this,new NewCharacterUI(this));
			}else{
				if (Facade.gameM.playerM.exists==false){
					stashB.disabled=true;
					Facade.saveC.startLoadChar(Facade.gameM.playerM,GameData.lastChar,true,null,finishOpen2);
				}else{
					finishOpen2();
				}
			}
			if (!GameData._Save.data.bundlePopped && GameData.getFlag(GameData.FLAG_TUTORIAL)){
				var _pop:PopRelicBundles=new PopRelicBundles();
				Facade.stage.addChild(_pop);
				GameData._Save.data.bundlePopped=true;
			}
		}
		
		public function finishOpen2(){
			display.update(Facade.gameM.playerM);
			
			if (Facade.gameM.playerM.level>=2){
				stashB.disabled=false;
			}else{
				stashB.disabled=true;
			}
			
		}
		
		public function muteSound(){
			Facade.soundC.mute=!Facade.soundC.mute;
			soundB.toggled=Facade.soundC.mute;
		}
	}
}