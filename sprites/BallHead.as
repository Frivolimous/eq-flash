package sprites {
	import skills.SkillData;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import items.FilterData;
	import flash.filters.ColorMatrixFilter;
	
	public class BallHead extends MovieClip{
		public static const COSMETICS_SKIN:Array=[-1,6,7,8,9,10,11,12],//
							COSMETICS_EYES:Array=[-1],//[18,20,21,22]
							COSMETICS_MOUTH:Array=[-1],//[26,27,28,29]
							COSMETICS_FEET:Array=[-1],//[3,4,5,6]
							COSMETICS_EXTRA:Array=[-1],//[8,9,10,24]
							COSMETICS_AURA:Array=[-1];//[1]
							
		/*
		*	0 - Skin
		*	1 - Eyes
		*	2 - Mouth
		*	3 - Feet
		*	4 - Extra
		*	5 - Aura
		*/
						
		/*public static const COSMETICS_SKIN:Array=[-1],
							COSMETICS_EYES:Array=[-1],
							COSMETICS_MOUTH:Array=[-1],
							COSMETICS_ACCESSORY:Array=[-1],
							COSMETICS_EXTRA:Array=[-1],
							COSMETICS_AURA:Array=[-1];*/
					 //Body
		public static const FLESH:int=1,
					 GREEN:int=2,
					 SKULL:int=3,
					 STONE:int=4,
					 FUR:int=5,
					 BODY_NAMES:Array=[null,"Flesh","Orc","Skull","Stone","Fur","Dark","Chilled","Pale","Burnt","Mud","Coal","Infernal"],
					 
					 //Eyes
					 NORMAL:int=1,
					 SMALL:int=2,
					 QUIZ:int=3,
					 BRIGHT:int=4,
					 FURROW:int=5,
					 SQUINT:int=6,
					 CRAZY:int=7,
					 UPWARD:int=8,
					 SURPRISE:int=9,
					 SPIKED:int=10,
					 XED:int=11,
					 SQUINT_HARD:int=12,
					 CLOSED:int=13,
					 MEAN:int=14,
					 GIRL:int=15,
					 HOLES:int=16,
					 LIFELESS:int=17,
					 ACOLYTE:int=18,
					 JOCULAR:int=19,
					 BEADY:int=20,
					 NO_WORRY:int=21,
					 SAPIEN:int=22,
					 NINJA:int=23,
					 EYES_NAMES:Array=[null,"Normal","Small","Quiz","Bright","Furrow","Squint","Crazy","Upward","Surprised","Spiked","Xed",
									   "Hard Squint","Closed","Mean","Girl","Holes","Lifeless","Demonic","Jocular","Beady","No Worry","Sapien","Ninja"],
					
					 //Mouth
					 //NORMAL:int=1,
					 SMIRK:int=2,
					 FROWN:int=3,
					 GAPE:int=4,
					 HMM:int=5,
					 SMILE:int=6,
					 SNARL:int=7,
					 PURSED:int=8,
					 TONGUE:int=9,
					 UPFROWN:int=10,
					 UPTEETH:int=11,
					 OH:int=12,
					 TOOTHPICK:int=13,
					 ORC:int=14,
					 VAMPIRE:int=15,
					 MUTTER_SMALL:int=16,
					 MUTTER_LARGE:int=17,
					 BIG_TEETH:int=18,
					 GRIMACE:int=19,
					 WHISTLE:int=20,
					 GOBLIN_LIPS:int=21,
					 SKULL_TEETH:int=22,
					 WEDGE:int=23,
					 CAT_MOUTH:int=24,
					 OVERSMILE:int=25,
					 ENRAGED:int=26,
					 PRINCESS:int=27,
					 BE_HAPPY:int=28,
					 GRIM:int=29,
					 MOUTH_NAMES:Array=[null,"Normal","Smirk","Frown","Gape","Hmm","Smile","Snarl","Pursed","Tongue","Upfrown","Upteeth","Oh",
										"Toothpick","Orc","Vampire","Mutter Small","Mutter Large","Big Teeth","Grimace","Whistle","Lipstick",
										"Skull Teeth","Wedge","Cat Mouth","Oversmile","Enraged","Lipstick","Be Happy","Grim"],
										 
					
					 //Extras
					NONE:int=2,
					WARPAINT:int=3,
					STITCHES:int=1,
					REDEYE:int=4,
					MUD:int=5,
					FOAM:int=6,
					PAINTED:int=7,
					HALO:int=8,
					GREY_BAGS:int=9,
					MAKEUP:int=10,
					BAGS:int=13,
					GLASSES:int=14,
					CHIN:int=15,
					GOATEE:int=11,
					HOBO:int=16,
					WIZARD:int=17,
					SHADES:int=18,
					TATTOOS:int=19,
					TATTOO_SMALL:int=20,
					ROSY:int=21,
					GOATEE2:int=22,
					CAT_EARS:int=23,
					DARK_HALO:int=24,
					RANGER_SMUDGES:int=25,
					NINJA_MASK:int=26,
					QUIVER:int=27,
					SCALES:int=28,
					VIKING_BEARD:int=29,
					EXTRA_NAMES:Array=[null,"Stitches","None","Warpaint","Redeye","Mud","Foam","Painted","Halo","Bags","Makeup","Goatee","None","Baggy Eyes","Glasses","Chin","Hobo","Wizard","Shades","Tattoos","Small Tattoos",
											"Rosy","Goat-face","Cat Ears","Dark Halo","Streaks","Mask","Quiver","Scales","Viking"],
					
					AURA_NAMES:Array=[null,"Legacy"],
					FEET_NAMES:Array=[null,"Shoes","Hoofs","Fancy","Heels","Sandals","Barefoot","Boots","Slippers"],
					
					//Action
					//NORMAL:int=1,
					CAST0:int=2,
					CAST1:int=3,
					HURT:int=4,
					DEAD:int=5,
					WINDUP:int=6,
					WARCRY:int=7;
		
		var defaultEyes:int=1;
		var defaultMouth:int=1;
		var extras:Array=[null,null,null,null];
		var extraHelmets:Array=[null,null];
		var relic:*=null;
		
		public function addHelmet(i:int,_layer:int=0){
			if (extraHelmets[_layer]==null){
				extraHelmets[_layer]=new BallHat;
				extraHelmets[_layer].gotoAndStop(i);
				addChild(extraHelmets[_layer]);
			}else{
				extraHelmets[_layer].gotoAndStop(i);
			}
			sortLayers();
		}
		
		public function addHelmetFromItem(_item:int,_filters:Function,_layer:int=0){
			if (extraHelmets[_layer]==null){
				extraHelmets[_layer]=new BallHat;
				extraHelmets[_layer].x=5;
				extraHelmets[_layer].y=-4.3;
				addChild(extraHelmets[_layer]);
			}
			
			extraHelmets[_layer].fromItem(_item);
			_filters(extraHelmets[_layer]);
			
			sortLayers();
		}
		
		public function helmetSub(_frame:int){
			for (var i:int=0;i<extraHelmets.length;i+=1){
				if (extraHelmets[i]!=null && extraHelmets[i].sub!=null){
					extraHelmets[i].sub.gotoAndStop(_frame);
				}
			}
		}
		
		public function clearHelmet(){
			for (var i:int=0;i<extraHelmets.length;i+=1){
				if (extraHelmets[i]!=null){
					removeChild(extraHelmets[i]);
					extraHelmets[i]=null;
				}
			}
		}
		
		public function updateCosmetics(_cosmetics:Array,_talent:int){
			faceFromTalent(_talent);
			setFace(_cosmetics[0],_cosmetics[1],_cosmetics[2],[_cosmetics[3],_cosmetics[4],_cosmetics[7]],_cosmetics[8],_cosmetics[9]);
		}
		
		public function fromAction(i:int){
			if ((defaultEyes==HOLES)||(defaultEyes==LIFELESS)) return;
			
			switch(i){
				case NORMAL: setExpression(-1,-1); break;
				case CAST0: setExpression(CLOSED,MUTTER_SMALL); break;
				case CAST1: setExpression(CLOSED,MUTTER_LARGE); break;
				case HURT: 
					if ((defaultMouth==ORC)||(defaultMouth==VAMPIRE)){
						setExpression(SQUINT_HARD,VAMPIRE);
					}else{
						setExpression(SQUINT_HARD,BIG_TEETH);
					}break;
				case DEAD:
					if ((defaultMouth==ORC)||(defaultMouth==VAMPIRE)){
						setExpression(XED,ORC);
					}else{
						setExpression(XED,WHISTLE);
					}break;
				case WINDUP: setExpression(FURROW,GRIMACE); break;
				case WARCRY: setExpression(SQUINT_HARD,BIG_TEETH); break;
			}
		}
		
		static function checkArrayHas(a:Array,_cosmetic:int):Boolean{
			for (var i:int=0;i<a.length;i+=1){
				if (a[i]==_cosmetic) return true;
			}
			return false;
		}

		public function faceFromTalent(i:int){
			switch(i){
				case SkillData.ORDINARY: setFace(FLESH,NORMAL,NORMAL); break;
				case SkillData.DEFT: setFace(FLESH,SMALL,SMIRK); break;
				case SkillData.CLEVER: setFace(FLESH,QUIZ,FROWN); break;
				case SkillData.UNGIFTED: setFace(FLESH,NORMAL,GAPE,[BAGS]); break;
				case SkillData.STUDIOUS: setFace(FLESH,NORMAL,HMM,[null,GLASSES]); break;
				case SkillData.ENLIGHTENED: setFace(FLESH,BRIGHT,SMILE); break;
				case SkillData.POWERFUL: setFace(FLESH,FURROW,SNARL,[CHIN]); break;
				case SkillData.HOLY: setFace(FLESH,SQUINT,PURSED); break;
				case SkillData.WILD: setFace(FLESH,CRAZY,TONGUE); break;
				case SkillData.NOBLE: setFace(FLESH,UPWARD,UPFROWN,[null,GOATEE]); break;
				case SkillData.HOBO: setFace(FLESH,NORMAL,NORMAL,[null,HOBO]); break;
				case SkillData.BRAVE: setFace(FLESH,UPWARD,UPTEETH,[CHIN]); break;
				case SkillData.WHITE: setFace(FLESH,NORMAL,NORMAL,[null,WIZARD]); break;
				case SkillData.HUNTER: setFace(FLESH,SURPRISE,OH); break;
				case SkillData.GRENADIER: setFace(FLESH,NORMAL,TOOTHPICK,[null,SHADES]); break;
				case SkillData.IRON: setFace(FLESH,1,1); break;
				case SkillData.SWIFT: setFace(FLESH,1,1); break;
				case SkillData.PEASANT: setFace(FLESH,NORMAL,NORMAL,[null,WIZARD]); break;
				case SkillData.DABBLER: setFace(FLESH,1,1); break;
				case SkillData.WEAVER: setFace(FLESH,1,1); break;
				case SkillData.SAVIOR: setFace(FLESH,JOCULAR,OVERSMILE,[PAINTED]); break;
			}
		}
		
		public function faceFromEnemy(s:String){
			switch(s){
				case EnemyData.FIGHTER: setFace(GREEN,SPIKED,ORC,[1+Math.floor(Math.random()*6)]); break;
				case EnemyData.SHAMAN: setFace(GREEN,SPIKED,ORC,[1+Math.floor(Math.random()*6)]); break;
				case EnemyData.BRUTE: setFace(GREEN,MEAN,ORC,[TATTOO_SMALL,1+Math.floor(Math.random()*6)]); break;
				case EnemyData.CHIEF: setFace(GREEN,SPIKED,VAMPIRE,[TATTOOS]); break;
				case EnemyData.ALCHEMIST: setFace(GREEN,GIRL,GOBLIN_LIPS,[ROSY]); break;
				case EnemyData.SKELETON: setFace(SKULL,HOLES,SKULL_TEETH); break;
				case EnemyData.GOLEM: setFace(STONE,LIFELESS,WEDGE); break;
				case EnemyData.GOATMAN: setFace(FUR,SQUINT,NORMAL,[GOATEE2]); break;
				case EnemyData.CATMAN: setFace(FUR,NORMAL,CAT_MOUTH,[CAT_EARS]); break;
			}
		}
		
		public function setFace(_body:int,_eyes:int,_mouth:int,_extras:Array=null,_relic:int=-1,_relicFilter:int=-1){
			if (_body>0) body.gotoAndStop(_body);
			if (_eyes>0){
				defaultEyes=_eyes;
				eyes.gotoAndStop(_eyes);
			}
			if (_mouth>0){
				defaultMouth=_mouth;
				mouth.gotoAndStop(_mouth);
			}
			if (_extras==null){
				for (i=0;i<extras.length;i+=1){
					if (extras[i]!=null) removeChild(extras[i]);
					extras[i]=null;
				}
			}else{
				for (var i:int=0;i<extras.length;i+=1){
					if (_extras[i]==null){
						if (extras[i]!=null) removeChild(extras[i]);
						extras[i]=null;
					}else if (_extras[i]>-1){
						if (extras[i]!=null) removeChild(extras[i]);
						extras[i]=new SpriteExtra;
						extras[i].gotoAndStop(_extras[i]);
						addChild(extras[i]);
					}
				}
			}
			if (_relic>0){
				relic=new VisualRelic;
				relic.gotoAndStop(_relic);
				var _filter:*=FilterData.getRelicFilter(_relic,_relicFilter);
				if (_filter==null){
					relic.filters=[];
				}else{
					relic.filters=[_filter];
				}
				addChild(relic);
			}else if (relic!=null){
				if (contains(relic)) removeChild(relic);
				relic=null;
			}
			sortLayers();
			
			if (body.currentFrame>=10 && body.currentFrame<=12){
				var glowFilter:GlowFilter=new GlowFilter(0xffffff,1,2,2,.4);
				eyes.filters=[glowFilter];
				mouth.filters=[glowFilter];
			}else{
				eyes.filters=[];
				mouth.filters=[];
			}
		}
		
		public function setExpression(_eyes:int=-1,_mouth:int=-1){
			if (_eyes==-1){
				_eyes=defaultEyes;
			}
			if (_mouth==-1){
				_mouth=defaultMouth;
			}
			eyes.gotoAndStop(_eyes);
			mouth.gotoAndStop(_mouth);
		}
		
		function sortLayers(){
			if (extraHelmets[1]!=null){
				setChildIndex(extraHelmets[1],0);
			}
			if (extras[0]!=null){
				if (extras[0].currentFrame==QUIVER){
					addChildAt(extras[0],0);
				}else{
					addChild(extras[0]);
				}
			}
			addChild(eyes);
			addChild(mouth);
			if (extras[1]!=null){
				if (extras[1].currentFrame==QUIVER){
					addChildAt(extras[1],0);
				}else{
					addChild(extras[1]);
				}
			}
			if (extraHelmets[0]!=null){
				addChild(extraHelmets[0]);
			}
			if (extras[2]!=null){
				if (extras[2].currentFrame==QUIVER){
					addChildAt(extras[2],0);
				}else{
					addChild(extras[2]);
				}
			}
			if (relic!=null){
				addChild(relic);
			}
		}
	}
}
