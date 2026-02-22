package ui.assets {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import utils.GameData;
	
	public class QualityBar extends MovieClip{
		static var EXISTS:Boolean=false;
		var origin:DisplayObject;
		var buttons:Array=new Array(7);
		
		public function QualityBar(_x:int,_y:int,_source:DisplayObject){
			/*
			lowB
			medB
			highB
			cursorB
			cinematicB
			*/
			
			if (!EXISTS){
				EXISTS=true;
				x=_x;
				y=_y;
				origin=_source;
				Facade.stage.addEventListener(MouseEvent.MOUSE_MOVE,testRemove);
				Facade.stage.addChild(this);
				lowB.update(null,setQuality,true);
				lowB.index=0;
				medB.update(null,setQuality,true);
				medB.index=1;
				highB.update(null,setQuality,true);
				highB.index=2;
				cursorB.update(null,toggleCursor,true);
				cinematicB.update(null,toggleCinematic,true);
				simpleB.update(null,toggleSimple,true);
				cinematicfB.update(null,toggleCinematicFocus,true);
				simplefB.update(null,toggleSimpleFocus,true);
				
				switch(Facade.stage.quality){
					case "LOW":
						lowB.toggled=true;
						medB.toggled=false;
						highB.toggled=false;
						break;
					case "MEDIUM":
						lowB.toggled=false;
						medB.toggled=true;
						highB.toggled=false;
						break;
					default:
						lowB.toggled=false;
						medB.toggled=false;
						highB.toggled=true;
						break;
				}
				
				cursorB.toggled=GameData._Save.data.pause[GameData.CURSOR];
				cinematicB.toggled=Facade.gameUI.cinematicMode;
				simpleB.toggled=Facade.gameUI.simpleMode;
				simplefB.toggled=GameData._Save.data.pause[GameData.FOCUS_SIMPLE];
				cinematicfB.toggled=GameData._Save.data.pause[GameData.FOCUS_CINEMATIC];
			}
		}
		
		function setQuality(i:int){
			Facade.setQuality(i);
			switch(i){
				case 0:
					lowB.toggled=true;
					medB.toggled=false;
					highB.toggled=false;
					break;
				case 1:
					lowB.toggled=false;
					medB.toggled=true;
					highB.toggled=false;
					break;
				case 2:
					lowB.toggled=false;
					medB.toggled=false;
					highB.toggled=true;
					break;
			}
		}
		
		function toggleCursor(){
			GameData._Save.data.pause[GameData.CURSOR]=!GameData._Save.data.pause[GameData.CURSOR]
			cursorB.toggled=(GameData._Save.data.pause[GameData.CURSOR]);
			Facade.mouseC.setMouseMode(GameData._Save.data.pause[GameData.CURSOR]);
		}
		
		function toggleCinematic(){
			Facade.gameUI.toggleCinematic();
			cinematicB.toggled=Facade.gameUI.cinematicMode;
		}
		
		function toggleSimple(){
			Facade.gameUI.toggleSimple();
			simpleB.toggled=Facade.gameUI.simpleMode;
		}
		
		function toggleCinematicFocus(){
			GameData._Save.data.pause[GameData.FOCUS_CINEMATIC]=!GameData._Save.data.pause[GameData.FOCUS_CINEMATIC];
			cinematicfB.toggled=GameData._Save.data.pause[GameData.FOCUS_CINEMATIC];
		}
		
		function toggleSimpleFocus(){
			GameData._Save.data.pause[GameData.FOCUS_SIMPLE]=!GameData._Save.data.pause[GameData.FOCUS_SIMPLE];
			simplefB.toggled=GameData._Save.data.pause[GameData.FOCUS_SIMPLE];
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
		
		function toggleButton(i:int){
			GameData._Save.data.pause[i]=!GameData._Save.data.pause[i];
			buttons[i].toggled=GameData._Save.data.pause[i];
		}
		
	}	
}
