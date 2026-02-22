package system.actions{
	import items.ItemModel;
	import system.actions.ActionPriorities;
	import system.effects.EffectBase;
	import system.effects.EffectData;
	import system.effects.EffectDamage;
	import system.effects.EffectBuffBasic;
	import system.effects.EffectKnockback;
	import system.buffs.BuffData;
	import system.buffs.BuffAction;
	import system.effects.EffectBuff;
	import system.buffs.BuffStats;
	import system.buffs.BuffBase;
	
	public class ActionData{
		public static const DEFAULT:ItemModel=new ItemModel(-1,"");
		
		public static const ATTACK:String="Attack",
							DODGE:String="Dodge",
							
							MISSILE:String="Magic Bolt",
							MULTI_BOLT:String="Multi Bolt",
							POISON:String="Poison Bolt",
							FIREBALL:String="Fireball",
							LIGHTNING:String="Lightning",
							SEARING:String="Searing Light",
							ENCHANT:String="Enchant Weapon",
							EMPOWER:String="Empower",
							HASTE:String="Haste",
							SLOW:String="Slow",
							WEAKEN:String="Weaken",
							VULNERABILITY:String="Vulnerability",
							CONFUSION:String="Confusion",
							HEALING:String="Healing",
							SHIELD:String="Shield",
							CYCLOPS:String="Concussive Blast",
							ROBOCOP:String="Find Weakpoint",
							
							DARK_BLAST:String="Dark Burst",
							DEADLY_CURSE:String="Blinding Curse",
							TERRIFY:String="Terrify",
							BERSERK:String="Berserk",
							ENERGIZE:String="Energize",

							HEALING_POT:String="Healing Potion",
							MANA_POT:String="Mana Potion",
							ALCH_POT:String="Alchemist Fire",
							POISON_POT:String="Toxic Gas",
							HOLY_POT:String="Holy Water",
							
							CELERITY_POT:String="Celerity Potion",
							RECOVERY_POT:String="Recover",
							TURTLE_POT:String="Turtle Up",
							PURITY_POT:String="Centered Focus",
							BUFF_POT:String="Amplification",
							
							
							THROW_D:String="Throw Dagger",
							THROW_A:String="Throw Axe",
							SHOOT:String="Throw Dart",
							SHURIKEN:String="Shuriken",
							THROW_CHAKRAM:String="Throw Chakram",
							THROW_BATARANG:String="Throw Rat",
							THROW_BOMB:String="Throw Bomb",
							THROW_ROSE:String="Throw Rose",
							THROW_ROSE2:String="Throw Toxic Rose",
							
							STUNNED:String="Stunned",
							CONFUSED:String="Confused",
							AFRAID:String="Afraid",
							WALK:String="Walk",
							WITHDRAW:String="Withdraw",
							APPROACH:String="Approach",
							//LEAP:String="Leap",
							BASH:String="Bash",
							SPINES:String="Toxic Spines",
							SCREAMER:String="Terrifying Scream",
							
							HEAL_GRAIL:String="Sip of Life",
							MANA_PENTA:String="Full Mana",
							
							CANNIBAL:String="Cannibal Strike";
							
		
		public static function makeAttack():ActionAttack{
			return new ActionAttack(ActionPriorities.NEAR,1,ActionBase.PHYSICAL,null,100,0.05,2,null);
		}

		public static function makeWeapon(damage:int,effects:Vector.<EffectBase>=null,cEffects:Vector.<EffectBase>=null,hitrate:int=0,critrate:Number=0,critmult:Number=0,tags:Array=null,alsoRanged:Boolean=false):ActionBase{
			//return new ActionBase(ATTACK,0,1,alsoRanged?ActionPriorities.COMBAT:ActionPriorities.NEAR,ActionBase.ENEMY,damage,ActionBase.PHYSICAL,effects,hitrate,critrate,critmult,cEffects);
			return new ActionAttack((alsoRanged?ActionPriorities.COMBAT:ActionPriorities.NEAR),damage,ActionBase.PHYSICAL,effects,hitrate,critrate,critmult,cEffects,0,0,tags);
		}
		
		public static function makeRanged(damage:int,effects:Vector.<EffectBase>=null,cEffects:Vector.<EffectBase>=null,hitrate:int=0,critrate:Number=0,critmult:Number=0,accuracy:Number=0,tags:Array=null):ActionBase{
			//return new ActionBase(ATTACK,0,1,ActionPriorities.FAR,ActionBase.ENEMY,damage,ActionBase.PHYSICAL,effects,hitrate,critrate,critmult,cEffects,0,0,accuracy);
			return new ActionAttack(ActionPriorities.FAR,damage,ActionBase.PHYSICAL,effects,hitrate,critrate,critmult,cEffects,0,accuracy,tags);
		}

		public static function makeAction(label:String,level:int=0):ActionBase{
			switch (label){
				case MISSILE: return new ActionSpellDamaging(label,level,36+4.2*level,ActionBase.MAGICAL,null,15+0.8*level,[EffectData.LONG_RANGED]);
				case MULTI_BOLT: return new ActionSpellDamaging(label,level,14+1.1*level,ActionBase.MAGICAL,new <EffectBase>[EffectData.makeEffect(EffectData.MULTI,3)],6+0.67*level,[EffectData.LONG_RANGED]);
				case FIREBALL: return new ActionSpellDamaging(label,level,41+5.55*level,ActionBase.MAGICAL,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.BURNED,level),EffectBase.CURSE,EffectBase.HIT,0.34)],20+1.8*level,[EffectData.LONG_RANGED]);
				case LIGHTNING: return new ActionSpellDamaging(label,level,49+7.95*level,ActionBase.MAGICAL,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.STUNNED,level),EffectBase.CURSE,EffectBase.HIT,0.05)],25+2.7*level);
				case SEARING: return new ActionSpellDamaging(label,level,75+12.7*level,ActionBase.HOLY,null,40+4.25*level,[EffectData.HALF_MPOW]);
				case DARK_BLAST: return new ActionSpellDamaging(label,level,45+6.35*level,ActionBase.DARK,null,29+1.3*level);
				case CYCLOPS: return new ActionSpellDamaging(label,level,41+5.55*level,ActionBase.PHYSICAL,new <EffectBase>[new EffectKnockback("Concuss")],15+1*level,[EffectData.FULL_MPOW]);
				case ROBOCOP: return new ActionSpellCursing(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.ROBOCOP,level),EffectBase.CURSE)],29+1.3*level);
				case POISON: return new ActionSpellCursing(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.POISONED,level),EffectBase.CURSE)],26+0.8*level,[EffectData.LONG_RANGED]);
				case VULNERABILITY: return new ActionSpellCursing(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.VULNERABLE,level),EffectBase.CURSE)],25+1.05*level);
				case WEAKEN: return new ActionSpellCursing(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.WEAKENED,level),EffectBase.CURSE)],23+.75*level);
				case CONFUSION: return new ActionSpellCursing(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.CONFUSED,level),EffectBase.CURSE)],13+1.5*level);
				case DEADLY_CURSE: return new ActionSpellCursing(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.CURSED,level),EffectBase.CURSE)],16+1.05*level);
				case TERRIFY: return new ActionSpellCursing(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.AFRAID,level*1.5),EffectBase.CURSE)],17+1.35*level);
				case SLOW: return new ActionSpellCursing(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.SLOW,level),EffectBase.CURSE)],16+1.3*level);
				
				case ENCHANT: return new ActionSpellBuffing(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.ENCHANTED,level),EffectBase.BUFF,EffectBase.ALL)],13+.8*level,[EffectData.HALF_MPOW]);
				case EMPOWER: return new ActionSpellBuffing(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.EMPOWERED,level),EffectBase.BUFF,EffectBase.ALL)],13+.8*level);
				case HASTE: return new ActionSpellBuffing(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.HASTENED,level),EffectBase.BUFF,EffectBase.ALL)],16+1.3*level);
				case BERSERK: return new ActionSpellBuffing(label,level,new <EffectBase>[EffectData.makeEffect(EffectData.STRENGTHEN,level)],14+1.05*level);
				
				case HEALING: return new ActionSpellHealing(label,level,78+6.65*level,ActionBase.HOLY,null,25+1.6*level,[EffectData.HALF_MPOW]);
				case SHIELD: return new ActionSpellBuffing(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.SHIELD,level),EffectBase.BUFF,EffectBase.ALL)],25+1.6,[EffectData.HALF_MPOW]);
				//case ENERGIZE: return finishSpell(label,level,ActionBase.SELF,ActionBase.MAGICAL,0,1000);
				
				case THROW_D: return new ActionProjectile(label,level,ActionPriorities.COMBAT,34+3.2*level,null,15+10*level,0,0,null,0,[EffectData.HALF_STRENGTH,EffectData.LONG_RANGED]);
				case THROW_A: return new ActionProjectile(label,level,ActionPriorities.COMBAT,36+3.5*level,null,0,0,0,new <EffectBase>[new EffectDamage("Bonus Physical",35+20*level,DamageModel.PHYSICAL)],0,[EffectData.HALF_STRENGTH]);
				case SHOOT: return new ActionProjectile(label,level,ActionPriorities.COMBAT,38+1.6*level,null,0,0,0,null,0,[EffectData.PIERCE,EffectData.LONG_RANGED]);
				
				case SHURIKEN: return new ActionProjectile(label,level,ActionPriorities.COMBAT,11+0.7*level,new <EffectBase>[EffectData.makeEffect(EffectData.MULTI,1)],0,0,0,null,0.05,[EffectData.MONK_WEAPON]);
				case THROW_CHAKRAM: return new ActionProjectile(label,level,ActionPriorities.FAR,18+1.25*level,null,0,0,0,null,0.05,[EffectData.FULL_STRENGTH,EffectData.RETURN,EffectData.ONLYFAR]);
				case THROW_BATARANG: return new ActionProjectile(label,level,ActionPriorities.COMBAT,38+1.6*level,new <EffectBase>[EffectData.makeEffect(EffectData.DAZZLE,level*2)],5+2*level,0,0,null,0.05,[EffectData.PIERCE,EffectData.LONG_RANGED]);
				case THROW_ROSE: return new ActionProjectile(label,level,ActionPriorities.COMBAT,18+1.6*level,new <EffectBase>[EffectData.makeEffect(EffectData.IVY,level)],15+10*level,0,0,null,0.1,[EffectData.HALF_STRENGTH,EffectData.TWO_CHARGES]);
				case THROW_ROSE2: return new ActionGrenadeCursing(label,level,new <EffectBase>[EffectData.makeEffect(EffectData.IVY,level)],0.1,[EffectData.TWO_CHARGES]);
				case SCREAMER: return new ActionSpellCursing(label,level,new <EffectBase>[new EffectBuffBasic(new BuffAction(30,BuffData.AFRAID,level,3,0.5+0.015*level),EffectBase.CURSE,EffectBase.HIT,1)],0,[EffectData.TWO_CHARGES]);
				case BUFF_POT: return new ActionBuffPot(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.BUFF_POT,level),EffectBase.BUFF,EffectBase.ALL)]);
				case CELERITY_POT: return new ActionBuffPot(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.CELERITY_POT,level),EffectBase.BUFF,EffectBase.ALL)]);
				case TURTLE_POT: return new ActionBuffPot(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.TURTLE_POT,level),EffectBase.BUFF,EffectBase.ALL)]);
				case PURITY_POT: return new ActionBuffPot(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.PURITY_POT,level),EffectBase.BUFF,EffectBase.ALL)]);
				
				case ALCH_POT: return new ActionGrenadeDamage(label,level,75+4.45*level,ActionBase.CHEMICAL);
				case HOLY_POT: return new ActionGrenadeDamage(label,level,68+4.15*level,ActionBase.HOLY,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.BLIND,level),EffectBase.CURSE)]);
				case POISON_POT: return new ActionGrenadeCursing(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.GASSED,level),EffectBase.CURSE)]);
				case THROW_BOMB: return new ActionGrenadeCursing(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.BOMB,level),EffectBase.CURSE)],0.05);
				
				//Potion(label,level:String,target:String,damage:int,effects:Vector.new <EffectBase>=null,type:String=null)
				
				case HEALING_POT: return new ActionPotionHealing(label,level,130+10.6*level);
				case MANA_POT: return new ActionPotionMana(label,level,60+3.15*level);
				case RECOVERY_POT: return new ActionPotionRecovery(label,level,95+7*level);
				
				//case HEAL_GRAIL: return finishPotion(label,level,ActionBase.SELF,1,new <EffectBase>[EffectData.makeEffect(EffectData.RANDOM_BUFF,level)]);
				case HEAL_GRAIL: return new ActionPotionHealingPercent(label,level,0.3,new <EffectBase>[EffectData.makeEffect(EffectData.HEAL_GRAIL,level)]);
				case MANA_PENTA: return new ActionPotionManaPercent(label,level,1);
				
				//Boss(label:String,useRate:Number,damage:int,effects:Vector.new <EffectBase>=null,_mana:int=0)
				case BASH: return new ActionBash(label,level,0.3,10+level,new <EffectBase>[new EffectKnockback("Bash",level,EffectBase.HIT,EffectKnockback.BACK,true)],20,0.1);
				case SPINES: return new ActionGrenadeDamage(label,level,20+level,ActionBase.CHEMICAL,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.SPINES,level),EffectBase.CURSE)],0,ActionPriorities.NEAR);
				
				//Others: as written
				case WALK: return new ActionWalk();
				case APPROACH: return new ActionApproach();
				
				case WITHDRAW: return new ActionWithdraw(level);
				case CANNIBAL: return new ActionBuffStrike(label,level,new <EffectBase>[new EffectBuffBasic(BuffData.makeBuff(BuffData.CANNIBALISM,level),EffectBase.BUFF,EffectBase.ALL,1)]);
				
				default: throw(new Error("Unidentified action: "+label));
			}
		}
	}
}