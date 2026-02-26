package ui.assets{
	import flash.display.Sprite;
	import flash.events.Event;
	import utils.AchieveData;
	
	public class AchievementDisplay extends Sprite{
		public static var numAchievements:int=0;
		var counter:int=0;
		var removing:Boolean=false;
		
		public function AchievementDisplay (i:int){
			Facade.soundC.playEffect(SoundControl.ACHIEVE);
			switch(i) {
				case 313: display.text="All Awards \nUnlocked"; break;
				case 315: display.text="You found 500 gold!"; break;
				case 316: display.text="Artifacts:\n Level Increased!"; break;
				case 317: display.text="Artifacts:\n New Slot Unlocked!"; break;
				case 101: display.text="Building Unlock:\nHall of Heroes"; break;
				case 102: display.text="Building Unlock:\nDueling Arena"; break;
				case 103: display.text="Building Unlock:\nLibrary"; break;
				case 104: display.text="Building Unlock:\nBlack Market"; break;
				case 105: display.text="Building Unlock:\nShop"; break;
				default:
					display.text=AchieveData.ACHIEVE_DEFS[i].displayText; break;
			}
			deleteB.update(null,remove);
			//addChild(display);
			x=0-width;
			y=110+numAchievements*40;
			numAchievements+=1;
			
			addEventListener(Event.ENTER_FRAME,update,false,0,true);
			Facade.stage.addChild(this);
		}
		
		public function update(e:Event){
			if (!removing){
				if (counter<25){
					counter+=1;
					x=0-width+counter*width/25;
				}else{
					x=0;
				}
			}else{
				if (counter>0){
					counter-=1;
					x=0-width+counter*width/25;
				}else{
					numAchievements-=1;
					removeEventListener(Event.ENTER_FRAME,update,false);
					if (parent!=null) parent.removeChild(this);
				}
			}
		}
		
		public function remove(){
			if (!removing){
				removing=true;
			}
		}
	}
}