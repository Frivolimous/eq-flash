package ui.main{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import items.StashInventoryUI;
	import ui.assets.GraphicButton;
	import flash.text.TextFieldType;
	import items.BaseInventoryUI;
	
	public class StashTab extends Sprite{
		/*
			personalB
			share1B
			stashName
			lockOver
		*/
		
		//Facade.gameM.stash[0-3] = [Name,Unlocked,[20 item datas]];
		var inventory:StashInventoryUI=new StashInventoryUI();
		var locked:Boolean=false;
		var origin:SpriteModel;
		var shares:Array;
		var cStash:Array;
		var tTName:String="Stash Tabs:";
		var tTDesc:String="P: Personal\n1 to 8: Shared\nO: Overflow\n *When inventory is full, special items go into OVERFLOW.";
		public var noSave:Boolean=false;
		
		public function StashTab(){
			addChild(inventory);
			updateButton(personalB,"P",100);
			updateButton(share1B,"1",0);
			updateButton(share2B,"2",1);
			updateButton(share3B,"3",2);
			updateButton(share4B,"4",3);
			updateButton(share5B,"5",4);
			updateButton(share6B,"6",5);
			updateButton(share7B,"7",6);
			updateButton(share8B,"8",7);
			updateButton(overB,"O",101);
			
			shares=[share1B,share2B,share3B,share4B,share5B,share6B,share7B,share8B];
			stashName.restrict="^,[]";
			removeChild(lockOver);
			lockOver.init(updatePurchase);
			lockHalf1.init(updatePersonal,10000,0);
			lockHalf2.init(updatePersonal,5000000,1);
			removeChild(lockHalf1);
			removeChild(lockHalf2);
			powerT.updateDisplay();
		}
		
		public function updateButton(_button:*,_name:String,i:int){
			_button.autosize=false;
			_button.update(_name,toggleStash,true);
			_button.index=i;
			_button.setDesc(tTName,tTDesc);
			
		}
		
		public function update(_origin:SpriteModel=null,_inventory:BaseInventoryUI=null){
			origin=_origin;
			inventory.update(_origin);
			if (_inventory!=null) inventory.alsoUpdate=_inventory.updateGold;
			toggleStash(0);
		}
		
		public function lockInventory(b:Boolean){
			inventory.locked=b;
			powerT.updateDisplay();
		}
		
		public function toggleStash(i:int){
			if (cStash!=null){
				cStash[0]=stashName.text;
			}
			if (origin==null) return;
			if (contains(lockHalf1)) removeChild(lockHalf1);
			if (contains(lockHalf2)) removeChild(lockHalf2);
			if (i<100){
				stashName.type=TextFieldType.INPUT;
				stashName.selectable=true;
				cStash=Facade.gameM.stash[i];
				
				stashName.text=Facade.gameM.stash[i][0];
				// locked=Facade.gameM.stash[i][1];
				locked = false;
				inventory.locked=locked;
				inventory.cantAdd=false;
				if (locked && !noSave){
					addChild(lockOver);
					stashBG1.alpha=0.5;
					stashBG2.alpha=0.5;
				}else{
					stashBG1.alpha=1;
					stashBG2.alpha=1;
					if (contains(lockOver)){
						removeChild(lockOver);
					}
				}
				
				inventory.updateStash(Facade.gameM.stash[i][2],!noSave);
				for (var j:int=0;j<shares.length;j+=1){
					if (i==j){
						shares[j].toggled=true;
					}else{
						shares[j].toggled=false;
					}
					personalB.toggled=false;
					overB.toggled=false;
				}
			}else if (i==100){ // Personal Tab
				stashName.type=TextFieldType.DYNAMIC;
				stashName.selectable=false;
				cStash=null;
				stashName.text=origin.label;
				if (stashName.text.charAt(stashName.text.length-1).toUpperCase()==("S")){
					stashName.appendText("' Stash");
				}else{
					stashName.appendText("'s Stash");
				}
				locked=false;
				inventory.locked=locked;
				inventory.cantAdd=false;
				if (contains(lockOver)){
					removeChild(lockOver);
				}
				if (origin.stash[0] && !noSave){
					addChild(lockHalf1);
					stashBG1.alpha=0.5;
				}else{
					stashBG1.alpha=1;
				}
				if (origin.stash[1] && !noSave) {
					addChild(lockHalf2);
					stashBG2.alpha=0.5;
				}else{
					stashBG2.alpha=1;
				}
				inventory.updateStash(origin.stash[2],!noSave);
				personalB.toggled=true;
				overB.toggled=false;
				for (j=0;j<shares.length;j+=1){
					shares[j].toggled=false;
				}
			}else if (i==101){ // Overflow Tab
				stashBG1.alpha=1;
				stashBG2.alpha=1;
				stashName.type=TextFieldType.DYNAMIC;
				stashName.selectable=false;
				cStash=null;
				stashName.text="Overflow";
				locked=false;
				inventory.locked=false;
				inventory.cantAdd=true;
				if (contains(lockOver)){
					removeChild(lockOver);
				}
				Facade.gameM.condenseOverflow();
				inventory.updateStash(Facade.gameM.overflow,!noSave);
				personalB.toggled=false;
				overB.toggled=true;
				for (j=0;j<shares.length;j+=1){
					shares[j].toggled=false;
				}
			}
		}
		
		public function updatePurchase(){
			for (var i:int=Facade.gameM.stash.length-1;i>=0;i-=1){
				if (!Facade.gameM.stash[i][1]){
					toggleStash(i);
					powerT.updateDisplay();
					return;
				}
			}
			powerT.updateDisplay();
		}
		
		public function updatePersonal(){
			toggleStash(100);
		}
	}
}