package items {
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class StoreInventoryUI extends PlayerInventoryUI{
		//UI of player equipment for the store; 5, 5, 5x4

		public function StoreInventoryUI() {
			var _goldBox=new GoldBox;
			gold=_goldBox.gold;
			_goldBox.x=533;
			_goldBox.y=63;
			addChild(_goldBox);
			IWIDTH=32.5;
			IHEIGHT=34;
			
			for (var i:int=0;i<30;i+=1){
				if (i<5){
					//itemA[i]=makeBox(i,367+i*41.45,117,((i>=2)?ItemBox.SMALL:null));
					itemA[i]=makeBox(i,367+i*41.45,117);
				}else if (i<10){
					//itemA[i]=makeBox(i,367+(i-5)*41.45,154,ItemBox.SMALL);
					itemA[i]=makeBox(i,367+(i-5)*41.45,154);
					itemA[i].checkIndex=ItemBox.BELT;
				}else{
					itemA[i]=makeBox(i,367+((i-10)%5)*41.45,207+Math.floor((i-10)/5)*36.5);
				}
			}
			itemA[0].checkIndex=ItemBox.WEAPON;
			itemA[1].checkIndex=ItemBox.HELMET;
			itemA[2].checkIndex=itemA[3].checkIndex=itemA[4].checkIndex=ItemBox.MAGIC;
		}
	}
}
