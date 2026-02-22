package ui.assets {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import utils.GameData;
	
	public class PauseBar extends MovieClip{
		static var EXISTS:Boolean=false;
		var origin:DisplayObject;
		var buttons:Array=new Array(7);
		public function PauseBar(_x:int,_y:int,_source:DisplayObject){
			/*
			skip25b
			skip50b
			skip100b
			itemsb
			healthb
			bossb
			bossallb
			*/
			
			if (!EXISTS){
				EXISTS=true;
				x=_x;
				y=_y;
				origin=_source;
				Facade.stage.addEventListener(MouseEvent.MOUSE_MOVE,testRemove);
				Facade.stage.addChild(this);
				setupButton(skipb,GameData.PAUSE_SKIP);
				setupButton(skipTimerb,GameData.PAUSE_SKIP_TIMER);
				setupButton(itemsb,GameData.PAUSE_ITEMS);
				setupButton(healthb,GameData.PAUSE_HEALTH);
				setupButton(bossb,GameData.PAUSE_BOSS);
				setupButton(bossallb,GameData.PAUSE_BOSS_ALL);
				setupButton(turnb,GameData.PAUSE_TURN);
				setupButton(levelb,GameData.PAUSE_LEVEL);
			}
		}
		
		public function testRemove(e:MouseEvent){
			if (e.target!= this && !contains(e.target as DisplayObject) && e.target!=origin) remove();
		}
		
		public function remove(){
			if (parent!=null){
				parent.removeChild(this);
			}
			EXISTS=false;
			Facade.stage.removeEventListener(MouseEvent.MOUSE_DOWN,testRemove);
		}
		
		public function setupButton(_button:GraphicButton,i:int){
			buttons[i]=_button;
			_button.update(null,toggleButton,true);
			_button.index=i;
			_button.toggled=GameData._Save.data.pause[i];
		}
		
		function toggleButton(i:int){
			GameData._Save.data.pause[i]=!GameData._Save.data.pause[i];
			buttons[i].toggled=GameData._Save.data.pause[i];
		}
		
		/*public function effectVolume(p:Number){
			Facade.soundC.soundVolume=0.4*p;
		}
		
		public function musicVolume(p:Number){
			Facade.soundC.musicVolume=p;
		}*/
	}	
}
