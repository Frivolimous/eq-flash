package items {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import ui.assets.TutorialWindow;
	import ui.windows.ConfirmWindow;
	import system.effects.EffectData;
	import utils.GameData;
	import utils.AchieveData;
	
	public class BaseInventoryUI extends Sprite{
		var IWIDTH:Number=32.5;
		var IHEIGHT:Number=34;
		public var NUM_SLOTS:int=20;
		public var origin:SpriteModel;
		public var gold:TextField;
		public var itemA:Array;
		
		public var locked:Boolean=false;
		public var noSell:Boolean=false;
		public var nullSell:Boolean=false;
		
		public var alsoUpdate:Function;

		public function BaseInventoryUI() {
			itemA=new Array(20);
		}
		
		public function makeBox(i:int,_x:Number,_y:Number,_size:String=null):ItemBox{
			var m:ItemBox=new ItemBox(i,this,_size);
			m.x=_x;
			m.y=_y;
			addChild(m);
			return m;
		}
		
		public function clear(){
			for (var i:int=0;i<itemA.length;i+=1){
				if (itemA[i].hasItem()){
					(itemA[i].removeItem()).dispose();
				}
			}
		}

		public function update(_o:SpriteModel=null){
			origin=_o;
		}
		
		public function addItem(_item:ItemView):Boolean{
			for (var i:int=0;i<NUM_SLOTS;i+=1){
				if (!itemA[i].hasItem()){
					itemA[i].addItem(_item);
					return true;
				}
			}
			return false;
		}
		
		public function addItemAt(_item:ItemView,i:int):Boolean{
			//return true if successful
			if ((_item==null)||(i==-1)){
				return true;
			}
			
			itemA[i].addItem(_item);
			return true;
		}
		
		public function removeItem(_item:ItemView):Boolean{
			itemA[_item.index].removeItem();
			return true;
		}
		
		public function removeItemAt(i:int):ItemView{
			return itemA[i].removeItem();
		}
		
		public function canSell():Boolean{
			if (!GameData.getFlag(GameData.FLAG_TUTORIAL) && !Facade.gameM.playerM.flags[TutorialWindow.GEM]) return false;
			if (origin==null || origin.saveSlot>=5) return false;
			if (noSell) return false;
			
			return true;
		}
		public function sell(_item:ItemView){
			if ((origin!=null && origin.saveSlot<0) || nullSell){
				toSell=_item;
				toSell.dispose();
				removeItem(toSell);
				return;
			}
			if (!canSell()) return;
			
			
			if (_item.model.isSpecial()){
				toSell=_item;
				if (_item.model.isPremium()){
					new ConfirmWindow("Do you want to sell your "+_item.model.name+" for 1 Power Token?",100,100,sellPremiumYes,0,sellNo);
				}else if (_item.model.index==135 || _item.model.index==136){
					new ConfirmWindow("Do you want to sell your "+_item.model.name+" for 1,000 Soul Power?",100,100,sellEssenceYes,0,sellNo);
				}else{
					new ConfirmWindow("Are you sure you want to sell your "+_item.model.name+" for "+_item.model.cost+" gold?",100,100,sellYes,0,sellNo);
				}
			}else{
				toSell=_item;
				sellYes();
			}
		}
		
		var toSell:ItemView;
		function sellYes(i:int=0){			
			if (origin!=null){
				GameData.gold+=toSell.model.cost;
				updateGold();
				Facade.soundC.playEffect(SoundControl.GOLD);
			}
			toSell.dispose();
			removeItem(toSell);
		}
		
		function sellPremiumYes(i:int=0){			
			if (origin!=null){
				AchieveData.achieve(AchieveData.SALVAGE_MYTHIC_1);

				GameData.kreds+=1;
				updateGold();
				Facade.soundC.playEffect(SoundControl.GOLD);
			}
			toSell.dispose();
			removeItem(toSell);
		}
		
		function sellEssenceYes(i:int=0){
			if (origin!=null){
				GameData.souls+=1000;
				//updateGold();
				Facade.soundC.playEffect(SoundControl.GOLD);
			}
			toSell.dispose();
			removeItem(toSell);
		}
		
		function sellNo(i:int=0){
			returnItem(toSell);
			toSell=null;
		}
		
		public function check(_item:ItemView,i:int):Boolean{
			if (beltContainsRelic() && (!itemA[i].hasItem() || !itemA[i].stored.model.hasTag(EffectData.RELIC))){
				if (itemA[i].checkIndex==ItemBox.BELT && _item.model.hasTag(EffectData.RELIC)){ // only 1 Relic
					return false;
				}
			}
			
			return itemA[i].check(_item);
		}

		public function dropItem(_item:ItemView,i:int){
			var _location:BaseInventoryUI=_item.location;
			var j:int=_item.index;
			
			if (!check(_item,i)){
				_location.returnItem(_item);
				return;
			}
			
			if (!_item.location.removeItem(_item)){
				_location.returnItem(_item);				
				return;
			}
			
			if (origin!=null){
				if (origin.actionList.itemC.stored==itemA[i].stored) origin.actionList.itemC.remove();
			}
			//if (Facade.actionC.itemCover.stored==itemA[i].stored) Facade.actionC.itemCover.remove();
			var _item2:ItemView=itemA[i].stored; // check for stacking charges
			
			if (itemA[i].checkIndex==ItemBox.FORGE && (_item.model.index==135 || _item.model.index==136)){
				if (_item2!=null && _item.model.index==_item2.model.index && _item.model.enchantIndex==_item2.model.enchantIndex && _item.model.suffixIndex==_item2.model.suffixIndex){
					_location.returnItem(_item);
					return;
				}
				if (_item.model.charges>1){
					_item.model.charges-=1;
					_location.returnItem(_item);
					_item=new ItemView(_item.model.clone());
					_item.model.charges=1;
				}
			}
			
			if (itemA[i].hasItem()){
				if (itemA[i].checkIndex!=ItemBox.FORGE){
					if (((_item.model.index==135 &&_item2.model.index==135) || (_item.model.index==136 &&_item2.model.index==136)) && _item.model.enchantIndex==_item2.model.enchantIndex && _item.model.suffixIndex==_item2.model.suffixIndex){
						if (_item2.model.charges==-1) _item2.model.charges=1;
						if (_item.model.charges==-1){
							_item2.model.charges+=1;
						}else{
							_item2.model.charges+=_item.model.charges;
						}
						addItemAt(_item2,_item2.index);
						updateGold();
						_location.updateGold();
						return;
					}
				}
				/*if (_item.model.charges>=0 && _item2.model.charges>=0){ //combine stacks.  Troublesome so removing.
					var _temp:int=compareStackables(_item.model,_item2.model); //1: _item greater, 2: _item2 greater; 0: unequal;
					if (_temp!=0){
						var _totalCharges:int=_item.model.charges+_item2.model.charges;
						if (_temp==1){
							var _maxCharges:int=ItemData.maxCharges(_item.model);
							
							if (_totalCharges<=_maxCharges){
								_item.model.charges=_totalCharges;
								_item.model.setActionList(_item2.model.listC);
								removeItemAt(i);
								addItemAt(_item,i);
							}else{
								_item.model.charges=_maxCharges;
								_item2.model.charges=(_totalCharges-_maxCharges);
								_item.model.setActionList(_item2.model.listC);
								removeItemAt(i);
								addItemAt(_item,i);
								if (_location.check(_item2,j)){
									_location.addItemAt(_item2,j);
								}else if (!_location.addItem(_item2)){
									addItem(_item2);
								}
							}
						}else{
							_maxCharges=ItemData.maxCharges(_item2.model);
							
							if (_totalCharges<=_maxCharges){
								_item2.model.charges=_totalCharges;
							}else{
								_item2.model.charges=_maxCharges;
								_item.model.charges=(_totalCharges-_maxCharges);
								if (_location.check(_item,j)){
									_location.addItemAt(_item,j);
								}else if (!_location.addItem(_item)){
									addItem(_item);
								}
							}
						}
						return;
					}
				}*/
				
				//either consumable wasn't consumed or 1 not consumable.  Test swapping or add to inventory.
				_item2=removeItemAt(i); //no I2, I1 in air
				addItemAt(_item,i);  //no I2, I1 in L2
				if (_location.check(_item2,j) && !_location.itemA[j].hasItem()){  // can I2 go to L1?
					_location.addItemAt(_item2,j);  // YES! L2 go to I1
				}else if (!_location.addItem(_item2)){  // NO! Can I2 go elsewhere in L1? >> YES = OVER
					if (!addItem(_item2)){ // NO!  Can I2 go back where to its own place? YES = OVER
						if (canSell() && !nullSell){
							Facade.gameM.addOverflowItem(_item2.model); // NO! I2 nowhere to go >> to Overflow!
						}else{
							//REWIND THE WHOLE TRANSFER
							removeItemAt(i);
							
							_item.index=j;
							_location.returnItem(_item);
							
							addItemAt(_item2,i);
						}
					}
				}
			}else{
				addItemAt(_item,i);
			}
			
			updateGold();
			_location.updateGold();
		}
		
		public function beltContainsRelic():Boolean{
			for (var i:int=0;i<itemA.length;i+=1){
				if (itemA[i].checkIndex==ItemBox.BELT && itemA[i].hasItem() && itemA[i].stored.model.hasTag(EffectData.RELIC)){
					return true;
				}
			}
			return false;
		}
		
		public function updateGold(){
			if ((gold!=null)&&(origin!=null)){
				var _gold:Number=GameData.gold;
				var _letter:int=0;
				if (_gold>=10000){
					while(_gold>=1000){
						_gold/=1000;
						_letter+=1;
					}
				}
				if (_gold>=100){
					_gold=Math.round(_gold);
				}else if (_gold>10){
					_gold=Math.round(_gold*10)/10;
				}else{
					_gold=Math.round(_gold*100)/100;
				}
				gold.text=String(_gold);
				switch(_letter){
					case 1: gold.appendText("k"); break;
					case 2: gold.appendText("m"); break;
					case 3: gold.appendText("b"); break;
					case 4: gold.appendText("t"); break;
				}
			}
			if (alsoUpdate!=null){
				alsoUpdate();
			}
		}
		
		public function returnItem(_item:ItemView){
			if (itemA[_item.index].stored==_item){
				itemA[_item.index].addItem(_item);
			}else{
				addItemAt(_item,_item.index);
			}
		}
		
		public function addStackable(_item:ItemView,_upgrade:Boolean=true):ItemView{
			/*for (var i:int=0;i<itemA.length;i+=1){
				var _item2:ItemView=itemA[i].stored;
				if (_item2==null) continue;
				var _temp:int=compareStackables(_item.model,_item2.model);
				if (_temp>0){
					var _totalCharges:int=_item.model.charges+_item2.model.charges;
					
					if (_temp==1){
						var _maxCharges:int=ItemData.maxCharges(_item.model);
					
						if (_totalCharges<=_maxCharges){
							_item.model.charges=_totalCharges;
							_item.model.setActionList(_item2.model.listC);
							removeItemAt(i);
							addItemAt(_item,i);
							return null;
						}else{
							_item.model.charges=_maxCharges;
							_item2.model.charges=(_totalCharges-_maxCharges);
							_item.model.setActionList(_item2.model.listC);
							removeItemAt(i);
							addItemAt(_item,i);
							_item=_item2;
						}
					}else{
						_maxCharges=ItemData.maxCharges(_item2.model);
						
						if (_totalCharges<=_maxCharges){
							_item2.model.charges=_totalCharges;
							return null;
						}else{
							_item2.model.charges=_maxCharges;
							_item.model.charges=(_totalCharges-_maxCharges);
						}
					}
				}
			}
			return _item; */
			return null;
		}
		
		public function compareStackables(_item1:ItemModel,_item2:ItemModel):int{
			//returns 1: item1 is greater or equal
			//returns 0: items are nonequivalent
			//returns 2: item2 is greater
			if (_item1.index!=_item2.index) return 0; //not same type
			if (_item1.charges<0 || _item2.charges<0) return 0; //not stackable
			var m:int=0;
			
			if (_item1.level>_item2.level){
				m=1;
			}else if (_item2.level>_item1.level){
				m=2;
			}
			
			if (_item1.enchantIndex>-1){
				if (_item2.enchantIndex>-1){
					//both enchanted
					return 0;
				}else{
					//1 is enchanted
					if (m==2){
						return 0;
					}else{
						return 1;
					}
				}
			}else{
				if (_item2.enchantIndex>-1){
					//2 is enchanted
					if (m==1){
						return 0;
					}else{
						return 2;
					}
				}else{
					//neither enchanted
					if (m==0) return 1;
				}
			}
			return m;
		}
	}
}
