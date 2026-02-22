package ui.main.assets {
	import ui.assets.GraphicButton;
	import ui.windows.TokenWindow;
	
	public class SoulTokenDisplay extends GraphicButton{

		public function SoulTokenDisplay() {
			//update(null,popPurchase);
			setDesc("Soul Power","These are used to purchase Artifacts in the Ascension Screen, or Essences in the Mystic Forge.");
		}
		
		function popPurchase(){
			//Facade.stage.addChild(new TokenWindow(updateDisplay));
		}
		
		public function updateDisplay(){
			gold.text=String(Facade.gameM.souls);
		}
	}
}
