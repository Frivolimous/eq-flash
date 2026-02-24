package ui.main{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import ui.windows.ConfirmWindow;
	import ui.assets.FadeTransition;
	import utils.GameData;
	import flash.events.Event;
	import flash.text.TextField;
	import artifacts.ArtifactData;
	import gameEvents.GameEvent;
	import gameEvents.GameEventManager;
	
	public class TempleUI extends BaseUI{
		
		public function TempleUI(){
			mysteryG.restrict="0-9";
			donateB.update(StringData.YES,buyDonate);
			
			ascendB.update(StringData.ASCEND,popAscend);
			
			doneB.update(StringData.LETSGO,navOut,true);
			soundB.update(null,muteSound,true);
		}
		
		public function popStatistics(){
			//new FadeTransition(this,new StatusUI(this,gameM.playerM));
		}
		
		public function navOut(){
			new FadeTransition(this,Facade.menuUI);
		}
		
		override public function openWindow(){
			mysteryG.text="1000";
			soundB.toggled=Facade.soundC.mute;
			display.update(Facade.gameM.playerM);
			currentSoul.gold.text=String(GameData.souls);
			
			var slots:int=0;
			for (var i:int=0;i<GameData.artifacts.length;i+=1){
				if (GameData.artifacts[i]!=-1){
					slots+=1;
				}
			}
			if (Facade.gameM.area>=101 || slots>0 || Facade.gameM.playerM.arts[2]!=false){
				ascendB.disabled=false;
				ascendB.updateLabel(StringData.ASCEND);
				soulGold.gold.text=ArtifactData.zoneToSoul(Facade.gameM.area,Facade.gameM.revivedArea);
			}else{
				ascendB.updateLabel(StringData.NO_ASCEND);
				ascendB.disabled=true;
				soulGold.gold.text="---";
			}
			updateGold();
			addEventListener(Event.ENTER_FRAME,onTick);
		}
		
		override public function closeWindow(){
			removeEventListener(Event.ENTER_FRAME,onTick);
		}
		
		public function muteSound(){
			Facade.soundC.mute=!Facade.soundC.mute;
			soundB.toggled=Facade.soundC.mute;
		}
		
		public function onTick(e:Event){
			var _gold:int=int(mysteryG.text);
			if (_gold>GameData.gold){
				mysteryG.text=GameData.gold.toString();
			}
		}
		
		public function popAscend(){
			new ConfirmWindow("Your character will be reset, keeping gold and items but losing all levels and all progress.  Proceed?",50,50,finishAscend);
		}
		
		public function finishAscend(i:int){
			GameData.souls+=ArtifactData.zoneToSoul(Facade.gameM.area,Facade.gameM.revivedArea);
			if (Facade.gameM.area>=101) GameData.addAscend();
			GameEventManager.addGameEvent(GameEvent.ASCEND);
			new FadeTransition(this,new ArtifactUI);
		}
		
		public function buyDonate(){
			var suns:Number=(int(mysteryG.text)/900);
			GameData.gold-=int(mysteryG.text);
			new ConfirmWindow("The gods thank you for your donation!\nA warm glow surrounds you with the strength of "+String(Math.ceil(suns))+" sun"+(suns==1?"":"s")+".");
			GameData.suns+=suns;
			GameData.saveThis(GameData.SCORES);
			updateGold();
		}

		public function updateGold(){
			if (goldBox!=null){
				var _gold:Number=GameData.gold;
				var _letter:int=0;
				if (_gold>=10000){
					while(_gold>=1000){
						_gold/=1000;
						_letter+=1;
					}
				}
				if (_gold>=100){
					_gold=Math.round(_gold);
				}else if (_gold>10){
					_gold=Math.round(_gold*10)/10;
				}else{
					_gold=Math.round(_gold*100)/100;
				}
				goldBox.gold.text=String(_gold);
				switch(_letter){
					case 1: goldBox.gold.appendText("k"); break;
					case 2: goldBox.gold.appendText("m"); break;
					case 3: goldBox.gold.appendText("b"); break;
					case 4: goldBox.gold.appendText("t"); break;
				}
			}
		}
	}
}