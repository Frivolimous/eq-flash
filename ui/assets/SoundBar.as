package ui.assets {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import utils.GameData;
	
	public class SoundBar extends MovieClip{
		static var EXISTS:Boolean=false;
		var origin:DisplayObject;
		
		public function SoundBar(_x:int,_y:int,_source:DisplayObject){
			if (!EXISTS){
				EXISTS=true;
				x=_x;
				y=_y;
				origin=_source;
				effectsB.init(effectVolume,Facade.soundC.soundVolume/0.4);
				musicB.init(musicVolume,Facade.soundC.musicVolume);
				Facade.stage.addEventListener(MouseEvent.MOUSE_MOVE,testRemove);
				Facade.stage.addChild(this);
			}
		}
		
		public function testRemove(e:MouseEvent){
			if (e.target!= this && !contains(e.target as DisplayObject) && e.target!=origin) remove();
		}
		
		public function remove(){
			effectsB.dispose();
			musicB.dispose();
			if (parent!=null){
				parent.removeChild(this);
			}
			EXISTS=false;
			Facade.stage.removeEventListener(MouseEvent.MOUSE_DOWN,testRemove);
		}
		
		public function effectVolume(p:Number){
			Facade.soundC.soundVolume=0.4*p;
			GameData._Save.data.sound[1]=0.4*p;
		}
		
		public function musicVolume(p:Number){
			Facade.soundC.musicVolume=p;
			GameData._Save.data.sound[0]=p;
		}
	}	
}
