package ui.assets{
	import flash.display.Sprite;
	
	public class DisplayBar extends Sprite{
		static const HEIGHT:int=6;
		var colour:uint;
		var back:uint=0x442200;
		var tWidth:int;
		//var display:BitText;
		var nums:Boolean;
		var tooltipName:String;
		
		public function DisplayBar(s:String,c:uint,w:int=60,_nums:Boolean=false){
			tooltipName=s;
			tWidth=w;
			mouseChildren=false;
			name=MouseControl.DISPLAY_BAR;
			
			colour=c;
			var _red:uint=colour/0x10000;
			var _green:uint=(colour%0x10000)/0x100;
			var _blue:uint=colour%0x100;
			_red*=0.2;
			_green*=0.2;
			_blue*=0.2;
			back=_red*0x10000+_green*0x100+_blue;
			
			
			/*display=new BitText;
			display.color=c;
			display.x=tWidth+2;
			display.y=-4;
			if (_nums){
				addChild(display);
			}*/
			count(100,100);
		}
		
		public function count(c:Number,m:Number){
			if (c<0) c=0;
			if (c>m) c=m;
			graphics.clear();
			graphics.beginFill(back);
			graphics.drawRect(0,0,tWidth,HEIGHT);
			graphics.beginFill(colour);
			if (m>0){
				graphics.drawRect(0,0,tWidth*c/m,HEIGHT);
				//display.text=(c+"/"+m);
			}
			
		}
		
		public function getTooltipName():String{
			return (tooltipName);//+" "+display.text);
		}
		
		public function getTooltipDesc():String{
			return "";
		}
	}
}