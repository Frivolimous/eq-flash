package ui.windows{
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Bitmap;
	import ui.main.MiniShopUI;
	import utils.GameData;
	
	public class EndWindow extends Sprite{		
		var timerT:Timer=new Timer(1000,15);
		
		var continueF:Function;
		var menuF:Function;
		
		var extra:*;
		
		public function EndWindow(s:String,_menuF:Function,_continueF:Function=null,_shop:Boolean=false,canSkip:Boolean=false,_progressCost:int=-1,_progressF:Function=null){
			if (canSkip && GameData._Save.data.pause[GameData.PAUSE_SKIP_TIMER]){
				if (_shop) new MiniShopUI();
				_continueF();
				Facade.gameC.pauseGame(true);
			}else{
				menuF=_menuF;
				continueF=_continueF;
				
				menuB.update(StringData.LEAVE,goMenu);
				if (continueF==null){
					removeChild(continueB);
					timer.text="";
				}else{
					continueB.update(StringData.CONTINUE,goContinue);
		
					timerT.addEventListener(TimerEvent.TIMER,tick);
					timerT.addEventListener(TimerEvent.TIMER_COMPLETE,goContinue);
					timerT.reset();
					timerT.start();
					timer.text="15";
				}
				
				if (_shop){
					extra=new MiniShopUI;
					addChild(extra);
				}
				display.text=s;
				
				Facade.gameC.pauseGame(true);
				Facade.stage.addChild(this);
			}
		}
		
		
		function tick(e:TimerEvent){
			timer.text=String(15-timerT.currentCount);
		}
		
		function goMenu(){
			if (parent==null) {clear(); return;}
			close();
			menuF();
		}
		
		function goContinue(e:TimerEvent=null){
			if (parent==null) {clear(); return;}
			close();
			continueF();
		}
		
		function continueTimer(i:int=0){
			timerT.start();
		}
		
		function close(){
			if (extra!=null && extra is MiniShopUI){
				extra.close();
			}
			clear();
		}
		
		function clear(){
			if (parent!=null) parent.removeChild(this);
			timerT.stop();
			try{
				timerT.removeEventListener(TimerEvent.TIMER,tick);
				timerT.removeEventListener(TimerEvent.TIMER_COMPLETE,goContinue);
			}catch(e:Error){}
		}
	}
}