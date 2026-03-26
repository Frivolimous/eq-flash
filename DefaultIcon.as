package{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.filters.GlowFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.display.StageQuality;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	
	public class DefaultIcon extends Sprite{
		public var _Label:String,
					_Desc:String,
					index:int,
					output:Function;
					 
		public var counter:TextField;
		public var vectorIcon:MovieClip;
		
		// public var bitmap:Bitmap;
		
		
		public function makeCounter(_x:int=45,_y:int=25,_color:uint=0xffffff,_size:int=13){
			counter=new TextField;
			counter.defaultTextFormat=new TextFormat(StringData.FONT_SYSTEM,_size,_color,true);
			counter.autoSize="right";
			counter.width=21;
			counter.height=21;
			counter.x=_x;
			counter.y=_y;
			counter.filters=[new GlowFilter(0,1,2,2,8)];
			addChild(counter);
		}
		
		public function makeBitmap(_vector:MovieClip,_offX:Number=0,_offY:Number=0,_width:Number=-1){
			if (_width>=0){
				vectorIcon.width = _width;
				vectorIcon.scaleY=vectorIcon.scaleX;
			}
			vectorIcon.x=_offX;
			vectorIcon.y=_offY;

			addChildAt(vectorIcon,0);
		}
		
		public function dispose(){
			vectorIcon=null;
			if (parent!=null){
				parent.removeChild(this);
			}
		}
		
		public function get tooltipName():String{
			return _Label;
		}
		
		public function set tooltipName(s:String){
			_Label=s;//throw(new Error("Property is read-only"));
		}
		
		public function get tooltipDesc():String{
			return _Desc;
		}
		
		public function set tooltipDesc(s:String){
			_Desc=s;//sthrow (new Error("Property is read-only"));
		}
		
		public function run(){
			if (output!=null){
				output(index);
			}
		}
		
		public function sepia(){
			filters=[new ColorMatrixFilter([0.4,0.4,0.4,0,0,0.35,0.35,0.35,0,0,0.2,0.2,0.2,0,0,0,0,0,1,0])];
			alpha=.5;
		}
		
		public function makeGrey(){
			filters=[new ColorMatrixFilter([0.3,0.3,0.3,0,0,0.3,0.3,0.3,0,0,0.3,0.3,0.3,0,0,0,0,0,1,0])];
			//alpha=.7;
		}
	}
}