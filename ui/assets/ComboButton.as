package ui.assets{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.filters.GlowFilter;
	import flash.display.Sprite;
	
	public class ComboButton extends MovieClip{
		var _Name:String;
		var _Desc:String;
		public var label:TextField=new TextField;
		var index:int;
		var output:Function;
		var _Selected:Boolean;
		public var _Width:Number;
		public var _Height:Number=18;
		var over:Sprite;
		//public var disabled:Boolean=false;
		
		public function ComboButton(_text:String,_color:uint,_output:Function,_index:int=-1,_selected:Boolean=false,_width:Number=50){
			_Width=_width;
			output=_output;
			index=_index;
			selected=_selected;
			
			name=MouseControl.BUTTON;
			buttonMode=true;
			mouseChildren=false;
			addChild(label);
			label.embedFonts=true;
			label.defaultTextFormat=new TextFormat(StringData.FONT_SYSTEM,14,(_color==0xC0AA52?0x33291B:0xC1A95F),true);
			//label.defaultTextFormat=new TextFormat("Garamond",14,(_color==0xC0AA52?0x33291B:0xC1A95F),true);
			label.y=-3
			label.width=_Width*5;
			label.height=_Height;
			label.text=_text;
			
			var labelWidth:Number=label.textWidth+10;

			if (labelWidth>_Width){
				label.width=labelWidth;
				label.scaleX=label.scaleY=_Width/labelWidth;
				label.height=label.textHeight;
				label.y=_Height/2-label.height/2-3;
			}else{
				label.width=_Width;
			}
			label.autoSize="center";
			
			label.height=_Height;
			
			graphics.clear();
			graphics.beginFill(_color,1);
			graphics.drawRect(0,0,_Width,_Height);
			graphics.endFill();
			
			over=new Sprite;
			over.graphics.beginFill(0xffffff,0.2);
			over.graphics.drawRect(0,0,width,height);
			//addChild(over);
		}
		
		public function get tooltipName():String{
			return _Name;
		}
		
		public function set tooltipName(s:String){
			throw (new Error("property is read-only"));
		}
		
		public function get description():String{
			return _Desc;
		}
		
		public function set description(s:String){
			throw (new Error("property is read-only"));
		}
		
		public function setDesc(_name:String=null,_desc:String=null){
			if (_name!=null){
				_Name=_name;
			}
			if (_desc!=null){
				_Desc=_desc;
			}
		}
		
		public function run(){
			if (index>-1){
				output(index);
			}else{
				output();
			}
		}
		
		
		public function set selected(b:Boolean){
			_Selected=b;
			if (_Selected){
				filters=[new GlowFilter(0xffff00,1,7,7,6,1)];
			}else{
				filters=[];
			}
		}
		
		public function get selected():Boolean{
			return _Selected;
		}
	}
}