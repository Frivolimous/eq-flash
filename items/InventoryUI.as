package items{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import skills.SkillData;
	import ui.assets.PullButton;
	
	public class InventoryUI extends PlayerInventoryUI{
		//public var itemB:Array=new Array(8);
		
		public var trash:Sprite;
		public function InventoryUI(){
			gold=goldBox.gold;
			gold.selectable=false;
			
			IWIDTH=38;
			IHEIGHT=34;
			
			trash=new Sprite;
			trash.graphics.beginFill(0,0.01);
			trash.graphics.drawRect(0,0,35,35);
			trash.name=MouseControl.TRASH;
			trash.x=406;
			trash.y=134.8;
			trash.buttonMode=true;
			addChild(trash);
			
			for (var i:int=0;i<30;i+=1){
				if (i==0){
					itemA[i]=makeBox(i,18.65,38.7,ItemBox.BIG);
				}else if (i==1){
					itemA[i]=makeBox(i,58.7,38.7,ItemBox.BIG);
				}else if (i<5){
					itemA[i]=makeBox(i,106.1+(i-2)*40.05,38.7,ItemBox.BIG);
				}else if (i<10){
					itemA[i]=makeBox(i,236+(i-5)*40.2,38.7,ItemBox.BIG);
					itemA[i].checkIndex=ItemBox.BELT;
				}else{
					itemA[i]=makeBox(i,6.4+(i%10)*40.051,(i<20?95.8:134.8));
				}
				/*if (i<5){
					itemA[i]=makeBox(i,15+i*(IWIDTH+1),6,((i>=2)?ItemBox.BIG:null));
				}else if (i<10){
					itemA[i]=makeBox(i,235+(i-5)*(IWIDTH+1),6,ItemBox.BIG);
					itemA[i].checkIndex=ItemBox.BELT;
				}else{
					itemA[i]=makeBox(i,5+((i-10)%10)*(IWIDTH+1),85+Math.floor((i-10)/10)*(IHEIGHT+1));
				}*/
			}
			itemA[0].checkIndex=ItemBox.WEAPON;
			itemA[1].checkIndex=ItemBox.HELMET;
			itemA[2].checkIndex=itemA[3].checkIndex=itemA[4].checkIndex=ItemBox.MAGIC;
		}
		
	}
}
