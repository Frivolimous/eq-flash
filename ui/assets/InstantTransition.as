package ui.assets{
	
	public class InstantTransition{
		
		public function InstantTransition(_origin:*,_target:*){
			var _childIndex:int=-1;
			if (_origin!=null){
				_origin.closeWindow();
				if (_origin.parent!=null){
					_childIndex=_origin.parent.getChildIndex(_origin);
					_origin.parent.removeChild(_origin);
				}
			}
			
			if (_target!=null){
				Facade.currentUI=_target;
				if (_childIndex==-1){
					Facade.stage.addChild(_target);
				}else{
					Facade.stage.addChildAt(_target,_childIndex);
				}
				_target.openWindow();
			}
		}
	}
}