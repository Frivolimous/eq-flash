package ui.game {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class ZoneWindow extends MovieClip{
		
		public function ZoneWindow() {
			progB.setTooltipName("Zone Progress");
			progB.countText=progN;
			removeChild(bossFlash)
		}
		
		public function set atBoss(b:Boolean){
			if (b){
				addChild(bossFlash);
				if (contains(progB)){
					removeChild(progB);
					removeChild(progN);
				}
			}else{
				addChild(progB);
				addChild(progN);
				if (contains(bossFlash)){
					removeChild(bossFlash);
				}
			}
		}
		
		public function get atBoss():Boolean{
			return contains(bossFlash);
		}
	}
	
}
