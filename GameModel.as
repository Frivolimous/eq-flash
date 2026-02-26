package{
	import flash.net.SharedObject;
	import items.ItemModel;
	import items.ItemData;
	import utils.GameData;
	import ui.StatusUI;
	import items.ItemView;
	import ui.main.DuelUI;
	import ui.main.ShopUI;
	import ui.main.ForgeUI;
	import ui.windows.ConfirmWindow;
	import hardcore.HardcoreHomeUI;
	import hardcore.HardcoreDuelUI;
	import ui.main.ArtifactUI;
	import ui.main.LoadCharacterUI;
	import ui.main.NewCharacterUI;
	
	public class GameModel{
		
		public static const NEAR:String="near",
							FAR:String="far",
							VERY:String="long",
							BETWEEN:String="safe";

		public static const MAX_ROUNDS:int=200;
		public static var SIMULATED:Boolean=false;
		
		public var enemyM:SpriteModel=new SpriteModel;
		public var playerM:SpriteModel=new SpriteModel;
		public var projectiles:Array=new Array;
		//public var projM:ProjectileObject=new ProjectileObject;
		public var distance:String=BETWEEN;
		public var turn:Boolean;
		public var revivedArea:int=0;
		public var _Area:int=0;
		public var _AreaType:int=0;
		public var _EnemyType:int=0;
		public var _ECount:int;
		public var _ETotal:int;
		
		//public var _Save:SharedObject=SharedObject.getLocal("OPTIONS");
		public var round:Number;
		
		public var active:Boolean=true;
		public var manual:Boolean;
		
		public var duel:Boolean=false;
		public var challengeList:int=0;
		
		public var deathStreak:int=0;
		
		public function get area():int{
			if (Facade.gameC is EpicGameControl){
				return GameData.epics[0];
			}
			return _Area;
		}
		
		public function set area(i:int){
			if (Facade.gameC is EpicGameControl){
				GameData.epics[0]=i;
			}else{
				_Area=i;
			}
		}
		
		public function get areaType():int{
			if (Facade.gameC is EpicGameControl){
				return GameData.zone[0];
			}
			return _AreaType;
		}
		
		public function set areaType(i:int){
			if (Facade.gameC is EpicGameControl){
				GameData.zone[0]=i;
			}else{
				_AreaType=i;
			}
		}
		
		public function get enemyType():int{
			if (Facade.gameC is EpicGameControl){
				return GameData.zone[1];
			}
			return _EnemyType;
		}
		
		public function set enemyType(i:int){
			if (Facade.gameC is EpicGameControl){
				return GameData.zone[1]=i;
			}else{
				_EnemyType=i;
			}
		}
		
		public function get eCount():int{
			if (Facade.gameC is EpicGameControl){
				return GameData.epics[1];
			}
			return _ECount;
		}
		
		public function set eCount(i:int){
			if (Facade.gameC is EpicGameControl){
				GameData.epics[1]=i;
			}else{
				_ECount=i;
			}
		}
		
		public function get eTotal():int{
			if (Facade.gameC is EpicGameControl){
				return GameData.zone[3];
			}
			return _ETotal;
		}
		
		public function set eTotal(i:int){
			if (Facade.gameC is EpicGameControl){
				GameData.zone[3]=i;
			}else{
				_ETotal=i;
			}
		}
		
		public function init(){
			enemyM.view.inverted=true;
		}
		
		public function clearData(){
			GameData.resetPlayerData();
		}
		
		public function atBoss():Boolean{
			if (eCount==eTotal || enemyM.player) return true;
			return false;
		}
		
		public function get kreds():int{
			return GameData.kreds;
		}
		
		public function set kreds(i:int){
			GameData.kreds=i;
		}
		
		public function get stash():Array{
			return GameData.stash;
		}
		
		public function set stash(a:Array){
			throw(new Error("Property is read-only"));
		}
		
		public function get overflow():Array{
			return GameData.overflow;
		}
		
		public function set overflow(a:Array){
			throw(new Error("Property is read-only"));
		}
		
		public function get souls():int{
			return GameData.souls;
		}
		
		public function set souls(i:int){
			GameData.souls=i;
		}
		
		public function setupArea(i:int,_aType:int=-1,_eType:int=-1,_eCount:int=0,_revived:int=-1){
			if (_revived>-1){
				revivedArea=_revived;
			}
			area=i;
			eCount=_eCount;
			eTotal=calcETotal(area);
			if (eCount>eTotal){
				eCount=eTotal;
				//setupArea(area+1);
				//return;
			}
			if (_aType>-1){
				areaType=_aType;
				if (_eType>-1){
					enemyType=_eType;
				}else{
					enemyType=_aType;
				}
			}else if ((area==10)||(area==25)||(area==50)||(area==100)||(area==200)||(area==300)||(area==400)||(area==1000)){
				areaType=enemyType=3;
			}else{
				do{
					var i:int=Math.floor(Math.random()*3);
				}while (i==areaType);
				areaType=i;
				do{
					i=Math.floor(Math.random()*3);
				}while (i==enemyType);
				enemyType=i;
			}
		}
		
		public function calcETotal(i:int):int{
			var base:Number= 7+100*(1- (100/(100+i)) );
			
			var _suns:Number=Math.ceil(GameData.suns);
			var sub:Number=0;
			if (_suns>0) sub=1;
			if (_suns>10) sub+=1;
			if (_suns>100) sub+=1;
			var mult:Number=1-(_suns/(_suns+4000))*0.7;
			var m:Number=(base-sub)*mult;
			if (m<1) m=1;
			
			return m;
		}

		//finds the player wherever he is and adds an item, or if not found adds to overflow
		public function addItemFallbackOverflow(_item:ItemModel){
			//fix when in duel (directly doesn't work it adds to duel character)
			//fix when actively dueling (i get  ref error)
			//fix when in shop (add to shop inventory)
			if ((Facade.gameC is EpicGameControl) || (Facade.gameC is GameControl)){
				trace("added through game");
				Facade.gameUI.addItem(new ItemView(_item));
				return;
			}

			if (Facade.gameC is DuelControl) {
				trace("added to overflow cus duel");
				addOverflowItem(_item, true);
				return;
			}

			if (Facade.currentUI is DuelUI) {
				trace("added to overflow cus duel");
				addOverflowItem(_item, true);
				return;
			}

 			if ((Facade.currentUI is HardcoreHomeUI) || (Facade.currentUI is HardcoreDuelUI) || (Facade.currentUI is ArtifactUI) || (Facade.currentUI is LoadCharacterUI) || (Facade.currentUI is NewCharacterUI)){
				trace("added to overflow cus not perma char");
				addOverflowItem(_item, true);
				return;
			}

			if (Facade.currentUI is ShopUI) {
				trace("added through shop");
				if (Facade.currentUI.inventory.addItem(new ItemView(_item))){
					return;
				}
			}

			if (Facade.currentUI is ForgeUI) {
				trace("added through forge");
				if (Facade.currentUI.inventoryUI.addItem(new ItemView(_item))){
					return;
				}
			}

			if (Facade.currentUI is StatusUI) {
				if (!Facade.currentUI.inventoryUI.noSell) {
					trace("added through status");
					if (Facade.currentUI.inventoryUI.addItem(new ItemView(_item))){
						return;
					}
				}
			} else {
				if (playerM.addItem(_item)) {
					trace("added to player directly");

					return;
				}
			}

			trace("added to overflow");
			addOverflowItem(_item, true);
		}
		
		public function addOverflowItem(_item:ItemModel, andConfirm:Boolean=false){
			condenseOverflow();
			overflow.unshift(_item.exportArray());

			if (andConfirm){
				new ConfirmWindow("Item added to overflow: "+_item.name);
			}
		}
		
		public function condenseOverflow(){
			var i:int=0;
			while (i<overflow.length){
				if (overflow[i]==null){
					overflow.splice(i,1);
				}else{
					i+=1;
				}
			} 
		}
		
		public static var record:Boolean=false,
							replay:Boolean=false,
							recordA:Array=new Array(),
							replayA:Array=new Array(),
							cReplay:int=0;
							
		public static function startReplay(_replay:Array=null){
			if (_replay!=null){
				replayA=_replay;
			}
			replay=true;
			cReplay=0;
		}
		
		public static function endReplay(){
			replay=false;
			replayA=null;
		}
		
		public static function random():Number{
			if (replay){
				if (replayA.length==0) throw(new Error("Missing something..."));
				var m:Number=replayA[cReplay];
				cReplay+=1;
				if (cReplay>=replayA.length){
					cReplay=0;
					//Facade.addLine("Replay Complete");
				}
			}else{
				m=Math.random();
			}
			if (record){
				recordA.push(m);
				Facade.addLine("Random REC: "+String(m));
			}
			return m;
		}
	}
}