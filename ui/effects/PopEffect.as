package ui.effects{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class PopEffect extends MovieClip{
		public static const CRIT:int=1,
							FIRE:int=2,
							MAGIC:int=3,
							TOXIC:int=4,
							HOLY:int=5,
							TEST:int=6,
							BUBBLE:int=7,
							BLOOD:int=8,
							MUTE:int=9,
							BOMB:int=10,
							CLEAR_BUBBLE:int=11,
							RADIANCE:int=12,
							DARK:int=13,
							BROWN_BURST:int=14;
							
		
		public function PopEffect (origin:SpriteModel,i:int){
			if (i==-1) return;
			x=origin.view.x-41;
			y=origin.view.y-100;
			scaleX=1.3*origin.view.scaleX/Math.abs(origin.view.scaleX);
			scaleY=1.3;
			gotoAndStop(i);
			addEventListener(Event.ENTER_FRAME,update,false,0,true);
			Facade.gameUI.gameV.addChild(this);
		}
		
		public function update(e:Event){
			if (alpha>0){
				alpha-=0.05;
			}else{
				removeEventListener(Event.ENTER_FRAME,update,false);
				parent.removeChild(this);
			}
		}
	}
}