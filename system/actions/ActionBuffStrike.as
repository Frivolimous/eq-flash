package system.actions{
	import items.ItemModel;
	import items.ItemData;
	import system.buffs.BuffData;
	import system.buffs.BuffBase;
	import system.actions.ActionList;
	import system.actions.ActionPriorities;
	import system.actions.conditionals.ConditionalBase;
	import system.effects.EffectBase;
	import system.effects.EffectBuff;
	import system.effects.EffectData;
	import ui.effects.AnimatedEffect;
	
	public class ActionBuffStrike extends ActionBase{
		public function ActionBuffStrike(_label:String=null,_level:int=0,_effects:Vector.<EffectBase>=null,_tags:Array=null){
			if (_label!=null){
				baseStats();
				label=_label;
				level=_level;
				userate=0;
				target=SELF;
				damage=0;
				if (_effects!=null) effects=_effects;
				if (_tags!=null) tags=_tags;
				effects.push(EffectData.makeEffect(EffectData.STRIKE,_level));
				basePriority.setBaseDistance(ActionPriorities.NEAR,false);
				setDefaultPriorities();
				
				source=ActionData.DEFAULT;
			}
		}
		
		override public function modify(_v:SpriteModel,_random:Boolean=true):ActionBase{
			if (_random){
				var m:ActionBase=clone(getBoost(_v));
			}else{
				m=clone();
			}
			
			var _effects:Vector.<EffectBase>=m.effects;
			m.effects=new Vector.<EffectBase>;
			for (var i:int=0;i<_effects.length;i+=1){
				m.effects[i]=_effects[i].modify(_v,m);
			}
			
			if (_v.stats.procs.length>0){
				m.effects=m.effects.concat(_v.stats.modProcs(_v,this));
			}
			
			return m;
		}
		
		override public function useAction2(_o:SpriteModel,_t:SpriteModel){
			makeProjectile(_o,_o);
		}
		
		override public function postAnim(_o:SpriteModel,_t:SpriteModel){
			if (_o.attackTarget!=null){
				var _reflect:EffectBase=_o.attackTarget.stats.findDisplay(EffectData.BUFF_REFLECT);
				if (_reflect!=null && _reflect.checkRate()){
					_o=_o.attackTarget;
					_t=_o.attackTarget;
				}
			}
			
			checkStrike(_o,_o.attackTarget);
		}
		
		override public function getBoost(_v:SpriteModel):int{
			specialEffect=-1;
			var m:int=0;
			for (var i:int=0;i<_v.stats.displays.length;i+=1){
				if (_v.stats.displays[i].trigger==EffectBase.LEVEL_BOOST){
					switch(_v.stats.displays[i].name){
						case EffectData.SPELL_BOOST:
						case EffectData.BUFF_BOOST:
							 if (_v.stats.displays[i].checkRate()) m+=_v.stats.displays[i].values; 
							 specialEffect=GAIA;
							 break;
					}
				}
			}
			return m;
		}
		
		override public function fullUse(_v:SpriteModel):Number{
			var m:Number=userate;
			if (isConsumable()){
				m=addMult(m,_v.stats.getValue(StatModel.IRATE));
			}
			return m;
		}
		override public function isMagic():Boolean{
			return true;
		}
		
		override public function isBuff():Boolean{
			return true;
		}
		
		//===================PRIORITIES==========================\\
		
		override public function canUse(_o:SpriteModel,_t:SpriteModel,_distance:String=null):Boolean{
			if (_distance==null) _distance=Facade.gameM.distance;
			
			if (_t==null) return false;
			
			if (!checkCanDistance(_distance)){
				return false;
			}
			
			for (var i:int=0;i<_o.buffList.numBuffs();i+=1){
				switch(_o.buffList.getBuff(i).name){ //limited actions
					case BuffData.RUSHED: case BuffData.AIMING: return false;
				}
			}
			
			if (source.charges>=0 && source.charges<chargeCost()){
				return false;
			}
			
			return true;
		}
		
		override public function wantUse(_o:SpriteModel,_t:SpriteModel,_distance:String=null,_rate:Boolean=true):Boolean{
			if (_distance==null) _distance=_o.eDistance;
			if (!checkDistance(_distance)) return false;
			
			for (var i:int=0;i<additionalPriorities.length;i+=1){
				if (!additionalPriorities[i].testThis(_o,_t,this)) return false;
			}
			
			if (_rate){
				var _userate:Number=fullUse(_o);
				if (_userate<1 && (_userate<=0 || GameModel.random()>_userate)) return false;
			}
			
			if (effects.length>0 && (effects[0] is EffectBuff)){
				if (_o.buffList.hasBuff((effects[0] as EffectBuff).buff.name)){
					return false; //self has buffs
				}
			}
			return true;
		}
		
		override public function setDefaultPriorities(){
			//WITHDRAW is always first, APPROACH is always last.
			//Default: Priority 0 is highest, Priority 5 is lowest.
			//Players can set 1-4.
			additionalPriorities=[new ConditionalBase(0,0,[0,1])];
			priorityTier=2;
			additionalPriorities.push(new ConditionalBase(3,0,[0,1,2,3,4,5,6,7]));
		}
		
		override public function getDesc():String{
			var m:String="";
			m+="<font color="+StringData.YELLOW+"><b>"+label+"</b></font>";
			if ((userate!=0)&&(userate<1)){
				m+="\n USE: <font color="+StringData.RED+"><b> +"+StringData.reduce(userate*100)+"%</b></font>";
			}
			
			m+=getEffectDescs();
			
			return m;
		}
	}
}