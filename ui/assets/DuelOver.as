package ui.assets{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class DuelOver extends MovieClip{
		var fadeUp:Boolean=true;
		var count:int=50;
		var textValue:Array=new Array();
		
		public function DuelOver(_ln:String,_lt:String,_rn:String,_rt:String){
			textValue[0]=_ln;
			textValue[1]=_lt;
			textValue[2]=_rn;
			textValue[3]=_rt;
			name0.text=_ln;
			title0.text=_lt;
			name1.text=_rn;
			title1.text=_rt;
			
			addEventListener(Event.ENTER_FRAME,onTick);
			Facade.gameC.pauseGame(true);
			Facade.stage.addChild(this);
		}
		
		public function onTick(e:Event){
			/*if (fadeUp){
				alpha+=0.03;
				if (alpha>=1){
					fadeUp=false;
				}
			}else{
				if (count>0){
					count-=1;
				}else{
					alpha-=0.03;
					if (alpha<=0){
						parent.removeChild(this);
						Facade.gameC.pauseGame(false);
						removeEventListener(Event.ENTER_FRAME,onTick);
					}
				}
			}*/
			name0.text=textValue[0];
			title0.text=textValue[1];
			name1.text=textValue[2];
			title1.text=textValue[3];
			if (currentFrame==totalFrames){
				parent.removeChild(this);
				Facade.gameC.pauseGame(false);
				removeEventListener(Event.ENTER_FRAME,onTick);
			}
		}
	}
}