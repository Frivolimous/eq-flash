package artifacts{
	import utils.GameData;
	
	public class PlayerArtifactUI extends ArtifactInventoryBase{
		
		public function PlayerArtifactUI(){
			itemA=new Array(5);
			itemA[0]=makeBox(0,0,14.75,ArtifactBox.EQUIP);
			itemA[1]=makeBox(1,41.05,3.75,ArtifactBox.EQUIP);
			itemA[2]=makeBox(2,84.1,0,ArtifactBox.EQUIP);
			itemA[3]=makeBox(3,126.15,3.75,ArtifactBox.EQUIP);
			itemA[4]=makeBox(4,168.25,14.75,ArtifactBox.EQUIP);
		}
		
		override public function update(_o:SpriteModel=null,_arts:Array=null){
			clear();
			
			origin=_o;
			if (_o==null) return;
			if (_arts==null) _arts=GameData.artifacts;
			
			updateGold();
			for (var i:int=0;i<itemA.length;i+=1){
				if (origin.arts[i]==false || origin.arts[i]==true){
					if (i==2){
						origin.arts[i]=null;
					}else{
						var _cost:int;
						switch(i){
							case 0: _cost=5000; break;
							case 1: _cost=50; break;
							case 2: _cost=5; break;
							case 3: _cost=500; break;
							case 4: _cost=50000; break;
						}
						itemA[i].setUnlockCost(_cost);
						itemA[i].locked=true;
						this["box"+i].gotoAndStop(2);
					}
				}else{
					this["box"+i].gotoAndStop(1);
					if (origin.arts[i]!=null){
						origin.arts[i]=ArtifactData.spawnArtifact(origin.arts[i].index,_arts[origin.arts[i].index]);
						itemA[i].addItem(new ArtifactView(origin.arts[i]));
					}
				}
			}
		}
		
		public function blankLocks(){
			for (var i:int=0;i<5;i+=1){
				if (itemA[i].locked){
					itemA[i].setUnlockCost(-1);
					itemA[i].locked=true;
				}
			}
		}
		
		override public function addItem(_item:ArtifactView):Boolean{
			for (var i:int=0;i<itemA.length;i+=1){
				if (!itemA[i].hasItem() && check(_item,i)){
					if (origin!=null){
						origin.addArtifactAt(_item.model,i);
					}
					itemA[i].addItem(_item);
					return true;
				}
			}
			return false;
		}
		
		override public function addItemAt(_item:ArtifactView,i:int):Boolean{
			//return true if successful
			if ((_item==null)||(i==-1)){
				return true;
			}
			
			if (origin!=null){
				origin.addArtifactAt(_item.model,i);
			}
			
			itemA[i].addItem(_item);
			return true;
		}
		
		override public function removeItem(_item:ArtifactView):Boolean{
			if (origin!=null){
				origin.removeArtifactAt(_item.index);
			}
			itemA[_item.index].removeItem();
			return true;
		}
		
		override public function removeItemAt(i:int):ArtifactView{
			if (origin!=null){
				origin.removeArtifactAt(i);
			}
			return itemA[i].removeItem();
		}
		
		override public function check(_item:ArtifactView,i:int):Boolean{
			return !itemA[i].locked;
		}
	}
}
