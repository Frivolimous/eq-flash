package system.actions.conditionals {
	import ui.assets.ComboButton;
	import system.buffs.BuffBase;
	import system.actions.ActionPriorities;
	import system.actions.ActionBase;
	
	public class ConditionalBase {
		public static const ENEMY_TYPE:String="E Type",
								GENERAL:String="General",
									BOSS:String="Boss",
									MINION:String="Mobs",
								CLASS:String="Class",
									WARRIOR:String="Warrior",
									MAGE:String="Mage",
									MONK:String="Monk",
									RANGER:String="Ranger",
									ALCHEMIST:String="Alchemist",
									ACOLYTE:String="Acolyte",
									PALADIN:String="Paladin",
								GOBLIN:String="Goblin",
									G_FIGHTER:String="Fighter",
									G_SHAMAN:String="Shaman",
									
							PLAYER_PROPERTY:String="my.Prop",
								HEALTH:String="Health",
									PERCENT_100:String="75-100%",
									PERCENT_75:String="50-75%",
									PERCENT_50:String="25-50%",
									PERCENT_25:String="10-25%",
									PERCENT_10:String="<10%",
								MANA:String="Mana",
									//Percents
								NUM_BUFFS:String="# Buffs",
									NUM_0:String="0",
									NUM_1:String="1",
									NUM_2:String="2",
									NUM_5:String="3-5",
									NUM_10:String="6-10",
									NUM_20:String="11-20",
									NUM_100:String="21-100",
									NUM_200:String="101-200",
								NUM_CURSES:String="# Curses",
									//Nums
								HAS_BUFF:String="Buff",
									EMPOWERED:String="Empow",
									HASTENED:String="Haste",
									ENCHANTED:String="Enchant",
							ENEMY_PROPERTY:String="E.Prop",
								//Health, Mana, etc.
							GLOBAL_PROPERTY:String="Global",
								TURN_COUNT:String="Turns",
									NO_ENEMY:String="No Enemy",
									NUM_200B:String="20-200",
									PRE_COMBAT:String="Pre-fight",
								DISTANCE:String="Range",
									NEAR:String="Near",
									FAR:String="Far",
									VERY:String="Long",
									BETWEEN:String="Safe";
									
		public static const PERCENT_LIST:Array=[PERCENT_100,PERCENT_75,PERCENT_50,PERCENT_25,PERCENT_10],
							NUM_LIST:Array=[NUM_0,NUM_1,NUM_2,NUM_5,NUM_10,NUM_20,NUM_100,NUM_200],
							BUFF_LIST:Array=[EMPOWERED,HASTENED,ENCHANTED],
							TURNS_LIST:Array=[NO_ENEMY,PRE_COMBAT,NUM_1,NUM_2,NUM_5,NUM_10,NUM_20,NUM_200B],
							DISTANCE_LIST:Array=[BETWEEN,VERY,FAR,NEAR];
		
		public static const MASTER_LIST:Array=[[ENEMY_TYPE,[[GENERAL,[BOSS,MINION]],[CLASS,[WARRIOR,MAGE,MONK,RANGER,ALCHEMIST,ACOLYTE,PALADIN]],[GOBLIN,[G_FIGHTER,G_SHAMAN]]]],
											   [PLAYER_PROPERTY,[[HEALTH,PERCENT_LIST],[MANA,PERCENT_LIST],[NUM_BUFFS,NUM_LIST],[NUM_CURSES,NUM_LIST],[HAS_BUFF,BUFF_LIST]]],
											   [ENEMY_PROPERTY,[[HEALTH,PERCENT_LIST],[MANA,PERCENT_LIST],[NUM_BUFFS,NUM_LIST],[NUM_CURSES,NUM_LIST],[HAS_BUFF,BUFF_LIST]]],
											   [GLOBAL_PROPERTY,[[TURN_COUNT,TURNS_LIST],[DISTANCE,DISTANCE_LIST]]]];
											   
		public var category:int,
					sub:int,
					selections:Array;
		
		public function ConditionalBase(_category:int=-1,_sub:int=-1,_selections:Array=null) {
			category=_category;
			sub=_sub;
			if (_selections==null){
				selections=[];
			}else{
				selections=_selections;
			}
		}
		
		public var basePriorityList:int;
		var veryFar:Boolean=false;
		//var baseNear:Boolean=false;
		public function setBaseDistance(i:int,b:Boolean){
			basePriorityList=i;
			veryFar=b;
			var _list=getFilteredDistanceList();
			selections=[];
			for (var i:int=0;i<_list.length;i+=1){
				selections.push(i);
			}
		}
		
		/*public function addLeap(b:Boolean){
			if (b){
				if (basePriorityList==ActionPriorities.NEAR){
					baseNear=true;
					basePriorityList=ActionPriorities.COMBAT;
					for (i=0;i<selections.length;i+=1){
						if (selections[i]==2) return;
					}
					selections.push(2);
				}
			}else{
				if (baseNear){
					basePriorityList=ActionPriorities.NEAR;
					for (var i:int=0;i<selections.length;i+=1){
						if (selections[i]==2){
							selections.splice(i,1);
							return;
						}
					}
				}
			}
		}*/
		
		public function getFilteredDistanceList(i:int=-1):Array{
			if (i==-1) i=basePriorityList;
			switch(i){
				case ActionPriorities.ALL_DISTANCE: var m:Array=[BETWEEN,FAR,NEAR]; if (veryFar) m.splice(1,0,VERY); return m;
				case ActionPriorities.COMBAT: m=[FAR,NEAR]; if (veryFar) m.unshift(VERY); return m;
				case ActionPriorities.BETWEEN: return [BETWEEN];
				case ActionPriorities.VERY: return [VERY,FAR];
				case ActionPriorities.FAR: m=[FAR]; if (veryFar) m.unshift(VERY); return m;
				case ActionPriorities.NEAR: return [NEAR];
			}
			return [];
		}
		
		public function testCanDistance(_distance:String):Boolean{
			var _list:Array=getFilteredDistanceList();
			if (category==3 && sub==1){
				for (var i:int=0;i<_list.length;i+=1){
					switch(_distance){
						case GameModel.NEAR: if (_list[i]==NEAR) return true;
							break;
						case GameModel.FAR: if (_list[i]==FAR) return true;
							break;
						case GameModel.VERY: if (_list[i]==VERY) return true;
							break;
						case GameModel.BETWEEN: if (_list[i]==BETWEEN) return true;
							break;
					}
				}
			}
			return false;
		}
		
		public function testDistance(_distance:String):Boolean{
			var _list:Array=getFilteredDistanceList();
			if (category==3 && sub==1){
				for (var i:int=0;i<selections.length;i+=1){
					switch(_distance){
						case GameModel.NEAR: if (_list[selections[i]]==NEAR) return true;
							break;
						case GameModel.FAR: if (_list[selections[i]]==FAR) return true;
							break;
						case GameModel.VERY: if (_list[selections[i]]==VERY) return true;
							break;
						case GameModel.BETWEEN: if (_list[selections[i]]==BETWEEN) return true;
							break;
					}
				}
			}
			return false;
		}
		
		public function makeDistanceComboArray(_function:Function):Array{
			var m:Array=new Array;
			var _list:Array=getFilteredDistanceList();
			_Refresh=_function;
			for (var i:int=0;i<_list.length;i+=1){
				var _selected:Boolean=false;
				for (var j:int=0;j<selections.length;j+=1){
					if (selections[j]==i){
						_selected=true;
						break;
					}
				}
				var _color:uint=ActionPriorities.getColor(i);
				m.push(new ComboButton(_list[i],_color,toggleSelection,i,_selected));
				makeTooltipSelection(_list[i],m[m.length-1].setDesc);
			}
			return m;
		}
		
		public function getCurrentName():int{
			var _list:Array=getFilteredDistanceList();
			
			var _near:Boolean=false;
			var _far:Boolean=false;
			var _very:Boolean=false;
			var _safe:Boolean=false;
			for (var i:int=0;i<selections.length;i+=1){
				switch(_list[selections[i]]){
					case NEAR: _near=true; break;
					case FAR: _far=true; break;
					case VERY: _very=true; break;
					case BETWEEN: _safe=true; break;
				}
			}
			if (_near){
				if (_far || _very){
					if (_safe){
						return ActionPriorities.ALL_DISTANCE;
					}else{
						return ActionPriorities.COMBAT;
					}
				}else if (_safe){
					return ActionPriorities.NEAR;
				}else{
					return ActionPriorities.NEAR;
				}
			}else if (_far){
				if (_very){
					return ActionPriorities.FAR;
				}else if (_safe){
					return ActionPriorities.FAR;
				}else{
					return ActionPriorities.FAR;
				}
			}else if (_very){
				if (_safe){
					return ActionPriorities.VERY;
				}else{
					return ActionPriorities.VERY;
				}
			}else if (_safe){
				return ActionPriorities.BETWEEN;
			}else{
				return ActionPriorities.NEVER;
			}
		}
		
		public function goNextList(){
			var i:int=getCurrentName();
			while(true){
				i+=1;
				if (i>6) i=0;
				if (canHaveName(i)) break;
			}
			
			var _list:Array=getFilteredDistanceList();
			
			var _list2:Array=getFilteredDistanceList(i);
			
			selections=[];
			main:for (i=0;i<_list.length;i+=1){
				for (var j:int=0;j<_list2.length;j+=1){
					if (_list[i]==_list2[j]){
						selections.push(i);
						continue main;
					}
				}
			}
		}
		
		public function canHaveName(i:int):Boolean{
			if (basePriorityList==ActionPriorities.ALL_DISTANCE && (veryFar || i!=ActionPriorities.VERY)) return true;
			
			switch(i){
				case ActionPriorities.COMBAT: if (basePriorityList==ActionPriorities.COMBAT) return true;
				case ActionPriorities.ALL_DISTANCE: return false;
				case ActionPriorities.VERY:
					return false;
				case ActionPriorities.FAR: if (basePriorityList==ActionPriorities.COMBAT || basePriorityList==ActionPriorities.FAR || basePriorityList==ActionPriorities.VERY) return true;
					return false;
				case ActionPriorities.NEAR: if (basePriorityList==ActionPriorities.COMBAT || basePriorityList==ActionPriorities.NEAR) return true;
					return false;
				case ActionPriorities.BETWEEN: if (basePriorityList==ActionPriorities.BETWEEN) return true;
					return false;
				case ActionPriorities.NEVER: return true;
			}
			return false;
		}
		
		public function testThis(_o:SpriteModel,_t:SpriteModel,_action:ActionBase):Boolean{
			switch(MASTER_LIST[category][0]){
				case ENEMY_TYPE: return testEnemyType(_o,_t,_action);
				case PLAYER_PROPERTY: return testProperty(_o,_t,_action);
				case ENEMY_PROPERTY: return testProperty(_t,_o,_action);
				case GLOBAL_PROPERTY: return testGlobal(_o,_t,_action);
			}
			return true;
		}
		
		public function testEnemyType(_o:SpriteModel,_t:SpriteModel,_action:ActionBase):Boolean{
			var _selections:Array=getSelections(category,sub,true);
			switch(getSubs()[sub]){
				case GENERAL: return testEnemyTypeGeneral(_t,_selections);
				case CLASS: return testEnemyTypeClass(_t,_selections);
				case GOBLIN: return testEnemyTypeGoblin(_t,selections);
			}
			return true;
		}
		
		public function testProperty(_o:SpriteModel,_t:SpriteModel,_action:ActionBase):Boolean{
			var _selections:Array=getSelections(category,sub,true);
			switch(getSubs()[sub]){
				case HEALTH: return testNumberRange(_o.healthPercent(),_selections);
				case MANA: return testNumberRange(_o.manaPercent(),_selections);
				case NUM_BUFFS: return testNumBuffs(_o,_selections,BuffBase.BUFF);
				case NUM_CURSES: return testNumBuffs(_o,_selections,BuffBase.CURSE);
				case HAS_BUFF: return testHasBuff(_o,_selections);
			}
			return true;
		}
		
		public function testGlobal(_o,_t,_action):Boolean{
			var _selections:Array=getSelections(category,sub,true);
			switch(getSubs()[sub]){
				case TURN_COUNT: return testTurnCount(_selections,Facade.gameM);
			}
			return true;
		}
		
		public function testTurnCount(_selections:Array,_gameM:GameModel):Boolean{
			for (var i:int=0;i<_selections.length;i+=1){
				switch(_selections[i]){
					case NO_ENEMY: if (_gameM.distance==GameModel.BETWEEN && !_gameM.enemyM.exists) return true;
						break;
					case PRE_COMBAT: if (_gameM.distance==GameModel.BETWEEN && _gameM.enemyM.exists) return true;
						break; 
					case NUM_1: if (_gameM.distance!=GameModel.BETWEEN && _gameM.round<=1) return true;
						break;
					case NUM_2: if (_gameM.distance!=GameModel.BETWEEN && _gameM.round>1 && _gameM.round<=2) return true;
						break;
					case NUM_5: if (_gameM.distance!=GameModel.BETWEEN && _gameM.round>2 && _gameM.round<=5) return true;
						break;
					case NUM_10: if (_gameM.distance!=GameModel.BETWEEN && _gameM.round>5 && _gameM.round<=10) return true;
						break;
					case NUM_20: if (_gameM.distance!=GameModel.BETWEEN && _gameM.round>10 && _gameM.round<=20) return true;
						break;
					case NUM_200B: if (_gameM.distance!=GameModel.BETWEEN && _gameM.round>20) return true;
						break;
				}
			}
			return false;
		}
		
		public function testEnemyTypeGeneral(_o:SpriteModel,_selections:Array):Boolean{
			for (var i:int=0;i<_selections.length;i+=1){
				switch(_selections[i]){
					case BOSS: if (Facade.gameM.atBoss()) return true;
						break;
					case MINION: if (!Facade.gameM.atBoss()) return true;
						break;
				}
			}
			
			return false;
		}
		
		public function testEnemyTypeClass(_o:SpriteModel,_selections:Array):Boolean{
			
			return true;
		}
		
		public function testEnemyTypeGoblin(_o:SpriteModel,_selections:Array):Boolean{
			
			return true;
		}
		
		public function testNumberRange(n:Number,_selections:Array):Boolean{
			for (var i:int=0;i<_selections.length;i+=1){
				switch(_selections[i]){
					case PERCENT_100:
						if (testRange(n,0.75,1)) return true;
						break;
					case PERCENT_75: 
						if (testRange(n,0.50,0.75)) return true;
						break;
					case PERCENT_50:
						if (testRange(n,0.25,0.5)) return true;
						break;
					case PERCENT_25:
						if (testRange(n,0.1,0.25)) return true;
						break;
					case PERCENT_10:
						if (testRange(n,-1,0.1)) return true;
						break;
				}
			}
			return false;
		}
		
		public function testNumBuffs(_o:SpriteModel,_selections:Array,_type:int):Boolean{
			
			return true;
		}
		
		public function testHasBuff(_o:SpriteModel,_selections:Array):Boolean{
			
			return true;
		}
		
		public function testRange(n:Number,min:Number,max:Number):Boolean{
			if ((min<0 || n>=min) && n<max) return true;
			return false
		}
		
		public function getSubs(_category:int=-1):Array{
			if (_category==-1){
				_category=category;
			}
			if (_category==-1) return [];
			
			var m:Array=new Array;
			for (var i:int=0;i<MASTER_LIST[_category][1].length;i+=1){
				m.push(MASTER_LIST[_category][1][i][0]);
			}
			
			return m;
		}
		
		public function getSelections(_category:int=-1,_sub:int=-1,_filtered:Boolean=false):Array{
			if (_category==-1){
				_category=category;
			}
			if (_sub==-1){
				_sub=sub;
			}
			
			if (_category==-1 || _sub==-1) return [];
			
			if (_filtered){
				var m:Array=new Array;
				for (var i:int=0;i<selections.length;i+=1){
					m.push(MASTER_LIST[_category][1][_sub][1][selections[i]]);
				}
				return m;
			}else{
				return MASTER_LIST[_category][1][_sub][1];
			}
		}
		
		public function addSelection(i:int){
			selections.push(i);
		}
		
		public function removeSelection(i:int):Boolean{
			for (var j:int=0;j<selections.length;j+=1){
				if (selections[j]==i){
					selections.splice(j,1);
					return true;
				}
			}
			return false;
		}
		
		public function makeComboArray(_function:Function,_selecteds:Array=null,_category:int=-1,_sub:int=-1):Array{
			if (_selecteds==null) _selecteds=[];
			if (_category==-1){
				m=new Array;
				for (i=0;i<MASTER_LIST.length;i+=1){
					_selected=false;
					for (j=0;j<_selecteds.length;j+=1){
						if (_selecteds[j]==i){
							_selected=true;
							break;
						}
					}
					m.push(makeComboButton(_function,_selected,i));
				}
				return m;
			}else if (_sub==-1){
				var m:Array=new Array;
				for (var i:int=0;i<MASTER_LIST[_category][1].length;i+=1){
					var _selected:Boolean=false;
					for (var j:int=0;j<_selecteds.length;j+=1){
						if (_selecteds[j]==i){
							_selected=true;
							break;
						}
					}
					
					m.push(makeComboButton(_function,_selected,_category,i));
				}
				return m;
			}else{
				m=new Array;
				for (i=0;i<MASTER_LIST[_category][1][_sub][1].length;i+=1){
					_selected=false;
					for (j=0;j<_selecteds.length;j+=1){
						if (_selecteds[j]==i){
							_selected=true;
							break;
						}
					}
					m.push(makeComboButton(_function,_selected,_category,_sub,i));
				}
				
				return m;
			}
		}
		
		var _Refresh:Function;
		
		public function makeComboButton(_function:Function,_selected:Boolean,_category:int=-1,_sub:int=-1,_selection:int=-1,_color:uint=0):ComboButton{
			if (_sub==-1){
				if (_color==0) _color=getColor(_category);
				var m:ComboButton=new ComboButton(MASTER_LIST[_category][0],_color,_function,_category,_selected);
				makeTooltipDesc(m.setDesc,_category);
				return m;
			}else if (_selection==-1){
				if (_color==0) _color=getColor(_sub);
				//m=new ComboButton(MASTER_LIST[_category][0]+" "+MASTER_LIST[_category][1][_sub][0],_color,_function,_sub,_selected);
				m=new ComboButton(MASTER_LIST[_category][1][_sub][0],_color,_function,_sub,_selected);
				
				makeTooltipDesc(m.setDesc,_category,_sub);
				//m.setDesc("remove "+MASTER_LIST[_category][0]+" "+MASTER_LIST[_category][1][_sub][0],"Click here to remove this column.");
				return m;
			}else{
				_Refresh=_function;
				if (_color==0) _color=getColor(_selection);
				m=new ComboButton(MASTER_LIST[_category][1][_sub][1][_selection],_color,toggleSelection,_selection,_selected);
				makeTooltipDesc(m.setDesc,_category,_sub,_selection);
				return m;
			}
		}
		
		public function makeSubTitle(_function:Function):ComboButton{			
			var m:ComboButton=new ComboButton(MASTER_LIST[category][1][sub][0],0x412315,_function);
			m.buttonMode=false;
			makeTooltipDesc(m.setDesc,category,sub);
			return m;
		}
		
		public function toggleSelection(i:int){
			if (!removeSelection(i)){
				addSelection(i);
			}
			
			if (_Refresh!=null) _Refresh();
		}
		
		public function toArray():Array{
			return [category,sub,selections];
		}
		
		//=========STATICS===========\\
		
		public static function fromArray(a:Array):ConditionalBase{
			var m:ConditionalBase=new ConditionalBase(a[0],a[1],a[2]);
			return m;
		}
		
		public static function getColor(i:int){
			switch (i){
				case 5: case 0: return 0x003333;
				case 6: case 1: return 0x993300;
				case 7: case 2: return 0x224422;
				case 8: case 3: return 0x5D1185;
				case 9: case 4: return 0x2B324D;
				
				default: return 0xC0AA52;
			}
		}
		
		public static function makeTooltipDesc(_function:Function,_category:int=-1,_sub:int=-1,_selection:int=-1){
			if (_sub==-1){
				switch(MASTER_LIST[_category][0]){
					default: _function("Category: "+MASTER_LIST[_category][0],"See Sub Categories"); break;
				}
			}else if (_selection==-1){
				switch(MASTER_LIST[_category][1][_sub][0]){
					case GENERAL: _function(MASTER_LIST[_category][0]+" "+MASTER_LIST[_category][1][_sub][0],"Is this action used at Bosses, Minions or both?"); break;
					case CLASS: _function(MASTER_LIST[_category][0]+" "+MASTER_LIST[_category][1][_sub][0],"Select which Player and Enemy classes to use this on"); break;
					case GOBLIN: _function(MASTER_LIST[_category][0]+" "+MASTER_LIST[_category][1][_sub][0],"Select specific Goblin creatures to use this on"); break;
					case HEALTH: _function(MASTER_LIST[_category][0]+" "+MASTER_LIST[_category][1][_sub][0],"Which health values ("+(_category==1?"Yours":"Enemy's")+") to use this ability?"); break;
					case MANA: _function(MASTER_LIST[_category][0]+" "+MASTER_LIST[_category][1][_sub][0],"Which mana values ("+(_category==1?"Yours":"Enemy's")+") to use this ability?"); break;
					case NUM_BUFFS: _function(MASTER_LIST[_category][0]+" "+MASTER_LIST[_category][1][_sub][0],"Only use when this many buffs are on "+(_category==1?"you":"your target")+"."); break;
					case NUM_CURSES: _function(MASTER_LIST[_category][0]+" "+MASTER_LIST[_category][1][_sub][0],"Only use when this many debuffs are on "+(_category==1?"you":"your target")+"."); break;
					case HAS_BUFF:_function(MASTER_LIST[_category][0]+" "+MASTER_LIST[_category][1][_sub][0],"Only use when this/these specific buff(s) are on "+(_category==1?"you":"your target")+"."); break;
					case TURN_COUNT: _function(MASTER_LIST[_category][0]+" "+MASTER_LIST[_category][1][_sub][0],"During which turn of combat will you use this action?"); break;
					case DISTANCE: _function(MASTER_LIST[_category][1][_sub][0],"At what range(s) will you use this action?"); break;
					default: _function("Sub-Category: "+MASTER_LIST[_category][1][_sub][0],"Select this Sub-Category"); break;
				}
			}else{
				makeTooltipSelection(MASTER_LIST[_category][1][_sub][1][_selection],_function);
			}
		}
		
		public static function makeTooltipSelection(s:String,_function:Function){
			switch(s){
				case PERCENT_100: _function("75%-100%","Include this range as possible values (does not include 100%)."); break;
				case PERCENT_75: _function("50%-75%","Include this range as possible values."); break;
				case PERCENT_50: _function("25%-50%","Include this range as possible values."); break;
				case PERCENT_25: _function("10%-25%","Include this range as possible values."); break;
				case PERCENT_10: _function("Less than 10%","Include this range as possible values."); break;
				case NO_ENEMY: _function("No Enemy","If ALL or SAFE are selected, include the time before an enemy spawns."); break;
				case PRE_COMBAT: _function("Pre Fight","If ALL or SAFE are selected, include the time after an enemy spawns."); break;
				case NUM_200B: _function("20-200+","Include any number above 20 as a possible value."); break;
				case NUM_0: _function("0","Include this number as a possible value."); break;
				case NUM_1: _function("1","Include this number as a possible value."); break;
				case NUM_2: _function("2","Include this number as a possible value."); break;
				case NUM_5: _function("3-5","Include this range as possible values."); break;
				case NUM_10: _function("6-10","Include this range as possible values."); break;
				case NUM_20: _function("11-20","Include this range as possible values."); break;
				case NUM_100: _function("21-100","Include this range as possible values."); break;
				case NUM_200: _function("101-200+","Include any number above 100 as a possible value."); break;
				case EMPOWERED: _function("Empower","Include this Buff as a possible value."); break;
				case HASTENED: _function("Haste","Include this Buff as a possible value."); break;
				case ENCHANTED: _function("Enchanted","Include this Buff as a possible value."); break;
				case BOSS: _function("At Boss","Use when you are at the boss."); break;
				case MINION: _function("At Regular Monster","Use when you are at a regular, non-boss monster."); break;
				case NEAR: _function("Near Range","Use when you are right next to your opponent."); break;
				case FAR: _function("Far Range","Use when you are far away from your opponent."); break;
				case VERY: _function("Long Range","Use when you are at long range."); break;
				case BETWEEN: _function("Safe","Use when you have no current opponent."); break;
				default: _function("Undefined","This property does nothing!  Or does it..."); break;
			}
		}
		
		public static function makeMainComboArray(_function:Function):Array{
			var m:Array=new Array;
			for (var i:int=0;i<MASTER_LIST.length;i+=1){
				m.push(makeMainComboButton(_function,i));
			}
			return m;
		}
		
		public static function makeMainComboButton(_function:Function,_category:int):ComboButton{
			var m:ComboButton=new ComboButton(MASTER_LIST[_category][0],getColor(_category),_function,_category);
			makeTooltipDesc(m.setDesc,_category);
			return m;
		}
		
		public static function makeSubComboArray(_function:Function,_category:int=-1):Array{
			var m:Array=new Array;
			for (var i:int=0;i<MASTER_LIST[_category][1].length;i+=1){
				m.push(makeSubComboButton(_function,_category,i));
			}
			return m;
		}
		
		
		public static function makeSubComboButton(_function:Function,_category:int=-1,_sub:int=-1):ComboButton{
			var m:ComboButton=new ComboButton(MASTER_LIST[_category][1][_sub][0],getColor(_sub),_function,_sub);
			makeTooltipDesc(m.setDesc,_category,_sub);
			return m;
		}
		
	}
}
