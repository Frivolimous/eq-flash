package items {
	import ui.windows.ConfirmWindow;
	import utils.GameData;
	import utils.AchieveData;
	
	public class GambleInventoryUI extends BaseInventoryUI{
		public function GambleInventoryUI(){
			itemA=new Array(3);
			NUM_SLOTS=3;
			for (var i:int=0;i<3;i+=1){
				itemA[i]=makeBox(i,i*41.5,-1);
			}
		}
				
		override public function addItem(_item:ItemView):Boolean{
			return false;
		}
		
		override public function dropItem(_item:ItemView,i:int){
			_item.location.returnItem(_item);
		}
		
		override public function check(_item:ItemView,i:int):Boolean{
			return false;
		}

		
		override public function removeItem(_item:ItemView):Boolean{
			if (GameData.gold>=_item.model.cost){
				GameData.gold-=_item.model.cost;
				AchieveData.achieve(AchieveData.BUY_ITEM);

				
				ItemData.finishGamble(_item);
				
				itemA[_item.index].removeItem();
				return true;
			}else{
				new ConfirmWindow(StringData.confGold(_item.model.cost));
				return false;
			}
		}
		
		override public function sell(_item:ItemView){
			
		}
	}
}
