package ui.assets{
	import flash.display.Sprite;
	import system.actions.ActionBase;
	
	public class SymbolPair extends Sprite{
		public static const STRENGTH:int=1,
							MPOW:int=2,
							INIT:int=3,
							HIT:int=4,
							CRIT:int=5,
							BLOCK:int=6,
							DODGE:int=7,
							RMAG:int=8,
							RCHEM:int=9,
							RSPIRIT:int=10;
		
		public static const ACTION:int=0,
							STAT:int=1;
							
		public var statIndex:int;
		public var type:int=1;

		public function SymbolPair(){
			mouseChildren=false;
		}
		
		public function set text(_text:String){
			label.text=_text;
		}
				
		public function get text():String{
			return label.text;
		}
		
		public function set symbol(i:int){
			switch(i){
				case 1: statIndex=StatModel.STRENGTH; break;
				case 2: statIndex=StatModel.MPOWER; break;
				case 3: statIndex=StatModel.INITIATIVE; break;
				case 4: statIndex=ActionBase.HITRATE; break;
				case 5: statIndex=ActionBase.CRITRATE; break;
				case 6: statIndex=StatModel.BLOCK; break;
				case 7: statIndex=StatModel.DODGE; break;
				case 8: statIndex=StatModel.RMAGICAL; break;
				case 9: statIndex=StatModel.RCHEMICAL; break;
				case 10: statIndex=StatModel.RSPIRIT; break;
			}
			
			statSymbol.gotoAndStop(i);
		}
		
		public function get symbol():int{
			return 0;
		}
		
		public function getTooltipName():String{
			if (type==STAT){
				return StatModel.statNames[statIndex];
			}else{
				return ActionBase.statNames[statIndex];
			}
		}
		
		public function getTooltipDesc():String{
			 if (type==STAT){
				 return StringData.stat(statIndex);
			 }else if (type==ACTION){
				 return StringData.actionStat(statIndex);
			 }
			 return "";
		}
	}
}