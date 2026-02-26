package items {
	import ui.windows.ConfirmWindow;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import utils.GameData;
	import utils.AchieveData;
	
	public class ShopInventoryUI extends BaseInventoryUI{

		public function ShopInventoryUI(){
			IWIDTH=32.5;
			IHEIGHT=34;
			
			for (var i:int=0;i<20;i+=1){
				itemA[i]=makeBox(i,30.45+(i%5)*41.5,97.8+Math.floor(i/5)*36.5);
			}
		}
		
		override public function addItem(_item:ItemView):Boolean{
			return false;
		}
		
		override public function check(_item:ItemView,i:int):Boolean{
			return false;
		}
		
		override public function removeItem(_item:ItemView):Boolean{
			if (GameData.gold>=_item.model.cost){
				Facade.soundC.playEffect(SoundControl.GOLD);
				GameData.gold-=_item.model.cost;
				itemA[_item.index].removeItem();
				_item.model.cost/=4;
				_item.tooltipDesc=null;
				AchieveData.achieve(AchieveData.BUY_ITEM);
				return true;
			}else{
				new ConfirmWindow(StringData.confGold(_item.model.cost));
				return false;
			}
		}
		
		override public function dropItem(_item:ItemView,i:int){
			if (_item.location==this){
				returnItem(_item);
			}else{
				_item.location.sell(_item);
			}
		}
	}
}
