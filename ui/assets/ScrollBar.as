package ui.assets {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class ScrollBar extends MovieClip{
		var output:Function;
		var mover:MovieClip;
		var dragging:Boolean=false;
		var topY:Number=26;
		var bottomY:Number=228;
		
		public function ScrollBar(f:Function=null,p:Number=0,frame:int=1) {
			mover=ball;
			mover.buttonMode=true;
			if (f!=null) init(f,p,frame);
		}
		
		public function init(f:Function,p:Number=0,frame:int=1){
			gotoAndStop(frame);
			output=f;
			mover.addEventListener(MouseEvent.MOUSE_DOWN,startMove);
			Facade.stage.addEventListener(MouseEvent.MOUSE_UP,endMove);
			Facade.stage.addEventListener(MouseEvent.MOUSE_MOVE,moveMover);
			setPosition(p);
		}
		
		function startMove(e:MouseEvent){
			dragging=true;
		}
		
		function endMove(e:MouseEvent){
			dragging=false;
		}
		
		function moveMover(e:MouseEvent){
			if (dragging){
				var _point:Point=globalToLocal(new Point(e.stageX,e.stageY));
				if (_point.y<topY) _point.y=topY;
				if (_point.y>bottomY) _point.y=bottomY;
				mover.y=_point.y;
				output(getPosition());
			}
		}
		
		public function setPosition(p:Number){
			mover.y=bottomY+p*(topY-bottomY);
			output(getPosition());
		}
		
		function getPosition():Number{
			return (mover.y-bottomY)/(topY-bottomY);
		}
		
		public function dispose(){
			mover.removeEventListener(MouseEvent.MOUSE_DOWN,startMove);
			Facade.stage.removeEventListener(MouseEvent.MOUSE_UP,endMove);
			Facade.stage.removeEventListener(MouseEvent.MOUSE_MOVE,moveMover);
		}

	}
	
}
