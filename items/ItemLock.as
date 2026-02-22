package items {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import utils.GameData;
	
	public class ItemLock extends MovieClip{
		static var EXISTS:Boolean=false;
		var origin:ItemView;
		
		public function ItemLock(_x:int,_y:int,_source:ItemView){
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
				
				Facade.stage.addEventListener(MouseEvent.CLICK,toggleButton);
				
				mouseChildren=false;
				buttonMode=true;
				gotoAndStop(origin.model.sellMode);
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
		
		function toggleButton(e:Event){
			if (currentFrame==totalFrames){
				gotoAndStop(1);
			}else{
				nextFrame();
			}
			origin.model.sellMode=currentFrame-1;
		}
	}	
}
