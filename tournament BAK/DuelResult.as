package tournament {
	
	public class DuelResult {
		public static const FORMAT:Array=[P1_NAME,P2_NAME,WINTYPE,TURNS,RESOURCES_L,RESOURCES_R];
		
		public static const WINTYPE:String="Result",
							TURNS:String="Num Turns",
							RESOURCES_L:String="Resources",
							RESOURCES_R:String="Opp Resources",
							P1_NAME:String="Character",
							P2_NAME:String="Opponent",
							
							WIN:String="Win",
							LOSS:String="Loss",
							TIE:String="Tie";
							
		
		public var left:Array;
		public var right:Array;
		public var replay:Array;
		public var winner:String="Tie";
		public var turns:int=0;
		public var resourcesLeft:Number;
		public var resourcesRight:Number;
		
		public function DuelResult(_left:Array=null,_right:Array=null){
			left=_left;
			right=_right;
		}
		
		public function finishRound(_winner:String,_left:SpriteModel,_right:SpriteModel,_turns:Number){
			winner=_winner;
			turns=Math.ceil(_turns);
			resourcesLeft=getResources(_left);
			resourcesRight=getResources(_right);
		}
		
		public function getResources(_v:SpriteModel):Number{
			var m:Number=0;
			var n:Number=0;
			for (var i:int=0;i<_v.belt.length;i+=1){
				if (_v.belt[i]!=null && _v.belt[i].charges>=0){
					m+=_v.belt[i].charges/_v.belt[i].maxCharges();
					n+=1;
				}
			}
			if (n==0){
				m=1;
			}else{
				m/=n;
			}
			
			return Math.round(m*100);
		}
		
		public function getTextBar(_width:Number):TournamentTextBar{
			var a:Array=getResultArray(true);
			
			return new TournamentTextBar(a,_width);
		}
		
		public function getSpreadsheetRow(_player:String):String{
			var a:Array=getResultArray(true);
			var m:String="";
			if (_player!=null) m+=_player+"\t";
			
			for (var i:int=0;i<a.length;i+=1){
				m+=a[i]+"\t";
			}
			return m;
		}
		
		public function flip():DuelResult{
			var m:DuelResult=new DuelResult(right,left);
			if (winner==WIN){
				m.winner=LOSS;
			}else if (winner==LOSS){
				m.winner=WIN;
			}else{
				m.winner=TIE;
			}
			m.resourcesLeft=resourcesRight;
			m.resourcesRight=resourcesLeft;
			m.turns=turns;
			
			if (replay!=null){
				var _replay:Array=replay.concat();
				var _temp:Number=_replay[0];
				_replay[0]=_replay[1];
				_replay[1]=_temp;
				m.replay=_replay;
			}
			
			return m;
		}
		
		public function getResultArray(toStrings:Boolean=false):Array{
			if (toStrings){
				return [left[0],right[0],winner,String(turns),String(resourcesLeft)+"%",String(resourcesRight)+"%"];
			}else{
				return [left[0],right[0],getWinInt(),turns,resourcesLeft,resourcesRight];
			}
		}
		
		public function getFullArray():Array{
			return [left,right,getWinInt(),turns,resourcesLeft,resourcesRight,replay];
		}
		
		public static function fromResultArray(a:Array):DuelResult{
			if (a.length>6) return fromFullArray(a);
			
			var m:DuelResult=new DuelResult();
			m.left=[a[0]];
			m.right=[a[1]];
			m.setWinInt(a[2]);
			m.turns=a[3];
			m.resourcesLeft=a[4];
			m.resourcesRight=a[5];
			return m;
		}
		
		public function getWinInt():int{
			switch(winner){
				case WIN: return 1;
				case LOSS: return 0;
				case TIE: return -1;
				default: return -1;
			}
		}
		
		public function setWinInt(i:int){
			switch(i){
				case -1: winner=TIE; break;
				case 0: winner=LOSS; break;
				case 1: winner=WIN; break;
			}
		}
		
		public static function fromFullArray(a:Array):DuelResult{
			if (a.length<7) return fromResultArray(a);
			
			var m:DuelResult=new DuelResult();
			m.left=a[0];
			m.right=a[1];
			m.setWinInt(a[2]);
			m.turns=a[3];
			m.resourcesLeft=a[4];
			m.resourcesRight=a[5];
			m.replay=a[6];
			return m;
		}
	}
}
