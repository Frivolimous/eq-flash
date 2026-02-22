package ui.assets{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class GraphicDisplayBar extends MovieClip{
		static const HEIGHT:int=6;
		var tooltipName:String;
		var numberText:String="";
		public var countText:TextField;
		public var maxed:Boolean=false;
		
		public function GraphicDisplayBar(){
			mouseChildren=false;
			count(100,100);
		}
		
		public function count(c:Number,m:Number){
			if (isNaN(c) || isNaN(m)){
				c=0;
				m=1;
			}
			//if (c<0) c=0;
			//if (c>m) c=m;
			if (minusT!=null) minusT.text="";
			if (c<=0){
				gotoAndStop(0);
				if (minusT!=null) minusT.text=String(Math.floor(c));
			}else if (c>=m){
				gotoAndStop(100);
			}else{
				gotoAndStop(Math.ceil(c/m*100));
			}
			numberText=Math.round(c)+"/"+Math.round(m);
			if (countText!=null){
				countText.text=numberText;
			}
			maxed=false;
		}
		
		public function setTooltipName(s:String){
			tooltipName=s;
		}
		
		public function setMaxed(b:Boolean){
			if (b){
				maxed=true;
				gotoAndStop(100);
			}else{
				maxed=false;
			}
		}
		
		public function getTooltipName():String{
			if (maxed) return "MAX LEVEL";
			
			return (tooltipName+" "+numberText);
		}
		
		public function getTooltipDesc():String{
			return "";
		}
	}
}