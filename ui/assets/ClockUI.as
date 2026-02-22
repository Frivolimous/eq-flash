package ui.assets{
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class ClockUI extends Sprite{
		public var time:BitText=new BitText();
		public var updateT:Timer=new Timer(1000);
		
		public function ClockUI(){
			time.numberFont();
			updateT.addEventListener(TimerEvent.TIMER,update);
			updateT.start();
			addChild(time);
		}
		
		public function update(e:TimerEvent){
			time.text=(new Date).toLocaleTimeString();
			Facade.gameM.scores[4]+=1;
		}
	}
}