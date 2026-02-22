package ui.main{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.KeyboardEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import ui.assets.GraphicButton;
	
	public class FilterUI extends Sprite{
		var cType:int=0;
		var cFilter:int=0;
		var bottomBar:Sprite=new Sprite;
		var textArray=new Array(12);
		var matrix:Array=new Array(20);
		var spriteArray:Array=new Array(6);
		
		public function FilterUI(){
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
			spriteArray[6]=new SpriteModel;
			spriteArray[6].view.x=500;
			spriteArray[6].view.y=280;
			addChild(spriteArray[6].view);
			EnemyData.newBoss(spriteArray[i],0,0);
			
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
			buttonB.update("Next Filter",scrollFilter);
			buttonB.x=400;
			buttonB.y=350;
			addChild(buttonB);
			
			buttonB=new ButtonMedium;
			buttonB.update("Update Filter",fromText);
			buttonB.x=400;
			buttonB.y=380;
			addChild(buttonB);
			
			
			
			
			for (var i:int=0;i<12;i+=1){
				textArray[i]=new TextField();
				textArray[i].type="input";
				textArray[i].x=(i%4)*25;
				textArray[i].y=350+Math.floor(i/4)*20;
				textArray[i].width=25;
				textArray[i].height=20;
				addChild(textArray[i]);
			}

			for (i=0;i<20;i+=1){
				matrix[i]=0;
			}
			matrix[0]=matrix[6]=matrix[12]=matrix[18]=1;
		}
		
		public function openWindow(){
			Facade.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
			toText();
			fromText();
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
			var j:int=0;
			for (var i:int=0;i<12;i+=1){
				matrix[j]=Number(textArray[i].text);
				if (i%4!=2){
					j+=1;
				}else{
					j+=2;
				}
			}
			for (i=0;i<6;i+=1){
				if (cType==0 || (cType==1 && i!=5) || (cType==2 && i!=5)){
					EnemyData.newCreature(spriteArray[i],cType,i,cFilter);
					//spriteArray[i].view.recolor(matrix,false);
					addChild(spriteArray[i].view);
				}else{
					if (spriteArray[i].view.parent!=null){
						spriteArray[i].view.parent.removeChild(spriteArray[i].view);
					}
				}
			}
			EnemyData.newBoss(spriteArray[6],cType,cFilter);
			addChild(spriteArray[6].view);
			
			toText();
		}
		
		public function toText(){
			var j:int=0;
			for (var i:int=0;i<12;i+=1){
				textArray[i].text=String(matrix[j]);
				if (i%4!=2){
					j+=1;
				}else{
					j+=2;
				}
			}
		}
		
		public function scrollImage(){
			cType+=1;
			if (cType>2){
				cType=0;
			}
			fromText();
		}
		
		public function scrollFilter(){
			cFilter+=1;
			if (cFilter>2){
				cFilter=0;
			}
			//matrix=SpriteSheets.eColors[cType][cFilter].concat();
			toText();
			fromText();
		}
	}
}