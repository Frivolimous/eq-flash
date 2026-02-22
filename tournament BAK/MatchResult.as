package tournament {
	
	public class MatchResult {
		public static const PLAYER:String="Player",
							WINRATE:String="Winrate",
							WINS:String="Wins",
							LOSSES:String="Losses",
							TIES:String="Ties",
							TURNS:String="Num Turns",
							RESOURCES_L:String="Avg Resources",
							RESOURCES_R:String="Opp Resources",
							P1_NAME:String="Character",
							P2_NAME:String="Opponent",
							RANK:String="Rank",
							LEAGUE:String="League";
							
		public static var format:Array;
		public static var titleBar:TournamentTextBar;
		public static var width:Number;
		
		public var league:String;
		public var rank:int;
		
		public var player:String;
		public var wins:int;
		public var losses:int;
		public var ties:int;
		public var rounds:Array;
		
		public var avgTurns:Number;
		public var avgResourcesL:Number;
		public var avgResourcesR:Number;
		public var winrate:Number=0;
		
		public var textBar:TournamentTextBar;
		
		public static function getTitleBar(a:Array,_width:Number):TournamentTextBar{
			format=a;
			width=_width
			titleBar=new TournamentTextBar(a,_width,true);
			return titleBar;
		}
		
		public function MatchResult(){
			reset();
		}

		public function reset(){
			wins=losses=ties=0;
			avgTurns=avgResourcesL=avgResourcesR=0;
			rounds=new Array();
		}
		
		public function addRound(_result:DuelResult){
			rounds.push(_result);
			/*if (_result.winner==DuelResult.WIN){
				wins+=1;
			}else if (_result.winner==DuelResult.LOSS){
				losses+=1;
			}else{
				ties+=1;
			}
			avgTurns=(avgTurns*rounds.length + _result.turns)/(rounds.length+1);
			avgResourcesL=(avgResourcesL*rounds.length+ _result.resourcesLeft)/(rounds.length+1);
			avgResourcesR=(avgResourcesR*rounds.length+ _result.resourcesRight)/(rounds.length+1);
			rounds.push(_result);*/
		}
		
		public function setWinrate(){
			winrate=Math.round((wins+ties/2)/(wins+ties+losses)*100);
		}
		
		public function deriveAllStats(){
			var _resourcesL:Number=0;
			var _resourcesR:Number=0;
			var _turns:Number=0;
			for (var i:int=0;i<rounds.length;i+=1){
				_resourcesL+=rounds[i].resourcesLeft;
				_resourcesR+=rounds[i].resourcesRight;
				_turns+=rounds[i].turns;
				if (rounds[i].winner==DuelResult.WIN){
					wins+=1;
				}else if (rounds[i].winner==DuelResult.LOSS){
					losses+=1;
				}else{
					ties+=1;
				}
			}
			avgResourcesL=Math.round(_resourcesL/rounds.length);
			avgResourcesR=Math.round(_resourcesR/rounds.length);
			avgTurns=Math.round(_turns/rounds.length);
			setWinrate();
		}
		
		public function getTextBar():TournamentTextBar{
			textBar=new TournamentTextBar(getTextArray(),width);
			return textBar;
		}
		
		public function getSpreadsheetRow():String{
			var m:String="";
			var a:Array=getTextArray();
			for (var i:int=0;i<a.length;i+=1){
				m+=String(a[i]);
				if (i+1<a.length) m+="\t";
			}
			return m;
		}
		
		public function getTextArray():Array{
			var a:Array=new Array();
			for (var i:int=0;i<format.length;i+=1){
				switch(format[i]){
					case LEAGUE: a[i]=league; break;
					case P1_NAME: a[i]=rounds[0].left[0]; break;
					case P2_NAME: a[i]=rounds[0].right[0]; break;
					case WINS: a[i]=wins; break;
					case LOSSES: a[i]=losses; break;
					case TIES: a[i]=ties; break;
					case WINRATE: a[i]=String(winrate)+"%"; break;
					case TURNS: a[i]=Math.round(avgTurns); break;
					case RESOURCES_L: a[i]=String(avgResourcesL)+"%"; break;
					case RESOURCES_R: a[i]=String(avgResourcesR)+"%"; break;
					case RANK: a[i]=String(rank); break;
					case PLAYER: a[i]=String(player); break;
					default: a[i]=""; break;
				}
			}
			return a;
		}
		
		public function getRoundTextBar(i:int):TournamentTextBar{
			return rounds[i].getTextBar(width);
		}
		
		public function lastRound():DuelResult{
			return rounds[rounds.length-1];
		}
		
		public function getMatchArray():Array{
			var _rounds:Array=new Array();
			for (var i:int=i;i<rounds.length;i+=1){
				_rounds.push(rounds[i].getResultArray());
			}
			return [rank,player,_rounds];
		}
		
		public static function fromMatchArray(a:Array):MatchResult{
			var m:MatchResult=new MatchResult();
			
			m.rank=a[0];
			m.player=a[1];
			var _rounds:Array=new Array();
			for (var i:int=0;i<a[2].length;i+=1){
				_rounds.push(DuelResult.fromResultArray(a[2][i]));
			}
			m.rounds=_rounds;
			m.deriveAllStats();
			return m;
		}
	}
}
