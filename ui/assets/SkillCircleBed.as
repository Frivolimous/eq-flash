package ui.assets {
	import flash.display.MovieClip;
	
	public class SkillCircleBed extends MovieClip{
		var circles:Array=new Array(5);
		var LEFT:Number;
		var RIGHT:Number;

		public function SkillCircleBed() {
			LEFT=circle1.x;
			RIGHT=circle5.x+circle5.width;
			
			circles[0]=circle1;
			circles[1]=circle2;
			circles[2]=circle3;
			circles[3]=circle4;
			circles[4]=circle5;
		}
		
		public function setPageNumber(j:int){
			for (var i:int=0;i<5;i+=1){
				if (i==j){
					circles[i].gotoAndStop(2);
				}else{
					circles[i].gotoAndStop(1);
				}
			}
		}
		
		public function numCircles(j:int){
			for (var i:int=0;i<circles.length;i+=1){
				if (i>=j){
					if (contains(circles[i])) removeChild(circles[i]);
				}else{
					addChild(circles[i]);
				}
			}
		}

	}
	
}
