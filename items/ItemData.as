package items{
	import skills.SkillData;
	import system.buffs.*;
	import system.effects.*;
	import system.actions.*;
	import items.ItemModel;
	import utils.GameData;
	import utils.AchieveData;
	import ui.effects.PopEffect;

	
	public class ItemData{
		public static const EQUIPMENT:String="Equipment",
							USEABLE:String="Useable",
							TRADE:String="Trade Good",
							ESSENCE:String="Essence",
							
							UNARMED:String="Unarmed",
							
							WEAPON:String="Weapon",
							HELMET:String="Helmet",
							MAGIC:String="Magic",
							MAGIC_E:String="Magic Enemy",
							POTION:String="Potion",
							GRENADE:String="Grenade",
							SCROLL:String="Scroll",
							PROJECTILE:String="Projectile",
							CHARM:String="Charm",
							TRINKET:String="Trinket",
							
							TWO_HANDED:String="Two Handed",
							DOUBLE:String="Double",
							SHIELD:String="Defensive",
							UNARMORED:String="Agile",
							HELD:String="Held",
							RANGED:String="Ranged",
							
							LIGHT:String="Light",
							MEDIUM:String="Medium",
							HEAVY:String="Heavy",
							DAMAGING:String="Offensive",
							HEALING:String="Healing",
							MANA:String="Mana",
							RECOVERY:String="Recovery",
							BUFF:String="Buffing",
							CURSE:String="Cursing",
							THROW:String="Throwable",
							
							INVENTORY:String="inventory",
							EQUIP:String="equipment",
							EQUIP_NO:String="equipment no",
							BELT:String="belt",
							SHOP:String="shop",
							GAMBLE:String="gamble",
							UPGRADE:String="upgrade",
							STACK:String="restack";
							
		public static function findItem(_level:int,find:Number):ItemModel{
			var premiumChance:Number=0.00019;
			if (find>=1){
				premiumChance*=(_level/3);
				if (premiumChance>0.01) premiumChance=0.01;
			}else{
				premiumChance*=(1-_level/1500);
				if (premiumChance<0.0001) premiumChance = 0.0001;
			}
			if (premiumChance>0.01) premiumChance=0.01;
			
			if (Math.random()<premiumChance){
				return spawnPremium(0);
			}
			var level:int=Math.ceil((Math.random()*0.8+0.25)*_level/10);
			if (level>15) level=15;
			var m:ItemModel;
			switch(Math.floor(Math.random()*15)){
				case 0: case 1: case 2: m=randomItem(WEAPON,level);
					if ((m.index==4)||(Math.random()<find)){
						enchantItem(m);
					}break;
				case 3: case 4: m=randomItem(HELMET,level);
					if ((m.index==9)||(Math.random()<find)){
						enchantItem(m);
					}break;
				case 5: m=randomItem(MAGIC,level); break;
				case 6: m=randomItem(PROJECTILE,level); 
					if (Math.random()<find){
						enchantItem(m);
						m.charges=m.maxCharges();
					}break;
				case 7: m=randomItem(SCROLL,level); break;
				case 8: //m=enchantItem(randomItem(CHARM,level)); break;
					var i:int=1+Math.floor(Math.random()*29);
					var j:int;
					switch(i){
						case 11: case 12: case 13: case 27: case 28: case 29: j=40; break;
						case 3: case 4: case 7: case 8: case 9: case 10: j=41; break;
						case 5: case 15: case 17: case 19: case 24: case 26: j=42; break;
						case 1: case 2: case 14: case 16: case 18: j=43; break;
						case 6: case 20: case 21: case 22: case 23: case 25: j=44; break;
					}
					m=enchantItem(spawnItem(level,j),i);
					break;
				case 9: case 10: case 11: 
					level=Math.ceil((Math.random()*0.25+0.8)*_level/10); 
					if  (level>15) level=Math.floor(15+(level-15)*0.3);
					m=randomItem(TRADE,level); break;
				case 12: case 13: case 14: m=randomItem(POTION,level); break;
				default: null;
			}
			
			return m;
		}
		
		public static function spawnItem(_level:int,_index:int,_charges:int=-1):ItemModel{
			if (_index<=63){
				switch (_index){
					case -1: return new ItemEquipment(_index,"ENEMY BASIC",_level,WEAPON,TWO_HANDED,80,ActionData.makeWeapon(35+2.3*_level));
					case 0: return new ItemEquipment(_index,"Greatsword",_level,WEAPON,TWO_HANDED,80,ActionData.makeWeapon(35+2.3*_level,null,null,0,0,0,[EffectData.BONUS_STRENGTH]));
					case 1: return new ItemEquipment(_index,"Battle Axe",_level,WEAPON,TWO_HANDED,60,ActionData.makeWeapon(30+1.6*_level,null,new <EffectBase>[new EffectDamage("Bonus Physical",35+20*_level,DamageModel.PHYSICAL)],0,0,0,[EffectData.BONUS_STRENGTH]));
					case 2: return new ItemEquipment(_index,"Staff",_level,WEAPON,TWO_HANDED,50,ActionData.makeWeapon(20+1.55*_level,null,null,0,0,0,[EffectData.BONUS_STRENGTH]),[[SpriteModel.STAT,StatModel.MPOWER,10+4*_level]]);
					case 3: return new ItemEquipment(_index,"Short Swords",_level,WEAPON,DOUBLE,60,ActionData.makeWeapon(15+1.2*_level));
					case 4: return new ItemEquipment(_index,"Gloves",_level,WEAPON,UNARMED,30);
					case 5: return new ItemEquipment(_index,"Daggers",_level,WEAPON,DOUBLE,45,ActionData.makeWeapon(15+1.07*_level,null,null,10+2*_level,0,0,[EffectData.PIERCE]));
					case 6: return new ItemEquipment(_index,"Sword & Shield",_level,WEAPON,SHIELD,70,ActionData.makeWeapon(26+1.7*_level),[[SpriteModel.STAT,StatModel.BLOCK,12+11*_level]]);
					case 7: return new ItemEquipment(_index,"Axe & Shield",_level,WEAPON,SHIELD,55,ActionData.makeWeapon(23+1.5*_level,null,new <EffectBase>[new EffectDamage("Bonus Physical",27+15*_level,DamageModel.PHYSICAL)]),[[SpriteModel.STAT,StatModel.BLOCK,12+11*_level]]);
					case 8: return new ItemEquipment(_index,"Mace & Shield",_level,WEAPON,SHIELD,50,ActionData.makeWeapon(17+1.1*_level),[[SpriteModel.STAT,StatModel.BLOCK,16+14*_level],[SpriteModel.STAT,StatModel.MPOWER,5+2.5*_level]]);
					
					case 9: return new ItemEquipment(_index,"Bandana",_level,HELMET,UNARMORED,30,null,[[SpriteModel.STAT,StatModel.HEALTH,60+25*_level]]);
					case 10: return new ItemEquipment(_index,"Cone",_level,HELMET,LIGHT,60,null,[[SpriteModel.STAT,StatModel.HEALTH,75+37*_level],[SpriteModel.STAT,StatModel.RCRIT,.1],[SpriteModel.STAT,StatModel.MANA,10+3*_level]]);
					case 11: return new ItemEquipment(_index,"Cap",_level,HELMET,LIGHT,50,null,[[SpriteModel.STAT,StatModel.HEALTH,80+40*_level],[SpriteModel.STAT,StatModel.RCRIT,.1]]);
					case 12: return new ItemEquipment(_index,"Helmet",_level,HELMET,MEDIUM,80,null,[[SpriteModel.STAT,StatModel.HEALTH,100+52*_level],[SpriteModel.STAT,StatModel.RCRIT,.2],[SpriteModel.STAT,StatModel.INITIATIVE,-20],[SpriteModel.STAT,StatModel.DODGE,-0.1]]);
					case 13: return new ItemEquipment(_index,"Armet",_level,HELMET,HEAVY,100,null,[[SpriteModel.STAT,StatModel.HEALTH,120+62*_level],[SpriteModel.STAT,StatModel.RCRIT,.3],[SpriteModel.STAT,StatModel.INITIATIVE,-40],[SpriteModel.STAT,StatModel.DODGE,-0.2]]);
					
					case 14: return new ItemMagic(_index,"Magic Bolt",_level,DAMAGING,60,ActionData.makeAction(ActionData.MISSILE,_level));
					case 15: return new ItemMagic(_index,"Fireball",_level,DAMAGING,80,ActionData.makeAction(ActionData.FIREBALL,_level));
					case 16: return new ItemMagic(_index,"Lightning",_level,DAMAGING,100,ActionData.makeAction(ActionData.LIGHTNING,_level));
					case 17: return new ItemMagic(_index,"Searing Light",_level,DAMAGING,140,ActionData.makeAction(ActionData.SEARING,_level));
					case 18: return new ItemMagic(_index,"Poison Bolt",_level,CURSE,75,ActionData.makeAction(ActionData.POISON,_level));
					case 19: return new ItemMagic(_index,"Confusion",_level,CURSE,85,ActionData.makeAction(ActionData.CONFUSION,_level));
					case 20: return new ItemMagic(_index,"Cripple",_level,CURSE,75,ActionData.makeAction(ActionData.WEAKEN,_level));
					case 21: return new ItemMagic(_index,"Vulnerability",_level,CURSE,90,ActionData.makeAction(ActionData.VULNERABILITY,_level));
					case 22: return new ItemMagic(_index,"Healing",_level,HEALING,95,ActionData.makeAction(ActionData.HEALING,_level));
					case 23: return new ItemMagic(_index,"Empower",_level,BUFF,110,ActionData.makeAction(ActionData.EMPOWER,_level));
					case 24: return new ItemMagic(_index,"Haste",_level,BUFF,70,ActionData.makeAction(ActionData.HASTE,_level));
					case 25: return new ItemMagic(_index,"Enchant Weapon",_level,BUFF,70,ActionData.makeAction(ActionData.ENCHANT,_level));
					
					case 26: return new ItemMagic(_index,"Berserk",_level,BUFF,50,ActionData.makeAction(ActionData.BERSERK,_level));
					case 27: return new ItemMagic(_index,"Deadly Curse",_level,CURSE,50,ActionData.makeAction(ActionData.DEADLY_CURSE,_level));
					case 28: return new ItemMagic(_index,"Energize",_level,MANA,50,ActionData.makeAction(ActionData.ENERGIZE,_level));
					case 29: return new ItemMagic(_index,"Terrify",_level,CURSE,50,ActionData.makeAction(ActionData.TERRIFY,_level));
					case 30: return new ItemMagic(_index,"Dark Burst",_level,DAMAGING,50,ActionData.makeAction(ActionData.DARK_BLAST,_level));
					
					case 31: return new ItemModel(_index,"Healing Potion",_level,USEABLE,POTION,HEALING,30,ActionData.makeAction(ActionData.HEALING_POT,_level),null,(_charges>=0)?_charges:(Math.ceil(Math.random()*6)));
					case 32: return new ItemModel(_index,"Mana Potion",_level,USEABLE,POTION,MANA,40,ActionData.makeAction(ActionData.MANA_POT,_level),null,(_charges>=0)?_charges:(Math.ceil(Math.random()*6)));
					case 33: return new ItemModel(_index,"Amplification Potion",_level,USEABLE,POTION,BUFF,40,ActionData.makeAction(ActionData.BUFF_POT,_level),null,(_charges>=0)?_charges:(Math.ceil(Math.random()*6)));
					case 34: return new ItemModel(_index,"Alchemist Fire",_level,USEABLE,GRENADE,DAMAGING,20,ActionData.makeAction(ActionData.ALCH_POT,_level),null,(_charges>=0)?_charges:(Math.ceil(Math.random()*6)));
					case 35: return new ItemModel(_index,"Toxic Gas",_level,USEABLE,GRENADE,CURSE,20,ActionData.makeAction(ActionData.POISON_POT,_level),null,(_charges>=0)?_charges:(Math.ceil(Math.random()*6)));
					case 36: return new ItemModel(_index,"Holy Water",_level,USEABLE,GRENADE,DAMAGING,20,ActionData.makeAction(ActionData.HOLY_POT,_level),null,(_charges>=0)?_charges:(Math.ceil(Math.random()*6)));
					
					case 37: return new ItemModel(_index,"Throwing Dagger",_level,USEABLE,PROJECTILE,DAMAGING,20,ActionData.makeAction(ActionData.THROW_D,_level),null,(_charges>=0)?_charges:Math.ceil(5+Math.random()*5));
					case 38: return new ItemModel(_index,"Throwing Axe",_level,USEABLE,PROJECTILE,DAMAGING,20,ActionData.makeAction(ActionData.THROW_A,_level),null,(_charges>=0)?_charges:Math.ceil(5+Math.random()*5));
					case 39: return new ItemModel(_index,"Darts",_level,USEABLE,PROJECTILE,DAMAGING,30,ActionData.makeAction(ActionData.SHOOT,_level),null,(_charges>=0)?_charges:Math.ceil(5+Math.random()*20));
					
					case 40: return new ItemModel(_index,"Statue",_level,USEABLE,CHARM,BUFF,100);
					case 41: return new ItemModel(_index,"Skull",_level,USEABLE,CHARM,BUFF,100);
					case 42: return new ItemModel(_index,"Feather",_level,USEABLE,CHARM,BUFF,100);
					case 43: return new ItemModel(_index,"Beads",_level,USEABLE,CHARM,BUFF,100);
					case 44: return new ItemModel(_index,"Hoof",_level,USEABLE,CHARM,BUFF,100);
					
					case 45: return new ItemModel(_index,"Diamond",_level,TRADE,TRADE,"",200*(1+Math.min(3.5, 0.1*_level)));
					case 46: return new ItemModel(_index,"Sapphire",_level,TRADE,TRADE,"",180*(1+Math.min(3.5, 0.1*_level)));
					case 47: return new ItemModel(_index,"Ruby",_level,TRADE,TRADE,"",160*(1+Math.min(3.5, 0.1*_level)));
					case 48: return new ItemModel(_index,"Emerald",_level,TRADE,TRADE,"",140*(1+Math.min(3.5, 0.1*_level)));
					case 49: return new ItemModel(_index,"Amethyst",_level,TRADE,TRADE,"",120*(1+Math.min(3.5, 0.1*_level)));
					
					case 50: case 51: case 52: case 53: case 54: case 55: case 56: case 57: case 58: case 59: case 60: case 61: 
						return new ItemScroll(_level,spawnItem(_level+Math.ceil(Math.min(_level,15)*0.25),_index-36),(_charges>=0)?_charges:1);
					case 62: 
						return new ItemScroll(_level,null,-1);
				}
			}else if (_index<=111){
				switch (_index){
					case 64: return new ItemEquipment(_index,"Kabuto",_level,HELMET,HEAVY,500,null,[[SpriteModel.STAT,StatModel.HEALTH,110+62*_level],[SpriteModel.STAT,StatModel.RCRIT,.35],[SpriteModel.STAT,StatModel.INITIATIVE,-40],[SpriteModel.STAT,StatModel.DODGE,-0.2],[SpriteModel.STAT,StatModel.STRENGTH,10+4*_level],[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.SACRIFICE,_level)]],[EffectData.PREMIUM]);
					case 65: return new ItemEquipment(_index,"Hood",_level,HELMET,UNARMORED,500,null,[[SpriteModel.STAT,StatModel.HEALTH,60+26*_level],[SpriteModel.STAT,StatModel.HOLYEFF,0.022+0.022*_level]],[EffectData.PREMIUM]);
					case 66: return new ItemEquipment(_index,"Phrygian Cap",_level,HELMET,LIGHT,500,null,[[SpriteModel.STAT,StatModel.HEALTH,80+40*_level],[SpriteModel.STAT,StatModel.RCRIT,.1],[SpriteModel.STAT,StatModel.ITEMEFF,0.01+0.0127*_level]],[EffectData.PREMIUM]);
					case 67: return new ItemEquipment(_index,"Plumber Hat",_level,HELMET,UNARMORED,500,null,[[SpriteModel.STAT,StatModel.HEALTH,60+26*_level],[SpriteModel.STAT,StatModel.RCRIT,.05],[SpriteModel.STAT,StatModel.INITIATIVE,2+2*_level],[SpriteModel.STAT,StatModel.CHEMEFF,0.018+0.018*_level]],[EffectData.PREMIUM]);
					case 68: return new ItemEquipment(_index,"Boxing Gear",_level,HELMET,UNARMORED,500,null,[[SpriteModel.STAT,StatModel.HEALTH,59+25*_level],[SpriteModel.STAT,StatModel.RCRIT,.1],[SpriteModel.STAT,StatModel.BLOCK,6+6*_level],[SpriteModel.STAT,StatModel.DODGE,0.02+0.005*_level]],[EffectData.PREMIUM]);
					case 69: return new ItemEquipment(_index,"Turban",_level,HELMET,UNARMORED,500,null,[[SpriteModel.STAT,StatModel.HEALTH,63+27*_level],[SpriteModel.STAT,StatModel.RCRIT,.05],[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.QUICK,1+0.5*_level)]],[EffectData.PREMIUM]);
					case 70: return new ItemEquipment(_index,"Crown",_level,HELMET,MEDIUM,500,null,[[SpriteModel.STAT,StatModel.HEALTH,110+58*_level],[SpriteModel.STAT,StatModel.RCRIT,.2],[SpriteModel.STAT,StatModel.INITIATIVE,-10],[SpriteModel.STAT,StatModel.DODGE,-0.1],[SpriteModel.STAT,StatModel.ILOOT,0.06+0.006*_level]],[EffectData.PREMIUM]);
					case 71: return new ItemEquipment(_index,"Protector",_level,HELMET,UNARMORED,500,null,[[SpriteModel.STAT,StatModel.HEALTH,61+27*_level],[SpriteModel.STAT,StatModel.RCRIT,.05],[SpriteModel.STAT,StatModel.MANA,5+1*_level],[SpriteModel.STAT,StatModel.STRENGTH,1+_level],[SpriteModel.STAT,StatModel.MPOWER,1+_level],[SpriteModel.STAT,StatModel.INITIATIVE,1+_level],[SpriteModel.STAT,StatModel.DODGE,0.01+0.003*_level],[SpriteModel.STAT,StatModel.TURN,0.01+0.003*_level]],[EffectData.PREMIUM]);
					
					case 72: return new ItemEquipment(_index,"Katanas",_level,WEAPON,DOUBLE,500,ActionData.makeWeapon(20+1.2*_level,null,null,0,0.10+0.02*_level,-0.25-0.05*_level),null,[EffectData.PREMIUM]);
					case 73: return new ItemEquipment(_index,"Light Sword",_level,WEAPON,TWO_HANDED,500,ActionData.makeWeapon(27+2.45*_level,new <EffectBase>[new EffectDamage("Luminant",18+9.5*_level,DamageModel.HOLY),EffectData.makeEffect(EffectData.ILLUMINATED,_level)],null,0,0,0,[EffectData.BONUS_STRENGTH]),null,[EffectData.PREMIUM]);
					case 74: return new ItemEquipment(_index,"Rending Claws",_level,WEAPON,UNARMED,500,null,[[SpriteModel.UNARMED,ActionBase.CRITRATE,0.05+0.007*_level],[SpriteModel.UNARMED,ActionBase.CRITMULT,0.1+0.05*_level],[SpriteModel.UNARMED,ActionBase.CEFFECT,EffectData.makeEffect(EffectData.REND,_level)]],[EffectData.PREMIUM]);
					case 75: return new ItemEquipment(_index,"Hylian Sword",_level,WEAPON,SHIELD,500,ActionData.makeWeapon(29+1.9*_level,new <EffectBase>[EffectData.makeEffect(EffectData.FULL_POWER,_level)],null,0,0,0,[EffectData.LONG_RANGED],true),[[SpriteModel.STAT,StatModel.BLOCK,12+11*_level]],[EffectData.PREMIUM]);
					case 76: return new ItemEquipment(_index,"Plumber Gloves",_level,WEAPON,UNARMED,500,null,[[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectDamage("Blazing",10+4*_level,DamageModel.CHEMICAL,7,1,PopEffect.FIRE)]],[EffectData.PREMIUM]);
					case 77: return new ItemEquipment(_index,"Boxing Gloves",_level,WEAPON,UNARMED,500,null,[[SpriteModel.STAT,StatModel.BLOCK,4+4*_level],[SpriteModel.STAT,StatModel.DODGE,0.05+0.005*_level]],[EffectData.PREMIUM]);
					case 78: return new ItemEquipment(_index,"Saruman's Staff",_level,WEAPON,TWO_HANDED,500,ActionData.makeWeapon(20+1.05*_level,null,null,0,0,0,[EffectData.BONUS_STRENGTH]),[[SpriteModel.STAT,StatModel.MPOWER,12+7*_level],[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.BEFUDDLE,_level)]],[EffectData.PREMIUM]);
					case 79: return new ItemEquipment(_index,"Mjolnir",_level,WEAPON,TWO_HANDED,500,ActionData.makeWeapon(30+1.6*_level,null,new <EffectBase>[new EffectDamage("Bonus Physical",38+22*_level,DamageModel.PHYSICAL),EffectData.makeEffect(EffectData.SMASH,_level)],0,0,0,[EffectData.BONUS_STRENGTH]),null,[EffectData.PREMIUM]);
					case 80: return new ItemEquipment(_index,"Captain's Shield",_level,WEAPON,SHIELD,500,ActionData.makeWeapon(29+2.05*_level,null,null,10+5*_level,-0.05,0,[EffectData.RANGED],true),[[SpriteModel.STAT,StatModel.BLOCK,17+17*_level]],[EffectData.PREMIUM]);
					case 81: return new ItemEquipment(_index,"Twin Scimitars",_level,WEAPON,DOUBLE,500,ActionData.makeWeapon(15+1.07*_level,new <EffectBase>[EffectData.makeEffect(EffectData.QUICK,1+0.5*_level)],null,10+_level*2,0,0,[EffectData.PIERCE]),null,[EffectData.PREMIUM]);
					case 82: return new ItemEquipment(_index,"Royal Scepter",_level,WEAPON,SHIELD,500,ActionData.makeWeapon(18+1.2*_level),[[SpriteModel.STAT,StatModel.BLOCK,16+15*_level],[SpriteModel.STAT,StatModel.MPOWER,5+2.5*_level],[SpriteModel.STAT,StatModel.ILOOT,0.05+0.005*_level]],[EffectData.PREMIUM]);
					
					//BATCH 2
					case 83: return new ItemEquipment(_index,"Neptune's Trident",_level, WEAPON,TWO_HANDED,500,ActionData.makeWeapon(28+1.8*_level,new <EffectBase>[EffectData.makeEffect(EffectData.MPOWSCALING,10)],null,0,0,0,[EffectData.BONUS_STRENGTH]),[[SpriteModel.STAT,StatModel.MPOWER,10+4*_level]],[EffectData.PREMIUM]);
					case 84: return new ItemEquipment(_index,"Ancient Ankh",_level,WEAPON,TWO_HANDED,500,ActionData.makeWeapon(20+1.55*_level,null,null,0,0,0,[EffectData.BONUS_STRENGTH]),[[SpriteModel.STAT,StatModel.MPOWER,13+7*_level],[SpriteModel.STAT,StatModel.SPELLSTEAL,0.03+0.006*_level]],[EffectData.PREMIUM]);
					case 85: return new ItemEquipment(_index,"Baseball Bat",_level,WEAPON,TWO_HANDED,500,ActionData.makeWeapon(30+1.6*_level,null,new <EffectBase>[new EffectDamage("Bonus Physical",49+28*_level,DamageModel.PHYSICAL),EffectData.makeEffect(EffectData.KNOCKBACK_NO,_level)],0,0,0,[EffectData.BONUS_STRENGTH]),null,[EffectData.PREMIUM]);
					case 86: return new ItemEquipment(_index,"Breaker Sword",_level,WEAPON,TWO_HANDED,500,ActionData.makeWeapon(44+2.9*_level,null,null,0,0,0,[EffectData.BONUS_STRENGTH]),null,[EffectData.PREMIUM]);
					case 87: return new ItemEquipment(_index,"Board with a Nail In It",_level,WEAPON,TWO_HANDED,500,ActionData.makeWeapon(36+2.4*_level,new <EffectBase>[EffectData.makeEffect(EffectData.TERRIFYING,_level)],null,0,0,0,[EffectData.BONUS_STRENGTH]),null,[EffectData.PREMIUM]);
					
					case 88: return new ItemEquipment(_index,"Mullet",_level,HELMET,HEAVY,500,null,[[SpriteModel.STAT,StatModel.HEALTH,150+70*_level],[SpriteModel.STAT,StatModel.RCRIT,.25],[SpriteModel.STAT,StatModel.INITIATIVE,-40],[SpriteModel.STAT,StatModel.DODGE,-0.2],[SpriteModel.STAT,StatModel.POTEFF,0.05+Facade.diminish(0.005,_level)]],[EffectData.PREMIUM]);
					case 89: return new ItemEquipment(_index,"Ampersand",_level,HELMET,LIGHT,500,null,[[SpriteModel.STAT,StatModel.HEALTH,80+41*_level],[SpriteModel.STAT,StatModel.RCRIT,.15],[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.BUFF_POT_BOOST,_level)]],[EffectData.PREMIUM]);
					case 90: return new ItemEquipment(_index,"Death Jester",_level,HELMET,LIGHT,500,null,[[SpriteModel.STAT,StatModel.HEALTH,50+20*_level],[SpriteModel.STAT,StatModel.RCRIT,.05],[SpriteModel.STAT,StatModel.HREGEN,0.02+0.002*_level],[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.UNDYING,_level)]],[EffectData.PREMIUM]);
					case 91: return new ItemEquipment(_index,"Envenomed Mask",_level, HELMET,MEDIUM,500,null,[[SpriteModel.STAT,StatModel.HEALTH,100+52*_level],[SpriteModel.STAT,StatModel.RCRIT,.25],[SpriteModel.STAT,StatModel.INITIATIVE,-20],[SpriteModel.STAT,StatModel.DODGE,-0.1],[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.AUTOBUFF,1+_level)],[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.BERSERKER,_level)]],[EffectData.PREMIUM]);
					
					case 92: return new ItemModel(_index,"Rose Thorns",_level,USEABLE,PROJECTILE,DAMAGING,500,ActionData.makeAction(ActionData.THROW_ROSE,_level),null,(_charges>=0)?_charges:2,[EffectData.PREMIUM]);
					case 93: return new ItemModel(_index,"Classic Bomb",_level,USEABLE,GRENADE,CURSE,500,ActionData.makeAction(ActionData.THROW_BOMB,_level),null,(_charges>=0)?_charges:10,[EffectData.PREMIUM]);
					case 94: return new ItemModel(_index,"Flying Rat",_level,USEABLE,PROJECTILE,DAMAGING,500,ActionData.makeAction(ActionData.THROW_BATARANG,_level),null,-1,[EffectData.PREMIUM]);
					case 95: return new ItemModel(_index,"Chakram",_level,USEABLE,PROJECTILE,DAMAGING,500,ActionData.makeAction(ActionData.THROW_CHAKRAM,_level),null,-1,[EffectData.PREMIUM]);
					
					case 96: return new ItemModel(_index,"Recovery Potion",_level,USEABLE,POTION,RECOVERY,40,ActionData.makeAction(ActionData.RECOVERY_POT,_level),null,(_charges>=0)?_charges:(Math.ceil(Math.random()*6)));
					case 97: return new ItemModel(_index,"Celerity Potion",_level,USEABLE,POTION,BUFF,40,ActionData.makeAction(ActionData.CELERITY_POT,_level),null,(_charges>=0)?_charges:(Math.ceil(Math.random()*6)));
					case 98: return new ItemModel(_index,"Turtle Soup",_level,USEABLE,POTION,BUFF,40,ActionData.makeAction(ActionData.TURTLE_POT,_level),null,(_charges>=0)?_charges:(Math.ceil(Math.random()*6)));
					case 99: return new ItemModel(_index,"Purity Potion",_level,USEABLE,POTION,BUFF,40,ActionData.makeAction(ActionData.PURITY_POT,_level),null,(_charges>=0)?_charges:(Math.ceil(Math.random()*6)));
					
					case 100: return new ItemModel(_index,"Random Premium",_level,"MYSTERY","UNKNOWN",null,2000000);
					
					case 101: return new ItemEquipment(_index,"Riot Helmet",_level,HELMET,HEAVY,500,null,[[SpriteModel.STAT,StatModel.HEALTH,120+62*_level],[SpriteModel.STAT,StatModel.RCRIT,.3],[SpriteModel.STAT,StatModel.INITIATIVE,-40],[SpriteModel.STAT,StatModel.DODGE,-0.2],[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.RESPECT,_level)]],[EffectData.PREMIUM]);
					case 102: return new ItemEquipment(_index,"Hell Horns",_level,HELMET,UNARMORED,500,null,[[SpriteModel.STAT,StatModel.HEALTH,60+21*_level],[SpriteModel.STAT,StatModel.RCRIT,0.05],[SpriteModel.STAT,StatModel.RPHYS,0.04+0.004*_level],[SpriteModel.STAT,StatModel.RCHEMICAL,0.1+0.01*_level]],[EffectData.PREMIUM]);
					case 103: return new ItemEquipment(_index,"Hockey Mask",_level,HELMET,MEDIUM,500,null,[[SpriteModel.STAT,StatModel.HEALTH,100+52*_level],[SpriteModel.STAT,StatModel.RCRIT,.2],[SpriteModel.STAT,StatModel.INITIATIVE,-20],[SpriteModel.STAT,StatModel.DODGE,-0.1],[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.FEAR_BOOST,_level)]],[EffectData.PREMIUM]);
					case 104: return new ItemEquipment(_index,"Propeller Beanie",_level,HELMET,LIGHT,500,null,[[SpriteModel.STAT,StatModel.HEALTH,80+40*_level],[SpriteModel.STAT,StatModel.RCRIT,.1],[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.MOVE_BOOST,_level)]],[EffectData.PREMIUM]);
					
					case 105: return new ItemEquipment(_index,"Riot Gear",_level,WEAPON,SHIELD,500,ActionData.makeWeapon(26+1.7*_level,new <EffectBase>[EffectData.makeEffect(EffectData.AUTHORITAH,_level)]),[[SpriteModel.STAT,StatModel.BLOCK,17+17*_level]],[EffectData.PREMIUM]);
					case 106: return new ItemEquipment(_index,"Hell Hands",_level,WEAPON,UNARMED,500,null,[[SpriteModel.UNARMED,ActionBase.EFFECT,EffectData.makeEffect(EffectData.COMBO,_level)]],[EffectData.PREMIUM]);
					case 107: return new ItemEquipment(_index,"Chainsaw",_level,WEAPON,TWO_HANDED,500,ActionData.makeWeapon(1,new <EffectBase>[EffectData.makeEffect(EffectData.CHAIN,3)],new <EffectBase>[new EffectDamage("Bonus Physical",55+10*_level,DamageModel.PHYSICAL),EffectData.makeEffect(EffectData.TERRIFYING,1)],0,0.03+0.025*_level),null,[EffectData.PREMIUM]);
					case 108: return new ItemModel(_index,"Eternal Tome",_level,EQUIPMENT,WEAPON,HELD,500,null,[[SpriteModel.STAT,StatModel.MPOWER,13+7*_level],[SpriteModel.STAT,StatModel.MRATE,0.2+0.03*_level]],-1,[EffectData.NO_ATTACK,EffectData.PREMIUM]);
					case 109: return new ItemModel(_index,"Temporary Bow",_level,EQUIPMENT,WEAPON,HELD,500,null,[[SpriteModel.STAT,StatModel.PHYSEFF,0.1+0.01*_level],[SpriteModel.STAT,StatModel.IRATE,0.2+0.03*_level]],-1,[EffectData.NO_ATTACK,EffectData.PREMIUM]);
					
					case 110: return new ItemEquipment(_index,"Dark Half Hood",_level,HELMET,LIGHT,500,null,[[SpriteModel.STAT,StatModel.HEALTH,80+40*_level],[SpriteModel.STAT,StatModel.RCRIT,0.15],[SpriteModel.STAT,StatModel.DARKEFF,0.022+0.022*_level]],[EffectData.PREMIUM]);
					case 111: return new ItemEquipment(_index,"Dark Half Swords",_level,WEAPON,DOUBLE,500,ActionData.makeWeapon(11+1*_level,new <EffectBase>[new EffectDamage("Scorched",11+4.5*_level,DamageModel.DARK),EffectData.makeEffect(EffectData.SCORCHED,_level)]),null,[EffectData.PREMIUM]);
				}
			}else{
				switch(_index){
					case 112: return new ItemModel(_index,"Pentagram",_level,USEABLE,TRINKET,MANA,4000,ActionData.makeAction(ActionData.MANA_PENTA,_level),[[SpriteModel.STAT,StatModel.PROCEFF,0.1+0.016*_level]],1,[EffectData.RELIC,EffectData.SUPER_PREMIUM]);
					case 113: return new ItemModel(_index,"Holy Grail",_level,USEABLE,TRINKET,HEALING,4000,null,[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.REVIVE_GRAIL,_level)]],-1,[EffectData.RELIC,EffectData.SUPER_PREMIUM]);
					
					case 114: return new ItemEquipment(_index,"Crusader Mace",_level,WEAPON,TWO_HANDED,750,ActionData.makeWeapon(36+2.4*_level,null,null,0,0,0,[EffectData.BONUS_STRENGTH]),[[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.MAGIC_STRIKE,_level)]],[EffectData.SUPER_PREMIUM]);
					case 115: return new ItemEquipment(_index,"Crusader Helmet",_level,HELMET,HEAVY,750,null,[[SpriteModel.STAT,StatModel.HEALTH,120+62*_level],[SpriteModel.STAT,StatModel.RCRIT,.35],[SpriteModel.STAT,StatModel.INITIATIVE,-40],[SpriteModel.STAT,StatModel.DODGE,-0.2],[SpriteModel.STAT,StatModel.HEALMULT,0.05+0.006*_level],[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.INITIAL_BLESS,_level)]],[EffectData.SUPER_PREMIUM]);
					case 116: return new ItemEquipment(_index,"Demon Sickles",_level,WEAPON,DOUBLE,750,ActionData.makeWeapon(8+0.5*_level,new <EffectBase>[EffectData.makeEffect(EffectData.DELAYED_DAMAGE,_level)],null,10+_level*2,0,0,[EffectData.PIERCE]),null,[EffectData.SUPER_PREMIUM]);
					case 117: return new ItemEquipment(_index,"Demon Horns",_level,HELMET,LIGHT,750,null,[[SpriteModel.STAT,StatModel.HEALTH,70+40*_level],[SpriteModel.STAT,StatModel.RCRIT,0.15],[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.CURSE_REFLECT,_level)]],[EffectData.SUPER_PREMIUM]);
					
					case 118: return new ItemModel(_index,"Achievement Award",_level,TRADE,TRADE,"",-1,null,null,-1,[EffectData.PREMIUM]);
					case 119: return new ItemModel(_index,"Trophy",_level,USEABLE,CHARM,BUFF,3500,null,[[SpriteModel.STAT,StatModel.STRENGTH,2+2*_level],[SpriteModel.STAT,StatModel.MPOWER,2+2*_level],[SpriteModel.STAT,StatModel.INITIATIVE,2+2*_level],[SpriteModel.STAT,StatModel.THROWEFF,0.02+0.02*_level],[SpriteModel.STAT,StatModel.HEALTH,4+4*_level],[SpriteModel.STAT,StatModel.ILOOT,0.06+0.006*_level],[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.AWARD,_level)]],-1,[EffectData.RELIC]);
					
					case 120: return new ItemEquipment(_index,"Big Pencil",_level,WEAPON,TWO_HANDED,750,ActionData.makeWeapon(35+2.3*_level,null,null,0,0,0,[EffectData.BONUS_STRENGTH]),[[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.MAGIC_STRIKE,_level)]],[EffectData.SUPER_PREMIUM]);
					
					case 121: return new ItemEquipment(_index,"Tramp Hair",_level,HELMET,HEAVY,750,null,[[SpriteModel.STAT,StatModel.HEALTH,120+62*_level],[SpriteModel.STAT,StatModel.RCRIT,.3],[SpriteModel.STAT,StatModel.INITIATIVE,-30],[SpriteModel.STAT,StatModel.DODGE,-0.2],[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.IGNORE_ATTACK,_level)],[SpriteModel.UNARMED,ActionBase.EFFECT,EffectData.makeEffect(EffectData.UNARMED_INIT,_level)]],[EffectData.SUPER_PREMIUM]);//trump
					case 122: return new ItemEquipment(_index,"Princess",_level,HELMET,MEDIUM,750,null,[[SpriteModel.STAT,StatModel.HEALTH,100+52*_level],[SpriteModel.STAT,StatModel.RCRIT,.2],[SpriteModel.STAT,StatModel.INITIATIVE,-20],[SpriteModel.STAT,StatModel.DODGE,-0.1],[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.BARRIER,_level)]],[EffectData.SUPER_PREMIUM]);//princess
					case 123: return new ItemEquipment(_index,"Masta Rasta",_level,HELMET,LIGHT,750,null,[[SpriteModel.STAT,StatModel.HEALTH,78+38*_level],[SpriteModel.STAT,StatModel.RCRIT,.1],[SpriteModel.STAT,StatModel.MANA,18+7*_level],[SpriteModel.STAT,StatModel.EFFECT,new EffectBuffBasic(BuffData.makeBuff(BuffData.HIGH,_level),EffectBase.BUFF,EffectBase.SAFE)]],[EffectData.SUPER_PREMIUM]);//rasta
					case 124: return new ItemEquipment(_index,"Sapien Hair",_level,HELMET,LIGHT,750,null,[[SpriteModel.STAT,StatModel.HEALTH,60+26*_level],[SpriteModel.STAT,StatModel.RCRIT,.1],[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.REVIVE_GOKU,_level)]],[EffectData.SUPER_PREMIUM]);
					
					case 125: return new ItemMagic(_index,"Multibolt",_level,DAMAGING,500,ActionData.makeAction(ActionData.MULTI_BOLT,_level),[EffectData.PREMIUM]);
					
					case 126: return new ItemEquipment(_index,"Shortbow",_level,WEAPON,RANGED,80,ActionData.makeRanged(35+1.5*_level,null,null,0,0,0,0,[EffectData.PIERCE,EffectData.LONG_RANGED]));
					case 127: return new ItemEquipment(_index,"Shotgun",_level,WEAPON,RANGED,80,ActionData.makeRanged(35+1.5*_level,null,null,0,0,0,0,[EffectData.PIERCE,EffectData.LONG_RANGED]));
					case 128: return new ItemEquipment(_index,"Rifle",_level,WEAPON,RANGED,80,ActionData.makeRanged(35+1.5*_level,new <EffectBase>[EffectData.makeEffect(EffectData.MULTI,5)],null,0,0,0,0,[EffectData.PIERCE,EffectData.LONG_RANGED]));
					
					case 129: return new ItemEquipment(_index,"Sparrow's Bow",_level,WEAPON,RANGED,500,ActionData.makeRanged(38+1.65*_level,null,null,2+2*_level,0,0,0.1,[EffectData.PIERCE,EffectData.LONG_RANGED]),null,[EffectData.PREMIUM]);
					case 130: return new ItemEquipment(_index,"Bycocket",_level,HELMET,LIGHT,500,null,[[SpriteModel.STAT,StatModel.HEALTH,80+40*_level],[SpriteModel.STAT,StatModel.RCRIT,.1],[SpriteModel.STAT,StatModel.FAR,0.1+0.01*_level]],[EffectData.PREMIUM]);
					case 131: return new ItemModel(_index,"Quickdraw Quiver",_level,USEABLE,TRINKET,BUFF,4000,null,[[SpriteModel.ATTACK,ActionBase.CRITRATE,0.01+0.006*_level],[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.DOUBLESHOT,Math.floor(_level/3+1))]],-1,[EffectData.RELIC,EffectData.SUPER_PREMIUM]);
					
					case 132: return new ItemEquipment(_index,"Sais",_level,WEAPON,DOUBLE,500,ActionData.makeWeapon(14+0.94*_level,null,null,0,0.1+0.015*_level,0,[EffectData.PIERCE]),[[SpriteModel.STAT,StatModel.BLOCK,10+2*_level]],[EffectData.PREMIUM]);
					case 133: return new ItemEquipment(_index,"Fukumen",_level,HELMET,UNARMORED,500,null,[[SpriteModel.STAT,StatModel.HEALTH,61+26*_level],[SpriteModel.STAT,StatModel.RCRIT,0.05],[SpriteModel.STAT,StatModel.DODGE,0.1+0.01*_level]],[EffectData.PREMIUM]);
					case 134: return new ItemModel(_index,"Shuriken",_level,USEABLE,PROJECTILE,DAMAGING,750,ActionData.makeAction(ActionData.SHURIKEN,_level),null,(_charges>=0)?_charges:50,[EffectData.SUPER_PREMIUM]);
					
					case 135: return new ItemModel(_index,"Essence",15,TRADE,ESSENCE,"",200*(1+0.1*_level),null,[[SpriteModel.ATTACK,ActionBase.TAG,EffectData.SUFFIX_ESSENCE]],_charges,[EffectData.ESSENCE]);
					case 136: return new ItemModel(_index,"Epic Essence",15,TRADE,ESSENCE,"",200*(1+0.1*_level),null,[[SpriteModel.ATTACK,ActionBase.TAG,EffectData.EPIC_ESSENCE]],_charges,[EffectData.ESSENCE]);
					
					case 137: return new ItemModel(_index,"Screamer",_level,USEABLE,TRINKET,CURSE,4000,ActionData.makeAction(ActionData.SCREAMER,_level),[],(_charges>=0)?_charges:2,[EffectData.RELIC,EffectData.PREMIUM]);
					case 138: return new ItemModel(_index,"Puzzling Mask",_level,USEABLE,TRINKET,BUFF,4000,null,[[SpriteModel.STAT,StatModel.SPELLSTEAL,0.05+0.005*_level],[SpriteModel.STAT,StatModel.EFFECT,new EffectBuffBasic(BuffData.makeBuff(BuffData.TRAP,_level),EffectBase.CURSE,EffectBase.INITIAL)]],-1,[EffectData.RELIC,EffectData.SUPER_PREMIUM]);
					case 139: return new ItemModel(_index,"Big Bad Mask",_level,USEABLE,TRINKET,BUFF,4000,null,[[SpriteModel.ATTACK,ActionBase.HITRATE,2+2*_level],[SpriteModel.ATTACK,ActionBase.CRITRATE,0.01+0.005*_level],[SpriteModel.ATTACK,ActionBase.CRITMULT,0.1+0.05*_level],[SpriteModel.STAT,StatModel.ILOOT,0.05+0.005*_level],[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.GOLD_PER_KILL,_level)]],-1,[EffectData.RELIC,EffectData.PREMIUM]);
					case 140: return new ItemModel(_index,"Muzzle",_level,USEABLE,TRINKET,DAMAGING,4000,ActionData.makeAction(ActionData.CANNIBAL,_level),[[SpriteModel.ATTACK,ActionBase.LEECH,0.05+0.005*_level]],(_charges>=0)?_charges:1,[EffectData.RELIC,EffectData.SUPER_PREMIUM]);
					case 141: return new ItemModel(_index,"Ruby Visor",_level,USEABLE,TRINKET,DAMAGING,4000,ActionData.makeAction(ActionData.CYCLOPS,_level),[],(_charges>=0)?_charges:1,[EffectData.RELIC,EffectData.PREMIUM]);
					case 142: return new ItemModel(_index,"Rocketman",_level,USEABLE,TRINKET,BUFF,4000,null,[[SpriteModel.STAT,StatModel.TURN_REDUCE,0.05],[SpriteModel.STAT,StatModel.MANA,2+2*_level],[SpriteModel.STAT,StatModel.MANATOMPOW,0.05+0.01*_level]],-1,[EffectData.RELIC,EffectData.SUPER_PREMIUM]);
					case 143: return new ItemModel(_index,"Monacle",_level,USEABLE,TRINKET,BUFF,4000,null,[[SpriteModel.STAT,StatModel.STRENGTH,2+2*_level],[SpriteModel.STAT,StatModel.MPOWER,2+2*_level],[SpriteModel.STAT,StatModel.INITIATIVE,2+2*_level],[SpriteModel.STAT,StatModel.THROWEFF,0.02+0.02*_level],[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.NO_OFFENSIVE,_level)]],-1,[EffectData.RELIC,EffectData.PREMIUM]);
					case 144: return new ItemModel(_index,"Goggles",_level,USEABLE,TRINKET,BUFF,4000,null,[[SpriteModel.STAT,StatModel.THROWEFF,0.03+0.03*_level],[SpriteModel.STAT,StatModel.CHEMEFF,0.015+0.015*_level],[SpriteModel.ATTACK,ActionBase.DODGE_REDUCE,0.05],[SpriteModel.STAT,StatModel.RCHEMICAL,0.01+0.01*_level],[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.FIND_STACKS,_level)]],-1,[EffectData.RELIC,EffectData.SUPER_PREMIUM]);
					case 145: return new ItemEquipment(_index,"Dragon Sword",_level,WEAPON,SHIELD,70,ActionData.makeWeapon(26+1.7*_level),[[SpriteModel.STAT,StatModel.BLOCK,12+11*_level]]);
					case 146: return new ItemEquipment(_index,"Raider Sword",_level,WEAPON,SHIELD,70,ActionData.makeWeapon(26+1.7*_level),[[SpriteModel.STAT,StatModel.BLOCK,12+11*_level]]);
					case 147: return new ItemEquipment(_index,"Dragon Helmet",_level,HELMET,HEAVY,100,null,[[SpriteModel.STAT,StatModel.HEALTH,120+62*_level],[SpriteModel.STAT,StatModel.RCRIT,.3],[SpriteModel.STAT,StatModel.INITIATIVE,-40],[SpriteModel.STAT,StatModel.DODGE,-0.2]]);
					case 148: return new ItemEquipment(_index,"Raider Helmet",_level,HELMET,MEDIUM,80,null,[[SpriteModel.STAT,StatModel.HEALTH,100+52*_level],[SpriteModel.STAT,StatModel.RCRIT,.2],[SpriteModel.STAT,StatModel.INITIATIVE,-20],[SpriteModel.STAT,StatModel.DODGE,-0.1]]);
				}
			}
			
			return new ItemModel(_index,"UNSPECIFIED",_level,TRADE,TRADE,"",200*(1+0.1*_level));
		}
		
		public static function randomItem(_type:String,_level:int):ItemModel{
			var i:int;
			switch(_type){
				case WEAPON: 
					i=Math.floor(Math.random()*10);
					if (i==9) i=126;
					return spawnItem(_level,i);
				case HELMET: return spawnItem(_level,9+Math.floor(Math.random()*5));
				case MAGIC: return spawnItem(_level,14+Math.floor(Math.random()*12));
				case POTION: 
					i=31+Math.floor(Math.random()*6);
					if (i==33){
						i=Math.floor(Math.random()*5);
						if (i==4){
							i=33;
						}else{
							i+=96
						}
					}
					return spawnItem(_level,i);
				case PROJECTILE: return spawnItem(_level,37+Math.floor(Math.random()*3));
				case CHARM: return spawnItem(_level,40+Math.floor(Math.random()*5));
				case TRADE: return spawnItem(_level,45+Math.floor(Math.random()*5));
				case SCROLL: 
					if (_level==-1){
						return new ItemScroll(_level,null,0);
					}else{
						return spawnItem(_level,50+Math.floor(Math.random()*12));
					}
				default: throw(new Error("Invalid type: "+_type));
			}
			
			
		}
		
		public static function enchantItem(m:ItemModel,_index:int=-1):ItemModel{
			if (_index==-2) return m;
			if (m.enchantIndex>=0){
				
			}
			
			if (m.index==119){
				switch(_index){
					case 1: m.name="Gold "+m.name; break;
					case 2: m.name="Silver "+m.name; break;
					case 3: m.name="Bronze "+m.name; break;
					default: m.name="Rank #"+String(_index)+" "+m.name; break;
				}
				m.enchantIndex=_index;
				return m;
			}
			
			if (m.index === 118) {
				m.name = m.name+" #"+_index;
				m.enchantIndex=_index;
				m.cost=-1;
				return m;
			}
			
			if (m.isPremium()){
				return enchantPremium(m,_index);
			}
			
			if (m.primary==MAGIC){
				return enchantSpell(m,_index);
			}else if ((m.primary==PROJECTILE)||(m.primary==SCROLL)){
				if (_index==-1) _index=Math.floor(Math.random()*15);
				return enchantProjectile(m,_index);
			}else if (m.primary==POTION || m.primary==GRENADE){
				return enchantPotion(m,_index);
			}else if (m.primary==WEAPON){
				if (_index==-1){
					if (m.index==4){
						_index=Math.floor(Math.random()*14)+1;
					}else{
						_index=Math.floor(Math.random()*15);
					}
				}
				return enchantWeapon(m,_index);
			}else if (m.primary==HELMET){
				if (_index==-1) _index=15+Math.floor(Math.random()*15);
				return enchantHelmet(m,_index);
			}else if (m.primary==CHARM){
				if (_index==-1) _index=1+Math.floor(Math.random()*29);
				if (_index<15 || (_index>=100 && _index<115)){
					return enchantWeapon(m,_index);
				}else if (_index<30){
					return enchantHelmet(m,_index);
				}else if (_index==30){
					applyEnchant(30,"",m,1,[SpriteModel.STAT,StatModel.STRENGTH,2+2*m.level]);
					applyEnchant(30,"",m,1,[SpriteModel.STAT,StatModel.MPOWER,2+2*m.level]);
					applyEnchant(30,"",m,1,[SpriteModel.STAT,StatModel.INITIATIVE,2+2*m.level]);
					applyEnchant(30,"",m,1,[SpriteModel.STAT,StatModel.THROWEFF,0.02+0.02*m.level]);
					applyEnchant(30,"",m,1,[SpriteModel.STAT,StatModel.POTEFF,0.01+0.01*m.level]);
					applyEnchant(30,"",m,1,[SpriteModel.STAT,StatModel.MANA,2+1*m.level]);
					applyEnchant(30,"",m,1,[SpriteModel.STAT,StatModel.HEALTH,4+4*m.level]);
					applyEnchant(30,"",m,1,[SpriteModel.STAT,StatModel.BLOCK,1.5+1.5*m.level]);
					applyEnchant(30,"Shadow King's",m,30,[SpriteModel.ATTACK,ActionBase.HITRATE,2+2*m.level]);
					m.tags.push(EffectData.RELIC);
					return m;
				}else if (_index==31){
					applyEnchant(31,"",m,1,[SpriteModel.ATTACK,ActionBase.CRITRATE,0.005*m.level]);
					applyEnchant(31,"",m,1,[SpriteModel.ATTACK,ActionBase.CRITMULT,0.02*m.level]);
					applyEnchant(31,"",m,1,[SpriteModel.STAT,StatModel.DODGE,0.005*m.level]);
					applyEnchant(31,"",m,1,[SpriteModel.STAT,StatModel.TURN,0.005*m.level]);
					applyEnchant(31,"",m,1,[SpriteModel.STAT,StatModel.HEALTH,2+2*m.level]);
					applyEnchant(31,"Shadow Queen's",m,30,[SpriteModel.STAT,StatModel.MANA,2+1*m.level]);
					m.tags.push(EffectData.RELIC);
					return m;
				}
			}else if (m.index==135){
				m.values=[];
				if (_index==0){
					m.name="Scouring "+m.name;
					m.enchantIndex=0;
					m.values.push([SpriteModel.ATTACK,ActionBase.TAG,EffectData.SCOURING]);
					return m;
				}else if (_index==1){
					m.name="Chaos "+m.name;
					m.enchantIndex=1;
					m.values.push([SpriteModel.ATTACK,ActionBase.TAG,EffectData.CHAOS_ESSENCE]);
					return m;
				}else if (_index==2){
					m.name="Minor Chaos "+m.name;
					m.enchantIndex=2;
					m.values.push([SpriteModel.ATTACK,ActionBase.TAG,EffectData.MINOR_CHAOS_ESSENCE]);
					return m;
				}else if (_index==3){
					m.name="Plentiful "+m.name;
					m.enchantIndex=3;
					m.values.push([SpriteModel.ATTACK,ActionBase.TAG,EffectData.PLENTIFUL]);
					return m;
								   
				}
			}else if (m.primary==TRADE){
				if (_index==0){
					m.name="Shadow "+m.name;
					m.level=99;
					m.enchantIndex=0;
					m.cost=10000000;
					return m;
				}
			}
			//throw(new Error("Something happened with Enchanting"));
			return m;
		}
		
		public static function enchantProjectile(m:ItemModel,_index:int):ItemModel{
			switch (_index){
				case 1: applyEnchant(1,"Ready",m,2,[SpriteModel.ATTACK,ActionBase.USERATE,0.3]); break;
				case 2: 
					if (m.primary==SCROLL){
						m.tags=[EffectData.FULL_MPOW];
						applyEnchant(2,"Fully Powered",m,50,null);
					}else{
						applyEnchant(2,"Homing",m,3,[SpriteModel.ATTACK,ActionBase.DODGE_REDUCE,0.1]);
					} break;
				case 6: applyEnchant(6,"Plentiful",m,1,null); break;
				case 14: case 5: enchantWeapon(m,0); break;
				case 20: m.charges=-1; applyEnchant(20,"Unlimited",m,20,null); break;
				default: enchantWeapon(m,_index);
			}
			return m;
		}
		
		public static function enchantWeapon(m:ItemModel,_index:int):ItemModel{
			switch (_index){
				case 0: applyEnchant(0,"Master's",m,3,[SpriteModel.ATTACK,ActionBase.DAMAGE,0.1]);break;
				case 1: applyEnchant(1,"Focal",m,3.5,[SpriteModel.STAT,StatModel.MRATE,0.15+0.03*m.level]);break;
				case 2: applyEnchant(2,"Mystic",m,2,[SpriteModel.STAT,StatModel.MPOWER,2+2*m.level]);break;
				case 3: applyEnchant(3,"Guided",m,3.5,[SpriteModel.ATTACK,ActionBase.HITRATE,3+3*m.level]);break;
				case 4: applyEnchant(4,"Keen",m,3,[SpriteModel.ATTACK,ActionBase.CRITRATE,0.02+0.0054*m.level]);break;
				case 5: applyEnchant(5,"Grenadier",m,3,[SpriteModel.STAT,StatModel.THROWEFF,0.02+0.02*m.level]);break;
				case 6: applyEnchant(6,"Defender",m,3.1,[SpriteModel.STAT,StatModel.BLOCK,3+3*m.level]);break;
				case 7: applyEnchant(7,"Flaming",m,3.4,[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectDamage("Flaming",5+2*m.level,DamageModel.MAGICAL,7,1,PopEffect.FIRE)]);break;
				case 8: applyEnchant(8,"Brilliant",m,3.5,[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectDamage("Brilliant",5+2*m.level,DamageModel.HOLY)]);break;
				case 9: applyEnchant(9,"Venomous",m,3.4,[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectDamage("Venomous",5+2*m.level,DamageModel.CHEMICAL)]);break;
				case 10: applyEnchant(10,"Explosive",m,2.7,[SpriteModel.ATTACK,ActionBase.CEFFECT,new EffectDamage("Explosive",27+8*m.level,DamageModel.MAGICAL,7,1,PopEffect.FIRE)]);break;
				case 11: applyEnchant(11,"Cursing",m,2.9,[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.CURSE,m.level)]);break;
				case 12: applyEnchant(12,"Vampiric",m,3.5,[SpriteModel.ATTACK,ActionBase.LEECH,0.03+0.006*m.level]);break;
				case 13: applyEnchant(13,"Dazzling",m,3.4,[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.DAZZLE,m.level)]);break;
				case 14: applyEnchant(14,"Reflective",m,3.2,[SpriteModel.STAT,StatModel.TURN,0.05+0.005*m.level]);break;
				
				case 15: applyEnchant(15,"Shadow",m,6,[SpriteModel.ATTACK,ActionBase.DAMAGE,0.2]);break;
				case 16: applyEnchant(16,"Shadow",m,6,[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.BASE_DMG,m.level)]);break;
				case 17: applyEnchant(17,"Shadow",m,6,[SpriteModel.STAT,StatModel.MPOWER,4+4*m.level]);break;
				case 18: applyEnchant(18,"Shadow",m,6,[SpriteModel.ATTACK,ActionBase.CRITMULT,0.1+0.06*m.level]);break;
				case 19: applyEnchant(19,"Shadow",m,6,[SpriteModel.STAT,StatModel.THROWEFF,.03+.03*m.level]);break;
				case 20: applyEnchant(20,"Shadow",m,6,[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectBuffBasic(BuffData.makeBuff(BuffData.BLIND,m.level),EffectBase.CURSE)]); break;//Acolyte
				case 100: applyEnchant(100,"Corrupted",m,3.5,[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectDamage("Corrupted",5+2*m.level,DamageModel.DARK)]); break;

				default: throw(new Error("Int out of bounds."));
			}
			return m;
		}
		
		public static function enchantHelmet(m:ItemModel,_index:int):ItemModel{
			var _level:int=m.level;
			if (m.index==9) _level=Math.ceil(1.2*m.level);
			switch (_index){
				case 7: applyEnchant(7,"Shadow",m,6,[SpriteModel.ATTACK,ActionBase.CRITRATE,0.02+0.006*_level]); break;//rogue
				case 8: applyEnchant(8,"Shadow",m,6,[SpriteModel.STAT,StatModel.DOTEFF,0.015+0.015*_level]); break;//acolyte
				case 9: applyEnchant(9,"Shadow",m,6,[SpriteModel.STAT,StatModel.HOLYEFF,0.01+0.01*_level]); break;//paladin
				case 10: applyEnchant(10,"Shadow",m,6,[SpriteModel.STAT,StatModel.HEALTH,25+10*_level]); break; //monk
				case 11: applyEnchant(11,"Shadow",m,6,[SpriteModel.STAT,StatModel.MAGICEFF,0.01+0.01*_level]); break; //mage
				case 12: applyEnchant(12,"Shadow",m,6,[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.FIND_STACKS,_level)]); break; //rogue
				case 13: 
					applyEnchant(13,"",m,1,[SpriteModel.STAT,StatModel.RMAGICAL,0.05+0.005*_level]);
					applyEnchant(13,"",m,1,[SpriteModel.STAT,StatModel.RCHEMICAL,0.05+0.005*_level]);
					applyEnchant(13,"Shadow",m,6,[SpriteModel.STAT,StatModel.RSPIRIT,0.05+0.005*_level]); break; //warrior
				case 14: applyEnchant(14,"Shadow",m,6,[SpriteModel.STAT,StatModel.TRATE,0.15+0.04*_level]); break; //alch
				
				case 15: applyEnchant(15,"Master's",m,3,[SpriteModel.STAT,StatModel.HEALTH,20+4*_level]);break;
				case 16: applyEnchant(16,"Wizard",m,3.5,[SpriteModel.STAT,StatModel.MANA,8+2*_level]);break;
				case 17: applyEnchant(17,"Troll's",m,4,[SpriteModel.STAT,StatModel.HREGEN,0.0025+0.0005*_level]);break;
				case 18: applyEnchant(18,"Channeling",m,4,[SpriteModel.STAT,StatModel.MREGEN,0.004+0.0006*_level]);break;
				case 19: applyEnchant(19,"Light",m,3,[SpriteModel.STAT,StatModel.INITIATIVE,2+2*_level]);break;
				case 20: applyEnchant(20,"Warded",m,3,[SpriteModel.STAT,StatModel.RMAGICAL,0.1+0.01*_level]);break;
				case 21: applyEnchant(21,"Alchemist",m,3,[SpriteModel.STAT,StatModel.RCHEMICAL,0.1+0.01*_level]);break;
				case 22: applyEnchant(22,"Virtuous",m,3,[SpriteModel.STAT,StatModel.RSPIRIT,0.1+0.01*_level]);break;
				case 23: 
					applyEnchant(23,"",m,1,[SpriteModel.STAT,StatModel.RMAGICAL,0.03+0.003*_level]);
					applyEnchant(23,"",m,1,[SpriteModel.STAT,StatModel.RCHEMICAL,0.03+0.003*_level]);
					applyEnchant(23,"Protective",m,3.6,[SpriteModel.STAT,StatModel.RSPIRIT,0.03+0.003*_level]);break;
				case 24: applyEnchant(24,"Seeking",m,4,[SpriteModel.STAT,StatModel.ILOOT,0.05+0.005*_level]);break;
				case 25: applyEnchant(25,"Cloaking",m,3,[SpriteModel.STAT,StatModel.DODGE,0.05+0.005*_level]);break;
				case 26: applyEnchant(26,"Utility",m,2.6,[SpriteModel.STAT,StatModel.IRATE,0.15+0.03*_level]);break;
				case 27: applyEnchant(27,"Spikey",m,2.7,[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.SPIKEY,_level)]);break;
				case 28: applyEnchant(28,"Berserker",m,2.5,[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.BERSERKER,_level)]);break;
				case 29: applyEnchant(29,"Fearsome",m,3.4,[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.FEARSOME,_level)]);break;
				default: throw(new Error("Int out of bounds."));
			}
			return m;
		}
		
		public static function areSame(_item0:ItemModel,_item1:ItemModel):Boolean{
			if (_item0.index==_item1.index && _item0.enchantIndex==_item1.enchantIndex){
				return true;
			}
			return false;
		}
		
		public static function getCraftingResult(_item0:ItemModel,_item1:ItemModel):ItemModel{
			if (_item0.level<15 || _item1.level<15) return null; //Must be level 15 or higher to craft
			if (_item0.primary==TRADE || _item1.primary==TRADE) return null; //Can't craft with gems
			
			if (_item0.index==135){
				if (_item1.index==136) return null;
				
				if (_item0.enchantIndex>=0){
					if (_item0.enchantIndex==0){ //Scouring Essence
						if (_item1.index==135){
							if (_item1.enchantIndex==-1 && _item1.suffixIndex>=64){
								return spawnItem(_item1.level,_item1.suffixIndex);
							}
						}else if (_item1.enchantIndex>=0 || _item1.suffixIndex>=0){
							return spawnItem(_item1.level,_item1.index);
						}
					}else if (_item0.enchantIndex==1){ //Chaos Essence
						if (_item1.index==135){
							return null;
						}
						if (_item1.primary==POTION || _item1.primary==GRENADE || _item1.primary==SCROLL || (_item1.primary==CHARM && !_item1.hasTag(EffectData.RELIC))){
							return null;
						}
						
						if (_item1.primary==MAGIC){
							do{
								_suffix=Math.floor(30+Math.random()*(42-30));
							}while(!testSuffix(_item1,_suffix));
							return suffixItem(_item1.clone(-1,true),_suffix);
						}
						do{
							var _suffix:int=Math.floor(64+Math.random()*(135-64));
						}while(!testSuffix(_item1,_suffix));
						return suffixItem(_item1.clone(-1,true),_suffix);
						
					}else if (_item0.enchantIndex==2){ //Minor Chaos Essence
						if (_item1.primary==CHARM || _item1.primary==WEAPON || _item1.primary==HELMET || _item1.primary==TRINKET || _item1.primary==PROJECTILE){
							do{
								_suffix=Math.floor(Math.random()*30);
							}while(!testSuffix(_item1,_suffix));
							return suffixItem(_item1.clone(-1,true),_suffix);
						}else{
							return null;
						}
					}else if (_item0.enchantIndex==3){ //Plentiful Essence
						if (_item1.enchantIndex==-1 && _item1.charges>=0){
							var m:ItemModel=enchantItem(_item1.clone(-1,false,true),6);
							m.charges=m.maxCharges();
							return m;
						}
					}
				}else{
					if (_item1.index==135) return null;
					if (_item0.suffixIndex==-1){ //Blank Essence, add Suffix?
						if (_item1.isPremium()){
							return suffixItem(_item0.clone(),_item1.index);
						}else if (_item1.index>=14 && _item1.index<=25){
							return suffixItem(_item0.clone(),_item1.index+16);
						}else if (_item1.index>=31 && _item1.index<=36){
							return suffixItem(_item0.clone(),_item1.index+11);
						}else if (_item1.index>=96 && _item1.index<=99){
							return suffixItem(_item0.clone(),_item1.index-48);
						}
					}else{ //Suffixed Essence and Other Item
						if (testSuffix(_item1,_item0.suffixIndex)){
							return suffixItem(_item1.clone(-1,true),_item0.suffixIndex);
						}
					}
				}
				
				return null;
			}else if (_item1.index==135){
				return null;
			}
			
			if (_item0.index==136){
				if (_item1.index!=136 && _item1.level==15){
					return _item1.clone(16);
				}
				return null;
			}else if (_item1.index==136){
				return null;
			}
			
			//NO ESSENCES PAST THIS POINT
			if (_item0.index==_item1.index){
				if (!AchieveData.hasAchieved(AchieveData.ZONE_400)) return null;
				if (_item0.level==15 && _item1.level==15 && (_item0.enchantIndex==-1 || _item1.enchantIndex==-1 || _item0.enchantIndex==_item1.enchantIndex) && (_item0.suffixIndex==-1 || _item1.suffixIndex==-1 || _item0.suffixIndex==_item1.suffixIndex)){
					return ItemModel.importArray([_item0.index,16,_item0.maxCharges(),[_item0.enchantIndex==-1?_item1.enchantIndex:_item0.enchantIndex,_item0.suffixIndex==-1?_item1.suffixIndex:_item0.suffixIndex]]);
				}
				return null;
			}
			
			if (!_item0.isPremium() && !_item1.isPremium()){
				if (_item0.primary==WEAPON && _item0.enchantIndex==-1 && _item1.enchantIndex>-1 && (_item1.primary==WEAPON || (_item1.primary==CHARM && _item1.enchantIndex<15))){
					return enchantItem(_item0.clone(-1,false,true),_item1.enchantIndex); //Shadow Weapon
				}
				if (_item0.primary==HELMET && _item0.enchantIndex==-1 && _item1.enchantIndex>-1 && (_item1.primary==HELMET || (_item1.primary==CHARM && _item1.enchantIndex>=15 && _item1.enchantIndex<30))){
					return enchantItem(_item0.clone(-1,false,true),_item1.enchantIndex); //Shadow Helmet
				}
				if (_item0.primary==MAGIC && _item0.enchantIndex==-1 && _item1.primary==SCROLL){
					_item0=new ItemScroll(_item0.level,_item0,1);
					if (_item1.enchantIndex==6){
						return enchantItem(_item0,6);
					}else{
						return _item0;
					}
				}
				if (_item0.index==40 && _item0.enchantIndex==30 && _item1.isShadow()){
					return enchantItem(spawnItem(_item0.level,40),31);
				}
				if ((_item0.primary==POTION || _item0.primary==GRENADE || _item0.primary==SCROLL) && (_item1.primary==POTION || _item1.primary==GRENADE || _item1.primary==SCROLL) && _item0.enchantIndex==6 && _item1.enchantIndex==-1){
					return enchantItem(_item1.clone(),6);
				}
			}
			if ((_item0.index>=31&&_item0.index<36) || (_item0.index>=96&&_item0.index<=99)){
				if (_item0.enchantIndex==6){
					switch(_item0.index){
						case 31://heal
							if (_item1.index==98){
								if (_item1.enchantIndex==6){
									return enchantItem(_item0.clone(-1,false,true),0);
								}
							}else if (_item1.index==33){
								if (_item1.enchantIndex==6){
									return enchantItem(_item0.clone(-1,false,true),1);
								}
							}else if (_item1.index==32){
								if (_item1.enchantIndex==6){
									return spawnItem(_item0.level,96,6);
								}
							}
							break;
						case 32://mana
							if (_item1.index==98){
								if (_item1.enchantIndex==6){
									return enchantItem(_item0.clone(-1,false,true),0);
								}
							}else if (_item1.index==33){
								if (_item1.enchantIndex==6){
									return enchantItem(_item0.clone(-1,false,true),1);
								}
							}
							break;
						case 33://amp
							if (_item1.index==99){
								if (_item1.enchantIndex==6){
									return enchantItem(_item0.clone(-1,false,true),0);
								}
							}break;
						case 34://alch fire
							if (_item1.index==33){
								if (_item1.enchantIndex==6){
									return enchantItem(_item0.clone(-1,false,true),0);
								}
							}else if (_item1.index==98){
								if (_item1.enchantIndex==6){
									return enchantItem(_item0.clone(-1,false,true),1);
								}
							}break;
						case 35://gas
							if (_item1.index==33){
								if (_item1.enchantIndex==6){
									return enchantItem(_item0.clone(-1,false,true),0);
								}
							}else if (_item1.index==98){
								if (_item1.enchantIndex==6){
									return enchantItem(_item0.clone(-1,false,true),1);
								}
							}break;
						case 36://holy
							if (_item1.index==32){
								if (_item1.enchantIndex==6){
									return enchantItem(_item0.clone(-1,false,true),0);
								}
							}else if (_item1.index==35){
								if (_item1.enchantIndex==6){
									return enchantItem(_item0.clone(-1,false,true),1);
								}
							}break;
						case 96://recovery
							if (_item1.index==99){
								if (_item1.enchantIndex==6){
									return enchantItem(_item0.clone(-1,false,true),1);
								}
							}break;
						case 97://celerity
							if (_item1.index==99){
								if (_item1.enchantIndex==6){
									return enchantItem(_item0.clone(-1,false,true),0);
								}
							}break;
						case 98://turtle
							if (_item1.index==33){
								if (_item1.enchantIndex==6){
									return enchantItem(_item0.clone(-1,false,true),0);
								}
							}break;
						case 99://purity
							if (_item1.index==35){
								if (_item1.enchantIndex==6){
									return enchantItem(_item0.clone(-1,false,true),0);
								}
							}break;
					}
				}
				return null;
			}
			if (_item0.enchantIndex>-1) return null;
			if (_item0.index<64){ 
				switch(_item0.index){
					
					//Special Recipes for MAGIC\\
					case 14: //Magic Bolt
						if (_item1.index==17) return enchantItem(_item0.clone(-1,false,true),0);
						if (_item1.index==111) return enchantItem(_item0.clone(-1,false,true),1);
						break;
					case 15: //Fireball
						if (_item1.primary!=HELMET && _item1.enchantIndex==10) return enchantItem(_item0.clone(-1,false,true),0);
						break;
					case 16: //Lightning
						if (_item1.primary!=HELMET && _item1.enchantIndex==13) return enchantItem(_item0.clone(-1,false,true),0);
						break;
					case 17: //Searing Light
						if (_item1.index==16) return enchantItem(_item0.clone(-1,false,true),0);
						break;
					case 18: //Poison Bolt
						if (_item1.index==15) return enchantItem(_item0.clone(-1,false,true),0);
						if (_item1.index==35) return enchantItem(_item0.clone(-1,false,true),1);
						if (_item1.index==111) return enchantItem(_item0.clone(-1,false,true),2);
						break;
					case 19: //Confusion
						if (_item1.primary!=WEAPON && _item1.enchantIndex==29) return enchantItem(_item0.clone(-1,false,true),0);
						break;
					case 20: //Cripple
						if (_item1.primary!=HELMET && _item1.enchantIndex==12) return enchantItem(_item0.clone(-1,false,true),0);
						break;
					case 21: //Vulnerability
						if (_item1.primary!=WEAPON && _item1.enchantIndex==15) return enchantItem(_item0.clone(-1,false,true),0);
						break;
					case 22: //Healing
						if (_item1.index==122) return enchantItem(_item0.clone(-1,false,true),0); 
						break;
					case 23: //Empower
						if (_item1.primary!=WEAPON && _item1.enchantIndex==28) return enchantItem(_item0.clone(-1,false,true),0);
						if (_item1.primary!=WEAPON && _item1.enchantIndex==19) return enchantItem(_item0.clone(-1,false,true),1);
						break;
					case 24: //Haste
						if (_item1.primary!=HELMET && _item1.enchantIndex==11) return enchantItem(_item0.clone(-1,false,true),0);
					case 25: //Enchant Weapon
						if (_item1.index==17) return enchantItem(_item0.clone(-1,false,true),0);
						if (_item1.index==24) return enchantItem(_item0.clone(-1,false,true),1);
						if (_item1.index==111) return enchantItem(_item0.clone(-1,false,true),2);
						break;
				}
			}else if (_item0.index<=111){ //Special Recipes for PREMIUMS
				switch(_item0.index){
					case 64: //Kabuto
						if (_item1.isPremium()) break;
						if (_item1.primary!=HELMET && _item1.enchantIndex==2){
							return enchantItem(_item0.clone(-1,false,true),1);
						}else if (_item1.primary!=WEAPON&& _item1.enchantIndex==19){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 65: //Hood
						if (_item1.isPremium()) break;
						if (_item1.primary!=HELMET && _item1.enchantIndex==11){
							return spawnItem(_item0.level,110);
						}else if (_item1.primary!=HELMET && _item1.enchantIndex==9){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 66: //Phrygian Cap
						if (_item1.index==31 && _item1.enchantIndex==6){
							return enchantItem(_item0.clone(-1,false,true),1);
						}else if (_item1.index==32 && _item1.enchantIndex==6){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 67: //Plumber Hat
						if (_item1.index==98 && _item1.enchantIndex==6){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 68: //Boxing Gear
						if (_item1.index==70){
							return enchantItem(_item0.clone(-1,false,true),4);
						}else if (_item1.primary!=WEAPON){
							if (_item1.isPremium()) break;
							switch(_item1.enchantIndex){
								case 20: return enchantItem(_item0.clone(-1,false,true),0);
								case 21: return enchantItem(_item0.clone(-1,false,true),1);
								case 22: return enchantItem(_item0.clone(-1,false,true),2);
								case 23: return enchantItem(_item0.clone(-1,false,true),3);
							} 	
						}break;
					case 69: //Turban
						if (_item1.isPremium()) break;
						if (_item1.primary!=HELMET && _item1.enchantIndex==11){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 70: //Crown
						if (_item1.isPremium()) break;
						if (_item1.primary!=WEAPON && _item1.enchantIndex>15 && _item1.enchantIndex<30){
							return enchantItem(_item0.clone(-1,false,true),_item1.enchantIndex);
						}break;
					case 71: //Protector
						if (_item1.enchantIndex==30){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 72: //Katanas
						if (_item1.index==132){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 73: //Light Sword
						if (_item1.enchantIndex==6){
							switch(_item1.index){
								case 31: return enchantItem(_item0.clone(-1,false,true),0);
								case 32: return enchantItem(_item0.clone(-1,false,true),1);
								case 33: return enchantItem(_item0.clone(-1,false,true),2);
								case 34: return enchantItem(_item0.clone(-1,false,true),3);
								case 35: return enchantItem(_item0.clone(-1,false,true),4);
								case 36: return enchantItem(_item0.clone(-1,false,true),5);
								case 96: return enchantItem(_item0.clone(-1,false,true),6);
								case 97: return enchantItem(_item0.clone(-1,false,true),7);
								case 98: return enchantItem(_item0.clone(-1,false,true),8);
								case 99: return enchantItem(_item0.clone(-1,false,true),9);
							}
						}break;
					case 74: //Rending Claws
						if (_item1.index==84){
							return enchantItem(_item0.clone(-1,false,true),0);
						}
					case 75: //Hylian Sword
						if (_item1.isPremium()) break;
						if (_item1.primary!=HELMET){
							if (_item1.enchantIndex==8){
								return enchantItem(_item0.clone(-1,false,true),0);
							}else if (_item1.enchantIndex==9){
								return enchantItem(_item0.clone(-1,false,true),1);
							}else if (_item1.enchantIndex==11){
								return enchantItem(_item0.clone(-1,false,true),2);
							}
						}break;
					case 76: //Plumber Gloves
						if (_item1.isPremium()) break;
						if (_item1.primary!=HELMET){
							if (_item1.enchantIndex==8){
								return enchantItem(_item0.clone(-1,false,true),0);
							}else if (_item1.enchantIndex==7){
								return enchantItem(_item0.clone(-1,false,true),1);
							}else if (_item1.enchantIndex==11){
								return enchantItem(_item0.clone(-1,false,true),2);
							}
						}break;
					case 77: //Boxing Gloves
						if (_item1.isPremium()) break;
						if (_item1.primary!=HELMET){
							switch(_item1.enchantIndex){
								case 7: return enchantItem(_item0.clone(-1,false,true),0);
								case 8: return enchantItem(_item0.clone(-1,false,true),1);
								case 9: return enchantItem(_item0.clone(-1,false,true),2);
								case 10: return enchantItem(_item0.clone(-1,false,true),3);
								case 11: return enchantItem(_item0.clone(-1,false,true),4);
								case 13: return enchantItem(_item0.clone(-1,false,true),5);
							}
						}break;
					case 78: //Saruman's Staff
						if (_item1.index==21){
							return enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==20){
							return enchantItem(_item0.clone(-1,false,true),1);
						}else if (_item1.index==18){
							return enchantItem(_item0.clone(-1,false,true),2);
						}break;
					case 79: //Mjolnir
						if (_item1.index==80){
							return enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==72){
							return enchantItem(_item0.clone(-1,false,true),1);
						}break;
					case 80: //Captain's Shield
						if (_item1.index==95){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 81: //Twin Scimitars
						if (_item1.index==97){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
						//???
					case 82: //Royal Scepter
						if (_item1.isPremium()) break;
						if (_item1.primary!=HELMET && _item1.enchantIndex<15){
							return enchantItem(_item0.clone(-1,false,true),_item1.enchantIndex);
						}break;
					case 83: //Neptune's Trident
						if (_item1.index==114){
							return enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==80){
							return enchantItem(_item0.clone(-1,false,true),1);
						}break;
					case 84: //Ancient Ankh
						if (_item1.index==73){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 85: //Baseball Bat
						if (_item1.index==20){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 86: //Breaker Sword
						if (_item1.index==79){
							return enchantItem(_item0.clone(-1,false,true),0);
						}
					case 87: //Board with a Nail In It
						if (_item1.index==21){
							return enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==19){
							return enchantItem(_item0.clone(-1,false,true),1);
						}else if (_item1.index==20){
							return enchantItem(_item0.clone(-1,false,true),2);
						}break;
					case 88: //Mullet
						if (_item1.isPremium()) break;
						if (_item1.primary!=WEAPON && _item1.enchantIndex==17){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 89: //Ampersand
						if (_item1.index==114){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 90: //Death Jester
						if (_item1.isPremium()) break;
						if (_item1.primary!=WEAPON && _item1.enchantIndex==17){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 91: //Envenomed Mask
						if (_item1.enchantIndex==6){
							switch(_item1.index){
								case 33: return enchantItem(_item0.clone(-1,false,true),0);
								case 97: return enchantItem(_item0.clone(-1,false,true),1);
								case 98: return enchantItem(_item0.clone(-1,false,true),2);
								case 99: return enchantItem(_item0.clone(-1,false,true),3);
								
							}
						}break;
					case 92: //Rose Thorns
						if (_item1.enchantIndex==6 && _item1.index==35){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 93: //Classic Bomb
						if (_item1.isPremium()) break;
						if (_item1.primary!=HELMET && _item1.enchantIndex==8){
							return enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.primary!=HELMET && _item1.enchantIndex==11){
							return enchantItem(_item0.clone(-1,false,true),1);
							
						}break;
					case 94: //Flying Rat
						if (_item1.isPremium()) break;
						if (_item1.primary!=HELMET){
							switch(_item1.enchantIndex){
								case 7: return enchantItem(_item0.clone(-1,false,true),0);
								case 8: return enchantItem(_item0.clone(-1,false,true),1);
								case 9: return enchantItem(_item0.clone(-1,false,true),2);
								case 10: return enchantItem(_item0.clone(-1,false,true),3);
								case 11: return enchantItem(_item0.clone(-1,false,true),4);
								case 0: return enchantItem(_item0.clone(-1,false,true),5);
							}
						}break;
					case 95: //Chakram
						if (_item1.index==85){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					/*case 96:
					case 97:
					case 98:
					case 99:
					case 100:*/
					case 101: //Riot Helmet
						if (_item1.index==11 && _item1.enchantIndex==-1 && _item1.suffixIndex==-1){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 102: //Hell Horns
						if (_item1.index==106){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 103: //Hockey Mask
						if (_item1.index==21){
							return enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==20){
							return enchantItem(_item0.clone(-1,false,true),1);
						}else if (_item1.index==19){
							return enchantItem(_item0.clone(-1,false,true),2);
						}break;
					case 104: //Propeller Beanie
						if (_item1.isPremium()) break;
						if (_item1.primary!=WEAPON && _item1.enchantIndex==28){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 105: //Riot Gear
						if (_item1.index==80){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 106: //Hell Hands
						if (_item1.enchantIndex==6 && (_item1.primary==SCROLL || _item1.primary==GRENADE)){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 107: //Chainsaw
						if (_item1.index==21){
							return enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==19){
							return enchantItem(_item0.clone(-1,false,true),1);
						}else if (_item1.index==20){
							return enchantItem(_item0.clone(-1,false,true),2);
						}break;
					case 108: //Eternal Tome
						switch(_item1.index){
							case 14: return enchantItem(_item0.clone(-1,false,true),0);
							case 15: return enchantItem(_item0.clone(-1,false,true),1);
							case 16: return enchantItem(_item0.clone(-1,false,true),2);
							case 17: return enchantItem(_item0.clone(-1,false,true),3);
							case 18: return enchantItem(_item0.clone(-1,false,true),4);
						}break;
					case 109: //Temporary Bow
						if (_item1.secondary==UNARMED){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 110: //Dark Half Hood
						if (_item1.isPremium()) break;
						if (_item1.primary!=WEAPON && _item1.enchantIndex==8){
							return spawnItem(_item0.level,65);
						}else if (_item1.primary!=HELMET && _item1.enchantIndex==7){
							return enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.primary!=HELMET && _item1.enchantIndex==0){
							return enchantItem(_item0.clone(-1,false,true),1);
						}
						break;
					case 111: //Dark Half Swords
						if (_item1.enchantIndex==6){
							switch(_item1.index){
								case 31: return enchantItem(_item0.clone(-1,false,true),0);
								case 32: return enchantItem(_item0.clone(-1,false,true),1);
								case 33: return enchantItem(_item0.clone(-1,false,true),2);
								case 34: return enchantItem(_item0.clone(-1,false,true),3);
								case 35: return enchantItem(_item0.clone(-1,false,true),4);
								case 36: return enchantItem(_item0.clone(-1,false,true),5);
								case 96: return enchantItem(_item0.clone(-1,false,true),6);
								case 97: return enchantItem(_item0.clone(-1,false,true),7);
								case 98: return enchantItem(_item0.clone(-1,false,true),8);
								case 99: return enchantItem(_item0.clone(-1,false,true),9);
							}
						}break;
				}
			}else{
				switch(_item0.index){
					case 112: //Pentagram
						if (_item1.index==113){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 113: //Holy Grail
						if (_item1.enchantIndex==6){
							switch(_item1.index){
								case 33: return enchantItem(_item0.clone(-1,false,true),0);
								case 97: return enchantItem(_item0.clone(-1,false,true),1);
								case 98: return enchantItem(_item0.clone(-1,false,true),2);
								case 99: return enchantItem(_item0.clone(-1,false,true),3);
								
							}
						}break;
					case 114: //Crusader's Mace
						if (_item1.isPremium()) break;
						if (_item1.primary!=HELMET && (_item1.enchantIndex==5 || _item1.enchantIndex==19)){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 115: //Crusader's Helmet
						if (_item1.index==102 || _item1.index==117){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 116: //Demon Sickles
						if (_item1.isPremium()) break;
						if (_item1.primary!=HELMET){
							if (_item1.enchantIndex==8){
								return enchantItem(_item0.clone(-1,false,true),0);
							}else if (_item1.enchantIndex==7){
								return enchantItem(_item0.clone(-1,false,true),1);
							}else if (_item1.enchantIndex==9){
								return enchantItem(_item0.clone(-1,false,true),2);
							}else if (_item1.enchantIndex==11){
								return enchantItem(_item0.clone(-1,false,true),3);
							}
						}break;
					case 117: //Demon Horns
						if (_item1.index==102){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 118: //Participation Award
					case 119: //Trophy
					case 120: //Big Pencil
						break;
					case 121: //Tramp Hair
						if (_item1.index==122){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 122: //Princess
						if (_item1.isPremium()) break;
						if (_item1.primary!=WEAPON){
							if (_item1.enchantIndex==28){
								return enchantItem(_item0.clone(-1,false,true),0);
							}else if (_item1.enchantIndex==19){
								return enchantItem(_item0.clone(-1,false,true),1);
							}
						}break;
					case 123: //Masta Rasta
						if (_item1.index==88){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 124: //Sapien Hair
						if (_item1.index==69){
							return enchantItem(_item0.clone(-1,false,true),1);
						}else if (_item1.index==64){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 125: //Multibolt
						if (_item1.index==17){
							return enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==111){
							return enchantItem(_item0.clone(-1,false,true),1);
						}break;
					/*case 126: 
					case 127: 
					case 128: */
					
					case 129: //Sparrow's Bow
						if (_item1.isPremium()) break;
						if (_item1.primary==WEAPON && _item1.enchantIndex>=15){
							return enchantItem(_item0.clone(-1,false,true),_item1.enchantIndex);
						}break;
					case 130: //Bycocket
						if (_item1.isPremium()) break;
						if (_item1.primary==HELMET && _item1.enchantIndex<15){
							return enchantItem(_item0.clone(-1,false,true),_item1.enchantIndex);
						}break;
					case 131: //Quickdraw Quiver
						if (_item1.primary==CHARM){
							return enchantItem(_item0.clone(-1,false,true),_item1.enchantIndex);
						}break;
					case 132: //Sais
						if (_item1.index==80 || _item1.index==105){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 133: //Fukumen
						if (_item1.isPremium()) break;
						if (_item1.primary!=HELMET && _item1.enchantIndex==14){
							return enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.primary!=WEAPON){
							switch(_item1.enchantIndex){
								case 20: return enchantItem(_item0.clone(-1,false,true),1);
								case 21: return enchantItem(_item0.clone(-1,false,true),2);
								case 22: return enchantItem(_item0.clone(-1,false,true),3);
								case 23: return enchantItem(_item0.clone(-1,false,true),4);
							}
						}break;
					case 134: //Shurikens
						if (!_item1.isPremium() && _item1.enchantIndex==6){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 137: //Screamer
						if (_item1.index==122){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 138: //Puzzling Mask
						if (_item1.index==110){
							return enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==91){
							return enchantItem(_item0.clone(-1,false,true),1);
						}break;
					case 139: //Big Bad Mask
						if (_item1.index==70 || _item1.index==82){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 140: //Muzzle
						if (_item1.index==83){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 141: //Ruby Visor
						if (_item1.index==73){
							return enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==111){
							return enchantItem(_item0.clone(-1,false,true),1);
						}else if (_item1.index==101){
							return enchantItem(_item0.clone(-1,false,true),2);
						}break;
					case 142: //Rocketman
						if (_item1.index==64){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 143: //Monacle
						if (_item1.index==91){
							return enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 144: //Goggles
						if (_item1.index==86){
							return enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==73){
							return enchantItem(_item0.clone(-1,false,true),1);
						}else if (_item1.index==111){
							return enchantItem(_item0.clone(-1,false,true),2);
						}break;
				}
			}
			
			return null;
		}
		
		public static function finishEnchantPremium(m:ItemModel,_prefix:String,_remove:int,_replacement:Array=null):ItemModel{
			m.name=_prefix+" "+m.name;
			if (_remove!=-1){
				for (var i:int=0;i<m.values.length;i+=1){
					if (m.values[i][1]==_remove){
						m.values.splice(i,1);
						break;
					}
				}
			}
			if (_replacement!=null){
				for (var j:int=0;j<_replacement.length;j+=1){
					endApply(m,_replacement[j]);
				}
			}
			return m;
		}
		
		public static function enchantPotion(m:ItemModel,_index:int):ItemModel{
			if (m.primary!=POTION && m.primary!=GRENADE) return m;
			m.enchantIndex=_index;
			if (_index==6){
				applyEnchant(6,"Plentiful",m,1,null);
				return m;
			}
			switch(m.index){
				case 31: //Healing
					if (m.enchantIndex==0){
						m.name="Massive Healing Potion";
						//m.action.type=ActionBase.HOLY;
						m.action=new ActionPotionHealingPercent("Healing Potion",m.level,0.05+0.006*m.level,null,DamageModel.CHEMICAL,10+3*m.level);
						m.action.source=m;
						return m;
					}else if (m.enchantIndex==1){
						m.name="Blood Bank";
						m.action=null;
						m.values.push([SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.BLOOD_BANK,m.level)]);
						return m;
					}break;
				case 32: //Mana
					if (m.enchantIndex==0){
						m.name="Lingering Mana Potion";
						m.action.damage*=0.5;
						m.action.effects.push(new EffectBuffBasic(new BuffMOT(33,"Lingering Mana",m.level,3,StatModel.POTEFF,30+1.5*m.level,DamageModel.CHEMICAL),EffectBase.BUFF,EffectBase.TRIGGER_SELF));
						return m;
					}else if (m.enchantIndex==1){
						m.name="Mana Bank";
						m.action=null;
						m.values.push([SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.MANA_BANK,m.level)]);
						return m;
					}break;
				case 33: //Amp
					if (m.enchantIndex==0){
						m.name="Plentiful Artifact Tincture";
						m.action.effects[0]=new EffectBuffBasic(new BuffStats(m.index+1,"Artificed",m.level,BuffBase.BUFF,5,[[SpriteModel.STAT,StatModel.PHYSEFF,0.05+0.015*m.level],[SpriteModel.STAT,StatModel.MAGICEFF,0.05+0.015*m.level],[SpriteModel.STAT,StatModel.CHEMEFF,0.05+0.015*m.level],[SpriteModel.STAT,StatModel.HOLYEFF,0.05+0.015*m.level],[SpriteModel.STAT,StatModel.DARKEFF,0.05+0.015*m.level]]),EffectBase.BUFF,EffectBase.ALL);
						return m;
					}break;
				case 34: //Fire
					if (m.enchantIndex==0){
						m.name="Plentiful Wildfire";
						m.action.damage*=0.75;
						m.action.effects.push(EffectData.makeEffect(EffectData.PSEUDOCRIT,m.level));
						return m;
					}else if (m.enchantIndex==1){
						m.name="Mercury Bomb";
						m.action.damage*=1.1;
						m.action.type=DamageModel.PHYSICAL;
						return m;
					}break;
				case 35: //Gas
					if (m.enchantIndex==0){
						m.name="Dark Gas";
						((m.action.effects[0] as EffectBuffBasic).buff as BuffDOT).damage*=1.1;
						((m.action.effects[0] as EffectBuffBasic).buff as BuffDOT).damageType=DamageModel.DARK;
						return m;
					}else if (m.enchantIndex==1){
						m.name="Caustic Gas";
						((m.action.effects[0] as EffectBuffBasic).buff as BuffDOT).damage*=0.8;
						m.action.effects.push(new EffectBuffBasic(new BuffStats(m.index+1,"Caustic",m.level,BuffBase.BUFF,4,[[SpriteModel.STAT,StatModel.RPHYS,-0.01*m.level]]),EffectBase.CURSE));
						return m;
					}break;
				case 36: //Holy
					if (m.enchantIndex==0){
						m.name="Plentiful Holy Water mk.II";
						m.action.effects[0]=new EffectBuffBasic(new BuffStats(28,"Arcane Static",m.level,BuffBase.CURSE,3,[[SpriteModel.STAT,StatModel.TURN_REDUCE,-0.1-0.01*m.level]]),EffectBase.CURSE)
						return m;
					}else if (m.enchantIndex==1){
						m.name="Unholy Water";
						m.action.type=DamageModel.DARK;
						m.action.effects[0]=EffectData.makeEffect(EffectData.RPEN,50);
						return m;
					}break;
				case 96: //Recovery
					if (m.enchantIndex==1){
						m.name="Cleansing Potion";
						m.action=new ActionBuffPot("Cleansing Waters",m.level,new <EffectBase>[EffectData.makeEffect(EffectData.CLEANSE_HEAL,m.level)]);
						m.action.source=m;
						return m;
					}else if (m.enchantIndex==0){
						
					}break;
				case 97: //Celerity
					if (m.enchantIndex==0){
						m.name="Plentiful Acuity Potion";
						m.action.effects[0]=new EffectBuffBasic(new BuffStats(m.index+1,"Acuitized",m.level,BuffBase.BUFF,5,[[SpriteModel.ATTACK,ActionBase.DODGE_REDUCE,0.07],[SpriteModel.STAT,StatModel.THROWEFF,0.15+0.03*m.level],[SpriteModel.ATTACK,ActionBase.HITRATE,15+3*m.level],[SpriteModel.ATTACK,ActionBase.CRITRATE,0.05+0.01*m.level]]),EffectBase.BUFF,EffectBase.ALL);
						return m;
					}break;
				case 98: //Turtle
					if (m.enchantIndex==0){
						m.name="Plentiful Lucky Soup";
						m.action.effects[0]=new EffectBuffBasic(new BuffStats(m.index+1,"Lucky!",m.level,BuffBase.BUFF,5,[[SpriteModel.STAT,StatModel.ILOOT,0.1+0.005*m.level],[SpriteModel.STAT,StatModel.STRENGTH,-50-2.5*m.level],[SpriteModel.STAT,StatModel.INITIATIVE,-50-2.5*m.level],[SpriteModel.STAT,StatModel.MPOWER,-50-2.5*m.level],[SpriteModel.STAT,StatModel.THROWEFF,-0.5-0.025*m.level]]),EffectBase.BUFF,EffectBase.ALL);
						return m;
					}break;
				case 99: //Purity
					if (m.enchantIndex==0){
						m.name="Plentiful Profanity Potion";
						m.action.effects[0]=new EffectBuffBasic(new BuffStats(m.index+1,"Profaned",m.level,BuffBase.BUFF,5,[[SpriteModel.STAT,StatModel.SPELLSTEAL,0.01*m.level],[SpriteModel.ATTACK,ActionBase.LEECH,0.012*m.level],[SpriteModel.STAT,StatModel.PROCEFF,0.10+0.015*m.level],[SpriteModel.STAT,StatModel.RMAGICAL,0.01*m.level],[SpriteModel.STAT,StatModel.RCHEMICAL,0.01*m.level],[SpriteModel.STAT,StatModel.RSPIRIT,-0.1]]),EffectBase.BUFF,EffectBase.ALL);
						return m;
					}break;
			}
			return m;
		}
		
		public static function enchantSpell(m:ItemModel,_index:int):ItemModel{
			if (m.index<14 || m.index>25) return m;
			m.enchantIndex=_index;
			switch(m.index){
				case 14: //Magic Missile
					if (m.enchantIndex==0){
						m.name="Holy Bolt";
						m.action.type=ActionBase.HOLY;
						m.action.damage*=0.9;
						m.action.effects.push(EffectData.makeEffect(EffectData.ILLUMINATED,m.level*0.5));
						return m;
					}else if (m.enchantIndex==1){
						m.name="Dark Bolt";
						m.action.type=ActionBase.DARK;
						m.action.damage*=0.9;
						m.action.effects.push(EffectData.makeEffect(EffectData.SCORCHED,m.level*0.5));
						return m;
					}
				case 15: //Fireball
					m.name="Napalm Ball";
					m.action.damage-=2*m.level;
					m.action.effects[0].userate=1;
					((m.action.effects[0] as EffectBuff).buff as BuffDOT).damage+=0.1*m.level;
					return m;
				case 16: //Lightning
					m.name="Dazzling Strike";
					m.action.damage*=0.6;
					m.action.mana*=1.33;
					m.action.effects[0].userate=0.33;
					return m;
				case 17: //Searing Light
					m.name="Searing Blast";
					m.action.damage-=2.5*m.level;
					m.action.effects.push(new EffectDamage("Scorched",15+10.8*m.level,DamageModel.MAGICAL));
					m.action.mana*=1.2;
					return m;
				case 18: //Poison Bolt
					if (m.enchantIndex==0){
						m.name="Smothering Poison";
						((m.action.effects[0] as EffectBuff).buff as BuffDOT).damage*=0.9;
						(m.action.effects[0] as EffectBuff).buff.charges+=2;
						return m;
					}else if (m.enchantIndex==1){
						m.name="Surmounting Poison";
						((m.action.effects[0] as EffectBuff).buff as BuffDOT).damage*=0.85;
						(m.action.effects[0] as EffectBuff).buff.charges=3;
						(m.action.effects[0] as EffectBuff).buff.maxStacks=3;
						return m;
					}else if (m.enchantIndex==2){
						m.name="Dark Poison";
						((m.action.effects[0] as EffectBuff).buff as BuffDOT).damageType=DamageModel.DARK;
						return m;
					}
					break;
				case 19: //Confusion
					return spawnItem(m.level,29);
				case 20: //Cripple
					m.name="Sever the Crown";
					m.action.effects[0]=new EffectBuffBasic(BuffData.makeBuff(BuffData.HEAL_NO,m.level),EffectBase.CURSE);
					return m;
				case 21: //Vulnerability
					m.name="Sever the Root";
					(m.action.effects[0] as EffectBuff).buff=BuffData.makeBuff(BuffData.VULNERABLE2,m.level);
					return m;
				case 22: //Healing
					m.name="Shield";
					m.secondary=BUFF;
					m.action=ActionData.makeAction(ActionData.SHIELD,m.level);
					m.action.source=m;
					return m;
				case 23: //Empower
					switch(_index){
						case 0: m.name="Enstrengthen";
							((m.action.effects[0] as EffectBuff).buff as BuffStats).values=[[SpriteModel.STAT,StatModel.STRENGTH,60+6*m.level]];
							(m.action.effects[0] as EffectBuff).buff.name=BuffData.EMPOWERED2;
							return m;
						case 1: m.name="Enquicken";
							((m.action.effects[0] as EffectBuff).buff as BuffStats).values=[[SpriteModel.STAT,StatModel.INITIATIVE,60+6*m.level]];
							(m.action.effects[0] as EffectBuff).buff.name=BuffData.EMPOWERED3;
							return m;
					}break;
				case 24: //Haste
					m.name="Slow";
					m.secondary=CURSE;
					m.action=ActionData.makeAction(ActionData.SLOW,m.level);
					m.action.source=m;
					return m;
				case 25: //Enchant Weapon
					switch(_index){
						case 0: m.name="Blessed Weapon";
							((m.action.effects[0] as EffectBuff).buff as BuffEnchantWeapon).values[0][2].damageType=ActionBase.HOLY;
							(m.action.effects[0] as EffectBuff).buff.name=BuffData.ENCHANTED2;
							return m;
						case 1: m.name="Vorpal Weapon";
							((m.action.effects[0] as EffectBuff).buff as BuffEnchantWeapon).values[0][2].damage*=0.4;
							((m.action.effects[0] as EffectBuff).buff as BuffEnchantWeapon).values[0][2].damageType=ActionBase.PHYSICAL;
							((m.action.effects[0] as EffectBuff).buff as BuffEnchantWeapon).values.push([SpriteModel.ATTACK,ActionBase.HITRATE,10+5*m.level]);
							((m.action.effects[0] as EffectBuff).buff as BuffEnchantWeapon).values.push([SpriteModel.ATTACK,ActionBase.CRITRATE,0.05+0.3*Facade.diminish(0.04,m.level)]);
							(m.action.effects[0] as EffectBuff).buff.name=BuffData.ENCHANTED3;
							return m;
						case 2: m.name="Darkened Weapon";
							((m.action.effects[0] as EffectBuff).buff as BuffEnchantWeapon).values[0][2].damage*=0.5;
							((m.action.effects[0] as EffectBuff).buff as BuffEnchantWeapon).values[0][2].damageType=ActionBase.DARK;
							((m.action.effects[0] as EffectBuff).buff as BuffEnchantWeapon).values.push([SpriteModel.ATTACK,ActionBase.EFFECT,new EffectBuffBasic(BuffData.makeBuff(BuffData.DARKENED,m.level),EffectBase.CURSE)]);
							(m.action.effects[0] as EffectBuff).buff.name=BuffData.ENCHANTED4;
					}break;
			}
			return m;
		}
		
		public static function enchantPremium(m:ItemModel,_index:int):ItemModel{
			if (m.index<64) return m;
			m.enchantIndex=_index;
			
			if (m.index<=111){
				switch(m.index){
					case 64: //Kabuto
						switch(_index){
							case 0:
								m.secondary=MEDIUM;
								m.values[0][2]-=20+20*m.level;
								m.values[3][2]=-0.1;
								m.values[1][2]=0.25;
								return finishEnchantPremium(m,"Quick",StatModel.STRENGTH,[[SpriteModel.STAT,StatModel.INITIATIVE,40+4*m.level]]);
							case 1: return finishEnchantPremium(m,"Mystic",StatModel.STRENGTH,[[SpriteModel.STAT,StatModel.MPOWER,10+4*m.level]]);
						}break;
					case 65: //Hood
						return finishEnchantPremium(m,"Chemist's",StatModel.HOLYEFF,[[SpriteModel.STAT,StatModel.CHEMEFF,0.022+0.022*m.level]]);
					case 66: //Phrygian Cap
						switch(_index){
							case 0: return finishEnchantPremium(m,"Blue",StatModel.ITEMEFF,[[SpriteModel.STAT,StatModel.ITEMEFF,0.05+0.0064*m.level],[SpriteModel.STAT,StatModel.RPHYS,0.05+0.0034*m.level]]);
							case 1: return finishEnchantPremium(m,"Red",StatModel.ITEMEFF,[[SpriteModel.STAT,StatModel.ITEMEFF,0.05+0.0064*m.level],[SpriteModel.STAT,StatModel.RMAGICAL,0.05+0.0076*m.level],[SpriteModel.STAT,StatModel.RCHEMICAL,0.05+0.0076*m.level],[SpriteModel.STAT,StatModel.RSPIRIT,0.05+0.0076*m.level]]);
						}break;
					case 67: //Plumber Hat
						m.secondary=LIGHT;
						return finishEnchantPremium(m,"Brother's",StatModel.INITIATIVE,[[SpriteModel.STAT,StatModel.HEALTH,22+16*m.level],[SpriteModel.STAT,StatModel.RCRIT,0.05]]);
					case 68: //Boxing Gear
						switch(_index){
							case 0: return finishEnchantPremium(m,"Warded",StatModel.DODGE,[[SpriteModel.STAT,StatModel.RMAGICAL,0.02+0.005*m.level]]);
							case 1: return finishEnchantPremium(m,"Alchemist",StatModel.DODGE,[[SpriteModel.STAT,StatModel.RCHEMICAL,0.02+0.005*m.level]]);
							case 2: return finishEnchantPremium(m,"Virtuous",StatModel.DODGE,[[SpriteModel.STAT,StatModel.RSPIRIT,0.02+0.005*m.level]]);
							case 3: return finishEnchantPremium(m,"Protected",StatModel.DODGE,[[SpriteModel.STAT,StatModel.RMAGICAL,0.006+0.00125*m.level],[SpriteModel.STAT,StatModel.RCHEMICAL,0.006+0.00125*m.level],[SpriteModel.STAT,StatModel.RSPIRIT,0.006+0.00125*m.level]]);
							case 4: return finishEnchantPremium(m,"Champion's",StatModel.DODGE,[[SpriteModel.STAT,StatModel.ILOOT,0.005+0.005*m.level]]);
						}break;
					case 69: //Turban
						switch(_index){
							case 0: m.secondary=MEDIUM;
								return finishEnchantPremium(m,"Dark",-1,[[SpriteModel.STAT,StatModel.HEALTH,30+17*m.level],[SpriteModel.STAT,StatModel.RCRIT,0.05],[SpriteModel.STAT,StatModel.INITIATIVE,-20]]);
						}break;
					case 70: //Crown
						return enchantHelmet(m,_index);
					case 71: //Protector
						m.name="Alternate Protector";
						m.values=[[SpriteModel.STAT,StatModel.HEALTH,61+27*m.level],[SpriteModel.STAT,StatModel.RCRIT,.05],[SpriteModel.ATTACK,ActionBase.CRITRATE,0.01+0.003*m.level],[SpriteModel.ATTACK,ActionBase.CRITMULT,0.1+0.03*m.level],[SpriteModel.STAT,StatModel.RPHYS,0.003+0.0010*m.level],[SpriteModel.STAT,StatModel.RMAGICAL,0.005+0.0015*m.level],[SpriteModel.STAT,StatModel.RCHEMICAL,0.005+0.0015*m.level],[SpriteModel.STAT,StatModel.RSPIRIT,0.005+0.0015*m.level]];
						return m;
					case 72: //Katanas
						m.action.critrate=-0.05-0.002*m.level;
						return finishEnchantPremium(m,"Vorpal",-1,[[SpriteModel.ATTACK,ActionBase.CRITMULT,0.5+0.1*m.level]]);
					case 73: //Light Sword
						return m;
					case 74: //Rending Claws
						m.name="Mending Claws";
						m.values[2][2]=EffectData.makeEffect(EffectData.REND_HEAL,m.level);
						return m;
					case 75: //Hylian Sword
						switch(_index){
							case 0: m.name="Divine "+m.name;
								(m.action.effects[0] as EffectDamage).damageType=ActionBase.HOLY;
								return m;
							case 1: m.name="Venomous "+m.name;
								(m.action.effects[0] as EffectDamage).damageType=ActionBase.CHEMICAL;
								return m;
							case 2: m.name="Dark "+m.name;
								(m.action.effects[0] as EffectDamage).damageType=ActionBase.DARK;
								return m;
						}break;
					case 76: //Plumber Gloves
						switch(_index){
							case 0: m.name="Divine "+m.name;
								m.values[0][2].damageType=ActionBase.HOLY;
								return m;
							case 1: m.name="Mystic "+m.name;
								m.values[0][2].damageType=ActionBase.MAGICAL;
								return m;
							case 2: m.name="Dark "+m.name;
								m.values[0][2].damageType=ActionBase.DARK;
								return m;
						}break;
					case 77: //Boxing Gloves
						switch(_index){
							case 0: return finishEnchantPremium(m,"Flaming",StatModel.BLOCK,[[SpriteModel.UNARMED,ActionBase.EFFECT,new EffectDamage("Flaming",5+2*m.level,DamageModel.MAGICAL,7,1,PopEffect.FIRE)]]);
							case 1: return finishEnchantPremium(m,"Brilliant",StatModel.BLOCK,[[SpriteModel.UNARMED,ActionBase.EFFECT,new EffectDamage("Brilliant",5+2*m.level,DamageModel.HOLY)]]);
							case 2: return finishEnchantPremium(m,"Venomous",StatModel.BLOCK,[[SpriteModel.UNARMED,ActionBase.EFFECT,new EffectDamage("Venomous",5+2*m.level,DamageModel.CHEMICAL)]]);
							case 3: return finishEnchantPremium(m,"Explosive",StatModel.BLOCK,[[SpriteModel.UNARMED,ActionBase.CEFFECT,new EffectDamage("Explosive",27+8*m.level,DamageModel.MAGICAL,7,1,PopEffect.FIRE)]]);
							case 4: return finishEnchantPremium(m,"Cursing",StatModel.BLOCK,[[SpriteModel.UNARMED,ActionBase.EFFECT,EffectData.makeEffect(EffectData.CURSE,m.level)]]);
							case 5: return finishEnchantPremium(m,"Dazzling",StatModel.BLOCK,[[SpriteModel.UNARMED,ActionBase.EFFECT,EffectData.makeEffect(EffectData.DAZZLE,m.level)]]);
						}break;
					case 78: //Saruman's Staff
						switch(_index){
							case 0: m.name="Vulnerable "+m.name;
								m.values[1][2].buff=BuffData.makeBuff(BuffData.VULNERABLE,m.level);
								return m;
							case 1: m.name="Weakening "+m.name;
								m.values[1][2].buff=BuffData.makeBuff(BuffData.WEAKENED,m.level);
								return m;
							case 2: m.name="Toxic "+m.name;
								m.values[1][2].buff=BuffData.makeBuff(BuffData.POISONED,m.level*3/4);
						}break;
					case 79: //Mjolnir
						switch(_index){
							case 0:
								m.name="Mighty "+m.name;
								m.action.tags.push(EffectData.RANGED);
								m.action.basePriority.setBaseDistance(ActionPriorities.COMBAT,false);
								return m;
							case 1:
								m.name="Deadblow "+m.name;
								m.action.critrate-=0.25;
								m.action.cEffects.splice(0,1);
								m.action.cEffects[0].userate=1;
								return m;
						}
					case 80: //Captain's Shield
						m.name="Powerful "+m.name;
						m.action.damage*=1.1;
						m.action.hitrate+=3*m.level;
						m.values[0][2]*=0.8;
						return m;
					case 81: //Twin Scimitars
						m.name="Quad Scimitars";
						m.action.damage*=0.8;
						m.action.effects=new <EffectBase>[EffectData.makeEffect(EffectData.QUICK,0.2*m.level),EffectData.makeEffect(EffectData.QUICK,0.2*m.level)];
						return m;
					case 82: //Royal Scepter
						return enchantWeapon(m,_index);
					case 83: //Neptune's Trident
						switch(_index){
							case 0: return finishEnchantPremium(m,"Crusading",StatModel.MPOWER,[[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.MAGIC_STRIKE,m.level)]]);
							case 1: m.name="Poseidon's Trident";
								m.action.tags.push(EffectData.LONG_RANGED);
								m.action.basePriority.setBaseDistance(ActionPriorities.COMBAT,true);
								return m;
						}break;
					case 84: //Ancient Ankh
						return finishEnchantPremium(m,"Pious",StatModel.SPELLSTEAL,[[SpriteModel.STAT,StatModel.HEALMULT,0.04+0.008*m.level]]);
					case 85: //Baseball Bat
						m.name="Dinger Bat";
						m.action.cEffects=new <EffectBase>[];
						m.action.effects.push(EffectData.makeEffect(EffectData.KNOCKBACK_MINOR,0));
						return m;
					case 86: //Breaker Sword
						m.name="Breaking Sword";
						m.action.damage*=1.2;
						m.action.effects.push(new EffectBuffBasic(BuffData.makeBuff(BuffData.COOLDOWN,0),EffectBase.BUFF,EffectBase.ALL));
						return m;
					case 87: //Board with a Nail In It
						switch(_index){
							case 0: m.name="Vulnerable "+m.name;
								(m.action.effects[0] as EffectBuff).buff=BuffData.makeBuff(BuffData.VULNERABLE,m.level-1);
								return m;
							case 1: m.name="Confusing "+m.name;
								(m.action.effects[0] as EffectBuff).buff=BuffData.makeBuff(BuffData.CONFUSED,m.level-1);
								return m;
							case 2: m.name="Weakening "+m.name;
								(m.action.effects[0] as EffectBuff).buff=BuffData.makeBuff(BuffData.WEAKENED,m.level-1);
								return m;
						}break;
					case 88: //Mullet
						return finishEnchantPremium(m,"Troll's",StatModel.POTEFF,[[SpriteModel.STAT,StatModel.HREGEN,0.00125+0.00025*m.level]]);
					case 89: //Ampersand
						m=finishEnchantPremium(m,"Monument",StatModel.DISPLAYS,[[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.BUFFPOT_STRIKE,m.level)]]);
						m.name="Monument";
						return m;
					case 90: //Death Jester
						m.name="Life Jester";
						m.values[2][2]*=2;
						m.values[3][2].buff.values[0][2]*=-2;
						return m;
					case 91: //Envenomed Mask
						m.values[4]=[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.AUTOBUFFFREE,m.level)];
						switch(_index){
							case 0: m.name="Amplifying Mask";
								return m;
							case 1: m.name="Quickened Mask";
								m.values[4][2].buff=BuffData.makeBuff(BuffData.CELERITY_POT,m.level*0.5);
								return m;
							case 2: m.name="Turtle Mask";
								m.values[4][2].buff=BuffData.makeBuff(BuffData.TURTLE_POT,m.level*0.5);
								return m;
							case 3: m.name="Purifying Mask";
								m.values[4][2].buff=BuffData.makeBuff(BuffData.PURITY_POT,m.level*0.5);
								return m;
						}break;
					case 92: //Rose Thorns
						if (_index==0){
							m.name="Toxic "+m.name;
							m.action=ActionData.makeAction(ActionData.THROW_ROSE2,m.level);
							m.action.source=m;
							m.primary=GRENADE;
							m.secondary=CURSE;
							return m;
						}else if (_index==6){
							m.action.damage*=0.25;
							((m.action.effects[0] as EffectBuff).buff as BuffDOT).damage*=0.25;
							applyEnchant(6,"Plentiful",m,1,null);
							return m;
						}break;
					case 93: //Classic Bomb
						if (_index==0){
							m.name="Holy Bomb";
							((m.action.effects[0] as EffectBuff).buff as BuffDelayedDmg).damageType=ActionBase.HOLY;
							return m;
						}else if (_index==1){
							m.name="Dark Bomb";
							((m.action.effects[0] as EffectBuff).buff as BuffDelayedDmg).damageType=ActionBase.DARK;
							return m;
						}else if (_index==6){
							((m.action.effects[0] as EffectBuff).buff as BuffDelayedDmg).damage*=0.75;
							applyEnchant(6,"Plentiful",m,1,null);
							return m;
						}break;
					case 94: //Flying Rat
						switch(_index){
							case 0: m.name="Flaming Rat";
								m.action.effects[0]=new EffectDamage("Flaming",5+4*m.level,DamageModel.MAGICAL,7,1,PopEffect.FIRE);
								return m;
							case 1: m.name="Brilliant Rat";
								m.action.effects[0]=new EffectDamage("Brilliant",5+4*m.level,DamageModel.HOLY);
								return m;
							case 2: m.name="Venomous Rat";
								m.action.effects[0]=new EffectDamage("Venomous",5+2*m.level,DamageModel.CHEMICAL);
								return m;
							case 3: m.name="Exploding Rat";
								m.action.effects.shift();
								m.action.cEffects.push(new EffectDamage("Explosive",27+16*m.level,DamageModel.MAGICAL,7,1,PopEffect.FIRE));
								return m;
							case 4: m.name="Cursing Rat";
								m.action.effects[0]=EffectData.makeEffect(EffectData.CURSE,m.level*2);
								return m;
							case 5: m.name="Black Rat";
								m.action.effects[0]=new EffectDamage("Darkened",5+4*m.level,DamageModel.DARK);
								return m;
						}break;
					case 95: //Chakram
						m.name="Pulling "+m.name;
						m.action.damage*=0.8;
						m.action.cEffects.push(EffectData.makeEffect(EffectData.KNOCKBACK_REVERSED,0));
						return m;
					/*case 96:
					case 97:
					case 98:
					case 99:
					case 100:*/
					case 101: //Riot Helmet
						m.name="Kevlar Helmet";
						m.secondary=LIGHT;
						endApply(m,[SpriteModel.STAT,StatModel.HEALTH,-40+22*m.level]);
						m.values[1][2]-=.2;
						m.values.splice(2,2);
						m.values[2][2]=EffectData.makeEffect(EffectData.RESPECT,m.level/2);
						return m;
					case 102: //Hell Horns
						m.name="Heck Horns";
						m.values.splice(2,2);
						m.values.push([SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.COMBO_DEFENSE,m.level)]);
						return m;
					case 103: //Hockey Mask
						switch(_index){
							case 0: m.name="Abusive "+m.name;
								(m.values[4][2] as EffectDmgBoost).extra=BuffData.VULNERABLE;
								return m;
							case 1: m.name="Bullying "+m.name;
								(m.values[4][2] as EffectDmgBoost).extra=BuffData.WEAKENED;
								return m;
							case 2: m.name="Taunting "+m.name;
								(m.values[4][2] as EffectDmgBoost).extra=BuffData.CONFUSED;
								return m;
						}break;
					case 104: //Propeller Beanie
						m.name="Deadly "+m.name;
						m.values[2][2].buff.values=[[SpriteModel.STAT,StatModel.DMGMULT,0.05+0.009*m.level]];
						return m;
					case 105: //Riot Gear
						m.name="Mighty "+m.name;
						m.action.tags.push(EffectData.RANGED);
						m.action.basePriority.setBaseDistance(ActionPriorities.COMBAT,false);
						return m;
					case 106: //Hell Hands
						m.name="Frenetic "+m.name;
						m.values[0][2].buff.maxStacks=5;
						m.values[0][2].buff.values[0][2]*=0.8;
						return m;
					case 107: //Chainsaw
						switch(_index){
							case 0: m.name="Vulnerable "+m.name;
								(m.action.cEffects[1] as EffectBuff).buff=BuffData.makeBuff(BuffData.VULNERABLE,1);
								return m;
							case 1: m.name="Confusing "+m.name;
								(m.action.cEffects[1] as EffectBuff).buff=BuffData.makeBuff(BuffData.CONFUSED,1);
								return m;
							case 2: m.name="Weakening "+m.name;
								(m.action.cEffects[1] as EffectBuff).buff=BuffData.makeBuff(BuffData.WEAKENED,1);
								return m;
						}break;
					case 108: //Eternal Tome
						switch(_index){
							case 0: m.name="Magic Bolt Tome";
								m.action=ActionData.makeAction(ActionData.MISSILE,m.level);
								m.action.source=m;
								return m;
							case 1: m.name="Fireball Tome";
								m.action=ActionData.makeAction(ActionData.FIREBALL,m.level*0.6);
								m.action.source=m;
								return m;
							case 2: m.name="Lightning Tome";
								m.action=ActionData.makeAction(ActionData.LIGHTNING,m.level*0.6);
								m.action.source=m;
								return m;
							case 3: m.name="Searing Tome";
								m.action=ActionData.makeAction(ActionData.SEARING,m.level*0.6);
								m.action.source=m;
								return m;
							case 4: m.name="Poison Tome";
								m.action=ActionData.makeAction(ActionData.POISON,m.level*0.6);
								m.action.source=m;
								return m;
						}
					case 109: //Temporary Bow
						m.name="Bladed Bow";
						m.secondary=UNARMED;
						m.tags.shift();
						return m;
					case 110: //Dark Half Hood
						switch (_index){
							case 0:								
								m.name="Half Hood";
								return finishEnchantPremium(m,"Medium",StatModel.DARKEFF,[[SpriteModel.STAT,StatModel.MAGICEFF,0.018+0.018*m.level]]);
							case 1:
								m.name="Hood";
								return finishEnchantPremium(m,"Heavy",StatModel.DARKEFF,[[SpriteModel.STAT,StatModel.PHYSEFF,0.015+0.015*m.level]]);
						}
					case 111: //Dark Half Swords
						return m;
				}
			}else{
				switch(m.index){
					case 112: //Pentagram
						if (_index==0){
							m.action=ActionData.makeAction(ActionData.HEAL_GRAIL,m.level);
							m.action.source=m;
							m.name="Healing "+m.name;
						}else if (_index==6){
							applyEnchant(6,"Plentiful",m,1,null);
							return m;
						}break;
					case 113: //Holy Grail
						switch(_index){
							case 0: m.name="Amplifying Grail";
								m.values[0][2].buff=BuffData.makeBuff(BuffData.BUFF_POT,m.level*0.8);
								return m;
							case 1: m.name="Quickening Grail"
								m.values[0][2].buff=BuffData.makeBuff(BuffData.CELERITY_POT,m.level*0.8);
								return m;
							case 2: m.name="Turtle Grail"
								m.values[0][2].buff=BuffData.makeBuff(BuffData.TURTLE_POT,m.level*0.8);
								return m;
							case 3: m.name="Purifying Grail"
								m.values[0][2].buff=BuffData.makeBuff(BuffData.PURITY_POT,m.level*0.8);
								return m;
						}break;
					case 114: //Crusader's Mace
						return finishEnchantPremium(m,"Grenadier",StatModel.PROCS,[[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.GRENADE_STRIKE,m.level)]]);
					case 115: //Crusader's Helmet
						return finishEnchantPremium(m,"Dark",StatModel.EFFECT,[[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.INITIAL_CURSE,m.level)]]);
					case 116: //Demon Sickles
						switch(_index){
							case 0: m.name="Brilliant Sickles";
								((m.action.effects[0] as EffectBuff).buff as BuffDelayedDmg).damageType=ActionBase.HOLY;
								return m;
							case 1: m.name="Arcane Sickles";
								((m.action.effects[0] as EffectBuff).buff as BuffDelayedDmg).damageType=ActionBase.MAGICAL;
								return m;
							case 2: m.name="Venomous Sickles";
								((m.action.effects[0] as EffectBuff).buff as BuffDelayedDmg).damageType=ActionBase.CHEMICAL;
								return m;
							case 3: m.name="Darkened Sickles";
								((m.action.effects[0] as EffectBuff).buff as BuffDelayedDmg).damageType=ActionBase.DARK;
								return m;
						}break;
					case 117: //Demon Horns
						return finishEnchantPremium(m,"Reversed",StatModel.DISPLAYS,[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.BUFF_REFLECT,m.level)]]);
					case 118: //Participation Award
					case 119: //Trophy
					
					case 120: //Big Pencil
					
					case 121: //Tramp Hair
						//m.name="Real "+m.name;
						return finishEnchantPremium(m,"Real",StatModel.DISPLAYS,[[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.BUILD_WALL,m.level)]]);
					case 122: //Princess
						switch(_index){
							case 0:
								m.name="Matriarch";
								m.values[4][2].buff.mult=StatModel.STRENGTH;
								return m;
							case 1:
								m.name="Mermaid";
								m.values[4][2].buff.mult=StatModel.INITIATIVE;
								return m;
						}
					case 123: //Masta Rasta
						m.name="Stoned Rasta";
						endApply(m,[SpriteModel.STAT,StatModel.HEALTH,52+24*m.level]);
						m.values[1][2]=0.2;
						m.secondary=MEDIUM;
						m.values.splice(2,1,[SpriteModel.STAT,StatModel.INITIATIVE,-20]);
						return m;
					case 124: //Sapien Hair
						switch(_index){
							case 0:
								m.name="Vegetative "+m.name;
								m.values[2][2].buff=BuffData.makeBuff(BuffData.SUPER_SAYAN3,m.level);
								return m;
							case 1:
								m.name="Legendary "+m.name;
								m.values[2][2].buff=BuffData.makeBuff(BuffData.SUPER_SAYAN2,m.level);
								return m;
						}break;
					case 125: //Multibolt
						if (_index==0){
							m.name="Multi-Holy";
							m.action.type=ActionBase.HOLY;
							return m;
						}else if (_index==1){
							m.name="Multi-Dark";
							m.action.type=ActionBase.DARK;
							return m;
						}
					/*case 126: 
					case 127: 
					case 128: */
					
					case 129: //Sparrow's Bow
						m.action.damage*=0.9;
						m.action.dodgeReduce=0.05;
						return enchantWeapon(m,_index);
					case 130: //Bycocket
						m.values[0][2]*=0.8;
						return enchantHelmet(m,_index);
					case 131: //Quickdraw Quiver
						m.name="Quiver";
						m.values.splice(0,1);
						if (_index<15){
							return enchantWeapon(m,_index);
						}else{
							return enchantHelmet(m,_index);
						}break;
					case 132: //Sais
						m.name="Defensive "+m.name;
						m.values[0][2]*=1.75;
						m.action.damage*=0.9;
						return m;
					case 133: //Fukumen
						switch(_index){
							case 0: return finishEnchantPremium(m,"Reflective",StatModel.DODGE,[[SpriteModel.STAT,StatModel.TURN,0.1+0.01*m.level]]);
							case 1: return finishEnchantPremium(m,"Warded",StatModel.DODGE,[[SpriteModel.STAT,StatModel.RMAGICAL,0.3+0.03*m.level]]);
							case 2: return finishEnchantPremium(m,"Alchemist",StatModel.DODGE,[[SpriteModel.STAT,StatModel.RCHEMICAL,0.3+0.03*m.level]]);
							case 3: return finishEnchantPremium(m,"Virtuous",StatModel.DODGE,[[SpriteModel.STAT,StatModel.RSPIRIT,0.3+0.03*m.level]]);
							case 4: return finishEnchantPremium(m,"Protective",StatModel.DODGE,[[SpriteModel.STAT,StatModel.RMAGICAL,0.1+0.01*m.level],[SpriteModel.STAT,StatModel.RCHEMICAL,0.1+0.01*m.level],[SpriteModel.STAT,StatModel.RSPIRIT,0.1+0.01*m.level]]);
						}break;
					case 134: //Shurikens
						if (_index==0){
							m.name="Frenetic "+m.name;
							m.action.effects[0]=EffectData.makeEffect(EffectData.MULTI,2);
							m.action.hitrate-=100;
						}else if (_index==6){
							m.action.damage*=0.75;
							applyEnchant(6,"Plentiful",m,1,null);
							return m;
						}
						break;
					case 137: //Screamer
						switch(_index){
							case 0:
								m.name="Whisperer";
								(m.action.effects[0] as EffectBuffBasic).name=BuffData.ENTRANCED;
								(m.action.effects[0] as EffectBuffBasic).buff.name=BuffData.ENTRANCED;
								m.action.label="Whipering Call";
								break;
							case 6:
								((m.action.effects[0] as EffectBuffBasic).buff as BuffAction).rate*=0.75;
								applyEnchant(6,"Plentiful",m,1,null);
								return m;
						}break;
					case 138: //Puzzling Mask
						switch(_index){
							case 0:
								m.name="Silencing Mask";
								m.values[1][2].buff=BuffData.makeBuff(BuffData.SILENCED,0);
								break;
							case 1:
								m.name="Unpuzzled Mask";
								m.values[1][2]=new EffectBuffBasic(BuffData.makeBuff(BuffData.UNTRAPPABLE,m.level),EffectBase.BUFF,EffectBase.INITIAL);
								break;
						}break;
					case 139: //Big Bad Mask
						m.name="Super "+m.name;
						m.values.splice(0,3);
						m.values.unshift([SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.GOLD_STRIKE,m.level)]);
						break;
					case 140: //Muzzle
						if (_index==0){
							m.name="Magical "+m.name;
							((m.action.effects[0] as EffectBuffBasic).buff as BuffStats).values[0]=[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.MANA_HEAL,m.level)];
						}else if (_index==6){
							//((m.action.effects[0] as EffectBuffBasic).buff as BuffAction).rate*=0.75;
							m.values[0][2]*=0.5;
							applyEnchant(6,"Plentiful",m,1,null);
						}
						break;
					case 141: //Ruby Visor
						switch(_index){
							case 0:
								m.name="Emerald Visor";
								m.action.type=DamageModel.HOLY;
								m.action.effects[0]=new EffectBuffBasic(BuffData.makeBuff(BuffData.BLIND,m.level),EffectBase.CURSE);
								break;
							case 1:
								m.name="Saphire Visor";
								m.action.type=DamageModel.DARK;
								m.action.effects[0]=new EffectBuffBasic(BuffData.makeBuff(BuffData.DARKENED,m.level),EffectBase.CURSE);
								break;
							case 2:
								m.name="Mecha-Police Visor";
								m.action=ActionData.makeAction(ActionData.ROBOCOP,m.level);
								m.action.source=m;
								break;
							case 6:
								m.action.damage*=0.75;
								applyEnchant(6,"Plentiful",m,1,null);
								break;
						}break;
					case 142: //Rocketman
						m.name="Small Dancer";
						m.values[2][1]=StatModel.MANATOSTRENGTH;
						break;
					case 143: //Monacle
						m.name="Taunting "+m.name;
						m.values[4]=[SpriteModel.STAT,StatModel.EFFECT,new EffectBuffBasic(BuffData.makeBuff(BuffData.BERSERK,0-m.level),EffectBase.CURSE,EffectBase.INITIAL)];
						break;
					case 144: //Goggles
						switch(_index){
							case 0:
								m.name="Strong "+m.name;
								m.values[1][1]=StatModel.PHYSEFF;
								break;
							case 1:
								m.name="Bright "+m.name;
								m.values[1][1]=StatModel.HOLYEFF;
								break;
							case 2:
								m.name="Dark "+m.name;
								m.values[1][1]=StatModel.DARKEFF;
								break;
						}break;
				}
			}
			return m;
		}
		
		public static function finishTestSuffix(_test:String,_index:int):Boolean{
			if (_test==HELMET){
				if (_index>=15 && _index<30) return true;
				switch(_index){
					case 64: case 65: case 66: case 67: case 68: case 69: case 70: case 71:
					case 88: case 89: case 90: case 91:
					case 101: case 102: case 103: case 104: case 105: case 110:
					case 112: case 113: case 115: case 117: case 119:
					case 121: case 122: case 123: case 124: 
					case 130: case 133:
					case 142: case 144:
						return true;
				}
			}else if (_test==UNARMED){
				if (_index>=1 && _index<15) return true;
				switch(_index){
					case 72: case 73: case 74: case 75: case 76: case 77: case 78: case 79: case 80: case 81: case 82:
					case 83: case 84: case 85: case 87:
					case 92: case 93: case 94:
					case 106: case 108: case 109: case 111:
					case 114:
					case 129: case 132:
					case 140: 
						return true;
				}
			}else if (_test==WEAPON){
				if (_index>=0 && _index<15) return true;
				switch(_index){
					case 72: case 73: case 74: case 75: case 76: case 77: case 78: case 79: case 80: case 81: case 82:
					case 83: case 84: case 85: case 86: case 87:
					case 92: case 93: case 94:
					case 106: case 107: case 108: case 109: case 111:
					case 114: case 116:
					case 129: case 132: case 134:
					case 140:
						return true;
				}
				
			}else if (_test==MAGIC){
				switch(_index){
					case 14: case 24:
					case 30: case 35:
					/*case 73: case 76:*/ /*case 84:*/ case 86: case 87:
					/*case 108: */case 111:
					
						return true;
					//84, 108 apply to SPELL ONLY
				}
			}else if (_test==DAMAGING){
				switch(_index){
					case 0: case 7: case 8: case 12: case 13:
					case 31: case 32: case 33: case 34: case 36: case 37: case 41: case 125:
					case 94: case 105: 
					case 141: case 116:
						return true;
				}
			}else if (_test==CURSE){
				switch(_index){
					case 7: case 8: case 13: case 31:
					case 34: case 36: case 39:  case 41:
					case 94:  case 105: 
					case 141:
						return true;
				}
			}else if (_test==BUFF){
				switch(_index){
					case 38: case 39: case 40:
						return true;
				}
			}else if (_test==PROJECTILE){
				switch(_index){
					case 0: case 3: case 4: case 7: case 8: case 9: case 10: case 11: case 12: case 13:
					case 72: case 73: case 74: case 75: case 76: case 79: 
					case 83: case 86: case 87:
					case 92: case 93: case 94: case 95:
					case 106: case 109: case 111:
					case 116:
					case 129: case 132: case 134:
					case 140:
						return true;
				}
			}else if (_test==GRENADE){
				switch(_index){
					case 0: case 5: case 8: case 9: case 12: case 13:
					/*case 83: */case 86: case 87:
					case 92: case 93: case 94: case 95:
					case 106: case 109: 
					case 116:
					case 140:
					case 45: case 46: case 47: case 48:
						return true;
				}
			}else if (_test==POTION){
				switch(_index){
					case 15: case 17: case 21: case 24: case 26:
					case 70: case 82: case 88: case 95:
					case 42: case 43: case 44: case 48: case 50:
						return true;
				}
			}else if (_test==BUFF+" "+POTION){
				switch(_index){
					case 49: case 51:
						return true;
				}
			}else if (_test==EffectData.RELIC){
				if (_index>=1 && _index<30) return true;
				switch(_index){
					case 64: case 65: case 66: case 67: case 68: case 70: case 71:
					case 77: case 78: case 80: case 82:
					case 84:
					case 88: case 89: case 90: case 91:
					case 101: case 102: case 103: case 104: case 105: case 108: case 109: case 110:
					case 112: case 113: case 115: case 117: case 119:
					case 121: case 122: case 123: case 124:
					case 129: case 130: case 131: case 132: case 133:
					case 137: case 138: case 139: case 140: case 141: case 142: case 143: case 144:
						return true;
				}
			}else if (_test==SCROLL){
				switch(_index){
					case 18: case 20: case 24: case 1:
					case 30:
					case 70: case 82: case 95:
					case 141:
						return true;
				}
			}else if (_test==CHARM){
				if (_index>=1 && _index<30) return true;
			}
			return false;
		}
		
		public static function testSuffix(m:ItemModel,_index:int):Boolean{
			if (m.index==135) return true;
			if (m.isPremium() && m.index==_index) return false;
			
			if (m.primary==HELMET){
				return finishTestSuffix(HELMET,_index);
			}else if (m.primary==WEAPON){
				if (m.secondary==UNARMED){
					return finishTestSuffix(UNARMED,_index);
				}else{
					return finishTestSuffix(WEAPON,_index);
				}
			}else if (m.primary==MAGIC){
				if (finishTestSuffix(MAGIC,_index)){
					return true;
				}
				if (m.secondary==DAMAGING){
					return finishTestSuffix(DAMAGING,_index);
				}else if (m.secondary==CURSE){
					return finishTestSuffix(CURSE,_index);
				}else if (m.secondary==BUFF){
					return finishTestSuffix(BUFF,_index);
				}
			}else if (m.primary==PROJECTILE){
				return finishTestSuffix(PROJECTILE,_index);
			}else if (m.primary==GRENADE){
				return finishTestSuffix(GRENADE,_index); 
			}else if (m.primary==CHARM || m.primary==TRINKET){
				if (finishTestSuffix(CHARM,_index)){
					return true;
				}
				if (m.hasTag(EffectData.RELIC)){
					return finishTestSuffix(EffectData.RELIC,_index);
				}
			}else if (m.primary==POTION){
				if (finishTestSuffix(POTION,_index)){
					return true;
				}
				if (m.secondary==BUFF){
					return finishTestSuffix(BUFF+" "+POTION,_index);
				}
			}else if (m.primary==SCROLL){
				return finishTestSuffix(SCROLL,_index);
			}
			return false;
		}
		
		public static function suffixItem(m:ItemModel,_index:int):ItemModel{
			if (m.index==135) m.values=[];
			
			if (_index==-1) return m;
			if (m.isPremium() && m.index==_index) return m;
			
			if (_index<30){ //regular enchantments
				switch(_index){
					case 0: applySuffix(0,"of the Master",m,[[SpriteModel.ATTACK,ActionBase.DAMAGE,0.08]]);break;
					case 1: applySuffix(1,"of Focus",m,[[SpriteModel.STAT,StatModel.MRATE,0.45]]);break;
					case 2: applySuffix(2,"of the Mystic",m,[[SpriteModel.STAT,StatModel.MPOWER,22]]);break;
					case 3: applySuffix(3,"of Guidance",m,[[SpriteModel.ATTACK,ActionBase.HITRATE,33]]);break;
					case 4: applySuffix(4,"of Keenness",m,[[SpriteModel.ATTACK,ActionBase.CRITRATE,0.07]]);break;
					case 5: applySuffix(5,"of the Grenadier",m,[[SpriteModel.STAT,StatModel.THROWEFF,0.22]]);break;
					case 6: applySuffix(6,"of Defending",m,[[SpriteModel.STAT,StatModel.BLOCK,33]]);break;
					case 7: applySuffix(7,"of Flame",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectDamage("Flaming",25,DamageModel.MAGICAL,7,1,PopEffect.FIRE)]]);break;
					case 8: applySuffix(8,"of Brilliance",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectDamage("Brilliant",25,DamageModel.HOLY)]]);break;
					case 9: applySuffix(9,"of Venom",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectDamage("Venomous",25,DamageModel.CHEMICAL)]]);break;
					case 10: applySuffix(10,"of Exploding",m,[[SpriteModel.ATTACK,ActionBase.CEFFECT,new EffectDamage("Explosive",107,DamageModel.MAGICAL,7,1,PopEffect.FIRE)]]);break;
					case 11: applySuffix(11,"of Cursing",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.CURSE,10)]]);break;
					case 12: applySuffix(12,"of the Vampire",m,[[SpriteModel.ATTACK,ActionBase.LEECH,0.09]]);break;
					case 13: applySuffix(13,"of Dazzling",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.DAZZLE,5)]]);break;
					case 14: applySuffix(14,"of Reflection",m,[[SpriteModel.STAT,StatModel.TURN,0.10]]);break;
					case 15: applySuffix(15,"of the Master",m,[[SpriteModel.STAT,StatModel.HEALTH,100]]);break;
					case 16: applySuffix(16,"of the Wizard",m,[[SpriteModel.STAT,StatModel.MANA,28]]);break;
					case 17: applySuffix(17,"of the Troll",m,[[SpriteModel.STAT,StatModel.HREGEN,0.0075]]);break;
					case 18: applySuffix(18,"of Channeling",m,[[SpriteModel.STAT,StatModel.MREGEN,0.01]]);break;
					case 19: applySuffix(19,"of Lightness",m,[[SpriteModel.STAT,StatModel.INITIATIVE,22]]);break;
					case 20: applySuffix(20,"of Warding",m,[[SpriteModel.STAT,StatModel.RMAGICAL,0.2]]);break;
					case 21: applySuffix(21,"of the Alchemist",m,[[SpriteModel.STAT,StatModel.RCHEMICAL,0.2]]);break;
					case 22: applySuffix(22,"of Virtue",m,[[SpriteModel.STAT,StatModel.RSPIRIT,0.2]]);break;
					case 23: applySuffix(23,"of Protection",m,[[SpriteModel.STAT,StatModel.RMAGICAL,0.06],[SpriteModel.STAT,StatModel.RCHEMICAL,0.06],[SpriteModel.STAT,StatModel.RSPIRIT,0.06]]);break;
					case 24: applySuffix(24,"of Seeking",m,[[SpriteModel.STAT,StatModel.ILOOT,0.1]]);break;
					case 25: applySuffix(25,"of Cloaking",m,[[SpriteModel.STAT,StatModel.DODGE,0.1]]);break;
					case 26: applySuffix(26,"of Utility",m,[[SpriteModel.STAT,StatModel.IRATE,0.45]]);break;
					case 27: applySuffix(27,"of Spikes",m,[[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.SPIKEY,10)]]);break;
					case 28: applySuffix(28,"of the Berserker",m,[[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.BERSERKER,10)]]);break;
					case 29: applySuffix(29,"of Fear",m,[[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.FEARSOME,10)]]);break;
				}
			}else if (_index<=63){
				switch(_index){
					case 30: applySuffix(_index,"of Efficiency",m,[[SpriteModel.ATTACK,ActionBase.MANA,-0.33]]); break; //Magic Bolt
					case 31: //Fireball
						if (m.action!=null && m.action.hasTag(EffectData.LONG_RANGED)) return null; 
						applySuffix(_index,"of Range",m,[[SpriteModel.ATTACK,ActionBase.TAG,EffectData.LONG_RANGED]]);
						if (m.action!=null) m.action.basePriority.setBaseDistance(ActionPriorities.COMBAT,true);
						break;
					case 32: applySuffix(_index,"of Wildness",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.RANDOM_DMG_BOOST,50)]]); break; //Lightning
					case 33: applySuffix(_index,"Supreme",m,[[SpriteModel.ATTACK,ActionBase.DAMAGE,0.2],[SpriteModel.ATTACK,ActionBase.MANA,0.33]]); break; //Searing Light
					case 34: applySuffix(_index,"of Poisoning",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectBuffBasic(BuffData.makeBuff(BuffData.POISONED2,0),EffectBase.CURSE)]]); break; //Poison Bolt
					case 35: applySuffix(_index,"of Blood",m,[[SpriteModel.ATTACK,ActionBase.TAG,EffectData.BLOOD_MAGIC]]); break;//Confusion
					case 36: applySuffix(_index,"of Penetration",m,[[SpriteModel.STAT,StatModel.TURN_REDUCE,0.1]]); break;//Cripple
					case 37: applySuffix(_index,"of Nearness",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.NEAR_DMG_BOOST,0)]]); break;//Vulnerability
					case 38: applySuffix(_index,"of Cleansing",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.CLEANSE_HEAL,10)]]); break;//Healing
					case 39: 
						if (m.index==135){
							m.values.push([SpriteModel.ATTACK,ActionBase.TAG,EffectData.DURATION]);
						}else{
							for (var i:int=0;i<m.action.effects.length;i+=1){
								if (m.action.effects[i] is EffectBuff){
									(m.action.effects[i] as EffectBuff).buff.charges+=1;
								}
							}
						}
						applySuffix(_index,"of Duration",m,[]); break;//Empower
						break;
					case 40:
						if (m.index==135){
							m.values.push([SpriteModel.ATTACK,ActionBase.TAG,EffectData.INITIAL_SPELL]);
							m.values.push([SpriteModel.ATTACK,ActionBase.TAG,EffectData.DURATION_MINUS]);
						}else{
							m.values=[[SpriteModel.STAT,StatModel.MANA,0-m.action.mana],[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.INITIAL_SPELL,0)]];
							m.values[1][2].buff=(m.action.effects[0] as EffectBuff).buff;
							m.values[1][2].buff.charges-=2;
							m.action=null;
						}
						applySuffix(_index,"of Initiation",m,[]); //Haste
						break;
					
					case 41: //Enchant Weapon
						if (m.index==135){
							m.values.push([SpriteModel.ATTACK,ActionBase.TAG,EffectData.FREE_SPELL]);
						}else{
							m.values=[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.FREE_SPELL,0)]];
							m.values[0][2].values=m.clone(Math.round(m.level/5)).action;
							m.action=null;
						}
						applySuffix(_index,"of Cantrip",m,[]);
						break;
						
						/* ALCHEMY HERE */
					case 42: applySuffix(_index,"of Sipping",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectHeal("Health Sip",40,DamageModel.CHEMICAL)]]); break;//Heal Pot
					case 43: applySuffix(_index,"of Bubbling",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectMana("Mana Sip",25,DamageModel.CHEMICAL)]]); break; //Mana Pot
					case 44: applySuffix(_index,"Amplified",m,[[SpriteModel.ATTACK,ActionBase.TAG,EffectData.TWO_CHARGES],[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.BUFF_POT_BOOST,10)]]); break; //Amp Pot
					case 45: applySuffix(_index,"of Great Alchemy",m,[[SpriteModel.ATTACK,ActionBase.DODGE_REDUCE,0.07],[SpriteModel.ATTACK,ActionBase.DAMAGE,0.07]]); break; //Alch Fire
					case 46: applySuffix(_index,"of Acid",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectBuffBasic(new BuffStats(35,"Acid",0,BuffBase.CURSE,3,[[SpriteModel.STAT,StatModel.RCHEMICAL,-0.15]]),EffectBase.CURSE)]]); break; //Toxic Gas
					case 47: applySuffix(_index,"of Purging",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.REMOVE_BUFF,3)]]); break;//Holy Water
					
					case 48: //Recovery Pot
						if (m.index==135){
							m.values.push([SpriteModel.ATTACK,ActionBase.TAG,EffectData.DURATION]);
						}else{
							for (i=0;i<m.action.effects.length;i+=1){
								if (m.action.effects[i] is EffectBuff){
									(m.action.effects[i] as EffectBuff).buff.charges+=1;
								}
							}
						}
						applySuffix(_index,"of Better",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.BUFF_POT_BOOST,0)]]);
						 break;
					
					case 49: //Celerity Pot
						if (m.index==135){
							m.values.push([SpriteModel.ATTACK,ActionBase.TAG,EffectData.DURATION2]);
						}else{
							for (i=0;i<m.action.effects.length;i+=1){
								if (m.action.effects[i] is EffectBuff){
									(m.action.effects[i] as EffectBuff).buff.charges+=3;
								}
							}
						}
						applySuffix(_index,"of Longevity",m,[[SpriteModel.ATTACK,ActionBase.TAG,EffectData.TWO_CHARGES]]);
						break;
					case 50: applySuffix(_index,"of Dreaming",m,[[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.DREAM,0)]]); break;//Purity Pot
					case 51: //Turtle Soup
						if (m.index==135){
							m.values.push([SpriteModel.ATTACK,ActionBase.TAG,EffectData.DURATION_MINUS]);
						}else{
							for (i=0;i<m.action.effects.length;i+=1){
								if (m.action.effects[i] is EffectBuff){
									(m.action.effects[i] as EffectBuff).buff.charges-=2;
								}
							}
						}
						applySuffix(_index,"of Supremeness",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.BUFF_POT_BOOST,20)]]);//Celerity Pot
						break;
					/*
					Heal +40 (Pot Only)
					Mana +25 (Pot Only)
					Cleanse x2 (on Self, Pot Only)
					Cost 2, Level +3
					Cost 2, Duration +2
					Manufacturing +5
					Duration -3, Level +5
					Level -1, Acc +10% (Gr. Only)
					RChem -15% (Gr. Only)
					Purge Buff x1 (on Enemy, Gr. Only)
					*/
				}
			}else if (_index<=111){
				switch(_index){
					case 64: applySuffix(_index,"of Sacrifice",m,[[SpriteModel.STAT,StatModel.STRENGTH,50],[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.SACRIFICE,10)]]); break;//Kabuto
					case 65: applySuffix(_index,"of Light",m,[[SpriteModel.STAT,StatModel.HOLYEFF,0.22]]); break;//Hood
					case 66: applySuffix(_index,"of Sprites",m,[[SpriteModel.STAT,StatModel.ITEMEFF,0.15]]); break; //Phrygian Cap
					case 67: applySuffix(_index,"of Plumbing",m,[[SpriteModel.STAT,StatModel.CHEMEFF,0.22]]); break; //Plumber Hat     
					case 68: applySuffix(_index,"of Blocking",m,[[SpriteModel.STAT,StatModel.BLOCKMULT,0.15]]); break; //Boxing Gear
					case 69: applySuffix(_index,"of Quickening",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.QUICK,4)]]); break; //Turban
					case 70: applySuffix(_index,"of Finding",m,[[SpriteModel.STAT,StatModel.ILOOT,0.1]]); break; //Crown
					case 71: applySuffix(_index,"of Trine",m,[[SpriteModel.STAT,StatModel.STRENGTH,20],[SpriteModel.STAT,StatModel.MPOWER,20],[SpriteModel.STAT,StatModel.INITIATIVE,20]]); break; //Protector
					case 72: applySuffix(_index,"of Honor",m,[[SpriteModel.ATTACK,ActionBase.CRITRATE,0.3],[SpriteModel.ATTACK,ActionBase.CRITMULT,-0.75]]); break; //Katanas
					case 73: applySuffix(_index,"of Luminance",m,[[SpriteModel.ATTACK,ActionBase.CEFFECT,new EffectDamage("Luminant",110,DamageModel.HOLY)]]); break; //Light Sword
					case 74: applySuffix(_index,"of Rending",m,[[SpriteModel.ATTACK,ActionBase.CEFFECT,EffectData.makeEffect(EffectData.REND,10)]]); break; //Rending Claws
					case 75: applySuffix(_index,"of Power",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.FULL_POWER2,0)]]); break; //Hylian Sword
					case 76: applySuffix(_index,"of Combustion",m,[[SpriteModel.ATTACK,ActionBase.CEFFECT,new EffectDamage("Blazing",110,DamageModel.CHEMICAL,7,1,PopEffect.FIRE)]]); break; //Plumber Gloves
					case 77: applySuffix(_index,"of Avoidance",m,[[SpriteModel.STAT,StatModel.DODGE,0.1]]); break; //Boxing Gloves
					case 78: applySuffix(_index,"of Befuddling",m,[[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.BEFUDDLE,10)]]); break; //Saruman's Staff
					case 79: applySuffix(_index,"of Impact",m,[[SpriteModel.ATTACK,ActionBase.CEFFECT,EffectData.makeEffect(EffectData.SMASH,6)]]); break; //Mjolnir
					case 80: applySuffix(_index,"of Righteousness",m,[[SpriteModel.STAT,StatModel.BLOCK,50]]); break; //Captain's Shield
					case 81: applySuffix(_index,"of Flurry",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.QUICK,4)]]); break; //Twin Scimitars
					case 82: applySuffix(_index,"of Seeking",m,[[SpriteModel.STAT,StatModel.ILOOT,0.1]]); break; //Royal Scepter
					case 83: applySuffix(_index,"of Neptune",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.MPOWSCALING,8)]]); break; //Neptune's Trident
					case 84: applySuffix(_index,"of the Ancients",m,[[SpriteModel.STAT,StatModel.SPELLSTEAL,0.09]]); break; //Ancient Ankh
					case 85: applySuffix(_index,"of Riddance",m,[[SpriteModel.ATTACK,ActionBase.CEFFECT,EffectData.makeEffect(EffectData.KNOCKBACK_NO,0)]]); break; //Baseball Bat
					case 86: applySuffix(_index,"of the Supreme Master",m,[[SpriteModel.ATTACK,ActionBase.DAMAGE,0.1]]); break; //Breaker Sword
					
					case 87: applySuffix(_index,"of the Nail",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.TERRIFYING,7)]]); break; //Board with a Nail In It
					case 88: applySuffix(_index,"of Carousing",m,[[SpriteModel.STAT,StatModel.POTEFF,0.22]]); break; //Mullet
					case 89: applySuffix(_index,"of Increase",m,[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.BUFF_POT_BOOST,10)]]); break; //Ampersand
					case 90: applySuffix(_index,"of Undeath",m,[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.UNDYING,-1)]]); break; //Death Jester
					case 91: applySuffix(_index,"of Autobuff",m,[[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.AUTOBUFF,10)]]); break; //Envenomed Mask
					case 92: applySuffix(_index,"of Gas",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectBuffBasic(BuffData.makeBuff(BuffData.GASSED,1),EffectBase.CURSE)]]); break; //Rose Thorns
					case 93: applySuffix(_index,"of Exploding",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectBuffBasic(BuffData.makeBuff(BuffData.BOMB,1),EffectBase.CURSE)]]); break; //Classic Bomb
					case 94: applySuffix(_index,"of the Rat",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.DAZZLE,10)]]); break; //Flying Rat
					case 95: applySuffix(_index,"of Infinity",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.INFINITY,0)]]); break; //Chakram
					/*case 96:
					case 97:
					case 98:
					case 99:
					case 100:*/
					case 101: applySuffix(_index,"of Respect",m,[[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.RESPECT,10)]]); break; //Riot Helmet
					case 102: applySuffix(_index,"of Durability",m,[[SpriteModel.STAT,StatModel.RPHYS,0.1]]); break; //Hell Horns
					case 103: applySuffix(_index,"of Horror",m,[[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.FEAR_BOOST,10)]]); break; //Hockey Mask
					case 104: applySuffix(_index,"of Movement",m,[[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.MOVE_BOOST,10)]]); break; //Propeller Beanie
					case 105: applySuffix(_index,"of Authoritah",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.AUTHORITAH,10)]]); break; //Riot Gear
					case 106: applySuffix(_index,"of Abuse",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.COMBO,2)]]); break; //Hell Hands
					case 107: applySuffix(_index,"Motorized",m,[[SpriteModel.ATTACK,ActionBase.DAMAGE,-0.6],[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.CHAIN,2)]]); break; //Chainsaw
					
					case 108: applySuffix(_index,"of Eternity",m,[[SpriteModel.STAT,StatModel.TURN_REDUCE,0.1]]); break; //Eternal Tome
					case 109: applySuffix(_index,"of Temporality",m,[[SpriteModel.ATTACK,ActionBase.DODGE_REDUCE,0.1]]); break; //Temporary Bow
					case 110: applySuffix(_index,"Half Darkened",m,[[SpriteModel.STAT,StatModel.DARKEFF,0.22]]); break; //Dark Half Hood
					case 111: applySuffix(_index,"of Scorching",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.SCORCHED,7)]]); break; //Dark Half Swords
				}
			}else{
				switch(_index){
					case 112: applySuffix(_index,"Upturned",m,[[SpriteModel.STAT,StatModel.PROCEFF,0.22]]); break; //Pentagram
					case 113: applySuffix(_index,"of Healing",m,[[SpriteModel.STAT,StatModel.HEALMULT,0.22]]); break; //Holy Grail
					
					case 114: applySuffix(_index,"of Crusading",m,[[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.MAGIC_STRIKE,4)]]); break; //Crusader's Mace
					case 115: applySuffix(_index,"of Initiation",m,[[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.INITIAL_BLESS,10)]]); break; //Crusader's Helmet
					case 116: applySuffix(_index,"Delayed",m,[[SpriteModel.ATTACK,ActionBase.DAMAGE,-0.4],[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.DELAYED_DAMAGE,0)]]); break; //Demon Sickles
					case 117: applySuffix(_index,"of Overturning",m,[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.CURSE_REFLECT,10)]]); break; //Demon Horns
					// case 118: applySuffix(_index,"of Experience",m,[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.AWARD,0)],[SpriteModel.STAT,StatModel.ILOOT,0.1]]); break; //Participation Award
					case 119: applySuffix(_index,"of Superior Experience",m,[[SpriteModel.STAT,StatModel.HEALTH,60],[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.AWARD,0)],[SpriteModel.STAT,StatModel.ILOOT,0.1]]); break; //Trophy
					
					//case 120: applySuffix(_index,"",m,[]); break; //Big Pencil
					
					case 121: applySuffix(_index,"of the Tramp",m,[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.IGNORE_ATTACK,0)]]); break; //Tramp Hair
					case 122: applySuffix(_index,"of the Princess",m,[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.BARRIER,10)]]); break; //Princess
					case 123: applySuffix(_index,"of Stoning",m,[[SpriteModel.STAT,StatModel.EFFECT,new EffectBuffBasic(BuffData.makeBuff(BuffData.HIGH,15),EffectBase.BUFF,EffectBase.SAFE)]]); break; //Masta Rasta
					case 124: applySuffix(_index,"of the Sapien",m,[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.REVIVE_JUST,0)]]); break; //Sapien Hair
					
					case 125: applySuffix(_index,"of Multiplication",m,[[SpriteModel.ATTACK,ActionBase.DAMAGE,-0.6],[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.MULTI,1)]]); break; //Multibolt
				
					/*case 126: 
					case 127: 
					case 128: */
					
					case 129: applySuffix(_index,"of the Sparrow",m,[[SpriteModel.ATTACK,ActionBase.HITRATE,20],[SpriteModel.ATTACK,ActionBase.DODGE_REDUCE,0.05],[SpriteModel.ATTACK,ActionBase.CRITRATE,0.05]]); break; //Sparrow's Bow
					case 130: applySuffix(_index,"of Distance",m,[[SpriteModel.STAT,StatModel.FAR,0.15]]); break; //Bycocket
					case 131: applySuffix(_index,"of Doubling",m,[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.DOUBLESHOT,5)]]); break; //Quickdraw Quiver
					
					case 132: applySuffix(_index,"of Potency",m,[[SpriteModel.ATTACK,ActionBase.CRITMULT,1]]); break; //Sais
					case 133: applySuffix(_index,"of Closeness",m,[[SpriteModel.STAT,StatModel.NEAR,0.15]]); break; //Fukumen
					case 134: applySuffix(_index,"of Centering",m,[[SpriteModel.ATTACK,ActionBase.TAG,EffectData.MONK_WEAPON]]); break; //Shurikens
					
					case 137: applySuffix(_index,"of Screams",m,[[SpriteModel.STAT,StatModel.EFFECT,new EffectBuffBasic(BuffData.makeBuff(BuffData.AFRAID,5),EffectBase.CURSE,EffectBase.INITIAL)]]); break; //Screamer
					case 138: applySuffix(_index,"of Puzzles",m,[[SpriteModel.STAT,StatModel.EFFECT,new EffectBuffBasic(new BuffDOT(139,"Minor Trap",0,3,StatModel.MPOWER,20,ActionBase.DARK),EffectBase.CURSE,EffectBase.INITIAL)]]); break; //Puzzling Mask
					case 139: applySuffix(_index,"of Badness",m,[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.GOLD_PER_KILL,5)]]); break; //Big Bad Mask
					case 140: applySuffix(_index,"of Containment",m,[[SpriteModel.ATTACK,ActionBase.LEECH,0.12]]); break; //Muzzle
					case 141: applySuffix(_index,"of Concussion",m,[[SpriteModel.ATTACK,ActionBase.EFFECT,new EffectDamage("Concuss",20,DamageModel.PHYSICAL)]]); break; //Ruby Visor
					case 142: applySuffix(_index,"of Rocketeering",m,[[SpriteModel.STAT,StatModel.MANATOMPOW,0.1]]); break; //Rocketman
					case 143: applySuffix(_index,"of Sophistication",m,[[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.NO_OFFENSIVE,7)]]); break; //Monacle
					case 144: applySuffix(_index,"of Goggles",m,[[SpriteModel.STAT,StatModel.THROWEFF,0.25]]); break; //Goggles
				}
			}
			
			if (m.index==135){
				if (finishTestSuffix(HELMET,_index)){
					m.tags.push(HELMET);
				}
				if (finishTestSuffix(WEAPON,_index)){
					m.tags.push(WEAPON);
				}
				if (finishTestSuffix(MAGIC,_index)){
					m.tags.push(MAGIC);
				}
				if (finishTestSuffix(DAMAGING,_index)){
					m.tags.push(DAMAGING+" "+MAGIC);
				}
				if (finishTestSuffix(CURSE,_index)){
					m.tags.push(CURSE+" "+MAGIC);
				}
				if (finishTestSuffix(BUFF,_index)){
					m.tags.push(BUFF+" "+MAGIC);
				}
				if (finishTestSuffix(SCROLL,_index)){
					m.tags.push(SCROLL);
				}
				if (finishTestSuffix(PROJECTILE,_index)){
					m.tags.push(PROJECTILE);
				}
				if (finishTestSuffix(GRENADE,_index)){
					m.tags.push(GRENADE);
				}
				if (finishTestSuffix(POTION,_index)){
					m.tags.push(POTION);
				}
				if (finishTestSuffix(BUFF+" "+POTION,_index)){
					m.tags.push(BUFF+" "+POTION);
				}
				if (finishTestSuffix(CHARM,_index)){
					m.tags.push(CHARM);
				}
				if (finishTestSuffix(EffectData.RELIC,_index)){
					m.tags.push(EffectData.RELIC);
				}
			}
			return m;
		}
		
		static function applySuffix(i:int,suffix:String,m:ItemModel,values:Array){
			if (suffix.length>0){
				m.name=m.name+" "+suffix;
			}
			m.suffixIndex=i;
			
			if (values!=null){
				for (var j:int=0;j<values.length;j+=1){
					endApply(m,values[j]);
				}
			}
		}
		
		static function applyEnchant(i:int,prefix:String,m:ItemModel,v:Number,value:Array){
			if (prefix.length>0){
				m.name=prefix+" "+m.name;
			}
			
			m.enchantIndex=i;
			m.cost*=v;
			
			if (value!=null) endApply(m,value);
		}
		
		static function endApply(m:ItemModel,value:Array){
			if (value[0]==SpriteModel.ATTACK){
				if (m.action!=null && !m.hasTag(EffectData.RELIC)){
					if (value[1]==ActionBase.DAMAGE){
						m.action.damage*=(1+value[2]);
					}else if (value[1]==ActionBase.MANA){
						m.action.mana*=(1+value[2]);
					}else{
						m.action.addValue(value[1],value[2]);
					}
				}else{
					_b=false;
					for (j=0;j<m.values.length;j+=1){
						if ((m.values[j][0]==SpriteModel.ATTACK || m.values[j][0]==SpriteModel.UNARMED) && m.values[j][1]==value[1] && m.values[j][1]!=ActionBase.EFFECT && m.values[j][1]!=ActionBase.CEFFECT){
							m.values[j][2]+=value[2];
							_b=true;
							break;
						}
					}
					if (_b==false) m.values.push(value);
				}
			}else if (value[0]==SpriteModel.STAT){
				if (value[1]==StatModel.TURN_REDUCE && m.action!=null && (m.action.isMagic())){
					m.action.dodgeReduce+=value[2];
				}else{
					if (value[1]==StatModel.HEALTH && m.level>15){
						value[2]*=(m.level-5)/10;
					}
					var _b:Boolean;
					for (var j:int=0;j<m.values.length;j+=1){
						if (m.values[j][0]==SpriteModel.STAT && m.values[j][1]==value[1] && m.values[j][1]!=StatModel.EFFECT && m.values[j][1]!=StatModel.PROCS && m.values[j][1]!=StatModel.DISPLAYS) {
							m.values[j][2]+=value[2];
							_b=true;
							break;
						}
					}
					if (_b==false) m.values.push(value);
				}
			}else{
				m.values.push(value);
			}
		}
		
		public static function spawnGamble(_level:int):ItemModel{
			var m:ItemModel;
			switch(Math.floor(Math.random()*7)){
				case 0: case 1: m=randomItem(WEAPON,-1);break;
				case 2: case 3: m=randomItem(HELMET,-1);break;
				case 4: m=randomItem(PROJECTILE,-1);break;
				case 5: m=randomItem(CHARM,-1);break;
				case 6: m=randomItem(SCROLL,-1);break;
				default:null;
			}
			m.cost=gambleCost(m.cost,_level,m.primary==PROJECTILE);
			
			return m;
		}
		
		public static function gambleCost(_cost:int,_level:int,_projectile:Boolean):int{
			//var m:int=(_cost*(1+_level/5)+100)*_level*_level*4;
			var m:int=(_cost*(1+_level/5)+100)*_level*4;
			if (_projectile){
				m*=5;
			}
			return m;
		}
		
		static const SUPER:Vector.<int>=new <int>[112,113,114,115,116,117,121,122,123,124,131,134,138,140,142,144];
		static const PREMIUM:Vector.<int>=new <int>[64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,
												83,84,85,86,87,88,89,90,91,92,93,94,95,
												101,102,103,104,105,106,107,108,109,110,111,125,129,130,132,133,137,139,141,143];
		
		public static function spawnPremium(_level:int,_super:Boolean=false):ItemModel{
			if (_super && Math.random()<0.01){
				var i:int=SUPER[Math.floor(Math.random()*SUPER.length)];
			}else{
				i=PREMIUM[Math.floor(Math.random()*PREMIUM.length)];
			}
			
			return spawnItem(_level,i);
		}
		
		public static function finishPremium(_item:ItemView){
			_item.model.cost=500;
		}
		
		public static function finishGamble(_item:ItemView){
			var _level:int=Math.ceil(Facade.gameM.area/10);
			if (_level>15) _level=15;

			var m:ItemModel;
			
			if (_item.model.primary==SCROLL) m=randomItem(SCROLL,_level);
			else m=spawnItem(_level,_item.model.index);
			if (m.primary!=SCROLL){
				enchantItem(m);
			}
			if ((m.primary==PROJECTILE)||(m.primary==SCROLL)){
				m.charges=m.maxCharges();
			}
			_item.update(m);
		}
		
		public static function finishGamblePremium(_item:ItemView){
			_item.update(spawnPremium(0));
		}
		
		public static function shadowItem():ItemModel{
			Facade.gameM.playerM.titleCheck();
			if (Facade.gameM.area<11){
				switch(Facade.gameM.playerM.mainClass){
					case SkillData.MONK: return enchantHelmet(spawnItem(1,9),10); //monk
					case SkillData.WIZARD: return enchantHelmet(spawnItem(1,10),11); //mage
					case SkillData.RANGER: return enchantHelmet(spawnItem(1,11),12); //ranger
					case SkillData.ALCHEMIST: return enchantHelmet(spawnItem(1,13),14); //alch
					case SkillData.PALADIN: return enchantHelmet(spawnItem(1,13),9);
					case SkillData.ACOLYTE: return enchantHelmet(spawnItem(1,11),8);
					case SkillData.ROGUE: return enchantHelmet(spawnItem(1,9),7);
					default: return enchantHelmet(spawnItem(1,12),13); //warrior
				}
			}else if (Facade.gameM.area<26){
				switch(Facade.gameM.playerM.mainClass){
					case SkillData.MONK: return enchantWeapon(spawnItem(3,4),16);
					case SkillData.WIZARD: return enchantWeapon(spawnItem(3,2),17);
					case SkillData.RANGER: return enchantWeapon(spawnItem(3,126),15);
					case SkillData.ALCHEMIST: return enchantWeapon(spawnItem(3,8),19);
					case SkillData.PALADIN: return enchantWeapon(spawnItem(3,6),15);
					case SkillData.ACOLYTE: return enchantWeapon(spawnItem(3,3),20);
					case SkillData.ROGUE: return enchantWeapon(spawnItem(3,5),18);
					default: return enchantWeapon(spawnItem(3,1),15);
				}
			}else if (Facade.gameM.area<99){
				var _item:ItemModel=enchantItem(randomItem(POTION,5),6);
				_item.charges=12;
				return _item;
			}else if (Facade.gameM.area<200){
				return enchantItem(spawnItem(0,40),30);
			}else if (Facade.gameM.area<300){
				_item=enchantItem(randomItem(SCROLL,5),6);
				_item.charges=2;
				return _item;
			}else if (Facade.gameM.area<400){
				_item=enchantItem(spawnItem(0,45),0);
				return _item;
			}else if (Facade.gameM.area<1000){
				_item=suffixItem(spawnItem(15,135),Math.floor(Math.random()*30));
				return _item;
			}else if (Facade.gameM.area<2000){
				_item=enchantItem(spawnItem(15,135),3);
				return _item;
			}
			return null;
		}
		
		public static function startingItem(_talent:int,_type:String):ItemModel{
			var _item:int;
			var _enchant:int=-1;
			if (_type==HEALING){
				return spawnItem(0,31,6)
			}else if (_type==MANA){
				return spawnItem(0,32,6)
			}
			switch(_talent){
				case SkillData.ORDINARY:
					switch(_type){
						case WEAPON: _item=6; break;
						case HELMET: _item=11; break;
						case MAGIC: _item=14; break;
						case THROW: _item=34; break;
					}
					break;
				case SkillData.DEFT:
					switch(_type){
						case WEAPON: _item=3; break;
						case HELMET: _item=11; break;
						case MAGIC: _item=14; break;
						case THROW: _item=39; break;
					}
					break;
				case SkillData.CLEVER:
					switch(_type){
						case WEAPON: _item=5; break;
						case HELMET: _item=9; _enchant=24; break;
						case MAGIC: _item=14; break;
						case THROW: _item=37; break;
					}
					break;
				case SkillData.UNGIFTED:
					switch(_type){
						case WEAPON: _item=7; break;
						case HELMET: _item=11; break;
						case MAGIC: break;
						case THROW: _item=33; break;
					}
					break;
				case SkillData.STUDIOUS:
					switch(_type){
						case WEAPON: _item=7; break;
						case HELMET: _item=11; break;
						case MAGIC: _item=21; break;
						case THROW: _item=35; break;
					}
					break;
				case SkillData.ENLIGHTENED://5
					switch(_type){
						case WEAPON: _item=8; break;
						case HELMET: _item=10; break;
						case MAGIC: _item=14; break;
						case THROW: _item=55; break;
					}
					break;
				case SkillData.POWERFUL:
					switch(_type){
						case WEAPON:_item=1; break;
						case HELMET: _item=12; break;
						case MAGIC: _item=20; break;
						case THROW: _item=38; break;
					}
					break;
				case SkillData.HOLY:
					switch(_type){
						case WEAPON: _item=6; break;
						case HELMET: _item=12; break;
						case MAGIC: _item=17; break;
						case THROW: _item=36; break;
					}
					break;
				case SkillData.WILD:
					switch(_type){
						case WEAPON: _item=5; break;
						case HELMET: _item=9; _enchant=15; break;
						case MAGIC: _item=16; break;
						case THROW: _item=37; break;
					}
					break;
				case SkillData.NOBLE: //9
					switch(_type){
						case WEAPON: _item=6; break;
						case HELMET: _item=12; break;
						case MAGIC: _item=15; break;
						case THROW: _item=35; break;
					}
					break;
			}
			var m:ItemModel=spawnItem((_talent==SkillData.NOBLE?3:0),_item);
			if (m.charges>0) m.charges=m.maxCharges();
			if (_enchant>=0) enchantItem(m,_enchant);
			return m;
		}
	}
}