package ui.main.assets {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.display.MovieClip;
	import ui.main.assets.Page;
	import ui.assets.GraphicButton;
	import utils.AchieveData;
	
	public class LibraryBook extends MovieClip{
		var _Name:String;
		var book:Array=new Array();
		
		var page:int=0;
		
		var toc:Array=new Array();
		var img:Array=new Array();
		
		
		public function LibraryBook(_name:String,_book:String) {
			prevB.update(null,prevPage);
			nextB.update(null,nextPage);
			tocB.update(StringData.TABLE_CONTENTS,loadToc);
			libraryB.update(StringData.LIBRARY,closeWindow);
					
			tocB.update("Table of Contents",loadToc);
			libraryB.update("Library",closeWindow);
			
			_Name=_name;
			
			var i:int=0;
			var j:int=0;
			//set up pages.  Pages must be preformatted for length
			while(i>-1){
				i=_book.indexOf("<page>",j);
				if (i>-1){
					book.push(new Page(_book.substring(j,i),book.length%2==1));
					j=i+6;
				}else{
					book.push(new Page(_book.substring(j),book.length%2==1));
				}
			}
			
			for (i=0;i<book.length;i+=1){
				if (book[i].title.length>0){
					var _button:GraphicButton=new ButtonTOC;
					//var _button:GraphicButton=new ButtonLarge;
					_button.update(book[i].title,loadPage);
					_button.index=i;
					_button.setDesc("");
					_button.x=380;
					_button.y=112+21*toc.length;
					toc.push(_button);
				}
			}
			loadToc();
			
			Facade.stage.addChild(this);
		}
		
		public function nextPage(){
			if (page==-2){
				loadPage(0);
			}
			else if (page<book.length-2){
				page+=2;
				loadPage(page);
			}else{
				AchieveData.achieve(AchieveData.ACHIEVE_STUDIOUS);
			}
		}
		
		public function prevPage(){
			if (page<0){
			}else if (page==0){
				loadToc();
			}else{
				page-=2;
				loadPage(page);
			}
		}
		
		public function loadToc(){
			page=-2;

			if (toc.length==0){
				loadPage(0);
			}else{
				clearPage();
				leftNum.text="0";
				rightNum.text="1";
				tocTitle.text=_Name;
				addChild(tocGraphic);
				img.push(tocGraphic);
				for (var i:int=0;i<toc.length;i+=1){
					addChild(toc[i]);
					img.push(toc[i]);
				}
			}
		}
		
		public function bookUpdate(){
			if (book[page].title.length>0){
				addChild(pageGraphic);
				img.push(pageGraphic);
				pageTitle.text=book[page].title;
			}
			if (book[page].sub.length>0){
				subTitle.text=book[page].sub;
			}
			
			leftPage.text=book[page].text;
			for (var i:int=0;i<book[page].images.length;i+=1){
				addChild(book[page].images[i]);
				img.push(book[page].images[i]);
			}
			
			if (book.length>page+1){
				if (book[page+1].sub.length>0){
					subTitle2.text=book[page+1].sub;
				}
				rightPage.text=book[page+1].text;
				for (i=0;i<book[page+1].images.length;i+=1){
					addChild(book[page+1].images[i]);
					img.push(book[page+1].images[i]);
				}
			}
			
			leftNum.text=String(page+2);
			rightNum.text=String(page+3);
		}
		
		public function loadPage(j:int){
			clearPage();
			page=j;
			bookUpdate();
		}
		
		function clearPage(){
			for (var i:int=0;i<img.length;i+=1){
				if (contains(img[i])){
					removeChild(img[i]);
				}
			}
			img=new Array();
			subTitle.text="";
			subTitle2.text="";
			tocTitle.text="";
			pageTitle.text="";
			leftPage.text="";
			rightPage.text="";
			//leftImg.bitmapData.fillRect(leftImg.bitmapData.rect,0);
			//rightImg.bitmapData.fillRect(rightImg.bitmapData.rect,0);
		}
				
		function closeWindow(){
			parent.removeChild(this);
		}

	}
	
}
