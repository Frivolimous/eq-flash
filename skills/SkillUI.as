package skills{
	import flash.display.Sprite;
	import ui.assets.PullButton;
	import system.actions.ActionBase;
	//import ui.assets.GraphicButton;
	
	public class SkillUI extends Sprite{
		public static const BED_X:Number=2;
		public static const BED_Y:Number=97;
		public static const BED_SCALE:Number=1;
		
		var pageV:SkillBed;
		var cPage:int=0;
		var origin:SpriteModel;
		var skillA:Array=new Array();
		var trees:Array=new Array();
		var classSkillDisplay:SkillTreeView;
		public var locked:Boolean=false;
		
		public function SkillUI(){
			//respecB.update(StringData.RESPEC,respecSkills);
			leftB.update(null,leftSkill);
			rightB.update(null,rightSkill);
			
			classSkillDisplay=new SkillTreeView;
			classSkillDisplay.x=10;
			classSkillDisplay.y=60;
			addChild(classSkillDisplay);
			//var respecB:GraphicButton=new GraphicButton;
			respecB.setDesc("Respec Instructions","To reset your skillpoints, go to Town then Home > Skills > Respec.");
		}
						
		public function update(_o:SpriteModel=null){
			if (_o!=null){
				origin=_o;
			}
			if (origin==null) return;
			
			//respecC.text=respecCost().toString()+" g";
			remainText.text=String(origin.skillBlock.skillPoints);
			// respecText.text=String(origin.respecsSinceAscension);
			trees=origin.skillBlock.getTreeArray();
			if (trees.length==0) trees=[0];
			skillCircles.numCircles(trees.length);
			
			if (pageV==null || cPage>=trees.length || trees[cPage]!=pageV.tree){
				page=0;
			}else{
				pageV.update(origin);
			}
		}

		public function set page(_page:int){
			if (pageV!=null){
				removeChild(pageV);
			}
			
			cPage=_page;
			
			pageV=new SkillBed(trees[cPage],skillUp);
			if (origin!=null) pageV.update(origin);
			pageV.x=BED_X;
			pageV.y=BED_Y;
			pageV.scaleY=pageV.scaleX=BED_SCALE;
			addChild(pageV);
			skillCircles.setPageNumber(cPage);
			
			classSkillDisplay.setSkillTree(origin.skillBlock.treeSkills[trees[cPage]]);
			
			pageName.text=StringData.PTITLES[trees[cPage]*3+1];
		}
		
		public function get page():int{
			return cPage;
		}
				
		public function rightSkill(){
			if (page>=trees.length-1){
				page=0;
			}else{
				page+=1;
			}
		}
		
		public function leftSkill(){
			if (page<=0){
				page=trees.length-1;
			}else{
				page-=1;
			}
		}
		
		public function skillUp(i:int){
			if (locked) return;
			if (origin.skillBlock.skillUp(i)){
				pageV.update(origin);
				remainText.text=String(origin.skillBlock.skillPoints);
				classSkillDisplay.setSkillTree(origin.skillBlock.treeSkills[trees[cPage]]);
			}
		}
		
	}
}