package utils{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.display.StageQuality;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import packaged.ReferenceData;
	import packaged.EQGraphicsMain;
	
	public class SpriteSheets{
		public static var running:int=0;
		public static var afterEffect:Array;
		
		public static var background:Array;
		public static var paralax:Array;

		public static var enemyIcons:BitmapData;
		
		public static var eqGraphics:MovieClip;
		public static var ldr:Loader=new Loader;
		
		public static function init(){
		// 	ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaderComplete);
		// 	ldr.load(new URLRequest("EQGraphics.swf"));
		// 	running+=1;
		// }
		
		// public static function onLoaderComplete(e:Event){
		// 	eqGraphics=MovieClip(ldr.contentLoaderInfo.content);
		// 	ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoaderComplete);
		// 	running-=1;
			eqGraphics = new EQGraphicsMain();
			init2();
		}
		
		public static function doneRendering():Boolean{
			if (running>0 || eqGraphics==null || eqGraphics.running>0) return false;
			return true;
		}
		
		public static function init2(){
			background=[eqGraphics.getRenderedBackground(ReferenceData.MYB0),eqGraphics.getRenderedBackground(ReferenceData.MYB1),eqGraphics.getRenderedBackground(ReferenceData.MYB2),eqGraphics.getRenderedBackground(ReferenceData.MYB_SHADOW)];
			paralax=[eqGraphics.getRenderedBackground(ReferenceData.PARALAX0),eqGraphics.getRenderedBackground(ReferenceData.PARALAX1),eqGraphics.getRenderedBackground(ReferenceData.PARALAX2),eqGraphics.getRenderedBackground(ReferenceData.PARALAX_SHADOW)];
			/*background=[render(new MyB0,640),render(new MyB1,640),render(new MyB2,640),render(new MyB1,640,true)];
			paralax=[render(new Paralax0,640,false,false),render(new Paralax1,640,false,false),render(new Paralax2,640,false,false),render(new Paralax1,640,true,false)];
			*/
			enemyIcons=null;//unPurple(new EIcons(80,72));
			
			Facade.soundC.loadArrays(eqGraphics.getMusicArray(),eqGraphics.getSoundEffectsArray());
		}
		
		/*public static function init2(){
			background=[render(new MyB0,640),render(new MyB1,640),render(new MyB2,640),render(new MyB1,640,true)];
			paralax=[render(new Paralax0,640,false,false),render(new Paralax1,640,false,false),render(new Paralax2,640,false,false),render(new Paralax1,640,true,false)];
			enemyIcons=unPurple(new EIcons(80,72));
		}*/
		
	}
}