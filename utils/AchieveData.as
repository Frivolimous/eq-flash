package utils {
  import utils.GameData;
  import ui.assets.AchievementDisplay;
  import sprites.BallHead;
  import skills.SkillData;
  import items.ItemData;

	public class AchieveData {
    public static const TUTORIAL_COMPLETE:int=0,
          DAMAGE_100:int=1, //talent deft
          DAMAGE_1000:int=2,
          DEATHS_1:int=3, //talent ungifted
          DEATHS_100:int=4,
          FIND_TREASURE:int=5, //talent clever
          BUY_ITEM:int=6,
          READ_BOOK:int=7, //talent studious
          MAX_SKILL:int=8, //talent enlightened
          SKILL_5_TREES:int=9, //talent wild
          ZONE_25:int=10,
          ZONE_50:int=11, //talent noble
          ZONE_75:int=12,
          ZONE_100:int=13, //prestige unlocked
          ZONE_200:int=14, //class acolyte
          ZONE_300:int=15, //feature forge
          ZONE_400:int=16, //feature epic
          ZONE_600:int=17,
          ZONE_800:int=18,
          ZONE_1000:int=19, //feature lvl70
          ZONE_2000:int=20,
          DUEL_50:int=21, //talent powerful
          DUEL_100:int=22, //class rogue
          DUEL_250:int=23, //class barbarian?
          DUEL_500:int=24,
          DUEL_800:int=25,
          DUEL_1000:int=26,
          DUEL_1500:int=27,
          ASCEND_1:int=28,
          ASCEND_10:int=29,
          ASCEND_25:int=30,
          ASCEND_50:int=31, //cosmetic dark halo
          BUY_MYTHIC:int=32,//talent holy
          UPGRADE_ITEM_1:int=33,
          UPGRADE_ITEM_15:int=34,
          CRAFT_ITEM_1:int=35,// class paladin
          LEVEL_60_ORDINARY:int=36,
          LEVEL_60_DEFT:int=37,
          LEVEL_60_CLEVER:int=38,
          LEVEL_60_UNGIFTED:int=39,
          LEVEL_60_STUDIOUS:int=40,
          LEVEL_60_ENLIGHTENED:int=41,
          LEVEL_60_POWERFUL:int=42,
          LEVEL_60_HOLY:int=43,
          LEVEL_60_WILD:int=44,
          LEVEL_60_NOBLE:int=45,
          KILL_200:int=46,
          KILL_2000:int=47,
          KILL_20K:int=48,
          KILL_200K:int=49,
          KILL_2M:int=50,
          REACH_LEVEL_70:int=51,
          EPIC_ZONE_2:int=52,
          EPIC_ZONE_10:int=53,
          EPIC_ZONE_100:int=54,
          ARTIFACTS_1:int=55,
          ARTIFACTS_10:int=56,
          ARTIFACTS_40:int=57,
          VISIT_GRAVE:int=58,
          COMPLETE_ALL:int=59,//XX
          NUM_ACHIEVEMENTS:int=60;

    public static const TALENT_ACHIEVEMENTS:Array=[1,5,3,7,8,20,31,9,11,12];

    public static const ACHIEVE_DEFS:Array=[
      {steamName: "TUTORIAL_COMPLETE", displayText: "Tutorial Complete!", awardDesc: "You made it through the entire tutorial!"},
      {steamName: "DAMAGE_100", displayText: "Talent Unlock: Deft", awardDesc: "You dealt 100 damage in a single blow!\n\nThis achievement unlocked the Deft talent."}, //
      {steamName: "DAMAGE_1000", displayText: "1,000 Damage Dealt!", awardDesc: "You dealt a massive 1,000 damage! You may be the strongest you can ever get now."},
      {steamName: "DEATHS_1", displayText: "Talent Unlock: Ungifted", awardDesc: "You died. Congratulations..?\n\nThis achievement unlocked the Ungifted Talent."},
      {steamName: "DEATHS_100", displayText: "Secret Achievement: DEATH", awardDesc: "You died 100 times. This is a secret achievement, because I don't actually want people to do this on purpose."},
      {steamName: "FIND_TREASURE", displayText: "Talent Unlock: Clever", awardDesc: "OMG you found the secret treasure! Was it hard to find?\n\nThis achievement unlocked the Clever Talent."},
      {steamName: "BUY_ITEM", displayText: "Purchase any item", awardDesc: "You bought something from the shop! I think that deserves an award!"},//XX
      {steamName: "READ_BOOK", displayText: "Talent Unlock: Studious", awardDesc: "Wow! You actually read one of my books! <3 err... i mean... amazing reading!\n\nThis achievement unlocked the Studious Talent."},
      {steamName: "MAX_SKILL", displayText: "Talent Unlock: Enlightened", awardDesc: "You leveled up a skill to the max!\n\nThis achievement unlocked the Enlightened Talent."},
      {steamName: "SKILL_5_TREES", displayText: "Talent Unlock: Wild", awardDesc: "You placed 1 skill point in 5 different trees. Make up your mind!\n\nThis achievement unlocked the Wild Talent."},
      {steamName: "ZONE_25", displayText: "Zone Complete: 25", awardDesc: "Woohoo! You made it past the second Shadow Minion! Keep going, more prizes await!"},
      {steamName: "ZONE_50", displayText: "Talent Unlocked: Noble", awardDesc: "Amazing, you made it to Zone 50! That's halfway to ascension!\n\nThis achievement unlocked the Noble Talent."},
      {steamName: "ZONE_75", displayText: "Zone Complete: 75", awardDesc: "You have surpassed zone 75! Keep going to 100 to unlock Ascension!"},
      {steamName: "ZONE_100", displayText: "Feature Unlock: Ascension", awardDesc: "You made it to Zone 100 and defeated the SHADOW KING!\n\nThis achievement unlocked Ascension! Go to the Temple to ascend and unlock powerful artifacts!"},
      {steamName: "ZONE_200", displayText: "Class Unlock: Acolyte", awardDesc: "Wow! You made it to Zone 200! that's like... super far!\n\nThis achievement unlocked the Acolyte Skill Tree."},
      {steamName: "ZONE_300", displayText: "Building Unlocked: Mystic Forge", awardDesc: "You made it to Zone 300!\n\nThis achievement unlocked the Mystic Forge in town."},
      {steamName: "ZONE_400", displayText: "Building Unlocked: Epic Zone!", awardDesc: "You made it all the way to Zone 400! I can't believe you made it this far... now the REAL journey begins!\n\nThis achievement unlocked the Epic Zone in town."},
      {steamName: "ZONE_600", displayText: "Zone Completed: 600", awardDesc: "If you can believe it, the game was originally made expecting Level 100 to be the farthest possible. You have gone 6x into the impossible!"},
      {steamName: "ZONE_800", displayText: "Zone Completed: 800", awardDesc: "Nothing rhymes with 800! Except 'Bait Hunt Dread'. Ok whatever, you do better!"},
      {steamName: "ZONE_1000", displayText: "Level 70 Unlocked!", awardDesc: "Wow, you have officially made it farther than I ever thought possible! As a reward... you can go further!\n\nThis achievement unlocked Level 70."},
      {steamName: "ZONE_2000", displayText: "Zone Completed: 2000", awardDesc: "OK that's it! you made it. Stop playing now, there's nothing else to do. Like literally... that's it."},
      {steamName: "DUEL_50", displayText: "Talent Unlock: Powerful", awardDesc: "You have defeated all of the Arena Opponents! But wait... now they come back STRONGER!\n\nThis achievement unlocked the Powerful Talent."},
      {steamName: "DUEL_100", displayText: "Class Unlock: Rogue", awardDesc: "You have defeated the second set of opponents! But wait, there's more?!?\n\nThis achievement unlocked the Rogue Skill Tree"},
      {steamName: "DUEL_250", displayText: "Arena Level: 250", awardDesc: "You have defeated the level 250 opponents! Go you!"},
      {steamName: "DUEL_500", displayText: "Arena Level: 500", awardDesc: "So you probably know this by now, but the arena is a great place to make gold. You have defeated level 500, which is like... 100 guys in one ascension!"},
      {steamName: "DUEL_800", displayText: "Arena Level: 800", awardDesc: "I'm starting to run out of ways to say 'Good Job!' wait - - i never tried this one: GOOD JOB!"},
      {steamName: "DUEL_1000", displayText: "Arena Level: 1000", awardDesc: "You have defeated a Level 1,000 Yermiyah. That's the 20th incarnation! That means you have killed me at least 20 times."},
      {steamName: "DUEL_1500", displayText: "Arena Level: 1500", awardDesc: "OK, that's it. You've killed me like 30 times. You got the last Arena achievement, so go do something else now!"},
      {steamName: "ASCEND_1", displayText: "You have ascended", awardDesc: "Rise from your grave! You have ascended and returned... with more power than ever before!"},
      {steamName: "ASCEND_10", displayText: "Ascensions: 10", awardDesc: "You have ascended 10 times and all you got was this lousy award."},
      {steamName: "ASCEND_25", displayText: "Ascensions: 25", awardDesc: "You have ascended a grand total of 25 times! Or more, if you kept this award around and are looking at it later. Why would you do that? Sell it! Get your Power Tokens already!"},
      {steamName: "ASCEND_50", displayText: "Cosmetic Unlocked: Dark Halo", awardDesc: "You have ascended 50 times and earned yourself the DARK HALO. Because you ascended a dark amount of times. It makes sense, just don't think about it too much."},
      {steamName: "BUY_MYTHIC", displayText: "Talent Unlocked: Holy", awardDesc: "You have purchased an amazing Mythic item from the golden temple, and proved your devotion.\n\nThis achievement unlocked the Holy Talent."},//XX talent holy
      {steamName: "UPGRADE_ITEM_1", displayText: "Item Upgraded", awardDesc: "Congratulations, you now know how to upgrade an item! You'll be doing this a lot, I guarantee it."},//XX
      {steamName: "UPGRADE_ITEM_15", displayText: "Item Upgraded 15", awardDesc: "Congratulations, you upgraded an item up to level 15! That's max level btw (for now...)"},//XX
      {steamName: "CRAFT_ITEM_1", displayText: "Class Unlock: Paladin", awardDesc: "You have crafted an item at the Mythic Forge! I'm so proud of you!\n\nThis achievement unlocked the Paladin Skill Tree."},//XX class paladin
      {steamName: "LEVEL_60_ORDINARY", displayText: "Cosmetics Unlocked: Ordinary", awardDesc: "You got to level 60 with an Ordinary Hero! Why would you do that? The others are all way more interesting.\n\nThis achievement unlocked Ordinary Cosmetics."},
      {steamName: "LEVEL_60_DEFT", displayText: "Cosmetics Unlocked: Deft", awardDesc: "You got to level 60 with a Deft Hero! Did you do it quickly? Get It?!? Ah you don't know good jokes.\n\nThis achievement unlocked Deft Cosmetics."},
      {steamName: "LEVEL_60_CLEVER", displayText: "Cosmetics Unlocked: Clever", awardDesc: "You got to level 60 with a Clever Hero! Like the talent. I bet your build was pretty plain though.\n\nThis achievement unlocked Clever Cosmetics."},
      {steamName: "LEVEL_60_UNGIFTED", displayText: "Cosmetics Unlocked: Ungifted", awardDesc: "You got to level 60 as an Ungifted. You probably miss using magic, don't you.\n\nThis achievement unlocked Ungifted Cosmetics."},
      {steamName: "LEVEL_60_STUDIOUS", displayText: "Cosmetics Unlocked: Studious", awardDesc: "You got to level 60 as a Studious Hero. You probably went grenade build, right? Alchemist Pots or Classic Bomb? Or Rose? That's a good one too.\n\nThis achievement unlocked Studious Cosmetics."},
      {steamName: "LEVEL_60_ENLIGHTENED", displayText: "Cosmetics Unlocked: Enlightened", awardDesc: "You got to Level 60 as an Enlightened! Now everyone can be enlightened! Or at least look that way...\n\nThis achievement unlocked Enlightened Cosmetics."},
      {steamName: "LEVEL_60_POWERFUL", displayText: "Cosmetics Unlocked: Powerful", awardDesc: "You got to Level 60 as a Powerful! This is probably your first or second, right? Everyone likes the bonus damage.\n\nThis achievement unlocked Powerful Cosmetics."},
      {steamName: "LEVEL_60_HOLY", displayText: "Cosmetics Unlocked: Holy", awardDesc: "You got to Level 60 with Holiness. Just wait until you unlock the Paladin Skill Tree! You'll def wanna do it again!\n\nThis achievement unlocked Holy Cosmetics."},
      {steamName: "LEVEL_60_WILD", displayText: "Cosmetics Unlocked: Wild", awardDesc: "You got to Level 60 with a WiLd tALeNt! Did you actually notice a difference?\n\nThis achievement unlocked Wild Cosmetics."},
      {steamName: "LEVEL_60_NOBLE", displayText: "Cosmetics Unlocked: Noble", awardDesc: "You got to Level 60 with a Noble Hero! Did you figure out how to min/max this guy? You can't really do it eh?\n\nThis achievement unlocked Noble Cosmetics."},
      {steamName: "KILL_200", displayText: "Monsters Killed: 200", awardDesc: "You got this award for killing 200 baddies. Now go kill more!"},
      {steamName: "KILL_2000", displayText: "Monsters Killed: 2000", awardDesc: "You got this award for killing 2,000 baddies. That's like Zone 67 right? No, you probably died a bunch so got this earlier.."},
      {steamName: "KILL_20K", displayText: "Monsters Killed: 20,000", awardDesc: "You got this award for killing TWENTY THOUSAND MONSTERS! That's pretty good! But there are a lot more out there!"},
      {steamName: "KILL_200K", displayText: "Monsters Killed: 200,000", awardDesc: "You have officially killed over 200,000 monsters. That's a lot!"},
      {steamName: "KILL_2M", displayText: "Monsters Killed: 2,000,000", awardDesc: "You have killed over two million monsters. This definitely counts as genocide!"},
      {steamName: "REACH_LEVEL_70", displayText: "Level Reached: 70", awardDesc: "You reached level 70! Bet you didn't think this was possible, did you? Nah, you did... admit it, you were scanning the achievements page."},
      {steamName: "EPIC_ZONE_2", displayText: "Epic Zone: 2", awardDesc: "OK cool, so now you know what the epic zone is, because you got to Zone 3. What do you think? Up for the challenge?"},
      {steamName: "EPIC_ZONE_10", displayText: "Epic Zone: 10", awardDesc: "You got this award for completing Epic Zone 10. Don't stick with just 1 character, diversify and strive! That's the only way to push your limits."},
      {steamName: "EPIC_ZONE_100", displayText: "Epic Zone: 100", awardDesc: "You officially made it past Epic Zone 100. You reached the endgame of the endgame. And no, there are no resets sorry... just gotta try harder to push one more!"},
      {steamName: "ARTIFACTS_1", displayText: "Artifacts Unlocked: 1", awardDesc: "You have unlocked a potent Artifact! This means you have officially joined the ranks of the Ascended Heroes!"},
      {steamName: "ARTIFACTS_10", displayText: "Artifacts Unlocked: 10", awardDesc: "Your collection of artifacts have grown beyond the number 10! Your epicness has increased."},
      {steamName: "ARTIFACTS_40", displayText: "Artifacts Unlocked: 40", awardDesc: "Wow, you got them all! You unlocked all 40 of the artifacts that exist! Now, how many have you actually used? Try out Blood of the Minotaur, I promise it's better than it looks!"},
      {steamName: "VISIT_GRAVE", displayText: "Visited Gars", awardDesc: "Alas, poor Gars! I knew him. A caster of infinite power, with most excellent art. He killed a thousand foes and now, how sad to see him gone."},
      {steamName: "COMPLETE_ALL", displayText: "Completionist", awardDesc: "You have officially completed all of the achievements! Congratulations!\n\nDid you save all of your other Awards as well? Because if you did, you unlock a super secret extra bonus cosmetic! It's super awesome and epic I swear! And yes, it's totally real! Honest it is!"},//XX
    ]

    public static function checkCompleteAll():void {
      for (var i=0;i<COMPLETE_ALL;i+=1){
        if (GameData.achievements[i]==false) return false;
      }

      achieve(COMPLETE_ALL);
    }

    public static function hasAchieved(i:int):Boolean{
			return GameData.achievements[i];
		}

    public static function achieve(i:int):void{
			if (i==313){
				for (var j:int=0;j<NUM_ACHIEVEMENTS;j+=1){
					if (!GameData.achievements[j]){
						GameData.achievements[j]=true;
            checkUnlockCosmetics(i);
						new AchievementDisplay(i);            
					}
				}
				return;
			}
			
			if (!GameData.achievements[i]){
				GameData.achievements[i]=true;
        checkUnlockCosmetics(i);
				new AchievementDisplay(i);

				var _item = ItemData.enchantItem(ItemData.spawnItem(1, 118), i);
				Facade.gameM.addItemFallbackOverflow(_item);
        
        Facade.steamAPI.unlockAchievement(ACHIEVE_DEFS[i].steamName);

				GameData.saveThis(GameData.ACHIEVEMENTS);

        checkCompleteAll();
			}
		}

    public static function checkScore(score:int, value:int):void {
      if (score == GameData.SCORE_FURTHEST) {
          if (value>25) achieve(ZONE_25);
          if (value>50) achieve(ZONE_50);
          if (value>75) achieve(ZONE_75);
          if (value>100) achieve(ZONE_100);
          if (value>200) achieve(ZONE_200);
          if (value>300) achieve(ZONE_300);
          if (value>400) achieve(ZONE_400);
          if (value>600) achieve(ZONE_600);
          if (value>800) achieve(ZONE_800);
          if (value>1000) achieve(ZONE_1000);
          if (value>2000) achieve(ZONE_2000);
          Facade.steamAPI.setStatInt("zone", value);
      } else if (score == GameData.SCORE_DEATHS) {
        if (value>=1) achieve(DEATHS_1);
        if (value>=100) achieve(DEATHS_100);
      } else if (score == GameData.SCORE_DUEL) {
          if (value>=50) achieve(DUEL_50);
          if (value>=100) achieve(DUEL_100);
          if (value>=250) achieve(DUEL_250);
          if (value>=500) achieve(DUEL_500);
          if (value>=800) achieve(DUEL_800);
          if (value>=1000) achieve(DUEL_1000);
          if (value>=1500) achieve(DUEL_1500);
          Facade.steamAPI.setStatInt("duel", value);
      } else if (score == GameData.SCORE_DAMAGE) {
        if (value>=100) achieve(DAMAGE_100);
        if (value>=1000) achieve(DAMAGE_1000);
      } else if (score == GameData.SCORE_ASCENDS) {
        if (value>=1) achieve(ASCEND_1);
        if (value>=10) achieve(ASCEND_10);
        if (value>=25) achieve(ASCEND_25);
        if (value>=50) achieve(ASCEND_50);
        Facade.steamAPI.setStatInt("ascend", value);
      } else if (score == GameData.SCORE_KILLS) {
        if (value>=200) achieve(KILL_200);
        if (value>=2000) achieve(KILL_2000);
        if (value>=20000) achieve(KILL_20K);
        if (value>=200000) achieve(KILL_200K);
        if (value>=2000000) achieve(KILL_2M);
        Facade.steamAPI.setStatInt("kill", value);
      } else if (score == GameData.SCORE_EPICS) {
        if (value>=2) achieve(EPIC_ZONE_2);
        if (value>=10) achieve(EPIC_ZONE_10);
        if (value>=100) achieve(EPIC_ZONE_100);
        Facade.steamAPI.setStatInt("epic", value);
      } else if (score == GameData.SCORE_LEVEL) {
        if (value>=70) achieve(REACH_LEVEL_70);
      }
    }

    public static function checkFlag(flag:int):void {
      switch(flag) {
        case GameData.FLAG_TUTORIAL: achieve(TUTORIAL_COMPLETE); break;
        case GameData.FLAG_TREASURE: achieve(FIND_TREASURE); new AchievementDisplay(315); break;
      }
    }

    public static function checkSkills(skillA: Array):void {
      var _numTrees:int=0;
      var _trees = SkillData.getTreeAssignment(skillA);
      for (var i:int=0;i<SkillData.NUM_TREES;i+=1){
        if (_trees[i]>0) _numTrees+=1;
      }
      if (_numTrees>=5) achieve(SKILL_5_TREES);

      for (i=0;i<skillA.length;i+=1){
        if (skillA[i].level==SkillData.MAX_SKILL) {
          achieve(MAX_SKILL);
          return;
        }
      }
    }

    public static function checkUnlockCosmetics(achieve:int):void {
      switch(achieve) {
        case ASCEND_50: addCosmetic(4, BallHead.DARK_HALO); GameData.saveThis(GameData.COSMETICS); break;
        case LEVEL_60_ORDINARY:
          addCosmetic(1, BallHead.NORMAL); addCosmetic(2, BallHead.NORMAL); addCosmetic(4, BallHead.NONE);
          GameData.saveThis(GameData.COSMETICS); break;
        case LEVEL_60_DEFT:
          addCosmetic(1,BallHead.SMALL); addCosmetic(2,BallHead.SMIRK);
          GameData.saveThis(GameData.COSMETICS); break;
        case LEVEL_60_CLEVER:
          addCosmetic(1,BallHead.QUIZ); addCosmetic(2,BallHead.FROWN);
          GameData.saveThis(GameData.COSMETICS); break;
        case LEVEL_60_UNGIFTED:
          addCosmetic(2,BallHead.GAPE); addCosmetic(4,BallHead.BAGS);
          GameData.saveThis(GameData.COSMETICS); break;
        case LEVEL_60_STUDIOUS:
          addCosmetic(2,BallHead.HMM); addCosmetic(4,BallHead.GLASSES);
          GameData.saveThis(GameData.COSMETICS); break;
        case LEVEL_60_ENLIGHTENED:
          addCosmetic(1,BallHead.BRIGHT); addCosmetic(2,BallHead.SMILE);
          GameData.saveThis(GameData.COSMETICS); break;
        case LEVEL_60_POWERFUL:
          addCosmetic(1,BallHead.FURROW); addCosmetic(2,BallHead.SNARL); addCosmetic(4,BallHead.CHIN); 
          GameData.saveThis(GameData.COSMETICS); break;
        case LEVEL_60_HOLY:
          addCosmetic(1,BallHead.SQUINT); addCosmetic(2,BallHead.PURSED); 
          GameData.saveThis(GameData.COSMETICS); break;
        case LEVEL_60_WILD:
          addCosmetic(1,BallHead.CRAZY); addCosmetic(2,BallHead.TONGUE); 
          GameData.saveThis(GameData.COSMETICS); break;
        case LEVEL_60_NOBLE:
          addCosmetic(1,BallHead.UPWARD); addCosmetic(1,BallHead.UPFROWN); addCosmetic(4,BallHead.GOATEE); 
          GameData.saveThis(GameData.COSMETICS); break;
      }
    }

    public static function checkTalentLevel(level:int,talent:int):void {
      if (level>=60){
        achieve(talent+LEVEL_60_ORDINARY);
      }
    }

    public static function checkArtifactsOwned(artifacts:Array):void {
      var _numUnlocked:int=0;
      for (var i=0;i,artifacts.length;i++){
        if (artifacts[i]>-1){
          _numUnlocked+=1;
        }
      }

      if (_numUnlocked>=1) achieve(ARTIFACTS_1);
      if (_numUnlocked>=10) achieve(ARTIFACTS_10);
      if (_numUnlocked>=40) achieve(ARTIFACTS_40);
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
      GameData.saveThis(GameData.COSMETICS);
    }

    public static function addCosmetic(_type:int,index:int):void {
      if (!GameData.hasCosmetic(_type,index)){
        GameData.cosmetics[_type].push(index);
      }
    }
  }
}