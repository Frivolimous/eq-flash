package ui.assets{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import system.actions.ActionBase;
	
	public class TextDouble extends Sprite{
		public var label1:TextField=new TextField;
		public var label2:TextField=new TextField;
		var labelFormat1:TextFormat=new TextFormat;
		var labelFormat2:TextFormat=new TextFormat;
		public var index:int;
		public var type:int;
		
		public static const ACTION:int=0,
							STAT:int=1;
		
		public function TextDouble(_width:Number,_type:int){
			type=_type;
			mouseChildren=false;
			name=MouseControl.STAT_TEXT;
			
			label1.width=_width;
			label2.width=_width;
			label1.height=20;
			label2.height=20;
			label1.embedFonts=true;
			label2.embedFonts=true;
			label1.antiAliasType=AntiAliasType.ADVANCED;
			label2.antiAliasType=AntiAliasType.ADVANCED;
			labelFormat1=new TextFormat(StringData.FONT_SYSTEM,12,StringData.U_BROWN,true);
			labelFormat2=new TextFormat(StringData.FONT_SYSTEM,12,StringData.U_RED,true);
			label1.defaultTextFormat=labelFormat1;
			label2.defaultTextFormat=labelFormat2;
			label2.autoSize="right";
			
			addChild(label1);
			addChild(label2);
		}
		
		public function setTextFromIndex(i:int){
			index=i;
			if (type==STAT){
				label1.text=StatModel.statNames[i];
			}else{
				label1.text=ActionBase.statNames[i];
			}
		}
		
		public function set text(_text:String){
			label1.text=_text;
		}
				
		public function get text():String{
			return label1.text;
		}
		
		public function set text2(_text:String){
			label2.text=_text;
		}
				
		public function get text2():String{
			return label2.text;
		}
		
		public function set color(_color:uint){
			labelFormat1.color=_color;
			label1.defaultTextFormat=labelFormat1;
		}
		
		public function get color():uint{
			return 0;//label1.color;
		}

		public function set color2(_color:uint){
			labelFormat2.color=_color;
			label2.defaultTextFormat=labelFormat2;
		}
		
		public function get color2():uint{
			return 0;//label2.color;
		}
		
		public function getTooltipName():String{
			return label1.text;
		}
		
		public function getTooltipDesc():String{
			 if (type==STAT){
				 return StringData.stat(index);
			 }else if (type==ACTION){
				 return StringData.actionStat(index);
			 }
			 return "";
		}
	}
}