package{
	import items.ItemData;
	import fl.motion.AdjustColor;
	import items.ItemModel;
	import system.buffs.BuffData;
	import system.actions.ActionBase;
	import system.actions.ActionData;
	import system.effects.EffectBase;
	import system.effects.EffectData;
	import system.effects.EffectBuffBasic;
	
	public class EnemyData{
		public static const WARLOCK:String="Warlock",
							WSHAMAN:String="Warlock Shaman",
							GRUNTLING:String="Gruntling",
							FLOATER:String="Floater",
							SKULTOPUS:String="Skultopus",
		
							FIGHTER:String="Goblin Fighter",
							SHAMAN:String="Goblin Shaman",
							ALCHEMIST:String="Goblin Alchemist",
							BRUTE:String="Goblin Brute",
							TREE:String="Stumpling",
							VINE:String="Vine",
							BLOB:String="Blob",
							CHIEF:String="Goblin Chief",
							
							DRAGON:String="Dragon",
							RHINO:String="Uniceratops",
							TIGER:String="Tiger",
							WHELP:String="Whelp",
							WOLF:String="Wolf",
							BOAR:String="Mega Boar",
							
							GOATMAN:String="Goat Man",
							CATMAN:String="Cat Man",
							GUARDIAN:String="Guardian",
							BIRDMAN:String="Bird Man",
							//RHINO:String="Rhino",
							
							IMP:String="Imp",
							HELLING:String="Helling",
							GOLEM:String="Golem",
							FLAMBERT:String="Flambert",
							SKELETON:String="Skeleton",
							BEEZELPUFF:String="Beezelpuff";
												
		public static const TITLES:Array=[
			["Forest","Mountain","Cave"],
			["Wild","Savage","Dire"],
			["Hellish","Plasmic","Spectral"]];
		
		public static const NAMES:Array=[FIGHTER,BRUTE,SHAMAN,ALCHEMIST,VINE,BLOB,DRAGON,RHINO,TIGER,WHELP,WOLF,IMP,HELLING,GOLEM,FLAMBERT,SKELETON];
		public static const SHADOW:Array=[
			["Shadow Knight",25,11,[5,5,5,5,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[[1,2,0,-2,0],[12,2,0,-2,0],[25,2,0,-1,0],null,null,[31,2,6,-1,0],[31,2,6,-1,0]]],
			["Shadow Mage",50,5,[0,0,10,0,0,0,0,0,0,6,10,10,10,4,0,0,0,0,0,0,0,0,0,0,0,0],
			[[2,5,0,-2,0],[10,5,0,-2,0],[30,5,0,-1,0],[27,5,0,-1,0],null,[31,5,6,-1,0],[32,5,6,-1,0],[40,5,0,13,0],[40,5,0,23,0]]],
			["Shadow Mage",50,5,[0,0,10,0,0,0,0,0,0,6,10,10,10,4,0,0,0,0,0,0,0,0,0,0,0,0],
			[[2,5,0,-2,0],[10,5,0,-2,0],[30,5,0,-1,0],[26,5,0,-1,0],null,[31,5,6,-1,0],[32,5,6,-1,0],[40,5,0,13,0],[40,5,0,23,0]]],
			["Shadow King",100,10,[10,10,10,10,10,10,0,0,0,0,10,10,10,10,0,0,0,0,0,0,0,0,0,0,3,0],
			[[82,10,0,-2,0],[70,15,0,-2,0],[25,10,0,-1,0],[30,10,0,-1,0],null,[31,10,6,-1,0],[35,10,6,-1,1],[40,10,0,12,0],[40,10,0,16,0],[40,10,0,31,0]]],
			["Shadow Rogue",10,8,[1,1,1,1,2,0,0,0,0,0,0,0,0,0,0,0,0,1,1,7,0,0,0,0,0],
			[[5,2,-1,-1,0],[11,2,-1,-1,0],null,null,null,[31,2,3,-1,0],[39,2,25,-1,0],null,null,null]],
			["Shadow Hunter",60,0,[10,10,10,10,10,0,0,0,0,0,10,10,10,10,10,0,0,0,0,0,0,0,0,0,0],
			[[83,15,-1,-1,0],[91,15,-1,-1,0],[15,15,-1,-1,0],null,null,[31,15,6,-1,0],[98,15,6,-1,0],[40,15,-1,30,0]]],
			["Shadow Guard",5,11,[5,5,5,5,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[[1,2,0,-2,0],[12,2,0,-2,0],[25,2,0,-1,0],null,null,[31,2,6,-1,0],[31,2,6,-1,0]]],
			["Shadow Craftsman",100,17,[10,0,10,10,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,10,0,10,10,0,0,0,0,0,0],
			[[79,15,-1,1],[71,15,-1,0],[25,15,-1,1],null,null,[31,15,6,-1],[113,15,-1,-1],[97,15,-1,-1],[40,15,-1,31],[40,15,-1,31]]],
			["Shadow Master",100,0, [0,0,0,10,0,0,0,0,0,0,10,10,10,10,0,0,0,0,0,0,0,0,0,0,0,10,10,0,0,10,0,0,0,0,0,0,0,0,10,0],
			[[108,15,-1,[0,84]],[117,15,-1,[0,117]],[18,15,-1,1],[30,15,-1,-1],null,[31,15,6,-1],[32,15,6,-1],[113,15,-1,[-1,121]],[40,15,-1,30],[40,15,-1,30]]],
			["Shadow #8",150,0, [10,10,10,10,10,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,10,10,0,10,0,0,10,0,0,0,10,0,10,0,0,0,0,0,0,0,0,0,0,0,0],
			 [[79,20,-1,[-1,105]],[88,20,-1,[-1,121]],[20,20,-1,[-1,39]],null,null,[31,20,6,[1,67]],[31,20,6,[1,67]],[143,20,-1,[-1,124]],[40,20,-1,[30,81]],[40,20,-1,[31,81]]]],
			 ];
			 
		static var slot:int;
		static var spawn:SpriteModel;
		
		
		public static function newBoss(_spawn:SpriteModel,_level:int=-1,_zone:int=-1,_eType:int=-1,_aType:int=-1){
			if (_level==-1) _level=Facade.gameM.area;
			if (_zone==-1) _zone=Facade.gameM.area;
			if (_eType==-1) _eType=Facade.gameM.enemyType;
			if (_aType==-1) _aType=Facade.gameM.areaType;
			
			spawn=_spawn;
			spawn.newMonster();
			slot=2;
			switch(_eType){
				case 0:
					spawn.label=CHIEF;
					setBaseStats(_level,4,4,5,4,5,4,true);
					//equipAction(ActionData.LEAP);
					equipEffect(EffectData.LEAP_ATTACK);
					equipAction(ActionData.BASH);
					break;
				case 1:
					spawn.label=BOAR;
					setBaseStats(_level,4,4,3,3,3,2,true);
					var _temp:Number=Facade.diminish(0.05,spawn.level/10);
					if (_temp>0.5) _temp=0.5;
					spawn.stats.addValue(StatModel.STRENGTH,0.5*spawn.level);
					spawn.stats.addValue(StatModel.DODGE,_temp);
					spawn.actionList.attack.critrate=0.05+0.35*Facade.diminish(0.1,spawn.level/10);
					spawn.actionList.attack.critmult=3;
					equipAction(ActionData.SPINES);
					break;
				case 2:
					spawn.label=BEEZELPUFF;
					setBaseStats(_level,2,3,3,3,3,2,true);
					spawn.stats.addValue(StatModel.MPOWER,0.4*spawn.level);
					spawn.stats.addValue(StatModel.MANA,spawn.level);
					spawn.stats.addValue(StatModel.MRATE,0.15);
					_temp=Facade.diminish(0.05,spawn.level/10)*0.5;
					if (_temp>0.25) _temp=0.25;
					spawn.stats.addValue(StatModel.TURN,_temp);
					spawn.stats.addValue(StatModel.RALL,_temp);
					attackType(ActionBase.DARK);
					spawn.actionList.attack.effects.push(new EffectBuffBasic(BuffData.makeBuff(BuffData.BLIND,spawn.level/10)));
					equipItem(30); //Dark Burst
					equipItem(29); //Terrify
					break;
				case 3:
					if (_zone==0){
						if (_level==_zone){
							Facade.saveC.loadShort(spawn,SHADOW[6],-1);
						}else{
							Facade.saveC.loadShort(spawn,Facade.saveC.levelUpArray(SHADOW[6],_level/50),-1);
						}
					}else if (_zone<25){
						if (_level==_zone){
							Facade.saveC.loadShort(spawn,SHADOW[4],-1);
						}else{
							Facade.saveC.loadShort(spawn,Facade.saveC.levelUpArray(SHADOW[4],_level/50),-1);
						}
					}else if (_zone<50){
						if (_level==_zone){
							Facade.saveC.loadShort(spawn,SHADOW[0],-1);
						}else{
							Facade.saveC.loadShort(spawn,Facade.saveC.levelUpArray(SHADOW[0],_level/50),-1);
						}
					}else if (_zone<99){
						Facade.saveC.loadShort(spawn,Facade.gameM.playerM.isMelee()?SHADOW[1]:SHADOW[2],-1);
						if (_level==_zone){
							Facade.saveC.loadShort(spawn,Facade.gameM.playerM.isMelee()?SHADOW[1]:SHADOW[2],-1);
						}else{
							Facade.saveC.loadShort(spawn,Facade.saveC.levelUpArray(Facade.gameM.playerM.isMelee()?SHADOW[1]:SHADOW[2],_level/50),-1);
						}
					}else if (_zone<200){
						if (_level==_zone){
							Facade.saveC.loadShort(spawn,SHADOW[3],-1);
						}else{
							Facade.saveC.loadShort(spawn,Facade.saveC.levelUpArray(SHADOW[3],_level/50),-1);
						}
					}else if (_zone<300){
						if (_level==_zone){
							Facade.saveC.loadShort(spawn,SHADOW[5],-1);
						}else{
							Facade.saveC.loadShort(spawn,Facade.saveC.levelUpArray(SHADOW[5],_level/50),-1);
						}
					}else if (_zone<400){
						if (_level==_zone){
							Facade.saveC.loadShort(spawn,SHADOW[7],-1);
						}else{
							Facade.saveC.loadShort(spawn,Facade.saveC.levelUpArray(SHADOW[7],_level/50),-1);
						}
					}else if (_zone<1000){
						if (_level==_zone){
							Facade.saveC.loadShort(spawn,SHADOW[8],-1);
						}else{
							Facade.saveC.loadShort(spawn,Facade.saveC.levelUpArray(SHADOW[8],_level/50),-1);
						}
					}else if (_zone<2000){
						if (_level==_zone){
							Facade.saveC.loadShort(spawn,SHADOW[9],-1);
						}else{
							Facade.saveC.loadShort(spawn,Facade.saveC.levelUpArray(SHADOW[9],_level/50),-1);
						}
					}
					
					spawn.view.recolor([],true);
					return;
				default:
					throw(new Error("Unidentified Boss Type"));
			}
			spawn.view.newMonster(spawn.label);
			spawn.view.recolor(getColorFilter(spawn.label,_aType),_aType==3);
			spawn.maxHM();
		}

		public static function newCreature(_spawn:SpriteModel,_level:int=-1,_eType:int=-1,_mType:int=-1,_aType:int=-1){
			var _temp:Number;
			//temp for testing:
			//_eType=2;
			//_mType=2;
			/*if (Math.random()<0.5){
				_eType=0;
				_mType=4;
			}else{
				_eType=2;
				_mType=0;
			}*/
			//----
			if (_level==-1) _level=Facade.gameM.area;
			if (_eType==-1 || _eType==3){
				if (Facade.gameM.enemyType>2){
					_eType=Math.floor(Math.random()*3);
				}else{
					_eType=Facade.gameM.enemyType;
				}
			}
			if (_aType==-1 || _aType==3) _aType=Facade.gameM.areaType;
			
			spawn=_spawn;
			spawn.newMonster();
			slot=2;
			spawn.title=TITLES[_eType][_aType];
			switch(_eType){
				case 0:
					if (_mType==-1) _mType=Math.floor(Math.random()*6);
					switch (_mType){
						case 0:
							spawn.label=FIGHTER;
							setBaseStats(_level,2,4,5,3,3,3);
							
							switch(_aType){
								case 0: spawn.stats.addValue(StatModel.STRENGTH,_level); break;
								case 1: spawn.stats.addValue(StatModel.HEALTH,3*_level); break;
								case 2: spawn.stats.addValue(StatModel.BLOCK,Math.min(_level,250)); break;
							}
							break;
						case 1:
							spawn.label=BRUTE;
							setBaseStats(_level,1,3,3,4,5,1);
							switch(_aType){
								case 0: equipItem(25); break;
								case 1: equipItem(24); break;
								case 2: equipItem(26); break;
							}
							break;
						case 2:
							spawn.label=SHAMAN;
							setBaseStats(_level,2,2,2,1,2,2);
							switch(_aType){
								case 0:
									attackType(ActionBase.MAGICAL);
									equipItem(125);
									equipItem(19);
									break;
								case 1:
									attackType(ActionBase.MAGICAL);
									equipItem(15);
									equipItem(21);
									break;
								case 2:
									attackType(ActionBase.DARK);
									equipItem(30);
									equipItem(20);
									break;
							}
							break;
						case 3:
							spawn.label=ALCHEMIST;
							setBaseStats(_level,3,2,4,2,2,2);
							attackType(ActionBase.CHEMICAL);
							switch(_aType){
								case 0: equipItem(34); equipAction(ActionData.WITHDRAW); break;
								case 1: equipItem(34); spawn.stats.addValue(StatModel.THROWEFF,_level/100); break;
								case 2: equipItem(35); spawn.stats.addValue(StatModel.HEALTH,3*_level); break;
							}
							break;
						case 4:
							spawn.label=VINE;
							setBaseStats(_level,4,4,2,4,3,1);
							spawn.actionList.attack.leech+=0.05;
							switch(_aType){
								case 0: spawn.actionList.attack.critrate+=0.05; break;
								case 1: spawn.actionList.attack.leech+=0.05; break;
								case 2: spawn.actionList.attack.critmult+=1; break;
							}
							break;
						case 5:
							spawn.label=BLOB;
							setBaseStats(_level,2,6,2,3,1,1);
							attackType(ActionBase.CHEMICAL);
							spawn.stats.addValue(StatModel.DODGE,0.1);
							spawn.stats.addValue(StatModel.RCHEMICAL,0.4);
							break;
						default: null;
					}
					_temp=0.04+0.001*_level;
					if (_temp>0.25) _temp=0.25;
					spawn.stats.addValue(StatModel.DODGE,_temp);
					switch(_aType){
						case 0: spawn.actionList.attack.critrate+=0.05; break;
						case 1: spawn.stats.addValue(StatModel.HEALTH,3*_level); break;
						case 2: spawn.stats.addValue(StatModel.STRENGTH,2*_level); break;
					}
					break;
				case 1:
					if (_mType==-1) _mType=Math.floor(Math.random()*5);
					switch (_mType){
						case 0:
							spawn.label=BIRDMAN;
							setBaseStats(_level,3,2,2,4,3,2);
							switch(_aType){
								case 0:
									attackType(ActionBase.MAGICAL);
									equipItem(15);
									break;
								case 1:
									attackType(ActionBase.CHEMICAL);
									equipItem(18);
									break;
								case 2:
									attackType(ActionBase.DARK);
									equipItem(30);
									break;
							}
							break;
						case 1:
							spawn.label=RHINO;
							setBaseStats(_level,1,3,4,3,4,4);
							switch(_aType){
								case 0: equipItem(26); break;
								case 1: spawn.stats.addValue(StatModel.HEALTH,3*_level); break;
								case 2: spawn.stats.addValue(StatModel.RCRIT,0.2); break;
							}
							break;
						case 2:
							spawn.label=CATMAN;
							setBaseStats(_level,5,3,3,2,3,2);
							equipItem(37);
							switch(_aType){
								case 0: spawn.stats.addValue(StatModel.DODGE,0.1); break;
								case 1: spawn.stats.addValue(StatModel.STRENGTH,_level); break;
								case 2: spawn.actionList.attack.critrate+=0.1; break;
							}
							break;
						case 3:
							spawn.label=GUARDIAN;
							setBaseStats(_level,6,4,3,4,2,1);
							spawn.stats.addValue(StatModel.RALL,0.1);
							switch(_aType){
								case 0: equipCharm(7); spawn.stats.addValue(StatModel.RMAGICAL,0.15); break;
								case 1: equipCharm(9); spawn.stats.addValue(StatModel.RCHEMICAL,0.15); break;
								case 2: equipCharm(100); spawn.stats.addValue(StatModel.RSPIRIT,0.15); break;
							}
							break;
						case 4:
							spawn.label=GOATMAN;
							setBaseStats(_level,3,3,3,4,3,2);
							switch(_aType){
								case 0: equipItem(27); equipCharm(22); break;
								case 1: equipItem(25); equipCharm(23); break;
								case 2: equipItem(20); equipCharm(25); break;
							}
							break;
						default: null;
					}
					spawn.stats.addValue(StatModel.RMAGICAL,0.1);
					spawn.stats.addValue(StatModel.RSPIRIT,0.1);
					switch(_aType){
						case 0: spawn.stats.addValue(StatModel.INITIATIVE,25); break;
						case 1: spawn.stats.addValue(StatModel.STRENGTH,2*_level); break;
						case 2: spawn.actionList.attack.critmult+=0.5; break;
					}
					break;
				case 2:
					if (_mType==-1) _mType=Math.floor(Math.random()*5)
					switch (_mType){
						case 0:
							spawn.label=IMP;
							setBaseStats(_level,3,2,2,3,3,2);
							equipAction(ActionData.WITHDRAW);
							switch(_aType){
								case 0: equipItem(16); equipItem(21); break;
								case 1: equipItem(14); equipItem(18); break;
								case 2: equipItem(30); equipItem(19); break;
							}
							break;
						case 1:
							spawn.label=HELLING;
							setBaseStats(_level,4,4,2,4,3,1);
							equipCharm(27);
							attackType(ActionBase.CHEMICAL);
							switch(_aType){
								case 0: spawn.stats.addValue(StatModel.DODGE,0.05); break;
								case 1: spawn.actionList.attack.effects.push(EffectData.makeEffect(EffectData.QUICK,Math.floor(_level/10))); break;
								case 2: spawn.stats.addValue(StatModel.STRENGTH,_level); break;
							}
							break;
						case 2:
							spawn.label=GOLEM;
							setBaseStats(_level,0,3,3,5,4,4);
							spawn.stats.addValue(StatModel.RMAGICAL,0.2);
							spawn.stats.addValue(StatModel.RSPIRIT,0.2);
							spawn.actionList.attack.critrate+=0.2;
							spawn.actionList.attack.critmult+=2.5;
							equipAction(ActionData.CONFUSED);
							break;
						case 3:
							spawn.label=FLAMBERT;
							setBaseStats(_level,5,4,2,3,2,0);
							spawn.stats.addValue(StatModel.RSPIRIT,0.2);
							//equipAction(ActionData.LEAP);
							equipEffect(EffectData.LEAP_ATTACK);
							switch(_aType){
								case 0: attackType(ActionBase.MAGICAL); equipItem(26); break;
								case 1: attackType(ActionBase.MAGICAL); equipItem(15); break;
								case 2: attackType(ActionBase.DARK); equipItem(29); break;
							}
							break;
						case 4:
							spawn.label=SKELETON;
							setBaseStats(_level,2,3,5,3,3,4);
							spawn.stats.addValue(StatModel.RCRIT,0.1);
							spawn.stats.addValue(StatModel.RCHEMICAL,0.6);
							spawn.stats.addValue(StatModel.RMAGICAL,0.2);
							spawn.stats.subValue(StatModel.RSPIRIT,0.2);
							break;
					}
					_temp=0.04+0.0005*_level;
					if (_temp>0.25) _temp=0.25;
					spawn.stats.addValue(StatModel.TURN,_temp);
					switch(_aType){
						case 0: equipCharm(10); break;
						case 1: equipCharm(9); break;
						case 2: equipCharm(100); break;
					}
					break;
					
			}
			spawn.view.newMonster(spawn.label);
			spawn.view.recolor(getColorFilter(spawn.label,_aType),_aType==3);
			spawn.maxHM();
		}
		
		static function setBaseStats(_level:int,_init:int=-1,_hit:int=-1,_block:int=-1,_attack:int=-1,_defense:int=-1,_rCrit:int=-1,_boss:Boolean=false){
			spawn.level=_level;
			
			//_degree goes from 0 (slowest) to 6 (fastest)
			spawn.stats.setBase(_level,_init,_block,_attack,_defense,_rCrit,_boss);
			
			var _mult:Number=(_level/200)*0.75+0.25;
			if (_mult>1) _mult=1;
			
			var _base:Number;
			if (_attack>-1){
				equipWeapon(_attack);
			}
			if (_hit>-1){
				switch (_hit){
					case 0: _base=0; break;
					case 1: _base=50; break;
					case 2: _base=100; break;
					case 3: _base=200; break;
					case 4: _base=300; break;
					case 5: _base=400; break;
					case 6: _base=750; break;
				}
				spawn.actionList.attack.hitrate=_base*_mult;
				
				spawn.actionList.attack.critrate=0.05;
				spawn.actionList.attack.critmult=2;
			}
		}

		static function makeWeapon(_level:int,_tier:int):ItemModel{
			var _damage:Number;
			var _double:Boolean=false;
			switch(_tier){
				case 0: _damage=0; break;
				case 1: _damage=20+1.5*_level; break;
				case 2: _damage=15+1*_level; _double=true; break;
				case 3: _damage=26+1.7*_level; break;
				case 4: _damage=30+1.9*_level; break;
				case 5: _damage=35+2.3*_level; break;
				case 6: _damage=40+3.5*_level; break;
			}
			return new ItemModel(-2,"Weapon",0,ItemData.EQUIPMENT,ItemData.WEAPON,(_double?ItemData.DOUBLE:ItemData.TWO_HANDED),0,ActionData.makeWeapon(_damage));
		}
		
		static function equipWeapon(_tier:int){
			var _level:int=diminishLevel(spawn.level);
			
			var _item:ItemModel=makeWeapon(_level,_tier);
			
			spawn.equipment[0]=_item;
			spawn.statAdd(_item.values);
			spawn.actionList.addAction(_item.action);
		}
				
		static function equipItem(i:int){
			var _level:int=diminishLevel(spawn.level);
			
			spawn.equipment[slot]=ItemData.spawnItem(Math.floor(_level),i);
			
			spawn.statAdd(spawn.equipment[slot].values);
			if (spawn.equipment[slot].action!=null) spawn.actionList.addAction(spawn.equipment[slot].action);
			slot+=1;
		}
		
		static function equipCharm(i:int){
			var _level:int=diminishLevel(spawn.level);
			
			spawn.equipment[slot]=ItemData.enchantItem(ItemData.spawnItem(Math.floor(_level),40),i);
			spawn.statAdd(spawn.equipment[slot].values);
			slot+=1;
		}
		
		static function equipEffect(effect:String){
			var _level:int=diminishLevel(spawn.level);
			if (_level>20) _level=20;
			
			var _effect:EffectBase=EffectData.makeEffect(effect,_level);
			spawn.actionList.attack.addValue(ActionBase.EFFECT,_effect);
		}
		
		static function equipAction(action:String){
			var _level:int=diminishLevel(spawn.level);
			if (_level>20) _level=20;
			
			if (action==ActionData.CONFUSED){
				spawn.buffList.addBuff(BuffData.makeBuff(BuffData.GOLEM_CONFUSED,_level));
				return;
			}
			var _action:ActionBase=ActionData.makeAction(action,_level);
			
			if (action==ActionData.BASH){
				_action.addSource(spawn.equipment[0]);
			}
			spawn.actionList.addAction(_action);
		}
		
		static function attackType(_type:int){
			spawn.actionList.attack.type=_type;
		}
		
		static function diminishLevel(_level:int):int{
			if (_level>=1000) return 32;
			if (_level<100) return _level/10;
			return Math.sqrt(_level);
		}
		
		static function getColorFilter(_type:String,_area:int):Array{
			if (_area>=3){
				return [];
			}
			var _array:Array=[0,0,0,0]; //BCSH
			switch(_type){
				case CHIEF: case FIGHTER: case BRUTE: case SHAMAN: case ALCHEMIST:
					switch(_area){
						case 0: break;
						case 1: _array=[50,0,-25,70]; break;
						case 2: _array=[40,0,-20,-110]; break;
					}
					break;
				case VINE:
					switch(_area){
						case 0: break;
						case 1: _array=[50,-50,0,90]; break;
						case 2: _array=[0,0,10,-100]; break;
					}
					break;
				case BLOB:
					switch(_area){
						case 0: _array=[0,0,-20,-90]; break;
						case 1: break;
						case 2: _array=[0,0,20,-180]; break;
					}
					break;
				case SKELETON:
					switch(_area){
						case 0: _array=[0,0,0,73]; break;
						case 1: _array=[0,0,0,144]; break;
						case 2: _array=[0,0,10,-52]; break;
					}
					break;
				case IMP:
					switch(_area){
						case 0: _array=[10,0,-20,-70]; break;
						case 1: break;
						case 2: _array=[0,0,0,150]; break;
					}
					break;
				case BIRDMAN:
					switch(_area){
						case 0: _array=[10,0,-20,-70]; break;
						case 1: break;
						case 2: _array=[0,0,0,150]; break;
					}
					break;
				case HELLING:
					switch(_area){
						case 0: _array=[40,-40,-30,60]; break;
						case 1: _array=[30,0,-20,150]; break;
						case 2: break;
					}
					break;
				case RHINO:
					switch(_area){
						case 0: _array=[0,0,-60,-90]; break;
						case 1: _array=[30,30,0,0]; break;
						case 2: _array=[0,0,60,110]; break;
					}
					break;
				case BOAR:
					switch(_area){
						case 0: break;
						case 1: _array=[90,0,6,-164]; break;
						case 2: _array=[0,0,40,-30]; break;
					}
					break;
				case GOLEM:
					switch(_area){
						case 0: break;
						case 1: _array=[0,0,0,-37]; break;
						case 2: _array=[30,0,-20,180]; break;
					}
					break;
				case FLAMBERT:
					switch(_area){
						case 0: _array=[50,0,-30,60]; break;
						case 1: _array=[50,0,0,-180]; break;
						case 2: break;
					}
					break;
				case GUARDIAN:
					switch(_area){
						case 0: _array=[-20,0,60,110]; break;
						case 1: _array=[0,0,70,-170]; break;
						case 2: _array=[-10,0,84,20]; break;
					}
					break;
				case GOATMAN:
					switch(_area){
						case 0: break;
						case 1: _array=[40,0,30,-180]; break;
						case 2: _array=[30,0,20,-20]; break;
					}
					break;
				case CATMAN:
					switch(_area){
						case 0: break;
						case 1: _array=[40,0,30,-180]; break;
						case 2: _array=[30,0,20,-20]; break;
					}
					break;
				case BEEZELPUFF:
					switch(_area){
						case 0: _array=[10,-20,-20,54]; break;
						case 1: _array=[20,0,-30,-180]; break;
						case 2: break;
					}
					break;
				default: return null;
			}			
			var _adjust:AdjustColor=new AdjustColor();
			_adjust.brightness=_array[0];
			_adjust.contrast=_array[1];
			_adjust.saturation=_array[2];
			_adjust.hue=_array[3];
			return _adjust.CalculateFinalFlatArray();
		}
	}
}