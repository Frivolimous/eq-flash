package ui.assets{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.filters.DropShadowFilter;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class ComboBox extends Sprite{
		public static const BACK:uint=0x412315,
							BORDER1:uint=0xb1875b,
							BORDER2:uint=0x412315,
							SHADOW:uint=0x412315;
		
		
		static var EXISTS:Boolean=false;
		var origin:DisplayObject;
		var buttons1:Array=new Array();
		var buttons2:Array=new Array();
		var output:Function;
		
		public function ComboBox(_source:DisplayObject,a:Array,a2:Array=null){
			if (!EXISTS && a!=null && a.length>0){
				EXISTS=true;
				//x=_x;
				//y=_y;
				origin=_source;
				Facade.stage.addEventListener(MouseEvent.CLICK,testRemove);
				Facade.stage.addChild(this);
				this.filters=[new DropShadowFilter(5,45,0x28190b,.5,4,4,.7)];
				makeBox(a,a2);
				setTooltipLocation(_source);
			}
		}
		
		public function makeBox(a1:Array,a2:Array=null){
			for (var i:int=0;i<a1.length;i+=1){
				var _obj:DisplayObject=a1[i];
				_obj.x=0;
				_obj.y=i*(_obj.height+2);
				addChild(_obj);
				buttons1.push(_obj);
			}
			if (a2!=null){
				for (i=0;i<a2.length;i+=1){
					_obj=a2[i];
					_obj.x=buttons1[0].x+buttons1[0].width+10;
					_obj.y=i*(_obj.height+2);
					addChild(_obj);
					buttons2.push(_obj);
				}
			}
			drawBox();
			Facade.stage.addChild(this);
		}
		
		function drawBox(){
			var _bottom:Number;
			var _right:Number;
			var _test:Number;
			
			_bottom=buttons1[buttons1.length-1].y+buttons1[buttons1.length-1].height;
			if (buttons2.length>0){
				_test=buttons2[buttons2.length-1].y+buttons2[buttons2.length-1].height;
				if (_test>_bottom) _bottom=_test;
				_right=buttons2[0].x+buttons2[0].width;
			}else{
				_right=buttons1[0].x+buttons1[0].width;
			}
			graphics.clear();
			
			graphics.beginFill(BACK);
			graphics.lineStyle(3,BORDER1);
			
			graphics.drawRect(-5,-5,_right+10,_bottom+6);
			graphics.endFill();
			
			graphics.lineStyle(1,BORDER2);
			
			graphics.drawRect(-7,-7,_right+14,_bottom+10);
		}
		
		public function testRemove(e:MouseEvent){
			if (e.target!= this && !(e.target is Tooltip) && !contains(e.target as DisplayObject)) remove();
			// && e.target!=origin
		}
		
		public function remove(){
			if (parent!=null){
				parent.removeChild(this);
				EXISTS=false;
				Facade.stage.removeEventListener(MouseEvent.MOUSE_DOWN,testRemove);
			}
		}
		
		function setTooltipLocation(_o:*){
			if (_o==null || _o.parent==null) return;
			var _point:Point=_o.parent.localToGlobal(new Point(_o.x,_o.y));
			x=_point.x;
			y=_point.y+_o.height+1;

			if ((x+width)>Facade.WIDTH){
				x=_point.x+_o.width-width+6;
			}
			if (x<0){
				x=0;
			}
			var cUI:*=Facade.currentUI, FH:Number=Facade.HEIGHT;
			if ((y+height)>Facade.HEIGHT){
				y=_point.y-height+6;
				//y=_point.y-description.y-description.textHeight-7;
				//graphics.drawRect(0,description.y+2,description.width+2,description.textHeight+7);
			}
			if (y<0-Facade.currentUI.y){
				y=2-Facade.currentUI.y;
				x=_point.x+_o.width+1;
				if (x+width>Facade.WIDTH){
					x=_point.x-width+6;
				}
				if (x<0){
					x=0;
				}
			}
		}
	}
}