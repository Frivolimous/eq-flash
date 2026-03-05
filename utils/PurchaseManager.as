package utils {
	import ui.windows.ConfirmWindow;
	import utils.AchieveData;

	public class PurchaseManager {
    public static var _Success:Function;

		public static function buyItem(rSuccess:Function,amount:int=15,_update:Function=null):Boolean{
			_Success=rSuccess;
			
			if (Facade.gameM.kreds>=amount){
				checkIngamePurchase(amount);
			}else{
				new ConfirmWindow("Not enough Power Tokens to make this purchase.");
			}
			return false;
		}
		
		public static function checkIngamePurchase(_amount:int){
			new ConfirmWindow("Finish purchasing this item using "+_amount+" Power Tokens?",50,50,finishIngamePurchase,_amount);
		}
		
		public static function finishIngamePurchase(_amount:int){
			GameData.kreds-=_amount;
			AchieveData.achieve(AchieveData.BUY_MYTHIC);

			_Success();
			_Success=null;
			//Facade.saveC.saveChar();
		}
		
		public static function buyItemSouls(rSuccess:Function,amount:int=15,_update:Function=null):Boolean{
			_Success=rSuccess;
			
			if (Facade.gameM.souls>=amount){
				checkIngamePurchaseSouls(amount);
			}else{
				new ConfirmWindow("Not enough Soul Power to make this purchase.");
			}
			return false;
		}
		
		public static function checkIngamePurchaseSouls(_amount:int){
			new ConfirmWindow("Finish purchasing this item using "+_amount+" Souls?",50,50,finishIngamePurchaseSouls,_amount);
		}
		
		public static function finishIngamePurchaseSouls(_amount:int){
			GameData.souls-=_amount;
			_Success();
			_Success=null;
			//Facade.saveC.saveChar();
		}


  }
}