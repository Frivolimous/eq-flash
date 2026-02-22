package items{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import skills.SkillData;
	import ui.assets.PullButton;
	
	public class DuelInventoryUI extends PlayerInventoryUI{
		//public var itemB:Array=new Array(8);
				
		public function DuelInventoryUI(){
			IWIDTH=38;
			IHEIGHT=34;
			
			itemA=new Array(10);

			for (var i:int=0;i<10;i+=1){
				if (i==0){
					itemA[i]=makeBox(i,9.5,11.6,ItemBox.BIG);
				}else if (i==1){
					itemA[i]=makeBox(i,52,11.6,ItemBox.BIG);
				}else if (i<5){
					itemA[i]=makeBox(i,94.5+(i-2)*42.52,11.6,ItemBox.BIG);
				}else if (i<10){
					itemA[i]=makeBox(i,9.5+(i-5)*42.51,69.6,ItemBox.BIG);
					itemA[i].checkIndex=ItemBox.BELT;
				}
			}
			itemA[0].checkIndex=ItemBox.WEAPON;
			itemA[1].checkIndex=ItemBox.HELMET;
			itemA[2].checkIndex=itemA[3].checkIndex=itemA[4].checkIndex=ItemBox.MAGIC;
		}
	}
}
