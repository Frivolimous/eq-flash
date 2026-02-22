package ui.assets{
	public class BackgroundModel{
		public var x:int;
		public var index:Number;
		public var width:int;
		
		public function BackgroundModel(_index:Number,_x:int,_width:int){
			while (_index<0){
				_index+=1;
			}
			index=_index;
			x=_x;
			width=_width
		}
		
		public function set right(i:int){
			throw(new Error("property is read-only"));
		}
		
		public function get right():int{
			return (x+width);
		}
	}
}