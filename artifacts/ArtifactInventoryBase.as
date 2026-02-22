package artifacts {
	import flash.display.Sprite;
	import flash.text.TextField;
	import ui.windows.ConfirmWindow;
	
	public class ArtifactInventoryBase extends Sprite{
		var IWIDTH:Number=32.5;
		var IHEIGHT:Number=34;
		
		public var origin:SpriteModel;
		public var gold:TextField;
		public var itemA:Array;
		
		public var drop:ArtifactInventoryBase;
		
		public var locked:Boolean=false;

		public function ArtifactInventoryBase() {
			itemA=new Array(20);
		}
		
		public function makeBox(i:int,_x:Number,_y:Number,_check:int=-1):ArtifactBox{
			var m:ArtifactBox=new ArtifactBox(i,this,_check);
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

		public function update(_o:SpriteModel=null,_arts:Array=null){
			origin=_o;
		}
		
		public function addItem(_item:ArtifactView):Boolean{
			for (var i:int=0;i<itemA.length;i+=1){
				if (!itemA[i].hasItem() && check(_item,i)){
					itemA[i].addItem(_item);
					return true;
				}
			}
			return false;
		}
		
		public function addItemAt(_item:ArtifactView,i:int):Boolean{
			//return true if successful
			if ((_item==null)||(i==-1)){
				return true;
			}
			
			itemA[i].addItem(_item);
			return true;
		}
		
		public function removeItem(_item:ArtifactView):Boolean{
			itemA[_item.index].removeItem();
			return true;
		}
		
		public function removeItemAt(i:int):ArtifactView{
			return itemA[i].removeItem();
		}
		
		public function check(_item:ArtifactView,i:int):Boolean{
			return true;
		}

		public function dropItem(_item:ArtifactView,i:int){
			var _location:ArtifactInventoryBase=_item.location;
			var j:int=_item.index;
			
			if (!check(_item,i)){
				_location.returnItem(_item);
				return;
			}
			if (!_item.location.removeItem(_item)){
				_location.returnItem(_item);				
				return;
			}
			
			/*if (itemA[i].hasItem() && !_location.check(itemA[i].stored,_item.index)){
				_location.returnItem(_item);
				return;
			}*/
			
			
			if (itemA[i].hasItem()){ //there's an item there!
				var _item2:ArtifactView=removeItemAt(i); //_item is item to place, _item2 is item was there
				
				addItemAt(_item,i);  //_item1 is down... now what to do with _item2?
				
				if (_location.check(_item2,j)){  // can I2 go to L1?
					_location.addItemAt(_item2,j);  // YES! I2 go to L1
					
				}else if (!_location.addItem(_item2)){  // NO! Can I2 go elsewhere in L1? If so, over!
					if (!addItem(_item2)){ // NO! Can I2 go elsewhere in L2? If so, over!
						if (!drop.addItem(_item2)){ //NO! just drop it in into drop.  Done.
							//if not, LOST FOREVER!!!
						}
					}
				}
			}else{
				addItemAt(_item,i);
			}
			
			updateGold();
			_location.updateGold();
		}
		
		public function checkDuplicate(_item:ArtifactView):Boolean{
			for (var i:int=0;i<itemA.length;i+=1){
				if (itemA[i].checkIndex==ArtifactBox.EQUIP && itemA[i].hasItem() && itemA[i].stored.model.index==_item.model.index){
					return true;
				}
			}
			return false;
		}
		
		public function updateGold(){
			if ((gold!=null)&&(origin!=null)){
				var _gold:Number=Facade.gameM.souls;
				var _letter:int=0;
				if (_gold>=10000){
					while(_gold>=1000){
						_gold/=1000;
						_letter+=1;
					}
				}
				if (_gold>=100){
					_gold=Math.round(_gold);
				}else if (_gold>10){
					_gold=Math.round(_gold*10)/10;
				}else{
					_gold=Math.round(_gold*100)/100;
				}
				gold.text=String(_gold);
				switch(_letter){
					case 1: gold.appendText("k"); break;
					case 2: gold.appendText("m"); break;
					case 3: gold.appendText("b"); break;
					case 4: gold.appendText("t"); break;
				}
			}
		}
		
		public function returnItem(_item:ArtifactView){
			if (itemA[_item.index].stored==_item){
				itemA[_item.index].addItem(_item);
			}else{
				addItemAt(_item,_item.index);
			}
		}
		
		public function sell(_item:ArtifactView){
			if (drop!=null){
				drop.dropItem(_item,_item.model.index);
			}
		}
	}
}
