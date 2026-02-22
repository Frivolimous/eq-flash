package ui.assets{
	import flash.display.Sprite;
	
	public class ScrollBoxSmooth extends Sprite{
		public var display:Sprite=new Sprite;
		public var frame:Sprite=new Sprite;
		var fieldHeight:Number;
		
		var _Objects:Array=new Array;
		public var leftMargin:Number=0;
		public var spacing:Number=0;
		
		public function ScrollBoxSmooth(_x:Number,_y:Number,tW:Number,tH:Number){
			x=_x;
			y=_y;
			fieldHeight=tH;
			var tMask:Sprite=new Sprite();
			tMask.graphics.beginFill(0xFF000000);
			tMask.graphics.drawRect(0,0,tW+1,tH+1);
			addChild(display);
			addChild(tMask);
			mask=tMask;
		}
		
		
		/*public function update(v:*=null){
			if (v!=null){
				removeChild(display);
				display=v;
				addChildAt(display,0);
				display.x=1;
			}
			bar.update(display,fieldHeight);
		}*/
		
		public function setPosition(n:Number){
			//n is % of height
			if (display.height<fieldHeight) display.y=0;
			else display.y=(fieldHeight-display.height)*(1-n);
		}
		
		public function clear(){
			/*while(_Objects.length>0){
				display.removeChild(_Objects.shift());
			}*/
			_NextY=0;
			if (display!=null && contains(display)) removeChild(display);
			display=new Sprite;
			addChildAt(display,0);
		}
		
		public function setDisplay(_display:Sprite){
			_NextY=0;
			if (display!=null && contains(display)) removeChild(display);
			display=_display;
			addChildAt(_display,0);
		}
		
		var _NextY:Number=0;
		public function addObject(_v:*){
			_v.x=leftMargin;
			_v.y=_NextY+spacing;
			_NextY=_v.y+_v.height;
			/*if (_Objects.length>0){
				_v.y=_Objects[_Objects.length-1].y+_Objects[_Objects.length-1].height+spacing;
			}
			_Objects.push(_v);*/
			display.addChild(_v);
		}
	}
}