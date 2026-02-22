package{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import system.buffs.BuffBase;
	import system.buffs.BuffData;
	import utils.GameData;
	import flash.filters.ColorMatrixFilter;
	
	public class BuffView extends DefaultIcon{
		//public static const FRAMES_IN_ITEM_FRONT:int=109;
		//public static const FRAMES_IN_ARTIFACT:int=50;
		public static const ARTIFACT_START:int=200;
		public static const SKILL_START:int=300;
		public var model:BuffBase;
		var glowLevel:Number=0;
		//var index:int=0;
		
		public function BuffView(_model:BuffBase){
			model=_model;
			model.view=this;
			mouseChildren=false;
			name=MouseControl.EFFECT;
			
			var _index:int=_model.index;
			if (_index<ARTIFACT_START){
				//ITEMS
				vectorIcon=new ItemIcon;
				vectorIcon.back.gotoAndStop(2);
				vectorIcon.border.gotoAndStop(2);
				vectorIcon.front.gotoAndStop(_index);
				if (_model.filter!=null){
					vectorIcon.filters=[_model.filter];
				}
				makeBitmap(vectorIcon,1.5,1.5,28);
				
			}else if (_index<SKILL_START){
				//ARTIFACTS
				_index-=ARTIFACT_START-1;
				vectorIcon=new ArtifactIcons;
				vectorIcon.gotoAndStop(_index);
				vectorIcon.back.gotoAndStop(2);
				//vectorIcon.x=8;
				//vectorIcon.y=5;
				if (_model.filter!=null){
					vectorIcon.filters=[_model.filter];
				}
				makeBitmap(vectorIcon,3.2,2.8,28);
				//vectorIcon.scaleX=vectorIcon.scaleY=1.5;
			}else{
				//SKILLS
				_index-=SKILL_START-1;
				vectorIcon=new SkillIcon;
				vectorIcon.gotoAndStop(_index);
				if (_model.filter!=null){
					vectorIcon.filters=[_model.filter];
				}
				makeBitmap(vectorIcon,1.5,1.5,28);
			}
			
			//addChild(vectorIcon);
			
			//makeIcon(1,index,0x640000,0xED1C24,true);
			if (model.charges>=0){
				makeCounter(24,13,0xffffff,10);
				counter.text=String(model.charges);
			}
			if (model.maxStacks>1){
				upgrade(model.stacks/model.maxStacks);
			}
		}
		
		override public function get tooltipName():String{
			var _s:String=model.name;
			
			switch(model.type){
				case BuffBase.BUFF: _s+=" <font color="+StringData.GREEN+">[Buff]</font>"; break;
				case BuffBase.CURSE: _s+=" <font color="+StringData.RED+">[Curse]</font>"; break;
				case BuffBase.DISPLAY: _s+=" <font color='#00ffff'>[Display]</font>"; break;
			}
			if (model.maxStacks>1){
				_s+=" "+String(Math.floor(model.stacks))+"/"+String(Math.floor(model.maxStacks));
			}
			if (model.name==BuffData.XP_BOOST){
				_s+=" "+String(GameData.boost)+" left.";
			}else if (model.name==BuffData.PROGRESS_BOOST){
				_s+=" "+String(GameData.clocks)+" left.";
			}
			return _s;
		}
		
		override public function get tooltipDesc():String{
			if (_Desc==null){
				_Desc=model.getSpecialDesc();
				//_Desc=StringData.buff(model.name);
			}
			
			return _Desc+"\n\n"+model.getTooltipDesc();
		}
		
		public function newModel(_model:BuffBase){
			model=_model;
			model.view=this;
			if (counter!=null) counter.text=String(model.charges);
		}
		
		public function upgrade(_percent:Number){
			glowLevel=_percent;
			if (glowLevel>1) glowLevel=1;
			filters=[new GlowFilter(0xffff00,glowLevel,3+glowLevel*7,3+glowLevel*7,2+3+glowLevel*3,1)];
		}
	}
}