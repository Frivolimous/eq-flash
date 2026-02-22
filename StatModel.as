package{
	import hardcore.HardcoreGameControl;

	public class StatModel{
		import skills.SkillData;
		import system.actions.ActionBase;
		import system.effects.EffectBase;
		
		public static const statNames:Vector.<String>=new <String>["STR","M.POW","INIT","HP","H.REG","MP","M.REG","R.MAGI","R.CHEM","R.SPIRIT","R.CRIT","R.PHYS",
																   "R.SPECIAL","DODGE","BLOCK","NULLIFY","SPELL PEN","LOOT","ITEM","DRINK","PHYSICAL",
																   "GRENADE","HOLY","CHEM","MAGI","DOT","PROC","NEAR","FAR","BASE DMG","REFILL BELT",
																   "M.RATE","I RATE","D.RATE","G.RATE","M.SLOTS","RANDOM DMG","TENACITY","Str Mult",
																   "MPow Mult","Init Mult","Block Mult","HEAL","Regen Mult","Block To Resist","Buff Turns",
																   "Curse Turns","Health from Armor","SPELLSTEAL","EFFECT","EFFECTS","PROCS","DISPLAYS",
																   "Health Mult","Mana Mult","Far Avoid","Mana To MPow","Mana To Str","FURY","FURY DECAY","Fury to Strength",
																   "Fury to R.Phys","Fury to Resist","DARK","Fury to Base Damage","Fury to Tenacity"];
		public static const STRENGTH:int=0,
							MPOWER:int=1,
							INITIATIVE:int=2,
							
							HEALTH:int=3,
							HREGEN:int=4,
							MANA:int=5,
							MREGEN:int=6,
							
							RMAGICAL:int=7,
							RCHEMICAL:int=8,
							RSPIRIT:int=9,
							RCRIT:int=10,
							RPHYS:int=11,
							RALL:int=12,
							
							DODGE:int=13,
							BLOCK:int=14,
							TURN:int=15,
							
							TURN_REDUCE:int=16,
							
							ILOOT:int=17,
							
							ITEMEFF:int=18,
							POTEFF:int=19,
							PHYSEFF:int=20,
							THROWEFF:int=21,
							HOLYEFF:int=22,
							CHEMEFF:int=23,
							MAGICEFF:int=24,
							DOTEFF:int=25,
							PROCEFF:int=26,
							
							NEAR:int=27,
							FAR:int=28,
							
							DMGMULT:int=29,
							
							CRAFT_BELT:int=30,
							
							MRATE:int=31,
							IRATE:int=32,
							PRATE:int=33,
							TRATE:int=34,
							
							SLOTS:int=35,
							DRANGE:int=36,
							
							TENACITY:int=37,
							
							STRMULT:int=38,
							MPOWMULT:int=39,
							INITMULT:int=40,
							BLOCKMULT:int=41,
							HEALMULT:int=42,
							REGMULT:int=43,
							BLOCKTORALL:int=44,
							
							BUFFMULT:int=45,
							CURSEMULT:int=46,
							ARMORTOHEALTH:int=47,
							
							SPELLSTEAL:int=48,
							
							EFFECT:int=49,
							EFFECTS:int=50,
							PROCS:int=51,
							DISPLAYS:int=52,
							
							HEALTHMULT:int=53,
							MANAMULT:int=54,
							FAR_AVOID:int=55,
							MANATOMPOW:int=56,
							MANATOSTRENGTH:int=57,
							
							FURY:int=58,
							FURY_DECAY:int=59,
							FURYTOSTRENGTH:int=60,
							FURYTORPHYS:int=61,
							FURYTORALL:int=62,
							
							DARKEFF:int=63,
							FURYTOBASE:int=64,
							FURYTOTENACITY:int=65,
							NULL:int=66;
							
		private var strength:Number,
					mpower:Number,
					initiative:Number,
					
					health:Number,
					mana:Number,
					hregen:Number,
					mregen:Number,
					
					rmagical:Number,
					rchemical:Number,
					rdark:Number,
					rcrit:Number,
					rphys:Number,
					
					block:Number,
					dodge:Number,
					turn:Number,
					
					negMag:Number,
					negChem:Number,
					negDark:Number,
					negCrit:Number,
					negPhys:Number,
					negDodge:Number,
					negTurn:Number,
					
					turnReduce:Number,
					
					iloot:Number,
					
					itemeff:Number,
					poteff:Number,
					physeff:Number,
					throweff:Number,
					holyeff:Number,
					chemeff:Number,
					magiceff:Number,
					darkeff:Number,
					doteff:Number,
					proceff:Number,
					
					near:Number,
					far:Number,
					
					dmgmult:Number,
					
					mrate:Number,
					irate:Number,
					prate:Number,
					trate:Number,
					
					tenacity:Number,
					
					strmult:Number,
					mpowmult:Number,
					initmult:Number,
					healmult:Number,
					regmult:Number,
					blockmult:Number,
					healthmult:Number,
					manamult:Number,
					buffmult:Number,
					cursemult:Number,
					blocktorall:Number,
					manatompow:Number,
					manatostrength:Number,
					armortohealth:Number,
					craftBelt:Number,
					faravoid:Number,
					
					spellsteal:Number,
					fury:Number,
					
					furyDecay:Number,
					furytostrength:Number,
					furytorphys:Number,
					furytorall:Number,
					furytobase:Number,
					furytotenacity:Number;
					
		public var cfury:Number;
					
		/*public var effects:Array=[],
					procs:Array=[],
					displays:Array=[],*/
		public var effects:Vector.<EffectBase>=new Vector.<EffectBase>,
					procs:Vector.<EffectBase>=new Vector.<EffectBase>,
					displays:Vector.<EffectBase>=new Vector.<EffectBase>,
					slots:int,
					
					drange:Number;
							
		public function StatModel(){
		}
		
		public function clear(){
			strength=mpower=initiative=100;
			health=200;
			mana=100;
			fury=cfury=furyDecay=furytostrength=furytorphys=furytorall=furytobase=furytotenacity=0;
			block=50;
			poteff=itemeff=throweff=1;
			mregen=0.02;
			hregen=0;
			iloot=0.15;
			rmagical=rchemical=rdark=rcrit=rphys=dodge=turn=0;
			negMag=negChem=negDark=negCrit=negPhys=negDodge=negTurn=0;
			turnReduce=0;
			irate=mrate=0.4;
			trate=prate=0;
			craftBelt=5;
			dmgmult=strmult=mpowmult=initmult=healmult=regmult=blockmult=healthmult=manamult=buffmult=cursemult=1;
			faravoid=0;
			blocktorall=armortohealth=manatompow=manatostrength=0;
			
			spellsteal=0;
			
			physeff=holyeff=darkeff=chemeff=magiceff=doteff=proceff=1;
			near=1;
			far=1.1;
			
			drange=0.1;
			tenacity=0;
			slots=1;
			effects=new Vector.<EffectBase>;
			procs=new Vector.<EffectBase>;
			displays=new Vector.<EffectBase>;
		}
		
		public function playerBase(){
			clear();
			dodge=0.1;
		}
		
		public function addValue(_id:int,_value:*){
			switch(_id){
				case STRENGTH: strength+=_value; break;
				case MPOWER: mpower+=_value; break;
				case INITIATIVE: initiative+=_value; break;
				case HEALTH: health+=_value; break;
				case MANA: mana+=_value; break;
				case FURY: fury+=_value; break;
				case HREGEN: hregen+=_value; break;
				case MREGEN: mregen+=_value; break;
				case BLOCK: block+=_value; break;
				case DODGE: if (_value<0) addNegValue(_id,_value); else dodge=addMult(dodge,_value); break;
				case TURN: if (_value<0) addNegValue(_id,_value); else turn=addMult(turn,_value); break;
				case TURN_REDUCE: turnReduce+=_value; break;
				case RMAGICAL: if (_value<0) addNegValue(_id,_value); else rmagical=addMult(rmagical,_value); break;
				case RCHEMICAL: if (_value<0) addNegValue(_id,_value); else rchemical=addMult(rchemical,_value); break;
				case RSPIRIT: if (_value<0) addNegValue(_id,_value); else rdark=addMult(rdark,_value); break;
				case RCRIT: if (_value<0) addNegValue(_id,_value); else rcrit=addMult(rcrit,_value); break;
				case RPHYS: if (_value<0) addNegValue(_id,_value); else rphys=addMult(rphys,_value); break;
				case RALL: if (_value<0) addNegValue(_id,_value); else {rmagical=addMult(rmagical,_value); rchemical=addMult(rchemical,_value); rdark=addMult(rdark,_value);} break;
				case ILOOT: iloot=addMult(iloot,_value); break;
				case SLOTS: slots+=_value; break;
				case CRAFT_BELT: craftBelt+=_value; break;
				case EFFECT: effects.push(_value); break;
				case PROCS: procs.push(_value); break;
				case DISPLAYS: displays.push(_value); break;
				case MRATE: mrate=addMult(mrate,_value); break;
				case IRATE: irate=addMult(irate,_value); break;
				case TRATE: trate=addMult(trate,_value); break;
				case PRATE: prate=addMult(prate,_value); break;
				case ITEMEFF: itemeff+=_value; break;
				case POTEFF: poteff+=_value; break;
				case PHYSEFF: physeff+=_value; break;
				case THROWEFF: throweff+=_value; break;
				case HOLYEFF: holyeff+=_value; break;
				case DARKEFF: darkeff+=_value; break;
				case CHEMEFF: chemeff+=_value; break;
				case MAGICEFF: magiceff+=_value; break;
				case DOTEFF: doteff+=_value; break;
				case PROCEFF: proceff+=_value; break;
				case NEAR: near+=_value; break;
				case FAR: far+=_value; break;
				case DMGMULT: dmgmult+=_value; break;
				case DRANGE: drange+=_value; break;
				case TENACITY: tenacity=addMult(tenacity,_value); break;
				case STRMULT: strmult+=_value; break;
				case MPOWMULT: mpowmult+=_value; break;
				case INITMULT: initmult+=_value; break;
				case HEALMULT: healmult+=_value; break;
				case HEALTHMULT: healthmult+=_value; break;
				case MANAMULT: manamult+=_value; break;
				case REGMULT: regmult+=_value; break;
				case BLOCKMULT: blockmult+=_value; break;
				case BUFFMULT: buffmult+=_value; break;
				case CURSEMULT: cursemult+=_value; break;
				case BLOCKTORALL: blocktorall+=_value; break;
				case ARMORTOHEALTH: armortohealth+=_value; break;
				case MANATOMPOW: manatompow+=_value; break;
				case MANATOSTRENGTH: manatostrength+=_value; break;
				case SPELLSTEAL: spellsteal+=_value; break;
				case FAR_AVOID: faravoid+=_value; break;
				case FURY_DECAY: furyDecay+=_value; break;
				case FURYTOSTRENGTH: furytostrength+=_value; break;
				case FURYTORPHYS: furytorphys+=_value; break;
				case FURYTORALL: furytorall+=_value; break;
				case FURYTOBASE: furytobase+=_value; break;
				case FURYTOTENACITY: furytotenacity+=_value; break;
				case NULL: break;
				default: throw(new Error("Unavailable stat property: "+_id));
			}
		}
		
		public function subValue(_id:int,_value:*){
			switch(_id){
				case STRENGTH: strength-=_value; break;
				case MPOWER: mpower-=_value; break;
				case INITIATIVE: initiative-=_value; break;
				case HEALTH: health-=_value; break;
				case MANA: mana-=_value; break;
				case FURY: fury-=_value; break;
				case HREGEN: hregen-=_value; break;
				case MREGEN: mregen-=_value; break;
				case BLOCK: block-=_value; break;
				case DODGE: if (_value<0) subNegValue(_id,_value); else dodge=subMult(dodge,_value); break;
				case TURN: if (_value<0) subNegValue(_id,_value); else turn=subMult(turn,_value); break;
				case TURN_REDUCE: turnReduce-=_value; break;
				case RMAGICAL: if (_value<0) subNegValue(_id,_value); else rmagical=subMult(rmagical,_value); break;
				case RCHEMICAL: if (_value<0) subNegValue(_id,_value); else rchemical=subMult(rchemical,_value); break;
				case RSPIRIT: if (_value<0) subNegValue(_id,_value); else rdark=subMult(rdark,_value); break;
				case RCRIT: if (_value<0) subNegValue(_id,_value); else rcrit=subMult(rcrit,_value); break;
				case RPHYS: if (_value<0) subNegValue(_id,_value); else rphys=subMult(rphys,_value); break;
				case RALL: if (_value<0) subNegValue(_id,_value); else {rmagical=subMult(rmagical,_value); rchemical=subMult(rchemical,_value); rdark=subMult(rdark,_value);} break;
				
				case ILOOT: iloot=subMult(iloot,_value); break;
				case SLOTS: slots-=_value; break;
				case CRAFT_BELT: craftBelt-=_value; break;
				case EFFECT: effects.splice(effects.indexOf(_value),1); break;
				case PROCS: procs.splice(procs.indexOf(_value),1); break;
				case DISPLAYS: displays.splice(displays.indexOf(_value),1); break;
				case MRATE: mrate=subMult(mrate,_value); break;
				case IRATE: irate=subMult(irate,_value); break;
				case TRATE: trate=subMult(trate,_value); break;
				case PRATE: prate=subMult(prate,_value); break;
				case ITEMEFF: itemeff-=_value; break;
				case POTEFF: poteff-=_value; break;
				case PHYSEFF: physeff-=_value; break;
				case THROWEFF: throweff-=_value; break;
				case HOLYEFF: holyeff-=_value; break;
				case DARKEFF: darkeff-=_value; break;
				case CHEMEFF: chemeff-=_value; break;
				case MAGICEFF: magiceff-=_value; break;
				case DOTEFF: doteff-=_value; break;
				case PROCEFF: proceff-=_value; break;
				case NEAR: near-=_value; break;
				case FAR: far-=_value; break;
				case DMGMULT: dmgmult-=_value; break;
				case DRANGE: drange-=_value; break;
				case TENACITY: tenacity=subMult(tenacity,_value); break;
				case STRMULT: strmult-=_value; break;
				case MPOWMULT: mpowmult-=_value; break;
				case INITMULT: initmult-=_value; break;
				case HEALMULT: healmult-=_value; break;
				case HEALTHMULT: healthmult-=_value; break;
				case MANAMULT: manamult-=_value; break;
				case REGMULT: regmult-=_value; break;
				case BLOCKMULT: blockmult-=_value; break;
				case BUFFMULT: buffmult-=_value; break;
				case CURSEMULT: cursemult-=_value; break;
				case BLOCKTORALL: blocktorall-=_value; break;
				case ARMORTOHEALTH: armortohealth-=_value; break;
				case MANATOMPOW: manatompow-=_value; break;
				case MANATOSTRENGTH: manatostrength-=_value; break;
				case SPELLSTEAL: spellsteal-=_value; break;
				case FAR_AVOID: faravoid-=_value; break;
				case FURY_DECAY: furyDecay-=_value; break;
				case FURYTOSTRENGTH: furytostrength-=_value; break;
				case FURYTORPHYS: furytorphys-=_value; break;
				case FURYTORALL: furytorall-=_value; break;
				case FURYTOBASE: furytobase-=_value; break;
				case FURYTOTENACITY: furytotenacity-=_value; break;
				case NULL: break;
				default: throw(new Error("Unavailable stat property: "+_id));
			}
		}
		
		public function addNegValue(_id:int,_value:*){
			switch(_id){
				case RMAGICAL: negMag=addMult(negMag,-_value); break;
				case RCHEMICAL: negChem=addMult(negChem,-_value); break;
				case RSPIRIT: negDark=addMult(negDark,-_value); break;
				case RCRIT: negCrit=addMult(negCrit,-_value); break;
				case RPHYS: negPhys=addMult(negPhys,-_value); break;
				case RALL: negMag=addMult(negMag,-_value); negChem=addMult(negChem,-_value); negDark=addMult(negDark,-_value); break;
				case DODGE: negDodge=addMult(negDodge,-_value); break;
				case TURN: negTurn=addMult(negTurn,-_value); break;
			}
		}
		
		public function subNegValue(_id:int,_value:*){
			switch(_id){
				case RMAGICAL: negMag=subMult(negMag,-_value); break;
				case RCHEMICAL: negChem=subMult(negChem,-_value); break;
				case RSPIRIT: negDark=subMult(negDark,-_value); break;
				case RCRIT: negCrit=subMult(negCrit,-_value); break;
				case RPHYS: negPhys=subMult(negPhys,-_value); break;
				case RALL: negMag=subMult(negMag,-_value); negChem=subMult(negChem,-_value); negDark=subMult(negDark,-_value); break;
				case DODGE: negDodge=subMult(negDodge,-_value); break;
				case TURN: negTurn=subMult(negTurn,-_value); break;
			}
		}
		
		public function getValue(_id:int):Number{
			switch(_id){
				case STRENGTH: return ((strength+furytostrength*cfury)*strmult+mana*manatostrength);
				case MPOWER: return (mpower*mpowmult+mana*manatompow);
				case INITIATIVE: return (initiative*initmult);
				case HEALTH: return health*healthmult;
				case MANA: return mana*manamult;
				case FURY: return fury;
				case HREGEN: return hregen*healmult*regmult;
				case MREGEN: return mregen*regmult;
				case BLOCK: return (block*blockmult);
				case DODGE: return Math.min(1,dodge-negDodge);
				case TURN: return Math.min(1,turn-negTurn);
				case TURN_REDUCE: return turnReduce;
				case RMAGICAL: return Math.min(1,rmagical+blocktorall*block+furytorall*cfury-negMag);
				case RCHEMICAL: return Math.min(1,rchemical+blocktorall*block+furytorall*cfury-negChem);
				case RSPIRIT: return Math.min(1,rdark+blocktorall*block+furytorall*cfury-negDark);
				case RCRIT: return Math.min(1,rcrit-negCrit);
				case RPHYS: return Math.min(1,rphys-negPhys+furytorphys*cfury);
				
				case ILOOT: return iloot;
				case SLOTS: return slots;
				case CRAFT_BELT: return craftBelt;
				case MRATE: return mrate;
				case IRATE: return irate;
				case TRATE: return trate;
				case PRATE: return prate;
				case POTEFF: return poteff;
				case ITEMEFF: return itemeff;
				case PHYSEFF: return physeff;
				case THROWEFF: return throweff;
				case HOLYEFF: return holyeff;
				case DARKEFF: return darkeff;
				case CHEMEFF: return chemeff;
				case MAGICEFF: return magiceff;
				case DOTEFF: return doteff;
				case PROCEFF: return proceff;
				case NEAR: return near;
				case FAR: return far;
				case DMGMULT: return dmgmult+furytobase*Math.floor(cfury/100);
				case DRANGE: return drange;
				case TENACITY: return addMult(tenacity,furytotenacity*cfury);
				case STRMULT: return strmult;
				case MPOWMULT: return mpowmult;
				case INITMULT: return initmult;
				case HEALMULT: return Math.max(0,healmult);
				case HEALTHMULT: return healthmult;
				case MANAMULT: return manamult;
				case REGMULT: return regmult;
				case BLOCKMULT: return blockmult;
				case BUFFMULT: return buffmult;
				case CURSEMULT: return cursemult;
				case BLOCKTORALL: return blocktorall;
				case ARMORTOHEALTH: return armortohealth;
				case MANATOMPOW: return manatompow;
				case MANATOSTRENGTH: return manatostrength;
				case SPELLSTEAL: return spellsteal;
				case FAR_AVOID:return faravoid;
				
				case FURY_DECAY: return furyDecay;
				case FURYTOSTRENGTH: return furytostrength;
				case FURYTORPHYS: return furytorphys;
				case FURYTORALL: return furytorall;
				case FURYTOBASE: return furytobase;
				case FURYTOTENACITY: return furytotenacity;
				case NULL: return 0;
				default: throw(new Error("Unavailable stat property: "+_id));
			}
		}
		
		public static function addMult(b:Number,a:Number):Number{
			if (a==1) a=0.99;
			return (1-(1-a)*(1-b));
		}
		
		public static function subMult(t:Number,a:Number):Number{
			if (a==1) a=0.99;
			return (1-(1-t)/(1-a));
		}
		
		public function findEffect(_name:String):EffectBase{
			for (var i:int=0;i<effects.length;i+=1){
				if (effects[i].name==_name) return effects[i];
			}
			return null;
		}
		
		public function findProc(_name:String):EffectBase{
			for (var i:int=0;i<procs.length;i+=1){
				if (procs[i].name==_name) return procs[i];
			}
			return null;
		}
		
		public function findDisplay(_name:String):EffectBase{
			for (var i:int=0;i<displays.length;i+=1){
				if (displays[i].name==_name) return displays[i];
			}
			return null;
		}
		
		public function modProcs(_v:SpriteModel,_action:ActionBase):Vector.<EffectBase>{
			var m:Vector.<EffectBase>=new Vector.<EffectBase>;
			for (var i:int=0;i<procs.length;i+=1){
				m.push(procs[i].modify(_v,_action));
			}
			return m;
		}
		
		public function useEffects(_trigger:int,_dmgModel:DamageModel,_o:SpriteModel,_t:SpriteModel,_action:ActionBase=null){
			if (_dmgModel==null) _dmgModel=new DamageModel;
			for (var i:int=0;i<effects.length;i+=1){
				if (effects[i].canUse(_trigger,_action) && effects[i].checkRate()){
					effects[i].modify(_o,_action).applyEffect(_o,_t,_action,_dmgModel);
				}
			}
			
			_dmgModel.applyBuffs(_o,_t);
			_dmgModel.applyDamage(_o,_t,false);
		}
		
		public function useDisplays(_trigger:int,_dmgModel:DamageModel,_o:SpriteModel,_t:SpriteModel,_action:ActionBase=null){
			if (_dmgModel==null) _dmgModel=new DamageModel;
			for (var i:int=0;i<displays.length;i+=1){
				if (displays[i].canUse(_trigger,_action) && displays[i].checkRate()){
					displays[i].modify(_o,_action).applyEffect(_o,_t,_action,_dmgModel);
				}
			}
			
			_dmgModel.applyBuffs(_o,_t);
			_dmgModel.applyDamage(_o,_t,false);
		}
		
		public function setBase(_level:int,_init:int,_block:int,_strength:int,_health:int,_rCrit:int,_boss:Boolean){
			//_degree goes from 0 (slowest) to 6 (fastest)
			
			var _mult:Number=(_level/200)*0.5+0.5;
			if (_mult>1) _mult=1;
			var _base:Number;
			switch (_init){
				case 0: _base=0; break;
				case 1: _base=50; break;
				case 2: _base=100; break;
				case 3: _base=150; break;
				case 4: _base=400; break;
				case 5: _base=700; break;
				case 6: _base=1200; break;
			}
			initiative=_base*_mult;
			
			_mult=(_level/200)*0.9+0.1;
			if (_mult>1) _mult=1;
			switch (_block){
				case 0: _base=0; break;
				case 1: _base=50; break;
				case 2: _base=100; break;
				case 3: _base=200; break;
				case 4: _base=400; break;
				case 5: _base=500; break;
				case 6: _base=700; break;
			}
			block=_base*_mult;
			
			if (_level<25){
				block-=(25-_level)/25*20;
			}
			if (block<0) block=0;
			
			if (_level>50 && _level<=100){
				_level=50+(_level-50)*0.75;
			}else if (_level>100 && _level<=150){
				_level=150-(150-_level)*1.25;
			}
			
			switch(_health){
				case 0: health=50; _base=0; break;
				case 1: health=90; _base=4.62; break;
				case 2: health=110; _base=5.58; break;
				case 3: health=130; _base=8.36; break;
				case 4: health=150; _base=11.13; break;
				case 5: health=170; _base=15.4; break;
				case 6: health=190; _base=19.58; break;
			}
			health+=_base*_level;
			if (_boss) health+=200+21.45*_level;
			
			switch(_rCrit){
				case 0: rcrit=0; break;
				case 1: rcrit=0.05; break;
				case 2: rcrit=0.1; break;
				case 3: rcrit=0.2; break;
				case 4: rcrit=0.3; break;
				case 5: rcrit=0.4; break;
				case 6: rcrit=0.5; break;
			}
			
			mana=100+_level/2;
			dodge=0;
			turn=0;
			rmagical=rchemical=rdark=0.9*Facade.diminish(0.0011,_level);
			if (_level>200){
				rphys=0.9*Facade.diminish(0.00066,(_level-200));
			}else{
				rphys=0;
			}
			
			if (damageCapped()){
				if (_level>1000) _level=1000;
			}
			
			switch(_strength){
				case 0: strength=0; break;
				case 1: strength=50; _base=0.43; break;
				case 2: strength=50; _base=.85; break;
				case 3: strength=50; _base=.85; break;
				case 4: strength=50; _base=1.7; break;
				case 5: strength=50; _base=2.55; break;
				case 6: strength=50; _base=3.4; break;
			}
			strength+=_base*_level;
			if (_boss) strength+=50+_level*0.85;
			
			if (_boss){
				mpower=100+2.1*_level;
				poteff=1+_level*0.01;
				throweff=1+_level*0.01;		
				mregen=0.4;
				
			}else{
				mpower=50+0.85*_level;
				poteff=0.5+_level*0.0005;
				throweff=0.5+_level*0.0005;
			}
		}
		
		function damageCapped():Boolean{
			if (Facade.gameC!=null && Facade.gameC is hardcore.HardcoreGameControl){
				return true;
			}
			return false;
		}
	}
}