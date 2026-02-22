package skills{
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.filters.ColorMatrixFilter;
	
	public class SkillTreeView extends SkillView{
		
		public function SkillTreeView(i:int=-1,f:Function=null){
			name=MouseControl.SKILL_TREE;
			mouseChildren=false;
			buttonMode=true;
			
			//greyOut.graphics.beginFill(0,0.5);
			//greyOut.graphics.drawRect(0,0,50,45);
			//greyOut.graphics.drawRect(1,1,40,36);
			
			
			vectorIcon=new SkillTreeIcon();
			vectorIcon.gotoAndStop(i+1);
			makeBitmap(vectorIcon,1.5,1.5,42);
			//addChild(vectorIcon);
			
			makeCounter(37,23,0xffffff,11);
			
			if (i>-1){
				index=i;
				output=f;
			}
		}
		
		public function setSkillTree(_skill:SkillModel){
			_skill=SkillData.treeSkill(_skill.index,_skill.level);
			index=_skill.index;
			level=_skill.level;
			vectorIcon=new SkillTreeIcon();
			vectorIcon.gotoAndStop(index+1);
			makeBitmap(vectorIcon,1.5,1.5,42);
			/*if (_skill.values[0][1]==StatModel.PROCS){
				label.text=_skill.values[0][2].name;
				value.text=_skill.values[0][2].level;
			}else{
				label.text=_skill.values[0][1];
				value.text=String(_skill.values[0][2]*100)+"%";
			}*/
			_Label=_Desc=null;
		}
				
		override public function update(i:int,max:int){
			level=i;
			_Label=_Desc=null;
		}
		
		override public function get tooltipName():String{
			if (_Label==null){
				_Label=StringData.PTITLES[index*3+1];
			}
			return _Label;
		}
				
		override public function get tooltipDesc():String{
			if (_Desc==null){
				_Desc=StringData.getSkillTreeDesc(this);
			}
			return _Desc;
		}
	}
}