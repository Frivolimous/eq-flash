package{
	import flash.net.SharedObject;
	import items.ItemModel;
	import items.ItemData;
	import utils.GameData;
	
	public class GameModel{
		
		public static const NEAR:String="near",
							FAR:String="mid",
							VERY:String="far",
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
		
		public function addOverflowItem(_item:ItemModel){
			condenseOverflow();
			overflow.unshift(_item.exportArray());
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