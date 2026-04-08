package items {
	import ui.windows.ConfirmWindow;
	import flash.text.TextField;
	import utils.GameData;
	import utils.AchieveData;
	
	public class ForgeIngredientsUI extends BaseInventoryUI{
		//single box, for STACK or UPGRADE
		var drop:BaseInventoryUI;
		var valueGold:int;
		var result:ItemModel;
		var fakeItem:ItemView;
		var previewAmount:int=0;
		
		public function ForgeIngredientsUI(){
			
		}
		
		public function isFull():Boolean{
			if (itemA[0].hasItem() && itemA[1].hasItem()) return true;
			return false;
		}
		
		public function init (_drop:BaseInventoryUI){
			drop=_drop;
			removeUI.drop=_drop;
			itemA=[makeBox(0,-1,-1),makeBox(1,54,-1)];
			itemA[0].checkIndex=ItemBox.FORGE;
			itemA[1].checkIndex=ItemBox.FORGE;
			
			goldT.text="---";
			forgeB.update("Forge!",confirmBuy);
			forgeB.disabled=true;

			previewB.setDesc("Craftable", "This combination has a recipe! What will you get..?");
			blankB.setDesc("No Recipe", "This combination does not have a recipe. Try something else!");
			
			removeChild(previewB);
			removeChild(blankB);
		}
		
		override public function addItem(_item:ItemView):Boolean{
			if (!itemA[0].hasItem()){
				addItemAt(_item,0);
				return true;
			}else if (!itemA[1].hasItem()){
				addItemAt(_item,1);
				return true;
			}
			return false;
		}
		
		override public function addItemAt(_item:ItemView,i:int):Boolean{
			//return true if successful
			if ((_item==null)||(i==-1)){
				return true;
			}
			
			itemA[i].addItem(_item);
			
			if (itemA[0].hasItem() && itemA[1].hasItem()){
				result=ItemCraftingData.getCraftingResult(itemA[0].stored.model,itemA[1].stored.model);
				if (result==null) result=ItemCraftingData.getCraftingResult(itemA[1].stored.model,itemA[0].stored.model);
				if (result!=null){
					forgeB.disabled=false;
					goldT.text=String(result.cost*100)+" g";
					setPreview(itemA[0].stored.model,itemA[1].stored.model);
				} else {
					forgeB.disabled=true;
					goldT.text="---";
					addChild(blankB);
				}
			}
			
			return true;
		}
		
		public function setPreview(_item0:ItemModel,_item1:ItemModel){
			if (_item0.index==136 || _item1.index==136 || _item0.index==_item1.index){
				//straight upgrade
				makeFakeItem();
				return;
			}else if (_item0.index!=135 && _item1.index!=135){
				//special recipe
				previewAmount=3;
			}else if ((_item0.index==135 && _item0.enchantIndex==0) || (_item1.index==135 && _item1.enchantIndex==0)){
				//scouring
				makeFakeItem();
				return;
			}else if ((_item0.index==135 && _item0.enchantIndex==1) || (_item1.index==135 && _item1.enchantIndex==1)){
				//chaos
				previewAmount=50;
			}else if ((_item0.index==135 && _item0.enchantIndex==2) || (_item1.index==135 && _item1.enchantIndex==2)){
				previewAmount=10;
			}else if ((_item0.index==135 && _item0.suffixIndex==-1) || (_item1.index==135 && _item1.suffixIndex==-1)){
				//make suffix
				previewAmount=5;
			}else{
				//add suffix
				previewAmount=1;
			}
			
			addChild(previewB);
		}
		
		override public function removeItem(_item:ItemView):Boolean{
			result=null;
			forgeB.disabled=true;
			goldT.text="---";
			itemA[_item.index].removeItem();
			if (contains(previewB)) removeChild(previewB);
			if (contains(blankB)) removeChild(blankB);
			if (fakeItem!=null && contains(fakeItem)) removeChild(fakeItem);
			return true;
		}
		override public function removeItemAt(i:int):ItemView{
			result=null;
			forgeB.disabled=true;
			goldT.text="---";
			if (contains(previewB)) removeChild(previewB);
			if (contains(blankB)) removeChild(blankB);
			if (fakeItem!=null && contains(fakeItem)) removeChild(fakeItem);
			return itemA[i].removeItem();
		}
		
		public function showPreview(){
			if (GameData.kreds<previewAmount){
				new ConfirmWindow("Not enough Power Tokens.");
			}else{
				new ConfirmWindow("Preview the current crafting combination for "+previewAmount.toString()+" Power Tokens?",50,50,finishPreview);
			}
		}
		
		public function finishPreview(i:int=0){
			GameData.kreds-=previewAmount;
			GameData.saveThis(GameData.SCORES);
			makeFakeItem();
		}

		public function makeFakeItem(){
			if (contains(previewB)) removeChild(previewB);
			if (contains(blankB)) removeChild(blankB);
			if (fakeItem!=null && contains(fakeItem)) removeChild(fakeItem);
			if (result==null) return;
			fakeItem=new ItemView(result);
			fakeItem.makeGrey();
			fakeItem.x=removeUI.x;
			fakeItem.y=removeUI.y;
			addChild(fakeItem);
		}
		
		function confirmBuy(){
			if (removeUI.itemA[0].hasItem()){
				new ConfirmWindow("Please clear the Forge Slot before attempting to forge an item.");
				return;
			}
			if (result!=null){
				if (GameData.gold>=result.cost){
					GameData.gold-=result.cost;
					drop.updateGold();
					removeUI.addItemAt(new ItemView(result),0);
					GameData.overflow.unshift(result.exportArray());
					removeItemAt(0);
					removeItemAt(1);
					Facade.saveC.saveChar();
					GameData.overflow.shift();
					AchieveData.achieve(AchieveData.CRAFT_ITEM_1);
				}else{
					new ConfirmWindow(StringData.confGold(valueGold));
				}
			}
		}
		
		public function removeValues(){
			if (drop==null) return;
			result=null;
			goldT.text="---";
			forgeB.disabled=true;
			drop.updateGold();
			if (itemA[0].hasItem()){
				var _item:ItemView=itemA[0].removeItem();
				if (!drop.addItem(_item)){
					Facade.gameM.addOverflowItem(_item.model);
				}
			}
			if (itemA[1].hasItem()){
				_item=itemA[1].removeItem();
				if (!drop.addItem(_item)){
					Facade.gameM.addOverflowItem(_item.model);
				}
			}
			removeUI.removeValues();
		}
		
		override public function sell(_item:ItemView){
			
		}
	}
}
