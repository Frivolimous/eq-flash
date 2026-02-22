package ui.assets{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.filters.DropShadowFilter;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class SuperComboBox extends Sprite{
		public static const BACK:uint=0x412315,
							BORDER1:uint=0xb1875b,
							BORDER2:uint=0x412315,
							SHADOW:uint=0x412315;
		
		
		var origin:DisplayObject;
		var output:Function;
		var marginX:Number=0;
		var bottomY:Number=0;
		
		var addTo:*;
		
		public function SuperComboBox(_source:DisplayObject,a:Array,_addTo:*){
			if (a!=null && a.length>0){
				addTo=_addTo;
				origin=_source;
				_addTo.addEventListener(MouseEvent.CLICK,testRemove);
				_addTo.addChild(this);
				this.filters=[new DropShadowFilter(5,45,0x28190b,.5,4,4,.7)];
				for (var i:int=0;i<a.length;i+=1){
					makeBox(a[i],i);
				}
				drawBox();
				_addTo.addChild(this);
				
				setTooltipLocation(_source);
			}
		}
		
		static const MARGIN_X:int=10;
		static const MARGIN_Y:int=2;
		
		public function makeBox(a:Array,columnIndex:int=0){
			for (var i:int=0;i<a.length;i+=1){
				a[i].x=marginX;
				a[i].y=i*(a[i]._Height+MARGIN_Y);
				addChild(a[i]);
			}
			
			marginX=a[0].x+a[0]._Width+MARGIN_X;
			var _bottomY=(a[a.length-1].y+a[a.length-1]._Height);
			
			if (_bottomY>bottomY){
				bottomY=_bottomY;
			}
		}
		
		function drawBox(){
			var _bottom:Number;
			var _right:Number;
			var _test:Number;
			
			graphics.clear();
			
			graphics.beginFill(BACK);
			graphics.lineStyle(3,BORDER1);
			
			graphics.drawRect(-5,-5,marginX+2,bottomY+9);
			graphics.endFill();
			
			graphics.lineStyle(1,BORDER2);
			
			graphics.drawRect(-7,-7,marginX+6,bottomY+13);
		}
		
		public function testRemove(e:MouseEvent){
			if (e.target!= this && !(e.target is Tooltip) && !contains(e.target as DisplayObject) && e.target!=origin && !(e.target is SuperComboBox) && !(e.target is ComboButton)) remove();
		}
		
		public function remove(){
			if (parent!=null){
				parent.removeChild(this);
			}
			
			addTo.removeEventListener(MouseEvent.MOUSE_DOWN,testRemove);
		}
		
		function setTooltipLocation(_o:*){
			if (_o==null || _o.parent==null) return;
			var _point:Point=_o.parent.localToGlobal(new Point(_o.x,_o.y));
			x=_point.x;
			y=_point.y+_o.height+1;

			if ((x+width)>addTo.stageWidth){
				x=_point.x+_o.width-width+6;
			}
			if (x<0){
				x=0;
			}
			if ((y+height)>addTo.stageHeight){
				y=_point.y-height+6;
				//y=_point.y-description.y-description.textHeight-7;
				//graphics.drawRect(0,description.y+2,description.width+2,description.textHeight+7);
			}
			if (y<0){
				y=2;
				x=_point.x+_o.width+1;
				if (x+width>addTo.stageWidth){
					x=_point.x-width+6;
				}
				if (x<0){
					x=0;
				}
			}
		}
	}
}