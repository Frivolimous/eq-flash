package ui.windows{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	
	public class ExportWindow extends Sprite{
		var importFunction:Function;
		
		public function ExportWindow(_code:String=null,_import:Function=null){
			display.selectable=true;
			closeB.update(StringData.DONE,closeWindow);
			if (_code==null){
				importFunction=_import;
				importB.update(StringData.IMPORT,importCode);
				display.type="input";
				display.text="<paste text here>";
			}else{
				removeChild(importB);
				display.text=_code;
			}
			Facade.stage.addChild(this);
		}
				
		function importCode(){
			importFunction(display.text);
			closeWindow();
		}
		
		function closeWindow(){
			parent.removeChild(this);
		}
	}
}