package ui.main.assets{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import ui.main.LoadCharacterUI;
	import ui.assets.GraphicButton;
	
	public class LoadObject extends GraphicButton{
		//public var index:int;
		var levelText:String;
		
		public function LoadObject(_a:Array=null,i:int=-1){
			toggleMode=true;
			mouseChildren=true;
			name=LoadCharacterUI.LOAD;
			
			if (_a!=null){
				setup(_a,i);
			}
		}
		
		public function updateDelete(f:Function){
			var _button:ButtonDelete=new ButtonDelete;
			_button.x=169.5;
			_button.y=4.45;
			
			addChild(_button);
			_button.update(null,f);
			_button.index=index;
		}
		
		public function setup(_a:Array,i:int){
			labelText=_a[0];
			levelText=String(_a[1]);
			updateLabel();
			index=i;
		}
		
		override public function updateLabel(s:String=null){
			if (s!=null){
				labelText=s;
			}
			if (labelText!=null){
				nameT.text=labelText;
			}
			levelT.text=levelText;
		}
		
		public function select(){
			toggled=true;
		}
		
		public function unselect(){
			toggled=false;
		}
	}
}