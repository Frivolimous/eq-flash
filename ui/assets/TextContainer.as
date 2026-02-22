package ui.assets{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	
	public class TextContainer extends Sprite{
		var label:TextField;
		var labelFormat:TextFormat;
		public var value:*;
		
		public function TextContainer(_text:String=null,_width:int=100,_height:int=20){
			mouseChildren=false;
			label=new TextField;
			label.width=_width;
			label.height=_height;
			label.embedFonts=true;
			label.antiAliasType=AntiAliasType.ADVANCED;
			labelFormat=new TextFormat(StringData.FONT_SYSTEM,13,StringData.U_RED,true);
			label.defaultTextFormat=labelFormat;
			if (_text==null){
				label.text="";
			}else{
				label.text=_text;
			}
			addChild(label);
		}
		
		public function set text(_text:String){
			label.text=_text;
		}
				
		public function get text():String{
			return label.text;
		}
		
		public function set color(_color:uint){
			//label.color=_color;
			labelFormat.color=_color;
			label.defaultTextFormat=labelFormat;
			
		}
		
		public function get color():uint{
			return 0;
			//return labelFormat.color;
		}
		
		public function setWidth(i:int){
			label.width=i;
		}
		
		public function set autoSize(s:String){
			label.autoSize=s;
		}
		
		public function get autoSize():String{
			return label.autoSize;
		}
		
		public function set wordWrap(b:Boolean){
			label.wordWrap=b;
		}
		
		public function get wordWrap():Boolean{
			return label.wordWrap;
		}
	}
}