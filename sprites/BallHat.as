package sprites {
	import skills.SkillData;
	import flash.display.MovieClip;
	
	public class BallHat extends MovieClip{
		
					 //Body
		static const NONE:int=10,
					 HEADBAND:int=2,
					 FEDORA:int=3,
					 BOWL:int=4,
					 NOSECAP:int=5,
					 BUCKET:int=6,
					 HORNED:int=7,
					 ROMAN:int=8,
					 VIKING:int=9,
					 KNIGHT:int=1,
					 WIZARD:int=11,
					 ORC_HORNS:int=12,
					 SHELL_WREATH:int=13,
					 FLOWER:int=14,
					 
					 KABUTO:int=15,
					 HOOD:int=16,
					 LINK:int=17,
					 MARIO:int=18,
					 BOXING:int=19,
					 TURBAN:int=20,
					 CROWN:int=21,
					 NARUTO:int=22;

		public function fromItem(i:int){
			switch(i){
				case 9: setHat(HEADBAND); break;
				case 10: setHat(WIZARD); break;
				case 11: setHat(FEDORA); break;
				case 12: setHat(BUCKET); break;
				case 13: setHat(KNIGHT); break;
				case 64: setHat(KABUTO); break;
				case 65: setHat(HOOD); break;
				case 66: setHat(BOXING); break;
				case 67: setHat(MARIO); break;
				case 68: setHat(LINK); break;
				case 69: setHat(TURBAN); break;
				case 70: setHat(CROWN); break;
				case 71: setHat(NARUTO); break;
				case 91: setHat(23); break;
				case 90: setHat(24); break;
				case 89: setHat(25); break;
				case 88: setHat(26); break;
				case 101: setHat(28); break;
				case 102: setHat(30); break;
				case 103: setHat(29); break;
				case 104: setHat(27); break;
				case 117: setHat(31); break;
				case 115: setHat(32); break;
				case 110: setHat(33); break;
				case 121: setHat(35); break;
				case 122: setHat(36); break;
				case 123: setHat(37); break;
				case 124: setHat(38); break;
				case 130: setHat(39); break;
				case 133: setHat(40); break;
				case 147: setHat(41); break;
				case 148: setHat(42); break;
				
				default: setHat(NONE); break;
			}
				
		}
		
		public function fromEnemy(s:String){//trace(i,EnemyData.WARLOCK);
			switch(s){
				case EnemyData.FIGHTER: setHat(VIKING); break;
				case EnemyData.SHAMAN: setHat(SHELL_WREATH); break;
				case EnemyData.BRUTE: setHat(NONE); break;
				case EnemyData.CHIEF: setHat(ORC_HORNS); break;
				case EnemyData.ALCHEMIST: setHat(FLOWER); break;
				case EnemyData.SKELETON: setHat(NOSECAP); break;
				default: setHat();
			}
		}
		
		public function fromTalent(i:int){
			switch(i){
				case SkillData.BRAVE: setHat(ROMAN); break;
				case SkillData.IRON: setHat(BOWL); break;
				case SkillData.SAVIOR: setHat(34); break;
							/*HOBO:int=10,
							BRAVE:int=11,
							WHITE:int=12,
							HUNTER:int=13,
							GRENADIER:int=14,
							IRON:int=15,
							SWIFT:int=16,
							PEASANT:int=17,
							DABBLER:int=18,
							WEAVER:int=19;*/
			}
		}
		
		public function setHat(_hat:int=10){
			gotoAndStop(_hat);
		}
	}
	
}
