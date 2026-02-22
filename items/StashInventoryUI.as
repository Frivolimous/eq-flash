package items {
	import flash.display.Bitmap;
	
	public class StashInventoryUI extends BaseInventoryUI{
		//UI of stash.  5x4;
		
		var _Source:Array;
		public var cantAdd:Boolean;

		public function StashInventoryUI() {
			IWIDTH=32.5;
			IHEIGHT=34;
			
			for (var i:int=0;i<20;i+=1){
				itemA[i]=makeBox(i,24+(i%5)*41.5,99.65+Math.floor(i/5)*36.5);
			}
		}
		public function updateStash(a:Array=null,_save:Boolean=true){
			clear();
			
			if (_save){
				_Source=a;
			}
			
			if (a==null) return;
		
			for (var i:int=0;i<a.length && i<itemA.length;i+=1){
				if (a[i]!=null){
					var _model:ItemModel=ItemModel.importArray(a[i]);
					var _view:ItemView=new ItemView(_model)
					itemA[i].addItem(_view);
				}
			}
		}
		
		//override public function sell(_item:ItemView){
			
		//}
		
		override public function addItem(_item:ItemView):Boolean{
			if (locked || cantAdd){
				//_item.location.returnItem(_item);
				return false;
			}
			
			var m:Boolean=super.addItem(_item);
			if (m) saveItem(_item);
			return m;
		}
		
		/*public function addAnyway(_item:ItemView):Boolean{
			var m:Boolean=super.addItem(_item);
			saveItem(_item);
			return m; 
		}*/
								
		override public function check(_item:ItemView,i:int):Boolean{
			if (cantAdd) return false;
			
			return super.check(_item,i);
		}
		
		override public function addItemAt(_item:ItemView,i:int):Boolean{
			if (locked || cantAdd){
				_item.location.returnItem(_item);
				return false;
			}
			
			var m:Boolean=super.addItemAt(_item,i);
			saveItem(_item);
			return m;
		}
		
		override public function returnItem(_item:ItemView){
			itemA[_item.index].addItem(_item);
			saveItem(_item);
		}
		
		override public function removeItem(_item:ItemView):Boolean{
			var m:Boolean=super.removeItem(_item);
			deleteItem(_item);
			return m;
		}
		
		override public function removeItemAt(i:int):ItemView{
			var m:ItemView=super.removeItemAt(i);
			deleteItemAt(i);
			return m;
		}
		
		function saveItem(_item:ItemView){
			if (_Source!=null) _Source[_item.index]=_item.model.exportArray(true);
			//Facade.saveC.saveChar();
		}
		
		function deleteItem(_item:ItemView){
			if (_Source!=null) _Source[_item.index]=null;
			//Facade.saveC.saveChar();
		}
		
		function deleteItemAt(i:int){
			if (_Source!=null) _Source[i]=null;
			//Facade.saveC.saveChar();
		}
	}
}
