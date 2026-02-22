package ui.effects{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class ConstantEffect extends MovieClip{
		public static const HASTE:int=1,
							CELERITY:int=2,
							TURTLE:int=3,
							POWER:int=4,
							PURITY:int=5,
							HEALING:int=6;
		
		public var displays:Array=new Array(5);
		
		/*public function ConstantEffect (origin:*,i:int){
			if (i==-1) return;
			x=origin.view.x-41;
			y=origin.view.y-100;
			gotoAndStop(i);
			Facade.gameUI.gameV.addChild(this);
		}*/
		
		public function addEffect(i:int){
			displays[i]=new ConstantSubEffect;
			displays[i].gotoAndStop(i);
			addChild(displays[i]);
		}
		
		public function removeEffect(i:int){
			if (displays[i]!=null){
				removeChild(displays[i]);
				displays[i]=null;
			}
		}
		
		public function removeAll(){
			for (var i:int=0;i<displays.length;i+=1){
				removeEffect(i);
			}
		}
		
		public function reposition(_x:Number,_y:Number,_scale:Number){
			x=_x+20*_scale;
			y=_y+10;
			scaleX=_scale;
			scaleY=Math.abs(_scale);
		}
	}
}