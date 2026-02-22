package ui.main.assets {
	import ui.assets.GraphicButton;
	import ui.windows.TokenWindow;
	
	public class PowerTokenDisplay extends GraphicButton{

		public function PowerTokenDisplay() {
			update(null,popPurchase);
			setDesc("Power Tokens","These can be used instead of Kreds at a 1:1 ratio.  Click to purchase them in bulk!");
		}
		
		function popPurchase(){
			Facade.stage.addChild(new TokenWindow(updateDisplay));
		}
		
		public function updateDisplay(){
			gold.text=String(Facade.gameM.kreds);
		}
	}
}
