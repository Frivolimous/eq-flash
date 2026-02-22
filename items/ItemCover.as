package items{
	import flash.display.MovieClip;
	import gameEvents.GameEventManager;
	import gameEvents.GameEvent;
	import system.actions.ActionBase;

	public class ItemCover extends MovieClip{
		public var actionM:ActionBase;
		public var stay:Boolean;
		public var stored:ItemView;
		
		public function ItemCover(){
			buttonMode=true;
			name=MouseControl.ITEM_COVER;			
			gotoAndStop(1);
		}
		
		public function update(_box:ItemBox){
			if (_box.index>=10 || _box.cover) return;
			if ((_box.stored!=null)&&((_box.index==0 && _box.stored.model.secondary!=ItemData.HELD)||_box.stored.model.action!=null)){
				if (stay){
					stay=false;
					gotoAndStop(1);
				}
				_box.addChild(this);
				stored=_box.stored;
				if (_box.stored.model.secondary==ItemData.UNARMED){
					actionM=Facade.gameM.playerM.unarmed.action;
				}else{
					actionM=_box.stored.model.action;
				}
				GameEventManager.addGameEvent(GameEvent.COVER_ITEM,_box.stored);
			}
			
			
			
			/*else if (_box.index==0){
				if (stay){
					stay=false;
					graphics.clear();
					drawBasic();
				}
				_box.addChild(this);
				actionM=Facade.gameM.playerM.unarmed.values[0][1];
			}*/
		}
		
		public function double(){
			stay=true;
			gotoAndStop(2);
		}
		var toRecover;
		
		public function remove(_save:Boolean=false){
			if (!_save){
				toRecover=null;
			}
			if (stay){
				if (_save){
					toRecover=parent;
				}
				stay=false;
				gotoAndStop(1);
			}
			actionM=null;
			if (parent!=null){
				parent.removeChild(this);
			}
		}
		
		public function recover(){
			if (toRecover!=null){
				update(toRecover);
				double();
				toRecover=null;
			}
		}
	}
}