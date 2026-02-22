package artifacts{
	import utils.GameData;
	
	public class SepiaArtifactUI extends ArtifactInventoryBase{
		
		public function SepiaArtifactUI(){
			x=16;
			y=73;
			locked=true;
			itemA=new Array(5);
			itemA[0]=makeBox(0,0,15);
			itemA[1]=makeBox(1,42,4);
			itemA[2]=makeBox(2,84,0);
			itemA[3]=makeBox(3,126,4);
			itemA[4]=makeBox(4,168,15);
		}
		
		override public function update(_o:SpriteModel=null,_arts:Array=null){
			clear();
			
			origin=_o;
			if (_o==null) return;
			
			for (var i:int=0;i<5;i+=1){
				if (origin.arts[i]!=null && origin.arts[i] is ArtifactModel){
					itemA[i].addItem(new ArtifactView(origin.arts[i]));
					itemA[i].stored.sepia();
					itemA[i].stored.shortDesc=true;
				}
			}
		}
		
		override public function addItemAt(_item:ArtifactView,i:int):Boolean{
			//return true if successful
			if ((_item==null)||(i==-1)){
				return true;
			}
			
			itemA[i].addItem(_item);
			_item.sepia();
			_item.shortDesc=true;
			return true;
		}
		
		override public function removeItem(_item:ArtifactView):Boolean{
			itemA[_item.index].removeItem();
			return true;
		}
		
		override public function removeItemAt(i:int):ArtifactView{
			return itemA[i].removeItem();
		}
	}
}
