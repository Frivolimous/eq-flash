package items {
	import flash.display.Bitmap;
	import utils.GameData;
	
	public class StatisticsInventoryUI extends PlayerInventoryUI{
		//UI of player equipment for the status screen; 5, 5, 5x4

		public function StatisticsInventoryUI() {			
			gold=goldBox.gold;
			/*gold=new BitText(null,50,7,false,BitText.RIGHT,0xffff00);
			gold.x=160;
			gold.y=10;
			addChild(gold);*/
			
			IWIDTH=32.5;
			IHEIGHT=34;
			
			for (var i:int=0;i<30;i+=1){
				if (i<2){
					itemA[i]=makeBox(i,24.3+40.25*(i%5),76.1+36.2*Math.floor(i/5),ItemBox.SMALL);
				}else if (i>=2 && i<5){
					itemA[i]=makeBox(i,24.3+40.25*(i%5),76.1+36.2*Math.floor(i/5),ItemBox.SMALL);
					itemA[i].checkIndex=ItemBox.MAGIC;
				}else if (i>=5 && i<10){
					itemA[i]=makeBox(i,24.3+40.25*(i%5),76.1+36.2*Math.floor(i/5),ItemBox.SMALL);
					itemA[i].checkIndex=ItemBox.BELT;
				}else{
					itemA[i]=makeBox(i,24.3+40.25*(i%5),76.1+36.2*Math.floor(i/5));
				}
			}
			itemA[0].checkIndex=ItemBox.WEAPON;
			itemA[1].checkIndex=ItemBox.HELMET;
		}
		
		
		public function lockInventory(b:Boolean){
			locked=b;
		}
		
		public function removeFirst5(){
			for (var i:int=10;i<15;i+=1){
				removeChild(itemA[i]);
			}
		}
		public function removeLast15(){
			for (var i:int=15;i<30;i+=1){
				removeChild(itemA[i]);
			}
		}
		
		override public function update(_o:SpriteModel=null){
			if (_o!=null){
			}
			super.update(_o);
		}
		
	}
}
