package items {
	import flash.display.Bitmap;
	
	public class StatusInventoryUI extends BaseInventoryUI{
		//UI for use in the LOAD, NEW CHAR or DUEL screen; displays Equipment only and can't drag.

		public function StatusInventoryUI() {
			x=15.5;
			y=267.5;
			
			locked=true;
			IWIDTH=35;
			IHEIGHT=31;
			itemA=new Array(5);
			for (var i:int=0;i<5;i+=1){
				itemA[i]=makeBox(i,i*41,0);
			}
		}
		
		override public function update(_o:SpriteModel=null){
			clear();
			
			origin=_o;
			if (_o==null) return;
			
			
			for (var i:int=0;i<3;i+=1){
				if (i<origin.stats.slots){
					itemA[i+2].cover=false;
				}else{
					itemA[i+2].cover=true;
				}
			}
			for (i=0;i<5;i+=1){
				if (origin.equipment[i]!=null){
					if (origin.equipment[i].name!=ItemData.UNARMED){
						itemA[i].addItem(new ItemView(origin.equipment[i]));
						itemA[i].stored.sepia();
					}
				}
			}
		}
		
		override public function addItemAt(_item:ItemView,i:int):Boolean{
			//return true if successful
			if ((_item==null)||(i==-1)){
				return true;
			}
			
			itemA[i].addItem(_item);
			_item.sepia();
			return true;
		}
		
		override public function removeItem(_item:ItemView):Boolean{
			itemA[_item.index].removeItem();
			return true;
		}
		
		override public function removeItemAt(i:int):ItemView{
			return itemA[i].removeItem();
		}
	}
}
