package ui.assets{
	import flash.display.Sprite;
	import flash.events.Event;
	import utils.GameData;
	
	public class AchievementDisplay extends Sprite{
		public static var numAchievements:int=0;
		var counter:int=0;
		var removing:Boolean=false;
		
		public function AchievementDisplay (i:int){
			
			Facade.soundC.playEffect(SoundControl.ACHIEVE);
			if (i>=100){
				if (i==313) display.text="All Awards \nUnlocked";
				else if (i==315){
					display.text="You found 500 gold!";
					//y=280;
				}else if (i==316){
					display.text="Artifacts:\n Level Increased!";
				}else if (i==317){
					display.text="Artifacts:\n New Slot Unlocked!";
				}else{
					switch(i){
						case 101: display.text="Building Unlock:\nHall of Heroes"; break;
						case 102: display.text="Building Unlock:\nDueling Arena"; break;
						case 103: display.text="Building Unlock:\nLibrary"; break;
						case 104: display.text="Building Unlock:\nBlack Market"; break;
						case 105: display.text="Building Unlock:\nShop"; break;
					}
				}
			}else{
				if (i==GameData.ACHIEVE_ACOLYTE || i==GameData.ACHIEVE_PALADIN){
					display.text="Class Unlock:\n "+StringData.achieveName(i);
				}else if (i>=GameData.ACHIEVE_ORDINARY_COSMO && i<=GameData.ACHIEVE_NOBLE_COSMO){
					display.text="Cosmetics:\n "+StringData.achieveName(i);
				}else if (i==GameData.ACHIEVE_ASCEND_50){
					display.text="Cosmetics:\n 50 Ascends Reward.";
				}else if (i==GameData.ACHIEVE_ROGUE){
					display.text="Class Unlock:\n "+StringData.achieveName(i);
				}else if (i==GameData.ACHIEVE_BERSERKER){
					display.text="Class Unlock:\n "+StringData.achieveName(i);
				}else if (i==GameData.ACHIEVE_FORGE){
					display.text="Building Unlock:\nMystic Forge";
				}else if (i==GameData.ACHIEVE_EPIC){
					display.text="Area Unlock:\nEpic Zone";
				}else if (i==GameData.ACHIEVE_LEVEL_70){
					display.text="Advancement:\nLevel 70";
				}else{
					display.text="Talent Unlock: \n"+StringData.achieveName(i);
				}
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