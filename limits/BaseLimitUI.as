package limits {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import ui.assets.TutorialWindow;
	import ui.windows.ConfirmWindow;
	import utils.GameData;
	
	public class BaseLimitUI extends Sprite{
		var IWIDTH:Number=32.5;
		var IHEIGHT:Number=34;
		var NUM_SLOTS:int=13;
		public var origin:SpriteModel;
		public var itemA:Array;
		
		public var locked:Boolean=false;
		
		public function BaseLimitUI() {
			itemA=new Array(13);
		}
		
		public function makeBox(i:int,_x:Number,_y:Number,_size:String=null):LimitBox{
			var m:LimitBox=new LimitBox(i,this);
			m.x=_x;
			m.y=_y;
			addChild(m);
			return m;
		}
		
		public function clear(){
			for (var i:int=0;i<itemA.length;i+=1){
				if (itemA[i].hasItem()){
					(itemA[i].removeItem()).dispose();
				}
			}
		}

		public function update(_o:SpriteModel=null){
			origin=_o;
		}
		
		public function addItem(_item:LimitView):Boolean{
			for (var i:int=0;i<NUM_SLOTS;i+=1){
				if (!itemA[i].hasItem()){
					itemA[i].addItem(_item);
					return true;
				}
			}
			return false;
		}
		
		public function addItemAt(_item:LimitView,i:int):Boolean{
			//return true if successful
			if ((_item==null)||(i==-1)){
				return true;
			}
			
			itemA[i].addItem(_item);
			return true;
		}
		
		public function removeItem(_item:LimitView):Boolean{
			itemA[_item.index].removeItem();
			return true;
		}
		
		public function removeItemAt(i:int):LimitView{
			return itemA[i].removeItem();
		}
		
		public function check(_item:LimitView,i:int):Boolean{
			return itemA[i].check(_item);
		}

		public function dropItem(_item:LimitView,i:int){
			var _location:BaseLimitUI=_item.location;
			var j:int=_item.index;
			
			if (!check(_item,i)){
				_location.returnItem(_item);
				return;
			}
			if (!_item.location.removeItem(_item)){
				_location.returnItem(_item);				
				return;
			}
			
			if (itemA[i].hasItem()){
				var _item2:LimitView=removeItemAt(i);
				addItemAt(_item,i);
				_location.addItemAt(_item2,j);
			}else{
				addItemAt(_item,i);
			}
		}
		
		public function returnItem(_item:LimitView){
			itemA[_item.index].addItem(_item);
		}
	}
}
