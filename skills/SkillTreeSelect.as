package skills{
	import flash.display.Sprite;
	import ui.windows.ConfirmWindow;
	import utils.GameData;

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
			
			// buy6B.setDesc("Buy Acolyte Tree for 55 Kreds","Buy this premium skill tree for Power Tokens or Kreds. Also earned by reaching zone 200, or can be purchased in a bundle.");
			// buy7B.setDesc("Buy Paladin Tree for 55 Kreds","Buy this premium skill tree for Power Tokens or Kreds. Also earned by reaching zone 300, or can be purchased in a bundle.");
			// buy8B.setDesc("Buy Rogue Tree for 55 Kreds","Buy this premium skill tree for Power Tokens or Kreds. Also earned by defeating arena 800, or can be purchased in a bundle.");
			//buy9B.setDesc("Buy Berserker Tree for 55 Kreds","Buy this premium skill tree for Power Tokens or Kreds. Also earned by defeating arena 1200, or can be purchased in a bundle.");
			// buy9B.setDesc("Unavalable","This skill tree is unavailable - it will be added to the game soon!");
			// buy9B.disabled=true;
			
			for (var i:int=0;i<buttons.length;i+=1){
				buttons[i].update(StringData.PTITLES[i*3+1],toggleTree,true);
				buttons[i].index=i;
			}
			if (origin.skillBlock.checkTalent(SkillData.UNGIFTED)){
				buttons[SkillData.WIZARD].disabled=true;
			}
			if (!GameData.hasAchieved(GameData.ACHIEVE_ACOLYTE)){
				// removeChild(buttons[5]);
				buttons[5].disabled = true;
				buttons[5].setDesc(StringData.PTITLES[5*3+1]+" <font color="+StringData.RED2+">LOCKED</font>","Reach Zone 200 to unlock.");
			}
			if (!GameData.hasAchieved(GameData.ACHIEVE_PALADIN)){
				buttons[6].disabled = true;
				buttons[6].setDesc(StringData.PTITLES[6*3+1]+" <font color="+StringData.RED2+">LOCKED</font>","Reach Zone 300 to unlock.");
			}
			
			if (!GameData.hasAchieved(GameData.ACHIEVE_ROGUE)){
				buttons[7].disabled = true;
				buttons[7].setDesc(StringData.PTITLES[7*3+1]+" <font color="+StringData.RED2+">LOCKED</font>","Defeat arena 800 to unlock.");
			}
			
			if (!GameData.hasAchieved(GameData.ACHIEVE_BERSERKER)){
				buttons[8].disabled = true;
				buttons[8].setDesc(StringData.PTITLES[8*3+1]+" <font color="+StringData.RED2+">LOCKED</font>","This skill tree is unreleased. Maybe it will be, maybe not?");
			}
			
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