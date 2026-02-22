package ui.assets {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class PullButton extends MovieClip{
		public static const RIGHT:int=0;
		public static const DOWN:int=1;
		public static const LEFT:int=2;
		public static const UP:int=3;
		public static const SLIDE:Number=10;
		
		var direction:int;
		var min:Number;
		var max:Number;
		
		var running:int=0;
		
		public function init(_dir:int,_min:Number,_max:Number){
			buttonMode=true;
			direction=_dir;
			min=_min;
			max=_max;
			goMin();
			addEventListener(Event.ENTER_FRAME,tick);
		}
		
		public function moveTo(_x:Number,_y:Number){
			switch (direction){
				case RIGHT: case LEFT:
					if (testMin(_x,_y)) goMin();
					else if (testMax(_x,_y)) goMax();
					else parent.x=_x-x;
					break;
				case UP: case DOWN:
					if (testMin(_x,_y)) goMin();
					else if (testMax(_x,_y)) goMax();
					else parent.y=_y-y;
					break;
			}
		}
		
		function testMin(_x:Number,_y:Number):Boolean{
			switch (direction){
				case RIGHT: return (Math.round(_x)<=Math.round(min));
				case LEFT: return (Math.round(_x)>=Math.round(min));
				case DOWN: return (Math.round(_y)<=Math.round(min));
				case UP: return (Math.round(_y)>=Math.round(min));
				default:return false;
			}
		}
		
		function testMax(_x:Number,_y:Number):Boolean{
			switch (direction){
				case RIGHT: return (Math.round(_x)>=Math.round(max));
				case LEFT: return (Math.round(_x)<=Math.round(max));
				case DOWN: return (Math.round(_y)>=Math.round(max));
				case UP: return (Math.round(_y)<=Math.round(max));
				default: return false;
			}
		}
		
		public function tick(e:Event){
			if (running==1){
				switch (direction){
					case RIGHT:
						if (testMax(parent.x+x,parent.y+y)) goMax();
						else parent.x+=SLIDE;
						break;
					case LEFT:
						if (testMax(parent.x+x,parent.y+y)) goMax();
						else parent.x-=SLIDE;
						break;
					case DOWN:
						if (testMax(parent.x+x,parent.y+y)) goMax();
						else parent.y+=SLIDE;
						break;
					case UP:
						if (testMax(parent.x+x,parent.y+y)) goMax();
						else parent.y-=SLIDE;
						break;
				}
			}
			if (running==-1){
				switch (direction){
					case RIGHT:
						if (testMin(parent.x+x,parent.y+y)) goMin();
						else parent.x-=SLIDE;
						break;
					case LEFT:
						if (testMin(parent.x+x,parent.y+y)) goMin();
						else parent.x+=SLIDE;
						break;
					case DOWN:
						if (testMin(parent.x+x,parent.y+y)) goMin();
						else parent.y-=SLIDE;
						break;
					case UP:
						if (testMin(parent.x+x,parent.y+y)) goMin();
						else parent.y+=SLIDE;
						break;
				}
			}
		}
		
		public function goMin(){
			switch(direction){
				case LEFT: case RIGHT: parent.x=min-x; break;
				case UP: case DOWN: parent.y=min-y; break;
			}
			running=0;
		}
		
		public function goMax(){
			switch(direction){
				case LEFT: case RIGHT: parent.x=max-x; break;
				case UP: case DOWN: parent.y=max-y; break;
			}
			running=0;
		}
		
		public function resetRun(){
			running=0;
		}
		
		public function slideTo(i:int){
			running=i;
		}
		
		public function dropped(){
			if (!testMin(parent.x+x,parent.y+y)&&!testMax(parent.x+x,parent.y+y)){
				//slideTo(-1);
			}//dropped at location; stop there? slowly move back?
		}
		
		public function onClick(){
			if (!running){
				if (testMin(parent.x+x,parent.y+y)){
					slideTo(1);
				}else{
					slideTo(-1);
				}
			}
		}
	}
	
}
