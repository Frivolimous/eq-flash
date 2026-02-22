package  ui.assets{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	public class GraphicButton extends MovieClip{
		//var label:TextField;
		public var labelText:String;
		public var labelWidth:Number;
		public var scale:Number;
		
		
		var downOnThis:Boolean=false;
		
		var output:Function;
		public var over:Function;
		
		var _Name:String;
		var _Desc:String;
		
		public var index:int=-1;
		
		public var toggleMode:Boolean=false;
		
		public var autosize:Boolean=true;
		
		public function GraphicButton() {
			stop();
			buttonMode=true;
			mouseChildren=false;
			
		}
		
		public function update(t:String=null,f:Function=null,_toggleMode:Boolean=false){
			if (t!=null){
				labelText=t;
				//var label:TextField;
				if (autosize){
					var _width:Number=label.width;
					label.width*=5;
					label.text=t;
					labelWidth=label.textWidth+10;
					
					if (labelWidth>_width){
						label.width=labelWidth;
						scale=_width/labelWidth;
						label.scaleX=label.scaleY=scale;
					}else{
						labelWidth=_width;
						label.width=_width;
						scale=1;
					}
				}else{
					label.text=t;
				}
			}
			output=f;
			addEventListener(MouseEvent.MOUSE_OVER,showMouseOver,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT,showMouseOff,false,0,true);
			addEventListener(MouseEvent.MOUSE_DOWN,showMouseDown,false,0,true);
			addEventListener(MouseEvent.MOUSE_UP,showMouseUp,false,0,true);
			
			toggleMode=_toggleMode;
		}
				
		function showMouseOver(e:MouseEvent){
			if (disabled) return;
			if (totalFrames>=2 && currentFrame==1){
				Facade.soundC.playEffect(SoundControl.BUTTON_OVER);
				gotoAndStop(2);
				updateLabel();
			}
			if (over!=null){
				over();
			}
		}
		
		function showMouseOff(e:MouseEvent){
			if (disabled) return;
		
			if (totalFrames>=2 && (toggleMode==false || currentFrame==2)){
				gotoAndStop(1);
				updateLabel();
			}

			downOnThis=false;
		}
		
		function showMouseDown(e:MouseEvent){
			if (disabled) return;
			
			if (totalFrames>=3 && toggleMode==false){
				gotoAndStop(3);
				updateLabel();
			}
			downOnThis=true;
		}
		
		function showMouseUp(e:MouseEvent){
			if (disabled) return;
			
			if (totalFrames>=3 && toggleMode==false){
				gotoAndStop(2);
				updateLabel();
			}
			
			if (downOnThis){
				Facade.soundC.playEffect(SoundControl.BUTTON);
				downOnThis=false;
				if (index>-1){
					output(index);
				}else{
					output();
				}
			}
		}
		
		public function updateLabel(s:String=null){
			if (s!=null){
				labelText=s;
			}
			
			if (labelText!=null){
				label.text=labelText;
				if (autosize){
					label.width=labelWidth;
					label.scaleX=label.scaleY=scale;
				}
			}
		}
		
		public function setToggle(b:Boolean){
			if (b){
				gotoAndStop(3);
				updateLabel();
			}else{
				gotoAndStop(1);
				updateLabel();
			}
		}
		
		public function get toggled():Boolean{
			return currentFrame==3;
		}
		
		public function set toggled(b:Boolean){
			if (b){
				gotoAndStop(3);
				updateLabel();
			}else{
				gotoAndStop(1);
				updateLabel();
			}
		}
		
		public function set disabled(b:Boolean){
			if (b){
				gotoAndStop(4);
				updateLabel();
				buttonMode=false;
			}else{
				gotoAndStop(1);
				updateLabel();
				buttonMode=true;
			}
		}
		
		public function get disabled():Boolean{
			return currentFrame==4;
		}
		
		public function setDesc(_name:String=null,_desc:String=null){
			if (_name!=null){
				_Name=_name;
			}
			if (_desc!=null){
				_Desc=_desc;
			}
		}
		
		public function get tooltipName():String{
			if (_Name!=null){
				return _Name;
			}else{
				if (label!=null){
					return label.text;
				}else{
					return null;
				}
			}
		}
		
		public function set tooltipName(s:String){
			throw (new Error("property is read-only"));
		}
		
		public function get description():String{
			if (_Desc!=null){
				return _Desc;
			}else{
				if (tooltipName!=null){
					return StringData.button(tooltipName);
				}else{
					return null;
				}
			}
		}
		
		public function set description(s:String){
			throw (new Error("property is read-only"));
		}
	}
	
}
