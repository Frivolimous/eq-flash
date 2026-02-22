package items{
	import system.actions.ActionBase;
	import system.effects.EffectBase;
	import system.effects.EffectData;

	public class ItemModel{
		public var name:String,
							 index:int,
							 level:int,
							 //type1:String,
							 slot:String,
							 primary:String,
							 secondary:String,
							 cost:int,
							 _Charges:int,
							 values:Array=[],
							 view:ItemView,
							 location:Array,
							 enchantIndex:int,
							 suffixIndex:int,
							 sellMode:int=0,
							 action:ActionBase,
							 tags:Array; //0 = autosell, 1 = normal, 2 = warning, 3 = locked
		
		public function ItemModel(_index:int=-1,_name:String=null,_level:int=0,_type1:String=null,_type2:String=null,_type3:String=null,_cost:int=0,_action:ActionBase=null,_values:Array=null,_charges:int=-1,_tags:Array=null){
			if (_name==null) return;
			
			index=_index;
			name=_name;
			level=_level;
			slot=_type1;
			primary=_type2;
			secondary=_type3;
			tags=_tags;
			if (tags==null) tags=[];
			if (level>15) tags.push(EffectData.EPIC);
			
			if (_level<0){
				cost=_cost;
				_Charges=-1;
			}else{
				cost=_cost*(1+_level/2);
				_Charges=_charges;
			}
			action=_action;
			if (action!=null){
				action.addSource(this);
			}
			
			if (_values==null){
				values=[];
			}else{
				values=_values;
			}
			
			enchantIndex=-1;
			suffixIndex=-1;
			if (level>15){
				levelModValues(values,level);
			}
		}
		
		static function levelModValues(_values:Array,_level:int){
			if (_level<=15) return;
			
			for (var i:int=0;i<_values.length;i+=1){
				if (_values[i][0]== SpriteModel.STAT && _values[i][1]==StatModel.HEALTH){
					_values[i][2]*=(_level-5)/10;
				}
			}
		}
		
		public function set charges(i:int){
			_Charges=i;
			if (view!=null){
				if (view.counter==null) view.makeCounter(30,17,0xffffff,10);
				view.counter.text=String(i);
				view._Desc=null;
			}
		}
		
		public function get charges():int{
			return _Charges;
		}
		
		public function getRestackCost():int{
			if (charges>=0) return (maxCharges()-charges)*Facade.gameM.area;
			return 0;
			//return (ItemData.maxCharges(this)-charges)*_Cost*3.5;
		}
		
		
		public function hasTag(s:String):Boolean{
			for (var i:int=0;i<tags.length;i+=1){
				if (tags[i]==s) return true;
			}
			return false;
		}
		
		public function hasEffect(s:String):Boolean{
			for (var i:int=0;i<values.length;i+=1){
				if (values[i].length>=2 && (values[i][2] is EffectBase) && values[i][2].name==s) return true;
			}
			return false;
		}
		
		public function maxCharges():int{
			var m:int=-1;
			if (enchantIndex==20 || index==94 || index==95) return -1;
			if (index==135 || index==136) return int.MAX_VALUE;
			
			switch(index){
				case 93: m=10; break;
				case 137: case 92: m=2; break;
				case 141: case 140: case 112: m=1; break;
				case 134: m=50; break;
			}
			
			if (m==-1){
				if (primary==ItemData.POTION || primary==ItemData.GRENADE){
					m=6;
				}else if (primary==ItemData.PROJECTILE){
					if (index==39){
						m=25;
					}else{
						m=10;
					}
				}else if (primary==ItemData.SCROLL){
					m=1;
				}else{
					return -1;
				}
			}
			
			if (enchantIndex==6) m*=2;
			else if ((index==33 || index==34 || index==36 || (index>=97 && index<=99)) && enchantIndex==0){
				m*=2;
			}
			return m;
		}
		
		public function isSpecial():Boolean{
			if ((((index>=31 && index<=36) || (index>=96 && index<=99) || (index>=50 && index<=62)) && enchantIndex==6) || 
				(index==118 || index==119 || index==135 || index==136) || 
				isShadow() || isPremium()){
				return true;
			}else{
				return false;
			}
		}
		
		public function isShadow():Boolean{
			if ((primary==ItemData.WEAPON && enchantIndex>=15) || 
				(primary==ItemData.HELMET && enchantIndex>-1 && enchantIndex<15) ||
				(index==45 && enchantIndex==0) ||
				(enchantIndex>=30)){
				return true;
			}else{
				return false;
			}
		}
		
		public function isPremium():Boolean{
			if (hasTag(EffectData.PREMIUM) || hasTag(EffectData.SUPER_PREMIUM)){
				return true;
			}else{
				return false;
			}
		}
		
		public function setPriorities(_main:Array=null,_additional:Array=null){
			if (action==null) return;
			
			if (_main!=null){
				action.setMainPriority(_main);
			}
			
			if (_additional==null) _additional=[];
			
			setAdditionalPriorities(_additional);
		}
		
		public function setAdditionalPriorities(a:Array){
			if (action!=null){
				if (a.length==0 || a[0]==null){
					action.setDefaultPriorities();
				}else{
					action.setAdditionalPriorities(a);
				}
			}
		}
		
		public function hasAction():Boolean{
			if (action!=null) return true;
			return false;
		}
		
		public function exportArray(_noPriorities:Boolean=false):Array{
			var m:Array=[index,level,charges];
			if (suffixIndex>-1){
				m[3]=[enchantIndex,suffixIndex];
			}else{
				m[3]=enchantIndex;
			}
			
			if (!_noPriorities && action!=null){
				m[4]=action.getMainPriority();
				m[5]=action.getAdditionalPriorities();
				m[6]=action.priorityTier;
			}
			
			return m;
		}
		
		public static function importArray(_a:Array):ItemModel{
			var m:ItemModel;
			
			m=ItemData.spawnItem(_a[1],_a[0],_a[2]);
			if (_a[3] is Array){
				if (_a[3][0]>=0) ItemData.enchantItem(m,_a[3][0]);
				ItemData.suffixItem(m,_a[3][1]);
			}else if (_a[3]>=0){
				ItemData.enchantItem(m,_a[3]);
			}
			if (m.index!=135 && m.index!=136){
				var _max:int=m.maxCharges();
				if (_max>0){
					if (m.charges<0 || m.charges>_max) m.charges=_max;
				}
			}
			
			if (_a[4]==null){
				if (m.action!=null){
					m.setPriorities();
				}
			}else{
				if (!(_a[4] is Array)) _a[4]=null;
				
				if (_a[5]==null || !(_a[5] is Array) || _a.length==0 || !(_a[5][0] is Array)){
					var _temp:Array=null;
				}else{
					_temp=_a[5];
				}
				m.setPriorities(_a[4],_temp);
				if (_a[6]!=null && m.action!=null) m.action.priorityTier=_a[6];
			}
			return m;
		}
		
		public function clone(_level:int=-1,_noSuffix:Boolean=false,_noPrefix:Boolean=false):ItemModel{
			if (_level==-1) _level=level;
			var m:ItemModel=ItemData.spawnItem(_level,index,charges);
			if (enchantIndex>-1 && !_noPrefix) m=ItemData.enchantItem(m,enchantIndex);
			if (suffixIndex>-1 && !_noSuffix) m=ItemData.suffixItem(m,suffixIndex);
			return m;
		}
	}
}