package limits{
	public class LimitModel{
		public var name:String,
							 index:int,
							 _Charges:int,
							 view:LimitView,
							 location:Array;
		
		public function LimitModel(_index:int=-1,_name:String=null,_charges:int=-1){
			index=_index;
			name=_name;
			_Charges=_charges;
		}
		
		public function set charges(i:int){
			if (i>50) i==50;
			if (i<0) i==0;
			_Charges=i;
			if (view!=null){
				view.setCounter(i);
				view._Desc=null;
			}
		}
		
		public function get charges():int{
			return _Charges;
		}
	}
}