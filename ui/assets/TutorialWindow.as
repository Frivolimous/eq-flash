package ui.assets {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import items.ItemView;
	import items.ItemModel;
	import items.ItemData;
	import skills.SkillData;
	import utils.KongregateAPI;
	import utils.GameData;
	import items.ItemBox;
	import system.actions.ActionPriorities;
	
	public class TutorialWindow extends Sprite {
		public static const WELCOME:int=2,
							FIGHT:int=3,
							POTION1:int=4,
							POTION2:int=5,
							SPELL:int=6,
							SPELL2:int=7,
							MANA:int=8,
							MANAPRIORITY:int=9,
							SKILL:int=10,
							ALCH:int=11,
							ALCHPRIORITY:int=12,
							GEM:int=13,
							BOSS:int=14,
							END1:int=15,
							TOWN:int=16,
							DISABLE:int=17,
							GIFT:int=18,
							GIFT2:int=19,
							GIFT3:int=20;

		public static var index:int=-1;
		public static var current:TutorialWindow;
		public static var toTrack:*;
		
		var clickClose:Boolean;
		var displayArrow:TutorialArrow;
		
		public function TutorialWindow(i:int) {
			if (i<=DISABLE && GameData.getFlag(GameData.FLAG_TUTORIAL)){
				disableTutorial();
				return;
			}
			
			if (current!=null) return;
			if (Facade.gameM.playerM.skillBlock.checkTalent(SkillData.UNGIFTED)){
				switch(i){
					case SPELL: case SPELL2: case MANA: case MANAPRIORITY:
						flags[i]=true;
						return;
				}
			}
			if (i==DISABLE) {
				disableTutorial();
				return;
			}
			if (i<=DISABLE){
				if (flags[i]) return;
				flags[i]=true;
			}
			
			switch(i){
				case WELCOME: case FIGHT: case POTION2: case BOSS: case TOWN: case SPELL2: case GIFT: case GIFT2: case GIFT3:
					clickClose=true;
			}
			
			//clickClose=true;
			
			var _string:String=getString(i);
			var _display:TextField=new TextField;
			_display.embedFonts=true;
			_display.defaultTextFormat=new TextFormat(StringData.FONT_FANCY,16,StringData.U_BROWN);
			_display.text=_string;
			if (clickClose) _display.appendText("\n              <Click to close>");
			_display.width=120;
			_display.height=200;
			_display.height=_display.textHeight+10;
			_display.width=_display.textWidth+10;
			_display.wordWrap=true;
			_display.x=50;
			_display.y=100;
			
			graphics.lineStyle(1,StringData.U_BROWN);
			graphics.beginFill(StringData.U_NEUTRAL);
			graphics.drawRect(45,100,_display.width+5,_display.height);
			addChild(_display);
			mouseChildren=false;
			
			if (clickClose){
				addEventListener(MouseEvent.CLICK,remove,false,0,true);
				buttonMode=true;
			}
			
			index=i;
			current=this;
			if (Facade.gameC!=null) Facade.gameC.roundWait=true;
			Facade.currentUI.addChild(this);//Facade.gameUI.addChild(this);
			
		}
		
		
		public function getString(i):String{
			switch(i){
				case WELCOME:		Facade.gameUI.skillUI.visible=false;
									Facade.gameUI.statusW.visible=false;
									Facade.gameUI.actionText.visible=false;
									Facade.gameUI.zoneW.townB.visible=false;
									Facade.gameUI.inventoryUI.trash.visible=false;
									return "The hero ventures forth through the land, seeking fame, glory, riches and levels!";
				case FIGHT:			return "An enemy approaches!  Watch as your heroic hero fights heroically!";
				case POTION1:		toTrack=new ItemView(ItemData.spawnItem(0,31,6));
									Facade.gameUI.addItem(toTrack,5);
									makeArrow(Facade.gameUI.inventoryUI,Facade.gameUI.inventoryUI.itemA[toTrack.index].x+15,Facade.gameUI.inventoryUI.itemA[toTrack.index].y);
									return "Hark!  Your hero is injured!  Click on the potion to tell him to heal himself.";
				case POTION2:		toTrack=null;
									return "Amazing!  Your hero should also be smart enough to drink it himself... \nhopefully...";
				case SPELL:			toTrack=new ItemView(ItemData.startingItem(Facade.gameM.playerM.skillBlock.getTalentIndex(),ItemData.MAGIC));
									Facade.gameUI.addItem(toTrack);
									//arrow inv > magic slot
									return "Your hero defeated his foe and look!  He found a magic spell!  \nEquip it now.";
				case SPELL2:		//arrow
									return "Great!  Now your hero will occasionally cast it all on his own!\nYou can also click on the spell to force him to use it.";
				case MANA:			toTrack=new ItemView(ItemData.spawnItem(0,32,6));
									Facade.gameUI.addItem(toTrack);
									//arrow
									return "Your hero is low on mana, what a coincidence that he found a Mana Potion! \nEquip it now!";
				case MANAPRIORITY:	if (toTrack==null){
										toTrack=new ItemView(ItemData.spawnItem(0,32,6));
										Facade.gameUI.addItem(toTrack);
										}
									makeArrow(Facade.gameUI.inventoryUI,Facade.gameUI.inventoryUI.itemA[toTrack.index].x+15,72);
									//priorities appear
									return "Don't let him waste his time with this potion in battle.  \nChange the Priorities button so he'll only drink this potion while SAFE";
				case SKILL:			makeArrow(Facade.gameUI,488,82);
									Facade.gameUI.skillUI.visible=true;
									Facade.gameUI.statusW.visible=true;
									Facade.gameUI.actionText.visible=true;
									return "Your hero gained a level!  Assign your skill points now.  \nYour skill points can be reset in town... for a price...";
				case ALCH:			toTrack=new ItemView(ItemData.startingItem(Facade.gameM.playerM.skillBlock.getTalentIndex(),ItemData.THROW));
									Facade.gameUI.addItem(toTrack);
									//arrow inv
									return "Your hero found a throwing weapon!  These also go in his belt.  Equip it now!";
				case ALCHPRIORITY:	makeArrow(Facade.gameUI.inventoryUI,Facade.gameUI.inventoryUI.itemA[toTrack.index].x+15,72);
									return "Throwing weapons are better used from far away.\nChange the Priority until it says 'FAR' or 'MID'.";
				case GEM:			toTrack=new ItemView(ItemData.spawnItem(1,45));
									Facade.gameUI.addItem(toTrack);
									Facade.gameUI.inventoryUI.trash.visible=true;
									return "Incredible!  Your hero found a rare GEMSTONE!  He can't do anything with it himself... \nso SELL it for lots of gold!";
				case BOSS:			return "Your hero is approaching a powerful boss monster!  \nPrepare him for the fight of his life... \nOR DEATH!!!!";
									
				//case END1:			return "Hurrah!  The boss is defeated and the town is overjoyed!  Lets head back there to see what's new!";
				case TOWN:			makeArrow(Facade.gameUI,502,69,-90);
									Facade.gameUI.zoneW.townB.visible=true;
									flags[DISABLE]=true;
									GameData.setFlag(GameData.FLAG_TUTORIAL,true);
									Facade.gameUI.addItem(new ItemView(ItemData.spawnPremium(0)));
									return "You can now head back to town using this handy button!\nYour hero will only travel during his next 'SAFE' action.\n\nYou're on your own from here... and take a Premium Item as a gift!\n(Check your Inventory)";
				
				case GIFT:			makeArrow(Facade.stage,273,10,180);
									//displayArrow.scaleX=displayArrow.scaleY=0.6;
									graphics.beginFill(0,0.2);
									graphics.drawRect(0,0,Facade.stage.stageWidth,Facade.stage.stageHeight);
									return "If you enjoy this game please rate it 5 stars!\nA higher rating will help the developers and allow them to make more content!";
				case GIFT2:			Facade.gameM.addOverflowItem(ItemData.spawnPremium(0));
									y=-20;
									makeArrow(Facade.stage,240,190,90);
									toTrack=null;
									graphics.beginFill(0,0.2);
									graphics.drawRect(0,0,Facade.stage.stageWidth,Facade.stage.stageHeight+20);
									return "You've been given a free Premium Item as a thank you for playing!  \nGo ahead and pick it up from the Overflow Tab in your Stash!!!";
				case GIFT3:			GameData.boost+=500;
									return "You have made it far... but you have further to go!\nTake 500 extra Boosts to help you on your way to glory!";
				default: return "";
			}
			
		}
		
		public function makeArrow(_addTo:*,_x:Number,_y:Number,_rotation:Number=0){
			if (displayArrow==null){
				displayArrow=new TutorialArrow;
			}
			displayArrow.x=_x;
			displayArrow.y=_y;
			displayArrow.rotation=_rotation;
			_addTo.addChild(displayArrow);
		}
		
		
		public function remove(e:MouseEvent=null){
			parent.removeChild(this);
			if (Facade.gameC!=null) Facade.gameC.roundWait=false;
			if (displayArrow!=null){
				displayArrow.parent.removeChild(displayArrow);
				displayArrow=null;
			}
			current=null;
			
			if (index==GIFT){
				index=-1;
				new TutorialWindow(GIFT2);
				GameData.setFlag(GameData.FLAG_GIFT,true);
			}else{
				index=-1;
			}
		}
		
		
		
		public static function disableTutorial(){
			if (!GameData.getFlag(GameData.FLAG_TUTORIAL)){
				flags[DISABLE]=true;
				Facade.gameUI.skillUI.visible=true;
				Facade.gameUI.statusW.visible=true;
				Facade.gameUI.actionText.visible=true;
				Facade.gameUI.zoneW.townB.visible=true;
				GameData.setFlag(GameData.FLAG_TUTORIAL,true);
				Facade.gameUI.addItem(new ItemView(ItemData.spawnPremium(0)));
			}
			if (current !=null && current.parent!=null) current.remove();
		}
		
		public static function get flags():Array{
			return Facade.gameM.playerM.flags;
		}
		
		public static function set flags(a:Array){
			
		}
		
		public static function finishIfNumber(i:int){
			if (index==i){
				current.remove();
				
			}
		}
		
		public static function checkTutorial(){
			if (Facade.gameM.playerM.getHealth()<53) Facade.gameM.playerM.setHealth(53);
			if (current==null){
				if (Facade.gameM.area>2 || flags[DISABLE]){
					disableTutorial();
					return;
				}
				if (Facade.gameM.area==1){
					if (!flags[POTION1]){
						if (Facade.gameM.playerM.healthPercent() < 0.7){
							new TutorialWindow(POTION1);
						}
					}else if (!flags[POTION2]){
						if (toTrack==null) {
							flags[POTION2]=true;
						}else if (toTrack.model.charges<6){
							new TutorialWindow(POTION2);
						}
					}
					switch (Facade.gameM.eCount){
						case 0:
							if (!flags[WELCOME]){
								new TutorialWindow(WELCOME);
							}else if (!flags[FIGHT]){
								if (Facade.gameM.distance==GameModel.FAR){
									new TutorialWindow(FIGHT);
								}
							}
							break;
						case 1:
							if (!flags[SPELL]){
								new TutorialWindow(SPELL);
							}else if (!flags[SPELL2]){
								new TutorialWindow(SPELL2);
							}
							break;
						case 2:
							if (!flags[MANA]){
								new TutorialWindow(MANA);
							}else if (!flags[MANAPRIORITY]){
								new TutorialWindow(MANAPRIORITY);
							}
							break;
						case 3:
							if (!flags[SKILL]){
								new TutorialWindow(SKILL);
							}
							break;
						case 5:
							if (!flags[ALCH]){
								new TutorialWindow(ALCH);
							}else if (!flags[ALCHPRIORITY]){
								new TutorialWindow(ALCHPRIORITY);
							}
							break;
						case 6:
							if (!flags[GEM]){
								new TutorialWindow(GEM);
							}
							break;
						case 7:
							if (!flags[BOSS]){
								if (Facade.gameM.distance==GameModel.BETWEEN){
									new TutorialWindow(BOSS);
								}
							}
							break;
						default: break;
					}
				}else if (Facade.gameM.area==2){
					if (!flags[TOWN]){
						if (Facade.gameC.running){
							new TutorialWindow(TOWN);
						}
					}
				}
			}else{
				switch(index){
					case POTION1:
						if (Facade.gameM.playerM.actionList.itemC.stored==toTrack){
							current.remove();
						}
						break;
					case SPELL:
						if (toTrack.index==2){
							toTrack=null;
							current.remove();
						}else if (Facade.gameUI.inventoryUI.y==Facade.gameUI._invIn){
							current.makeArrow(Facade.gameUI.inventoryUI,223.5,4);
						}else if (Facade.mouseC.drag!=null && Facade.mouseC.drag==toTrack){
							current.makeArrow(Facade.gameUI.inventoryUI,Facade.gameUI.inventoryUI.itemA[2].x+15,Facade.gameUI.inventoryUI.itemA[2].y);
						}else{
							current.makeArrow(Facade.gameUI.inventoryUI,Facade.gameUI.inventoryUI.itemA[toTrack.index].x+15,Facade.gameUI.inventoryUI.itemA[toTrack.index].y);
						}
						break;
					case MANA:
						if (toTrack.index>=5 && toTrack.index<=9){
							current.remove();
						}else if (Facade.gameUI.inventoryUI.y==Facade.gameUI._invIn){
							current.makeArrow(Facade.gameUI.inventoryUI,223.5,4);
						}else if (Facade.mouseC.drag!=null && Facade.mouseC.drag==toTrack){
							current.makeArrow(Facade.gameUI.inventoryUI,Facade.gameUI.inventoryUI.itemA[6].x+15,Facade.gameUI.inventoryUI.itemA[6].y);
						}else{
							current.makeArrow(Facade.gameUI.inventoryUI,Facade.gameUI.inventoryUI.itemA[toTrack.index].x+15,Facade.gameUI.inventoryUI.itemA[toTrack.index].y);
						}
						break;
					case MANAPRIORITY:
						if (Facade.gameUI.inventoryUI.itemA[toTrack.index].checkIndex==items.ItemBox.BELT && Facade.gameUI.inventoryUI.itemA[toTrack.index].listB.label.text==ActionPriorities.getListName(ActionPriorities.BETWEEN)){
							toTrack=null;
							current.remove();
						}
						break;
					case SKILL:
						if (Facade.gameM.playerM.skillBlock.skillPoints==0){
							current.remove();
						}
						break;
					case ALCH:
						if (toTrack.index>=5 && toTrack.index<=9){
							current.remove();
						}else if (Facade.gameUI.inventoryUI.y==Facade.gameUI._invIn){
							current.makeArrow(Facade.gameUI.inventoryUI,223.5,4);
						}else if (Facade.mouseC.drag!=null && Facade.mouseC.drag==toTrack){
							current.makeArrow(Facade.gameUI.inventoryUI,Facade.gameUI.inventoryUI.itemA[7].x+15,Facade.gameUI.inventoryUI.itemA[6].y);
						}else{
							current.makeArrow(Facade.gameUI.inventoryUI,Facade.gameUI.inventoryUI.itemA[toTrack.index].x+15,Facade.gameUI.inventoryUI.itemA[toTrack.index].y);
						}
						break;
					case ALCHPRIORITY:
						if (Facade.gameUI.inventoryUI.itemA[toTrack.index].checkIndex==items.ItemBox.BELT && (Facade.gameUI.inventoryUI.itemA[toTrack.index].listB.label.text==ActionPriorities.getListName(ActionPriorities.FAR)||Facade.gameUI.inventoryUI.itemA[toTrack.index].listB.label.text==ActionPriorities.getListName(ActionPriorities.VERY))){
							toTrack=null;
							current.remove();
						}
						break;
					case GEM:
						if (toTrack.parent==null){
							toTrack=null;
							current.remove();
						}else if (Facade.gameUI.inventoryUI.y==Facade.gameUI._invIn){
							current.makeArrow(Facade.gameUI.inventoryUI,223.5,4);
						}else{
							current.makeArrow(Facade.gameUI.inventoryUI,423,129);
						}
						break;
					default: break;
				}
			}
		}
		
	}
}
