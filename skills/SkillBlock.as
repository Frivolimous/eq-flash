package skills {
	import utils.AchieveData;
	import system.actions.ActionBase;
	
	public class SkillBlock {
		public var talent:SkillModel;
		public var treeSkills:Vector.<SkillModel>=new Vector.<SkillModel>(8);
		public var skillA:Array=new Array(35);
		public var skillT:Array=new Array(9);
		public var skillPoints:int=0;
		
		var origin:SpriteModel;
		
		public function SkillBlock(_origin:SpriteModel){
			origin=_origin;
		}
		
		public function clear(){
			talent=null;
			treeSkills=new Vector.<SkillModel>(9);
			skillA=new Array(40);
			skillT=[false,false,false,false,false,false,false,false,false];
			skillPoints=0;
		}
		
		public function playerBase(){
			skillT=[true,true,true,true,true,false,false,false,false];
			talent=SkillData.loadTalent(SkillData.ORDINARY);
			for (var i:int=0;i<45;i+=1){
				skillA[i]=SkillData.loadSkill(i,0);
			}
			for (i=0;i<treeSkills.length;i+=1){
				treeSkills[i]=SkillData.treeSkill(i,0);
			}
		}
		
		public function loadCharacter(_talent:int,_skills:Array,_skillPoints:int=0,_skillT:Array=null){
			addTalent(_talent);
			loadSkills(_skills);
			
			skillPoints=_skillPoints;
			
			if (_skillT==null){
				setTrees();
			}else{
				skillT=_skillT;
				while(skillT.length<9) skillT.push(false);
			}
		}
		
		public function loadSkills(_a:Array){
			if (_a==null) return;
			var _treeSkillLevels:Array=new Array(treeSkills.length);
			for (i=0;i<treeSkills.length;i+=1){
				_treeSkillLevels[i]=0;
			}
			for (var i:int=0;i<45;i+=1){
				skillA[i]=SkillData.loadSkill(i,(_a==null?0:_a[i]));
				if (skillA[i].level>0){
					origin.statAdd(skillA[i].values);
					origin.actionList.addAction(skillA[i].action);
					_treeSkillLevels[Math.floor(i/5)]+=_a[i];
				}
			}
			
			for (i=0;i<treeSkills.length;i+=1){
				if (_treeSkillLevels[i]>0){
					treeSkills[i]=SkillData.treeSkill(i,_treeSkillLevels[i]);
					origin.statAdd(treeSkills[i].values);
				}
			}
			
			if (Facade.currentUI!=null) Facade.currentUI.updateStats();
			origin.titleCheck();
		}
		
		public function getSkillArray():Array{
			var m:Array=new Array(45);
			for (var i:int=0;i<m.length;i+=1){
				m[i]=skillA[i].level;
			}
			return m;
		}
		
		public function addSkillPoint(){
			skillPoints+=1;
		}
		
		public function subSkillPoint():Boolean{
			if (skillPoints>0){
				skillPoints-=1;
				return true;
			}else{
				return false;
			}
		}
		
		public function skillUp(i:int){
			if (skillPoints>0 && skillA[i].level<(checkTalent(SkillData.NOBLE)?7:SkillData.MAX_SKILL)){
				if (SkillData.prereq(i)==-1 || skillA[SkillData.prereq(i)].level>0){
					subSkillPoint()
			
					if (skillA[i].level>0){
						origin.statRemove(skillA[i].values);
						origin.actionList.removeAction(skillA[i].action);
					}
					skillA[i].levelUp();
					origin.statAdd(skillA[i].values);
					origin.actionList.addAction(skillA[i].action);
					
					var _cTree:int=Math.floor(i/5);
					if (treeSkills[_cTree].level>0){
						origin.statRemove(treeSkills[_cTree].values);
					}
					treeSkills[_cTree].levelUpTree();
					origin.statAdd(treeSkills[_cTree].values);
					
					origin.titleCheck();
					
					if (Facade.currentUI!=null) Facade.currentUI.updateStats();
					
					AchieveData.checkSkills(skillA);
					
					return true;
				}
			}
			return false;
		}
		
		public function skillReset(){
			for (var i:int=0;i<45;i+=1){
				if (skillA[i].level>0){
					skillPoints+=skillA[i].level;
					origin.statRemove(skillA[i].values);
					origin.actionList.removeAction(skillA[i].action);
					skillA[i].level=0;
				}
			}
			
			for (i=0;i<treeSkills.length;i+=1){
				if (treeSkills[i].level>0){
					origin.statRemove(treeSkills[i].values);
					treeSkills[i].level=0;
				}
			}
			
			if (Facade.currentUI!=null) Facade.currentUI.updateStats();
			origin.titleCheck();
		}
		
		public function addTalent(i:int){
			if (talent!=null){
				origin.statRemove(talent.values);
				switch (talent.index){
					case 3:
						origin.stats.slots=1;
						break;
					case 7:
						origin.actionList.attack.type=ActionBase.PHYSICAL;
						break;
					default:null;
				}
			}
			talent=SkillData.loadTalent(i);
			origin.statAdd(talent.values);
			switch (i){
				case 3:
					origin.stats.slots=0;
					break;
				case 7:
					origin.actionList.attack.type=ActionBase.HOLY;
					break;
				default:null;
			}
			if (talent.index>0){
				origin.title="The "+SkillData.talentName[i];
			}else{
				origin.title="";
			}
		}
		
		public function setTrees(){
			for (i=0;i<skillT.length;i+=1){
				skillT[i]=false;
			}
			for (var i:int=0;i<skillA.length;i+=1){
				if (skillA[i].level>0){
					skillT[Math.floor(i/5)]=true;
				}
			}
		}
		
		public function getTalentIndex():int{
			if (talent==null) return 0;
			return talent.index;
		}
		
		public function checkTalent(i:int):Boolean{
			if (talent.index==i) return true;
			return false;
		}
		
		public function getTreeArray():Array{
			var m:Array=[];
			for (var i:int=0;i<skillT.length;i+=1){
				if (skillT[i]){
					m.push(i);
				}
			}
			
			return m;
		}
	}
	
}
