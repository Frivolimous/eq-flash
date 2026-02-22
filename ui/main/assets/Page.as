package ui.main.assets {
	import flash.filters.ColorMatrixFilter;
	import items.ItemView;
	import skills.SkillView;
	
	public class Page {
		public var text:String="";
		public var title:String="";
		public var sub:String="";
		public var images:Array=new Array;
		
		public function Page(_text:String="",_right:Boolean=false){
			var i:int;
			var j:int;
			var k:int;
			//get Titles for Display and Table of Contents,
			//sub for Sub-Titles
			text=_text;
			i=text.indexOf("<title>");
			if (i>-1){
				j=text.indexOf("</title>",i);
				if (j>-1){
					title=text.substring(i+7,j);
					text=text.substring(0,i)+text.substring(j+8);
				}
			}
		
			i=text.indexOf("<sub>");
			if (i>-1){
				j=text.indexOf("</sub>");
				if (j>-1){
					sub=text.substring(i+5,j);
					text=text.substring(0,i)+text.substring(j+6);
				}
			}
			
			if (text.substr(0,5)=="<img:"){
				var imgType:String=text.substring(5,text.indexOf(":",5));
				var imgIndex:int=int(text.substr(text.indexOf(":",5)+1,2));
				var _img:*;
				switch(imgType){
					case "enemy": _img=new SpriteView();
						_img.newFromCode(imgIndex);
						_img.makeSepia(1);
						_img.x=220;
						_img.y=170;
						images.push(_img);
						break;
					case "boss ": _img=new SpriteView();
						_img.newFromCode(imgIndex,true);
						_img.makeSepia(1);
						_img.x=220;
						_img.y=170;
						images.push(_img);
						break;
					case "skill": _img=new SkillIcon;
						_img.gotoAndStop(imgIndex+1);
						formatIcon(_img,_right);
						images.push(_img);
						break;
					case "items": _img=new ItemIcon;
						_img.back.stop();
						_img.front.gotoAndStop(imgIndex+1);
						_img.parchment.stop();
						_img.border.stop();
						formatIcon(_img,_right);
						images.push(_img);
						break;
					
				}
				//do Image Stuff
				text=text.substring(text.indexOf(">")+1);
			}
		}
		
		public function formatIcon(v:*,_right:Boolean){
			
			v.filters=[new ColorMatrixFilter([0.4,0.4,0.4,0,0,0.35,0.35,0.35,0,0,0.2,0.2,0.2,0,0,0,0,0,1,0])]; 
			v.scaleX=v.scaleY=2;
			v.alpha=.5;
			
			if (_right){
				v.x=480;
			}else{
				v.x=180;
			}
			v.y=70;
		}
		
		/*public function makeImg(a:Array,i:int){
			return;
			var _bd:BitmapData;
			var _bm:Bitmap;
			if (i==0){
				_bm=leftImg;
			}else{
				_bm=rightImg;
			}
			switch(a[0]){
				case "enemy": 
					//_bd=SpriteControl.sepia(SpriteSheets.enemy[Math.floor(a[1]/10)][a[1]%10]); 
					_bd.copyPixels(_bd,new Rectangle(0,0,58,58),new Point(0,0));
					_bm.bitmapData.draw(_bd,new Matrix(1.38,0,0,1.38));
					_bd.dispose();
					break;
				case "boss ":
					//_bd=SpriteControl.sepia(SpriteSheets.boss[a[1]]);
					_bd.copyPixels(_bd,new Rectangle(0,0,58,58),new Point(0,0));
					_bm.bitmapData.draw(_bd,new Matrix(1.38,0,0,1.38));
					_bd.dispose();
					break;
				case "skill":
					/*_bd=new BitmapData(20,18);
					_bd.copyPixels(SpriteControl.sepia(SpriteSheets.skills),new Rectangle((a[1]%5)*20,int(a[1]/5)*18,20,18),new Point(0,0));
					_bm.bitmapData.draw(_bd,new Matrix(2,0,0,2,40,10));
					_bd.dispose();*/
					//break;
				/*case "items":
					_bd=new BitmapData(20,18);
					//_bd.copyPixels(SpriteControl.sepia(SpriteSheets.itemIcons),new Rectangle((a[1]%5)*20,int(a[1]/5)*18,20,18),new Point(0,0));
					if (_bm==leftImg){
						_bm.bitmapData.draw(_bd,new Matrix(4,0,0,4,80,15));
					}else{
						_bm.bitmapData.draw(_bd,new Matrix(4,0,0,4,0,15));
					}
					_bd.dispose();
					break;
				default:break;
			}
		}*/
	}
	
}
