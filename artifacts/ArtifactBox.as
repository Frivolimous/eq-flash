package artifacts{
	import flash.display.Sprite;
	import ui.windows.ConfirmWindow;
	import flash.filters.ColorMatrixFilter;
	
	public class ArtifactBox extends Sprite{
		public static var GAMBLE:int=1;
		public static var EQUIP:int=0;
		public static var NONE:int=-1;
		public static var UPGRADE:int=2;
		
		public var stored:ArtifactView;
		public var index:int;
		public var checkIndex:int;
		public var location:ArtifactInventoryBase;
		
		public var _Locked:Boolean=false;
		var lockedOver:ArtifactLockedOver;
		public var unlockCost:int;
		
		public var graphic:ArtifactIcons;
		public var shape:Sprite;
		
		public function ArtifactBox(i:int,_loc:ArtifactInventoryBase,_check:int=-1){
			index=i;
			location=_loc;
			checkIndex=_check;
			name=MouseControl.ARTIFACT_BOX;
			
			graphics.beginFill(0,0.01);
			graphics.drawRect(0,0,35,35);
		}
		
		public function addItem(item:ArtifactView){
			removeItem();
			stored=item;
			stored.index=index;
			stored.location=location;
			addChild(stored);
			//stored.x=0;
			//stored.y=0;
			stored.x=-3.2;
			stored.y=-2.8;
			//stored.width=35;
			//stored.scaleY=stored.scaleX;
		}
		
		public function removeItem():ArtifactView{
			var _stored:ArtifactView=stored;
			try{
				stored.parent.removeChild(stored);
			}catch(e:Error){}
			stored=null;

			return _stored;
		}
		
		public function hasItem():Boolean{
			if (stored==null){
				return false;
			}else{
				return true;
			}
		}
		
		public function showBlank(b:Boolean){
			if (b){
				if (graphic==null){
					graphic=new ArtifactIcons;
					graphic.gotoAndStop(index+1);
					//graphic.label.text=String(index);
					graphic.filters=[new ColorMatrixFilter([0.3,0.3,0.3,0,0,0.3,0.3,0.3,0,0,0.3,0.3,0.3,0,0,0,0,0,1,0])];
					graphic.mouseChildren=false;
					graphic.name=MouseControl.ARTIFACT_BOX_GRAPHIC;
					
					shape=new Sprite;
					shape.graphics.beginFill(0);
					shape.graphics.drawEllipse(1.35,1.95,29.70,29.65);
					graphic.mask=shape;
				}
				if (!contains(graphic)){
					addChildAt(graphic,0);
					addChildAt(shape,1);
					
					/*if (stored!=null){
						addChild(stored);
					}*/
				}
			}else if (graphic!=null && contains(graphic)){
				removeChild(graphic);
				removeChild(shape);
			}
		}
		
		public function setUnlockCost(i:int){
			unlockCost=i;
			//set locked's display
		}
		
		public function set locked(_locked:Boolean){
			_Locked=_locked;
			if (_locked){
				if (lockedOver==null){
					lockedOver=new ArtifactLockedOver;
					var _string:String;
					if (unlockCost>1000){
						_string=String(Math.floor(unlockCost/1000))+"k";
					}else if (unlockCost==-1){
						lockedOver.update("",function(){});
						lockedOver.setDesc("Locked!","This slot will unlock at a later zone.");
					}else{
						_string=String(unlockCost);
					}
					lockedOver.update(String(_string),tryBuy);
					lockedOver.setDesc("Unlock Artifact Slot: "+_string,"Unlocks an artifact slot so that you can equip an artifact.  Make sure you have yours equipped before you continue.");
				}else{
					if (unlockCost==-1){
						lockedOver.update("",function(){});
						lockedOver.setDesc("Locked!","This slot will unlock at a later zone.");
					}
				}
				addChild(lockedOver);
			}else{
				if (contains(lockedOver)){
					removeChild(lockedOver);
				}
			}
		}
		
		public function get locked():Boolean{
			return _Locked;
		}
		
		public function tryBuy(){
			if (unlockCost<=0){
				locked=false;
			}else if (Facade.gameM.souls<unlockCost){
				new ConfirmWindow(StringData.confSoul(unlockCost),350,100,null,0,null,2);
			}else{
				new ConfirmWindow("Unlock this slot for "+String(unlockCost)+" Souls?",350,100,finalYes,0,finalNo,2);
			}
		}
		
		public function finalYes(i:int){
			Facade.gameM.souls-=unlockCost;
			location["box"+index].gotoAndStop(1);
			location.updateGold();
			locked=false;
			Facade.gameM.playerM.arts[index]=null;
		}
		
		public function finalNo(){
			
		}
	}
}