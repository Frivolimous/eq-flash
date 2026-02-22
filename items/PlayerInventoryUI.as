package items{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import skills.SkillData;
	import ui.assets.PullButton;
	
	public class PlayerInventoryUI extends BaseInventoryUI{
						
		override public function update(_o:SpriteModel=null){
			clear();
			
			origin=_o;
			if (_o==null) return;
			updateGold();
			
			if (origin!=null){
				for (var i:int=0;i<3;i+=1){
					if (i<origin.stats.slots){
						itemA[i+2].cover=false;
					}else{
						itemA[i+2].cover=true;
					}
				}
				for (i=0;i<5;i+=1){
					if (origin.equipment[i]!=null){
						if (origin.equipment[i].name!=ItemData.UNARMED) itemA[i].addItem(new ItemView(origin.equipment[i]));
					}
					if (origin.belt[i]!=null) itemA[i+5].addItem(new ItemView(origin.belt[i]));
				}
				for (i=0;i<20;i+=1){
					if (origin.inventory[i]!=null && itemA[i+10]!=null) itemA[i+10].addItem(new ItemView(origin.inventory[i]));
				}
			}
		}
		
		override public function addItem(_item:ItemView):Boolean{
			/*if (_item.model.charges>0){
				_item=addStackable(_item,false);
				if (_item==null) return true;
			}*/
			
			for (var i:int=10;i<10+NUM_SLOTS;i+=1){
				if (!itemA[i].hasItem()){
					if (origin!=null){
						origin.addItemAt(_item.model,i);
					}
					itemA[i].addItem(_item);
					return true;
				}
			}
			return false;
		}
		
		public function addNoStacking(_item:ItemView):Boolean{
			for (var i:int=10;i<10+NUM_SLOTS;i+=1){
				if (!itemA[i].hasItem()){
					if (origin!=null){
						origin.addItemAt(_item.model,i);
					}
					itemA[i].addItem(_item);
					return true;
				}
			}
			return false;
		}
		
		override public function addItemAt(_item:ItemView,i:int):Boolean{
			//return true if successful
			if ((_item==null)||(i==-1)){
				return true;
			}
			
			if (origin!=null){
				origin.addItemAt(_item.model,i);
			}
			
			itemA[i].addItem(_item);
			return true;
		}
		
		public function addBelt(_item:ItemView){
			if (_item.model.charges>0){
				_item=addStackable(_item);
				if (_item==null) return;
			}
			for (var i:int=5;i<10;i+=1){
				if (!itemA[i].hasItem()){
					addItemAt(_item,i);
					return;
				}
			}
			addItem(_item);
		}
		
		override public function removeItem(_item:ItemView):Boolean{
			if (origin!=null){
				origin.removeItemAt(_item.index);
			}
			itemA[_item.index].removeItem();
			return true;
		}
		
		override public function removeItemAt(i:int):ItemView{
			if (origin!=null){
				origin.removeItemAt(i);
			}
			return itemA[i].removeItem();
		}
		
		public function isFull():Boolean{
			for (var i:int=10;i<30;i+=1){
				if (itemA[i].stored==null){
					return false;
				}
			}
			return true;
		}
	}
}
