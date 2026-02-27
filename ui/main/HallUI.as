package ui.main{
	import flash.display.Sprite;
	import ui.windows.ConfirmWindow;
	import ui.assets.FadeTransition;
	import flash.events.Event;
	import utils.GameData;
	import utils.AchieveData;
	
	public class HallUI extends BaseUI{
		var achieveA:Array=new Array(10);
		var scores:Array=new Array(6);
		
		public function HallUI(){
			doneB.update(StringData.LEAVE,navOut);
			soundB.update(null,muteSound,true);
			eraseB.update(null,eraseData);
			onlineB.update(StringData.ONLINE,popOnline);
			
			achieveA=[achieve0,achieve1,achieve2,achieve3,achieve4,achieve5,achieve6,achieve7,achieve8,achieve9];

			achieveA[0].update("Deft",nothing);
			achieveA[0].setDesc("Deft","Score a massive blow");
			achieveA[1].update("Clever",nothing);
			achieveA[1].setDesc("Clever","Find the hidden treasure");
			achieveA[2].update("Ungifted",nothing);
			achieveA[2].setDesc("Ungifted","Fail at your duty");
			achieveA[3].update("Studious",nothing);
			achieveA[3].setDesc("Studious","Learn something important");
			achieveA[4].update("Enlightened",nothing);
			achieveA[4].setDesc("Enlightened","Achieve a degree of mastery");
			achieveA[5].update("Powerful",nothing);
			achieveA[5].setDesc("Powerful","Prove your worth in the arena");
			achieveA[6].update("Holy",nothing);
			achieveA[6].setDesc("Holy","Buy into the Myth");
			achieveA[7].update("Wild",nothing);
			achieveA[7].setDesc("Wild","Grow without focus");
			achieveA[8].update("Noble",nothing);
			achieveA[8].setDesc("Noble","Roam far across the land");
			achieveA[9].update("Ascend!",nothing);
			achieveA[9].setDesc("Ascend!","Travel further than you can dream");

			scores=[monsterT,deathT,damageT,areaT,timeT,characterT];
		}
		
		function nothing(i:int=0){
		}
		
		override public function openWindow(){
			soundB.toggled=Facade.soundC.mute;
			for (var i:int=0;i<AchieveData.TALENT_ACHIEVEMENTS.length;i+=1){
				achieveA[i].disabled=!AchieveData.hasAchieved(AchieveData.TALENT_ACHIEVEMENTS[i]);
				achieveA[i].setDesc(StringData.locked(1,achieveA[i].disabled)); //add name back in here?
			}
			for (i=0;i<6;i+=1){
				scores[i].text=String(GameData.getScore(i));
			}
			var _time:Number=GameData.getScore(4);
			var _hours:int=_time/360;
			var _mins:int=(_time%360)/60;
			var _secs:int=(_time%60);
			if (_hours>0){
				scores[4].text=_hours+"h "+_mins+"m";
			}else{
				scores[4].text=_mins+"m "+_secs+"s";
			}
		}
		
		public function navOut(){
			new FadeTransition(this,Facade.menuUI);
		}
		
		public function popOnline(){
			new ConfirmWindow("This button will display the online leaderboard.");
		}
		
		public function eraseData(){
			new ConfirmWindow(StringData.CONF_ERASE,50,50,finishErase,0);
		}
		
		public function finishErase(i:int){
			Facade.gameM.clearData();
			Facade.gameM.playerM.exists=false;
			addEventListener(Event.ENTER_FRAME,waitTransfer);
		}
		
		public function waitTransfer(e:Event){
			removeEventListener(Event.ENTER_FRAME,waitTransfer);
			new FadeTransition(this,new HomeUI);
		}
		
		public function muteSound(){
			Facade.soundC.mute=!Facade.soundC.mute;
			soundB.toggled=Facade.soundC.mute;
		}
	}
}