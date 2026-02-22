package ui.assets{
	import flash.display.Sprite;
	import flash.events.Event;
	import ui.main.BaseUI;
	import utils.GameData;
	
	public class FadeTransition extends Sprite{
		var transFrom:*;
		var transTo:*;		
		
		var fadeUp:Boolean;
		var waiting:int=0;
		
		public function FadeTransition(_origin:*,_target:*){
			graphics.beginFill(0);
			graphics.drawRect(0,0,Facade.WIDTH,Facade.HEIGHT);
			addEventListener(Event.ENTER_FRAME,onTick);
		
			transFrom=_origin;
			transTo=_target;
			
			Facade.stage.addChild(this);
			alpha=0;
			fadeUp=true;
		}
		
		function onTick(e:Event){
			if (fadeUp){
				alpha+=.1
				if (alpha>=1){
					if (waiting==0){
						transFrom.parent.removeChild(transFrom);
						purge();
						Facade.stage.addChild(this);
						if (transFrom is BaseUI){
							transFrom.closeWindow();
						}
						waiting=1;
					}else if (waiting==1){
						if (!GameData.BUSY){
							waiting=2;
						}
					}else{
						Facade.currentUI=transTo;
						Facade.stage.addChild(transTo);
						Facade.stage.addChild(this);
						fadeUp=false;
						
						if (transTo is BaseUI){
							transTo.openWindow();
						}
					}
				}
			}else{
				alpha-=.1
				if (alpha<=0){
					parent.removeChild(this);
					removeEventListener(Event.ENTER_FRAME,onTick);
				}
			}
		}
		
		function purge(){
			while (Facade.stage.numChildren>0){
				Facade.stage.removeChildAt(0);
			}
		}
	}
}