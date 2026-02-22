package limits{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import skills.SkillData;
	import ui.assets.PullButton;
	
	public class PlayerLimitUI extends BaseLimitUI{
		
		public function PlayerLimitUI(){
			IWIDTH=38;
			IHEIGHT=34;
			NUM_SLOTS=13;
			
			for (var i:int=0;i<13;i+=1){
				if (i<3){
					itemA[i]=makeBox(i,31.55+59.05*i,104.8,null);
				}else{
					itemA[i]=makeBox(i,10.5+((i-3)%5)*40.05,(i<8?50.65:11.6));
				}
			}
		}
						
		override public function update(_o:SpriteModel=null){
			clear();
			
			origin=_o;
			if (_o==null) return;
			
			if (origin!=null){
				for (var i:int=0;i<3;i+=1){
					if (origin.limitEquip[i]==false){
						itemA[i].cover=true;
					}else{
						itemA[i].cover=false;
						if (origin.limitEquip[i] is LimitModel){
							itemA[i].addItem(new LimitView(origin.limitEquip[i]));
						}
					}
				}
				for (i=0;i<10;i+=1){
					if (origin.limitStored[i]!=null){
						itemA[i+3].addItem(new LimitView(origin.limitStored[i]));
					}
				}
			}
		}
		
		override public function addItem(_item:LimitView):Boolean{
			for (var i:int=3;i<13;i+=1){
				if (!itemA[i].hasItem()){
					if (origin!=null){
						origin.addLimitAt(_item.model,i);
					}
					itemA[i].addItem(_item);
					return true;
				}
			}
			return false;
		}
		
		override public function addItemAt(_item:LimitView,i:int):Boolean{
			//return true if successful
			if ((_item==null)||(i==-1)){
				return true;
			}
			
			if (origin!=null){
				origin.addLimitAt(_item.model,i);
			}
			
			itemA[i].addItem(_item);
			return true;
		}
		
		override public function removeItem(_item:LimitView):Boolean{
			if (origin!=null){
				origin.removeLimitAt(_item.index);
			}
			itemA[_item.index].removeItem();
			return true;
		}
		
		override public function removeItemAt(i:int):LimitView{
			if (origin!=null){
				origin.removeLimitAt(i);
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
