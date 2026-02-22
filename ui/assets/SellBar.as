package ui.assets {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import utils.GameData;
	
	public class SellBar extends MovieClip{
		static var EXISTS:Boolean=false;
		var origin:DisplayObject;
		var buttons:Array=new Array(7);
		public function SellBar(_x:int,_y:int,_source:DisplayObject){
			
			if (!EXISTS){
				EXISTS=true;
				x=_x;
				y=_y;
				origin=_source;
				Facade.stage.addEventListener(MouseEvent.MOUSE_MOVE,testRemove);
				Facade.stage.addChild(this);
				setupButton(gemb,GameData.SELL_GEM);
				setupButton(nonmagicb,GameData.SELL_NONMAGIC);
				setupButton(magicb,GameData.SELL_MAGIC);
				setupButton(potionb,GameData.SELL_POTION);
				setupButton(grenadeb,GameData.SELL_GRENADE);
				setupButton(spellb,GameData.SELL_SPELL);
				setupButton(scrollb,GameData.SELL_SCROLL);
				setupButton(charmb,GameData.SELL_CHARM);
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
		
		public function setupButton(_button:GraphicButton,i:int){
			buttons[i]=_button;
			_button.update(null,toggleButton,true);
			_button.index=i;
			_button.toggled=GameData._Save.data.sell[i];
		}
		
		function toggleButton(i:int){
			GameData._Save.data.sell[i]=!GameData._Save.data.sell[i];
			buttons[i].toggled=GameData._Save.data.sell[i];
		}
	}	
}
