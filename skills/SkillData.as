package skills{
	import system.actions.ActionData;
	import system.actions.ActionBase;
	import system.effects.EffectData;
	import system.effects.EffectDamage;
	import system.effects.EffectDmgBoost;
	import system.effects.EffectDamageRadiation;
	import system.effects.EffectBase;
	import system.effects.EffectBuffBasic;
	import system.buffs.BuffData;
	
	public class SkillData{
		public static const MAX_SKILL:int=10;
		public static const NUM_TREES:int=9;
		
		public static const FITNESS:int=2,
							STRENGTH:int=0,
							TOUGHNESS:int=3,
							LEAP:int=1,
							WEAPON_SKILL:int=4,
							
							UNARMED:int=5,
							FLURRY:int=6,
							KI_STRIKE:int=7,
							PURITY:int=8,
							DTHROW:int=9,
							
							MAGIC_APTITUDE:int=12,
							FOCUS:int=13,
							VESSEL:int=11,
							ATTUNEMENT:int=14,
							TURNING:int=10,
							
							GADGETEER:int=15,
							VITAL:int=16,
							BATTLE_AWARENESS:int=18,
							PRECISION:int=17,
							WITHDRAW:int=19,
							
							IRON_GUT:int=22,
							RADIATE:int=23,
							CRAFTING:int=21,
							DEADLY_ALCH:int=24,
							DETERMINED:int=20,
							
							PACT:int=25,
							BINDING:int=26,
							DEPTHS:int=27,
							ECCHO:int=28,
							DRAW_POWER:int=29,
							
							INITIATE:int=30,
							SMITE:int=31,
							GUARD:int=32,
							ALLY:int=33,
							PROTECTION:int=34,
							
							ONE_SHADOWS:int=35,
							DEADLY_SHADOWS:int=36,
							DANCING_SHADOWS:int=37,
							ASSASSINATE:int=38,
							DEFENSIVE_ROLL:int=39,
							
							WILDERNESS:int=40,
							FURIOUS:int=41,
							LASTING_ANGER:int=42,
							BLOODLUST:int=43,
							UNSTOPPABLE:int=44;
		
							
		public static const skillName:Vector.<String>=new <String>["Strength","Leap Attack","Fitness","Toughness","Combat Training",
																   "Martial Arts","Tiger Style","Crane Style","Purity of Form","Defensive Throw",
																   "Spell Turning","Vessel","Magical Aptitude","Focus","Attunement",
																   "Doubleshot","Precision","Spot","Battle Awareness","Withdraw",
																   "Determined","Manufacturing","Iron Gut","Radiating Aura","Deadly Alchemist",
																   "Pact of Darkness","Dark Binding","Lingering Depths","Hollow Echo","Draw Power",
																   "Initiate of Glory","Smite","Holy Guard","Ally of Light","Divine Protection",
																   "One with Shadows","Deadly Shadows","Dancing Shadows","Assassinate","Defensive Roll",
																   "Wilderness Survival","Furious","Lasting Anger","Bloodlust","Unstoppable"];
		public static const ORDINARY:int=0,
							DEFT:int=1,
							CLEVER:int=2,
							UNGIFTED:int=3,
							STUDIOUS:int=4,
							ENLIGHTENED:int=5,
							POWERFUL:int=6,
							HOLY:int=7,
							WILD:int=8,
							NOBLE:int=9,
							HOBO:int=10,
							BRAVE:int=11,
							WHITE:int=12,
							HUNTER:int=13,
							GRENADIER:int=14,
							IRON:int=15,
							SWIFT:int=16,
							PEASANT:int=17,
							DABBLER:int=18,
							WEAVER:int=19,
							SAVIOR:int=20,
							SEASON1_DEFT:int=21,
							SEASON1_HOLY:int=22,
							SEASON1_GADG:int=23;
			public static const talentName:Vector.<String>=new <String>["Ordinary","Deft","Clever","Ungifted","Studious","Enlightened","Powerful",
																		"Holy","Wild","Noble",
																		"Hobo","Brave","White","Hunter","Bombadier","Iron","Swift","Peasant",
																		"Dabbler","Weaver","Savior",
																		"Deftest","Holiest","Gadgeteer"];
							
		public static const WARRIOR:int=0,
							MONK:int=1,
							WIZARD:int=2,
							RANGER:int=3,
							ALCHEMIST:int=4,
							ACOLYTE:int=5,
							PALADIN:int=6,
							ROGUE:int=7,
							BERSERKER:int=8;
									
		public static function prereq(i:int):int{
			switch(i){
				case STRENGTH: return FITNESS;
				case WEAPON_SKILL: return FITNESS;
				case TOUGHNESS: return FITNESS;
				case LEAP: return STRENGTH;
				
				case FLURRY: return UNARMED;
				case KI_STRIKE: return UNARMED;
				case DTHROW: return PURITY;
				
				case FOCUS: return MAGIC_APTITUDE;
				case VESSEL: return MAGIC_APTITUDE;
				case ATTUNEMENT: return VESSEL;
				case TURNING: return FOCUS;
				
				case VITAL: return PRECISION;
				case BATTLE_AWARENESS: return PRECISION;
				case WITHDRAW: return BATTLE_AWARENESS;
				
				case DETERMINED: return IRON_GUT;
				case RADIATE: return DEADLY_ALCH;
				
				case BINDING: return PACT;
				case DEPTHS: return BINDING;
				case ECCHO: return BINDING;
				case DRAW_POWER: return PACT;
				
				case SMITE: return INITIATE;
				case GUARD: return INITIATE;
				case ALLY: return INITIATE;
				case PROTECTION: return INITIATE;
				
				case DEADLY_SHADOWS: return ONE_SHADOWS;
				case DANCING_SHADOWS: return ONE_SHADOWS;
				
				case LASTING_ANGER: return FURIOUS;
				case BLOODLUST: return LASTING_ANGER;
				case UNSTOPPABLE: return LASTING_ANGER;
				
				default: return -1;
			}
		}
		
		public static function treeSkill(tree:int,level:int=0):SkillModel{
			var _skill:SkillModel=new SkillModel;
			_skill.index=tree;
			_skill.level=level;
			
			switch(tree){
				case WARRIOR:
					_skill.values=[[SpriteModel.STAT,StatModel.PHYSEFF,0.005*level],[SpriteModel.STAT,StatModel.RPHYS,0.005*level]];
					break;
				case MONK:
					_skill.values=[[SpriteModel.STAT,StatModel.PROCEFF,0.005*level]];
					//_skill.values=[[SpriteModel.STAT,StatModel.PROCS,new EffectDamage("Ki Power",level,DamageModel.MAGICAL)]];
					break;
				case WIZARD:
					_skill.values=[[SpriteModel.STAT,StatModel.MAGICEFF,0.01*level]];
					break;
				case RANGER:
					_skill.values=[[SpriteModel.STAT,StatModel.FAR,0.005*level]];
					break;
				case ALCHEMIST:
					_skill.values=[[SpriteModel.STAT,StatModel.CHEMEFF,0.01*level]];
					break;
				case ACOLYTE:
					_skill.values=[[SpriteModel.STAT,StatModel.DARKEFF,0.01*level]];
					break;
				case PALADIN:
					_skill.values=[[SpriteModel.STAT,StatModel.HOLYEFF,0.01*level]];
					break;
				case ROGUE:
					_skill.values=[[SpriteModel.STAT,StatModel.NEAR,0.01*level]];
					break;
				case BERSERKER:
					_skill.values=[[SpriteModel.STAT,StatModel.HEALTHMULT,0.005*level]];
					break;
				default:
					throw(new Error("Invalid Skill Number: "+tree));
			}
			return _skill;
		}
		
		public static function loadSkill(s:int,i:int=0):SkillModel{
			var _skill:SkillModel=new SkillModel;
			_skill.index=s;
			_skill.level=i;
			
			switch(s){
				case FITNESS:
					//[SpriteModel.STAT,StatModel.PHYSEFF,0.01*i],
					_skill.values=[[SpriteModel.STAT,StatModel.STRENGTH,8*i],[SpriteModel.STAT,StatModel.HEALTH,22*i]];
					break;
				case STRENGTH:
					_skill.values=[[SpriteModel.STAT,StatModel.STRENGTH,11*i],[SpriteModel.ATTACK,ActionBase.CRITMULT,0.1*i]];
					break;
				case WEAPON_SKILL:
					_skill.values=[[SpriteModel.STAT,StatModel.INITIATIVE,4*i],[SpriteModel.ATTACK,ActionBase.HITRATE,8*i],[SpriteModel.STAT,StatModel.BLOCK,8*i]];
					break;
				case TOUGHNESS:
					_skill.values=[[SpriteModel.STAT,StatModel.HEALTH,40*i],[SpriteModel.STAT,StatModel.HREGEN,0.002*i]];
					break;
				case LEAP:
					_skill.values=[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.LEAP_ATTACK,i)]];
					//_skill.action=ActionData.makeAction(ActionData.LEAP,i);
					break;
				case UNARMED:
					//_skill.values=[[SpriteModel.UNARMED,ActionBase.DAMAGE,10+1.5*i],[SpriteModel.UNARMED,ActionBase.HITRATE,9*i],[SpriteModel.UNARMED,ActionBase.DODGE_REDUCE,0.01*i],[SpriteModel.UNARMED,StatModel.BLOCK,10*i],[SpriteModel.UNARMED,ActionBase.CRITMULT,0.1*i]];
					_skill.values=[[SpriteModel.UNARMED,ActionBase.DAMAGE,1*i],[SpriteModel.UNARMED,ActionBase.HITRATE,9*i],[SpriteModel.STAT,StatModel.BLOCK,10*i],[SpriteModel.UNARMED,ActionBase.EFFECT,EffectData.makeEffect(EffectData.QUICK,i)]];
					break;
				case KI_STRIKE:
					_skill.values=[[SpriteModel.UNARMED,ActionBase.DAMAGE,1*i],[SpriteModel.UNARMED,ActionBase.CRITRATE,0.012*i],[SpriteModel.STAT,StatModel.RMAGICAL,0.01*i],[SpriteModel.UNARMED,ActionBase.CEFFECT,EffectData.makeEffect(EffectData.KI_STRIKE,i)]];
					break;
				case FLURRY:
					//_skill.values=[[SpriteModel.UNARMED,ActionBase.HITRATE,4*i],[SpriteModel.UNARMED,ActionBase.EFFECT,EffectData.makeEffect(EffectData.QUICK,i)]];
					//_skill.values=[[SpriteModel.UNARMED,ActionBase.DODGE_REDUCE,0.01*i]];
					_skill.values=[[SpriteModel.UNARMED,ActionBase.DAMAGE,1*i],[SpriteModel.UNARMED,ActionBase.DODGE_REDUCE,0.01*i],[SpriteModel.STAT,StatModel.RPHYS,0.01*i],[SpriteModel.UNARMED,ActionBase.EFFECT,EffectData.makeEffect(EffectData.MASSIVE_BLOW,i)]];
					break;
				case PURITY:
					_skill.values=[[SpriteModel.UNARMORED,StatModel.INITIATIVE,i*4],[SpriteModel.UNARMORED,StatModel.DODGE,Facade.diminish(0.027,i)],[SpriteModel.UNARMORED,StatModel.TURN,Facade.diminish(0.035,i)],[SpriteModel.UNARMORED,StatModel.HREGEN,0.003*i],[SpriteModel.UNARMORED,StatModel.MREGEN,0.003*i]];
					break;
				case DTHROW:
					_skill.values=[[SpriteModel.UNARMORED,StatModel.EFFECT,EffectData.makeEffect(EffectData.DTHROW,i)]];
					break;
					
				case MAGIC_APTITUDE:
					_skill.values=[[SpriteModel.STAT,StatModel.MPOWER,8*i],[SpriteModel.STAT,StatModel.MANA,4*i]];
					break;
				case FOCUS:
					_skill.values=[[SpriteModel.STAT,StatModel.MPOWER,12*i],[SpriteModel.STAT,StatModel.MRATE,0.02*i]];
					break;
				case VESSEL:
					_skill.values=[[SpriteModel.STAT,StatModel.MANA,5*i],[SpriteModel.STAT,StatModel.MREGEN,0.005*i],[SpriteModel.STAT,StatModel.SLOTS,(i>0?1:0)+(i>=7?1:0)]];
					break;
				case ATTUNEMENT:
					_skill.values=[[SpriteModel.STAT,StatModel.RMAGICAL,0.05+Facade.diminish(0.05,i)],[SpriteModel.STAT,StatModel.RCHEMICAL,0.02+Facade.diminish(0.02,i)],[SpriteModel.STAT,StatModel.RSPIRIT,0.035+Facade.diminish(0.035,i)]];
					break;
				case TURNING:
					_skill.values=[[SpriteModel.STAT,StatModel.TURN,Facade.diminish(0.06,i)]];
					break;
					
				case PRECISION:
					_skill.values=[[SpriteModel.ATTACK,ActionBase.HITRATE,12*i],[SpriteModel.ATTACK,ActionBase.CRITRATE,0.01*i],[SpriteModel.ATTACK,ActionBase.CRITMULT,0.15*i]];
					break;
				case GADGETEER:
					_skill.values=[[SpriteModel.STAT,StatModel.INITIATIVE,4*i],[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.DOUBLESHOT,i)]];
					break;
				case BATTLE_AWARENESS:
					_skill.values=[[SpriteModel.STAT,StatModel.INITIATIVE,7*i],[SpriteModel.STAT,StatModel.DODGE,Facade.diminish(0.03,i)],[SpriteModel.STAT,StatModel.BLOCK,4*i]];
					break;
				case VITAL:
					_skill.values=[[SpriteModel.ATTACK,ActionBase.CRITRATE,0.012*i],[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.INITIAL_MARK,i)]];
					break;
				case WITHDRAW:
					_skill.action=ActionData.makeAction(ActionData.WITHDRAW,i);
					break;
					
				case IRON_GUT:
					_skill.values=[[SpriteModel.STAT,StatModel.POTEFF,0.05*i],[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.AUTOPOT,i)]];
					break;
				case DEADLY_ALCH:
					_skill.values=[[SpriteModel.STAT,StatModel.THROWEFF,0.10*i],[SpriteModel.STAT,StatModel.TRATE,0.03*i]];
					break;
				case RADIATE:
					_skill.values=[[SpriteModel.STAT,StatModel.HEALTH,12*i],[SpriteModel.STAT,StatModel.DISPLAYS,new EffectDamageRadiation("Radiation",0.01*i,DamageModel.CHEMICAL)]];
					break;
				case CRAFTING:
					_skill.values=[[SpriteModel.STAT,StatModel.ITEMEFF,0.02*i],[SpriteModel.STAT,StatModel.CRAFT_BELT,2.5*i]];
					break;
				case DETERMINED:
					_skill.values=[[SpriteModel.STAT,StatModel.RCHEMICAL,0.05+Facade.diminish(0.033,i)],[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.CLEANSE,i)]];
					break;
				
				case PACT:
					_skill.values=[[SpriteModel.STAT,StatModel.STRENGTH,6*i],[SpriteModel.STAT,StatModel.MPOWER,6*i],[SpriteModel.STAT,StatModel.INITIATIVE,6*i],[SpriteModel.ATTACK,ActionBase.HITRATE,6*i],[SpriteModel.STAT,StatModel.RSPIRIT,0-0.05]];
					break;
				case BINDING:
					_skill.values=[[SpriteModel.STAT,StatModel.HEALTH,18*i],[SpriteModel.STAT,StatModel.MANA,4*i],[SpriteModel.STAT,StatModel.RMAGICAL,0.1+Facade.diminish(0.035,i)],[SpriteModel.STAT,StatModel.RCHEMICAL,0.02+Facade.diminish(0.02,i)],[SpriteModel.STAT,StatModel.RSPIRIT,0-0.05]];
					break;
				case DEPTHS:
					_skill.values=[[SpriteModel.STAT,StatModel.CURSEMULT,0.2+0.02*i],[SpriteModel.STAT,StatModel.PROCS,new EffectDmgBoost("Dmg/Curse",i,EffectDmgBoost.NUM_CURSE,0.05+0.02*i)]];
					break;
				case ECCHO:
					_skill.values=[[SpriteModel.STAT,StatModel.DOTEFF,0.1+0.015*i],[SpriteModel.STAT,StatModel.PROCS,new EffectBuffBasic(BuffData.makeBuff(BuffData.ECCHO,i),EffectBase.CURSE,EffectBase.HURT)]];
					break;
				case DRAW_POWER:
					_skill.values=[[SpriteModel.ATTACK,ActionBase.LEECH,0.03+0.022*i],[SpriteModel.STAT,StatModel.SPELLSTEAL,0.02+0.018*i]];
					break;
				
				
				case INITIATE:
					_skill.values=[[SpriteModel.STAT,StatModel.STRENGTH,7*i],[SpriteModel.STAT,StatModel.MPOWER,7*i],[SpriteModel.STAT,StatModel.HREGEN,0.0023*i],[SpriteModel.STAT,StatModel.MREGEN,0.0023*i]];
					break;
				case SMITE:
					_skill.values=[[SpriteModel.ATTACK,ActionBase.HITRATE,8*i],[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.SMITE,i)]];
					break;
				case GUARD:
					_skill.values=[[SpriteModel.STAT,StatModel.HEALTH,25*i],[SpriteModel.STAT,StatModel.BLOCK,9*i],[SpriteModel.STAT,StatModel.RSPIRIT,Facade.diminish(0.029,i)]];
					break;
				case ALLY:
					_skill.values=[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.BUFF_BOOST,i)],[SpriteModel.STAT,StatModel.PROCS,new EffectDmgBoost("Dmg/Buff",i,EffectDmgBoost.NUM_BUFF,0.05+0.02*i)]];
					break;
				case PROTECTION:
					_skill.values=[[SpriteModel.STAT,StatModel.RCRIT,0.015+Facade.diminish(0.015,i)],[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.PROTECTION,i)]];
					break;
					
				case ONE_SHADOWS:
					_skill.values=[[SpriteModel.ATTACK,ActionBase.HITRATE,7*i],[SpriteModel.ATTACK,ActionBase.CRITMULT,0.16*i],[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.STEALTH_CMULT,i)]];
					break;
				case DEADLY_SHADOWS:
					_skill.values=[[SpriteModel.STAT,StatModel.INITIATIVE,4*i],[SpriteModel.ATTACK,ActionBase.CRITRATE,0.019*i],[SpriteModel.ATTACK,ActionBase.CEFFECT,EffectData.makeEffect(EffectData.STEALTH_CRATE,i)]];
					break;
				case DANCING_SHADOWS:
					_skill.values=[[SpriteModel.STAT,StatModel.INITIATIVE,4*i],[SpriteModel.STAT,StatModel.DODGE,0.04+Facade.diminish(0.03,i)],[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.STEALTH_DODGE,i)]];
					break;
				case ASSASSINATE:
					_skill.values=[[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.ASSASSINATE,i)]];
					break;
				case DEFENSIVE_ROLL:
					_skill.values=[[SpriteModel.STAT,StatModel.HEALTH,10*i],[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.DEFENSIVE_ROLL,i)]];
					break;
					
				case WILDERNESS:
					_skill.values=[[SpriteModel.STAT,StatModel.HEALTH,30*i],[SpriteModel.STAT,StatModel.DODGE,0.026*i],[SpriteModel.ATTACK,ActionBase.LEECH,0.015*i]];
					break;
				case FURIOUS:
					_skill.values=[[SpriteModel.STAT,StatModel.FURY,100],[SpriteModel.STAT,StatModel.FURY_DECAY,0.2],[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.FURY_MISS,i)],[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.FURY_HURT,i)],[SpriteModel.STAT,StatModel.FURYTOSTRENGTH,0.15*i],[SpriteModel.ATTACK,ActionBase.FURYTOHIT,0.1*i]];
					break;
				case LASTING_ANGER:
					_skill.values=[[SpriteModel.STAT,StatModel.FURY,5*i],[SpriteModel.STAT,StatModel.FURY_DECAY,-0.01*i],[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.FURY_INIT,i)],[SpriteModel.STAT,StatModel.FURYTORPHYS,0.0002*i],[SpriteModel.STAT,StatModel.FURYTORALL,0.0003*i]];
					break;
				case BLOODLUST:
					_skill.values=[[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.FURY_HIT,i)],[SpriteModel.ATTACK,ActionBase.FURYTOCRIT,0.0002*i],[SpriteModel.STAT,StatModel.FURYTOBASE,1]];
					break;
				case UNSTOPPABLE:
					_skill.values=[[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.FURY_DEFEND,i)],[SpriteModel.STAT,StatModel.FURYTOTENACITY,0.0002*i],[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.UNSTOPPABLE,i)]];
					break;
				default:
					throw(new Error("Invalid Skill Number: "+s));
			}
			return _skill;
		}
		
		public static function loadTalent(i:int):SkillModel{
			
			var _talent:SkillModel=new SkillModel;
			_talent.index=i;
			
			switch(i){
				case ORDINARY:
					_talent.values=[];
					break;
				case DEFT:
					_talent.values=[[SpriteModel.STAT,StatModel.DODGE,0.1],[SpriteModel.STAT,StatModel.INITIATIVE,10],[SpriteModel.STAT,StatModel.STRENGTH,-10],[SpriteModel.STAT,StatModel.MPOWER,-10]];
					break;
				case CLEVER:
					_talent.values=[[SpriteModel.STAT,StatModel.ILOOT,0.1],[SpriteModel.STAT,StatModel.ITEMEFF,0.1],[SpriteModel.STAT,StatModel.HEALTH,-25],[SpriteModel.STAT,StatModel.MANA,-25]];
					break;
				case UNGIFTED:
					_talent.values=[[SpriteModel.STAT,StatModel.RMAGICAL,0.25],[SpriteModel.STAT,StatModel.RSPIRIT,0.25],[SpriteModel.STAT,StatModel.SLOTS,-1],[SpriteModel.STAT,StatModel.MPOWER,-50]];
					break;
				case STUDIOUS:
					_talent.values=[[SpriteModel.STAT,StatModel.POTEFF,0.10],[SpriteModel.STAT,StatModel.THROWEFF,0.20],[SpriteModel.ATTACK,ActionBase.HITRATE,-20],[SpriteModel.STAT,StatModel.BLOCK,-20]];
					break;
				case ENLIGHTENED:
					_talent.values=[[SpriteModel.STAT,StatModel.MREGEN,0.04],[SpriteModel.STAT,StatModel.ITEMEFF,-0.1]];
					break;
				case POWERFUL:
					_talent.values=[[SpriteModel.STAT,StatModel.STRENGTH,25],[SpriteModel.STAT,StatModel.MPOWER,25],[SpriteModel.STAT,StatModel.RMAGICAL,-0.1],[SpriteModel.STAT,StatModel.RCHEMICAL,-0.1],[SpriteModel.STAT,StatModel.RSPIRIT,-0.1]];
					break;
				case HOLY:
					_talent.values=[[SpriteModel.STAT,StatModel.HOLYEFF,0.1],[SpriteModel.STAT,StatModel.RSPIRIT,0.1]];
					break;
				case WILD:
					_talent.values=[[SpriteModel.STAT,StatModel.DRANGE,0.5]];
					break;
				case NOBLE:
					_talent.values=[];
					break;
				case HOBO:
					_talent.values=[[SpriteModel.STAT,StatModel.HEALTH,-50]];
					break;
				case BRAVE:
					_talent.values=[[SpriteModel.STAT,StatModel.STRENGTH,50],[SpriteModel.STAT,StatModel.MPOWER,50]];
					break;
				case WHITE:
					_talent.values=[[SpriteModel.STAT,StatModel.HOLYEFF,0.25],[SpriteModel.STAT,StatModel.IRATE,-0.1]];
					break;
				case HUNTER:
					_talent.values=[[SpriteModel.STAT,StatModel.IRATE,0.5],[SpriteModel.STAT,StatModel.MANA,-100],[SpriteModel.STAT,StatModel.MREGEN,-0.02]];
					break;
				case GRENADIER:
					_talent.values=[[SpriteModel.STAT,StatModel.THROWEFF,0.50],[SpriteModel.STAT,StatModel.MANA,-100],[SpriteModel.STAT,StatModel.STRENGTH,-30]];
					break;
				case IRON:
					_talent.values=[[SpriteModel.STAT,StatModel.BLOCK,100]];
					break;
				case SWIFT:
					_talent.values=[[SpriteModel.STAT,StatModel.DODGE,0.15]];
					break;
				case PEASANT:
					_talent.values=[[SpriteModel.STAT,StatModel.MPOWER,100]];
					break;
				case DABBLER:
					_talent.values=[];
					break;
				case WEAVER:
					_talent.values=[[SpriteModel.STAT,StatModel.MREGEN,0.05],[SpriteModel.STAT,StatModel.HREGEN,0.05]];
					break;
				case SAVIOR:
					_talent.values=[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.RANDOM_COLOR,0)]];
					break;
				case SEASON1_DEFT:
					_talent.values=[[SpriteModel.STAT,StatModel.DODGE,0.1],[SpriteModel.STAT,StatModel.INITIATIVE,10],[SpriteModel.STAT,StatModel.STRENGTH,-10],[SpriteModel.STAT,StatModel.MPOWER,-10],[SpriteModel.ATTACK,ActionBase.HITRATE,120],[SpriteModel.ATTACK,ActionBase.CRITRATE,0.14]];
					break;
				case SEASON1_HOLY:
					_talent.values=[[SpriteModel.STAT,StatModel.HOLYEFF,0.1],[SpriteModel.STAT,StatModel.RSPIRIT,0.1],[SpriteModel.STAT,StatModel.INITIATIVE,50],[SpriteModel.STAT,StatModel.ITEMEFF,0.5],[SpriteModel.STAT,StatModel.IRATE,0.1]];
					break;
				case SEASON1_GADG:
					_talent.values=[[SpriteModel.STAT,StatModel.DODGE,0.1],[SpriteModel.STAT,StatModel.INITIATIVE,10],[SpriteModel.STAT,StatModel.STRENGTH,-10],[SpriteModel.STAT,StatModel.INITIATIVE,50],[SpriteModel.STAT,StatModel.ITEMEFF,0.5],[SpriteModel.STAT,StatModel.IRATE,0.1]];
					break;
				default:
					throw(new Error("Invalid Talent Type: "+i));
			}
			return _talent;
		}

		public static function getTreeAssignment(skillA: Array):Array{
			//a: SkillModel[];
			var m:Array=new Array(NUM_TREES);
			for (var i:int=0;i<m.length;i+=1){
				m[i]=0;
			}

			for (i=0;i<skillA.length;i+=1){
				m[Math.floor(i/5)]+=skillA[i].level;
			}

			return m;
		}
	}
}