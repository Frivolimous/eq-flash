package ui.effects{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class AnimatedEffect extends MovieClip{
		public static const GREEN_WISPS:int=1,
							BLUE_WISPS:int=2,
							HORNS:int=3,
							WINGS:int=4,
							FLAME:int=5,
							REVIVE:int=6,
							WILL:int=7,
							FEATHERS:int=8,
							DICE:int=9,
							CYCLOPS:int=10,
							SCREAM:int=11;
							
		
		public function AnimatedEffect (origin:*,i:int){
			if (i==-1) return;
			x=origin.view.x;
			y=origin.view.y;
			scaleX=scaleY=1;
			gotoAndStop(i);
			addEventListener(Event.ENTER_FRAME,update,false,0,true);
			Facade.gameUI.gameV.addChild(this);
		}
		
		public function update(e:Event){
			if (display.currentFrame>=display.totalFrames){
				removeEventListener(Event.ENTER_FRAME,update,false);
				parent.removeChild(this);
			}
		}
	}
}