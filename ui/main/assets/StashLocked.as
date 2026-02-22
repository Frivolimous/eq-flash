package ui.main.assets {
	import flash.display.Sprite;
	import utils.KongregateAPI;
	
	public class StashLocked extends Sprite{
		var refresh:Function;

		public function StashLocked() {
			yesB.update("20 Tokens",startPurchase);
		}
		
		public function init(_refresh:Function){
			refresh=_refresh;
		}
		
		public function startPurchase(){
			if (refresh!=null){
				KongregateAPI.buyItem(endPurchase,20,refresh)
			}
		}
		
		public function endPurchase(){
			for (var i:int=0;i<Facade.gameM.stash.length;i+=1){
				if (Facade.gameM.stash[i][1]){
					Facade.gameM.stash[i][1]=false;
					refresh();
					return;
				}
			}
		}

	}
	
}
