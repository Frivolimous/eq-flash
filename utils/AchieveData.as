package utils {
  import utils.GameData;
  import ui.assets.AchievementDisplay;
  import sprites.BallHead;
  import skills.SkillData;

	public class AchieveData {
    public static const TUTORIAL_COMPLETE:int=0,
          DAMAGE_100:int=1, //talent deft
          DAMAGE_1000:int=2,
          DEATHS_1:int=3, //talent ungifted
          DEATHS_100:int=4,
          FIND_TREASURE:int=5, //talent clever
          BUY_ITEM:int=6,//XX
          READ_BOOK:int=7, //talent studious
          MAX_SKILL:int=8, //talent enlightened
          SKILL_5_TREES:int=9, //talent wild
          ZONE_25:int=10,
          ZONE_50:int=11, //talent noble
          ZONE_100:int=12, //prestige unlocked
          ZONE_200:int=13, //class acolyte
          ZONE_300:int=14, //feature forge
          ZONE_400:int=15, //feature epic
          ZONE_600:int=16,
          ZONE_800:int=17,
          ZONE_1000:int=18, //feature lvl70
          ZONE_2000:int=19,
          DUEL_50:int=20, //talent powerful
          DUEL_100:int=21, //class rogue
          DUEL_250:int=22, //class barbarian?
          DUEL_500:int=23,
          DUEL_800:int=24,
          DUEL_1000:int=25,
          DUEL_1500:int=26,
          ASCEND_1:int=27,
          ASCEND_10:int=28,
          ASCEND_25:int=29,
          ASCEND_50:int=30, //cosmetic dark halo
          BUY_MYTHIC:int=31,//talent holy XX
          SALVAGE_MYTHIC_1:int=32,//XX
          HAVE_MYTHIC_10:int=33,//XX
          CRAFT_ITEM_1:int=34,//XX class paladin
          ORDINARY_LEVEL_60:int=35,
          DEFT_LEVEL_60:int=36,
          CLEVER_LEVEL_60:int=37,
          UNGIFTED_LEVEL_60:int=38,
          STUDIOUS_LEVEL_60:int=39,
          ENLIGHTENED_LEVEL_60:int=40,
          POWERFUL_LEVEL_60:int=41,
          HOLY_LEVEL_60:int=42,
          WILD_LEVEL_60:int=43,
          NOBLE_LEVEL_60:int=44,
          KILL_10:int=45,
          KILL_100:int=46,
          KILL_10K:int=47,
          KILL_100K:int=48,
          KILL_1M:int=49,
          REACH_LEVEL_70:int=50,
          EPIC_ZONE_2:int=51,
          EPIC_ZONE_10:int=52,
          EPIC_ZONE_100:int=53,
          ARTIFACTS_1:int=54,
          ARTIFACTS_10:int=55,
          ARTIFACTS_40:int=56,
          COMPLETE_ALL:int=57,//XX
          NUM_ACHIEVEMENTS:int=58;

    public static const TALENT_ACHIEVEMENTS:Array=[1,5,3,7,8,20,31,9,11,100];

    public static const ACHIEVE_DEFS:Array=[
      {displayText: "Tutorial Complete!", awardDesc: "You made it through the entire tutorial!"},
      {displayText: "Talent Unlock: Deft", awardDesc: "You dealt 100 damage in a single blow!\n\nThis achievement unlocked the Deft talent."}, //talent deft
      {displayText: "1,000 Damage Dealt!", awardDesc: "You dealt a massive 1,000 damage! You may be the strongest you can ever get now."},
      {displayText: "Talent Unlock: ungifted", awardDesc: "You died. Congratulations..?\n\nThis achievement unlocked the Ungifted Talent."}, //talent ungifted
      {displayText: "Secret Achievement: DEATH", awardDesc: "You died 100 times. This is a secret achievement, because I don't actually want people to do this on purpose."},
      {displayText: "Talent Unlock: Clever", awardDesc: "OMG you found the secret treasure! Was it hard to find?\n\nThis achievement unlocked the Clever Talent."}, //talent clever
      {displayText: "Purchase any item", awardDesc: "You bought something from the shop! I think that deserves an award!"},//XX
      {displayText: "Talent Unlock: Studious", awardDesc: "Wow! You actually read one of my books! <3 err... i mean... amazing reading!\n\nThis achievement unlocked the Studious Talent."}, //talent studious
      {displayText: "Talent Unlock: Enlightened", awardDesc: "You leveled up a skill to the max!\n\nThis achievement unlocked the Enlightened Talent."}, //talent enlightened
      {displayText: "Talent Unlock: Wild", awardDesc: "You placed 1 skill point in 5 different trees. Make up your mind!\n\nThis achievement unlocked the Wild Talent."}, //talent wild
      {displayText: "Zone Complete: 25", awardDesc: "Woohoo! You made it past the second Shadow Minion! Keep going, more prizes await!"},
      {displayText: "Talent Unlocked: Noble", awardDesc: "Amazing, you made it to Zone 50! That's halfway to ascension!\n\nThis achievement unlocked the Noble Talent."}, //talent noble
      {displayText: "Feature Unlock: Ascension", awardDesc: "This achievement unlocked Ascension! Go to the Temple to ascend and unlock powerful artifacts!"}, //prestige unlocked
      {displayText: "Class Unlock: Acolyte", awardDesc: "Wow! You made it to Zone 200! that's like... super far!\n\nThis achievement unlocked the Acolyte Skill Tree."}, //class acolyte
      {displayText: "Building Unlocked: Mystic Forge", awardDesc: "You made it to Zone 300!\n\nThis achievement unlocked the Mystic Forge in town."}, //feature forge
      {displayText: "Building Unlocked: Epic Zone!", awardDesc: "You made it all the way to Zone 400! I can't believe you made it this far... now the REAL journey begins!\n\nThis achievement unlocked the Epic Zone in town."}, //feature epic
      {displayText: "Zone Completed: 600", awardDesc: "If you can believe it, the game was originally made expecting Level 100 to be the farthest possible. You have gone 6x into the impossible!"},
      {displayText: "Zone Completed: 800", awardDesc: "Nothing rhymes with 800! Except 'Bait Hunt Dread'. Ok whatever, you do better!"},
      {displayText: "Level 70 Unlocked!", awardDesc: "Wow, you have officially made it farther than I ever thought possible! As a reward... you can go further!\n\nThis achievement unlocked Level 70."}, //feature lvl70
      {displayText: "Zone Completed: 2000", awardDesc: "OK that's it! you made it. Stop playing now, there's nothing else to do. Like literally... that's it."},
      {displayText: "Talent Unlock: Powerful", awardDesc: "You have defeated all of the Arena Opponents! But wait... now they come back STRONGER!\n\nThis achievement unlocked the Powerful Talent."}, //talent powerful
      {displayText: "Class Unlock: Rogue", awardDesc: "You have defeated the second set of opponents! But wait, there's more?!?\n\nThis achievement unlocked the Rogue Skill Tree"}, //class rogue
      {displayText: "Arena Level: 250", awardDesc: "You have defeated the level 250 opponents! Go you!"}, //class barbarian?
      {displayText: "Arena Level: 500", awardDesc: "So you probably know this by now, but the arena is a great place to make gold. You have defeated level 500, which is like... 100 guys in one ascension!"},
      {displayText: "Arena Level: 800", awardDesc: "I'm starting to run out of ways to say 'Good Job!' wait - - i never tried this one: GOOD JOB!"},
      {displayText: "Arena Level: 1000", awardDesc: "You have defeated a Level 1,000 Yermiyah. That's the 20th incarnation! That means you have killed me at least 20 times."},
      {displayText: "Arena Level: 1500", awardDesc: "OK, that's it. You've killed me like 30 times. You got the last Arena achievement, so go do something else now!"},
      {displayText: "You have ascended", awardDesc: "Rise from your grave! You have ascended and returned... with more power than ever before!"},
      {displayText: "Ascensions: 10", awardDesc: "You have ascended 10 times and all you got was this lousy award."},
      {displayText: "Ascensions: 25", awardDesc: "You have ascended a grand total of 25 times! Or more, if you kept this award around and are looking at it later. Why would you do that? Sell it! Get your Power Tokens already!"},
      {displayText: "Cosmetic Unlocked: Dark Halo", awardDesc: "You have ascended 50 times and earned yourself the DARK HALO. Because you ascended a dark amount of times. It makes sense, just don't think about it too much."}, //cosmetic dark halo
      {displayText: "Talent Unlocked: Holy", awardDesc: "You have purchased an amazing Mythic item from the golden temple, and proved your devotion.\n\nThis achievement unlocked the Holy Talent."},//XX talent holy
      {displayText: "Mythic Item Sold", awardDesc: "You sold a mythic item! That probably mean you need Power Token for something. Here, sell this award also - I think you need the money."},//XX
      {displayText: "10 Mythic Items Collected", awardDesc: "You own at least 10 Mythic Items! You can't equip more than like 2 or 3 at a time though, so I have no idea why you're hoarding them."},//XX
      {displayText: "Class Unlock: Paladin", awardDesc: "You have crafted an item at the Mythic Forge! I'm so proud of you!\n\nThis achievement unlocked the Paladin Skill Tree."},//XX class paladin
      {displayText: "Cosmetics Unlocked: Ordinary", awardDesc: "You got to level 60 with an Ordinary Hero! Why would you do that? The others are all way more interesting.\n\nThis achievement unlocked Ordinary Cosmetics."},
      {displayText: "Cosmetics Unlocked: Deft", awardDesc: "You got to level 60 with a Deft Hero! Did you do it quickly? Get It?!? Ah you don't know good jokes.\n\nThis achievement unlocked Deft Cosmetics."},
      {displayText: "Cosmetics Unlocked: Clever", awardDesc: "You got to level 60 with a Clever Hero! Like the talent. I bet your build was pretty plain though.\n\nThis achievement unlocked Clever Cosmetics."},
      {displayText: "Cosmetics Unlocked: Ungifted", awardDesc: "You got to level 60 as an Ungifted. You probably miss using magic, don't you.\n\nThis achievement unlocked Ungifted Cosmetics."},
      {displayText: "Cosmetics Unlocked: Studious", awardDesc: "You got to level 60 as a Studious Hero. You probably went grenade build, right? Alchemist Pots or Classic Bomb? Or Rose? That's a good one too.\n\nThis achievement unlocked Studious Cosmetics."},
      {displayText: "Cosmetics Unlocked: Enlightened", awardDesc: "You got to Level 60 as an Enlightened! Now everyone can be enlightened! Or at least look that way...\n\nThis achievement unlocked Enlightened Cosmetics."},
      {displayText: "Cosmetics Unlocked: Powerful", awardDesc: "You got to Level 60 as a Powerful! This is probably your first or second, right? Everyone likes the bonus damage.\n\nThis achievement unlocked Powerful Cosmetics."},
      {displayText: "Cosmetics Unlocked: Holy", awardDesc: "You got to Level 60 with Holiness. Just wait until you unlock the Paladin Skill Tree! You'll def wanna do it again!\n\nThis achievement unlocked Holy Cosmetics."},
      {displayText: "Cosmetics Unlocked: Wild", awardDesc: "You got to Level 60 with a WiLd tALeNt! Did you actually notice a difference?\n\nThis achievement unlocked Wild Cosmetics."},
      {displayText: "Cosmetics Unlocked: Noble", awardDesc: "You got to Level 60 with a Noble Hero! Did you figure out how to min/max this guy? You can't really do it eh?\n\nThis achievement unlocked Noble Cosmetics."},
      {displayText: "Monsters Killed: 10", awardDesc: "You got this award for killing 10 baddies. Now go kill more!"},
      {displayText: "Monsters Killed: 100", awardDesc: "You got this award for killing 100 baddies. That's like Zone 10 right? Not that far."},
      {displayText: "Monsters Killed: 10,000", awardDesc: "You got this award for killing TEN THOUSAND MONSTERS! That's pretty good! But there are a lot more out there!"},
      {displayText: "Monsters Killed: 100,000", awardDesc: "You have officially killed over 100,000 monsters. That's a lot!"},
      {displayText: "Monsters Killed: 1,000,000", awardDesc: "You have killed over a million monsters. This definitely counts as genocide!"},
      {displayText: "Level Reached: 70", awardDesc: "You reached level 70! Bet you didn't think this was possible, did you? Nah, you did... admit it, you were scanning the achievements page."},
      {displayText: "Epic Zone: 2", awardDesc: "OK cool, so now you know what the epic zone is, because you got to Zone 3. What do you think? Up for the challenge?"},
      {displayText: "Epic Zone: 10", awardDesc: "You got this award for completing Epic Zone 10. Don't stick with just 1 character, diversify and strive! That's the only way to push your limits."},
      {displayText: "Epic Zone: 100", awardDesc: "You officially made it past Epic Zone 100. You reached the endgame of the endgame. And no, there are no resets sorry... just gotta try harder to push one more!"},
      {displayText: "Artifacts Unlocked: 1", awardDesc: "You have unlocked a potent Artifact! This means you have officially joined the ranks of the Ascended Heroes!"},
      {displayText: "Artifacts Unlocked: 10", awardDesc: "Your collection of artifacts have grown beyond the number 10! Your epicness has increased."},
      {displayText: "Artifacts Unlocked: 40", awardDesc: "Wow, you got them all! You unlocked all 40 of the artifacts that exist! Now, how many have you actually used? Try out Blood of the Minotaur, I promise it's better than it looks!"},
      {displayText: "Completionist", awardDesc: "You have officially completed all of the achievements! Congratulations!\n\nDid you save all of your other Awards as well? Because if you did, you unlock a super secret extra bonus cosmetic! It's super awesome and epic I swear! And yes, it's totally real! Honest it is!"},//XX
    ]

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
          if (value>25) achieve(ZONE_25);
          if (value>50) achieve(ZONE_50);
          if (value>100) achieve(ZONE_100);
          if (value>200) achieve(ZONE_200);
          if (value>300) achieve(ZONE_300);
          if (value>400) achieve(ZONE_400);
          if (value>600) achieve(ZONE_600);
          if (value>800) achieve(ZONE_800);
          if (value>1000) achieve(ZONE_1000);
          if (value>2000) achieve(ZONE_2000);
      } else if (score == GameData.SCORE_DEATHS) {
        if (value>=1) achieve(DEATHS_1);
        if (value>=100) achieve(DEATHS_100);
      } else if (score == GameData.SCORE_DUEL) {
          if (value>50) achieve(DUEL_50);
          if (value>100) achieve(DUEL_100);
          if (value>250) achieve(DUEL_250);
          if (value>500) achieve(DUEL_500);
          if (value>800) achieve(DUEL_800);
          if (value>1000) achieve(DUEL_1000);
          if (value>1500) achieve(DUEL_1500);
      } else if (score == GameData.SCORE_DAMAGE) {
        if (value>=100) achieve(DAMAGE_100);
      } else if (score == GameData.SCORE_ASCENDS) {
        if (value>=1) achieve(ASCEND_1);
        if (value>=10) achieve(ASCEND_10);
        if (value>=25) achieve(ASCEND_25);
        if (value>=50) achieve(ASCEND_50);
      } else if (score == GameData.SCORE_KILLS) {
        if (value>=10) achieve(KILL_10);
        if (value>=100) achieve(KILL_100);
        if (value>=10000) achieve(KILL_10K);
        if (value>=100000) achieve(KILL_100K);
        if (value>=1000000) achieve(KILL_1M);
      } else if (score == GameData.SCORE_EPICS) {
        if (value>=2) achieve(EPIC_ZONE_2);
        if (value>=10) achieve(EPIC_ZONE_10);
        if (value>=100) achieve(EPIC_ZONE_100);
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
      if (skillA[i].level==SkillData.MAX_SKILL) achieve(MAX_SKILL);
      var _numTrees:int=0;
      var _trees = SkillData.getTreeAssignment(skillA);
      for (var i:int=0;i<SkillData.NUM_TREES;i+=1){
        if (_trees[i]>0) _numTrees+=1;
      }
      if (_numTrees>=5) achieve(SKILL_5_TREES);
    }

    public static function checkUnlockCosmetics(achieve:int):void {
      switch(achieve) {
        case ASCEND_50: addCosmetic(4, BallHead.DARK_HALO); GameData.saveThis(GameData.COSMETICS); break;
        case ORDINARY_LEVEL_60:
          addCosmetic(1, BallHead.NORMAL); addCosmetic(2, BallHead.NORMAL); addCosmetic(4, BallHead.NONE);
          GameData.saveThis(GameData.COSMETICS); break;
        case DEFT_LEVEL_60:
          addCosmetic(1,BallHead.SMALL); addCosmetic(2,BallHead.SMIRK);
          GameData.saveThis(GameData.COSMETICS); break;
        case CLEVER_LEVEL_60:
          addCosmetic(1,BallHead.QUIZ); addCosmetic(2,BallHead.FROWN);
          GameData.saveThis(GameData.COSMETICS); break;
        case UNGIFTED_LEVEL_60:
          addCosmetic(2,BallHead.GAPE); addCosmetic(4,BallHead.BAGS);
          GameData.saveThis(GameData.COSMETICS); break;
        case STUDIOUS_LEVEL_60:
          addCosmetic(2,BallHead.HMM); addCosmetic(4,BallHead.GLASSES);
          GameData.saveThis(GameData.COSMETICS); break;
        case ENLIGHTENED_LEVEL_60:
          addCosmetic(1,BallHead.BRIGHT); addCosmetic(2,BallHead.SMILE);
          GameData.saveThis(GameData.COSMETICS); break;
        case POWERFUL_LEVEL_60:
          addCosmetic(1,BallHead.FURROW); addCosmetic(2,BallHead.SNARL); addCosmetic(4,BallHead.CHIN); 
          GameData.saveThis(GameData.COSMETICS); break;
        case HOLY_LEVEL_60:
          addCosmetic(1,BallHead.SQUINT); addCosmetic(2,BallHead.PURSED); 
          GameData.saveThis(GameData.COSMETICS); break;
        case WILD_LEVEL_60:
          addCosmetic(1,BallHead.CRAZY); addCosmetic(2,BallHead.TONGUE); 
          GameData.saveThis(GameData.COSMETICS); break;
        case NOBLE_LEVEL_60:
          addCosmetic(1,BallHead.UPWARD); addCosmetic(1,BallHead.UPFROWN); addCosmetic(4,BallHead.GOATEE); 
          GameData.saveThis(GameData.COSMETICS); break;
      }
    }

    public static function checkTalentLevel(level:int,talent:int):void {
      if (level>=60){
        achieve(talent+ORDINARY_LEVEL_60);
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