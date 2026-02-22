package packaged {
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.BitmapData;
	import flash.display.StageQuality;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	

	public class EQGraphicsMain extends MovieClip {
		public var running:int=0;
		
		public function getRenderedBackground(i:int):Array{
			switch(i){
				case ReferenceData.MYB0: return render(new MyB0,640);
				case ReferenceData.MYB1: return render(new MyB1,640);
				case ReferenceData.MYB2: return render(new MyB2,640);
				case ReferenceData.MYB_SHADOW: return render(new MyB1,640,true);
				case ReferenceData.PARALAX0: return render(new Paralax0,640,false,false);
				case ReferenceData.PARALAX1: return render(new Paralax1,640,false,false);
				case ReferenceData.PARALAX2: return render(new Paralax2,640,false,false);
				case ReferenceData.PARALAX_SHADOW: return render(new Paralax1,640,true,false);
			}
			return null;
		}
		
		public function getMusicArray():Array{
			return [Music0,Music1,Music2,Music3,Music4,Music3];
		}
		
		public function getSoundEffectsArray():Array{
			return [ArrowHit,PunchHit,DefaultMiss,SlashHit,DefaultMiss,FireHit,DefaultMiss,EnchantEffect,PoisonUpdate,ConfusionUpdate,null,
						   //AchievementSound,ClickSound,OverSound,LevelSound,GoldSound];
						  Click,Click,Click,Click,Click];
		}
		
		public function render(_source:MovieClip,_cut:Number=-1,_shadow:Boolean=false,_transparent:Boolean=true):Array{
			_source.gotoAndStop(0);
			var _timer:Timer=new Timer(10,0);
			_timer.addEventListener(TimerEvent.TIMER,renderTick);
			_timer.reset();
			_timer.start();
			var _array:Array=new Array;
			running+=1;
			return _array;
			
			function renderTick(e:TimerEvent){
				var m:BitmapData=new BitmapData(640,420,_transparent,0);
				//var rect:Rectangle=_source.getRect(_source);
				m.draw(_source);//,new Matrix(1,0,0,1,-rect.x,-rect.y));
				// m.drawWithQuality(_source, null, null, null, null, true, StageQuality.BEST);
				if (_shadow){
					m.colorTransform(m.rect,new ColorTransform(-1,-1,-1,1,120,120,130,0));
				}
				_array.push(m);
				if (_source.currentFrame<_source.totalFrames){
					_source.nextFrame();
				}else{
					_timer.stop();
					_timer.removeEventListener(TimerEvent.TIMER,renderTick);
					running-=1;
				}
			}
		}
		
		
		public function unPurple(src:BitmapData):BitmapData {
			var converted:BitmapData = new BitmapData(src.width, src.height, true, 0xFF000000);
			converted.threshold(src, src.rect, new Point(0, 0), "==", 0xFFD003D5, 0x0, 0x00FFFFFF, true);
			converted.threshold(converted, src.rect, new Point(0, 0), "==", 0xFFFF00FF, 0x0, 0x00FFFFFF, true);
			converted.threshold(converted, src.rect, new Point(0, 0), "==", 0xFFFF00DE, 0x0, 0x00FFFFFF, true);
			return converted;
		}
	}
	
}
