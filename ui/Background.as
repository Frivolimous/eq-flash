package  ui{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.display.DisplayObject;
	import ui.assets.BackgroundModel;
	import ui.windows.EndWindow;
	import ui.assets.TutorialWindow;
	import utils.GameData;
	import utils.SpriteSheets;
	import flash.display.StageQuality;

	
	public class Background extends Bitmap{
		public static var cBG:Number=0;
		public var backs:Array;
		var para:Array;
		var paraX:int=0;
		public var objects:Array=new Array();
		
		public var cList:Array;
		
		public function Background(){
			bitmapData=new BitmapData(GameUI.VIEW_WIDTH,GameUI.VIEW_HEIGHT);
			clear();
		}
		
		public function clear(){
			for (var i:int=0;i<objects.length;i+=1){
				if (objects[i].parent!=null){
					objects[i].parent.removeChild(objects[i]);
				}
			}
			objects=new Array();
			backs=null;
			para=null;
			paraX=0;
			cBG=-1;
		}
				
		public function loadBacks(_cBG:int,_areaType:int){
			clear();
			
			backs=SpriteSheets.background[_areaType];
			para=SpriteSheets.paralax[_areaType];
			
			if (_cBG==-1){
				cBG=getAverageBackground(Facade.gameM.eCount,Facade.gameM.eTotal);
			}else{
				cBG=_cBG;
			}
			cList=new Array();
			cList.push(new BackgroundModel(cBG,0,backs[Math.floor(cBG)].width));
			
		}
		
		public function setBackground(){
			if (cList[cList.length-1].right<GameUI.VIEW_WIDTH){
				cList.push(new BackgroundModel(cBG,cList[cList.length-1].right,backs[0].width));
			}
			var i:int=paraX;
			bitmapData.lock();
			while (i<bitmapData.width){
				bitmapData.draw(para[0],new Matrix(1,0,0,1,i,0));
				i+=para[0].width;
			}
			for (i=0;i<cList.length;i+=1){
				var j:Number=cList[i].index;
				if (j>=backs.length){
					j=backs.length-1;
				}
				while (j<0){
					j+=1;
				}
				if (Math.floor(j)==j){
					bitmapData.draw(backs[j],new Matrix(1,0,0,1,cList[i].x,0));
				}else{
					bitmapData.draw(backs[Math.floor(j)],new Matrix(-1,0,0,1,cList[i].right,0));
				}
			}
			bitmapData.unlock();
		}
		
		public function shiftBack(n:Number){ //moves the background
			if (n==0) return;
		//shift objects
			for (var i:int=0;i<cList.length;i++){
				cList[i].x+=n;
			}
			Facade.gameM.playerM.view.x+=n;
			if (Facade.gameM.enemyM.exists){
				Facade.gameM.enemyM.view.x+=n;
			}
			i=0;
			while (i<objects.length){
				objects[i].x+=n;
				if (objects[i].x+objects[i].width<0){
					parent.removeChild(objects[i]);
					objects.splice(i,1);
				}else{
					i+=1;
				}
			}
			
			if (n<0){
		//move forwards
				if ((cList[0].right)<0){
					cList.shift();
				}
				
				if (cList[0].index==backs.length-1){
					//Facade.gameC.nextLevel();
					new EndWindow(StringData.getEndText(StringData.END_WIN,Facade.gameM.playerM,Facade.gameM.enemyM),Facade.gameUI.navOut,Facade.gameUI.restart,GameData.getFlag(GameData.FLAG_TUTORIAL)&& Facade.gameM.playerM.saveSlot>=0 && Facade.gameM.playerM.saveSlot<5,true);
					return;
				}
				if (cList[cList.length-1].right<GameUI.VIEW_WIDTH){
					//new background
					if (Facade.gameM.eCount>Facade.gameM.eTotal){
						var _isLast:Boolean;
						for (i=0;i<cList.length;i+=1){
							if (cList[i].index==backs.length-1){
								_isLast=true;
								break;
							}
						}
						if (!_isLast){
							cList.push(new BackgroundModel(backs.length-1,cList[cList.length-1].right,backs[backs.length-1].width));
							return;
						}
					}
					
					if (cBG!=Math.floor(cBG)){
						cBG=Math.floor(cBG)-1;
					}else if (cBG%2==1){
						cBG+=1;
					}else{
						if (Facade.gameM.eCount>Facade.gameM.eTotal){
							if (cBG<backs.length-1){
								cBG+=1;
							}
						}else if (Facade.gameM.eCount==Facade.gameM.eTotal){
							if (cBG<backs.length-3){
								cBG+=1;
							}
						}else{
							var _offset:int=(backs.length-3)-(Facade.gameM.eTotal-Facade.gameM.eCount)-cBG;
							trace(_offset);
							if (_offset>0){
								cBG+=1;
							}else{
								switch(Math.floor(Math.random()*10)){
									case 0: case 1: case 2: case 3:
										cBG=cBG; break;
									case 4:
										cBG+=1; break;
									case 5: case 6:
										cBG-=0.5; break;
									case 7: case 8: case 9:
										if (_offset==0){
											cBG=cBG;
										}else if (_offset>0){
											cBG+=1;
										}else{
											cBG-=0.5;
										}
										break;
								}
							}
							if (cBG<=0) cBG+=1;
							if (cBG>backs.length-3) cBG=backs.length-3;
						}
					}
					
					cList.push(new BackgroundModel(cBG,cList[cList.length-1].right,backs[0].width));
					//end new background
				}
			}else{
		//move backwards
				if (cList[0].x>0){
					var _bg:Number=cList[0].index;
					if (Math.floor(_bg)!=_bg){
						_bg=Math.floor(_bg)+1;
					}else if (_bg%2==1){
						_bg-=1;
					}else{
						_bg=_bg;
					}
					cList.unshift(new BackgroundModel(_bg,cList[0].x-cList[0].width,backs[_bg].width));
				}
			}
		
		//always; shift the paralax and draw
			paraX+=n*.75;
			
			if (paraX<0-para[0].width){
				paraX+=para[0].width;
			}
			if (paraX>0){
				paraX-=para[0].width;
			}
			i=paraX;
			bitmapData.lock();
			while (i<bitmapData.width){
				bitmapData.draw(para[0],new Matrix(1,0,0,1,i,0));
				// bitmapData.drawWithQuality(para[0],new Matrix(1,0,0,1,i,0), null, null, null, true, StageQuality.BEST);
				i+=para[0].width;
			}
			
		//draw all the bitmaps
			for (i=0;i<cList.length;i+=1){
				var j:Number=cList[i].index;
				if (j>=backs.length){
					j=backs.length-1;
				}
				while (j<0){
					j+=1;
				}
				if (Math.floor(j)==j){
					bitmapData.draw(backs[j],new Matrix(1,0,0,1,cList[i].x,0));
				}else{
					bitmapData.draw(backs[Math.floor(j)],new Matrix(-1,0,0,1,cList[i].right,0));
				}
			}
			bitmapData.unlock();
		}
		
		public function addLast(){
			cList.push(new BackgroundModel(backs.length-1,cList[cList.length-1].right,backs[backs.length-1].width));
		}
		public function addObject (_b:*){
			parent.addChildAt(_b,1);
			objects.push(_b);
		}
		
		public function isLoaded():Boolean{
			return cBG>=0;
		}
		
		public function getAverageBackground(_count:int,_total:int):int{
			if (_total-_count<10){
				return 10-(_total-_count)/3;
			}else{
				return _count/_total*12;
			}
		}
	}
}
