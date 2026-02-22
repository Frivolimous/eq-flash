package skills{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import ui.assets.PullButton;
	import ui.windows.ConfirmWindow;
	import utils.GameData;
	import system.actions.ActionBase;
	
	public class SimpleSkillUI extends Sprite{
		public static const BED_X:Number=39;
		public static const BED_Y:Number=98;
		public static const BED_SCALE:Number=1;
		
		//public var pages:Array=new Array;
		//var _Page:int=0;
		var pageV:SkillBed;
		var cPage:int=0;
		var origin:SpriteModel;
		var skillA:Array=new Array();
		var trees:Array=new Array();
		public var locked:Boolean=false;
		public var noCost:Boolean=false;
		
		public var rerespec:Boolean=false;
		
		var classSkillDisplay:SkillTreeView;

		public function SimpleSkillUI(){
			respecB.update(StringData.RESPEC,respecSkills);
			leftB.update(null,leftSkill);
			rightB.update(null,rightSkill);
			
			classSkillDisplay=new SkillTreeView;
			classSkillDisplay.x=42;
			classSkillDisplay.y=250;
			addChild(classSkillDisplay);
			//page=0;
		}
						
		public function update(_o:SpriteModel=null){
			if (_o!=null){
				origin=_o;
			}
			if (origin==null) return;
			
			respecC.text=respecCost().toString()+" g";
			remainText.text=String(origin.skillBlock.skillPoints);
			trees=origin.skillBlock.getTreeArray();
			if (trees.length==0) trees=[0];
			skillCircles.numCircles(trees.length);
			
			if (pageV==null || cPage>=trees.length || trees[cPage]!=pageV.tree){
				page=0;
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
		
		public function respecSkills(){
			if (locked) return;
			if (origin==null) return;
			if (GameData.gold>=respecCost()){
				GameData.gold-=respecCost();
				origin.skillBlock.skillReset();
				if (!rerespec) origin.respecsSinceAscension+=1;
				rerespec=true;
				pageV.update(origin);
				classSkillDisplay.setSkillTree(origin.skillBlock.treeSkills[trees[cPage]]);
				addChild(new SkillTreeSelect(origin,update));
			}else{
				new ConfirmWindow("Not enough gold!");
			}
			
			//update();
		}
		
		public function respecCost():Number{
			if (origin==null || origin.skillBlock.checkTalent(SkillData.ORDINARY)) return 0;
			if (origin.saveSlot<0 || origin.saveSlot>=5) return 0;
			if (noCost) return 0;
			if (rerespec) return 0;
			
			return (origin.level-origin.skillBlock.skillPoints)*(origin.level-origin.skillBlock.skillPoints)*7;
		}

	}
}