package ui.windows{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	
	public class ConfirmWindow extends MovieClip{
		var _Function:Function;
		var _Function2:Function;
		var blackout:Sprite=new Sprite;
		var index:int;
		
		public function ConfirmWindow(_display:String,_x:int=50,_y:int=50,_f:Function=null,i:int=0,_f2:Function=null,_page:int=1){
			gotoAndStop(_page);
			x=_x;
			y=_y;
			
			_Function=_f;
			_Function2=_f2;
			index=i;
			
			if (_f==null){
				removeChild(yesB);
				removeChild(noB);
				if (_page==2){
					closeB2.update(StringData.CLOSE_WINDOW,closeWindow);
					removeChild(closeB);
				}else{
					closeB.update(StringData.CLOSE_WINDOW,closeWindow);
					removeChild(closeB2);
				}
			}else{
				removeChild(closeB);
				removeChild(closeB2);
				yesB.update(StringData.YES,confirm);
				noB.update(StringData.NO,cancel);
			}

			blackout.graphics.beginFill(0,0.6);
			blackout.graphics.drawRect(0,0,Facade.WIDTH,Facade.HEIGHT);
			blackout.graphics.endFill();

			display.text=_display;
			
			Facade.stage.addChild(blackout);
			Facade.stage.addChild(this);
		}
				
		function confirm(){
			if (_Function!=null) _Function(index);
				closeWindow();
		}
		
		function cancel(){
			if (_Function2!=null){
				_Function2();
			}
			closeWindow();
		}
		
		public function closeWindow(){
			parent.removeChild(this);
			blackout.parent.removeChild(blackout);
		}
	}
}