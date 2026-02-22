package artifacts{
	import system.actions.ActionBase;
	
	public class ArtifactModel{
		public var name:String,
							 index:int,
							 level:int,
							 type:String,
							 cost:int,
							 action:ActionBase,
							 values:Array,
							 view:ArtifactView,
							 counter:int;
							 //location:Array,
		
		public function ArtifactModel(_index:int=-1,_name:String=null,_level:int=0,_values:Array=null,_action:ActionBase=null){
			index=_index;
			name=_name;
			level=_level;
			
			cost=50*Math.pow(2,_level);
			
			if (_values==null){
				values=[];
			}else{
				values=_values;
			}
			
			/*if (_action!=null){
				_action.source=this;
			}*/
		}
		
		public function exportArray():Array{
			return [index,level];
		}
		
		public static function importArray(a:Array):ArtifactModel{
			return ArtifactData.spawnArtifact(a[0],a[1]);
		}
	}
}