package ui.main{
	import flash.display.Sprite;
	import ui.windows.ConfirmWindow;
	import ui.assets.FadeTransition;
	import flash.events.Event;
	import utils.GameData;
	import utils.PlayfabAPI;
	
	public class HallUI extends BaseUI{
		var achieveA:Array=new Array(10);
		var scores:Array=new Array(6);
		
		public function HallUI(){
			doneB.update(StringData.LEAVE,navOut);
			soundB.update(null,muteSound,true);
			eraseB.update(null,eraseData);
			onlineB.update(StringData.ONLINE,popOnline);
			
			achieveA=[achieve0,achieve1,achieve2,achieve3,achieve4,achieve5,achieve6,achieve7,achieve8,achieve9];

			for (var i:int=0;i<10;i+=1){
				achieveA[i].update(StringData.achieveName(i),nothing);
				achieveA[i].setDesc(StringData.achieveName(i),StringData.achieveDesc(i));
			}
			scores=[monsterT,deathT,damageT,areaT,timeT,characterT];
		}
		
		function nothing(i:int=0){
		}
		
		override public function openWindow(){
			soundB.toggled=Facade.soundC.mute;
			for (var i:int=0;i<10;i+=1){
				if (GameData.hasAchieved(i)){
					achieveA[i].disabled=false;
					achieveA[i].setDesc(StringData.achieveName(i)+StringData.locked(1,false));
				}else{
					achieveA[i].disabled=true;
					achieveA[i].setDesc(StringData.achieveName(i)+StringData.locked(1,true));
				}
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
			if (utils.PlayfabAPI.SUBMITTING==0){
				removeEventListener(Event.ENTER_FRAME,waitTransfer);
				new FadeTransition(this,new HomeUI);
			}
		}
		
		public function muteSound(){
			Facade.soundC.mute=!Facade.soundC.mute;
			soundB.toggled=Facade.soundC.mute;
		}
	}
}