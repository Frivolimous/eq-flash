package  system.stats{
	
	public class StatObject {
		public var location:int,
					id:int,
					base:Number,
					scaling:Number;
					
		public function StatObject(_location:int=-1,_id:int=-1,_base:Number=-1,_scaling:Number=-1){
			if (_location==-1) return;
			
			location=_location;
			id=_id;
			base=_base;
			scaling=_scaling;
		}
		
		public function getValue(_level:int=0):*{
			return base+(scaling*_level);
		}
	}
}
