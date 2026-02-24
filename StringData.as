package{
	import skills.SkillData;
	import skills.SkillView;
	import items.ItemData;
	import items.ItemView;
	import items.ItemModel;
	import artifacts.ArtifactModel;
	import artifacts.ArtifactView;
	import artifacts.ArtifactData;
	import system.buffs.BuffData;
	import utils.GameData;
	import skills.SkillModel;
	import system.actions.ActionBase;
	import system.actions.ActionData;
	import system.effects.EffectBase;
	import system.effects.EffectData;
	import skills.SkillTreeView;

//Also text in the following files
//LibraryUI.as
//EndWindow.as
//AchievementDisplay.as

//fix logic of MouseClick in LoadCharacterUI/LoadObject
//sponsor update HallUI.as, MainUI.as
//secret codes: NewCharacterUI.as

	public class StringData{
		public static const ADVENTURE:String="Adventure",
							HOME:String="Hero's Home",
							SHOP:String="Shop",
							BLACK_MARKET:String="Black Market",
							GAMBLE:String="Gamble",
							UPGRADE:String="Upgrade",
							RESTACK:String="Fill Item",
							LIBRARY:String="Library",
							HALL:String="Hall of Heroes",
							DUEL:String="Dueling Arena",
							ARCADE:String="Arcade",
							COLOURS:String="Colours",
							EXHIBITION:String="Exhibition",
							MONSTER:String="Monster Arena",
							FILLSTACK:String="Fill Stack",
							FILLALL:String="Fill Belt",
							
							ACTIONS:String="Actions",
							STATS:String="Stats",
							STASH:String="Stash",
							SKILLS:String="Skills",
							SKILL_SCROLL:String="Change Page",
							INVENTORY:String="Items",
							NEW_CHAR:String="New Character",
							LOAD_CHAR:String="Load Character",
							CHALLENGE:String="Challenge",
							SEASON1:String="Season 1",
							
							IMPORT:String="Import",
							EXPORT:String="Export",
							
							STATUS:String="Statistics",
							CLOSE_WINDOW:String="Close Window",
							DONE:String="Done",
							LEAVE:String="To Town",
							REVIVE:String="Revive!",
							LETSGO:String="Let's Go!",
							ERASE:String="Erase Data",
							ONLINE:String="Online",
							DISABLE_TUTORIAL:String="Disable Tutorial",
							
							PAUSE:String="Pause",
							UNPAUSE:String="Unpause",
							TURBO:String="Turbo",
							QUALITY:String="Quality",
							MUTE:String="Mute",
							UNMUTE:String="Unmute",
							AUTO:String="Auto",
							SEMI:String="Active",
							MANUAL:String="Manual",
							TOWN:String="Go To Town",
							
							NEXT_PAGE:String="Next Page",
							PREV_PAGE:String="Prev Page",
							TABLE_CONTENTS:String="ToC",
							
							CONTINUE:String="Continue",
							RESPEC:String="Respec",
							
							YES:String="Yes",
							NO:String="No",
							SAVE:String="Done",
							CANCEL:String="Cancel",
							FIGHT:String="Fight!",
							
							REFRESH:String="Refresh",
							
							ASCEND:String="Ascend!",
							NO_ASCEND:String="Ascend",
							
							NONE:String="     ",
							NEVER:String="Never",
							ALWAYS:String="All",
							BETWEEN:String="Safe",
							COMBAT:String="Fight",
							VERY:String="Far",
							FAR:String="Mid",
							NEAR:String="Near",
							NEAR_AW:String="NEAR",
							FAR_AW:String="MID",
							VERY_AW:String="FAR",
							SAFE_AW:String="SAFE";
								
		public static const TYPE:String="TYPE",
							USERATE:String="USERATE",
							DAMAGE:String="DAMAGE",
							EFFECTS:String="EFFECTS:",
							CEFFECTS:String="CRIT:",
							HITRATE:String="HIT",
							CRITRATE:String="CRIT",
							CRITMULT:String="C.MULT",
							MANA:String="MANA",
							HEALING:String="HEALING",
							
							EFFECT:String="Effect",
							CEFFECT:String="CEffect",

							PHYSICAL:String="PHYS",
							MAGICAL:String="MAGI",
							CHEMICAL:String="CHEM",
							HOLY:String="HOLY",
							DARK:String="DARK",

							SELF:String="Self",
							ENEMY:String="Enemy",
							
							EQUIPMENT:String="EQUIPMENT",
							
							LIVES:String="Lives";

		public static var PTITLES:Vector.<String>=new <String>["Fighter","Warrior","Hardened",
								 "Brawler","Monk","Centered",
								 "Mage","Wizard","Gifted",
								 "Scout","Ranger","Wandering",
								 "Alchemist","Scientist","Brewing",
								 "Cultist","Acolyte","Dark",
								 "Initiate","Paladin","Light",
								 "Sneak","Rogue","Hidden",
								 "Rager","Berserker","Enraged"];
		
		public static var PTITLES2:Array=[["Warrior","Gladiator","Spellsword","Mercenary","Trooper","Reaper","Knight","Bandit","Ironguard"],
										["Enforcer","Monk","Kuji","Seeker","Drunken Master","Nightmare","Sifu","Spy","Bouncer"],
										["Warmage","Mystic","Wizard","Wuss","Librarian","Warlock","Exorcist","Illusionist","Stormchanter"],
										["Duelist","Dervish","Warden","Ranger","Hunter","Dusk","Nazir","Bountyhunter","Survivor"],
										["Grenadier","Brewmaster","Magister","Herbalist","Scientist","Locusta","Friar","Toxicologist","Frustrated"],
										["Doombringer","Fanatic","Occultist","Flayer","Scryer","Acolyte","Gatemaster","Vizir","Horror"],
										["Templar","Avenger","Seer","Harrier","Meister","Zealot","Paladin","Undertaker","Blatherer"],
										["Instigator","Ninja","Trickster","Thief","Hacker","Assassin","Masquerade","Rogue","Seether"],
										["Destroyer","Brute","Rage Mage","Barbarian","Psychotic","Chaotical","Executioner","Hurricane","Berserker"]];
										
		
		public static const enemyType:Vector.<String>=new <String>["Goblin","Savage","Demon","Shadow"];
		public static const areaType:Vector.<String>=new <String>["Woods","Wastes","Realm","World"];
		
		/*public static const YELLOW:uint=0xFFF43F,
							DARK_RED:uint=0x9F400D,
							RED:uint=0xFF6F23,
							BLACK:uint=0x210D02,
							SEPIA:uint=0x0000AA;*/
							
		public static const YELLOW:String="'#EADF78'",
							DARK_RED:String="'#9f400d'",
							//RED:String="'#ff6f23'",
							//RED:String="'#cc0000'",
							RED:String="'#990502'", //Non Tooltips
							RED2:String="'#fc3841'", //Tooltips
							BLACK:String="'#452411'",
							SEPIA:String="'#0000AA'",
							DEFAULT:String="'#FFF43F'",
							GREEN:String="'#44CC5E'",
							TEAL:String="'#43CBFF'",
							NEUTRAL:String="'#b1875b'";
							
		public static const U_NEUTRAL:uint=0xb1875b,
							U_BROWN:uint=0x452411, 
							U_RED:uint=0x990502,
							U_YELLOW:uint=0xEADF78,
							//U_BLACK:uint=0x210D02;
							U_BLACK:uint=0x452411;
							
		public static const FONT_SYSTEM:String="Garamond",
							FONT_FANCY:String="Kingthings Petrock",
							FONT_FANCY_LIGHT:String="Kingthings Petrock Light";
		
		public static function skillTree(i:int):String{
			switch(i){
				case SkillData.WARRIOR: return "Mixture of Offense and Defense";
				case SkillData.MONK: return "Unarmed warrior with mystic tendencies";
				case SkillData.WIZARD: return "Specialized spellcaster and destroyer.";
				case SkillData.RANGER: return "Ranged Master and Critical Thinker.";
				case SkillData.ALCHEMIST: return "Many tricks and many treats.";
				case SkillData.ACOLYTE: return "Made a deal with darkness for more power.";
				case SkillData.PALADIN: return "Made a deal with the light for more power.";
				case SkillData.ROGUE: return "Master of shadows and lethality.";
				default: return null;
			}
		}
		
		public static function skill(i:int):String{
			with (skills.SkillData){
				switch(i){
					case FITNESS: return "Working out makes you physically fit.";
					case STRENGTH: return "Strength training has given your attacks great potential.";
					case WEAPON_SKILL: return "Your weapons training has made you a formidable foe.";
					case TOUGHNESS: return "You have trained your body to withstand even the mightiest blows.";
					case LEAP: return "True flight is one step closer.";
					case UNARMED: return "You fight better without weapons.\n\n<font color="+GREEN+">UNARMED OR GLOVES</font>";
					case KI_STRIKE: return "Your inner strength is unleashed.\n\n<font color="+GREEN+">UNARMED OR GLOVES</font>";
					case FLURRY: return "Your blows are fierce, your hands deadly.\n\n<font color="+GREEN+">UNARMED OR GLOVES</font>";
					case PURITY: return "You are able to avoid all attacks.\n\n<font color="+GREEN+">UNARMOURED OR AGILE HELMET</font>";
					case DTHROW: return "Your opponent's strength can easily become your own.\n\n<font color="+GREEN+">UNARMOURED OR AGILE HELMET</font>";
					case MAGIC_APTITUDE: return "Your spiritual eye opens to reveal what lies beyond.";
					case FOCUS: return "Your mind hones in like a hawk swooping for its prey.";
					case VESSEL: return "Your soul becomes empty and ready to receive.";
					case ATTUNEMENT: return "Magical energies course through you harmlessly regardless of the source.";
					case TURNING: return "Your mind is ever alert, your skin tingling as magical powers manifest.";
					case PRECISION: return "Your mind is sharp, your aim is true.";
					case GADGETEER: return "Your hand is quicker than your opponent's eye.";
					case BATTLE_AWARENESS: return "After a lifetime of practice you have developped a 6th sense for danger.";
					case VITAL: return "A hunter must know how to strike for maximum potential.";
					case WITHDRAW: return "The key to staying alive is staying out of danger.";
					case IRON_GUT: return "Years of trial and error have kept your stomach in top form.";
					case DEADLY_ALCH: return "Your knowledge of science is incredible.";
					case RADIATE: return "You literally glow with power.";
					case CRAFTING: return "You are a walking laboratory.";
					case DETERMINED: return "Nothing can stop your inner power.";
					case PACT: return "You share a bit of your soul in exchange for power.";
					case BINDING: return "You join with Shadow to destroy it.";
					case DEPTHS: return "When the light fades, darkness remains.";
					case ECCHO: return "Your soul reverberates constantly within the void.";
					case DRAW_POWER: return "You have learned to pull at the darkness of others.";
					case INITIATE: return "You bind your soul to the Highest Power.";
					case SMITE: return "Darkness is crushed beneath the weight of your might.";
					case GUARD: return "Your skin tingles with power and your confidence grows.";
					case ALLY: return "As your soul grows strong your power increases.";
					case PROTECTION: return "You are surrounded by love and light.";
					case ONE_SHADOWS: return "You meld effortlessly into your surroundings";
					case DEADLY_SHADOWS: return "You strike quickly and precisely";
					case DANCING_SHADOWS: return "You move with the darkness, disappearing from view";
					case ASSASSINATE: return "You first cut strikes deepest.";
					case DEFENSIVE_ROLL: return "You move with your opponent and turn blows aside";
					default: return null;
				}
			}
		}
		
		public static function artifact(i:int):String{
			switch(i){
				case 0: return "A small piece of greatness is still greatness";
				case 1: return "Ashes, when stoked, may burn once again";
				case 2: return "Wild flames destroy, controlled they create";
				case 3: return "One who is tested is one who is strong";
				case 4: return "A low flame is a lasting one";
				
				case 5: return "Fluttering softly in the sky";
				case 6: return "the golden glow luminesces";
				case 7: return "wrapping around you softly";
				case 8: return "with warmth and comfort";
				case 9: return "inspiring your journey";
				
				case 10: return "Your soul is opened and divine power flows through";
				case 11: return "Your mind is filled with images of the unseen";
				case 12: return "Your heart is warmed and clings to goodness";
				case 13: return "Your soul burns with a new and greater power";
				case 14: return "Your essence is firm, your substance is hardened";
				
				case 15: return "A celestial arm guides your aim";
				case 16: return "A glowing disk escorts you safely";
				case 17: return "You are surrounded by warmth, while others feel flame";
				case 18: return "A layer of force rests upon your skin";
				case 19: return "The heavens scream out, chanting your name";
				
				case 20: return "Through the deep meadows of wonder and bliss";
				case 21: return "As a warm breeze caressing an old willow";
				case 22: return "The reeds of a pond drip softly, echoing deeply";
				case 23: return "Before you is an open field and a single majestic oak";
				case 24: return "A single leaf falls, drifting endlessly, swaying softly";
				
				case 25: return "Veins of power flow across your skin, imbuing you with strength";
				case 26: return "Your eyes shine bright with dark precision";
				case 27: return "Your fangs grow long, your ferocity grows deep";
				case 28: return "Your belly fills with power, the air tingles with excitement";
				case 29: return "Your arms pulse and bulge, your fingers exude power";
				
				case 30: return "A deep almost black substance, oddly delicate";
				case 31: return "Luminescent ooze of viscous and active properties";
				case 32: return "Scarlet frothing and bubbling, vibrant and still hot";
				case 33: return "The vial is reinforced with extreme enchantments";
				case 34: return "The colours and movements are indescribably breathtaking";
				
				case 35: return "Falsehood, security and the blissful ignorance of illusion";
				case 36: return "Knowledge, freedom and the (sometimes painful) truth of reality";
				case 37: return "Do not try and bend the spoon. That's impossible. Instead only try to realize the truth.";
				case 38: return "Show me.";
				case 39: return "When you're ready, you won't have to.";
			}
			return "";
		}
		
		public static function talent(i:int):String{
			with (skills.SkillData){
				switch(i){
					case ORDINARY: return "You are a regular nobody who comes from a small town in the middle of nowhere.";
					case DEFT: return "Your speed and stealth are legendary.";
					case CLEVER: return "You have an eye for valuables and a love of utilities.";
					case UNGIFTED: return "Sages are baffled by the way magic avoids you.";
					case STUDIOUS: return "Other scientists gawk at your accomplishments.";
					case ENLIGHTENED: return "Seekers of truth and power flock to you, hoping for answers.";
					case POWERFUL: return "Tales of your might are spoken in taverns across the land.";
					case HOLY: return "You are known as a man of piety and honour.";
					case WILD: return "Your unusual fighting style makes others wary of you.";
					case NOBLE: return "You were born to a wealthy family with many resources.";

					default: return null;
				}
			}
		}
		
		public static function enemy(s:String):String{
			with (EnemyData){
				switch(s){
					case CHIEF: return "Strong and Tough leader of the goblins.";
					case BOAR: return "The biggest and quickest pig you've ever seen.";
					case BEEZELPUFF: return "Demonic spellcaster of great power.";
					case FIGHTER: return "Fighters are masters of melee combat who hack through their foes.";
					case BRUTE: return "Elite goblin martial artist";
					case SHAMAN: return "Shamans use their magical abilities to weaken and then kill their foes.";
					case ALCHEMIST: return "Alchemists use chemical weapons to cause great damage.";
					case VINE: return "Vines attack and defend with random properties.";
					case BLOB: return "Blobs cause chemical damage and easily avoid damage.";
					case DRAGON: return "Dragons Deal massive aligned damage.";
					case RHINO: return "Rhinos are big and tough and some can work themselves into a frenzy.";
					case TIGER: return "Tigers are strong and swift.";
					case WHELP: return "Whelps deal bonus aligned damage and are resistant.";
					case WOLF: return "Wolves are swift and resiliant.";
					case IMP: return "Imps are creatures of magic.";
					case HELLING: return "Swift spiky killers of all.";
					case GOLEM: return "Slow, Stupid, yet powerful.";
					case FLAMBERT: return "A horse made of pure energy.";
					case SKELETON: return "Back from the dead to kick butt.";
					default: return null;
				}
			}
		}
		
		/*public static function buff(s:String):String{
			with (BuffData){
				switch(s){
					case BURNED: return "Takes magic damage over time.";
					case POISONED: case POISONED2:
						return "Takes magic damage over time.";
					case GASSED: return "Takes chemical damage over time.";
					case BOMB: return "Explodes after 1 turn.";
					case IVY: return "Deals damage over time that scales with GRENADE and prevents enemy from moving.";
					case ECCHO: return "Deals Damage over time when you deal Direct Damage, scaling with MPow.";
					case SPINES: return "Deals chemical damage over time.";
					case DELAYED_DAMAGE: return "Deals a percent of damage dealt after your opponent's next action.";
					case BLEEDING: return "Will take massive physical damage..";
					case PHOENIX_PROC: return "Deals damage over time when you successfully damage or debuff an opponent.";
					case PHOENIX_THORNS: return "Deals damage over time to enemies at Near range.";
					case PROTECTION: return "Heals you over time when you are injured.";
					case REND: return "Deals Physical Damage over time.";
					case REND_HEAL: return "Physical Healing over time.";
					case CRIT_ACCUM: return "Gain a stacking Crit Rate bonus every time you fail to crit.";
					case EMPOWERED: return "Magic power is increased.";
					case EMPOWERED2: return "Strength is increased.";
					case EMPOWERED3: return "Initiative is increased.";
					case HASTENED: return "Has initiative and dodge rate increased.";
					case SLOW: return "Has initiative and dodge rate reduced.";
					
					case ENCHANTED: return "Adds magic damage on every attack.";
					case ENCHANTED2: return "Adds holy damage on every attack.";
					case ENCHANTED3: return "Adds physical damage, Hit and Crit.";
					case SHIELD: return "Prevents up to this amount of damage next time you receive damage.";
					case SMITE_PROC: return "Deals massive Holy Damage when you deal damage.";
					case BARRIER: return "Protects you from incoming damage.";
					
					case STRENGTHEN: return "Makes you stronger and deal more damage.";
					case BUFF_POT: return "You have been empowered through alchemical wonders.";
					case CELERITY_POT: return "Accelerates you through Science!";
					case TURTLE_POT: return "Increases your defenses and gives you a bit of Return Damage.";
					case PURITY_POT: return "Simulates enlightenment with fancy drugs.";
					case MOVE_BOOST: return "Increased stats after using a Movement Ability.";
					case COMBO: return "Increases further damage this round every time you hit.";
					case COMBO_DEFENSE: return "Increases your defenses every time you hit.";
					case COOLDOWN: return "Has reduced stats temporarily.";
					case INITIAL_BLESS: return "Buffs you for a number of turns when you first encounter an enemy.";
					case INITIAL_CURSE: return "Curses enemy for a number of turns when you first encounter them.";
					case GRAILED: return "Increases Health Regeneration by a significant amount.";
					case SAYAN: return "Normal mode";
					case SUPER_SAYAN: return "Powered up after you revive until you defeat your enemy.";
					
					case BERSERK: return "Has more powerful attacks but is unable to take complicated actions.";
					
					case RUSHED: return "Your next attack is made with a penalty to hit your opponent.";
					case QUICK: return "Chance to make a bonus attack when you hit with your first melee attack(s).";
					case DOUBLESHOT: return "Chance to make a bonus ranged attack or throw an additional projectile or grenade.";
					case AIMING: return "Your next attack is made with a bonus to hit your opponent.";
					case LEAP_ATTACK: return "Leap at your opponent with increased base weapon damage.";
					
					case WEAKENED: return "Has decreased damage.";
					case HEAL_NO: return "Has significantly reduced healing.";
					case VULNERABLE: return "Has resistances decreased.";
					case VULNERABLE2: return "Has physical resistance decreased.";
					case SCORCHED: return "Reduces Magic Resistance.";
					case ILLUMINATED: return "Reduces Spirit Resistance.";
					case WHISPERED: return "Reduces Enemy Resistance to Magic, Chemical and Holy.";
					case CURSED: return "Has a reduced Hit Rate.";
					case BLIND: return "Your eyes blur making it difficult to hit your target.";
					case RESPECT: return "Enemy has reduced Dodge and Nullify when you defend.";
					case AUTHORITAH: return "Enemy deals reduced Base Damage for their next action.";
					case ATTACK_IGNORED: return "You have already ignored an attack this fight.";
					case HIGH: return "Your Health and Mana Regen are increased.";
					case MARKED: return "Has reduced Dodge and Critical Resistance.";
					case STEALTH: return "Has increased Dodge, CRate and CMult.  Stealth is lost when you make an offensive action, are Cursed or Injured.";
					
					case GOLEM_CONFUSED: case CONFUSED: case DISORIENTED: return "Chance of not acting.";
					case STUNNED:
					case ASLEEP: return "Cannot act.";
					case AFRAID: return "Running in terror from opponent.";
					
					case SILENCED: return "Can't cast magic spells.";
					case ROOTED: return "Cannot move forwards or backwards on your own.";
					
					case UNDYING: 
					case DYING: return "Can survive below 0 health for a number of turns.";
					case REVIVED: return "You have already revived this fight and cannot revive again.";
					
					case TOWN: return "You will go to town after this battle.";
					case XP_BOOST: return "Gain extra Experience and Gold.";
					case PROGRESS_BOOST: return "Every monster kill counts as two for Level Progress, XP and Loot.  Multiplies with XP Boosts!  Gained from Offline Hours.";
					
					default: return null;
				}
			}
		}
		public static function effect(s:String):String{
			with (EffectData){
				switch(s){
					case BURN: //return "Deals magic damage over time.";
					case POISON: case POISON2:
						return "Deals magic damage over time.";
					case STUN: return "Makes your opponent unable to act.";
					case ENERVATE: return "Decreases your opponent's resistance to damage.";
					case WEAKEN: return "Decreases opponent's primary damage.";
					case HEAL_NO: return "Significantly reduces opponent's HEAL.";
					case CONFUSE: return "Chance every turn that your opponent will not act.";
					case DISORIENT: return "When you hit your opponent with a Belt Item, chance for them to not act next turn.";
					case POISON_GAS: return "Deals chemical damage over time."
					case BOMB: return "Explodes after 1 turn.";
					case ECCHO: return "Deals Damage over time when you deal Direct Damage, scaling with MPow.";
					
					case BLIND: return "Your eyes blur making it difficult to hit your target.";
					case SPINES: return "Deals chemical damage over time.";
					
					case TERRIFY: 
					case TERRIFYING: return "Causes enemies to flee in terror.";
					case IVY: return "Deals damage over time that scales with GRENADE and prevents enemy from moving.";
					
					case PHOENIX_PROC: return "Deals damage over time when you successfully damage or debuff and opponent.";
							
					case ENCHANT: return "Imbues your Weapon Attacks and Projectiles.";
					case EMPOWER: return "Increases your effectiveness.";
					case HASTEN: return "Increases your dodge rate and initiative.";
					case SLOW: return "Reduces enemy dodge rate and initiative.";
					case SHIELD: return "Prevents up to this much damage next time you would receive damage.  Cast with 3 stacks";
					
					case BUFF_POT: return "You have been empowered through alchemical wonders.";
					case CELERITY_POT: return "Accelerates you through Science!";
					case TURTLE_POT: return "Increases your defenses and gives you a bit of Return Damage.";
					case PURITY_POT: return "Simulates enlightenment with fancy drugs.";
					
					case RUSHED: return "Your next attack is made with a penalty to hit your opponent.";
					case AIMING: return "Your next attack is made with a bonus to hit your opponent.";
					case LEAP_ATTACK: return "Leap at your opponent with increased base weapon damage.";
					
					case ARCANE: return "Adds Magic Damage any time you deal damage from any source.";
					case ENCHANTED: return "Adds magic damage on every attack.";
					case CRITBONUS: return "Extra damage dealt on critical hits";
					case FLAMING: case SCORCHING: return "Bonus magic damage dealt on each strike.";
					case BLAZING: return "Bonus chemical damage dealt on each strike.";
					case FULL_POWER: return "When you are over 75% Health, deals bonus Magic Dmg and can attack from Mid or Far Range.";
					case FULL_POWER2: return "When you are over 75% Health, deals bonus Magic Dmg";
					case CORRUPTED: return "";
					case BRILLIANT: case LUMINANT: return "Bonus holy damage dealt on each strike.";
					case VENOMOUS: return "Bonus chemical damage dealt on each strike.";
					case EXPLOSIVE: return "Deals bonus magic damage on critical hits.";
					case SMITE: return "Deals massive Holy Damage when you deal damage every number of rounds.";
					case SMITE_PROC: return "Deals massive Holy Damage when you deal damage.";
					
					case QUICK: return "Chance to make a bonus attack when you hit with your first melee attack(s).";
					case DOUBLESHOT: return "Chance to make a bonus ranged attack or throw an additional projectile or grenade.";
					case KI_STRIKE: return "Deal damage on critical hits based on mana spent. Scales off of MPOW.";
					case SMASH: return "High chance to stun your opponent on critical hits.";
					case CURSE: return "Reduces target's hit rate.";
					case SACRIFICE: return "Deals a percent of damage dealt to yourself.";
					case DAZZLE: return "Chance to stun the target.";
					case KNOCKBACK: return "Sends target flying back to Mid Range distance and stuns for 1 round.";
					case KNOCKBACK_NO: return "Sends target flying back to Far Range without stunning.";
					case KNOCKBACK_MINOR: return "Knocks the target back to Mid Range without stunning.";
					case KNOCKBACK_REVERSED: return "Pulls the enemy forward to Near Range without stunning.";
					case CRIT_ACCUM: return "Gain a stacking Crit Rate bonus every time you fail to crit.";
					case MANA_HEAL: return "Recover mana whenever you directly damage an enemy.";
					case MPOW_HEAL: return "Chance to recover your MPow in Health when you directly damage an enemy.";
					case NONCRIT: return "Increased Non-Critical Damage with Weapons and Projectiles";
					case BLEED: return "Deals a percent of critical damage as physical damage every round.";
					case DELAYED_DAMAGE: return "Deals a percent of damage dealt after your opponent's next action.";
					case REMOVE_BUFF: return "Destroy a number of buff turns off of your enemy when you successfully damage or debuff an opponent.";
					
					case FEAR_BOOST: return "Increases Direct Damage against Feared targets.";
					case NEAR_DMG_BOOST: return "Increases Direct Damage while at NEAR Range";
					case RANDOM_DMG_BOOST: return "Chance to Increase or Decrease Direct Damage by up to this amount every cast.";
					case BUFF_DMG_BOOST: return "Increases Direct Damage for every unique Buff applied to you.";
					case CURSE_DMG_BOOST: return "Increases Direct Damage for every Debuff or Debuff Stack applied to your target.";
					
					case COMBO: return "Increases further damage this round every time you hit.";
					case COMBO_DEFENSE: return "Increases your defenses every time you hit.";
					case COOLDOWN: return "Has reduced stats temporarily.";
					case AUTHORITAH: return "Enemy deals reduced Base Damage for their next action.";
					case SCORCHED: return "Reduces Magic Resistance.";
					case ILLUMINATED: return "Reduces Spirit Resistance.";
					case WHISPERED: return "Reduces Enemy Resistance to Magic, Chemical and Holy when you successfully damage or debuff your opponent..";
					case REND: return "Deals Physical Damage over time.";
					case REND_HEAL: return "Physical Healing over time.";
					case RANDOM_BUFF: return "Casts a random Buffing Potion effect on you at the listed level.";
					
					case MINOTAUR: return "Once per round, if no attack hits, chance to Knockback and Stun when an enemy blocks from Near Range.";
					case RADIANT_PULSE: return "If the enemy blocks your attack, deal a percent of your Primary Damage as Holy Damage.";
					case RADIANCE: return "When you block an enemy attack or projectile, deal Holy Damage.";
					
					case INITSCALING: return "Adds a percent of your bonus Initiative as a multiplier to Strength Items, or a percent of your bonus Strength to Initiative Items.";
					case MPOWSCALING: return "Uses your MPow as your weapon multipier instead of Strength.";
					case INIT_SPELL: return "Uses a percent of your bonus Initiative in addition to MPow as a multiplier for spells.";
					case MPOWSCALINGADD: return "Adds a percent of your bonus MPow as a multiplier to Weapon Damage.";
					case MULTI: case CHAIN: return "Increased number of hits";
					case AWARD: return "Grants +1 XP Per Kill."; 
					
					case INITIAL_BLESS: return "Buffs you for a number of turns when you first encounter an enemy.";
					case INITIAL_CURSE: return "Curses enemy for a number of turns when you first encounter them.";
					case INITIAL_SPELL: return "Uses this spell once at the beginning of combat for free.";
					case FREE_SPELL: return "Casts this spell without using an action but with greatly reduced effect.  Reduces your mana by the spell's Mana Cost.";
					case INITIAL_MARK: return "Places a curse on your opponent at the beginning of combat.";
					
					case SPIKEY: return "Returns damage to melee attackers when you are Hit or when you Block.";
					case STRENGTHEN: return "Makes you stronger and deal more damage.";
					case BERSERKER: return "Chance to become berserk when hurt or debuffed, gaining bonus strength but only being able to attack.";
					case FEARSOME: return "Chance to cause fear when hurt and make attackers run in terror.";
					case BEFUDDLE: return "Chance to affect your attacker when you are hurt.";
					case MUTE: return "Chance to prevent enemy from casting spells when you nullify a spell.";
					case DTHROW: return "When you avoid damage at close range, chance to stun your opponent.";
					case AUTOPOT: return "Chance to drink when dropping below 50% Health or Mana.";
					case AUTOBUFF: return "Chance to drink a non-active buffing potion when you are dealt damage.";
					case AUTOBUFFFREE: return "Chance to automatically gain a buff when you are dealt damage.";
					case ROOT: return "When you are struck or debuffed the enemy is prevented from moving.";
					case RESPECT: return "Enemy has reduced Dodge and Nullify when you defend.";
					case PROTECTION: return "Heals you over time when you are injured.";
					case BARRIER: return "Creates a Barrier stack every round which reduces damage taken.  Also scales with HEAL.";
					case BUILD_WALL: return "A percent of damage taken will be used to reduce the next amount of damage taken.";
					case ASSASSINATE: return "Deal increased direct damage based on target's current health.";
					
					case RADIATION: return "Deals % of your current health in CHEM damage to enemies NEAR you.";
					case PHOENIX_THORNS: return "Deals damage over time to enemies at Near range.";
					case CLEANSE: return "Chance to reduce a random debuff's duration by 1 each turn.";
					case CLEANSE_HEAL: return "Removes 1 debuff turn on successful cast.";
					case REVIVE_GRAIL: return "Revive after death with a percent of your health and Health Regen buff.  Only one revive of any type can occur per fight.";
					case HEAL_GRAIL: return "Greatly increased your HReg.";
					case REVIVE_JUST:
					case REVIVE_PHOENIX: return "Revive after death with a percent of your maximum health.  Only one revive of any type can occur per fight.";
					case REVIVE_GOKU: return "Revive after death and become Super Sapien!  Only one revive of any type can occur per fight.";
					case MANA_SHIELD: return "When you would take lethal damage, Mana is consumed instead of Health";
					case DEFENSIVE_ROLL: return "When you take any form of damage, succeed on a Dodge Roll to reduce damage taken.";
					case FEATHER_HIT: return "Your first attack every round has bonus Hit.";
					case HIGH: return "Increased regeneration between battles and for the first few turns of combat.";
					case IGNORE_ATTACK: return "Ignore the first successful action from your enemy.";
					case UNARMED_INIT: return "Use Initiative instead of Strength for Unarmed Damage.";
					
					case UNDYING: return "Can survive below 0 health for a number of turns. Cannot revive through other means.";
					case FIND_STACKS: return "Chance to refill Belt Items after defeating an opponent.";
					case BASE_DMG: return "Improves the weapon's Base Damage.";
					case MOVE_BOOST: return "Gain a buff after using a Movement Ability.";
					case CURSE_REFLECT: return "Chance to reflect any cursing Spell or Potion onto your enemy.";
					case BUFF_REFLECT: return "Chance to steal any Buffing Spell or Potion from your enemy on cast.";
					
					case SPELL_BOOST: return "Chance to boost the level of any spell you cast.";
					case BUFF_POT_BOOST: return "Boosts the level of buffing potions you drink.";
					case BUFF_BOOST: return "Increases effectiveness of your buffing Spells and Items.";
					case DREAM: return "Chance to put the enemy to sleep for one round whenever you take a non-offensive action.";
					
					case STEALTH_CMULT: return "Increases your Crit Mult while stealthed.\n\n*Grants Stealth at the start of combat.\n\n*Stealth is lost when you make an offensive action, are Cursed or Injured.";
					case STEALTH_CRATE: return "Increases your Critical Rate while stealthed.\n\n*Grants you Stealth at the end of your turn if you Critically Hit.";
					case STEALTH_DODGE: return "Increases your Dodge Rate while stealthed.\n\n*Grants you Stealth whenever you Dodge.";
					
					case MAGIC_STRIKE: return "Chance to make a Basic Attack after casting a spell.";
					case GRENADE_STRIKE: return "Chance to make a Basic Attack after using a Grenade.";
					case BUFFPOT_STRIKE: return "Chance to make a Basic Attack after using a Buffing Potion.";
					
					case STRIKE: return "Make a bonus strike against your opponent after this action.";
					case ACT: return "Take a bonus action.";
					case WITHDRAW_ACT: return "Take an attack action.";
					
					case WALK: return "Sally forth throughout the land, my friend, sally forth!";
					case APPROACH: return "Close the distance between you and your opponent.";
					case WITHDRAW: return "Move backwards one range category distance.";
					case BERSERK: return "Has more powerful attacks but is unable to take complicated actions.";
					case AFRAID: return "Running in terror from opponent.";
					case INFINITY: return "Chance for consumable to not use a charge on activation.";
					
					default: return null;
				}
			}
		}*/
		
		public static function getTagDesc(s:String):String{
			var m:String="\n\n<font color="+TEAL+">*"
			switch(s){
				case EffectData.RETURN: m+="Strikes twice"; break;
				case EffectData.NO_ATTACK: m+="You cannot attack while holding this item."; break;
				case EffectData.ONLYFAR: m+="Only useable from Mid Range."; break;
				case EffectData.TWO_CHARGES: m+="This item costs 2 charges when used."; break;
				case EffectData.HALF_STRENGTH: m+="Only half your strength bonus is used for damage."; break;
				case EffectData.HALF_MPOW: m+="Only half your MPow is added to the effect."; break;
				case EffectData.FULL_MPOW: m+="Your full MPow is added to the effect."; break;
				case EffectData.FULL_STRENGTH: m+="Your full strength bonus is used for damage."; break;
				case EffectData.BONUS_STRENGTH: m+="150% Damage Scaling from stats for this weapon."; break;
				case EffectData.RELIC: m+="Only one Relic of any type can ever be equipped at a time."; break;
				case EffectData.PIERCE: m+="Damage is based on your Initiative."; break;
				case EffectData.RANGED: m+="Can also be used as a Mid Ranged Weapon, splitting its damage into two strikes."; break;
				case EffectData.LONG_RANGED: m+="Can also be used at Far Range."; break;
				case EffectData.MONK_WEAPON: m+="Can use all of a monk's offensive skills."; break;
				case EffectData.BLOOD_MAGIC: m+="Uses Health instead of Mana to cast this spell at an increased cost."; break;
				case EffectData.DURATION: m+="Increases Duration by 1."; break;
				case EffectData.DURATION2: m+="Increases Duration by 3."; break;
				case EffectData.DURATION_MINUS: m+="Decreases Duration by 2."; break;
				case EffectData.INITIAL_SPELL: m+="Casts this spell automatically at the beginning of combat.  Cannot be cast manually."; break;
				case EffectData.FREE_SPELL: m+="Casts this spell without using an action but for greatly reduced effect.  Not used on Round 1."; break;
				//case EffectData.ESSENCE: m+="This item will be replaced with a Crafting Ingredient when the Crafting System is released.  Thank you for your patience!"; break;
				case EffectData.SCOURING: m+="Removes all prefixes and suffixes from an item or pulls an item out of an essence.  No other ingredients are recovered."; break;
				case EffectData.CHAOS_ESSENCE: m+="Places a random Mythic Suffix on any craftable item."; break;
				case EffectData.MINOR_CHAOS_ESSENCE: m+="Places a random Basic Suffix on a Weapon, Helmet, Projectile, Charm or Trinket."; break;
				case EffectData.EPIC_ESSENCE: m+="Upgrades any level 15 item to level 16 Epic.  Once the Epic Zone is unlocked you can also combine 2 identical items."; break;
				case EffectData.SUFFIX_ESSENCE: m+="Combines with many different possible items to create a Suffixed Essence."; break;
				case EffectData.PLENTIFUL: m+="Doubles the max number of charges of a charge based item."; break;
				default: return "";
			}
			m+="</font>";
			return m;
		}
		
		public static function action(s:String):String{
			switch(s){
				/*case ActionData.SEARING: return "\n\n<font color="+TEAL+">*Only half your magic power is added to damage.</font>"
				 case ActionData.HEALING: return "\n\n<font color="+TEAL+">*Only half your magic power is added to healing.</font>"*/
				default:
					return "";
			}
		}
		
		public static function button(s:String):String{
			switch(s){
				case ADVENTURE: return "Go forth into the world and test your mettle.";
				case HOME: return "Your home, where you can create or load characters and set options.";
				case SHOP: return "Buy or sell items and equipment.";
				case BLACK_MARKET: return "A place to purchase exotic goods and get rare services.";
				case GAMBLE: return "A shady dealer offers to sell you something, but you don't know if it's worth it.";
				case UPGRADE: return "A mysterious craftsman with a wicked grin claims to be able to enhance your items.";
				case RESTACK: return "In the black magic stall sits a woman who offers to duplicate some of your minor items.";
				case LIBRARY: return "Learn about the world you live in.";
				case HALL: return "View the achievements of heroes past and heroes from other worlds.";
				case DUEL: return "Test yourself against other would-be heroes.";
				case ARCADE: return "Play more games!";
				case COLOURS: return "Temporary testing ground for colouring units.";
				case EXHIBITION: return "Auto-matchups between players.";
				case MONSTER: return "Pit two teams of monsters against each other.";
				case FILLSTACK: case FILLALL: return "Toggles between filling a single item or your entire belt.";
				
				case ACTIONS: return "Switch to view the actions of the currently selected unit.";
				case STATS: return "Switch to view the statistics of the currently selected unit.";
				case STASH: return "Click to view your player stash and shared stash.  Locked until Level 2.";
				case SKILLS: return "Switch to view your skills.";
				case INVENTORY: return "Switch to view your items.";
				case NEW_CHAR: return "Create a new character.";
				case LOAD_CHAR: return "Load a previously created character.";
				case CHALLENGE: return "Challenge a computer opponent.";
				case SEASON1: return "Challenge characters created by Season 1 Tournament Champions!";
				
				case IMPORT: return "Import a character from an export code to be your opponent in the arena.  Export codes can be made from the 'Load Character' menu.";
				case EXPORT: return "Exports a character code for use in the Duel Arena on this or another computer.";
				case STATUS: return "Displays your character's status and inventory and allows you to edit your character.";
				case CLOSE_WINDOW: case DONE: case LEAVE: case LETSGO: return "Go into the main Town menu.";
				case REVIVE: return "Reincarnate as a fresh character.";
				case DISABLE_TUTORIAL: return "Disables all past, present and future tutorial popups.";
				
				case TOWN: return "Click here to go to town during your next SAFE action";
				case PAUSE: return "Pause the game";
				case UNPAUSE: return "Unpause the game";
				case TURBO: return "Make the game go super speed!";
				case QUALITY: return "Change the game's quality";
				case MUTE: return "Mutes all sounds and music";
				case UNMUTE: return "Reactivates the playing of sounds and music";
				case AUTO: return "In current mode, all actions are selected based on priorities.";
				case SEMI: return "In current mode, click on an item to use that item in your next available action.\n double click to constantly use that item whenever possible.";
				case MANUAL: return "In current mode, select each action from an Action Menu.";
				case NEXT_PAGE: return "Go to the next page";
				case PREV_PAGE: return "Go to the previous page";
				case TABLE_CONTENTS: return "Go back to the Table of Contents";
				case SKILL_SCROLL: return "Change skill page to a different class.";
				case REFRESH: return "Refreshes all shops for 1 Refresh Token.  1 Token is earned every 10 zones,  Max 15.";
				
				case CONTINUE: return "Go forth to the next area.";
				case RESPEC: return "Pay the money to get back all your spent skill points.";
				case YES: return "Confirm the current option.";
				case NO: case CANCEL: return "Don't do it! Don't do it!!!!";
				case ERASE: return "Erase ALL saved data, including characters, achievements and game stats.";
				case ONLINE: return "Pops up the online leaderboard to view other players' progress.";
				case SAVE: return "Saves the current character and begins the game!";
				case FIGHT: return "Enter the arena with current player selections.";
				case ASCEND: return "Restart the game from level 1.";
				case NO_ASCEND:return "Locked until you reach zone 101.";
				case NONE: return "Nothing is occupying this slot.";
				case NEVER: return "This item is not actively useable.";
				case ALWAYS: return "This item will be used whenever possible.";
				case BETWEEN: return "This item will only be used between fights.";
				case COMBAT: return "This item will be used any time during combat.";
				case NEAR: return "This item will only be used when the enemy is right next to you.";
				case FAR: return "This item will only be used when you at Mid Range.";
				case VERY: return "This item will only be used at Far Range.";
				case NEAR_AW: case FAR_AW: case SAFE_AW: case VERY_AW: return "Use this button to scroll between the three Action Lists.";
				case EnemyData.TITLES[0][0]: return "Forest creatures are more cunning.";
				case EnemyData.TITLES[0][1]: return "Mountain creatures are hardier.";
				case EnemyData.TITLES[0][2]: return "Cave creatures are stronger.";
				case EnemyData.TITLES[1][0]: return "Wild beasts are faster.";
				case EnemyData.TITLES[1][1]: return "Savage beasts are stronger.";
				case EnemyData.TITLES[1][2]: return "Dire beasts can deal massive blows.";
				case EnemyData.TITLES[2][0]: return "Hellish demons have explosive strikes.";
				case EnemyData.TITLES[2][1]: return "Plasmic demons are infused with magic.";
				case EnemyData.TITLES[2][2]: return "Spectral demons are infused with darkness.";
				case LIVES: return "Change the number of lives each player gets during the match.";
				case MouseControl.TRASH: return "Drag here or CTRL+Click on an item to sell.\n If inventory is full, will autosell or send Special Items to Overflow Stash.";
				default: return "";
			}
		}
		
		public static function actionStat(i:int):String{
			switch(i){
				case ActionBase.TYPE: return "The type of damage dealt by this attack.";
				case ActionBase.USERATE: return "Chance that this attack will be used, or go on to the next item on the list.";
				case ActionBase.HITRATE: return "Chance that an attack will hit; Opposed by Block.";
				case ActionBase.DAMAGE: return "The amount of damage dealt by this attack.";
				case ActionBase.CRITRATE: return "The chance of performing a critical hit.";
				case ActionBase.CRITMULT: return "The amount that your damage is multiplied by on critical hits.";
				case ActionBase.DODGE_REDUCE: return "Ignores this much enemy Dodge.";
				case ActionBase.MANA: return "Cost in mana for casting this spell.";
				case ActionBase.LEECH: return "Heal a percent of damage dealt on each attack.";
				case ActionBase.HEAL: return "The amount of healing done by this action.";
				
				default: return "";
			}
		}
		
		public static function stat(i:int):String{
			with (StatModel){
				switch (i){
					case ItemData.HEALING: return "The amount of health healed by this action.";
					case STRENGTH: return "Modifies the amount of physical damage dealt with weapons. 1 Strength = 1% Increase.";
					case MPOWER: return "Modifies the amount of damage dealt with spells and some effects. 1 MPow = 1% Increase.";
					case INITIATIVE: return "Determines if you will act before the enemy and modifies damage with some weapons. 1 Initiative = 1% Increase.";
					case HEALTH: return "The amount of damage you can take before dying.";
					case HREGEN: return "How fast your Health heals.";
					case MANA: return "Mana is necessary for casting spells.";
					
					case MREGEN: return "How fast your Mana regenerates.";
					case DODGE: return "The chance of avoiding attacks and thrown items.";
					case BLOCK: return "This value is subtracted from the enemy's Hit Rate when attacking.";
					case TURN: return "The chance to completely nullify an incoming spell.";
					
					case TURN_REDUCE: return "Ignores this much enemy Nullify.";
					case RMAGICAL: return "Reduces all incoming Magical damage from spells and some attacks.";
					case RCHEMICAL: return "Reduces all incoming Chemical damage from some attacks and some thrown items.";
					case RSPIRIT: return "Reduces all incoming Holy and Dark damage from some attacks and some spells.";
					case RPHYS: return "Reduces all incoming Physical Damage from attacks and some abilities.";
					case RCRIT: return "Reduces incoming Critical Hit damage of all types.";
					case ILOOT: return "The chance you have of finding an item off of an enemy corpse.";
					case ITEMEFF: return "Increase effectiveness of all belt items except Buffing Potions and Charms.  Stacks multiplicatively with other bonusses.";
					case POTEFF: return "Increases effectiveness of Health and Mana potions.";
					case PHYSEFF: return "Increases all Physical Damage dealt.";
					case THROWEFF: return "Increases effectiveness of all Throwing Potions.";
					case HOLYEFF: return "Increases damage and healing from all Holy sources.";
					case CHEMEFF: return "Increases damage and healing from all Chemical sources.";
					case MAGICEFF: return "Increases all Magic Damage dealt.";
					case DOTEFF: return "Increases the effectiveness of all your Over Time effects (Healing Included).";
					case PROCEFF: return "Increases the effectiveness of all secondary damage from weapons, spells and potions, including direct and damage over time.";
					case NEAR: return "Increased damage from Near Range.";
					case FAR: return "Increased damage from Mid or Far Range.";
					case HEALMULT: return "Increases healing from all sources.";
					case DMGMULT: return "Multiplies your base damage.";
					case CRAFT_BELT: return "Add this amount of Manufacturing Points every turn, doubled while SAFE. 100 Points grants stacks of belt items based on stack size.";
					case MRATE: return "Bonus to chance your hero will use spells on his own.";
					case IRATE: return "Bonus to chance your hero will use items on his own.  Stacks multiplicatively with other bonusses.";
					case PRATE: return "Bonus to chance your hero will drink potions on his own.";
					case TRATE: return "Bonus to chance your hero will throw potions on his own.";
					case SLOTS: return "Number of spell slots your hero has.";
					case DRANGE: return "The potential increase or decrease to your damage.  +/- this percent.";
					
					case SPELLSTEAL: return "Heal a percent of direct magic or holy damage dealt from spells.";
					case TENACITY: return "Chance to act normally when prevented from acting.";
					
					default: return "";
				}
			} 
		}
		
		public static function verb(s:String):String{
			with (ActionData){
				switch (s){
					case ATTACK: return "attacks";
					case DODGE: return "dodges";
					
					case MISSILE: case POISON: case FIREBALL: case LIGHTNING: case SEARING:
					case ENCHANT: case EMPOWER: case HASTE: case WEAKEN: case VULNERABILITY: case CONFUSION: case HEALING:
					case DARK_BLAST: case DEADLY_CURSE: case TERRIFY: case BERSERK: case ENERGIZE:
						return "casts "+s;
					case HEALING_POT: case MANA_POT: case BUFF_POT:
						return "drinks a "+s;
					case ALCH_POT: case POISON_POT: case HOLY_POT: return "throws "+s;
					
					case THROW_D: return "throws a Dagger";
					case THROW_A: return "throws an Axe";
					case SHOOT: return "shoots an Arrow";
	
					case STUNNED: return "is Stunned";
					case CONFUSED: return "is Confused";
					//case DISORIENTED: return "is Disoriented";
					case AFRAID: return "is Afraid";
					
					case WITHDRAW: return "Withdraws";
					//case LEAP: return "Leaps";
					case BASH: return "Bashes";
					default: return null;
				}
			}
		}
		
		public static function getSkillName(v:SkillView):String{
			return SkillData.skillName[v.index]+" <font color="+StringData.RED+">"+(v.level<SkillData.MAX_SKILL?(v.counter.text+"/"+String(SkillData.MAX_SKILL)):"MAX")+"</font>";
		}
		
		public static function getSkillTreeDesc(v:SkillTreeView):String{
			var m:String=skillTree(v.index);
			
			var _skill:SkillModel=SkillData.treeSkill(v.index,v.level);
			m+="\n\n"+statDesc(_skill.values);
			
			m+=specialTree(v.index);
			return m;
		}
		
		public static function getSkillDesc(v:SkillView):String{
			var m:String=skill(v.index);
			if (v.level>=0) {
				var _skill:SkillModel=SkillData.loadSkill(v.index,v.level);
				if (v.level>0){
					 m+="\n\n<font color="+StringData.YELLOW+"><b>This Level:</b></font>"
					 if (_skill.values!=null && _skill.values.length>0){
						 m+="\n"+statDesc(_skill.values); 
					 }
					 if (_skill.action!=null){
						m+="\n"+_skill.action.getDesc();
					 }
				}
				
				if (v.level<10){
					_skill=SkillData.loadSkill(v.index,v.level+1);
					 m+="\n\n<font color="+StringData.YELLOW+"><b>Next Level:</b></font>"
					 if (_skill.values!=null && _skill.values.length>0){
						m+="\n"+statDesc(_skill.values);
					 }
					 
					if (_skill.action!=null){
						m+="\n"+_skill.action.getDesc();
					}
				}
				
				for (var i:int=0;i<_skill.values.length;i+=1){
					var _temp:String=null;
					if (((_skill.values[i][0]==SpriteModel.STAT || _skill.values[i][0]==SpriteModel.UNARMORED) && _skill.values[i][1]==StatModel.PROCS)){
						_temp=_skill.values[i][2].getSpecialDesc(EffectBase.DESC_OFFENSIVE);
					}else if (((_skill.values[i][0]==SpriteModel.ATTACK || _skill.values[i][0]==SpriteModel.UNARMED) && _skill.values[i][1]==ActionBase.EFFECT)){
						_temp=_skill.values[i][2].getSpecialDesc(EffectBase.DESC_ATTACK);
					}else if ((_skill.values[i][0]==SpriteModel.ATTACK || _skill.values[i][0]==SpriteModel.UNARMED) && _skill.values[i][1]==ActionBase.CEFFECT){
						_temp=_skill.values[i][2].getSpecialDesc(EffectBase.DESC_CRIT);
					}else if ((_skill.values[i][0]==SpriteModel.STAT || _skill.values[i][0]==SpriteModel.UNARMORED) && (_skill.values[i][1]==StatModel.DISPLAYS || _skill.values[i][1]==StatModel.EFFECT)){
						_temp=_skill.values[i][2].getSpecialDesc();
					}
					if (_temp!=null) m+="\n\n<font color="+TEAL+">*"+_temp+"</font>";
					
					if (_skill.values[i][0]==SpriteModel.ATTACK && _skill.values[i][1]==ActionBase.TAG){
						//if (i>0) m+="\n";
						m+=getTagDesc(_skill.values[i][2]);
					}
				}
				
				m+=specialSkill(v.index);
			}
			return m;
		}
		
		public static function getArtifactDesc(v:ArtifactModel,_short:Boolean=false):String{
			var m:String=artifact(v.index); m+="\n\n";
			//var m:String="";
			var _values:Array=ArtifactData.spawnArtifact(v.index,v.level).values;
			if (!_short) m+="<font color="+StringData.YELLOW+"><b>This Level:</b></font>\n"
			m+=statDesc(_values);
			if (v.level<10 && !_short)m+="\n\n<font color="+StringData.YELLOW+"><b>Next Level:</b></font>\n"+statDesc(ArtifactData.spawnArtifact(v.index,v.level+1).values);
			
			for (var i:int=0;i<_values.length;i+=1){
				var _temp:String=null;
				if ((_values[i][0]==SpriteModel.STAT || _values[i][0]==SpriteModel.UNARMED) && _values[i][1]==StatModel.PROCS){
					_temp=_values[i][2].getSpecialDesc(EffectBase.DESC_OFFENSIVE);
				}else if ((_values[i][0]==SpriteModel.ATTACK || _values[i][0]==SpriteModel.UNARMED) && _values[i][1]==ActionBase.EFFECT){
					_temp=_values[i][2].getSpecialDesc(EffectBase.DESC_ATTACK);
				}else if ((_values[i][0]==SpriteModel.ATTACK || _values[i][0]==SpriteModel.UNARMED) && _values[i][1]==ActionBase.CEFFECT){
					_temp=_values[i][2].getSpecialDesc(EffectBase.DESC_CRIT);
				}else if (_values[i][0]==SpriteModel.STAT && (_values[i][1]==StatModel.DISPLAYS || _values[i][1]==StatModel.EFFECT)){
					_temp=_values[i][2].getSpecialDesc();
				}
				if (_temp!=null) m+="\n\n<font color="+TEAL+">*"+_temp+"</font>";
				
				if (_values[i][0]==SpriteModel.ATTACK && _values[i][1]==ActionBase.TAG){
					//if (i>0) m+="\n";
					m+=getTagDesc(_values[i][2]);
				}
			}
				
			m+=specialArtifact(v.index);
			return m;
		}
		
		public static function getItemDesc(model:ItemModel):String{
			var m:String="";
			var _post:String="";
			
			if (model.level<0){
				//m="Level <font color="+YELLOW+">?</font> ";
				if (model.secondary!=null){
					m+=model.secondary+" ";
				}
				if (model.primary!=null){
					m+=model.primary+" ";
				}else{
					m+=model.slot;
				}
				m+="\n\n<p align='right'><font color="+YELLOW+">"+model.cost+" g</font></p>";
				return m;
			}else{
				//m="Level <font color="+YELLOW+">"+model.level+" </font>";
				if (model.secondary!=null){
					m+=model.secondary+" ";
				}
				if (model.primary!=null){
					m+=model.primary+" ";
				}else{
					m+=model.slot;
				}
				if (model.tags.length>0){
					m+="\n";
					for (i=0;i<model.tags.length;i+=1){
						m+=model.tags[i];
						if (i<model.tags.length-1) m+=", ";
						if (model.index!=135) _post+=getTagDesc(model.tags[i]);
					}
				}
				if (model.action!=null && model.action.tags.length>0){
					if (model.tags.length>0){
						m+=", ";
					}else{
						m+="\n";
					}
					for (i=0;i<model.action.tags.length;i+=1){
						m+=model.action.tags[i];
						if (i<model.action.tags.length-1) m+=", ";
						_post+=getTagDesc(model.action.tags[i]);
					}
				}
				
				
				var _temp:String=statDesc(model.values);
				if (_temp.length>0){
					m+="\n\n"+_temp;
				}
				if (model.action!=null){
					if (_temp.length==0) m+="\n";
					m+="\n"+model.action.getDesc();
				}
				
				for (var i:int=0;i<model.values.length;i+=1){
					_temp=null;
					
					if ((model.values[i][0]==SpriteModel.STAT || model.values[i][0]==SpriteModel.UNARMED) && model.values[i][1]==StatModel.PROCS){
						_temp=model.values[i][2].getSpecialDesc(EffectBase.DESC_OFFENSIVE);
					}else if ((model.values[i][0]==SpriteModel.ATTACK || model.values[i][0]==SpriteModel.UNARMED) && model.values[i][1]==ActionBase.EFFECT){
						_temp=model.values[i][2].getSpecialDesc(EffectBase.DESC_ATTACK);
					}else if ((model.values[i][0]==SpriteModel.ATTACK || model.values[i][0]==SpriteModel.UNARMED) && model.values[i][1]==ActionBase.CEFFECT){
						_temp=model.values[i][2].getSpecialDesc(EffectBase.DESC_CRIT);
					}else if (model.values[i][0]==SpriteModel.STAT && (model.values[i][1]==StatModel.DISPLAYS || model.values[i][1]==StatModel.EFFECT)){
						_temp=model.values[i][2].getSpecialDesc();
					}
					if (_temp!=null) m+="\n\n<font color="+TEAL+">*"+_temp+"</font>";
					
					if (model.values[i][0]==SpriteModel.ATTACK && model.values[i][1]==ActionBase.TAG){
						//if (i>0) m+="\n";
						m+=getTagDesc(model.values[i][2]);
					}
				}
				
				if (model.action!=null){
					for (i=0;i<model.action.effects.length;i+=1){
						_temp=model.action.effects[i].getSpecialDesc(EffectBase.DESC_OFFENSIVE);
						if (_temp!=null) m+="\n\n<font color="+TEAL+">*"+_temp+"</font>";
					}
					
					for (i=0;i<model.action.cEffects.length;i+=1){
						_temp=model.action.cEffects[i].getSpecialDesc(EffectBase.DESC_CRIT);
						if (_temp!=null) m+="\n\n<font color="+TEAL+">*"+_temp+"</font>";
					}
					m+=action(model.action.label);
				}
			}
			
			m+=_post;
			
			if (model.cost>=0){
				m+="\n\n<p align='right'><font color="+YELLOW+">"+model.cost+" g</font></p>";
			}else if (model.cost<=-1000){
				m+="\n\n<p align='right'><font color="+YELLOW+">"+String(0-model.cost)+" SOULS</font></p>";
			}else{
				m+="\n\n<p align='right'><font color="+YELLOW+">"+String(0-model.cost)+" PT</font></p>";
			}
			return m;
		}
		
		public static function getEffectDesc(v:*):String{
			if (v==null) return "";
			var _temp:String=v.getSpecialDesc(EffectBase.DESC_OFFENSIVE);
			if (_temp!=null){
				return _temp+"\n\n"+v.getDesc();
			}else{
				return v.getDesc();
			}
		}
		
		public static function statDesc(_values:Array,_tabs:int=0):String{
			var m:String="";
			for (var i:int=0;i<_values.length;i+=1){
				var _temp:String="";
				if (_values[i][0]==SpriteModel.STAT || _values[i][0]==SpriteModel.UNARMORED){
					if (_values[i][1]==StatModel.EFFECT){
						_temp=_values[i][2].getDesc(_tabs+1);
					}else if (_values[i][1]==StatModel.PROCS){
						_temp=_values[i][2].getDesc(_tabs+1);
					}else if (_values[i][1]==StatModel.DISPLAYS){
						_temp=_values[i][2].getDesc(_tabs+1);
					}else{
						_temp=tabs(_tabs)+StatModel.statNames[_values[i][1]]+": <font color="+RED+"><b>";
						switch(_values[i][1]){
							case StatModel.STRENGTH: case StatModel.INITIATIVE: case StatModel.MPOWER:
							case StatModel.HEALTH: case StatModel.BLOCK:
							case StatModel.SLOTS: case StatModel.CRAFT_BELT: case StatModel.MANA:
							case StatModel.FURY:
							case StatModel.FURYTOSTRENGTH:
							//case StatModel.FURYTOTENACITY:
								_temp+=reduce(_values[i][2]); break;
							case StatModel.BLOCKTORALL: _temp+=reduce(_values[i][2]*10000)+"%"; break;
							case StatModel.DMGMULT: 
							if (_values[i][2]>0){
								_temp+="+"+reduce(_values[i][2]*100)+"%";
							}else{
								_temp+=reduce(_values[i][2]*100)+"%"; 
							}
							break;
							
							default:
								_temp+=reduce(_values[i][2]*100)+"%"; break;
								
							//case StatModel.SLOTS: _temp+="+"+String(_values[i][2]);break;
						}
						_temp+="</b></font>";
					}
				}else if (_values[i][0]==SpriteModel.ATTACK || _values[i][0]==SpriteModel.UNARMED){
					if (_values[i][1]==ActionBase.EFFECT){
						_temp=_values[i][2].getDesc(_tabs+1);
					}else if (_values[i][1]==ActionBase.CEFFECT){
						_temp=tabs(_tabs)+"<font color="+YELLOW+">Crit:</font>"+_values[i][2].getDesc(_tabs+1);
					}else if (_values[i][1]==StatModel.BLOCK){
						_temp=tabs(_tabs)+StatModel.statNames[StatModel.BLOCK]+":<font color="+RED+"><b>"+Math.round(_values[i][2])+"</b></font>";
					}else if (_values[i][1]==ActionBase.TAG){
						if (i>0) _temp+="\n";
						_temp=tabs(_tabs)+_values[i][2];
					}else{
						_temp=tabs(_tabs)+ActionBase.statNames[_values[i][1]]+": <font color="+RED+"><b>";
						switch(_values[i][1]){
							case ActionBase.DAMAGE:// case ActionBase.MANA:
								if (Math.abs(_values[i][2])<1){
									if (_values[i][2]>0) _temp+="+";
									_temp+=reduce(_values[i][2]*100)+"%";
								}else{
									if (_values[i][2]>0) _temp+="+";
									_temp+=reduce(_values[i][2]);
								}break;
							 case ActionBase.MANA:
								if (Math.abs(_values[i][2])<1){
									if (_values[i][2]>0) _temp+="+";
									_temp+=reduce(_values[i][2]*100)+"%";
								}else{
									_temp+=reduce(_values[i][2]);
								}break;
							case ActionBase.CRITMULT: case ActionBase.CRITRATE: case ActionBase.DODGE_REDUCE: case ActionBase.LEECH: case ActionBase.HITMULT:
							case ActionBase.FURYTOCRIT:
								_temp+=reduce(_values[i][2]*100)+"%"; break;
								//case ActionBase.FURYTOHIT:
								//_temp+=reduce(_values[i][2]); break;
								default:_temp+=reduce(_values[i][2]); break;
						}
						_temp+="</b></font>";
					}
				}
				if (_temp.length>0){
					if (i>0) m+="\n";
					m+=_temp;
				}
			}
			return m;
		}
		
		public static function tabs(_length:int=1):String{
			var m:String="";
			for (var i:int=0;i<_length;i+=1){
				m+="  ";
			}
			return m;
		}
		
		public static function talentDesc(i:int):String{
			var m:String="";
			with (skills.SkillData){
				switch (i){
					case ORDINARY: m="\n<font color="+RED+">RESPEC FOR FREE</font>";  break;
					case NOBLE: m="<font color="+RED+">+1 SKILL EVERY 12 LEVELS (5 TOTAL)\n SKILL LEVEL MAX: 7"; break;
					case HOLY: m="<font color="+RED+">NO GAMBLING\n HOLY ATTACKS\n</font>"; break;
					case UNGIFTED: m="<font color="+RED+">NO MAGIC\n</font>"; break;
					case WILD:m="<font color="+RED+">DAMAGE RANGE INCREASED, +/-\n</font>";break;
					case SAVIOR: m="<font color="+RED+">RANDOM DAMAGE TYPE EACH ATTACK\n</font>";break;
					default: m="";
				}
				m+=statDesc(loadTalent(i).values);
			}
			return m;
		}

		public static function reduce(n:Number):String{
			if (Math.abs(n)<0.001) return "0";
			if (Math.floor(n)!=n){
				if (String(Math.round(n)).length>=3){
					return String(Math.round(n));
				}else if (String(Math.round(n)).length==2){
					return n.toFixed(1);
					//return String(n).substr(0,String(n).indexOf(".")+2);
				}else{
					return n.toFixed(2);
					//return String(n).substr(0,String(n).indexOf(".")+3);
				}
			}else{
				return String(n);
			}
		}
		
		public static function specialSkill(i:int):String{
			switch(i){
				case SkillData.UNARMED: return "\n\n<font color="+TEAL+">*Damage is added to Base Unarmed Damage of 10.</font>"; break;
				case SkillData.LEAP: return "\n\n<font color="+TEAL+">*You can Leap and Attack from Mid Range (Overrides Approach: Acc -10%)</font>"; break;
				//case SkillData.GADGETEER: return "\n\n<font color="+TEAL+">*Increases effectiveness and use rate of all Belt Items (not Charms).</font>"; break;
				case SkillData.WITHDRAW: return "\n\n<font color="+TEAL+">*Chance to move backwards and use a Damaging Action.</font>"; break;
				case SkillData.IRON_GUT: return "\n\n<font color="+TEAL+">*Improves power of Health and Mana Potions</font>";
				case SkillData.DEADLY_ALCH: return "\n\n<font color="+TEAL+">*Improves damage of all Throwing Potions.</font>";
				case SkillData.CRAFTING: return "\n\n<font color="+TEAL+">*Refills any belt item by 1 or more (depending on Stack Size) periodically based of Manufacturing speed.</font>"; 
				case SkillData.DEPTHS: return "\n\n<font color="+TEAL+">*Increases duration of Debuffs.</font>";
				case SkillData.ECCHO: return "\n\n<font color="+TEAL+">*Increases effectiveness of all Over Time abilities (including Healing).</font>";
				case SkillData.VESSEL: return "\n\n<font color="+TEAL+">*Unlocks a Spell Slot at levels 1 and 7.</font>";
				default: return "";
			}
		}
		
		public static function specialTree(i:int):String{
			switch(i){
				case SkillData.WARRIOR: return "\n\n<font color="+TEAL+">*Every point in this tree increases your Physical Damage from any source.</font>"; break;
				case SkillData.MONK:	return "\n\n<font color="+TEAL+">*Every point in this tree increases your Secondary Damage from charms, skills, etc.</font>"; break;
				case SkillData.WIZARD:	return "\n\n<font color="+TEAL+">*Every point in this tree increases your Magic Damage from any source.</font>"; break;
				case SkillData.RANGER:	return "\n\n<font color="+TEAL+">*Every point in this tree increases all your damage when at Mid or Far Range.</font>"; break;
				case SkillData.ALCHEMIST: return "\n\n<font color="+TEAL+">*Every point in this tree increases Chemical Damage and Healing from any source.</font>"; break;
				case SkillData.ACOLYTE:	return "\n\n<font color="+TEAL+">*Every point in this tree increases your Dark Damage from any source.</font>"; break;
				case SkillData.PALADIN:	return "\n\n<font color="+TEAL+">*Every point in this tree increases your Holy Damage and Healing from any source.</font>"; break;
				case SkillData.ROGUE:	return "\n\n<font color="+TEAL+">*Every point in this tree increases all your damage when at Near Range.</font>"; break;
			}
			return "";
		}
		
		public static function specialArtifact(i:int):String{
			switch(i){
				case 3: return "\n\n<font color="+TEAL+">*Chance to act freely when you would be prevented from acting.</font>";
				case 4: return "\n\n<font color="+TEAL+">*Multiplies your Health and Mana Regeneration.</font>";
				case 8: return "\n\n<font color="+TEAL+">*Increases Magic Damage dealt.</font>";
				case 10: return "\n\n<font color="+TEAL+">*Increases Holy Damage dealt.</font>";
				case 12: return "\n\n<font color="+TEAL+">*Increases the duration of all buffs.</font>";
				case 14: return "\n\n<font color="+TEAL+">*Reduces physical damage taken.</font>";
				case 15: return "\n\n<font color="+TEAL+">*Increased damage from Mid and Far Range.</font>";
				case 16: return "\n\n<font color="+TEAL+">*A percentage of your Block is added as Magic, Chemical and Holy Resistance.</font>";
				case 18: return "\n\n<font color="+TEAL+">*Increases the amount of health gained from your Helmet by a percent.</font>";
				case 22: return "\n\n<font color="+TEAL+">*Increases the amount of healing gained from all sources.</font>";
				case 23: return "\n\n<font color="+TEAL+">*Increases the amount and quality of items found.</font>";
				case 26: return "\n\n<font color="+TEAL+">*Increases your initiative by a percent.</font>";
				case 31: return "\n\n<font color="+TEAL+">*Increases Chemical Damage dealt.</font>";
				case 33: return "\n\n<font color="+TEAL+">*Increases your strength by a percent.</font>";
				case 35: return "\n\n<font color="+TEAL+">*Increases your maximum mana by a percent.</font>";
				case 37: return "\n\n<font color="+TEAL+">*Increases your base stats by an amount.</font>";
				case 38: return "\n\n<font color="+TEAL+">*Increases damage while near and increases your Hit and Block by a percent.</font>";
				case 39: return "\n\n<font color="+TEAL+">*Increases your Dodge and Nullify while at Mid or Far Range.</font>";
				
			}
			return "";
		}
		
		public static function locked(i:int,b:Boolean):String{
			if (i==0){
				if (b){
					return " <font color="+TEAL+">LOCKED</font>";
				}else{
					return " <font color="+TEAL+">UNLOCKED</font>";
				}
			}else if (i==1){
				if (b){
					return " <font color="+RED+">UNACHIEVED</font>";
				}else{
					return " <font color="+TEAL+">ACHIEVED</font>";
				}
			}
			return "";
		}
		
		public static function achieveName(i:int):String{
			switch (i){
				case GameData.ACHIEVE_DEFT: case GameData.ACHIEVE_DEFT_COSMO: return "Deft";
				case GameData.ACHIEVE_CLEVER: case GameData.ACHIEVE_CLEVER_COSMO: return "Clever";
				case GameData.ACHIEVE_UNGIFTED: case GameData.ACHIEVE_UNGIFTED_COSMO: return "Ungifted";
				case GameData.ACHIEVE_STUDIOUS: case GameData.ACHIEVE_STUDIOUS_COSMO: return "Studious";
				case GameData.ACHIEVE_ENLIGHTENED: case GameData.ACHIEVE_ENLIGHTENED_COSMO: return "Enlightened";
				case GameData.ACHIEVE_POWERFUL: case GameData.ACHIEVE_POWERFUL_COSMO: return "Powerful";
				case GameData.ACHIEVE_HOLY: case GameData.ACHIEVE_HOLY_COSMO: return "Holy";
				case GameData.ACHIEVE_WILD: case GameData.ACHIEVE_WILD_COSMO: return "Wild";
				case GameData.ACHIEVE_NOBLE: case GameData.ACHIEVE_NOBLE_COSMO: return "Noble";
				case GameData.ACHIEVE_ORDINARY_COSMO: return "Ordinary";
				// case GameData.ACHIEVE_TURBO: return "Turbo";
				case GameData.ACHIEVE_ACOLYTE: return "Acolyte";
				case GameData.ACHIEVE_PALADIN: return "Paladin";
				case GameData.ACHIEVE_ROGUE: return "Rogue";
				default: return "Name "+String(i);
			}
		}
		
		public static function achieveDesc(i:int):String{
			switch (i){
				case 0: return ("Score a massive blow");
				case 1: return ("Find the hidden treasure");
				case 2: return ("Fail at your duty");
				case 3: return ("Learn something important");
				case 4: return ("Achieve a degree of mastery");
				case 5: return ("Prove your worth in the arena");
				case 6: return ("Aid the Creators");
				case 7: return ("Grow without focus");
				case 8: return ("Roam far across the land");
				case 9: return ("Travel further than you can dream");
				default: return ("Details "+String(i));
			}
		}
		
		public static function level(i:int):String{
			return ("Level "+String(i));
		}
		
		public static function player(i:int):String{
			return ("Player "+String(i));
		}
		
		public static function score(i:int):String{
			switch(i){
				case 0: return "Monsters Killed";
				case 1: return "Deaths";
				case 2: return "Highest Damage";
				case 3: return "Furthest Area";
				case 4: return "Time Played";
				case 5: return "Chars Created";
				default: return "";
			}
		}
		
		public static const CONF_MONSTER:String="Both teams need to select at least one monster.",
							CONF_TOO_MANY:String="Too many characters. Delete unused characters in the Load screen.",
							CONF_ERASE:String="Erase ALL data?  This action is irreversable and will destroy all mythic items and purchased stash tabs!",
							CONF_LOCKED:String="This talent is locked!  Check the Hall for how to unlock it.",
							CONF_MUST_NEW:String="You must create a new character.",
							CONF_MORAL:String="Your moral code does not allow you to visit this place!",
							//CONF_GOLD:String="Not enough gold!",
							//CONF_SOUL:String="Not enough Soul Power!",
							CONF_LAST_DELETE:String="You cannot delete your last character.",
							CONF_DELETE:String="This will delete your character!",
							CONF_TUTORIAL:String="Would you like to run the tutorial?",
							CONF_PREMIUM:String="Would you like to spend 15 Power Tokens on this item?",
							
							TEXT_SHOP:String="Welcome to my shop!  Drag items to my shop to sell, or from my shop to buy.",
							TEXT_BLACK:String="You enter the back alleyway to find all kinds of illegal goods being sold.  'I have something special for you!' calls out one of the merchants, flashing you a smile.",
							TEXT_GAMBLE:String="Hello sir, oh most valued customer!  I have a great deal for you...",
							TEXT_UPGRADE:String="You have something nice, yes?  Give to me... I make it better....",
							TEXT_STACK:String="You want more?  I make you more... many, many more....",
							TEXT_FULL:String="Full Inventory";
							
		public static const END_DEAD:int=0,
							END_WIN:int=1,
							END_FORFEIT:int=2,
							END_REMATCH_L:int=3,
							END_REMATCH_R:int=4,
							END_CHALLENGE_W:int=5,
							END_CHALLENGE_L:int=6,
							END_TIE:int=7;
							
		public static function getEndText(i:int,_left:SpriteModel,_right:SpriteModel,_extra:int=0):String{
			switch(i){
				case END_DEAD: return "You have died!\nSuch a shame...";
				case END_WIN: return "Congratulations, you beat the level!";
				case END_FORFEIT: return "Forfeit the match and return to menu?";
				case END_REMATCH_L: return _right.label+" has been victorious!\n\n go for a rematch?";
				case END_REMATCH_R: return _left.label+" has been victorious!\n\n go for a rematch?";
				case END_CHALLENGE_W: return "You have beaten "+Facade.gameM.enemyM.label+"!\n"+(_extra>0?("\nYou have earned "+String(_extra)+" gold.\n Challenge next opponent?"):"");
				case END_CHALLENGE_L: return Facade.gameM.enemyM.label+" has defeated you.\n go for a rematch?";
				case END_TIE: return "The fight has gone on long enough... it ends in a DRAW.";
				default: return "";
			}
		}
			
		public static function confGold(i:int):String{
			return "Not enough gold, you need "+i+"!";
		}
		
		public static function confSoul(i:int):String{
			return "Not enough Soul Power, you need "+i+"!";
		}
	}
}