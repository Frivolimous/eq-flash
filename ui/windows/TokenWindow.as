package ui.windows {
	import utils.KongregateAPI;
	import utils.GameData;
	import flash.display.MovieClip;
	
	public class TokenWindow extends MovieClip{
			//kred50b	50 PT
			//kred90b	100 PT
			//kred160b	200 PT
			//kred350b	500 PT
			//kred600b	1000 PT
			//kred1000b	2000 PT
		var update:Function;
		
		public function TokenWindow(_update:Function=null) {
			update=_update;
			
			doneB.update(StringData.DONE,closeWindow);

			kreds50b.update("15 Kreds",buyTokens);
			kreds50b.index=15;
			kreds50b.setDesc("15 Kreds!","Purchase 15 Power Tokens with 15 Kreds.  These can be used for ALL in-game purchases.");
			kreds90b.update("50 Kreds",buyTokens);
			kreds90b.index=55;
			kreds90b.setDesc("50 Kreds!","Purchase 55 Power Tokens with 50 Kreds.  These can be used for ALL in-game purchases.");
			kreds160b.update("100 Kreds",buyTokens);
			kreds160b.index=120;
			kreds160b.setDesc("100 Kreds!","Purchase 120 Power Tokens with 100 Kreds.  These can be used for ALL in-game purchases.");
			kreds350b.update("200 Kreds",buyTokens);
			kreds350b.index=260;
			kreds350b.setDesc("200 Kreds!","Purchase 260 Power Tokens with 200 Kreds.  These can be used for ALL in-game purchases.");
			kreds600b.update("500 Kreds",buyTokens);
			kreds600b.index=700;
			kreds600b.setDesc("500 Kreds!","Purchase 700 Power Tokens with 500 Kreds.  These can be used for ALL in-game purchases.");
			kreds1000b.update("1000 Kreds",buyTokens);
			kreds1000b.index=1500;
			kreds1000b.setDesc("1000 Kreds!","Purchase 1500 Power Tokens with 1000 Kreds.  These can be used for ALL in-game purchases.");
		}
		
		var amount:int=0;
		function buyTokens(_amount:int){
			amount=_amount;
			KongregateAPI.buyTokens(finishBuyTokens,_amount);
		}
		
		function finishBuyTokens(){
			GameData.kreds+=amount;
			new ConfirmWindow("Congratulations!  You purchased "+String(amount)+" more Power Tokens, bringing your total up to "+String(Facade.gameM.kreds)+".",50,50,null,0,null,3);
		}
		
		function closeWindow(){
			if (update!=null) update();
			parent.removeChild(this);
		}

	}
}
