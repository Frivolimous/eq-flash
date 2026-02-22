package ui.assets {
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ScrollAnnounce extends MovieClip{
		var scrollBox:ScrollBoxSmooth;
		
		public function ScrollAnnounce(s:String){
			scrollBox=new ScrollBoxSmooth(83.5,55,439,274);
			addChild(scrollBox);
			
			var displayField:TextField=new TextField;
			displayField.defaultTextFormat=new TextFormat(StringData.FONT_SYSTEM,16,StringData.BLACK);
			displayField.wordWrap=true;
			displayField.selectable=false;
			displayField.width=436;
			displayField.htmlText=s;
			displayField.height=displayField.textHeight+10;
			
			scrollBox.display.addChild(displayField);
			scrollB.init(scrollBox.setPosition,1,2);
			
			closeB.update(StringData.DONE,closeW);
			Facade.stage.addChild(this);
		}
		
		function closeW(){
			scrollB.dispose();
			if (parent!=null) parent.removeChild(this);
		}

	}
	
}
