package ui.assets{
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.filters.DropShadowFilter;
	import ui.main.ArtifactUI;
	
	public class Tooltip extends Sprite{
		
		public static const WIDTH:Number=140;
		
		public static const BASIC:int=0,
							ITEM:int=1,
							SKILL:int=2,
							EFFECT:int=3,
							ARTIFACT:int=4,
							LIMIT:int=5;
							
		public static const BACK:uint=0x412315,
							BORDER1:uint=0xb1875b,
							BORDER2:uint=0x412315,
							SHADOW:uint=0x412315;
							
		public static const BACKD:uint=0x53676d,
							BORDERD:uint=0x20363f,
							TEXTD:uint=0x000000;
							
		var label:TextField=new TextField;
		var description:TextField=new TextField;
		var delay:Timer=new Timer(0,1);
		var levelCircle:LevelCircle=new LevelCircle;
		public static const CIRCLE_OFF_X:Number=35;
		public static const CIRCLE_OFF_Y:Number=8;
		
		public function Tooltip(){
			name=MouseControl.POP_VIEW;
			mouseChildren=false;
			label.antiAliasType=AntiAliasType.ADVANCED;
			label.embedFonts=true;
			description.antiAliasType=AntiAliasType.ADVANCED;
			description.embedFonts=true;
			label.defaultTextFormat=new TextFormat(StringData.FONT_SYSTEM,13,StringData.U_YELLOW,true);
			description.defaultTextFormat=new TextFormat(StringData.FONT_SYSTEM,13,StringData.U_NEUTRAL);
			label.x=description.x=3;
			label.y=1;
			label.width=WIDTH;
			label.height=70;
			label.wordWrap=true;
			description.y=label.height-6;
			description.width=WIDTH-3;
			description.wordWrap=true;
			
			delay.addEventListener(TimerEvent.TIMER_COMPLETE,display,false,0,true);
			this.filters=[new DropShadowFilter(5,45,0x28190b,.5,4,4,.7)];
			addChild(label);
			addChild(description);
		}
		
		public function update(_label:String,_description:String,_o:*,instant:Boolean=true,_type:int=0,_level:int=-1){
			if (!(Facade.currentUI is ArtifactUI) && _description!=null) _description= _description.replace(/990502/g,"fc3841");
			
			if (_label==null || _label.length==0){
				delay.stop();
				try{parent.removeChild(this);}catch(e:Error){}
				return;
			}
			
			if (instant){
				display();
			}else{
				try{
					parent.removeChild(this);
				}catch(e:Error){}
				delay.reset();
				delay.start();
			}
			
			label.height=70;
			
			//label.setWidth(_label.length*4);
			
			//label.width=label.textWidth;
			if (Facade.currentUI is ArtifactUI){
				levelCircle.gotoAndStop(2);
				description.defaultTextFormat=new TextFormat(StringData.FONT_SYSTEM,13,TEXTD);
			}else{
				levelCircle.gotoAndStop(1);
				description.defaultTextFormat=new TextFormat(StringData.FONT_SYSTEM,13,StringData.U_NEUTRAL);
			}
			if (_type==ITEM || _type==SKILL || _type==ARTIFACT){
				addChild(levelCircle);
				if (_level>=0) levelCircle.label.text=_level.toString();
				else levelCircle.label.text="?";
				label.x=27;
				label.width=WIDTH-24;
				//label.htmlText="        "+_label;
				label.htmlText=_label;
			}else{
				label.x=3;
				label.width=WIDTH;
				if (contains(levelCircle)){
					removeChild(levelCircle);
				}
				label.htmlText=_label;
			}
			/*if (label.textHeight<40){
				
				//label.height=30;
			}*/
			if (label.textHeight<25){
				label.height=30;
			}else if (label.textHeight<40){
				label.height=45;
			}else{
				label.height=60;
			}
			//label.height=label.textHeight*2;
			
			description.y=label.height-6;
			if (_description==null) _description="";
			
			description.htmlText=_description;
			description.height=description.textHeight+7;

			graphics.clear();
			if (Facade.currentUI is ArtifactUI){
				graphics.beginFill(BACKD);
				graphics.lineStyle(3,BORDERD);
			}else{
				graphics.beginFill(BACK);
				graphics.lineStyle(3,BORDER1);
			}
			
			if (_description.length==0){
				graphics.drawRect(0,0,description.width+5,label.height-9);
				graphics.endFill();
			}else{
				graphics.drawRect(0,0,description.width+5,description.y+description.height);
				graphics.endFill();
				graphics.moveTo(0,label.height-9);
				graphics.lineTo(description.width+5,label.height-9);
			}
			
			if (_type==ITEM){
				graphics.lineStyle(1,BORDER1);
				graphics.moveTo(0,description.y+description.height-21);
				graphics.lineTo(description.width+2,description.y+description.height-21);
			}
			if (Facade.currentUI is ArtifactUI){
				graphics.lineStyle(1,BACKD);
			}else{
				graphics.lineStyle(1,BORDER2);
			}
			if (_description.length>0) graphics.drawRect(-2,-2,description.width+9,description.y+description.height+4);
			else graphics.drawRect(-2,-2,description.width+6,25);
			
			setTooltipLocation(_o);
		}
		
		function setTooltipLocation(_o:*){
			if (_o==null || _o.parent==null) return;
			var _point:Point=_o.parent.localToGlobal(new Point(_o.x,_o.y));
			x=_point.x;
			y=_point.y+_o.height+1;
			if (contains(levelCircle)) x-=CIRCLE_OFF_X;

			if ((x+width)>Facade.WIDTH){
				x=_point.x+_o.width-width;
				if (contains(levelCircle)) x+=CIRCLE_OFF_Y;
			}
			if (x<0){
				x=0;
			}
			var cUI:*=Facade.currentUI, FH:Number=Facade.HEIGHT;
			if ((y+height)>Facade.HEIGHT){
				y=_point.y-height-1;
				if (contains(levelCircle)) y+=CIRCLE_OFF_Y;
				//y=_point.y-description.y-description.textHeight-7;
				//graphics.drawRect(0,description.y+2,description.width+2,description.textHeight+7);
			}
			if (y<0-Facade.currentUI.y){
				y=2-Facade.currentUI.y;
				x=_point.x+_o.width+1;
				if (x+width>Facade.WIDTH){
					x=_point.x-width-1;
					if (contains(levelCircle)) x+=CIRCLE_OFF_Y;
				}
				if (x<0){
					x=0;
				}
			}
		}
		
		public function display(e:TimerEvent=null){
			Facade.stage.addChild(this);
		}
	}
}
		