package ui.windows{
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Bitmap;
	import ui.main.MiniShopUI;
	import utils.GameData;
	
	public class EndWindow extends Sprite{
		
		var timerT:Timer=new Timer(1000,15);
		
		var scoreL:int=0;
		var scoreR:int=0;
		
		var continueF:Function;
		var progressF:Function;
		var progressCost:int;
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
				
				if (_progressCost<=0){
					removeChild(deathMerchant);
				}else{
					deathMerchant.powerT.updateDisplay();
					deathMerchant.powerT.disabled=true;
					deathMerchant.continue2B.update(String(_progressCost)+" Tokens",goProgress);
					deathMerchant.continue2B.setDesc("Revive at Current Progress","Revives you and leaves the Progress Counter (top right) intact, allowing you to resume your current progress.");
					progressCost=_progressCost;
					progressF=_progressF;
				}
				
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
		
		function goProgress(){
			timerT.stop();
			if (GameData.kreds>=progressCost){
				new ConfirmWindow("You sure you want to spend "+progressCost.toString()+" PTs?",50,50,finishGoProgress,0,continueTimer);
			}else{
				new TokenWindow(continueTimer);
				//new ConfirmWindow("You don't have enough Power Tokens to do this action; please purchase ",50,50,finishGoProgress,0,continueTimer);
			}
		}
		
		function finishGoProgress(i:int=0){
			if (parent==null) {clear(); return;}
			close();
			GameData.kreds-=progressCost;
			progressF();
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