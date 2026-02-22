package ui.assets {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import utils.GameData;
	
	public class SellBarRow extends MovieClip{
		var buttons:Array=new Array(4);
		var index:int;
		
		public function SellBarRow(){
			setupButton(slot0,0);
			setupButton(slot1,1);
			setupButton(slot2,2);
			setupButton(slot3,3);
		}
		
		public function setupButton(_button:GraphicButton,i:int){
			buttons[i]=_button;
			_button.update(null,toggleButton,true);
			_button.index=i;
			_button.toggled=GameData.options[GameData.OPTIONS_SELL+i];
		}
		
		public function update(i:int){
			index=i;
			toggleButton(GameData.options[index]);
		}
		
		function toggleButton(i:int){
			
			GameData.options[index]=i;
			
			for (var j:int=0;j<4;j+=1){
				if (j==i) buttons[j].toggled=true;
				else buttons[j].toggled=false;
			}
		}
	}	
}
