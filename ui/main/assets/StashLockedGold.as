package ui.main.assets {
	import flash.display.Sprite;
	import utils.KongregateAPI;
	import utils.GameData;
	import ui.windows.ConfirmWindow;
	
	public class StashLockedGold extends Sprite{
		var refresh:Function;
		var cost:Number;
		var index:int;
		
		public function StashLockedGold() {
			
		}
		
		public function init(_refresh:Function,_cost:Number,_index:int){
			refresh=_refresh;
			cost=_cost;
			index=_index;
			if (cost==10000){
				yesB.update("10,000g",startPurchase);
				//label1.text=label2.text="Unlock for 10,000g?"
			}else if (cost==5000000){
				yesB.update("5m gold",startPurchase);
				//label1.text=label2.text="Unlock for 5,000,000g?"
			}
		}
		
		public function startPurchase(){
			if (GameData.gold>cost){
				GameData.gold-=cost;
				endPurchase();
			}else{
				new ConfirmWindow(StringData.confGold(cost));
			}
		}
		
		public function endPurchase(){
			Facade.gameM.playerM.stash[index]=false;
			Facade.saveC.saveChar();
			refresh();
		}

	}
	
}
