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
				new AchievementDisplay(i);
				GameData.achievements[i]=true;
				if (i>=ACHIEVE_ORDINARY_COSMO && i<=ACHIEVE_NOBLE_COSMO){
					i-=ACHIEVE_ORDINARY_COSMO;
					BallHead.setTalentCosmetics(GameData.cosmetics,i);
					GameData.saveThis(GameData.COSMETICS);
				}else if (i==ACHIEVE_ASCEND_50){
					GameData.cosmetics[4].push(BallHead.DARK_HALO);
					GameData.saveThis(GameData.COSMETICS);
				}
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
  }
}