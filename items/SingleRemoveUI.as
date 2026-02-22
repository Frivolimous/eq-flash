package items {
	import ui.windows.ConfirmWindow;
	import utils.GameData;
	
	public class SingleRemoveUI extends BaseInventoryUI{
		public var drop:BaseInventoryUI;
		
		public function SingleRemoveUI(){
			itemA=[];
			NUM_SLOTS=1;
			itemA[0]=makeBox(0,0,0);
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
			itemA[_item.index].removeItem();
			return true;
		}
		
		override public function sell(_item:ItemView){
			
		}
		
		public function removeValues(){
			if (drop==null) return;
			if (itemA[0].hasItem()){
				var _item:ItemView=itemA[0].removeItem();
				if (!drop.addItem(_item)){
					Facade.gameM.addOverflowItem(_item.model);
				}
			}
		}
	}
}
