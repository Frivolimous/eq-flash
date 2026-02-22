package system.buffs{
	import system.actions.ActionBase;
	import system.effects.EffectData;
	import system.effects.EffectDamage;

	public class BuffData{
		public static const BURNED:String="Burned",
							POISONED:String="Poisoned",
							POISONED2:String="Extra Poisoned",
							GASSED:String="Gassed",
							DARKENED:String="Darkened",
							BOMB:String="Ticking",
							IVY:String="Entangled",
							TRAP:String="Trapper",
							UNTRAPPABLE:String="Untrappable",
							ECCHO:String="Pained",
							SPINES:String="Toxics",
							DELAYED_DAMAGE:String="Uh-Oh",
							BLEEDING:String="Bleeding",
							PHOENIX_PROC:String="Ashed",
							PHOENIX_THORNS:String="Roasted",
							PROTECTION:String="Embraced",
							REND:String="Rended",
							REND_HEAL:String="Mended",
							CRIT_ACCUM:String="Crit Boosted",
							EMPOWERED:String="Empowered",
							EMPOWERED2:String="Enstrengthened",
							EMPOWERED3:String="Enquickened",
							HASTENED:String="Hastened",
							SLOW:String="Slowed",
							ENCHANTED:String="Enchanted",
							ENCHANTED2:String="Blessed Weapon",
							ENCHANTED3:String="Vorpal Weapon",
							ENCHANTED4:String="Insidious Weapon",
							SHIELD:String="Shielded",
							SMITE_PROC:String="Smite Ready",
							MASSIVE_BLOW_OFF:String="Claw Strike Charging",
							MASSIVE_BLOW_PROC:String="Claw Strike",
							HEAL_NO:String="No Healing",
							COOLDOWN:String="Cooldown",
							
							STRENGTHEN:String="Strengthened",
							BUFF_POT:String="Boosted",
							CELERITY_POT:String="Celerous",
							TURTLE_POT:String="Turtled",
							PURITY_POT:String="Pure",
							MOVE_BOOST:String="Propelled",
							COMBO:String="Comboing",
							COMBO_DEFENSE:String="Defensive",
							INITIAL_BLESS:String="Blessed",
							INITIAL_CURSE:String="Un-Blessed",
							INITIAL_NO_OFFENSIVE:String="Diplomacy",
							MARKED:String="Mark Target",
							GRAILED:String="Grailed",
							SAYAN:String="Normal Sapien",
							SUPER_SAYAN:String="Super Sapien",
							SUPER_SAYAN2:String="Legendary",
							SUPER_SAYAN3:String="Vegetative",
							HIGH:String="High",
							
							BERSERK:String="Berserk",
							TAUNT:String="Taunt",
							
							RUSHED:String="Rushed",
							AIMING:String="Aiming",
							QUICK:String="Quick Strike",
							LEAP_ATTACK:String="Leap Attack",
							
							WEAKENED:String="Weakened",
							VULNERABLE:String="Vulnerable",
							VULNERABLE2:String="Physical Vulnerable",
							SCORCHED:String="Scorched",
							ILLUMINATED:String="Illuminated",
							WHISPERED:String="Whispered",
							CURSED:String="Hexed",
							BLIND:String="Blind",
							RESPECT:String="Respect",
							AUTHORITAH:String="Authoritah",
							
							GOLEM_CONFUSED:String="Extra Confused",
							CONFUSED:String="Confused",
							DISORIENTED:String="Disoriented",
							STUNNED:String="Stunned",
							ASLEEP:String="Asleep",
							AFRAID:String="Afraid",
							ENTRANCED:String="Entranced",
							BARRIER:String="Barrier",
							BUILD_WALL:String="Build a Wall",
							
							SILENCED:String="Silenced",
							ROOTED:String="Rooted",
							
							UNDYING:String="Undying",
							DYING:String="Dying",
							REVIVED:String="Revived",
							ATTACK_IGNORED:String="Attack Ignored",
							
							STEALTH:String="Stealth",
							
							TOWN:String="Going To Town",
							XP_BOOST:String="XP Boosted",
							PROGRESS_BOOST:String="Offline Boost",
							
							ROBOCOP:String="Exposed Weakness",
							CANNIBALISM:String="Cannibalism";
							
		public static function makeBuff(label:String,level:int=0):BuffBase{
			var halfLevel:Number;
			if (level<=15) halfLevel=level;
			else halfLevel=15+(level-15)/2;
			
			//label,charges,values
			switch (label){
				//Dots
				case BURNED: return new BuffDOT(16,label,level,5,StatModel.MPOWER,5+3*level,ActionBase.MAGICAL,0.25);
				case DARKENED: return new BuffDOT(31,label,level,3,StatModel.MPOWER,2+1.25*level,ActionBase.DARK,0.5,2);
				case POISONED: return new BuffDOT(19,label,level,3+Math.floor(level/7),StatModel.MPOWER,18+2.1*level,ActionBase.MAGICAL,0.25);
				case POISONED2: return new BuffDOT(19,label,level,3+Math.floor(level/7),StatModel.MPOWER,18+2.1*level,ActionBase.MAGICAL,0.25);
				case GASSED: return new BuffDOT(36,label,level,5,StatModel.THROWEFF,28+2*level,ActionBase.CHEMICAL,0.25,2);
				case IVY: return new BuffDOT(93,label,level,3,StatModel.THROWEFF,15+1.1*level,ActionBase.CHEMICAL);
				case TRAP: return new BuffDOT(139,label,level,1,StatModel.MPOWER,15+1.1*level,ActionBase.DARK);
				case UNTRAPPABLE: return new BuffStats(139,label,level,BuffBase.BUFF,3,[[SpriteModel.STAT,StatModel.TENACITY,0.025*(level+1)]]);
				case ECCHO: return new BuffDOT(BuffView.SKILL_START+28,label,level,3,StatModel.MPOWER,5+4*level,ActionBase.DARK,0,2);
				case SPINES: return new BuffDOT(19,label,level,5,-1,15+0.8*level,ActionBase.CHEMICAL,0.5);
				case BLEEDING: return new BuffDOT(BuffView.ARTIFACT_START+27,label,level,3,-1,0.1+0.025*level,ActionBase.PHYSICAL,0.5);
				case PHOENIX_PROC: return new BuffDOT(BuffView.ARTIFACT_START+1,label,level,3,-1,20+8*level,ActionBase.MAGICAL,0,3);
				case PHOENIX_THORNS: return new BuffDOT(BuffView.ARTIFACT_START+2,label,level,3,-1,20+8*level,ActionBase.MAGICAL,0,3);
				case REND: return new BuffDOT(75,label,level,3,-1,3+1.5*level,ActionBase.PHYSICAL,0.5,20);
				
				//Delayed Dmg
				case BOMB: return new BuffDelayedDmg(94,label,level,1,StatModel.THROWEFF,86+5.1*level,ActionBase.CHEMICAL,0,2);
				case DELAYED_DAMAGE: return new BuffDelayedDmg(117,label,level,1,-1,1+0.05*level,ActionBase.PHYSICAL,0.5,2);
				
				//Hots
				case PROTECTION: return new BuffHOT(BuffView.SKILL_START+34,label,level,2,-1,30+7.5*level,ActionBase.HOLY);
				case REND_HEAL: return new BuffHOT(75,label,level,3,-1,3+1.5*level,ActionBase.PHYSICAL,20);
				
				//Spell Buffs
				case EMPOWERED: return new BuffStats(24,label,level,BuffBase.BUFF,4,[[SpriteModel.STAT,StatModel.MPOWER,100+10*halfLevel],[SpriteModel.STAT,StatModel.MRATE,0.2]]);
				case HASTENED: return new BuffStats(25,label,level,BuffBase.BUFF,5,[[SpriteModel.STAT,StatModel.INITIATIVE,10+2.5*halfLevel],[SpriteModel.STAT,StatModel.DODGE,0.15+0.6*Facade.diminish(0.05,halfLevel)]]);
				case ENCHANTED: return new BuffEnchantWeapon(26,label,level,7,StatModel.MPOWER,[[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectDamage("Enchanted",8+5*halfLevel,DamageModel.MAGICAL)]]);
				case STRENGTHEN: return new BuffStats(29,label,level,BuffBase.BUFF,5,[[SpriteModel.STAT,StatModel.STRENGTH,20+5*level]]);
				case SHIELD: return new BuffShield(23,label,level,-1,StatModel.MPOWER,39+3.3*level,3);
				case CANNIBALISM: return new BuffStats(141,label,level,BuffBase.BUFF,1,[[SpriteModel.ATTACK,ActionBase.LEECH,0.25+0.025*level],[SpriteModel.ATTACK,ActionBase.HITRATE,10+5*level],[SpriteModel.ATTACK,ActionBase.DODGE_REDUCE,0.5],[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.CANNIBAL_CLEAR_ATTACK,0)]]);
				//Pot Buffs
				case BUFF_POT: return new BuffStats(34,label,level,BuffBase.BUFF,5,[[SpriteModel.STAT,StatModel.STRENGTH,15+5*halfLevel],[SpriteModel.STAT,StatModel.MPOWER,15+5*halfLevel],[SpriteModel.STAT,StatModel.INITIATIVE,15+5*halfLevel],[SpriteModel.STAT,StatModel.THROWEFF,0.15+0.05*halfLevel],[SpriteModel.STAT,StatModel.RMAGICAL,0.1+0.7*Facade.diminish(0.03,level)],[SpriteModel.STAT,StatModel.RCHEMICAL,0.1+0.7*Facade.diminish(0.03,level)],[SpriteModel.STAT,StatModel.RSPIRIT,0.1+0.7*Facade.diminish(0.03,level)]]);
				case CELERITY_POT: return new BuffStats(98,label,level,BuffBase.BUFF,5,[[SpriteModel.ATTACK,ActionBase.HITRATE,15+5*level],[SpriteModel.ATTACK,ActionBase.CRITRATE,0.02+Facade.diminish(0.01,halfLevel)],[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.QUICK,1+0.5*halfLevel)]]);
				case TURTLE_POT: return new BuffStats(99,label,level,BuffBase.BUFF,5,[[SpriteModel.STAT,StatModel.BLOCK,20+6.6*level],[SpriteModel.STAT,StatModel.RPHYS,0.02+Facade.diminish(0.011,level)],[SpriteModel.STAT,StatModel.RMAGICAL,0.05+Facade.diminish(0.019,level)],[SpriteModel.STAT,StatModel.RCHEMICAL,0.05+Facade.diminish(0.019,level)],[SpriteModel.STAT,StatModel.RSPIRIT,0.05+Facade.diminish(0.019,level)],[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.SPIKEY,Math.floor(level*0.7))]]);
				case PURITY_POT: return new BuffStats(100,label,level,BuffBase.BUFF,5,[[SpriteModel.STAT,StatModel.DODGE,0.02+Facade.diminish(0.018,halfLevel)],[SpriteModel.STAT,StatModel.TURN,0.02+Facade.diminish(0.018,halfLevel)],[SpriteModel.STAT,StatModel.HREGEN,0.005+0.001*halfLevel],[SpriteModel.STAT,StatModel.MREGEN,0.005+0.001*halfLevel]]);				
				case GRAILED: return new BuffStats(114,label,level,BuffBase.BUFF,3,[[SpriteModel.STAT,StatModel.HREGEN,0.01+0.004*halfLevel]]);
				
				//React Buffs
				case BERSERK: return new BuffStats(27,label,level,BuffBase.BUFF,4,[[SpriteModel.STAT,StatModel.STRENGTH,25+5*level],[SpriteModel.STAT,StatModel.TENACITY,0.1]]);
				case TAUNT: return new BuffStats(27,label,level,BuffBase.CURSE,3,[[SpriteModel.STAT,StatModel.STRENGTH,25-5*level],[SpriteModel.ATTACK,ActionBase.HITRATE,-2.5*level],[SpriteModel.STAT,StatModel.TENACITY,0.1]]);
				
				//Special Buffs
				case MOVE_BOOST: return new BuffStats(105,label,level,BuffBase.BUFF,2,[[SpriteModel.STAT,StatModel.DODGE,0.075+0.0075*level],[SpriteModel.STAT,StatModel.TURN,0.075+0.0075*level]]);
				case SAYAN: return new BuffStats(-1,label,level,BuffBase.BUFF,-1,[[SpriteModel.STAT,StatModel.HEALTH,20+14*level],[SpriteModel.STAT,StatModel.DODGE,0.15],[SpriteModel.STAT,StatModel.BLOCK,2+2*level]]);
				case SUPER_SAYAN: return new BuffStats(125,label,level,BuffBase.BUFF,-1,[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.UNARMORED,level)],[SpriteModel.STAT,StatModel.TURN,0.15+0.0085*halfLevel],[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectDamage("Brilliant",10,DamageModel.HOLY)]]);
				case SUPER_SAYAN2: return new BuffStats(125,label,level,BuffBase.BUFF,-1,[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.UNARMORED,level)],[SpriteModel.STAT,StatModel.DMGMULT,0.1+0.01*level],[SpriteModel.ATTACK,ActionBase.HITRATE,3*level],[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectDamage("Brilliant",10,DamageModel.HOLY)]]);
				case SUPER_SAYAN3: return new BuffStats(125,label,level,BuffBase.BUFF,-1,[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.UNARMORED,level)],[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.QUICK,halfLevel*0.6)],[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectDamage("Brilliant",10,DamageModel.HOLY)]]);
				case STEALTH: return new BuffStealth(level);
				case COOLDOWN: return new BuffStats(87,label,level,BuffBase.CURSE,2,[[SpriteModel.STAT,StatModel.STRMULT,-0.9],[SpriteModel.STAT,StatModel.INITMULT,-0.9]]);
				
				//Proc Buffs
				case CRIT_ACCUM: return new BuffStats(BuffView.ARTIFACT_START+19,label,level,BuffBase.BUFF,-1,[[SpriteModel.ATTACK,ActionBase.CRITRATE,0.05+0.01*level]],10);
				case COMBO: return new BuffStats(107,label,level,BuffBase.BUFF,1,[[SpriteModel.STAT,StatModel.DMGMULT,0.20+0.01*halfLevel]],3);
				case COMBO_DEFENSE: return new BuffStats(103,label,level,BuffBase.BUFF,2,[[SpriteModel.STAT,StatModel.RPHYS,0.01+0.001*halfLevel],[SpriteModel.STAT,StatModel.RCHEMICAL,0.025+0.0025*halfLevel]],8);
				case QUICK: return new BuffStats(-1,label,level,BuffBase.BUFF,1,[[SpriteModel.ATTACK,ActionBase.HITRATE,8*level]]);
				
				//Init Buffs
				case INITIAL_BLESS: return new BuffStats(116,label,level,BuffBase.BUFF,3,[[SpriteModel.STAT,StatModel.DMGMULT,0.05+0.009*level],[SpriteModel.ATTACK,ActionBase.HITRATE,10+2*level]]);
				case INITIAL_CURSE: return new BuffStats(116,label,level,BuffBase.CURSE,3,[[SpriteModel.STAT,StatModel.DMGMULT,-0.05-0.009*level],[SpriteModel.ATTACK,ActionBase.HITRATE,-10-2*level]]);
				case MARKED: return new BuffStats(BuffView.SKILL_START+16,label,level,BuffBase.CURSE,3,[[SpriteModel.STAT,StatModel.DODGE,-0.05-0.01*level],[SpriteModel.STAT,StatModel.RPHYS,-0.05-0.02*level],[SpriteModel.STAT,StatModel.RCRIT,-0.05-0.02*level]]);
				
				case HIGH: return new BuffStats(124,label,level,BuffBase.BUFF,3,[[SpriteModel.STAT,StatModel.HREGEN,0.01+0.001*level],[SpriteModel.STAT,StatModel.MREGEN,0.01+0.001*level]]);
				case BARRIER: return new BuffShield(123,label,level,-1,StatModel.MPOWER,1+1*level,20);
				case BUILD_WALL: return new BuffShield(122,label,level,-1,-1,0.15,1);
				case SMITE_PROC: return new BuffStats(BuffView.SKILL_START+31,label,level,BuffBase.BUFF,-1,[[SpriteModel.STAT,StatModel.PROCS,new EffectDamage(EffectData.SMITE_PROC,50+20*level,DamageModel.HOLY)]],Math.floor(7-level/2));
				case MASSIVE_BLOW_OFF: return new BuffDisplay(BuffView.SKILL_START+6,label,level,-1,Math.floor(14-level));
				case MASSIVE_BLOW_PROC: return new BuffStats(BuffView.SKILL_START+6,label,level,BuffBase.BUFF,-1,[[SpriteModel.STAT,StatModel.DMGMULT,2],[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.MASSIVE_CLEAR_ATTACK,0)]],Math.floor(14-level));
				
				//Action Buffs
				case RUSHED: return new BuffStats(-1,label,level,BuffBase.BUFF,1,[[SpriteModel.ATTACK,ActionBase.DODGE_REDUCE,-0.1],[SpriteModel.STAT,StatModel.TURN_REDUCE,-0.1]]);
				case AIMING: return new BuffStats(-1,label,level,BuffBase.BUFF,1,[[SpriteModel.ATTACK,ActionBase.HITRATE,5+5*level]]);
				case LEAP_ATTACK: return new BuffStats(-1,label,level,BuffBase.BUFF,1,[[SpriteModel.ATTACK,ActionBase.DODGE_REDUCE,-0.1+0.02*level],[SpriteModel.STAT,StatModel.DMGMULT,0.1*level]]);
				
				//Spell Curses
				case WEAKENED: return new BuffStats(21,label,level,BuffBase.CURSE,5,[[SpriteModel.STAT,StatModel.DMGMULT,-0.1-0.7*Facade.diminish(0.09,halfLevel)]]);
				case VULNERABLE: return new BuffStats(22,label,level,BuffBase.CURSE,7,[[SpriteModel.STAT,StatModel.RMAGICAL,-0.1-0.5*Facade.diminish(0.03,halfLevel)],[SpriteModel.STAT,StatModel.RCHEMICAL,-0.1-0.5*Facade.diminish(0.03,halfLevel)],[SpriteModel.STAT,StatModel.RSPIRIT,-0.1-0.5*Facade.diminish(0.03,halfLevel)]]);
				case ROBOCOP: return new BuffStats(142,label,level,BuffBase.CURSE,2,[[SpriteModel.STAT,StatModel.RMAGICAL,-0.5-0.02*halfLevel],[SpriteModel.STAT,StatModel.RCHEMICAL,-0.5-0.02*halfLevel],[SpriteModel.STAT,StatModel.RSPIRIT,-0.5-0.02*halfLevel],[SpriteModel.STAT,StatModel.RPHYS,-0.25-0.01*halfLevel]]);
				case VULNERABLE2: return new BuffStats(22,label,level,BuffBase.CURSE,7,[[SpriteModel.STAT,StatModel.RPHYS,-0.05-0.25*Facade.diminish(0.03,halfLevel)]]);
				case SCORCHED: return new BuffStats(112,label,level,BuffBase.CURSE,3,[[SpriteModel.STAT,StatModel.RSPIRIT,-0.05-0.005*halfLevel]],2);
				case ILLUMINATED: return new BuffStats(74,label,level,BuffBase.CURSE,3,[[SpriteModel.STAT,StatModel.RSPIRIT,-0.10-0.01*halfLevel]]);
				case WHISPERED: return new BuffStats(BuffView.ARTIFACT_START+9,label,level,BuffBase.CURSE,2,[[SpriteModel.STAT,StatModel.RMAGICAL,-0.15-0.018*level],[SpriteModel.STAT,StatModel.RCHEMICAL,-0.15-0.018*level],[SpriteModel.STAT,StatModel.RSPIRIT,-0.15-0.018*level]]);
				case CURSED: return new BuffStats(21,label,level,BuffBase.CURSE,3,[[SpriteModel.ATTACK,ActionBase.HITRATE,-10-7*halfLevel]]);
				case BLIND: return new BuffStats(28,label,level,BuffBase.CURSE,3,[[SpriteModel.ATTACK,ActionBase.HITRATE,-50-5*halfLevel]]);
				case RESPECT: return new BuffStats(102,label,level,BuffBase.CURSE,2,[[SpriteModel.STAT,StatModel.DODGE,-0.05-0.01*level],[SpriteModel.STAT,StatModel.TURN,-0.05-0.01*halfLevel]]);
				case AUTHORITAH: return new BuffStats(106,label,level,BuffBase.CURSE,1,[[SpriteModel.STAT,StatModel.DMGMULT,-0.1-0.01*halfLevel]]);
				case HEAL_NO: return new BuffStats(21,label,level,BuffBase.CURSE,10,[[SpriteModel.STAT,StatModel.HEALMULT,-0.5-0.5*halfLevel/20]]);
				case SLOW: return new BuffStats(25,label,level,BuffBase.CURSE,5,[[SpriteModel.STAT,StatModel.INITIATIVE,-10-2.5*halfLevel],[SpriteModel.STAT,StatModel.DODGE,-0.075-0.3*Facade.diminish(0.05,halfLevel)]]);
				
				//Action Preventions
				case GOLEM_CONFUSED: return new BuffAction(-1,label,level,-1,.3);
				case STUNNED: return new BuffAction(17,label,level,1+Math.floor(level/100),1);
				case ASLEEP: return new BuffAction(BuffView.ARTIFACT_START+24,label,level,1,1);
				case AFRAID: return new BuffAction(30,label,level,3,0.2+0.5*Facade.diminish(0.07,halfLevel));
				case CONFUSED: return new BuffAction(20,label,level,5,0.25+0.5*Facade.diminish(0.08,halfLevel));
				case DISORIENTED: return new BuffAction(BuffView.ARTIFACT_START+7,label,level,1,0.1+0.015*level);
				case SILENCED: return new BuffAction(BuffView.ARTIFACT_START+11,label,level,2+(level>6?1:0),0);
				case ROOTED: return new BuffAction(BuffView.ARTIFACT_START+21,label,level,2,0);
				case INITIAL_NO_OFFENSIVE: return new BuffAction(144,label,level,2,0);
				
				//State Buffs
				case UNDYING: 
					if (level==-1) {
						return new BuffStats(91,label,level,BuffBase.BUFF,2,[[SpriteModel.STAT,StatModel.HREGEN,0.005]]);
					}else{
						return new BuffStats(91,label,level,BuffBase.BUFF,3,[[SpriteModel.STAT,StatModel.HREGEN,0.02+0.002*level]]);
					}
				case DYING: return new BuffDisplay(-1,label,level,-1);
				case REVIVED: return new BuffDisplay(BuffView.ARTIFACT_START,label,level,-1);
				case ATTACK_IGNORED: return new BuffDisplay(122,label,level,-1);
				
				//Display Buffs
				case TOWN: return new BuffDisplay(52,label,level,-1);
				case XP_BOOST: return new BuffDisplay(64,label,level,-1);
				case PROGRESS_BOOST: return new BuffDisplay(63,label,level,-1);
				
				default:throw(new Error("Unidentified buff label: "+label)); return null;
			}
		}
	}
}