package artifacts {
	import ui.windows.ConfirmWindow;
	
	public class GambleArtifactUI extends ArtifactInventoryBase{
		
		public function GambleArtifactUI(){
			itemA=new Array(3);
			for (var i:int=0;i<3;i+=1){
				itemA[i]=makeBox(i,i*42.5,-1,ArtifactBox.GAMBLE);
			}
		}
		
		public function init(_drop:ArtifactInventoryBase){
			drop=_drop;
			
		}
		
		override public function addItem(_item:ArtifactView):Boolean{
			return false;
		}
		
		override public function dropItem(_item:ArtifactView,i:int){
			_item.location.returnItem(_item);
		}
		
		override public function check(_item:ArtifactView,i:int):Boolean{
			return false;
		}

		override public function removeItem(_item:ArtifactView):Boolean{
			if (Facade.gameM.souls>=_item.model.cost){
				Facade.gameM.souls-=_item.model.cost;
				drop.updateGold();
				(drop as StashArtifactUI).unlockSlot(_item.model.index);
				
				itemA[_item.index].removeItem();
				return true;
			}else{
				new ConfirmWindow(StringData.confSoul(_item.model.cost),100,100,null,0,null,2);
				return false;
			}
		}
		
		override public function sell(_item:ArtifactView){
			
		}

	}
}
