package ui.main{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.KeyboardEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import fl.motion.AdjustColor;
	import flash.geom.Point;
	import ui.assets.GraphicButton;
	
	public class AdjustFilterUI extends Sprite{
		var cType:int=0;
		var cFilter:int=0;
		var bottomBar:Sprite=new Sprite;
		var textArray=new Array(12);
		var export:TextField=new TextField;
		var spriteArray:Array=new Array(6);
		
		public function AdjustFilterUI(){
			graphics.beginFill(0xffffff);
			//graphics.drawRect(0,0,240,160);
			graphics.drawRect(0,0,640,420);
			
			for (i=0;i<6;i+=1){
				spriteArray[i]=new SpriteModel;
				spriteArray[i].view.x=50+(i%3)*150;
				spriteArray[i].view.y=130+Math.floor(i/3)*150;
				addChild(spriteArray[i].view);
				EnemyData.newCreature(spriteArray[i],0,i,0);
			}
			
			bottomBar.graphics.beginFill(Facade.YELLOW);
			bottomBar.graphics.drawRect(0,320,640,100);
			addChild(bottomBar);
			
			var buttonB:GraphicButton=new ButtonMedium;
			buttonB.update("Next Creature",scrollImage);
			buttonB.x=500;
			buttonB.y=350;
			addChild(buttonB);
			
			buttonB=new ButtonMedium;
			buttonB.update("Close",closeWindow);
			buttonB.x=500;
			buttonB.y=380;
			addChild(buttonB);
			
			buttonB=new ButtonMedium;
			buttonB.update("Update Filter",fromText);
			buttonB.x=400;
			buttonB.y=380;
			addChild(buttonB);
			
			
			
			
			for (var i:int=0;i<4;i+=1){
				var _text:TextField=new TextField;
				_text.selectable=false;
				_text.width=100;
				_text.height=60;
				_text.multiline=true;
				_text.autoSize="center";
				switch(i){
					case 0: _text.text="BRIGHTNESS\n-100 to 100"; break;
					case 1: _text.text="CONTRAST\n-100 to 100"; break;
					case 2: _text.text="SATURATION\n-100 to 100"; break;
					case 3: _text.text="HUE\n-180 to 180"; break;
				}
				_text.x=(i/4)*320;
				_text.y=320;
				addChild(_text);
				textArray[i]=new TextField();
				textArray[i].autoSize="right";
				textArray[i].type="input";
				textArray[i].width=100;
				textArray[i].height=20;
				textArray[i].x=50+(i/4)*220;
				textArray[i].y=360;
				textArray[i].text="0";
				addChild(textArray[i]);
			}
			export.y=400;
			export.width=300;
			addChild(export);
		}
		
		public function openWindow(){
			Facade.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
		}

		public function closeWindow(){
			Facade.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDown);
			parent.removeChild(this);
		}
		
		public function keyDown(e:KeyboardEvent){
			if (e.keyCode==13){
				fromText();
			}else if (e.keyCode==32){
				scrollImage();
			}else if (e.keyCode==27){
				closeWindow();
			}
		}
		
		public function fromText(){
			var _adjust:AdjustColor=new AdjustColor();
			_adjust.brightness=textArray[0].text;
			_adjust.contrast=textArray[1].text;
			_adjust.saturation=textArray[2].text;
			_adjust.hue=textArray[3].text;
			var _filter:ColorMatrixFilter=new ColorMatrixFilter(_adjust.CalculateFinalFlatArray());
			export.text=_adjust.CalculateFinalFlatArray().toString();
			
			for (var i:int=0;i<6;i+=1){
				if (cType==0 || (cType==1 && i!=5) || (cType==2 && i!=5)){
					EnemyData.newCreature(spriteArray[i],cType,i,0);
					spriteArray[i].view.display.filters=[_filter];
					addChild(spriteArray[i].view);
				}else{
					if (spriteArray[i].view.parent!=null){
						spriteArray[i].view.parent.removeChild(spriteArray[i].view);
					}
				}
			}
			
		}
		
		public function zero(){
			for (var i:int=0;i<4;i+=1){
				textArray[i].text="0";
			}
		}
		
		public function scrollImage(){
			cType+=1;
			if (cType>2){
				cType=0;
			}
			fromText();
		}
	}
}