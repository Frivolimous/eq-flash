package utils {
  import utils.GameData;
  import ui.assets.AchievementDisplay;
  import sprites.BallHead;
  import skills.SkillData;

	public class AchieveData {
    public static const NUM_ACHIEVEMENTS:int = 28;

    public static const ACHIEVE_DEFT:int=0,
          ACHIEVE_CLEVER:int=1,
          ACHIEVE_UNGIFTED:int=2,
          ACHIEVE_STUDIOUS:int=3,
          ACHIEVE_ENLIGHTENED:int=4,
          ACHIEVE_POWERFUL:int=5,
          ACHIEVE_HOLY:int=6,
          ACHIEVE_WILD:int=7,
          ACHIEVE_NOBLE:int=8,
          // ACHIEVE_TURBO:int=9,
          ACHIEVE_ACOLYTE:int=10,
          ACHIEVE_PALADIN:int=11,
          ACHIEVE_ORDINARY_COSMO:int=12,
          ACHIEVE_DEFT_COSMO:int=13,
          ACHIEVE_CLEVER_COSMO:int=14,
          ACHIEVE_UNGIFTED_COSMO:int=15,
          ACHIEVE_STUDIOUS_COSMO:int=16,
          ACHIEVE_ENLIGHTENED_COSMO:int=17,
          ACHIEVE_POWERFUL_COSMO:int=18,
          ACHIEVE_HOLY_COSMO:int=19,
          ACHIEVE_WILD_COSMO:int=20,
          ACHIEVE_NOBLE_COSMO:int=21,
          ACHIEVE_ASCEND_50:int=22,
          ACHIEVE_ROGUE:int=23,
          ACHIEVE_FORGE:int=24,
          ACHIEVE_EPIC:int=25,
          ACHIEVE_BERSERKER:int=26,
          ACHIEVE_LEVEL_70:int=27;

    public static function checkAllAchievements():void {
      
    }

    public static function hasAchieved(i:int):Boolean{
			return GameData.achievements[i];
		}

    public static function achieve(i:int):void{
			if (i==313){
				for (var j:int=0;j<NUM_ACHIEVEMENTS;j+=1){
					if (!GameData.achievements[j]){
						GameData.achievements[j]=true;
						new AchievementDisplay(i);
					}
				}
				return;
			}
			
			if (!GameData.achievements[i]){
				GameData.achievements[i]=true;
        checkUnlockCosmetics(i);

				new AchievementDisplay(i);

				GameData.saveThis(GameData.ACHIEVEMENTS);
			}
		}

    public static function checkScore(score:int, value:int):void {
      if (score == GameData.SCORE_FURTHEST) {
        if (value>50) achieve(ACHIEVE_NOBLE);
        // if (value>100) achieve(ACHIEVE_TURBO);
        if (value>200) achieve(ACHIEVE_ACOLYTE);
        if (value>300) {achieve(ACHIEVE_PALADIN); achieve(ACHIEVE_FORGE);}
        if (value>400) achieve(ACHIEVE_EPIC);
        if (value>1000) achieve(ACHIEVE_LEVEL_70);
      } else if (score == GameData.SCORE_DEATHS) {
        if (value>0) achieve(ACHIEVE_UNGIFTED);
      } else if (score == GameData.SCORE_DUEL) {
        if (value>=50) achieve(ACHIEVE_POWERFUL);
        if (value>=800) achieve(ACHIEVE_ROGUE);

      } else if (score == GameData.SCORE_DAMAGE) {
        if (value>=100) achieve(ACHIEVE_DEFT);
      } else if (score == GameData.SCORE_ASCENDS) {
        if (value>=50) achieve(ACHIEVE_ASCEND_50);
      }
    }

    public static function checkFlag(flag:int):void {
      switch(flag) {
        case GameData.FLAG_TREASURE: achieve(ACHIEVE_CLEVER); new AchievementDisplay(315); break;
      }
    }

    public static function checkSkills(skillA: Array):void {
      if (skillA[i].level==SkillData.MAX_SKILL) achieve(ACHIEVE_ENLIGHTENED);
      var _numTrees:int=0;
      var _trees = SkillData.getTreeAssignment(skillA);
      for (var i:int=0;i<SkillData.NUM_TREES;i+=1){
        if (_trees[i]>0) _numTrees+=1;
      }
      if (_numTrees>=5) achieve(ACHIEVE_WILD);
    }

    public static function checkUnlockCosmetics(achieve:int):void {
      switch(achieve) {
        case ACHIEVE_ASCEND_50: addCosmetic(4, BallHead.DARK_HALO); GameData.saveThis(GameData.COSMETICS); break;
        case ACHIEVE_ORDINARY_COSMO:
          addCosmetic(1, BallHead.NORMAL); addCosmetic(2, BallHead.NORMAL); addCosmetic(4, BallHead.NONE);
          GameData.saveThis(GameData.COSMETICS); break;
        case ACHIEVE_DEFT_COSMO:
          addCosmetic(1,BallHead.SMALL); addCosmetic(2,BallHead.SMIRK);
          GameData.saveThis(GameData.COSMETICS); break;
        case ACHIEVE_CLEVER_COSMO:
          addCosmetic(1,BallHead.QUIZ); addCosmetic(2,BallHead.FROWN);
          GameData.saveThis(GameData.COSMETICS); break;
        case ACHIEVE_UNGIFTED_COSMO:
          addCosmetic(2,BallHead.GAPE); addCosmetic(4,BallHead.BAGS);
          GameData.saveThis(GameData.COSMETICS); break;
        case ACHIEVE_STUDIOUS_COSMO:
          addCosmetic(2,BallHead.HMM); addCosmetic(4,BallHead.GLASSES);
          GameData.saveThis(GameData.COSMETICS); break;
        case ACHIEVE_ENLIGHTENED_COSMO:
          addCosmetic(1,BallHead.BRIGHT); addCosmetic(2,BallHead.SMILE);
          GameData.saveThis(GameData.COSMETICS); break;
        case ACHIEVE_POWERFUL_COSMO:
          addCosmetic(1,BallHead.FURROW); addCosmetic(2,BallHead.SNARL); addCosmetic(4,BallHead.CHIN); 
          GameData.saveThis(GameData.COSMETICS); break;
        case ACHIEVE_HOLY_COSMO:
          addCosmetic(1,BallHead.SQUINT); addCosmetic(2,BallHead.PURSED); 
          GameData.saveThis(GameData.COSMETICS); break;
        case ACHIEVE_WILD_COSMO:
          addCosmetic(1,BallHead.CRAZY); addCosmetic(2,BallHead.TONGUE); 
          GameData.saveThis(GameData.COSMETICS); break;
        case ACHIEVE_NOBLE_COSMO:
          addCosmetic(1,BallHead.UPWARD); addCosmetic(1,BallHead.UPFROWN); addCosmetic(4,BallHead.GOATEE); 
          GameData.saveThis(GameData.COSMETICS); break;
      }
    }

    public static function unlockDLCCosmetics():void {
      addCosmetic(1,18); //Acolyte
      addCosmetic(4,8); //Paladin
      addCosmetic(1,23); addCosmetic(3,8); addCosmetic(4,26); //Rogue
      addCosmetic(3,7); addCosmetic(4,25); addCosmetic(4,27); //Ranger
      addCosmetic(1,22); addCosmetic(2,29); addCosmetic(3,6); //Hair0
      addCosmetic(2,27); addCosmetic(3,4); addCosmetic(4,10); //Hair1
      addCosmetic(1,21); addCosmetic(2,28); addCosmetic(3,5); //Hair2
      addCosmetic(1,20); addCosmetic(2,26); addCosmetic(3,3); addCosmetic(4,9); //Hair3
      addCosmetic(5,1);
    }

    public static function addCosmetic(_type:int,index:int):void {
      if (!GameData.hasCosmetic(_type,index)){
        GameData.cosmetics[_type].push(index);
      }
    }
  }
}