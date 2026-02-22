package ui.main{
	import flash.display.MovieClip;
	
	public class BaseUI extends MovieClip{
		public var origin:SpriteModel;
		
		public function openWindow(){
		}
		
		public function closeWindow(){
		}
				
		public function updateStats(_o:SpriteModel=null){
			if (_o!=null){
				origin=_o;
			}
			
			if (origin==null) return;
		}
	}
}