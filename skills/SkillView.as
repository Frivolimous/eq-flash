package skills{
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.filters.ColorMatrixFilter;
	
	public class SkillView extends DefaultIcon{
		var greyOut:Sprite=new Sprite;
		
		public function SkillView(i:int=-1,f:Function=null){
			if (i>-1){
				name=MouseControl.SKILL_TREE;
				mouseChildren=false;
				buttonMode=true;
				
				greyOut.graphics.beginFill(0,0.5);
				//greyOut.graphics.drawRect(0,0,50,45);
				greyOut.graphics.drawRect(1,1,40,36);
				
				vectorIcon=new SkillIcon();
				vectorIcon.gotoAndStop(i+1);
				makeBitmap(vectorIcon,1.5,1.5,42);
				//addChild(vectorIcon);
				
				makeCounter(37,23,0xffffff,11);
				
				index=i;
				output=f;
			}
		}
		
		public function get level():int{
			return int(counter.text);
		}
		
		public function set level(i:int){
			if (i<10){
				counter.text="0"+i;
			}else{
				counter.text=String(i);
			}
		}
		
		public function update(i:int,max:int){
			transform.colorTransform=new ColorTransform(1,1,1);
			if (contains(greyOut)){
				removeChild(greyOut);
			}
			level=i;
			if (i>=max){
				transform.colorTransform=new ColorTransform(2,2,2);
			}
			_Label=_Desc=null;
		}
				
		public function addGrey(b:Boolean){
			if (b){
				greyOut.graphics.clear();
				greyOut.graphics.beginFill(0,0.4);
				greyOut.graphics.drawRect(1,1,40,36);
				addChild(greyOut);
			}else{
				greyOut.graphics.clear();
				greyOut.graphics.beginFill(0,0.8);
				greyOut.graphics.drawRect(1,1,40,36);
				addChild(greyOut)
			}
		}
		
		override public function get tooltipName():String{
			if (_Label==null){
				_Label=StringData.getSkillName(this);
			}
			return _Label;
		}
				
		override public function get tooltipDesc():String{
			if (_Desc==null){
				_Desc=StringData.getSkillDesc(this);
			}
			return _Desc;
		}
	}
}