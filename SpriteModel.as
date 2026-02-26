package{
	import flash.utils.Dictionary;
	import flash.display.BitmapData;
	import skills.SkillModel;
	import skills.SkillData;
	import items.ItemModel;
	import items.ItemData;
	import ui.assets.AchievementDisplay;
	import artifacts.ArtifactModel;
	import flash.display.Sprite;
	import flash.display.IBitmapDrawable;
	import ui.effects.FlyingText;
	import limits.LimitModel;
	import limits.LimitData;
	import gameEvents.GameEvent;
	import gameEvents.GameEventManager;
	import system.buffs.BuffList;
	import system.buffs.BuffData;
	import system.actions.*
	import system.effects.EffectBase;
	import system.effects.EffectData;
	import skills.SkillBlock;
	import system.effects.EffectBuff;
	import items.ItemUnarmed;
	import utils.GameData;
	import utils.AchieveData;
	
	public class SpriteModel{
		
		public static const STAT:String="stats",
							ATTACK:String="Attack",
							UNARMED:String="Unarmed",
							UNARMORED:String="Unarmored",
							ACTION:String="Action",
							EFFECT:String="Effect";
							
		public var label:String, level:int, title:String="";
		public var mainClass:int;
		
		public var stats:StatModel=new StatModel;
		public var _Health:Number, _Mana:Number;
		
		public var equipment:Vector.<ItemModel>=new Vector.<ItemModel>(5);
		public var belt:Vector.<ItemModel>=new Vector.<ItemModel>(5);
		public var inventory:Vector.<ItemModel>=new Vector.<ItemModel>(20);
		public var arts:Array=new Array(5);
		public var limitEquip:Array=new Array(3);
		public var limitStored:Array=new Array(10);
		
		public var unarmed:ItemModel,
					unarmored:Array;
					
					
		public var actionList:ActionList=new ActionList;
		public var buffList:BuffList;
		
		public var toApply:Array=new Array();
		
		public var tFunction:Function;
		public var tTarget:SpriteModel;
		public var tAction:ActionBase;
		public var tValue:String;
		
		public var view:SpriteView;
		
		public var skillBlock:SkillBlock;
		public var craftB:Number=0;
		public var smiteB:int=0;
		
		public var _XP:Number=0;
		public var maxXP:Number;
		
		public var flags:Array;
		public var challenge:Array=[0,0];
		public var saveSlot:int=-1;
		public var updateUI:Boolean;
		public var player:Boolean;
		public var exists:Boolean;
		public var strike:int=0;
		public var shots:int=0;
		public var doneTurn:Boolean=true;
		
		public var stash:Array=[];
		public var lastSold:Array;
		
		public var cosmetics:Array=[-1,-1,-1,-1,-1,-1,-1,-1];
		
		public var dead:Boolean=false;
		public var deathsSinceAscension:int=0;
		public var respecsSinceAscension:int=0;
		public var attackTarget:SpriteModel;
		
		public function set eDistance(s:String){
			Facade.gameM.distance=s;
		}
		
		public function get eDistance():String{
			return Facade.gameM.distance;
		}
		
		public function SpriteModel(){
			view=new SpriteView(this);
			skillBlock=new SkillBlock(this);
			buffList=new BuffList(this);
			//newPlayer(false);
		}
		
		public function newMonster(){
			clearStats();
			updateUI=false;
			player=false;
			maxHM();
		}
				
		public function newPlayer(_updateUI:Boolean=true){
			clearStats();
			player=true;
			updateUI=_updateUI;
			stats.playerBase();
			skillBlock.playerBase();
			view.newPlayer(_updateUI);
			stash=[true,true,new Array(20)];
			maxHM();
		}
		
		public function clearStats(){
			label="";
			level=1;
			stats.clear();
			skillBlock.clear();
			
			equipment=new Vector.<ItemModel>(5);
			belt=new Vector.<ItemModel>(5);
			inventory=new Vector.<ItemModel>(20);
			arts=[false,false,false,false,false];
			buffList.reset();
			//limitEquip=[0];
			//limitStored=new Array(10);
			//for (var i:int=0;i<5;i+=1){
				//limitStored[i]=LimitData.spawnLimit(i+1);
			//}
			_XP=0;
			craftB=smiteB=0;
			unarmored=[];
			clearTimer();
			tValue=null;
			exists=true;
			doneTurn=true;
			dead=false;
			
			actionList.attack=ActionData.makeAttack();
			unarmed=new ItemUnarmed();
			actionList.attack.source=unarmed;
			equipment[0]=unarmed;
			
			actionList.clear(unarmed.action);
			
			maxXP=3;
			saveSlot=-1;
			challenge=[0,0];
			flags=new Array();
			cosmetics=[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
		}
		
		public function endTimer(){
			var _tF:Function=tFunction;
			var _tA:ActionBase=tAction;
			var _tT:SpriteModel=tTarget;
			
			clearTimer();
			if (_tA!=null && _tA.specialEffect==ActionBase.GAIA){
				var _special:Sprite=new GaiaSongEffect;
				_special.x=view.display.castPoint.x;
				_special.y=view.display.castPoint.y;
				view.addChild(_special);
			}
			if (_tF!=null){
				_tF(this,_tT);
			}
		}
		
		public function clearTimer(){
			//strike=0;
			tFunction=null;
			tAction=null;
			tTarget=null;
		}
		
		public function healthDamage(_dmg:Number){
			_dmg=Facade.effectC.reduceDamage(this,_dmg,_Health);
			if (Facade.gameM.distance==GameModel.BETWEEN){
				if (_Health-_dmg<=0){
					setHealth(1);
					return;
				}
			}
			setHealth(_Health-_dmg);
		}
		
		public function healthHeal(n:Number){
			setHealth(_Health+n);
		}
		
		public function setHealth(n:Number){
			_Health=Math.min(stats.getValue(StatModel.HEALTH),n);
			//_Health=n;
			//if (_Health>stats.getValue(StatModel.HEALTH)) _Health=stats.getValue(StatModel.HEALTH);
			if (view.healthBar!=null)
				view.healthBar.count(_Health,stats.getValue(StatModel.HEALTH));
		}
		
		public function getHealth():Number{
			var i:int=_Health;
			//if (isNaN(_Health)) i=0;
			return i;
		}
		
		public function healthPercent():Number{
			return _Health/stats.getValue(StatModel.HEALTH);
		}
		
		public function manaPercent():Number{
			return _Mana/stats.getValue(StatModel.MANA);
		}
		
		public function set mana(n:Number){
			_Mana=n;
			if (_Mana>stats.getValue(StatModel.MANA)) _Mana=stats.getValue(StatModel.MANA);
			if (_Mana<0) _Mana=0;
			if (view.manaBar!=null)	view.manaBar.count(_Mana,stats.getValue(StatModel.MANA));
		}
		
		public function get mana():Number{
			return _Mana;
		}
		
		public function set fury(n:Number){
			stats.cfury=Math.max(Math.min(n,stats.getValue(StatModel.FURY)),0);
		}
		
		public function get fury():Number{
			return stats.cfury;
		}
		
		public function addFury(n:Number){
			n=Math.min(n,furyLeftToGain);
			furyLeftToGain-=n;
			fury+=n;
		}
		
		public function maxHM(){
			dead=false;
			setHealth(stats.getValue(StatModel.HEALTH));
			mana=stats.getValue(StatModel.MANA);
		}
		
		public var furyLeftToGain:int=0;
		const FURY_GAIN:int=30;
		
		public function regen(){
			if (!dead){
				healthHeal(stats.getValue(StatModel.HREGEN)*stats.getValue(StatModel.HEALTH));
				mana+=stats.getValue(StatModel.MREGEN)*stats.getValue(StatModel.MANA);
				fury*=(1-stats.getValue(StatModel.FURY_DECAY));
				furyLeftToGain=FURY_GAIN;
			}
		}
		
		public function set xp(n:Number){
			if (level>=getMaxLevel()) return;
			
			_XP=n;
			setMaxXP();
			while (_XP>=maxXP && level<getMaxLevel()){
				levelup();
			}
		}
		
		public function get xp():Number{
			return _XP;
		}
		
		public function levelup(){
			Facade.soundC.playEffect(SoundControl.LEVEL);
			xp-=maxXP;
			level+=1;
			GameEventManager.addGameEvent(GameEvent.LEVEL_UP,{player:this, newLevel:level});
			skillBlock.addSkillPoint();
			if (level==3) skillBlock.addSkillPoint();
			if (skillBlock.checkTalent(SkillData.NOBLE) && (level%12)==0) skillBlock.addSkillPoint();
			new FlyingText(this,FlyingText.LEVEL_UP,0x0000ff);
			setMaxXP();

			if (saveSlot>=0 && saveSlot<5){
				GameData.setHigherScore(GameData.SCORE_LEVEL,level);
				if (level>=60){
					(skillBlock.getTalentIndex()+AchieveData.ACHIEVE_ORDINARY_COSMO);
				}
			}
		}
		
		public function getMaxLevel():int{
			return GameData.getMaxLevel();
		}
		
		public function setMaxXP(_level:int=-1){
			if (_level==-1) _level=level;
			if (level<getMaxLevel()){
				if (level==1){
					maxXP=3;
				}else if (level==2){
					maxXP=6;
				}else if (level<40){
					maxXP=Math.floor(level*2.2);
				}else if (level<60){
					maxXP=Math.floor(level*((level-35)/2));
				}else{
					maxXP=Math.floor(level*level/2);
				}
			}else{
				maxXP=_XP=0;
			}
		}

		public function titleCheck(){
			if (saveSlot>4){
				title="The "+SkillData.talentName[skillBlock.getTalentIndex()];
				return;
			}
			
			mainClass=-1;
			var class2:int=-1;
			
			var _points:Array=SkillData.getTreeAssignment(skillBlock.skillA);
			for (var i=0;i<SkillData.NUM_TREES;i+=1){
				if (_points[i]>=1){
					if ((mainClass==-1)||(_points[i]>_points[mainClass])){
						if ((class2==-1)||(_points[mainClass]>_points[class2])){
							class2=mainClass;
						}
						mainClass=i;
					}else{
						if ((class2==-1)||(_points[i]>_points[class2])){
							class2=i;
						}
					}
				}
			}
			
			var _title1:String;
			var _title2:String;
			if (mainClass>-1){
				if (_points[mainClass]>=20){
					_title1=StringData.PTITLES[mainClass*3+1];
				}else if (_points[mainClass]>=5){
					_title1=StringData.PTITLES[mainClass*3];
				}
			}
			if (class2>-1){
				if (_points[class2]>=10 && _points[mainClass]>=20){
					_title1=StringData.PTITLES2[mainClass][class2];
					_title2=null;
				}else if (_points[class2]>=6){
					_title2=StringData.PTITLES[class2*3+2];
				}
			}
			
			var s:String="";
			if (skillBlock.getTalentIndex()>0){
				s+=" "+SkillData.talentName[skillBlock.getTalentIndex()];
			}
			if (_title2!=null){
				s+=" "+_title2;
			}
			if ((_title1!=null)&&(_title1!="Nobody")){
				s+=" "+_title1;
			}
			if (s.length>0){
				s="The"+s;
			}
			title=s;
		}
		
		public function addItem(_item:ItemModel):Boolean{
			for (var i:int=0;i<20;i+=1){
				if (inventory[i]==null){
					inventory[i]=_item;
					return true;
				}
			}
			return false;
		}
		
		public function removeItem(_v:ItemModel){
			for (var i:int=0;i<5;i+=1){
				if (equipment[i]==_v){
					removeItemAt(i);
					return;
				}else if (belt[i]==_v){
					removeItemAt(i+5);
					return;
				}
			}
			for (i=0;i<20;i+=1){
				if (inventory[i]==_v){
					removeItemAt(i+10);
				}
			}
		}
		
		public function addItemAt(_item:ItemModel,i:int){
			//previous item is already REMOVED; slot is occupied by nothing.
			if (i<5){
				if (i==0){					
					if (_item.secondary!=ItemData.UNARMED){
						statRemove(unarmed.values);
						actionList.removeAction(unarmed.action);
					}
					if (_item.name==ItemData.UNARMED){
						equipment[i]=null;
					}else{
						equipment[i]=_item;
						statAdd(_item.values);
						if (_item.action!=null) actionList.addAction(_item.action);
					}
					view.updateWeapon(_item);
				}else if (i==1){
					equipment[i]=_item;
					stats.addValue(StatModel.HEALTH,_item.values[0][2]*stats.getValue(StatModel.ARMORTOHEALTH));
					statAdd(_item.values);
					actionList.addAction(_item.action);
					if (_item.secondary!=ItemData.UNARMORED){
						statRemove(unarmored);
					}
					view.updateHelmet(_item);
				}else{
					equipment[i]=_item;
					if (stats.slots>=(i-1)){
						statAdd(_item.values);
						actionList.addAction(_item.action);
					}
				}
				if (Facade.currentUI!=null) Facade.currentUI.updateStats();
			}else if(i<10){
				belt[i-5]=_item;
				statAdd(_item.values);
				actionList.addAction(_item.action);
				if (_item.hasTag(EffectData.RELIC)){
					view.updateRelic(_item.index,_item.enchantIndex);
				}
				if (Facade.currentUI!=null) Facade.currentUI.updateStats();
			}else{
				inventory[i-10]=_item;
			}
		}
		
		public function removeItemAt(i:int){
			if (i<5){
				if (equipment[i]==null) return;
				if (i==1){
					stats.subValue(StatModel.HEALTH,equipment[i].values[0][2]*stats.getValue(StatModel.ARMORTOHEALTH));
				}
				statRemove(equipment[i].values);
				actionList.removeAction(equipment[i].action);
				
				if (i==0){
					actionList.defaultAttack();
					//attack.source=unarmed;
					if (equipment[0].secondary!=ItemData.UNARMED){
						statAdd(unarmed.values);
						
					}
					view.updateWeapon();
					equipment[0]=unarmed;
				}else if (i==1){
					view.updateHelmet();
					if (equipment[1].secondary!=ItemData.UNARMORED){
						statAdd(unarmored);
					}
					equipment[i]=null;
				}else{
					equipment[i]=null;
				}
				if (Facade.currentUI!=null) Facade.currentUI.updateStats();
			}else if (i<10){
				if (belt[i-5]==null) return;
				if (belt[i-5].hasTag(EffectData.RELIC)){
					view.updateRelic(-1);
				}
				statRemove(belt[i-5].values);
				actionList.removeAction(belt[i-5].action);
				belt[i-5]=null;
				
				if (Facade.currentUI!=null) Facade.currentUI.updateStats();
			}else{
				if (inventory[i-10]==null) return;
				inventory[i-10]=null;
			}
		}
		
		public function onTurnStart(_double:Boolean){
			craftBelt();
			regen();
			if (_double){
				craftBelt();
				regen();
			}
			
			buffList.updateBuff();
			/*for (var i:int=0;i<gameM.playerM.limitEquip.length;i+=1){
				if (limitEquip[i] is LimitModel){
					limitEquip[i].charges+=1;
				}
			}*/
		}
		
		public function craftBelt(){
			craftB+=stats.getValue(StatModel.CRAFT_BELT);
			if (craftB>100){
				craftB-=100;
				increaseBeltStack(1);
			}
			
			var _effect:EffectBase=stats.findDisplay(EffectData.SMITE);
			if (_effect!=null && !buffList.hasBuff(BuffData.SMITE_PROC)){
				smiteB-=1;
				if (smiteB<=0){
					smiteB=_effect.userate;
					buffList.addBuff((_effect as EffectBuff).buff.modify(this));
				}
			}
		}
		
		public function increaseBeltStack(_bonus:int){
			var _toFill:ItemModel;
			var _toFillPercent:Number=0;
			for (var i:int=0;i<belt.length;i+=1){
				if (belt[i]!=null && belt[i].charges>=0){
					var _max:Number=belt[i].maxCharges();
					if (belt[i].charges<_max && (((belt[i].charges/_max) < _toFillPercent) || _toFill==null)){
						_toFill=belt[i];
						_toFillPercent=belt[i].charges/_max;
					}
				}
			}
			
			
			if (_toFill!=null){
				_max=_toFill.maxCharges();
				_toFill.charges+=Math.ceil(_max/9)*_bonus;
				if (_toFill.charges>_max) _toFill.charges=_max;
			}
		}
		
		public function isUnarmed():Boolean{
			if (equipment[0]==null || equipment[0].name==ItemData.UNARMED || equipment[0].secondary==ItemData.UNARMED){
				return true;
			}else{
				return false;
			}
		}
		
		public function isUnarmored():Boolean{
			if (equipment[1]==null || equipment[1].secondary==ItemData.UNARMORED || stats.findDisplay(EffectData.UNARMORED)!=null){
				return true;
			}else{
				return false;
			}
			
		}
		
		public function isMelee():Boolean{
			switch(mainClass){
				case SkillData.WARRIOR: case SkillData.MONK: case SkillData.PALADIN:
					return true;
				default: return false;
			}
		}
		
		public function addLimit(_item:LimitModel){
			for (var i:int=0;i<limitStored.length;i+=1){
				if (limitStored[i]==null){
					limitStored[i]=_item;
					return;
				}
			}
		}
		
		public function addLimitAt(_item:*,i:int){
			if (i<3){
				limitEquip[i]=_item;
			}else{
				limitStored[i-3]=_item;
			}
		}
		
		public function removeLimitAt(i:int){
			if (i<3){
				limitEquip[i]=null
			}else{
				limitStored[i-3]=null;
			}
		}
		
		public function addArtifactAt(_item:ArtifactModel,i:int){
			arts[i]=_item;
			if (_item.values.length>0 && _item.values[0][1]==StatModel.ARMORTOHEALTH){
				if (equipment[1]!=null && equipment[1].values[0][1]==StatModel.HEALTH){
					stats.subValue(StatModel.HEALTH,equipment[1].values[0][2]*stats.getValue(StatModel.ARMORTOHEALTH));
				}
			}
			
			statAdd(_item.values);
			actionList.addAction(_item.action);
			
			if (_item.values.length>0 && _item.values[0][1]==StatModel.ARMORTOHEALTH){
				if (equipment[1]!=null && equipment[1].values[0][1]==StatModel.HEALTH){
					stats.addValue(StatModel.HEALTH,equipment[1].values[0][2]*stats.getValue(StatModel.ARMORTOHEALTH));
				}
			}
		}
		
		public function removeArtifactAt(i:int){
			if (arts[i].values.length>0 && arts[i].values[0][1]==StatModel.ARMORTOHEALTH){
				if (equipment[1]!=null && equipment[1].values[0][1]==StatModel.HEALTH){
					stats.subValue(StatModel.HEALTH,equipment[1].values[0][2]*stats.getValue(StatModel.ARMORTOHEALTH));
				}
			}
			
			statRemove(arts[i].values);
			actionList.removeAction(arts[i].action);
			
			if (arts[i].values.length>0 && arts[i].values[0][1]==StatModel.ARMORTOHEALTH){
				if (equipment[1]!=null && equipment[1].values[0][1]==StatModel.HEALTH){
					stats.addValue(StatModel.HEALTH,equipment[1].values[0][2]*stats.getValue(StatModel.ARMORTOHEALTH));
				}
			}
			arts[i]=null;
		}
		
		public function checkDone():Boolean{
			return view.isIdle();
		}
		
		public function loadCosmetics(a:Array=null){
			cosmetics=a;
			if (cosmetics==null){
				cosmetics=[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
			}else{
				while(cosmetics.length<10) cosmetics.push(-1);
			}
			if (view!=null && view.display!=null){
				view.updateCosmetics(cosmetics,skillBlock.getTalentIndex());
			}
		}
		
		public function beginAction(){
			var _stop:String=buffList.actionStop();
			if (_stop!=null){
				if (stats.getValue(StatModel.TENACITY)>0 && GameModel.random()<stats.getValue(StatModel.TENACITY)){
					graphicEffect(ADD_EFFECT,this,StatModel.TENACITY);
				}else{
					stopEffect(_stop);
					return;
				}
			}
			actionList.runAct(this);
		}
		
		public function stopEffect(_stop:String){
			var s:String;
			if (_stop==BuffData.CONFUSED){
				Facade.soundC.playEffect(9);
				view.action(SpriteView.CONFUSED);
				s="Confused!";
			}else if (_stop==BuffData.DISORIENTED){
				view.action(SpriteView.CONFUSED);
				s="Confused!";
			}else if (_stop==BuffData.AFRAID){
				if (buffList.hasBuff(BuffData.ROOTED) || buffList.hasBuff(BuffData.IVY) || buffList.hasBuff(BuffData.TRAP)){
					s="Cowering!";					
				}else if (eDistance==GameModel.NEAR){
					eDistance=GameModel.FAR;
					view.action(SpriteView.AFRAID);
					s="Afraid!";
				}else if (this.eDistance==GameModel.FAR){
					eDistance=GameModel.VERY;
					view.action(SpriteView.AFRAID);
					s="Afraid!";
				}else{
					s="Cowering!";					
				}
			}else if (_stop==BuffData.ENTRANCED){
				if (buffList.hasBuff(BuffData.ROOTED) || buffList.hasBuff(BuffData.IVY) || buffList.hasBuff(BuffData.TRAP) || eDistance==GameModel.NEAR){
					s="Entranced!";
				}else if (eDistance==GameModel.FAR){
					eDistance=GameModel.NEAR;
					view.action(SpriteView.ENTRANCED);
					s="Entranced!";
				}else if (eDistance==GameModel.VERY){
					eDistance=GameModel.FAR;
					view.action(SpriteView.ENTRANCED);
					s="Entranced!";
				}
			}else if (_stop==BuffData.STUNNED){
				s="Stunned!";
			}else if (_stop==BuffData.ASLEEP){
				s="ZZZzzz...";
			}else if (_stop==BuffData.GOLEM_CONFUSED){
				s="Hrrrrm!";
				view.action(SpriteView.CONFUSED);
			}
			if (s!=null){
				graphicEffect(FLYING_TEXT,this,s);
			}
		}
		
		public static const FLYING_TEXT:int=0,
							ADD_EFFECT:int=4;
							
		public function graphicEffect(_type:int,_v:SpriteModel,_obj:*){
			if (GameModel.SIMULATED) return;
			switch(_type){
				case FLYING_TEXT: new FlyingText(_v,_obj,0xffffff); break;
				case ADD_EFFECT:
					Facade.gameUI.addEffect(_v,_obj);
					break;
			}
		}
		
		public function hasApply(s:String):Boolean{
			for (var i:int=0;i<toApply.length;i+=1){
				if (toApply[i].name==s) return true;
			}
			
			return false;
		}
		
		public function removeApply(s:String){
			for (var i:int=0;i<toApply.length;i+=1){
				if (toApply.name==s){
					toApply.splice(i,1);
					return;
				}
			}
		}
		
		public function addApply(_effect:EffectBase,newRate:Number,_replace:Boolean=false){
			for (var i:int=0;i<toApply.length;i+=1){
				if (toApply[i].name==_effect.name){
					if (_replace){
						toApply.splice(i,1);
						break;
					}else{
						return;
					}
				}
			}
			_effect.userate=newRate;
			toApply.push(_effect);
		}
		
		public function statAdd(v:Array){
			if (v==null || v.length==0) return;
			
			for (var i:int=0;i<v.length;i+=1){
				switch(v[i][0]){
					case SpriteModel.ATTACK:
						/*if (v[i][1]==ActionBase.DAMAGE){
							actionList.attack.damage*=v[i][2];
						}else{*/
							actionList.attack.addValue(v[i][1],v[i][2]);
						//}
						break;
					case SpriteModel.STAT:
						stats.addValue(v[i][1],v[i][2]);
						if (v[i][1]==StatModel.SLOTS){
							try{
								if (updateUI){
									Facade.currentUI.inventoryUI.update(this);
								}
							}catch(e:Error){}
						}else if (v[i][1]==StatModel.DISPLAYS && v[i][2].name==EffectData.REVIVE_GOKU){
							buffList.addBuff(BuffData.makeBuff(BuffData.SAYAN,v[i][2].level));
						}else if (v[i][1]==StatModel.DISPLAYS && v[i][2].name==EffectData.UNARMORED){
							statAdd(unarmored);
						}
						break;
					case SpriteModel.UNARMED:
						/*if (v[i][1]==ActionBase.DAMAGE){
							unarmed.action.damage=v[i][2];
						}else */
						if (v[i][1]==StatModel.BLOCK){
							unarmed.values[0][2]+=v[i][2];
							if (isUnarmed()){
								stats.addValue(StatModel.BLOCK,v[i][2]);
							}
						}else{
							unarmed.action.addValue(v[i][1],v[i][2]);
						}
						break;
					case SpriteModel.UNARMORED:
						if (isUnarmored()){
						//if ((p.equipment[1]==null)||(p.equipment[1].secondary==ItemData.UNARMORED)){
							statRemove(unarmored);
						}
						unarmored.push([SpriteModel.STAT,v[i][1],v[i][2]]);
						
						if (isUnarmored()){
						//if ((p.equipment[1]==null)||(p.equipment[1].secondary==ItemData.UNARMORED)){
							statAdd(unarmored);
						}
						break;
				}
			}
		}
		
		public function statRemove(v:Array){
			if (v==null || v.length==0) return;
			
			for (var i:int=0;i<v.length;i+=1){
				switch (v[i][0]){
					case SpriteModel.ATTACK:
						/*if (v[i][1]==ActionBase.DAMAGE){
							actionList.attack.damage/=v[i][2];
						}else{*/
							actionList.attack.subValue(v[i][1],v[i][2]);
						//}
						/*actionList.attack.subValue(v[i][1],v[i][2]);*/
						break;
					case SpriteModel.STAT:
						stats.subValue(v[i][1],v[i][2]);
						if (v[i][1]==StatModel.SLOTS){
							try{
								if (updateUI){
									Facade.currentUI.inventoryUI.update(this);
								}
							}catch(e:Error){}
						}else if (v[i][1]==StatModel.DISPLAYS && v[i][2].name==EffectData.REVIVE_GOKU){
							if (buffList.hasBuff(BuffData.SUPER_SAYAN)){
								buffList.removeBuffCalled(BuffData.SUPER_SAYAN);
							}else if (buffList.hasBuff(BuffData.SUPER_SAYAN2)){
								buffList.removeBuffCalled(BuffData.SUPER_SAYAN2);
							}else if (buffList.hasBuff(BuffData.SUPER_SAYAN3)){
								buffList.removeBuffCalled(BuffData.SUPER_SAYAN3);
							}else if (buffList.hasBuff(BuffData.SAYAN)){
								buffList.removeBuffCalled(BuffData.SAYAN);
							}else{
								//throw(new Error("ERROR -- Removing buff, but where's the buff???"));
							}
						}else if (v[i][1]==StatModel.DISPLAYS && v[i][2].name==EffectData.UNARMORED){
							statRemove(unarmored);
						}
						break;
					case SpriteModel.UNARMED:
						if (v[i][1]==StatModel.BLOCK){
							unarmed.values[0][2]-=v[i][2];
							if (isUnarmed()){
							//if (p.equipment[0].secondary==ItemData.UNARMED){
								stats.subValue(StatModel.BLOCK,v[i][2]);
							}
						}else{
							unarmed.action.subValue(v[i][1],v[i][2]);
						}
						break;
					case SpriteModel.UNARMORED:
						if (isUnarmored()){
						//if ((p.equipment[1]==null)||(p.equipment[1].secondary==ItemData.UNARMORED)){
							statRemove(unarmored);
						}
						for (var j:int=0;j<unarmored.length;j+=1){
							if (unarmored[j][1]==v[i][1]){
								unarmored.splice(j,1);
								break;
							}
						}
						if (isUnarmored()){
						//if ((p.equipment[1]==null)||(p.equipment[1].secondary==ItemData.UNARMORED)){
							statAdd(unarmored);
						}
						break;
				}
			}
		}
	}
}