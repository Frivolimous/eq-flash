package items {
	import ui.windows.ConfirmWindow;
	import flash.text.TextField;
	import flash.display.Sprite;
	import utils.GameData;
	
	public class FillAllUI extends Sprite{
		//single box, for STACK or UPGRADE
		var valueGold:int;
		var origin:SpriteModel;
		var inventory:BaseInventoryUI;
		
		public function init (_inventory:BaseInventoryUI){
			inventory=_inventory;
			yesB.update("---",confirmBuy);
		}
		
		public function update(_origin:SpriteModel=null){
			if (_origin!=null){
				origin=_origin;
			}
			
			valueGold=0;
			if (origin!=null){
				for (var i:int=0;i<origin.belt.length;i+=1){
					if (origin.belt[i]!=null) valueGold+=origin.belt[i].getRestackCost();
				}
			}
			//valueD.text=String(valueGold)+" g";
			yesB.updateLabel(String(valueGold)+"g");
		}
		
		public function confirmBuy(noWindow:Boolean=false){
			if (origin==null) return;
			
			if (valueGold>0){
				if (GameData.gold>=valueGold){
					GameData.gold-=valueGold;
					inventory.updateGold();
					for (var i:int=0;i<origin.belt.length;i+=1){
						var _item:ItemModel=origin.belt[i];
						if (_item!=null && _item.slot==ItemData.USEABLE && _item.charges>=0 && _item.charges<_item.maxCharges()){
							_item.charges=_item.maxCharges();
						}
					}
					removeValues();
				}else{
					if (!noWindow) new ConfirmWindow(StringData.confGold(valueGold));
				}
			}
		}
		
		public function removeValues(){
			yesB.updateLabel("---");
			valueGold=0;
			inventory.updateGold();
		}
	}
}
