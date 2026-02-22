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
		
		public var bitmap:Bitmap;
		
		
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
				var _scale:Number=_width/_vector.width;
				var _matrix:Matrix=new Matrix(_scale,0,0,_scale,_offX,_offY);
			}
			if (bitmap==null){
				var _bitmapData:BitmapData=new BitmapData(_vector.width*_scale,_vector.height*_scale,true,0);
				_bitmapData.draw(_vector,_matrix!=null?_matrix:null);
				// _bitmapData.drawWithQuality(_vector,_matrix!=null?_matrix:null, null, null, null, true, StageQuality.BEST);
				
				bitmap=new Bitmap(_bitmapData,"auto",false);
				addChildAt(bitmap,0);
			}else{
				bitmap.bitmapData.draw(_vector,_matrix!=null?_matrix:null);
				// bitmap.bitmapData.drawWithQuality(_vector,_matrix!=null?_matrix:null, null, null, null, true, StageQuality.BEST);
			}
			vectorIcon=null;
		}
		
		public function dispose(){
			if (bitmap!=null){
				bitmap.bitmapData.dispose();
				bitmap=null;
			}
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