package skills{
	import system.actions.ActionBase;
	
	public class SkillModel{
		public var index:int,
				 level:int=-1,
				 action:ActionBase,
				 values:Array=[];
							 
		public function levelUp(){
			level+=1;
			var _skill:SkillModel=SkillData.loadSkill(index,level);
			values=_skill.values;
			action=_skill.action;
		}
		
		public function levelUpTree(){
			level+=1;
			var _skill:SkillModel=SkillData.treeSkill(index,level);
			values=_skill.values;
			action=_skill.action;
		}
	}
}