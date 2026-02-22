package tournament {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	
	public class TournamentTextBar extends Sprite{
		static const colorDark:uint=0x613C21;
		static const colorMedium:uint=0x896148;
		static const colorLight:uint=0xCDB79A;
		static const _TitleHeight:Number=34;
		static const _Height:Number=27;
		
		var output:Function;
		var index:int;

		public function TournamentTextBar(a:Array,_width:Number,_title:Boolean=false) {
			mouseChildren=false;
			graphics.clear();
			graphics.lineStyle(1,colorMedium);
			var _height:Number=_Height;
			if (_title){
				graphics.clear();
				graphics.beginFill(colorDark);
				_height=_TitleHeight;
			}else{
				graphics.clear();
				graphics.beginFill(colorDark,0.01);
			}
			graphics.drawRect(0,0,_width,_height);
			graphics.endFill();
			graphics.lineStyle(1,colorMedium);
			for (var i:int=0;i<a.length;i+=1){
				var _text:TextField=new TextField;
				if (_title){
					_text.defaultTextFormat=new TextFormat(StringData.FONT_FANCY,16,colorLight);
				}else{
					_text.defaultTextFormat=new TextFormat(StringData.FONT_FANCY,16,colorDark);
				}
				_text.width=_width/a.length;
				_text.height=_height;
				_text.x=(_width/a.length)*i;
				_text.text=a[i];
				_text.height=_text.textHeight+5;
				_text.y=(_height-_text.height)/2;
				_text.autoSize="center";
				addChild(_text);
				if (i>0){
					graphics.moveTo((_width/a.length)*i,0);
					graphics.lineTo((_width/a.length)*i,_height);
				}
			}
		}
		
		public var overlay:Sprite;
		public var downOnThis:Boolean=false;
		
		public function makeButton(_function:Function,i:int){
			overlay=new Sprite;
			overlay.graphics.beginFill(0xffffff,0.2);
			overlay.graphics.drawRect(0,0,width,height);
			addEventListener(MouseEvent.MOUSE_OVER,showMouseOver,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT,showMouseOff,false,0,true);
			addEventListener(MouseEvent.MOUSE_DOWN,showMouseDown,false,0,true);
			addEventListener(MouseEvent.MOUSE_UP,showMouseUp,false,0,true);
			output=_function;
			index=i;
		}
		
		function showMouseOver(e:MouseEvent){
			addChild(overlay);
		}
		
		function showMouseOff(e:MouseEvent){
			if (contains(overlay)) removeChild(overlay);
			alpha=1;
			downOnThis=false;
		}
		
		function showMouseDown(e:MouseEvent){
			if (contains(overlay)) removeChild(overlay);
			alpha=0.5;
			downOnThis=true;
		}
		
		function showMouseUp(e:MouseEvent){
			alpha=1;
			addChild(overlay);
			
			if (downOnThis){
				Facade.soundC.playEffect(SoundControl.BUTTON);
				downOnThis=false;
				output(index);
			}
		}
		
	}
	
}
