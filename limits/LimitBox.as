package limits{
	import flash.display.Sprite;
	
	public class LimitBox extends Sprite{
		var _Cover:ItemCross=new ItemCross;
		
		public var stored:LimitView;
		public var index:int;
		public var location:BaseLimitUI;
		
		public function LimitBox(i:int,_loc:BaseLimitUI){
			index=i;
			location=_loc;
			name=MouseControl.LIMIT_BOX;
			graphics.beginFill(0,0.01);
			graphics.drawRect(0,0,35,35);
		}
		
		public function check(_item:LimitView):Boolean{
			if (cover){
				return false;
			}
			
			return true;
		}
		
		public function set cover(b:Boolean){
			if (b){
				addChild(_Cover);
			}else{
				if (contains(_Cover)){
					removeChild(_Cover);
				}
			}
		}
		
		public function get cover():Boolean{
			return (contains(_Cover));
		}
		
		public function addItem(item:LimitView){
			removeItem();
			stored=item;
			stored.index=index;
			stored.location=location;
			addChildAt(stored,0);
			stored.x=1;
			stored.y=2.2;
			stored.width=35;
			stored.scaleY=stored.scaleX;
		}
		
		public function removeItem():LimitView{
			var _stored:LimitView=stored;
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
	}
}