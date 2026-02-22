package artifacts {
	import ui.windows.ConfirmWindow;
	import flash.text.TextField;
	
	public class SingleArtifactUI extends ArtifactInventoryBase{
		//single box, for UPGRADE
		var valueGold:int;
		
		public function SingleArtifactUI(){
			itemA=[makeBox(0,0,0,ArtifactBox.UPGRADE)];
			
			yesB.update("---",confirmBuy);
		}
		
		
		public function init (_drop:ArtifactInventoryBase){
			drop=_drop;
		}
		
		override public function addItem(_item:ArtifactView):Boolean{
			return false;
		}
		
		override public function addItemAt(_item:ArtifactView,i:int):Boolean{
			//return true if successful
			if ((_item==null)||(i==-1)){
				return true;
			}
			
			valueGold=_item.model.cost;
			yesB.updateLabel(String(valueGold));
			//valueD.text=String(valueGold)+" souls";
			
			itemA[i].addItem(_item);
			return true;
		}
		
		
		override public function removeItem(_item:ArtifactView):Boolean{
			valueGold=0;
			yesB.updateLabel("---");//valueD.text="";
			itemA[_item.index].removeItem();
			return true;
		}
		override public function removeItemAt(i:int):ArtifactView{
			valueGold=0;
			yesB.updateLabel("---");//valueD.text="";
			return itemA[i].removeItem();
		}
		
		function confirmBuy(){
			if (itemA[0].hasItem()){
				if (Facade.gameM.souls>=itemA[0].stored.model.cost){
					Facade.gameM.souls-=itemA[0].stored.model.cost;
					drop.updateGold();
					
					addItemAt(new ArtifactView(ArtifactData.spawnArtifact(itemA[0].stored.model.index,itemA[0].stored.model.level+1)),0);
					(drop as StashArtifactUI).unlockSlot(itemA[0].stored.model.index,itemA[0].stored.model.level);
					
					if (!check(itemA[0].stored,0)){
						removeValues();
					}
				}else{
					new ConfirmWindow(StringData.confSoul(itemA[0].stored.model.cost),100,100,null,0,null,2);
					return;
				}
			}
		}
		override public function check(_item:ArtifactView,i:int):Boolean{
			if (_item.model.level<ArtifactData.MAX_LEVEL && !locked){
				return true;
			}else{
				return false;
			}
		}
									   
		
		public function removeValues(){
			if (drop==null) return;
			
			yesB.updateLabel("---");//valueD.text="";
			valueGold=0;
			drop.updateGold();
			if (itemA[0].hasItem()){
				drop.addItem(itemA[0].removeItem());
			}
		}
	}
}
