package ui.effects{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.filters.DropShadowFilter;
	
	public class FlyingText extends Sprite{
		public static const MISS:String="Dodged!",
							BLOCK:String="Block!",
							TURN:String="Nullified!",
							LEVEL_UP:String="Level Up!",
							CRITICAL:String="!!!";
		static var count:int=0;
		static var lastPos:int=0;
		
		var display:TextField=new TextField;
		var counter:int=20;
		
		public function FlyingText (origin:*,s:String,colour:uint=0xff0000,_offsetX:Number=0,_offsetY:Number=0){
			if (s=="") return;
			count+=1;
			
			mouseChildren=false;
			display.defaultTextFormat=new TextFormat(StringData.FONT_SYSTEM,15,colour,true);
			display.htmlText=s;
			display.width=display.textWidth+5;
			display.height=display.textHeight+10;
			mouseChildren=false;
			display.filters=[new DropShadowFilter(2,45,0,1,2,2,4)];
			addChild(display);
			if (_offsetX==0){
				x=origin.view.x;
				if (lastPos==0){
					x=origin.view.x;
				}else if (lastPos==1){
					x=origin.view.x+20;
				}else if (lastPos==2){
					x=origin.view.x-20;
				}
				lastPos+=1;
				if (lastPos>2) lastPos=0;
			}else{
				x=origin.view.x+_offsetX;
				lastPos=0;
			}
			
			y=origin.view.y-origin.view.height*3/4+_offsetY;
			addEventListener(Event.ENTER_FRAME,update,false,0,true);
			Facade.gameUI.gameV.addChild(this);
		}
		
		public function update(e:Event){
			if (counter>0){
				counter-=1;
				y-=2;
			}else{
				count-=1;
				if (count==0) lastPos=0;
				removeEventListener(Event.ENTER_FRAME,update,false);
				parent.removeChild(this);
			}
		}
	}
}