package system.effects{
	import system.buffs.BuffData;
	import system.actions.ActionBase;
	import ui.effects.AnimatedEffect
	
	public class EffectData{
		public static const STUN:String="Stun",
							DISORIENT:String="Disorient",
							
							TERRIFY:String="Terrify",
							TERRIFYING:String="Terrifying",
							IVY:String="Strangling Thorns",
							
							PHOENIX_PROC:String="Ashed",
							
							RUSHED:String="Rushed",
							AIMING:String="Aiming",
							LEAP_ATTACK:String="Leap Attack",
							
							FULL_POWER:String="Full Power",
							FULL_POWER2:String="Fullish Power",
							
							SMITE:String="Holy Smite",
							SMITE_PROC:String="Smite Ready",
							
							MASSIVE_BLOW:String="Claw Strike",
							MASSIVE_CLEAR_ATTACK:String="Claw Clear Attack",
							
							CANNIBAL_CLEAR_ATTACK:String="Cannibal Clear Attack",
							
							RANDOM_COLOR:String="Random Color",
							INIT_SPELL:String="Speedcaster",
							IGNORE_ATTACK:String="Deniability",
							UNARMED_INIT:String="Small Hands",
							
							QUICK:String="Quick Strike",
							DOUBLESHOT:String="Doubleshot",
							KI_STRIKE:String="Ki Strike",
							SMASH:String="Smash",
							CURSE:String="Hex",
							SACRIFICE:String="Sacrifice",
							DAZZLE:String="Dazzle",
							KNOCKBACK:String="Knockback",
							KNOCKBACK_NO:String="Homerun",
							KNOCKBACK_MINOR:String="Bunt",
							KNOCKBACK_REVERSED:String="Pull Closer",
							CRIT_ACCUM:String="Crit Boost",
							MANA_HEAL:String="Mana Steal",
							MPOW_HEAL:String="Restore Health",
							NONCRIT:String="Non-Crit Dmg",
							BLEED:String="Shred",
							DELAYED_DAMAGE:String="Delayed Damage",
							REMOVE_BUFF:String="Purge",
							
							FEAR_BOOST:String="Dmg vs",
							NEAR_DMG_BOOST:String="Near Dmg",
							RANDOM_DMG_BOOST:String="Random Dmg",
							
							COMBO:String="Combo",
							COMBO_DEFENSE:String="Defensive Combo",
							AUTHORITAH:String="Authoritah",
							SCORCHED:String="Scorched",
							ILLUMINATED:String="Illuminated",
							WHISPERED:String="Whispered",
							REND:String="Rended",
							REND_HEAL:String="Mended",
							RANDOM_BUFF:String="Random Buff",
							ASSASSINATE:String="Assassinate",
							
							MINOTAUR:String="Ram",
							
							INITSCALING:String="Cross-Scaling",
							MPOWSCALINGADD:String="Added MPow Scaling",
							MPOWSCALING:String="MPow Scaling",
							CHAIN:String="Chain Attack",
							MULTI:String="Multiple",
							AWARD:String="Everyone's A Winner!",
							
							INITIAL_BLESS:String="Crusader's Blessing",
							INITIAL_CURSE:String="Crusader's Curse",
							INITIAL_MARK:String="Mark Target",
							INITIAL_SPELL:String="Initial Cast",
							NO_OFFENSIVE:String="Diplomacy",
							FREE_SPELL:String="Free Spell",
							
							INITIAL_STEALTH:String="Stealth",
							STEALTH_CMULT:String="Stealth CMult",
							STEALTH_CRATE:String="Stealth Crit",
							STEALTH_DODGE:String="Stealth Dodge",
							STEALTH_CLEAR_DAMAGED:String="Clear when Damaged",
							STEALTH_CLEAR_ATTACK:String="Clear on Offensive Action",
							
							SPIKEY:String="Spikey",
							STRENGTHEN:String="Strengthen",
							BERSERKER:String="Berserker",
							FEARSOME:String="Fearsome",
							BEFUDDLE:String="Control",
							MUTE:String="Mute",
							DTHROW:String="Defensive Throw",
							AUTOPOT:String="Auto Potion",
							AUTOBUFF:String="Auto Buff",
							AUTOBUFFFREE:String="Auto Buff 2",
							ROOT:String="Gaia's Love",
							RESPECT:String="Respect",
							PROTECTION:String="Embraced",
							
							PHOENIX_THORNS:String="Engulfed",
							CLEANSE:String="Cleanse",
							CLEANSE_HEAL:String="Cleanse on Cast",
							REVIVE_PHOENIX:String="Rise from the Ashes",
							REVIVE_JUST:String="Revive",
							REVIVE_GRAIL:String="Rise from the Grave",
							HEAL_GRAIL:String="Grail Heal",
							REVIVE_GOKU:String="Rise from Defeat",
							NORMAL_GOKU:String="Normal Sapien",
							MANA_SHIELD:String="Mana Shield",
							BLOOD_BANK:String="Lazarus",
							MANA_BANK:String="Lamarus",
							UNDYING:String="Undying",
							FIND_STACKS:String="Find Components",
							BASE_DMG:String="Base Dmg",
							MOVE_BOOST:String="Propelled",
							CURSE_REFLECT:String="Curse Reflection",
							BUFF_REFLECT:String="Buff Stealing",
							BARRIER:String="Barrier",
							BUILD_WALL:String="Build the Wall",
							
							SPELL_BOOST:String="Spell Boost",
							BUFF_POT_BOOST:String="Buff Pot Boost",
							BUFF_BOOST:String="Buff Boost",
							DREAM:String="Dreamer's Dream",
							
							MAGIC_STRIKE:String="Magic Strike",
							GRENADE_STRIKE:String="Grenade Strike",
							BUFFPOT_STRIKE:String="Buff Pot Strike",
							STRIKE:String="Simple Strike",
							WITHDRAW_ACT:String="Offensive Action",
							ACT:String="Bonus Action",
							UNARMORED:String="Becomes Agile",
							
							WALK:String="Walk",
							APPROACH:String="Approach",
							WITHDRAW:String="Withdraw",
							BERSERK:String="Berserk",
							AFRAID:String="Afraid",
							
							DEFENSIVE_ROLL:String="Defensive Roll",
							RADIANT_PULSE:String="Radiant Pulse",
							FEATHER_HIT:String="Surestrike",
							INFINITY:String="Infinity",
							MANUFACTURING_HIT:String="Crafting Strike",
							GOLD_PER_KILL:String="Gold Per Kill",
							GOLD_STRIKE:String="Golden Strike",
							
							FURY_MISS:String="Fury on Miss",
							FURY_HURT:String="Fury when Hurt",
							FURY_HIT:String="Fury on Hit",
							FURY_DEFEND:String="Fury on Defend",
							FURY_INIT:String="Starting Fury",
							
							BLOODLUST:String="Vengeance of Blood",
							UNSTOPPABLE:String="Renewed Vigor",
							PSEUDOCRIT:String="Pseudocrit",
							
							RPEN:String="Penetrate Resistances";
							
							//TAGS
		public static const NO_ATTACK:String="No Attack",
							RELIC:String="Relic",
							PIERCE:String="Pierce",
							HALF_STRENGTH:String="Half Strength",
							FULL_STRENGTH:String="Full Strength",
							BONUS_STRENGTH:String="Heavy Weapon",
							ONLYFAR:String="Only Mid",
							TWO_CHARGES:String="Costs 2 Charges",
							RETURN:String="Return",
							HALF_MPOW:String="Half MPow",
							FULL_MPOW:String="Full MPow",
							PREMIUM:String="Mythic",
							SUPER_PREMIUM:String="Legendary",
							EPIC:String="Epic",
							SPECIAL:String="Special",
							LONG_RANGED:String="Long Ranged",
							RANGED:String="Ranged Return",
							MONK_WEAPON:String="Monk Weapon",
							BLOOD_MAGIC:String="Blood Magic",
							ESSENCE:String="Essence",
							DURATION:String="Increased Duration",
							DURATION2:String="Super Duration",
							DURATION_MINUS:String="Decreased Duration",
							SCOURING:String="Undo Crafting",
							CHAOS_ESSENCE:String="Chaos",
							MINOR_CHAOS_ESSENCE:String="Minor Chaos",
							EPIC_ESSENCE:String="Make Epic",
							SUFFIX_ESSENCE:String="Add Suffix",
							PLENTIFUL:String="Plentiful";
		
		public static const BLOOD_MAGIC_RATIO:Number=2.32;
		
		public static function makeEffect(label:String,level:int):EffectBase{
			//label,type,useRate,useMult,values
			switch (label){
				// --- ACTION ---
				//from curses
				
				case TERRIFY: return new EffectBuffBasic(BuffData.makeBuff(BuffData.AFRAID,level*1.5),EffectBase.CURSE);
				case TERRIFYING: return new EffectBuffBasic(BuffData.makeBuff(BuffData.AFRAID,level),EffectBase.CURSE);
				case IVY: return new EffectBuffBasic(BuffData.makeBuff(BuffData.IVY,level),EffectBase.CURSE);
				
				case STUN: return new EffectBuffBasic(BuffData.makeBuff(BuffData.STUNNED,level),EffectBase.CURSE,EffectBase.HIT,0.05);
				case DISORIENT: return new EffectBuffBasic(BuffData.makeBuff(BuffData.DISORIENTED,level),EffectBase.CURSE);
				
				case PHOENIX_PROC: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.HIT,1,BuffData.makeBuff(BuffData.PHOENIX_PROC,level));
				
				//from buffs
				
				//Movement Effects
				case RUSHED: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.ALL,1,BuffData.makeBuff(BuffData.RUSHED,level));
				case AIMING: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.ALL,1,BuffData.makeBuff(BuffData.AIMING,level));
				case LEAP_ATTACK: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.ALL,1,BuffData.makeBuff(BuffData.LEAP_ATTACK,level));
				
				//Proc Damage
				case FULL_POWER: return new EffectDamage(label,27+8*level,DamageModel.MAGICAL);
				case FULL_POWER2: return new EffectDamage(label,107,DamageModel.MAGICAL);
				case GOLD_STRIKE: return new EffectDamage(label,40+10*level,DamageModel.PHYSICAL);
														  
				case SMITE: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.NEVER,Math.floor(7-level/2),BuffData.makeBuff(BuffData.SMITE_PROC,level));
				case MASSIVE_BLOW: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.HIT,1,BuffData.makeBuff(BuffData.MASSIVE_BLOW_PROC,level));
				case MASSIVE_CLEAR_ATTACK: return new EffectBase(label,0,EffectBase.INSTANT,EffectBase.OFFENSE,1);
				case CANNIBAL_CLEAR_ATTACK: return new EffectBase(label,0,EffectBase.INSTANT,EffectBase.OFFENSE,1);
				
				//Other Procs
				case QUICK: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.HIT,Facade.diminish(0.2,level),BuffData.makeBuff(BuffData.QUICK,level));
				case SMASH: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.HIT,0.35+0.01*level,BuffData.makeBuff(BuffData.STUNNED,level));
				case CURSE: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.HIT,0.1+0.01*level,BuffData.makeBuff(BuffData.CURSED,level));
				case DAZZLE: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.HIT,0.05+0.003*level,BuffData.makeBuff(BuffData.STUNNED,level));
				case CRIT_ACCUM: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.HIT,1,BuffData.makeBuff(BuffData.CRIT_ACCUM,level));
				case BLEED: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.HIT,1,BuffData.makeBuff(BuffData.BLEEDING,level));
				case DELAYED_DAMAGE: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.HIT,1,BuffData.makeBuff(BuffData.DELAYED_DAMAGE,level));
				case COMBO: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.HIT,1,BuffData.makeBuff(BuffData.COMBO,level));
				case COMBO_DEFENSE: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.HIT,1,BuffData.makeBuff(BuffData.COMBO_DEFENSE,level));
				case AUTHORITAH: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.HIT,1,BuffData.makeBuff(BuffData.AUTHORITAH,level));
				case SCORCHED: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.HIT,1,BuffData.makeBuff(BuffData.SCORCHED,level));
				case ILLUMINATED: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.HIT,1,BuffData.makeBuff(BuffData.ILLUMINATED,level));
				case WHISPERED: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.HIT,1,BuffData.makeBuff(BuffData.WHISPERED,level));
				case REND: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.HIT,1,BuffData.makeBuff(BuffData.REND,level));
				case REND_HEAL: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.HIT,1,BuffData.makeBuff(BuffData.REND_HEAL,level));
				case MANUFACTURING_HIT: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.HIT,1,1+level);
				case FURY_MISS: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.DEFENSE,1,5+0.5*level);
				case BLOODLUST: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.HIT,30+4.5*level,0.5);
				case SACRIFICE: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.HIT,1,0.05+0.001*level);
				case RPEN: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.HIT,1,0.01*level);
				case KNOCKBACK: return new EffectKnockback(label,level,EffectBase.HIT,EffectKnockback.BACK,true);
				case KNOCKBACK_MINOR: return new EffectKnockback(label,level,EffectBase.HIT,EffectKnockback.BACK);
				case KNOCKBACK_REVERSED: return new EffectKnockback(label,level,EffectBase.HIT,EffectKnockback.FORWARDS);
				case KNOCKBACK_NO: return new EffectKnockback(label,level,EffectBase.HIT,EffectKnockback.BACK_TWO);
				case PSEUDOCRIT: return new EffectDmgBoost(label,level,EffectDmgBoost.FLAT,1,0.25);
				case MANA_HEAL: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.HURT,1,5+1*level);
				case MPOW_HEAL: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.HURT,0.05+0.03*level,1);
				case NONCRIT: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.HIT,1,0.25+0.05*level);
				case REMOVE_BUFF: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.HIT,1,Math.floor(1+0.5*level));
				
				case FEAR_BOOST: return new EffectDmgBoost(label,level,EffectDmgBoost.HAS_CURSE,0.15+0.015*level,1,BuffData.AFRAID);
				case NEAR_DMG_BOOST: return new EffectDmgBoost(label,level,EffectDmgBoost.DISTANCE,0.25,1,GameModel.NEAR);
				case RANDOM_DMG_BOOST: return new EffectDmgBoost(label,level,EffectDmgBoost.RANDOMIZED,level/100);
				case ASSASSINATE: return new EffectDmgBoost(label,level,EffectDmgBoost.HEALTH_PERCENT,0.05+0.07*level);
				
				case RANDOM_BUFF: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.ALL,1,Math.floor(level*1.5));
				case KI_STRIKE: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.HIT,1,[0.1+0.39*level,(100-5*level<25?25:100-5*level)]);
				
				//Defended Procs
				case MINOTAUR: return new EffectKnockback(label,level,EffectBase.ALL,EffectKnockback.BACK,true,0.2+0.04*level,AnimatedEffect.HORNS);
				case RADIANT_PULSE: return new EffectDamage(label,0.1+0.015*level,DamageModel.HOLY,EffectBase.BLOCK);
													  
				//Display Effects
				case RANDOM_COLOR: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,1,0);
				case INITSCALING: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,1,0.2+0.05*level);
				case MPOWSCALINGADD: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,1,0.2+0.05*level);
				case MPOWSCALING: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,1,level/10);
				case CHAIN: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.HIT,1,level);
				case MULTI: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,1,level);
				case DOUBLESHOT: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,0.1+0.09*level,1);
				case UNARMED_INIT: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,1,0);
				case BASE_DMG: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,1,5+level/2);
				case INIT_SPELL: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,1,0.1+0.02*level);
				case FEATHER_HIT: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,1,40+10*level);
				case GOLD_PER_KILL: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,1,100+20*level);
				
				//--- INITIAL ---
				case INITIAL_BLESS: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.INITIAL,1,BuffData.makeBuff(BuffData.INITIAL_BLESS,level));
				case INITIAL_CURSE: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.INITIAL,1,BuffData.makeBuff(BuffData.INITIAL_CURSE,level));
				case INITIAL_MARK:  return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.INITIAL,1,BuffData.makeBuff(BuffData.MARKED,level));
				case INITIAL_SPELL: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.INITIAL,1,null);
				
				case NO_OFFENSIVE: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.HURT,0.1+level*0.01,BuffData.makeBuff(BuffData.INITIAL_NO_OFFENSIVE,level));
				
				case INITIAL_STEALTH: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,1,0);
				
				//--- STEALTH ---
				case STEALTH_CMULT: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.INITIAL,1,0.16*level); //Initiate:: CMult
				case STEALTH_CRATE:	return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.HURT,1,0.019*level); //C.Effect:: CRate
				case STEALTH_DODGE: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.DODGE,1,0.04+Facade.diminish(0.03,level)); //On Dodge:: Dodge
				case STEALTH_CLEAR_DAMAGED: return new EffectBase(label,0,EffectBase.INSTANT,EffectBase.HURT,1);
				case STEALTH_CLEAR_ATTACK: return new EffectBase(label,0,EffectBase.INSTANT,EffectBase.OFFENSE,1);
				
				//--- REACTION ---
				//Reactions
				case SPIKEY: return new EffectDamage(label,10+3*level,DamageModel.PHYSICAL,EffectBase.HITBLOCK);
				
				case STRENGTHEN: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.ALL,1,BuffData.makeBuff(BuffData.BERSERK,level));
				case BERSERKER: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.HIT,0.15+0.01*level,BuffData.makeBuff(BuffData.BERSERK,level));
				case FEARSOME: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.HURT,0.15,BuffData.makeBuff(BuffData.AFRAID,level));
				case BEFUDDLE: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.HURT,0.20,BuffData.makeBuff(BuffData.CONFUSED,level));
				case MUTE: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.TURN,0.2+0.08*level,BuffData.makeBuff(BuffData.SILENCED,1));
				case ROOT: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.HIT,0.1+0.04*level,BuffData.makeBuff(BuffData.ROOTED,level));
				case RESPECT: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.DEFENSE,1,BuffData.makeBuff(BuffData.RESPECT,level));
				
				case IGNORE_ATTACK: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.HURT,1,BuffData.makeBuff(BuffData.ATTACK_IGNORED,level));
				case BUILD_WALL: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.HURT,1,BuffData.makeBuff(BuffData.BUILD_WALL,level));
				case DTHROW: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.DEFENSE,Facade.diminish(0.06,level),0);
				
				case FURY_HURT: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.HURT,1,10+level);
				case FURY_INIT: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.INITIAL,1,5+2*level);
				case FURY_HIT: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.HIT,1,1+0.4*level);
				case FURY_DEFEND: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.DEFENSE,1,2+0.8*level);
				
				//--- SPECIALS ---
				
				//when Injured
				case PROTECTION: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.INJURED,1,BuffData.makeBuff(BuffData.PROTECTION,level));
				
				case AUTOPOT: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.INJURED,Facade.diminish(0.08,level),0);
				case AUTOBUFF: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.INJURED,Facade.diminish(0.03,level),0);
				case AUTOBUFFFREE: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.INJURED,Facade.diminish(0.03,level),BuffData.makeBuff(BuffData.BUFF_POT,level*0.5));
				
				//start of each round
				
				case PHOENIX_THORNS: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.CONSTANT,1,BuffData.makeBuff(BuffData.PHOENIX_THORNS,level));
				case BARRIER: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.CONSTANT,1,BuffData.makeBuff(BuffData.BARRIER,level));
				case FREE_SPELL: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.CONSTANT,1,new ActionBase());
				
				case CLEANSE: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.CONSTANT,0.2+0.08*level,1);
				case CLEANSE_HEAL: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.ALL,1,1+level/2);
				
				
				//revives
				case REVIVE_PHOENIX: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,0.1+0.06*level,0);
				case REVIVE_JUST: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,0.17,0);
				case UNDYING: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.NEVER,1,BuffData.makeBuff(BuffData.UNDYING,level));
				case REVIVE_GRAIL: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.NEVER,0.3,BuffData.makeBuff(BuffData.GRAILED,level));
				case HEAL_GRAIL: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.ALL,1,BuffData.makeBuff(BuffData.GRAILED,level));
				case REVIVE_GOKU: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.NEVER,1,BuffData.makeBuff(BuffData.SUPER_SAYAN,level));
				case NORMAL_GOKU: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.NEVER,1,BuffData.makeBuff(BuffData.SAYAN,level));
				
				//boosts
				case SPELL_BOOST: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.LEVEL_BOOST,0.25+0.075*level,6);
				case BUFF_POT_BOOST: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.LEVEL_BOOST,1,Math.floor(1+0.2*level));
				case BUFF_BOOST:  return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.LEVEL_BOOST,1,1+Math.floor(level/7));
				
				//self actions
				case DREAM: return new EffectBuff(label,level,EffectBase.CURSE,EffectBase.TRIGGER_SELF,0.15+0.045*level,BuffData.makeBuff(BuffData.ASLEEP,level));
				case MOVE_BOOST: return new EffectBuff(label,level,EffectBase.BUFF,EffectBase.TRIGGER_SELF,1,BuffData.makeBuff(BuffData.MOVE_BOOST,level));
				
				//mitigations
				case MANA_SHIELD: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.MITIGATION,1,10/(6*level));
				case BLOOD_BANK: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.MITIGATION,1,50+5*level);
				case MANA_BANK: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,1,25+2*level);
				case DEFENSIVE_ROLL: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.MITIGATION,1,0.05+0.035*level);
				case UNSTOPPABLE: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.MITIGATION,1,[0.0005*level,0.5*level]);
				
				//miscellaneous
				case CURSE_REFLECT: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,0.05+0.015*level,0);
				case BUFF_REFLECT: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,0.05+0.015*level,0);
				case FIND_STACKS: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,1,40+6*level);
				case AWARD: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,1,null);
				case UNARMORED: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,1,null);
				case INFINITY: return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,0.35,null);
				
				//Actions
				case BUFFPOT_STRIKE: return new EffectStrike(label,level,EffectStrike.BUFFPOT,0.5+0.05*level)
				case MAGIC_STRIKE: return new EffectStrike(label,level,EffectStrike.MAGIC,0.5+0.05*level)
				case GRENADE_STRIKE: return new EffectStrike(label,level,EffectStrike.GRENADE,0.5+0.05*level)
				
				case STRIKE: return new EffectStrike(label,level,EffectStrike.BASIC,1);
				case ACT: return new EffectStrike(label,level,EffectStrike.ANY,1);
				case WITHDRAW_ACT: return new EffectStrike(label,level,EffectStrike.WITHDRAW,1);
				
				
				//  REMOVE???
				case WALK: case APPROACH: case WITHDRAW: 
				case BERSERK: case AFRAID:
				return new EffectBase(label,level,EffectBase.INSTANT,EffectBase.NEVER,1,null);
				
				default: throw(new Error("Unidentified effect label: "+label)); return null;
			}
		}
	}
}