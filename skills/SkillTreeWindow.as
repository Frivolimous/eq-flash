package skills{
	import flash.display.Sprite;

	public class SkillTreeWindow extends Sprite{
		var onClose:Function;
		
		public function SkillTreeWindow(_origin:SpriteModel,_onClose:Function){
			onClose=_onClose;
			closeB.update(StringData.CANCEL,closeWindow);
			select.setup(_origin,closeAccept);
			select.doneB.x=34;
		}
		
		function closeAccept(){
			closeWindow();
			onClose();
		}
		
		function closeWindow(){
			parent.removeChild(this);
		}
		
		
	}
}