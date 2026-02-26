package items {
	import ui.windows.ConfirmWindow;
	import flash.text.TextField;
	import utils.GameData;
	import utils.AchieveData;
	
	public class SingleInventoryUI extends BaseInventoryUI{
		//single box, for STACK or UPGRADE
		public static const STACK:int=0;
		public static const UPGRADE:int=1;
		var type:int;
		var drop:BaseInventoryUI;
		var valueGold:int;
		
		public function SingleInventoryUI(){
			
		}
		
		public function init (i:int,_drop:BaseInventoryUI){
			drop=_drop;
			itemA=[makeBox(0,6,4)];
			type=i;
			if (i==STACK){
				itemA[0].checkIndex=ItemBox.STACK;
			}else if (i==UPGRADE){
				itemA[0].checkIndex=ItemBox.UPGRADE;
			}
			
			yesB.update(null,confirmBuy);
		}
		
		override public function addItem(_item:ItemView):Boolean{
			return false;
		}
		
		override public function addItemAt(_item:ItemView,i:int):Boolean{
			//return true if successful
			if ((_item==null)||(i==-1)){
				return true;
			}
			if (type==UPGRADE){
				valueGold=_item.model.cost*(_item.model.level+1)*3.5;
				if (_item.model.level>15) valueGold*=1.1+(_item.model.level - 15)*0.9;
				valueD.text=String(valueGold)+" g";
			}else if (type==STACK){
				valueGold=_item.model.getRestackCost();
				valueD.text=String(valueGold)+" g";
			}else{
				throw(new Error("neither upgrade nor stack are children"));
			}
			
			itemA[i].addItem(_item);
			return true;
		}
		
		
		override public function removeItem(_item:ItemView):Boolean{
			valueGold=0;
			valueD.text="";
			itemA[_item.index].removeItem();
			return true;
		}
		override public function removeItemAt(i:int):ItemView{
			valueGold=0;
			valueD.text="";
			return itemA[i].removeItem();
		}
		
		function confirmBuy(){
			if (itemA[0].hasItem()){
				if (GameData.gold>=valueGold){
					GameData.gold-=valueGold;
					drop.updateGold();
					if (type==UPGRADE){
						AchieveData.achieve(AchieveData.UPGRADE_ITEM_1);
						itemA[0].stored.model.level+=1;
						addItemAt(new ItemView(itemA[0].removeItem().model.clone()),0);
						if (!itemA[0].check(itemA[0].stored)){
							removeValues();
						}
					}else if (type==STACK){
						itemA[0].stored.model.charges=itemA[0].stored.model.maxCharges();
						removeValues();
					}else{
						throw(new Error("Can't locate the right shop"));
					}
				}else{
					new ConfirmWindow(StringData.confGold(valueGold));
					return;
				}
			}
		}
		
		public function removeValues(){
			if (drop==null) return;
			valueD.text="";
			valueGold=0;
			drop.updateGold();
			if (itemA[0].hasItem()){
				var _item:ItemView=itemA[0].removeItem();
				if (!drop.addItem(_item)){
					Facade.gameM.addOverflowItem(_item.model);
				}
			}
		}
		
		override public function sell(_item:ItemView){
			
		}
	}
}
