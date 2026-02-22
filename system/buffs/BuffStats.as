package system.buffs{
	import system.effects.EffectData;
	import system.effects.EffectBase;
	import utils.GameData;
	
	public class BuffStats extends BuffBase{
		public var values:Array;
		
		public function BuffStats(_index:int,_name:String,_level:int,_type:int,_charges:int,_values:Array=null,_maxStacks:int=1){
			name=_name
			index=_index;
			level=_level;
			type=_type;
			_Charges=_charges;
			values=_values;
			maxStacks=_maxStacks;
		}
		
		
		override public function modify(_v:SpriteModel,_moreMult:Number=1):BuffBase{
			var m:BuffBase=clone();
			if (name!=BuffData.DYING && name!=BuffData.UNDYING){
				m.modifyThis(_v,_moreMult);
			}
			return m;
		}
		
		override public function clone():BuffBase{
			var m:BuffStats=new BuffStats(index,name,level,type,charges,cloneValues(),maxStacks);
			return m;
		}
		
		override public function addStacksFrom(_removed:BuffBase){
			if (_removed is BuffStats){
				if (_removed.stacks<maxStacks){
					values[0][2]+=(_removed as BuffStats).values[0][2];
				}else{
					values[0][2]=(_removed as BuffStats).values[0][2];
				}
			}
			super.addStacksFrom(_removed);
		}
		
		override public function wasAddedTo(_v:SpriteModel,_existing:BuffBase=null){
			if (_existing!=null){
				_v.statRemove((_existing as BuffStats).values);
				
				if (_existing.view!=null) _existing.view.newModel(this);
				if (maxStacks>1){
					addStacksFrom(_existing);
				}
			}else{
				if (name==BuffData.SUPER_SAYAN){
					_v.buffList.removeBuffCalled(BuffData.SAYAN);
				}else if (name==BuffData.SUPER_SAYAN2){
					_v.buffList.removeBuffCalled(BuffData.SAYAN);
				}else if (name==BuffData.SUPER_SAYAN3){
					_v.buffList.removeBuffCalled(BuffData.SAYAN);
				}else if (name==BuffData.SAYAN){
					_v.buffList.removeBuffCalled(BuffData.SUPER_SAYAN);
					_v.buffList.removeBuffCalled(BuffData.SUPER_SAYAN2);
					_v.buffList.removeBuffCalled(BuffData.SUPER_SAYAN3);
				}
			}
			
			_v.statAdd(values);
		}
		
		override public function wasRemovedFrom(_v:SpriteModel){
			_v.statRemove(values);
			
			if (name==EffectData.UNDYING){ //activated???
				if (_v.exists && !_v.dead && _v.getHealth()<=0){
					_v.buffList.addBuff(BuffData.makeBuff(BuffData.DYING,1));
				}
			}
		}
		
		override public function getDesc():String{
			var m:String=name;
			
			if (name==BuffData.AIMING){
				//return StringData.statDesc(values,_tabs);
				return StringData.statDesc(values,1);
			}
			
			if (name==BuffData.SMITE_PROC){
				return EffectData.SMITE+": every <font color="+StringData.RED+"><b>"+maxStacks+"</b></font> turns deal <font color="+StringData.RED+"><b>"+String(Math.floor(values[0][2].damage))+" HOLY</b></font> dmg.";
			}
			if (name==BuffData.MASSIVE_BLOW_PROC){
				return BuffData.MASSIVE_BLOW_PROC+"\n Base Damage <font color="+StringData.RED+"><b>+"+String(Math.floor(values[0][2]*100))+"%</b></font>\n  every <font color="+StringData.RED+"><b>"+maxStacks+"</b></font> attacks.";
			}
			if (charges>0){
				m+="<font color="+StringData.RED+">x"+charges+"</font>\n";
			}else{
				m+="\n";
			}
			//if (values.length>0) m+=StringData.statDesc(values,_tabs+1);
			if (values.length>0) m+=StringData.statDesc(values,2);
			if (maxStacks>1){
				m+="\nMax Stacks: <font color="+StringData.RED+"><b>"+String(Math.floor(maxStacks))+"</b></font>";
			}
			return m;
		}
		
		override public function getTooltipDesc():String{
			return StringData.statDesc(values);
		}
		
		function cloneValues():Array{
			var m:Array=new Array();
			for (var i:int=0;i<values.length;i+=1){
				m.push([values[i][0],values[i][1],(values[i][2] is EffectBase)?values[i][2].clone():values[i][2]]);
			}
			return m;
		}
		
		override public function getEffectDesc():String{
			switch(name){
				case BuffData.MASSIVE_BLOW_PROC: return "Every number of attacks, deal greatly increased Base Damage.";
				case BuffData.MARKED: return "Reduce enemy Dodge and Resistances.";
				case BuffData.SMITE_PROC: return "Deal massive Holy Damage when you deal damage every number of rounds.";
				
				case BuffData.SLOW: return "Reduce enemy initiative and dodge rate.";
				
				case BuffData.INITIAL_BLESS: return "Buffs you for a number of turns.";
				case BuffData.INITIAL_CURSE: return "Curses your enemy for a number of turns.";
				case BuffData.UNDYING: 
				case BuffData.DYING: return "Can survive below 0 health for a number of turns.";
				
				case BuffData.WEAKENED: return "Reduce enemy direct damage.";
				case BuffData.HEAL_NO: return "Significantly reduce enemy healing.";
				case BuffData.VULNERABLE: return "Reduce enemy resistances.";
				case BuffData.VULNERABLE2: return "Reduce enemy physical resistance.";
				case BuffData.SCORCHED: 
				case BuffData.ILLUMINATED: return "Reduce enemy Spirit Resistance.";
				case BuffData.WHISPERED: return "Reduce enemy Resistance to Magic, Chemical and Spirit.";
				case BuffData.BLIND: case BuffData.CURSED: return "Reduce enemy Hit Rate.";
				case BuffData.RESPECT: return "Reduce Enemy Dodge and Nullify.";
				case BuffData.AUTHORITAH: return "Reduce enemy Base Damage for their next action.";
				case BuffData.HIGH: return "Increase your Health and Mana Regeneration.";
				case BuffData.SUPER_SAYAN: return "power up!";
			}
			return getSpecialDesc();
		}
		
		override public function getSpecialDesc():String{
			switch(name){				
				case BuffData.CRIT_ACCUM: return "Gain a stacking Crit Rate bonus every time you fail to crit.";
				
				case BuffData.EMPOWERED: return "Increase Magic power.";
				case BuffData.EMPOWERED2: return "Increase Strength";
				case BuffData.EMPOWERED3: return "Increase Initiative";
				case BuffData.HASTENED: return "Increase Initiative and Dodge Rate";
				case BuffData.SLOW: return "Has initiative and dodge rate reduced.";
				
				case BuffData.ENCHANTED: return "Add magic damage on every attack.";
				case BuffData.ENCHANTED2: return "Add holy damage on every attack.";
				case BuffData.ENCHANTED3: return "Add physical damage, Hit and Crit.";
				case BuffData.SMITE_PROC: return "Deal massive Holy Damage when you deal damage.";
				
				case BuffData.STRENGTHEN: return "Make you stronger and deal more damage.";
				
				case BuffData.BUFF_POT: return "Empower you through alchemical wonders.";
				case BuffData.CELERITY_POT: return "Accelerate you through Science!";
				case BuffData.TURTLE_POT: return "Increase your defenses and give you a bit of Return Damage.";
				case BuffData.PURITY_POT: return "Simulate enlightenment with fancy drugs.";
				
				case BuffData.MOVE_BOOST: return "Increase your stats after using a Movement Ability.";
				
				case BuffData.COMBO: return "Increase further damage this round.";
				case BuffData.COMBO_DEFENSE: return "Increases your defenses.";
				case BuffData.COOLDOWN: return "Reduce your stats temporarily.";/**/
				
				case BuffData.GRAILED: return "Increase Health Regeneration by a significant amount.";
				case BuffData.SAYAN: return "Normal mode";
				case BuffData.SUPER_SAYAN: case BuffData.SUPER_SAYAN2: case BuffData.SUPER_SAYAN3: return "Powered up!";
				
				case BuffData.BERSERK: return "Increase your strength but makes you unable to do any complicated actions.";
				case BuffData.TAUNT: return "Reduces Strength and Hitrate but increases Tenacity.  Also causes an inability to do complicated actions.";
				
				case BuffData.RUSHED: return "Your next attack is made with a penalty to hit your opponent.";
				case BuffData.QUICK: return "make a bonus attack.";
				case BuffData.AIMING: return "Your next attack is made with a bonus to hit your opponent.";
				case BuffData.LEAP_ATTACK: return "Leap at your opponent with increased base weapon damage.";
				
				case BuffData.WEAKENED: return "Has decreased damage.";
				case BuffData.HEAL_NO: return "Has significantly reduced healing.";
				case BuffData.VULNERABLE: return "Has resistances decreased.";
				case BuffData.VULNERABLE2: return "Has physical resistance decreased.";
				case BuffData.SCORCHED: 
				case BuffData.ILLUMINATED: return "Reduced Spirit Resistance.";
				case BuffData.WHISPERED: return "Reduced Enemy Resistance to Magic, Chemical and Spirit.";
				case BuffData.CURSED: return "Has a reduced Hit Rate.";
				case BuffData.BLIND: return "Your eyes blur making it difficult to hit your target.";
				case BuffData.RESPECT: return "Reduced Dodge and Nullify when you defend.";
				case BuffData.AUTHORITAH: return "Deals reduced Base Damage for next action.";
				case BuffData.ATTACK_IGNORED: return "You have already ignored an attack this fight.";
				case BuffData.HIGH: return "Your Health and Mana Regen are increased.";
				case BuffData.MARKED: return "Has reduced Dodge and Critical Resistance.";
				case BuffData.STEALTH: return "Has increased Dodge, CRate and CMult.  Stealth is lost when you make an offensive action, are Cursed or Injured.";
				
				case BuffData.CANNIBALISM: return "Greatly increases your lifesteal, hitrate and accuracy for one attack this round.";
				case BuffData.UNTRAPPABLE: return "Greatly increases your Tenacity, allowing you to act through stuns, silences, fear, etc.";
			}
			
			return "Alters your base stats.";
		}
	}
}