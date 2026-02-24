package artifacts{
	import utils.GameData;
	import system.actions.ActionBase;
	import system.effects.EffectData;
	import system.effects.EffectBase;
	import system.effects.EffectDamage;
	import ui.effects.PopEffect;
	
	public class ArtifactData{
		public static const MAX_LEVEL:int=10;
		
		public static const PHOENIX:String="Phoenix",
							ARCHANGEL:String="Archangel",
							SPIRIT:String="Spirit Chakra",
							VALKYRIE:String="Valkyrie",
							GAIA:String="Gaia's Tree",
							DRAGON:String="Dragon Spirit",
							BLOOD:String="Blood of Beasts",
							ESPER:String="Esper",
							MATRIX:String="The One";
		
		public static function spawnArtifact(i:int,_level:int):ArtifactModel{
			switch(i){
				case 0: return new ArtifactModel(i,"Phoenix Feather",_level,[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.REVIVE_PHOENIX,_level)]]);
				case 1: return new ArtifactModel(i,"Phoenix Ash",_level,[[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.PHOENIX_PROC,_level)]]);
				case 2: return new ArtifactModel(i,"Phoenix Flame",_level,[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.PHOENIX_THORNS,_level)]]);
				case 3: return new ArtifactModel(i,"Phoenix Will",_level,[[SpriteModel.STAT,StatModel.TENACITY,0.05+0.045*_level]]);
				case 4: return new ArtifactModel(i,"Phoenix Embers",_level,[[SpriteModel.STAT,StatModel.REGMULT,0.2+0.08*_level]]);
				case 5: return new ArtifactModel(i,"Archangel's Feather",_level,[[SpriteModel.ATTACK,ActionBase.HITRATE,3*_level],[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.FEATHER_HIT,_level)]]);
				case 6: return new ArtifactModel(i,"Archangel's Halo",_level,[[SpriteModel.STAT,StatModel.EFFECT,new EffectDamage("Radiance",50+15*_level,DamageModel.HOLY,EffectBase.BLOCK,1,PopEffect.RADIANCE)]]);
				case 7: return new ArtifactModel(i,"Archangel's Belt",_level,[[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.DISORIENT,_level)]]);
				case 8: return new ArtifactModel(i,"Archangel's Cloth",_level,[[SpriteModel.STAT,StatModel.MAGICEFF,0.1+0.035*_level]]);
				case 9: return new ArtifactModel(i,"Archangel's Whisper",_level,[[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.WHISPERED,_level)]]);
				case 10: return new ArtifactModel(i,"Crown Chakra",_level,[[SpriteModel.STAT,StatModel.HOLYEFF,0.1+0.035*_level],[SpriteModel.STAT,StatModel.DARKEFF,0.1+0.035*_level]]);
				case 11: return new ArtifactModel(i,"3rd Eye Chakra",_level,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.INITSCALING,_level)]]);
				case 12: return new ArtifactModel(i,"Heart Chakra",_level,[[SpriteModel.STAT,StatModel.BUFFMULT,0.2+0.06*_level]]);
				case 13: return new ArtifactModel(i,"Solar Plexus Chakra",_level,[[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.MUTE,_level)]]);
				case 14: return new ArtifactModel(i,"Root Chakra",_level,[[SpriteModel.STAT,StatModel.RPHYS,0.1+0.015*_level]]);
				case 15: return new ArtifactModel(i,"Valkyrie's Spear",_level,[[SpriteModel.STAT,StatModel.FAR,0.20+0.04*_level]]);
				case 16: return new ArtifactModel(i,"Valkyrie's Shield",_level,[[SpriteModel.STAT,StatModel.RMAGICAL,0.09+0.005*_level],[SpriteModel.STAT,StatModel.RCHEMICAL,0.09+0.005*_level],[SpriteModel.STAT,StatModel.RSPIRIT,0.09+0.005*_level],[SpriteModel.STAT,StatModel.BLOCKTORALL,0.0002+0.00002*_level]]);
				case 17: return new ArtifactModel(i,"Valkyrie's Wing",_level,[[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.REMOVE_BUFF,_level)]]);
				case 18: return new ArtifactModel(i,"Valkyrie's Armor",_level,[[SpriteModel.STAT,StatModel.ARMORTOHEALTH,0.25+0.05*_level]]);
				case 19: return new ArtifactModel(i,"Valkyrie's Cry",_level,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.CRIT_ACCUM,_level)]]);
				case 20: return new ArtifactModel(i,"Gaia's Song",_level,[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.SPELL_BOOST,_level)]]);
				case 21: return new ArtifactModel(i,"Gaia's Love",_level,[[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.ROOT,_level)]]);
				case 22: return new ArtifactModel(i,"Gaia's Fountain",_level,[[SpriteModel.STAT,StatModel.HEALMULT,0.05+0.045*_level]]);
				case 23: return new ArtifactModel(i,"Gaia's Gift",_level,[[SpriteModel.STAT,StatModel.ILOOT,0.1+0.045*_level]]);
				case 24: return new ArtifactModel(i,"Gaia's Dream",_level,[[SpriteModel.STAT,StatModel.EFFECT,EffectData.makeEffect(EffectData.DREAM,_level)]]);
				case 25: return new ArtifactModel(i,"Spirit Dragon's Scale",_level,[[SpriteModel.STAT,StatModel.DISPLAYS,EffectData.makeEffect(EffectData.MANA_SHIELD,_level)]]);
				case 26: return new ArtifactModel(i,"Spirit Dragon's Eye",_level,[[SpriteModel.STAT,StatModel.INITMULT,0.1+0.03*_level]]);
				case 27: return new ArtifactModel(i,"Spirit Dragon's Tooth",_level,[[SpriteModel.ATTACK,ActionBase.CEFFECT,EffectData.makeEffect(EffectData.BLEED,_level)]]);
				case 28: return new ArtifactModel(i,"Spirit Dragon's Breath",_level,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.MPOWSCALINGADD,_level)]]);
				case 29: return new ArtifactModel(i,"Spirit Dragon's Claw",_level,[[SpriteModel.ATTACK,ActionBase.EFFECT,EffectData.makeEffect(EffectData.NONCRIT,_level)]]);
				case 30: return new ArtifactModel(i,"Blood of the Vampire",_level,[[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.MPOW_HEAL,_level)]]);
				case 31: return new ArtifactModel(i,"Blood of the Xenomorph",_level,[[SpriteModel.STAT,StatModel.CHEMEFF,0.1+.035*_level]]);
				case 32: return new ArtifactModel(i,"Blood of the Minotaur",_level,[[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.MINOTAUR,_level)]]);
				case 33: return new ArtifactModel(i,"Blood of the Titan",_level,[[SpriteModel.STAT,StatModel.STRMULT,0.1+0.03*_level]]);
				case 34: return new ArtifactModel(i,"Blood of the Unicorn",_level,[[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.MANA_HEAL,_level)]]);
				case 35: return new ArtifactModel(i,"Blue Pill",_level,[[SpriteModel.STAT,StatModel.MANAMULT,0.1+0.025*_level]]);
				case 36: return new ArtifactModel(i,"Red Pill",_level,[[SpriteModel.STAT,StatModel.PROCS,EffectData.makeEffect(EffectData.MANUFACTURING_HIT,_level)]]);
				case 37: return new ArtifactModel(i,"There is no spoon",_level,[[SpriteModel.STAT,StatModel.STRENGTH,30+5*_level],[SpriteModel.STAT,StatModel.MPOWER,30+5*_level],[SpriteModel.STAT,StatModel.INITIATIVE,30+5*_level],[SpriteModel.STAT,StatModel.THROWEFF,0.3+0.05*_level]]);
				case 38: return new ArtifactModel(i,"I know Kung Fu!",_level,[[SpriteModel.STAT,StatModel.NEAR,0.06+0.01*_level],[SpriteModel.ATTACK,ActionBase.HITMULT,0.06+0.01*_level],[SpriteModel.STAT,StatModel.BLOCKMULT,0.06+0.01*_level]]);
				case 39: return new ArtifactModel(i,"Dodging Bullets",_level,[[SpriteModel.STAT,StatModel.FAR_AVOID,0.05+0.02*_level]]);
				/*case 35: return new ArtifactModel(i,"Ramuh",_level,[]);
				case 36: return new ArtifactModel(i,"Shivah",_level,[]);
				case 37: return new ArtifactModel(i,"Ifrit",_level,[]);
				case 38: return new ArtifactModel(i,"Carbunkl",_level,[]);
				case 39: return new ArtifactModel(i,"Odin",_level,[]);*/
			}
			return null;
		}
				
		public static function zoneToSoul(_zone:int,_start:int,_noLow:Boolean=true):int{
			if (_noLow && _zone<101) return 0;
			
			var m:int=calc(_zone);
			if (_start>=100){
				m-=calc(_start);
			}
			if (m>0) return m;
			return 0;
		}
		
		public static function calc(_zone:int):int{
			if (_zone>400){
				return 79188+(_zone-400)*(700+_zone/10);
			}else{
				return Math.floor(204431.4 + (238.6777 - 204431.4)/(1 + Math.pow((_zone/431.1145),6.160109)));
			}
		}
		
		public static function getDesc(s:String):String{
			switch(s){
				case PHOENIX: return "The eternal cycle of rebirth; as sure as the arrival of death is the promise of life.  The Artifacts of the Phoenix attest to the ascension of purpose independent from reincarnation.";
				case ARCHANGEL: return "The peace of the heavens shine upon us from a guardian of light that brings both kindness and justice to be.  The artifacts from on high can be glimpsed as we ascend to the kingdom of Angels.";
				case SPIRIT: return "A power within elevates and centers our being to pursue the eternal truth within a temporary dwelling.  The artifacts of our spirit are the Chakras of power, a wellspring of energy to balance our Ascension.";
				case VALKYRIE: return "Beyond our death is the echo of our glory that cries to the future of humanity.  The artifacts of our accomplishments call attention to our lives and Ascend us to greatness as the Valkyrie rides on forever.";
				case GAIA: return "Our time is an instant in a sea of the infinite.  So intertwined with the natural world are we that we unravel as we ascend. The forces of Gaia are the steadiness of the world and the womb of life that remains.";
				case DRAGON: return "Our wisdom seems minute when compared to the knowledge of nothing.  A dragon within ascends from our spirit, gifting the artifacts of truth to those that treasure the ancient ways and study them all their days.";
				case BLOOD: return "A mythology of beasts is rendered from our fear of the unknown.  As we ascend in perspective their mystery is revealed and grants us power in knowing the psychology of man and what the darkness holds over them.";
				case ESPER: return "There are dangers in life that we admire from a distance, for approaching them is to risk being consumed.  They are artifacts of power so potent and pure that they guide us from a safe distance.  For the power of the espers of wonder and legend are only approachable in ascension.";
				case MATRIX: return "You are trapped in an illusion, a construct of the mind.  Once you realize that what you think you know is only knowledge that you think, your mind will be freed."
				default: return "";
			}
		}
	}
}