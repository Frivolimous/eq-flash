package items {
	
	public class ItemList {
		public var equipment:Array=new Array(5);
		public var belt:Array=new Array(5);
		public var inventory:Array=new Array(20);
		
		var origin:SpriteModel;
		
		public function ItemList(_o:SpriteModel){
			origin=_o;
		}
		
		/*public function addItem(_item:ItemModel):Boolean{
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
			}else if(i<10){
				belt[i-5]=_item;
				statAdd(_item.values);
				actionList.addAction(_item.action);
			}else{
				inventory[i-10]=_item;
			}
			if (Facade.currentUI!=null) Facade.currentUI.updateStats();
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
			}else if (i<10){
				if (belt[i-5]==null) return;
				statRemove(belt[i-5].values);
				actionList.removeAction(belt[i-5].action);
				belt[i-5]=null;
			}else{
				if (inventory[i-10]==null) return;
				inventory[i-10]=null;
			}
			if (Facade.currentUI!=null) Facade.currentUI.updateStats();
		}*/
	}
}
