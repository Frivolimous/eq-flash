package ui.main.assets {
	import ui.assets.GraphicButton;
	import ui.windows.TokenWindow;
	
	public class PowerTokenDisplay extends GraphicButton{

		public function PowerTokenDisplay() {
			update(null,popPurchase);
			setDesc("Power Tokens","Obtained by salvaging Mythic and Legendary items and used to purchase new ones.");
		}
		
		function popPurchase(){
			Facade.stage.addChild(new TokenWindow(updateDisplay));
		}
		
		public function updateDisplay(){
			gold.text=String(Facade.gameM.kreds);
		}
	}
}
