package  system.stats{
	import system.effects.EffectBase;
	
	public class StatEffectObject extends StatObject{
		var baseEffect:EffectBase;
		
		public function StatEffectObject(_location:int,_id:int,_effect:EffectBase,_scaling:Number) {
			location=_location;
			id=_id;
			baseEffect=_effect;
			scaling=_scaling
		}
		public function getValue(_level:int=0):*{
			return baseEffect;
		}
	}
	
}
