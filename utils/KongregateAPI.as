package utils {
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.system.Security;
	import items.ItemView;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import ui.windows.ConfirmWindow;
	import gameEvents.GameEvent;
	import ui.windows.TokenWindow;
	import hardcore.HardcoreGameControl;

	public class KongregateAPI {
		//public static const LEVEL_ACHIEVED;//
		public static const LEVEL_REACHED:String="levelReached",
							AREA_REACHED:String="areaReached",
							CHALLENGE_REACHED:String="challengeReached",
							HARDCORE_CHALLENGE_REACHED:String="warriorCReached",
							TOURNAMENT1_REACHED:String="tournament1Reached",
							ASCEND_REACHED:String="numAscends",
							EPIC_REACHED:String="epicReached";
								
		public static var disabled:Boolean = true;
		
		public static function submitAll(){
			if (disabled) return;
			
			submit(AREA_REACHED);
			submit(LEVEL_REACHED);
			submit(CHALLENGE_REACHED);
			submit(HARDCORE_CHALLENGE_REACHED);
			submit(TOURNAMENT1_REACHED);
			submit(ASCEND_REACHED);
			submit(EPIC_REACHED);
			
		}
		
		public static function submit(s:String){
			if (disabled) return;
			
			var i:int=0;
			switch(s){
				case LEVEL_REACHED:
					if (Facade.gameC is HardcoreGameControl) return;
					i=Facade.gameM.playerM.level;
					break;
				case AREA_REACHED:
					if (Facade.gameC is HardcoreGameControl) return;
					i=Facade.gameM.area;
					break;
				case CHALLENGE_REACHED:
					if (Facade.gameM.playerM.challenge[0]>0){
						i=Facade.saveC.challengeArray(Facade.gameM.playerM.challenge[0]-1,0)[1];
					}
					testChallengeDefeated(i);
					break;
				case TOURNAMENT1_REACHED:
					if (Facade.gameM.playerM.challenge[1]>0){
						i=Facade.saveC.challengeArray(Facade.gameM.playerM.challenge[1]-1,1)[1];
					}
					break;
				case HARDCORE_CHALLENGE_REACHED:
					//return;
					i=GameData.hardcore;
					/*if (GameData.hardcore>0){
						i=Facade.saveC.challengeArray(GameData.hardcore-1,0)[1];
					}*/
					break;
				case ASCEND_REACHED:
					i=GameData.getScore(GameData.SCORE_ASCENDS);
					if (i>=50){
						GameData.achieve(GameData.ACHIEVE_ASCEND_50);
					}
					break;
				case EPIC_REACHED:
					i=GameData.epics[0];
					break;
			}
			// api.stats.submit(s,i);
		}
		
		public static function checkEvent(e:GameEvent){
			switch(e.type){
				case GameEvent.AREA_REACHED: submit(AREA_REACHED); break;
				case GameEvent.EPIC_AREA_REACHED: submit(EPIC_REACHED); break;
				case GameEvent.CHALLENGE_DEFEATED: submit(CHALLENGE_REACHED); submit(TOURNAMENT1_REACHED);break;
				case GameEvent.ASCEND: submit(ASCEND_REACHED); break;
				case GameEvent.LEVEL_UP: submit(LEVEL_REACHED); break;
				case GameEvent.CHALLENGE_AREA_REACHED:
				case GameEvent.HARDCORE_CHALLENGE_DEFEATED: submit(HARDCORE_CHALLENGE_REACHED); break;
			}
		}
		
		public static function testChallengeDefeated(i:int=-1){
			if (i==-1){
				if (Facade.gameM.playerM.challenge[0]>0){
					var i:int=Facade.saveC.challengeArray(Facade.gameM.playerM.challenge[0]-1,0)[1];
				}
			}
			if (i>=800){
				GameData.achieve(GameData.ACHIEVE_ROGUE);
			}
		}
		
		public static var _Success:Function;
		
		public static const TURBO:String="turbomode",
							BOOST:String="xpboost",
							PREMIUM_BUNDLE:String="premiumbundle",
							PREMIUM_BUNDLE2:String="premiumbundle2",
							MINI_BUNDLE:String="minibundle",
							MINI_BUNDLE2:String="minibundle2",
							MINI_BUNDLE3:String="minibundle3",
							PREMIUM_CLASS:String="premiumclass",
							SUPER_PREMIUM:String="superpremium";
		
		public static var boughtBoost:Boolean=false;
		
		public static function buyItem(rSuccess:Function,amount:int=15,_update:Function=null):Boolean{
			_Success=rSuccess;
			
			if (Facade.gameM.kreds>=amount){
				checkIngamePurchase(amount);
			}else{
				Facade.stage.addChild(new TokenWindow(_update));
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
				Facade.stage.addChild(new TokenWindow(_update));
			}
			return false;
		}
		
		public static function checkIngamePurchase(_amount:int){
			new ConfirmWindow("Finish purchasing this item using "+_amount+" Power Tokens?",50,50,finishIngamePurchase,_amount);
		}
		
		public static function finishIngamePurchase(_amount:int){
			if (_amount==10) boughtBoost=true;
			GameData.kreds-=_amount;
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
		
		
		public static function buyTokens(rSuccess:Function,amount:int){
			_Success=rSuccess;
			
			if (disabled){
				checkIngamePurchase(0);
			}else{
				// api.mtx.purchaseItems(["tokens"+String(amount)],checkPurchase);
			}
		}
		
		public static function checkPurchase(result:Object) {
			if (result.success){
				// api.mtx.requestUserItemList(null, consumeItem);
			}else{
				_Success=null;
			}
		}
		
		public static function consumeItem(result:Object){
			if (result.success){
				for (var i:int=0;i<result.data.length;i+=1){
					var _item:Object=result.data[i];
					switch(_item.identifier){
						case "tokens55": case "tokens120": case "tokens260": case "tokens700": case "tokens150": case "tokens15":
							_Success();
							_Success=null;
							// api.mtx.useItemInstance(_item.id,nullFunction);
							GameData.achieve(GameData.ACHIEVE_HOLY);
							break;
					}
				}
			}
			Facade.saveC.saveChar();
		}
		
		public static function consumeToKreds(result:Object){
			var _kreds:int=0;
			if (result.success){
				for (var i:int=0;i<result.data.length;i+=1){
					var _item:Object=result.data[i];
					switch(_item.identifier){
						case "tokens55":
							_kreds+=55;
							// api.mtx.useItemInstance(_item.id,nullFunction);
							break;
						case "tokens120":
							_kreds+=120;
							// api.mtx.useItemInstance(_item.id,nullFunction);
							break;
						case "tokens260":
							_kreds+=260;
							// api.mtx.useItemInstance(_item.id,nullFunction);
							break;
						case "tokens700":
							_kreds+=700;
							// api.mtx.useItemInstance(_item.id,nullFunction);
							break;
						case "tokens1500":
							_kreds+=1500;
							// api.mtx.useItemInstance(_item.id,nullFunction);
							break;
						case "tokens15":
							_kreds+=15;
							// api.mtx.useItemInstance(_item.id,nullFunction);
							break;
					}
				}
			}
			if (_kreds>0){
				new ConfirmWindow("Incomplete purchase detected.  You have been credited with "+_kreds+" Power Tokens to be used in the Premium Shop. "+result.data.length);
				GameData.kreds+=_kreds;
				GameData.achieve(GameData.ACHIEVE_HOLY);
			}
		}
		
		public static function nullFunction(result:Object=null){
			
		}
		
		public static function getName():String{
			// if (disabled){
				return "OfflineMode4";
			// }else{
			// 	return api.services.getUsername();
			// }
		}
	}	
}
