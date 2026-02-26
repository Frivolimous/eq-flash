package utils {
	import ui.windows.ConfirmWindow;
	import utils.AchieveData;

	public class PurchaseManager {
    public static var _Success:Function;
    public static var boughtBoost:Boolean=false;

		public static const TURBO:String="turbomode",
							BOOST:String="xpboost",
							PREMIUM_BUNDLE:String="premiumbundle",
							PREMIUM_BUNDLE2:String="premiumbundle2",
							MINI_BUNDLE:String="minibundle",
							MINI_BUNDLE2:String="minibundle2",
							MINI_BUNDLE3:String="minibundle3",
							PREMIUM_CLASS:String="premiumclass",
							SUPER_PREMIUM:String="superpremium";

		public static function buyItem(rSuccess:Function,amount:int=15,_update:Function=null):Boolean{
			_Success=rSuccess;
			
			if (Facade.gameM.kreds>=amount){
				checkIngamePurchase(amount);
			}else{
				new ConfirmWindow("Not enough Power Tokens to make this purchase.");
			}
			return false;
		}
		
		public static function buySpecial(rSuccess:Function,_name:String,_update:Function=null):Boolean{
			var _amount:int;
			_Success=rSuccess;
			switch(_name){
				case TURBO: _amount=20; break;
				case BOOST: _amount=10; break;
				case PREMIUM_BUNDLE: _amount=100; break;
				case PREMIUM_BUNDLE2: _amount=120; break;
				case PREMIUM_CLASS: _amount=55; break;
				case SUPER_PREMIUM: _amount=20; break;
				case MINI_BUNDLE: _amount=50; break;
				case MINI_BUNDLE2: _amount=55; break;
				case MINI_BUNDLE3: _amount=75; break;
			}
			
			if (Facade.gameM.kreds>=_amount){
				if (_name==BOOST && boughtBoost){
					finishIngamePurchase(_amount);
				}else{
					checkIngamePurchase(_amount);
				}
			}else{
        new ConfirmWindow("Not enough Power Tokens to make this purchase.");
			}
			return false;
		}
		
		public static function checkIngamePurchase(_amount:int){
			new ConfirmWindow("Finish purchasing this item using "+_amount+" Power Tokens?",50,50,finishIngamePurchase,_amount);
		}
		
		public static function finishIngamePurchase(_amount:int){
			if (_amount==10) boughtBoost=true;
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