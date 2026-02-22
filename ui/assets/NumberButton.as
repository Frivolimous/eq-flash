package ui.assets{
	import flash.display.Sprite;
	//import ui.assets.BlankButton;
	
	public class NumberButton extends Sprite{
		//var num:BitText=new BitText();
		var up:Sprite=new Sprite;
		var down:Sprite=new Sprite;
		public var index:int=3;
		
		public function NumberButton(){
			/*num.numberFont();
			num.size(30);
			num.color=Facade.SEPIA;
			num.text="3";
			num.x=2;*/
			graphics.lineStyle(2,Facade.SEPIA);
			graphics.beginFill(0,0.1);
			graphics.drawRect(0,0,20,34);
			graphics.endFill();
			graphics.moveTo(3,5);
			graphics.lineTo(10,3);
			graphics.lineTo(17,5);
			graphics.moveTo(3,29);
			graphics.lineTo(10,31);
			graphics.lineTo(17,29);
			//addChild(num);
			/*var _button:BlankButton=new BlankButton(0,0,20,34,scrollDown);
			addChild(_button);
			_button=new BlankButton(0,0,20,17,scrollUp);
			addChild(_button);*/
		}
		
		public function scrollUp(){
			index+=1;
			if (index>9) index=9;
			//num.text=String(index);
		}
		
		public function scrollDown(){
			index-=1;
			if (index<1) index=1;
			//num.text=String(index);
		}
			
	}
}