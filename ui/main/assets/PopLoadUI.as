package ui.main.assets {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	public class PopLoadUI extends Sprite{
		public var player:int=0;
		var output:Function;

		public function PopLoadUI(_saves:Array,_output:Function,_player:int=0,_offset:int=0,_numOpen:int=-1) {
			player=_player;
			output=_output;
			
			var _sprite:MovieClip=new ArenaWindow;
			addChild(_sprite);
			
			for (var i:int=0;i<_saves.length;i+=1){
				var _loadObject=new LoadObject(_saves[i],i+_offset);
				_loadObject.scaleX=_loadObject.scaleY=0.6;
				_loadObject.x=30;
				_loadObject.y=15+25*i;
				_loadObject.update(null,loadChar);
				if (_numOpen>=0 && i>_numOpen){
					_loadObject.disabled=true;
				}
				addChild(_loadObject);
			}
		}
		
		public function loadChar(i:int){
			output(i,player);
		}

	}
	
}
