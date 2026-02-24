package{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import items.ItemButton;
	import items.ItemBox;
	import items.ItemView;
	import items.ItemData;
	import ui.GameUI;
	import flash.geom.Point;
	import ui.assets.GraphicButton;
	import ui.assets.GraphicDisplayBar;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.ui.Mouse;
	import ui.assets.SymbolPair;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import ui.StatusUI;
	import ui.main.HomeUI;
	import artifacts.ArtifactView;
	import ui.main.ArtifactUI;
	import ui.assets.FadeTransition;
	import artifacts.ArtifactData;
	import ui.assets.Tooltip;
	import limits.LimitData;
	import limits.LimitView;
	import utils.GameData;
	
	public class MouseControl{
		var gameM:GameModel;
		public var drag:*;
		var dragStartX:Number;
		var dragStartY:Number;
		var dragOffX:Number;
		var dragOffY:Number;
		
		var curOver:*;
		var timer:Timer=new Timer(200,1);
		var timer2:Timer=new Timer(300,1);
		
		public var customC:Boolean=true;
		var cursor:CustomCursor=new CustomCursor;
		
		public static const BUTTON:String="button",
							ITEM_BUTTON:String="item button",
							PULL:String="pull",
							CHECK_BOX:String="check box",
							SKILL_TREE:String="skill tree",
							POP_VIEW:String="pop view",
							ENEMY:String="enemy",
							PLAYER:String="player",
							STAT_TEXT:String="stat text",
							EFFECT_TEXT:String="effect text",
							ITEM:String="item",
							EFFECT:String="effect",
							ITEM_BOX:String="item box",
							ITEM_COVER:String="item cover",
							LIMIT:String="limit",
							LIMIT_BOX:String="limit box",
							ARTIFACT:String="artifact",
							ARTIFACT_BOX:String="artifact box",
							ARTIFACT_BOX_GRAPHIC:String="artifact graphic",
							ARTIFACT_BACK:String="artifact back",
							ARTIFACT_HEADER:String="artifact header",
							TRASH:String="Sell Item",
							DISPLAY_BAR:String="display bar",
							GAUGEB:String="Gauge Bar",
							LEFT_SKILL:String="Left Skill",
							RIGHT_SKILL:String="Right Skill",
							TREASURE:String="treasure",
							MONSTER_BOX:String="monster box",
							MONSTER:String="monster",
							GAME_VIEW:String="gameV",
							EX_BUTTON:String="exButt";
		
		public function init(){
			gameM=Facade.gameM;
			Facade.stage.addEventListener(MouseEvent.CLICK,mouseClick);
			Facade.stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			Facade.stage.addEventListener(MouseEvent.MOUSE_UP,mouseUp);
			Facade.stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			Facade.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,startDrag);
			setMouseMode(GameData._Save.data.pause[GameData.CURSOR]);
		}
		
		public function keyDown(e:KeyboardEvent){
			if (e.keyCode==Keyboard.C){
				if (e.ctrlKey && e.shiftKey){
					Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, Facade.saveC.exportSave(Facade.gameM.playerM));
					//Facade.gameM.playerM.stash[3]=[Facade.saveC.saveItem(ItemData.spawnItem(15,34,6)),Facade.saveC.saveItem(ItemData.spawnItem(15,36,6))];
					
					//Facade.achieve(6);
					//Facade.achieve(9);
				}
			}else if (e.keyCode==Keyboard.P){
				if (e.ctrlKey && e.shiftKey && Facade.DEBUG){
					Facade.gameM.playerM.xp+=5;
					
					/*if (Facade.currentUI==Facade.menuUI){
						gameM.souls+=1000;
						Facade.menuUI.popPrestige();
					}else if (Facade.currentUI is ui.main.ArtifactUI){
						new FadeTransition(Facade.currentUI,Facade.menuUI);
						//Facade.currentUI.restartCharacter();
					}*/
				}
			}else if (e.keyCode==Keyboard.SPACE){
				if (Facade.currentUI==Facade.gameUI){
					//Facade.gameUI.togglePause();
				}
			}else if (e.keyCode==Keyboard.O){
				
			}
		}
		
		public function mouseClick(e:MouseEvent){
			if (Facade.DEBUG){
				if (e.shiftKey){
					Facade.gameM.enemyM.view.toIdle();
					Facade.gameM.enemyM.setHealth(-5);
					//Facade.gameM.playerM.levelup();
					//Facade.gameM.playerM.challenge+=1;
					//Facade.gameM.playerM.increaseBeltStack(1);
					//Facade.gameM.playerM.addOverflowItem(ItemData.shadowItem());
					//Facade.gameUI.addItem(new ItemView(ItemData.spawnItem(0,31,1)));
					//Facade.menuUI.popPrestige();
				}
			}
			
			if (customC) Mouse.hide();
			
			if (curOver!=null){
				Facade.popOver();
				curOver=null;
				//mouseMove(e);
			}
			switch(e.target.name){
				case BUTTON:
					//if (e.target is ItemButton) return;
					e.target.run();
					break;
				case CHECK_BOX:
					e.target.toggle();
					break;
				case SKILL_TREE:
					e.target.run();
					if (curOver==e.target){
						mouseMove(e);
					}break;
				case ENEMY: case PLAYER:
					Facade.gameUI.updateStatus(e.target.model);
					Facade.gameUI.pullWindow(3);
					break;
				case TREASURE: Facade.menuUI.collectTreasure(); break;
				case ITEM_BOX: if (Facade.gameM.active && !e.target.location.locked) {
								Facade.gameM.playerM.actionList.itemC.update((e.target as ItemBox)); 
								timer2.reset(); 
								timer2.start(); 
							} break;
				case ITEM_COVER: if (timer2.running){
						Facade.gameM.playerM.actionList.itemC.double();
					}else{
						Facade.gameM.playerM.actionList.itemC.remove();
					}break;
				case LIMIT:
					limits.LimitData.useLimit(Facade.gameM.playerM,(e.target as LimitView).model);
					break;
				case PULL: e.target.onClick(); break;
				default: null;
			}
		}
		
		function mouseMove(e:MouseEvent){
			if (drag!=null){
				/*if (drag.name==PULL){
					drag.moveTo((e.stageX-Facade.currentUI.x)/Facade.SCALE,(e.stageY-Facade.currentUI.y)/Facade.SCALE);
				}else{*/
				if (timer.running){
					var _temp:Point=drag.localToGlobal(new Point(0,0));
					if (e.stageX<_temp.x || e.stageX>_temp.x+drag.width || e.stageY<_temp.y || e.stageY>_temp.y+drag.height){
						startDrag();
					}
				}else{
					drag.x=e.stageX+dragOffX;
					drag.y=e.stageY+dragOffY;
				}
			}else{
				if (customC){
					Facade.stage.addChild(cursor);
					if (e.target == cursor) return; 
					if (e.target is SimpleButton){
						cursor.gotoAndStop(2);
					}else if (e.target is Sprite){
						if (e.target.buttonMode){
							cursor.gotoAndStop(2);
						}else{
							cursor.gotoAndStop(1);
						}
					}else{
						cursor.gotoAndStop(1);
					}
				}
				
				if (e.target!=curOver){
					if (e.target is GraphicButton){
						curOver=e.target;
						Facade.popOver(e.target.tooltipName,e.target.description,e.target);
						return;
					}else if (e.target is GraphicDisplayBar){
						curOver=e.target;
						Facade.popOver(e.target.getTooltipName(),"",e.target);
						return;
					}else if (e.target is ui.assets.SymbolPair){
						curOver=e.target;
						//Facade.popOver(StatModel.statNames[e.target.statIndex],StringData.stat(e.target.statIndex),e.target);
						Facade.popOver(e.target.getTooltipName(),e.target.getTooltipDesc(),e.target);
						return;
					}
					switch(e.target.name){
						case BUTTON: case ITEM_BUTTON:
							curOver=e.target;
							Facade.popOver(e.target.tooltipName,e.target.description,e.target);
							break;
						case DISPLAY_BAR:
							curOver=e.target;
							Facade.popOver(e.target.getTooltipName(),e.target.getTooltipDesc(),e.target);
							break;
						case STAT_TEXT:
							curOver=e.target;
							Facade.popOver(e.target.getTooltipName(),e.target.getTooltipDesc(),e.target);
							break;
						case EFFECT_TEXT:
							curOver=e.target;
							Facade.popOver(e.target.text,StringData.getEffectDesc(e.target.value),e.target);
							break;
						case ITEM: 
							curOver=e.target;
							Facade.popOver(e.target.tooltipName,e.target.tooltipDesc,e.target,false,Tooltip.ITEM,e.target.model.level);
							break;
						case ITEM_COVER:
							curOver=e.target;
							Facade.popOver(e.target.stored.tooltipName,e.target.stored.tooltipDesc,e.target.stored,false,Tooltip.ITEM,e.target.stored.model.level)
							break;
						case LIMIT:
							curOver=e.target;
							Facade.popOver(e.target.tooltipName,e.target.tooltipDesc,e.target,false,Tooltip.LIMIT);
							break;
						case ARTIFACT:
							curOver=e.target;
							Facade.popOver(e.target.tooltipName,e.target.tooltipDesc,e.target,false,Tooltip.ARTIFACT,e.target.model.level);
							break;
						case EFFECT:
							curOver=e.target;
							Facade.popOver(e.target.tooltipName,e.target.tooltipDesc,e.target);
							break;
						case SKILL_TREE:
							curOver=e.target;
							Facade.popOver(e.target.tooltipName,e.target.tooltipDesc,e.target,false,Tooltip.SKILL,e.target.level);
							break;
						case EFFECT:
							curOver=e.target;
							Facade.popOver(e.target.tooltipName,e.target.tooltipDesc,e.target);
						case MONSTER:
							curOver=e.target;
							Facade.popOver(e.target.eName,StringData.enemy(e.target.eName),e.target);
							break;
						case ARTIFACT_HEADER:
							curOver=e.target;
							Facade.popOver(e.target.tooltipName,ArtifactData.getDesc(e.target.tooltipName),e.target);
							break;
						/*case LoadCharacterUI.LOAD:
							curOver=e.target;
							if (e.target.parent is LoadCharacterUI){
								Facade.popOver(SkillData.talentList[gameM.save[e.target.index][13]],StringData.talentDesc(SkillData.talentList[gameM.save[e.target.index][13]]),e.target);
							}else{
								Facade.popOver(SkillData.talentList[Facade.saveC.challengeArray(e.target.index)[2]],StringData.talentDesc(SkillData.talentList[Facade.saveC.challengeArray(e.target.index)[2]]),e.target);
							}break;
						case LoadCharacterUI.OVER:
							curOver=e.target;
							if (e.target.parent.parent is LoadCharacterUI){
								Facade.popOver(SkillData.talentList[gameM.save[e.target.parent.index][13]],StringData.talentDesc(SkillData.talentList[gameM.save[e.target.parent.index][13]]),e.target);
							}else{
								Facade.popOver(SkillData.talentList[Facade.saveC.challengeArray(e.target.parent.index)[2]],StringData.talentDesc(SkillData.talentList[Facade.saveC.challengeArray(e.target.parent.index)[2]]),e.target);
							}break;*/
						case CHECK_BOX:
							curOver=e.target;
							Facade.popOver("Manual Actions","Select whether or not actions are to be selected every round.",e.target);
							break;
						case TRASH:
							curOver=e.target;
							Facade.popOver(TRASH,StringData.button(TRASH),e.target);
							break;
						default:
							if (curOver!=null){
								Facade.popOver();
								curOver=null;
							}
					}
				}
			}
		}
		
		function startDrag(e:TimerEvent=null){
			timer.stop();
			if (Facade.gameM.playerM.actionList.itemC.stored==drag){
				Facade.gameM.playerM.actionList.itemC.remove();
			}
			if (drag!=null){
				if (drag.name==ITEM_BUTTON){
					drag.onHold();
					drag=null;
				}else{
					if (customC) {
						cursor.visible=false;
					}else{
						Mouse.hide();
					}
					drag.x=Facade.stage.mouseX+dragOffX;
					drag.y=Facade.stage.mouseY+dragOffY;
					Facade.stage.addChild(drag);
				}
			}
		}
		
		public function mouseDown(e:MouseEvent){
			if (e.target.name==ITEM){
				if (e.target.location==null) return;
				if (!e.target.location.locked){
					if (e.ctrlKey){
						(e.target as ItemView).location.sell(e.target as ItemView);
					}else{					
						drag=e.target;
						var _point:Point=Facade.currentUI.globalToLocal(drag.parent.localToGlobal(new Point(drag.x,drag.y)));
						dragOffX=_point.x-e.stageX;
						dragOffY=_point.y-e.stageY;
						if ((Facade.gameM.active)&&(Facade.currentUI==Facade.gameUI)){
							timer.reset();
							timer.start();
						}else{
							startDrag();
						}
						
						if(curOver!=null){
							Facade.popOver();
							curOver=null;
						}
					}
				}
			}else if (e.target.name==ARTIFACT){
				if (!e.target.location.locked){
					if (e.ctrlKey){
						(e.target as ArtifactView).location.sell(e.target as ArtifactView);
					}else{
						drag=e.target;
						_point=Facade.currentUI.globalToLocal(drag.parent.localToGlobal(new Point(drag.x,drag.y)));
						dragOffX=_point.x-e.stageX;
						dragOffY=_point.y-e.stageY;
						startDrag();
						if(curOver!=null){
							Facade.popOver();
							curOver=null;
						}
					}
				}
			}else if (e.target.name==LIMIT){
				if (!e.target.location.locked){
					drag=e.target;
					_point=Facade.currentUI.globalToLocal(drag.parent.localToGlobal(new Point(drag.x,drag.y)));
					dragOffX=_point.x-e.stageX;
					dragOffY=_point.y-e.stageY;
					timer.reset();
					timer.start();

					if(curOver!=null){
						Facade.popOver();
						curOver=null;
					}
				}
			}else if (e.target.name==ITEM_BUTTON){
				drag=e.target;
				timer.reset();
				timer.start();
			}
		}
		
		function endDrag(){
			if (customC){
				cursor.visible=true;
			}else{
				Mouse.show();
			}
			drag=null;
			/*if (Facade.currentUI is ui.StatusUI){
				if (Facade.currentUI.transTo is ui.main.HomeUI){
					Facade.saveC.saveChar();
				}
			//}else if (Facade.currentUI is ui.main.ArtifactUI){
				//Facade.saveC.saveChar();
			}*/
		}
		
		public function clearMouse(){
			if (drag!=null && drag.name==ITEM){
				drag.location.returnItem(drag);
				endDrag();
			}
		}
		
		function mouseUp(e:MouseEvent){
			if (drag!=null){
				var a:Array=Facade.stage.getObjectsUnderPoint(new Point(drag.x+drag.width/2,drag.y+drag.height/2));
				
				if (drag.name==ITEM){
					if ((timer.running)&&(e.target==drag)){
						Facade.gameM.playerM.actionList.itemC.update(drag.parent);
						timer2.reset();
						timer2.start();
						endDrag();
					}else{
						for (var i:int=0;i<a.length;i+=1){
							if (a[i].name==ITEM_BOX && !a[i].location.locked){
								a[i].location.dropItem(drag,a[i].index);
								endDrag();
								return;
							}else if (a[i].name==BUTTON && a[i].parent.name==ITEM_BOX&& !a[i].parent.location.locked){
								a[i].parent.location.dropItem(drag,a[i].parent.index);
								endDrag();
								return;
							}else if (a[i].name==TRASH){
								drag.location.sell(drag);
								endDrag();
								return;
							}
						}
						drag.location.returnItem(drag);
						endDrag();
					}
				}else if (drag.name==ARTIFACT){
					for (i=0;i<a.length;i+=1){
						if (a[i].name==ARTIFACT_BOX){
							a[i].location.dropItem(drag,a[i].index);
							endDrag();
							return;
						}else if (a[i].name==ARTIFACT_BOX_GRAPHIC){
							a[i].parent.location.dropItem(drag,a[i].index);
							endDrag();
							return;
						}else if (a[i].name==ARTIFACT_BACK){
							a[i].parent.dropItem(drag,drag.model.index);
							endDrag();
							return;
						}
					}
					drag.location.returnItem(drag);
					endDrag();
					return;
				}else if (drag.name==LIMIT){
					for (i=0;i<a.length;i+=1){
						if ((a[i].name==LIMIT_BOX)||(a[i].name==LIMIT && a[i]!=drag)){
							a[i].location.dropItem(drag,a[i].index);
							endDrag();
							return;
						}
					}
					drag.location.returnItem(drag);
					endDrag();
					return;
				}else if (drag.name==ITEM_BUTTON){
					drag.run();
					drag=null;
					timer.stop();
				}
			}
		}
		
		function mouseClickE(e:MouseEvent){
			if (curOver!=null){
				Facade.popOver();
				curOver=null;
			}
			if ((e.target.name==SKILL_TREE)||(e.target is ItemButton)){
			}else{
				mouseClick(e);
			}
		}
		
		public function setMouseMode(b:Boolean){
			customC=b;
			if (customC){
				Mouse.hide();
				cursor.startDrag(true);
				Facade.stage.addChild(cursor);
			}else{
				Mouse.show();
				cursor.stopDrag();
				if (Facade.stage.contains(cursor)) Facade.stage.removeChild(cursor);
			}
		}
	}
}