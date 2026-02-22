package {
	import system.actions.ActionBase;
	
	public class FakeProjectileObject extends ProjectileObject{
		
		override public function makeEffect(_action:ActionBase,_v:SpriteModel,_t:SpriteModel){
			if (_v==_t){
				Facade.actionC.buff(_action,_v,_t);
			}else{
				Facade.actionC.attack(_action,_v,_t);
			}
		}
		
		override public function update(_frame:int,_after:int,_type:String="straight"){
		}
		
		override public function tick(){
		}
		
		override public function invert(){
		}
		
		override public function endTimer(){
		}
		
		override public function clearTimer(){
		}
	}
}