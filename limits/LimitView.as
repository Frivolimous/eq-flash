package limits{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.filters.ColorMatrixFilter;
	
	public class LimitView extends DefaultIcon{
		public var model:LimitModel;
		public var location:BaseLimitUI;
		var limitDial:MovieClip;
		
		public function LimitView(_model:LimitModel){
			index=-1;
			mouseChildren=false;
			name=MouseControl.LIMIT;
			buttonMode=true;
			
			vectorIcon=new ArtifactIcons;
			limitDial=new LimitDial;
			addChild(vectorIcon);
			addChild(limitDial);
			
			finishView(_model);
		}
		
		function finishView(_model:LimitModel){
			model=_model;
			model.view=this;
			
			vectorIcon.gotoAndStop(model.index+1);
			
			setCounter(model.charges);
		}
		
		public function update(_model:LimitModel){
			model.view=null;
			_Desc=null;
			
			finishView(_model);
		}
		
		public function setCounter(i:int){
			glowLevel(LimitData.levelFromCharges(i));
			limitDial.gotoAndStop(Math.floor(LimitData.levelRemainder(i)*100));
		}
		
		override public function get tooltipName():String{
			return model.name;
		}
				
		override public function get tooltipDesc():String{
			if (_Desc==null){
				//_Desc=StringData.getLimitDesc(model);
			}
			return _Desc;
		}
		
		override public function dispose(){
			if (model.view==this){
				model.view=null;
			}
			if (parent!=null){
				parent.removeChild(this);
			}
		}
		
		public function glowLevel(_level:int){
			switch(_level){
				case 1: filters=[new GlowFilter(0xff0000,1,3,3,5,1)]; break;
				case 2: filters=[new GlowFilter(0xffff00,1,5,5,7,1)]; break;
				case 3: filters=[new GlowFilter(0x00ff00,1,7,7,9,1)]; break;
				default: filters=[]; break;
			}
		}
	}
}