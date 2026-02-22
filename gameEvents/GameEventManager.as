package gameEvents {
	import flash.events.Event;
	import utils.KongregateAPI;
	
	public class GameEventManager {
		public static var listeners:Array=new Array;
		public static var _Events:Array=new Array;
		
		public static function init(){
			Facade.stage.addEventListener(Event.ENTER_FRAME,onTick);
			listeners.push(Autopause);
			listeners.push(utils.KongregateAPI);
		}
		
		public static function register(_v:*){
			listeners.push(_v);
		}
		
		public static function unregister(_v:*){
			for (var i:int=0;i<listeners.length;i+=1){
				if (listeners[i]==_v){
					listeners.splice(i,1);
					return;
				}
			}
		}
		
		public static function addBuffEvent(_event:BuffEvent){
			
		}

		public static function addDisplayEvent(){
			
		}
		
		public static function addGameEvent(_type:int,_values:*=null){
			pushGameEvent(new GameEvent(_type,_values));
		}
		
		static function pushGameEvent(e:GameEvent){
			_Events.push(e);
		}
		
		static function onTick(e:Event){
			while (_Events.length>0){
				for (var i:int=0;i<listeners.length;i+=1){
					listeners[i].checkEvent(_Events[0]);
				}
				_Events.shift();
			}
		}

	}
	
}
