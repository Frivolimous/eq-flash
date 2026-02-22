package ui.assets {
	import flash.display.Sprite;
	import ui.main.CosmeticsTab;
	import sprites.BallHead;
	
	public class CosmeticSelect extends Sprite{
		var list:Array;
		var output:Function;
		var i:int;
		var type:String
		
		public function CosmeticSelect() {
			rightB.update(null,scrollRight);
			leftB.update(null,scrollLeft);
			tooltipOver.update(null,nullFunction);
		}
		
		function nullFunction(){}
		
		public function update(_type:String,_list:Array,_output:Function){
			list=_list;
			output=_output;
			type=_type;
			tooltipOver.setDesc(_type,"Use the arrows to change your cosmetic selection.");
			i=0;
			setText();
			if (list.length==1){
				rightB.disabled=true;
				leftB.disabled=true;
			}else{
				rightB.disabled=false;
				leftB.disabled=false;
			}
		}
		
		public function selectCosmetic(_cosmetic:int){
			for (var j:int=0;j<list.length;j+=1){
				if (list[j]==_cosmetic){
					i=j;
					setText();
					return;
				}
			}
		}
		
		function scrollRight(){
			i+=1;
			if (i>=list.length) i=0;
			setText();
			output(type,list[i]);
		}
		
		function scrollLeft(){
			i-=1;
			if (i<0) i=list.length-1;
			setText();
			output(type,list[i]);
		}
		
		function setText(){
			if (list[i]==-1){
				selectedT.text="Default";
				return;
			}
			switch(type){
				case CosmeticsTab.SKIN: selectedT.text=BallHead.BODY_NAMES[list[i]]; break;
				case CosmeticsTab.EYES: selectedT.text=BallHead.EYES_NAMES[list[i]]; break;
				case CosmeticsTab.MOUTH: selectedT.text=BallHead.MOUTH_NAMES[list[i]]; break;
				case CosmeticsTab.FEET: selectedT.text=BallHead.FEET_NAMES[list[i]]; break;
				case CosmeticsTab.EXTRA1: case CosmeticsTab.EXTRA2: case CosmeticsTab.EXTRA3:
					selectedT.text=BallHead.EXTRA_NAMES[list[i]]; break;
				case CosmeticsTab.AURA: selectedT.text=BallHead.AURA_NAMES[list[i]]; break;
			}
			
		}
	}
}
