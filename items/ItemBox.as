package items{
	import flash.display.Sprite;
	import items.ItemView;
	import skills.SkillData;
	
	public class ItemBox extends Sprite{
		public static var BIG:String="big";
		public static var SMALL:String="small";
		
		public static var WEAPON:int=0;
		public static var HELMET:int=1;
		public static var MAGIC:int=2;
		public static var BELT:int=3;
		public static var UPGRADE:int=4;
		public static var STACK:int=5;
		public static var NONE:int=-1;
		public static var FORGE:int=6;
		
		var _Cover:ItemCross=new ItemCross;
		
		public var stored:ItemView;
		public var index:int;
		public var checkIndex:int;
		public var listB:ItemButton;
		public var location:BaseInventoryUI;
		
		public function ItemBox(i:int,_loc:BaseInventoryUI,_type:String=null,_check:int=-1,_draw:Boolean=false){
			index=i;
			location=_loc;
			checkIndex=_check;
			name=MouseControl.ITEM_BOX;
			if (_draw){
				graphics.beginFill(0x996600);
				graphics.lineStyle(1,0x990000);
				graphics.drawRect(0,0,35,35);
			}else{
				graphics.beginFill(0,0.01);
				graphics.drawRect(0,0,35,35);
			}
			
			
			if (_type!=null){
				listB=new ItemButton();
				addChild(listB);
				if (_type==BIG){
					listB.y=38.1;
				}else{
					listB.y=19;//18-listB.height;
				}
				removeItem();
			}
		}
		
		public function check(_item:ItemView):Boolean{
			if (cover){
				return false;
			}
			
			switch(checkIndex){
				case WEAPON: if (_item.model.primary==ItemData.WEAPON) return true; break;
				case HELMET: if (_item.model.primary==ItemData.HELMET) return true; break;
				case MAGIC: if (_item.model.primary==ItemData.MAGIC) return true; break;
				case BELT: if ((_item.model.slot==ItemData.USEABLE)&&((!location.origin.skillBlock.checkTalent(SkillData.UNGIFTED))||(_item.model.primary!=ItemData.SCROLL))) return true; break;
				case UPGRADE: if (_item.model.level<20 && _item.model.level!=15) return true; break;
				case STACK: if (_item.model.charges>=0 && _item.model.charges<_item.model.maxCharges() && _item.model.index!=135 && _item.model.index!=136) return true; break;
				case NONE: return true; break;
				case FORGE: if (_item.model.level>=15) return true; break;
			}
			return false;
		}
		
		public function set cover(b:Boolean){
			if (b){
				addChild(_Cover);
				if (listB!=null) listB.disabled=true;
			}else{
				if (contains(_Cover)){
					removeChild(_Cover);
				}
				if (listB!=null) listB.disabled=false;
			}
		}
		
		public function get cover():Boolean{
			return (contains(_Cover));
		}
		
		public function addItem(item:ItemView){
			if (stored!=null && stored!=item){
				if ((stored.model.index==136 || stored.model.index==135) && stored.model.index==item.model.index && stored.model.enchantIndex==item.model.enchantIndex && stored.model.suffixIndex==item.model.suffixIndex){
					if (item.model.charges==-1) item.model.charges=1;
					stored.model.charges+=item.model.charges;
					return;
				}
			}
			removeItem();
			stored=item;
			stored.index=index;
			stored.location=location;
			addChildAt(stored,0);
			stored.x=-.05;
			stored.y=0.7;
			//stored.width=35;
			//stored.scaleY=stored.scaleX;
			if (listB!=null){
				listB.update(stored.model);
				listB.disabled=location.locked;
			}
		}
		
		public function removeItem():ItemView{
			var _stored:ItemView=stored;
			try{
				stored.parent.removeChild(stored);
			}catch(e:Error){}
			stored=null;
			if (listB!=null){
				listB.update(null);
			}
			return _stored;
		}
		
		public function hasItem():Boolean{
			if (stored==null){
				return false;
			}else{
				return true;
			}
		}
	}
}