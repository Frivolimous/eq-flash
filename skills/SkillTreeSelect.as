package skills{
	import flash.display.Sprite;
	import ui.windows.ConfirmWindow;
	import utils.AchieveData;

	public class SkillTreeSelect extends Sprite{
		const MAX_TOGGLED:int=5;
		
		var buttons:Array;
		var numToggled:int;
		var origin:SpriteModel;
		var onClose:Function;
		
		public function SkillTreeSelect(_origin:SpriteModel=null,_onClose:Function=null){
			if (_origin!=null){
				setup(_origin,_onClose);
			}
		}
		
		public function setup(_origin:SpriteModel,_onClose:Function){
			origin=_origin;
			onClose=_onClose;
			
			buttons=[skill1B,skill2B,skill3B,skill4B,skill5B,skill6B,skill7B,skill8B,skill9B];
			
			for (var i:int=0;i<buttons.length;i+=1){
				buttons[i].update(StringData.PTITLES[i*3+1],toggleTree,true);
				buttons[i].index=i;
			}
			if (origin.skillBlock.checkTalent(SkillData.UNGIFTED)){
				buttons[SkillData.WIZARD].disabled=true;
			}
			if (!AchieveData.hasAchieved(AchieveData.ZONE_200)){
				buttons[5].disabled = true;
				buttons[5].setDesc(StringData.PTITLES[5*3+1]+" <font color="+StringData.RED2+">LOCKED</font>","Reach Zone 200 to unlock.");
			}
			if (!AchieveData.hasAchieved(AchieveData.CRAFT_ITEM_1)){
				buttons[6].disabled = true;
				buttons[6].setDesc(StringData.PTITLES[6*3+1]+" <font color="+StringData.RED2+">LOCKED</font>","Craft any item in the Mystic Forge to unlock.");
			}
			
			if (!AchieveData.hasAchieved(AchieveData.DUEL_100)){
				buttons[7].disabled = true;
				buttons[7].setDesc(StringData.PTITLES[7*3+1]+" <font color="+StringData.RED2+">LOCKED</font>","Defeat arena level 100 to unlock.");
			}

			// if (!AchieveData.hasAchieved(AchieveData.DUEL_250)){
			// 	buttons[8].disabled = true;
			// 	buttons[8].setDesc(StringData.PTITLES[8*3+1]+" <font color="+StringData.RED2+">LOCKED</font>","Defeat arena level 250 to unlock.");
			// }
				buttons[8].disabled = true;
				buttons[8].setDesc(StringData.PTITLES[8*3+1]+" <font color="+StringData.RED2+">LOCKED</font>","This skill tree is unreleased. Maybe it will be, maybe not?");
			
			for (i=0;i<_origin.skillBlock.skillT.length;i+=1){
				if (buttons[i].disabled){
					if (i==2){
						buttons[i].setDesc(StringData.PTITLES[i*3+1]+" <font color="+StringData.RED2+">DISABLED</font>","Ungifted Characters cannot learn magic.");
					}
				}else{
					buttons[i].setDesc(StringData.PTITLES[i*3+1],"Click to select or unselect this as one of your available skill trees.");
				}
				if (_origin.skillBlock.skillT[i]){
					toggleTree(i);
				}
			}
			
			doneB.update(StringData.DONE,closeWindow);
		}
		
		public function toggleTree(i:int){
			if (buttons[i].toggled){
				buttons[i].toggled=false;
				numToggled-=1;
			}else{
				if (numToggled<MAX_TOGGLED && !buttons[i].disabled){
					buttons[i].toggled=true;
					numToggled+=1;
				}
			}
			setSelectText(numToggled);
		}
		
		public function setSelectText(i:int){
			var _left:int=5-i;
			selectText.text="Select up to "+_left+" more skill tree"+(_left==1?"":"s");
		}
		
		public function closeWindow(){
			if (numToggled==0){
				new ConfirmWindow("You must select at least one skill tree.");
			}else{
				for (var i:int=0;i<buttons.length;i+=1){
					origin.skillBlock.skillT[i]=buttons[i].toggled;
				}
				parent.removeChild(this);
				onClose();
			}
		}
	}
}