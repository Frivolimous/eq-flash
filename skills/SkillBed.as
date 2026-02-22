/*******************************
 *
 * [][][][] 0-5
 * [][][][] 6-11
 * [][][][] 12-17
 *
 ******************************/

package skills{
	import flash.display.Sprite;

	public class SkillBed extends Sprite{
		var tree:int;
		var skillA:Array=new Array;
		var skillUp:Function;
		
		public function SkillBed(_tree:int,_skillUp:Function=null){
			tree=_tree;
			skillUp=_skillUp;
			
			switch(_tree){
				case 0:
					draw(2,6);draw(6,12);draw(2,8);draw(2,10);
					addView(SkillData.FITNESS,2);
					addView(SkillData.STRENGTH,6);
					addView(SkillData.WEAPON_SKILL,8);
					addView(SkillData.TOUGHNESS,10);
					addView(SkillData.LEAP,12);
					break;
				case 1:
					draw(1,6);draw(1,8);draw(4,10);
					addView(SkillData.UNARMED,1);
					addView(SkillData.FLURRY,6);
					addView(SkillData.KI_STRIKE,8);
					addView(SkillData.PURITY,4);
					addView(SkillData.DTHROW,10);
					break;
				case 2:
					draw(2,7);draw(2,9);draw(7,13);draw(9,15);
					addView(SkillData.MAGIC_APTITUDE,2);
					addView(SkillData.FOCUS,7);
					addView(SkillData.VESSEL,9);
					addView(SkillData.TURNING,13);
					addView(SkillData.ATTUNEMENT,15);
					break;
				case 3:
					draw(1,6);draw(1,8);draw(8,14);
					addView(SkillData.PRECISION,1);
					addView(SkillData.GADGETEER,4);
					addView(SkillData.VITAL,6);
					addView(SkillData.WITHDRAW,14);
					addView(SkillData.BATTLE_AWARENESS,8);
					break;
				case 4:
					draw(0,6);draw(4,10);
					addView(SkillData.IRON_GUT,0);
					addView(SkillData.DEADLY_ALCH,4);
					addView(SkillData.CRAFTING,2);
					addView(SkillData.DETERMINED,6);
					addView(SkillData.RADIATE,10);
					break;
				case 5:
					draw(2,7);draw(2,10);draw(7,12);draw(7,14);
					addView(SkillData.PACT,2);
					addView(SkillData.BINDING,7);
					addView(SkillData.DRAW_POWER,10);
					addView(SkillData.DEPTHS,12);
					addView(SkillData.ECCHO,14);
					break;
				case 6:
					draw(2,6);draw(2,10);draw(2,13);draw(2,15);
					addView(SkillData.INITIATE,2);
					addView(SkillData.SMITE,6);
					addView(SkillData.ALLY,10);
					addView(SkillData.GUARD,13);
					addView(SkillData.PROTECTION,15);
					break;
				case 7:
					draw(2,7);draw(2,9);
					addView(SkillData.ONE_SHADOWS,2);
					addView(SkillData.DEADLY_SHADOWS,7);
					addView(SkillData.DANCING_SHADOWS,9);
					addView(SkillData.ASSASSINATE,0);
					addView(SkillData.DEFENSIVE_ROLL,4);
					break;
				case 8:
					draw(1,7);draw(7,12);draw(7,14);
					addView(SkillData.WILDERNESS,4);
					addView(SkillData.FURIOUS,1);
					addView(SkillData.LASTING_ANGER,7);
					addView(SkillData.BLOODLUST,12);
					addView(SkillData.UNSTOPPABLE,14);
					break;
			}
		}
		
		public function update(_origin:SpriteModel){
			if (_origin!=null){
				for (var i:int=0;i<skillA.length;i+=1){
					skillA[i].update(_origin.skillBlock.skillA[skillA[i].index].level,_origin.skillBlock.getTalentIndex()==SkillData.NOBLE?7:10);
				}
				
				for (i=0;i<skillA.length;i+=1){
					if (skillA[i].level==0){
						if (SkillData.prereq(skillA[i].index)==-1 || _origin.skillBlock.skillA[SkillData.prereq(skillA[i].index)].level>0){
							skillA[i].addGrey(true);
						}else{
							skillA[i].addGrey(false);
						}
					}
				}
			}
			//graphics.beginFill(0x331100);
			//graphics.drawRect(0,0,210,180);
		}
		
		public function draw(_o:int,_t:int){
			graphics.lineStyle(1,0xffffff);
			graphics.moveTo(36+(_o%6)*24,25.6+Math.floor(_o/6)*42.4);
			graphics.lineTo(36+(_t%6)*24,25.6+Math.floor(_t/6)*42.4);
		}
		
		public function addView(_index:int,_loc:int){
			var _skill:SkillView=new SkillView(_index,skillUp);
			skillA.push(_skill);
			
			_skill.x=16+(_loc%6)*24;
			_skill.y=8+Math.floor(_loc/6)*42.4;
			addChild(_skill);
		}
	}
}