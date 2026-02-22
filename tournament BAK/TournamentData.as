package tournament {
	import utils.KongregateAPI;
	
	public class TournamentData {
			
			//REPLACE WITH FULL SET OF SIMULATED OPPONENTS
			
		public static var current
		public static var exhibitionTest:Array;
		
			//LIST OF CURRENT DUEL CHAMPIONS
		public static var championTest:Array=[["AlexD110",["Hero",60,1,[0,0,1,10,0,0,0,0,0,0,6,1,1,1,10,0,0,10,9,0,1,0,10,0,0,0,0,0,0,0,0,0,0,0,0],[[107,15,-1,-1,0,0],[90,15,-1,-1,0,0],[20,15,-1,-1,4,0],null,null,[31,15,12,6,0,0],[44,15,-1,10,0,0],[44,15,-1,10,0,0],[41,15,-1,10,0,0],[42,15,-1,10,0,0],[42,15,-1,20,0,0],[40,15,-1,21,0,0],[44,15,-1,22,0,0],null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[-1,-1,-1,-1,-1,-1]]],["j6u6fu0",["Olajuwon",60,1,[0,0,1,10,6,0,0,0,0,0,10,1,1,1,10,0,0,10,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0],[[107,15,-1,-1,0,0],[90,15,-1,-1,0,0],[20,15,-1,-1,4,0],null,null,[43,15,-1,10,0,0],[41,15,-1,10,0,0],[40,15,-1,10,0,0],[40,15,-1,30,0,0],[31,15,12,6,0,0],null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[-1,-1,-1,-1,-1,-1]]],["8z8z",["Carl",60,2,[0,0,0,0,0,0,0,0,10,10,0,0,10,10,0,10,0,1,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[84,15,-1,-1,0,0],[65,15,-1,-1,0,0],[17,15,-1,-1,2,0],null,null,[53,15,1,2,0,0],[53,15,1,2,0,0],[42,15,-1,25,0,0],[43,15,-1,25,0,0],[40,15,-1,30,0,0],[98,15,6,-1,0,0],[43,15,-1,14,0,0],[43,15,-1,14,0,0],[43,15,-1,22,0,0],[43,15,-1,22,0,0],null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[-1,-1,-1,-1,-1,1]]],["Shynygami",["All_Might",60,7,[0,0,0,0,0,0,0,0,0,0,10,9,10,10,0,10,0,1,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[[2,15,-1,17,0,0],[65,15,-1,-1,0,0],null,null,null,[53,15,1,2,0,0],[53,15,1,2,0,0],[43,15,-1,14,0,0],[42,15,-1,14,0,0],[42,15,-1,14,0,0],[84,15,-1,-1,0,0],[90,15,-1,-1,0,0],[41,15,-1,25,0,0],[42,15,-1,25,0,0],[53,15,1,2,0,0],null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[-1,-1,-1,-1,-1,1]]]];

		
		
			//DATA TO BE COMPILED IN THE LEAGUE
		public static var replayData:Array;
		
		public static var exhibitionChars:Array=[["AlexD110",["Hero",60,1,[0,0,1,10,0,0,0,0,0,0,6,1,1,1,10,0,0,10,9,0,1,0,10,0,0,0,0,0,0,0,0,0,0,0,0],[[107,15,-1,-1,0,0],[90,15,-1,-1,0,0],[20,15,-1,-1,0,0],null,null,[31,15,12,6,0,0],[44,15,-1,22,0,0],[44,15,-1,10,0,0],[41,15,-1,10,0,0],[42,15,-1,10,0,0],[42,15,-1,20,0,0],[40,15,-1,21,0,0],[44,15,-1,10,0,0],null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[-1,-1,-1,-1,-1,-1]]],["j6u6fu0",["Olajuwon",60,1,[0,0,1,10,6,0,0,0,0,0,10,1,1,1,10,0,0,10,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0],[[107,15,-1,-1,0,0],[90,15,-1,-1,0,0],[20,15,-1,-1,4,0],null,null,[43,15,-1,10,0,0],[41,15,-1,10,0,0],[40,15,-1,10,0,0],[40,15,-1,30,0,0],[31,15,12,6,0,0],null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],[-1,-1,-1,-1,-1,-1]]]];
		
		public static var currentRound:Array=[["AlexD110","j6u6fu0"],["8z8z","Shynygami"]];
		
			//CHARS MARKED ELIMINATED
		public static var eliminated:Array=["AlexD110","j6u6fu0","Shynygami","8z8z","Hirolla","murtagh98","dombeek","pizza87760","Ezrael","Sylithius","CECIII","Smokescreem","Brown1430","ethanolol","thepeasant","kadercito","Morgif","BinyaminWork","WantedOne","exib","Drysh","Selensija","lunaticleo","Dvangrey","Gizdor","zver8","rohpatem","headdeadkoala","sdasklfj","HustlinuGuys","dogorcat3","greatzar"];
		public static var champion:Array=["Shynygami","8z8z","AlexD110","CECIII","j6u6fu0","Hirolla","Sylithius","Brown1430","thepeasant","Selensija","lunaticleo","murtagh98","BinyaminWork","ethanolol","pizza87760","Ezrael","dombeek","rohpatem","Gizdor","WantedOne","Morgif","kadercito","greatzar","dogorcat3","Drysh","headdeadkoala","Smokescreem","exib","Dvangrey","HustlinuGuys","zver8","sdasklfj","bonez893","Gunjer","Coke222","lenard999","YidaZhu","Chumpchangebot","BinyaminTsadik","Exerci","RacShade","serrn","Eomry","nanashin","roaches","TheRelic","nn330303","louha2","Bernat","Forstolf","DoomBrutus","leedah","yagil","tiburon3000","Milaniona","Bahrul","Jegenrapo","Vdoi","Getsumei","lavavomit","miles12591","ltpiipii","danitois","Zygroth","Pacer_x","heybob","RavingJester","luluwutz","vedrik","iladriel","Nevod","Slamnation","YoTuesday","bbeaverkid","Hyborian","felixkam","KenryZ","bluy123","Dexstor","Fenopy99"];
		
		public static const ELIMINATED_START:int=1;
		
		public static function getExhibitionArray(_start:int=0,_length:int=-1):Array{
			var m:Array=new Array;
			for (var i:int=_start;(_length==-1 || i<_start+_length) && (i<exhibitionChars.length);i+=1){
				m.push(exhibitionChars[i][1]);
			}
			
			return m;
		}
		
		public static function isActive():Boolean{
			var _name:String=KongregateAPI.getName();
			for (var i:int=0;i<exhibitionChars.length;i+=1){
				if (exhibitionChars[i][0]==_name){
					 return true;
				}
			}
			return false;
		}
		
		public static function getEliminatedPosition():int{
			var _name:String=KongregateAPI.getName();
			for (var i:int=0;i<eliminated.length;i+=1){
				if (eliminated[i]==_name){
					 return ELIMINATED_START+i;
				}
			}
			return 0;
		}
		
		public static function isEliminated():Boolean{
			var _name:String=KongregateAPI.getName();
			for (var i:int=0;i<eliminated.length;i+=1){
				if (eliminated[i]==_name){
					 return true;
				}
			}
			return false;
		}
		
		public static function isChampion():Boolean{
			var _name:String=KongregateAPI.getName();
			for (var i:int=0;i<champion.length;i+=1){
				if (champion[i]==_name){
					 return true;
				}
			}
			return false;
		}
		
		public static function getOpponent():Array{
			var _name:String=KongregateAPI.getName();
			var _oppName:String;
			for (var i:int=0;i<currentRound.length;i+=1){
				if (currentRound[i][0]==_name){
					_oppName=currentRound[i][1];
					break;
				}else if (currentRound[i][1]==_name){
					_oppName=currentRound[i][0];
					break;
				}
			}
			if (_oppName==null) return null;
			
			for (i=0;i<exhibitionChars.length;i+=1){
				if (_oppName==exhibitionChars[i][0]){
					return exhibitionChars[i][1];
				}
			}
			
			return null;
		}
	}
}


