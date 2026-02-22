package ui.main{
	import flash.display.Sprite;
	import ui.windows.StatusWindow;
	import ui.windows.StatusWindow2;
	
	public class StatsTab extends Sprite{
		var statusW:StatusWindow=new StatusWindow;
		var statusW2:StatusWindow2=new StatusWindow2;
		
		public var origin:SpriteModel;
		
		public function StatsTab(){
			toggleB.update("Detailed",changeTab);
			addChild(statusW);
		}
		
		public function update(_origin:SpriteModel){
			origin=_origin;
			statusW.update(origin);
			statusW2.update(origin);
		}
		
		
		function changeTab(){
			if (contains(statusW)){
				removeChild(statusW);
				addChild(statusW2);
				addChild(toggleB);
				toggleB.updateLabel("Detailed");
			}else{
				removeChild(statusW2);
				addChild(statusW);
				addChild(toggleB);
				toggleB.updateLabel("Simple");
			}
		}
	}
}