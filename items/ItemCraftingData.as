package items{
	import skills.SkillData;
	import system.buffs.*;
	import system.effects.*;
	import system.actions.*;
	import items.ItemModel;
	import utils.GameData;
	import utils.AchieveData;
	import ui.effects.PopEffect;
  import items.ItemData;
	
	public class ItemCraftingData{
		public static function getCraftingResult(_item0:ItemModel,_item1:ItemModel):ItemModel{
			if (_item0.level<15 || _item1.level<15) return null; //Must be level 15 or higher to craft
			if (_item0.primary==ItemData.TRADE || _item1.primary==ItemData.TRADE) return null; //Can't craft with gems
      if (_item1.index==135 || _item1.index==136) return null; //essences must be item0

      if (_item0.index==135) return getEssenceResult(_item0,_item1);
			
			if (_item0.index==136){ // Epic Essence
				if (_item1.level==15){
					return _item1.clone(16);
				}
				return null;
			}
			
			//Duplicate items
			if (_item0.index==_item1.index){
        if (!AchieveData.hasAchieved(AchieveData.ZONE_400)) return null;
        if (_item0.level!==15 || _item1.level!==15) return null;
        if (_item0.enchantIndex!==_item1.enchantIndex && _item0.enchantIndex>=0 && _item1.enchantIndex>=0) return null;
        if (_item0.suffixIndex!==_item1.suffixIndex && _item0.suffixIndex>=0 && _item1.suffixIndex>=0) return null;

        var newEnchant:int=_item0.enchantIndex==-1?_item1.enchantIndex:_item0.enchantIndex;
        var newSuffix:int=_item0.suffixIndex==-1?_item1.suffixIndex:_item0.suffixIndex;

        return ItemModel.importArray([_item0.index,16,_item0.maxCharges(),[newEnchant,newSuffix]]);
			}

      if (_item0.isPremium()){
        if (_item0.enchantIndex>=0 || _item0.suffixIndex>=0) return null;
        return getPremiumResult(_item0,_item1);
      }
			
			if (!_item1.isPremium()){
        //move enchantment from 1 to 0 (WEAPON)
				if (_item0.primary==ItemData.WEAPON && _item0.enchantIndex==-1 && _item1.enchantIndex>-1 && (_item1.primary==ItemData.WEAPON || (_item1.primary==ItemData.CHARM && _item1.enchantIndex<15))){
					return ItemData.enchantItem(_item0.clone(-1,false,true),_item1.enchantIndex);
				}
        //move enchantment from 1 to 0 (HELMET)
				if (_item0.primary==ItemData.HELMET && _item0.enchantIndex==-1 && _item1.enchantIndex>-1 && (_item1.primary==ItemData.HELMET || (_item1.primary==ItemData.CHARM && _item1.enchantIndex>=15 && _item1.enchantIndex<30))){
					return ItemData.enchantItem(_item0.clone(-1,false,true),_item1.enchantIndex);
				}
        //make a scroll with 0
				if (_item0.primary==ItemData.MAGIC && _item0.enchantIndex==-1 && _item1.primary==ItemData.SCROLL){
					_item0=new ItemScroll(_item0.level,_item0,1);
					if (_item1.enchantIndex==6){
						return ItemData.enchantItem(_item0,6);
					}else{
						return _item0;
					}
				}

        //shadow queen statue
				if (_item0.index==40 && _item0.enchantIndex==30 && _item1.isShadow()){
					return ItemData.enchantItem(ItemData.spawnItem(_item0.level,40),31);
				}

        //move plentiful across items
				if ((_item0.primary==ItemData.POTION || _item0.primary==ItemData.GRENADE || _item0.primary==ItemData.SCROLL) && (_item1.primary==ItemData.POTION || _item1.primary==ItemData.GRENADE || _item1.primary==ItemData.SCROLL) && _item0.enchantIndex==6 && _item1.enchantIndex==-1){
					return ItemData.enchantItem(_item1.clone(),6);
				}

        //special potion recipes
        if ((_item0.primary==ItemData.POTION || _item0.primary==ItemData.GRENADE) && (_item1.primary==ItemData.POTION || _item1.primary==ItemData.GRENADE)){
          if (_item0.enchantIndex==6 && _item1.enchantIndex==6){
            return getPotionResult(_item0,_item1);
          }

          return null;
        }
			}


      if (_item0.primary==ItemData.MAGIC){
        if (_item0.enchantIndex>=0) return null;
        return getMagicResult(_item0,_item1);
      }
			
			return null;
		}

    private static function getEssenceResult(_item0:ItemModel,_item1:ItemModel):ItemModel{
      if (_item0.enchantIndex>=0){
        if (_item0.enchantIndex==0){ //Scouring Essence
          if (_item1.index==135){
            if (_item1.enchantIndex==-1 && _item1.suffixIndex>=64){
              return ItemData.spawnItem(_item1.level,_item1.suffixIndex);
            }
          }else if (_item1.enchantIndex>=0 || _item1.suffixIndex>=0){
            return ItemData.spawnItem(_item1.level,_item1.index);
          }
        }else if (_item0.enchantIndex==1){ //Chaos Essence
          if (_item1.index==135){
            return null;
          }
          if (_item1.primary==ItemData.POTION || _item1.primary==ItemData.GRENADE || _item1.primary==ItemData.SCROLL || (_item1.primary==ItemData.CHARM && !_item1.hasTag(EffectData.RELIC))){
            return null;
          }
          
          if (_item1.primary==ItemData.MAGIC){
            do{
              _suffix=Math.floor(30+Math.random()*(42-30));
            }while(!ItemData.testSuffix(_item1,_suffix));
            return ItemData.suffixItem(_item1.clone(-1,true),_suffix);
          }
          do{
            var _suffix:int=Math.floor(64+Math.random()*(135-64));
          }while(!ItemData.testSuffix(_item1,_suffix));
          return ItemData.suffixItem(_item1.clone(-1,true),_suffix);
          
        }else if (_item0.enchantIndex==2){ //Minor Chaos Essence
          if (_item1.primary==ItemData.CHARM || _item1.primary==ItemData.WEAPON || _item1.primary==ItemData.HELMET || _item1.primary==ItemData.TRINKET || _item1.primary==ItemData.PROJECTILE){
            do{
              _suffix=Math.floor(Math.random()*30);
            }while(!ItemData.testSuffix(_item1,_suffix));
            return ItemData.suffixItem(_item1.clone(-1,true),_suffix);
          }else{
            return null;
          }
        }else if (_item0.enchantIndex==3){ //Plentiful Essence
          if (_item1.enchantIndex==-1 && _item1.charges>=0){
            var m:ItemModel=ItemData.enchantItem(_item1.clone(-1,false,true),6);
            m.charges=m.maxCharges();
            return m;
          }
        }
      }else{
        if (_item0.suffixIndex==-1){ //Blank Essence, add Suffix?
          if (_item1.isPremium()){
            return ItemData.suffixItem(_item0.clone(),_item1.index);
          }else if (_item1.index>=14 && _item1.index<=25){
            return ItemData.suffixItem(_item0.clone(),_item1.index+16);
          }else if (_item1.index>=31 && _item1.index<=36){
            return ItemData.suffixItem(_item0.clone(),_item1.index+11);
          }else if (_item1.index>=96 && _item1.index<=99){
            return ItemData.suffixItem(_item0.clone(),_item1.index-48);
          }
        }else{ //Suffixed Essence and Other Item
          if (ItemData.testSuffix(_item1,_item0.suffixIndex)){
            return ItemData.suffixItem(_item1.clone(-1,true),_item0.suffixIndex);
          }
        }
      }
      
      return null;
    
    }

    public static function getPremiumResult(_item0:ItemModel,_item1:ItemModel):ItemModel{
      if (_item0.index<=111){ //Special Recipes for PREMIUMS
				switch(_item0.index){
					case 64: //Kabuto
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.HELMET && _item1.enchantIndex==2){
							return ItemData.enchantItem(_item0.clone(-1,false,true),1);
						}else if (_item1.primary!=ItemData.WEAPON&& _item1.enchantIndex==19){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 65: //Hood
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.HELMET && _item1.enchantIndex==11){
							return ItemData.spawnItem(_item0.level,110);
						}else if (_item1.primary!=ItemData.HELMET && _item1.enchantIndex==9){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 66: //Phrygian Cap
						if (_item1.index==31 && _item1.enchantIndex==6){
							return ItemData.enchantItem(_item0.clone(-1,false,true),1);
						}else if (_item1.index==32 && _item1.enchantIndex==6){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 67: //Plumber Hat
						if (_item1.index==98 && _item1.enchantIndex==6){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 68: //Boxing Gear
						if (_item1.index==70){
							return ItemData.enchantItem(_item0.clone(-1,false,true),4);
						}else if (_item1.primary!=ItemData.WEAPON){
							if (_item1.isPremium()) break;
							switch(_item1.enchantIndex){
								case 20: return ItemData.enchantItem(_item0.clone(-1,false,true),0);
								case 21: return ItemData.enchantItem(_item0.clone(-1,false,true),1);
								case 22: return ItemData.enchantItem(_item0.clone(-1,false,true),2);
								case 23: return ItemData.enchantItem(_item0.clone(-1,false,true),3);
							} 	
						}break;
					case 69: //Turban
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.HELMET && _item1.enchantIndex==11){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 70: //Crown
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.WEAPON && _item1.enchantIndex>15 && _item1.enchantIndex<30){
							return ItemData.enchantItem(_item0.clone(-1,false,true),_item1.enchantIndex);
						}break;
					case 71: //Protector
						if (_item1.enchantIndex==30){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 72: //Katanas
						if (_item1.index==132){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 73: //Light Sword
						if (_item1.enchantIndex==6){
							switch(_item1.index){
								case 31: return ItemData.enchantItem(_item0.clone(-1,false,true),0);
								case 32: return ItemData.enchantItem(_item0.clone(-1,false,true),1);
								case 33: return ItemData.enchantItem(_item0.clone(-1,false,true),2);
								case 34: return ItemData.enchantItem(_item0.clone(-1,false,true),3);
								case 35: return ItemData.enchantItem(_item0.clone(-1,false,true),4);
								case 36: return ItemData.enchantItem(_item0.clone(-1,false,true),5);
								case 96: return ItemData.enchantItem(_item0.clone(-1,false,true),6);
								case 97: return ItemData.enchantItem(_item0.clone(-1,false,true),7);
								case 98: return ItemData.enchantItem(_item0.clone(-1,false,true),8);
								case 99: return ItemData.enchantItem(_item0.clone(-1,false,true),9);
							}
						}break;
					case 74: //Rending Claws
						if (_item1.index==84){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						} else if (_item1.enchantIndex==19) {
							return ItemData.enchantItem(_item0.clone(-1,false,true),1);
						}break;
					case 75: //Hylian Sword
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.HELMET){
							if (_item1.enchantIndex==8){
								return ItemData.enchantItem(_item0.clone(-1,false,true),0);
							}else if (_item1.enchantIndex==9){
								return ItemData.enchantItem(_item0.clone(-1,false,true),1);
							}else if (_item1.enchantIndex==11){
								return ItemData.enchantItem(_item0.clone(-1,false,true),2);
							}
						}break;
					case 76: //Plumber Gloves
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.HELMET){
							if (_item1.enchantIndex==8){
								return ItemData.enchantItem(_item0.clone(-1,false,true),0);
							}else if (_item1.enchantIndex==7){
								return ItemData.enchantItem(_item0.clone(-1,false,true),1);
							}else if (_item1.enchantIndex==11){
								return ItemData.enchantItem(_item0.clone(-1,false,true),2);
							}
						}break;
					case 77: //Boxing Gloves
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.HELMET){
							switch(_item1.enchantIndex){
								case 7: return ItemData.enchantItem(_item0.clone(-1,false,true),0);
								case 8: return ItemData.enchantItem(_item0.clone(-1,false,true),1);
								case 9: return ItemData.enchantItem(_item0.clone(-1,false,true),2);
								case 10: return ItemData.enchantItem(_item0.clone(-1,false,true),3);
								case 11: return ItemData.enchantItem(_item0.clone(-1,false,true),4);
								case 13: return ItemData.enchantItem(_item0.clone(-1,false,true),5);
							}
						}break;
					case 78: //Saruman's Staff
						if (_item1.index==21){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==20){
							return ItemData.enchantItem(_item0.clone(-1,false,true),1);
						}else if (_item1.index==18){
							return ItemData.enchantItem(_item0.clone(-1,false,true),2);
						}break;
					case 79: //Mjolnir
						if (_item1.index==80){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==72){
							return ItemData.enchantItem(_item0.clone(-1,false,true),1);
						}break;
					case 80: //Captain's Shield
						if (_item1.index==95){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 81: //Twin Scimitars
						if (_item1.index==97){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
						//???
					case 82: //Royal Scepter
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.HELMET && _item1.enchantIndex<15){
							return ItemData.enchantItem(_item0.clone(-1,false,true),_item1.enchantIndex);
						}break;
					case 83: //Neptune's Trident
						if (_item1.index==114){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==80){
							return ItemData.enchantItem(_item0.clone(-1,false,true),1);
						}break;
					case 84: //Ancient Ankh
						if (_item1.index==73){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 85: //Baseball Bat
						if (_item1.index==20){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 86: //Breaker Sword
						if (_item1.index==79){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}
					case 87: //Board with a Nail In It
						if (_item1.index==21){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==19){
							return ItemData.enchantItem(_item0.clone(-1,false,true),1);
						}else if (_item1.index==20){
							return ItemData.enchantItem(_item0.clone(-1,false,true),2);
						}break;
					case 88: //Mullet
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.WEAPON && _item1.enchantIndex==17){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 89: //Ampersand
						if (_item1.index==114){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 90: //Death Jester
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.WEAPON && _item1.enchantIndex==17){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 91: //Envenomed Mask
						if (_item1.enchantIndex==6){
							switch(_item1.index){
								case 33: return ItemData.enchantItem(_item0.clone(-1,false,true),0);
								case 97: return ItemData.enchantItem(_item0.clone(-1,false,true),1);
								case 98: return ItemData.enchantItem(_item0.clone(-1,false,true),2);
								case 99: return ItemData.enchantItem(_item0.clone(-1,false,true),3);
								
							}
						}break;
					case 92: //Rose Thorns
						if (_item1.enchantIndex==6 && _item1.index==35){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 93: //Classic Bomb
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.HELMET && _item1.enchantIndex==8){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.primary!=ItemData.HELMET && _item1.enchantIndex==11){
							return ItemData.enchantItem(_item0.clone(-1,false,true),1);
							
						}break;
					case 94: //Flying Rat
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.HELMET){
							switch(_item1.enchantIndex){
								case 7: return ItemData.enchantItem(_item0.clone(-1,false,true),0);
								case 8: return ItemData.enchantItem(_item0.clone(-1,false,true),1);
								case 9: return ItemData.enchantItem(_item0.clone(-1,false,true),2);
								case 10: return ItemData.enchantItem(_item0.clone(-1,false,true),3);
								case 11: return ItemData.enchantItem(_item0.clone(-1,false,true),4);
								case 0: return ItemData.enchantItem(_item0.clone(-1,false,true),5);
							}
						}break;
					case 95: //Chakram
						if (_item1.index==85){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					/*case 96:
					case 97:
					case 98:
					case 99:
					case 100:*/
					case 101: //Riot Helmet
						if (_item1.index==11 && _item1.enchantIndex==-1 && _item1.suffixIndex==-1){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 102: //Hell Horns
						if (_item1.index==106){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 103: //Hockey Mask
						if (_item1.index==21){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==20){
							return ItemData.enchantItem(_item0.clone(-1,false,true),1);
						}else if (_item1.index==19){
							return ItemData.enchantItem(_item0.clone(-1,false,true),2);
						}break;
					case 104: //Propeller Beanie
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.WEAPON && _item1.enchantIndex==28){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 105: //Riot Gear
						if (_item1.index==80){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 106: //Hell Hands
						if (_item1.enchantIndex==6 && (_item1.primary==ItemData.SCROLL || _item1.primary==ItemData.GRENADE)){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.enchantIndex==19) {
							return ItemData.enchantItem(_item0.clone(-1,false,true),1);
						}break;
					case 107: //Chainsaw
						if (_item1.index==21){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==19){
							return ItemData.enchantItem(_item0.clone(-1,false,true),1);
						}else if (_item1.index==20){
							return ItemData.enchantItem(_item0.clone(-1,false,true),2);
						}break;
					case 108: //Eternal Tome
						switch(_item1.index){
							case 14: return ItemData.enchantItem(_item0.clone(-1,false,true),0);
							case 15: return ItemData.enchantItem(_item0.clone(-1,false,true),1);
							case 16: return ItemData.enchantItem(_item0.clone(-1,false,true),2);
							case 17: return ItemData.enchantItem(_item0.clone(-1,false,true),3);
							case 18: return ItemData.enchantItem(_item0.clone(-1,false,true),4);
						}break;
					case 109: //Temporary Bow
						if (_item1.secondary==ItemData.UNARMED){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 110: //Dark Half Hood
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.WEAPON && _item1.enchantIndex==8){
							return ItemData.spawnItem(_item0.level,65);
						}else if (_item1.primary!=ItemData.HELMET && _item1.enchantIndex==7){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.primary!=ItemData.HELMET && _item1.enchantIndex==0){
							return ItemData.enchantItem(_item0.clone(-1,false,true),1);
						}
						break;
					case 111: //Dark Half Swords
						if (_item1.enchantIndex==6){
							switch(_item1.index){
								case 31: return ItemData.enchantItem(_item0.clone(-1,false,true),0);
								case 32: return ItemData.enchantItem(_item0.clone(-1,false,true),1);
								case 33: return ItemData.enchantItem(_item0.clone(-1,false,true),2);
								case 34: return ItemData.enchantItem(_item0.clone(-1,false,true),3);
								case 35: return ItemData.enchantItem(_item0.clone(-1,false,true),4);
								case 36: return ItemData.enchantItem(_item0.clone(-1,false,true),5);
								case 96: return ItemData.enchantItem(_item0.clone(-1,false,true),6);
								case 97: return ItemData.enchantItem(_item0.clone(-1,false,true),7);
								case 98: return ItemData.enchantItem(_item0.clone(-1,false,true),8);
								case 99: return ItemData.enchantItem(_item0.clone(-1,false,true),9);
							}
						}break;
				}
			}else{
				switch(_item0.index){
					case 112: //Pentagram
						if (_item1.index==113){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 113: //Holy Grail
						if (_item1.enchantIndex==6){
							switch(_item1.index){
								case 33: return ItemData.enchantItem(_item0.clone(-1,false,true),0);
								case 97: return ItemData.enchantItem(_item0.clone(-1,false,true),1);
								case 98: return ItemData.enchantItem(_item0.clone(-1,false,true),2);
								case 99: return ItemData.enchantItem(_item0.clone(-1,false,true),3);
								
							}
						}break;
					case 114: //Crusader's Mace
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.HELMET && (_item1.enchantIndex==5 || _item1.enchantIndex==19)){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 115: //Crusader's Helmet
						if (_item1.index==102 || _item1.index==117){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 116: //Demon Sickles
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.HELMET){
							if (_item1.enchantIndex==8){
								return ItemData.enchantItem(_item0.clone(-1,false,true),0);
							}else if (_item1.enchantIndex==7){
								return ItemData.enchantItem(_item0.clone(-1,false,true),1);
							}else if (_item1.enchantIndex==9){
								return ItemData.enchantItem(_item0.clone(-1,false,true),2);
							}else if (_item1.enchantIndex==11){
								return ItemData.enchantItem(_item0.clone(-1,false,true),3);
							}
						}break;
					case 117: //Demon Horns
						if (_item1.index==102){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 118: //Participation Award
					case 119: //Trophy
					case 120: //Big Pencil
						break;
					case 121: //Tramp Hair
						if (_item1.index==122){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 122: //Princess
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.WEAPON){
							if (_item1.enchantIndex==28){
								return ItemData.enchantItem(_item0.clone(-1,false,true),0);
							}else if (_item1.enchantIndex==19){
								return ItemData.enchantItem(_item0.clone(-1,false,true),1);
							}
						}break;
					case 123: //Masta Rasta
						if (_item1.index==88){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 124: //Sapien Hair
						if (_item1.index==69){
							return ItemData.enchantItem(_item0.clone(-1,false,true),1);
						}else if (_item1.index==64){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 125: //Multibolt
						if (_item1.index==17){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==111){
							return ItemData.enchantItem(_item0.clone(-1,false,true),1);
						}break;
					/*case 126: 
					case 127: 
					case 128: */
					
					case 129: //Sparrow's Bow
						if (_item1.isPremium()) break;
						if (_item1.primary==ItemData.WEAPON && _item1.enchantIndex>=15){
							return ItemData.enchantItem(_item0.clone(-1,false,true),_item1.enchantIndex);
						}break;
					case 130: //Bycocket
						if (_item1.isPremium()) break;
						if (_item1.primary==ItemData.HELMET && _item1.enchantIndex<15){
							return ItemData.enchantItem(_item0.clone(-1,false,true),_item1.enchantIndex);
						}break;
					case 131: //Quickdraw Quiver
						if (_item1.primary==ItemData.CHARM){
							return ItemData.enchantItem(_item0.clone(-1,false,true),_item1.enchantIndex);
						}break;
					case 132: //Sais
						if (_item1.index==80 || _item1.index==105){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 133: //Fukumen
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.HELMET && _item1.enchantIndex==14){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.primary!=ItemData.WEAPON){
							switch(_item1.enchantIndex){
								case 20: return ItemData.enchantItem(_item0.clone(-1,false,true),1);
								case 21: return ItemData.enchantItem(_item0.clone(-1,false,true),2);
								case 22: return ItemData.enchantItem(_item0.clone(-1,false,true),3);
								case 23: return ItemData.enchantItem(_item0.clone(-1,false,true),4);
							}
						}break;
					case 134: //Shurikens
						if (!_item1.isPremium() && _item1.enchantIndex==6){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 137: //Screamer
						if (_item1.index==122){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 138: //Puzzling Mask
						if (_item1.index==110){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==91){
							return ItemData.enchantItem(_item0.clone(-1,false,true),1);
						}break;
					case 139: //Big Bad Mask
						if (_item1.index==70 || _item1.index==82){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 140: //Muzzle
						if (_item1.index==83){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 141: //Ruby Visor
						if (_item1.index==73){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==111){
							return ItemData.enchantItem(_item0.clone(-1,false,true),1);
						}else if (_item1.index==101){
							return ItemData.enchantItem(_item0.clone(-1,false,true),2);
						}break;
					case 142: //Rocketman
						if (_item1.index==64){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 143: //Monacle
						if (_item1.index==91){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}break;
					case 144: //Goggles
						if (_item1.index==86){
							return ItemData.enchantItem(_item0.clone(-1,false,true),0);
						}else if (_item1.index==73){
							return ItemData.enchantItem(_item0.clone(-1,false,true),1);
						}else if (_item1.index==111){
							return ItemData.enchantItem(_item0.clone(-1,false,true),2);
						}break;
					case 145: //Dragonborn Sword
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.HELMET){
							if (_item1.enchantIndex==8){
								return ItemData.enchantItem(_item0.clone(-1,false,true),0);
							}else if (_item1.enchantIndex==9){
								return ItemData.enchantItem(_item0.clone(-1,false,true),1);
							}else if (_item1.enchantIndex==11){
								return ItemData.enchantItem(_item0.clone(-1,false,true),2);
							}
						}break;
					case 146: //Raider Sword
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.WEAPON){
							if (_item1.enchantIndex==24){
								return ItemData.enchantItem(_item0.clone(-1,false,true),1);
							}else if (_item1.enchantIndex==15){
								return ItemData.enchantItem(_item0.clone(-1,false,true),2);
							}
						}
						if (_item1.primary!=ItemData.HELMET){
							if (_item1.enchantIndex==14){
								return ItemData.enchantItem(_item0.clone(-1,false,true),0);
							}
						}
						break;
					case 147: //Wyrm's Helmet
						if (_item1.primary!=ItemData.WEAPON){
							if (_item1.isPremium()) break;
							switch(_item1.enchantIndex){
								case 20: return ItemData.enchantItem(_item0.clone(-1,false,true),0);
								case 22: return ItemData.enchantItem(_item0.clone(-1,false,true),1);
								case 23: return ItemData.enchantItem(_item0.clone(-1,false,true),2);
							} 	
						}break;
					case 148: //Raider Helmet
						if (_item1.isPremium()) break;
						if (_item1.primary!=ItemData.WEAPON){
							if (_item1.enchantIndex==24){
								return ItemData.enchantItem(_item0.clone(-1,false,true),1);
							}
						}
						if (_item1.primary!=ItemData.HELMET){
							if (_item1.enchantIndex==14){
								return ItemData.enchantItem(_item0.clone(-1,false,true),0);
							}
						}
						break;
				}
			}

      return null;
    }

    public static function getPotionResult(_item0:ItemModel,_item1:ItemModel):ItemModel{
      switch(_item0.index){
        case 31://heal
          if (_item1.index==98){
              return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          }else if (_item1.index==33){
              return ItemData.enchantItem(_item0.clone(-1,false,true),1);
          }else if (_item1.index==32){
              return ItemData.spawnItem(_item0.level,96,6);
          }
          break;
        case 32://mana
          if (_item1.index==98){
              return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          }else if (_item1.index==33){
              return ItemData.enchantItem(_item0.clone(-1,false,true),1);
          }
          break;
        case 33://amp
          if (_item1.index==99) return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          break;
        case 34://alch fire
          if (_item1.index==33){
              return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          }else if (_item1.index==98){
              return ItemData.enchantItem(_item0.clone(-1,false,true),1);
          }break;
        case 35://gas
          if (_item1.index==33){
              return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          }else if (_item1.index==98){
              return ItemData.enchantItem(_item0.clone(-1,false,true),1);
          }break;
        case 36://holy
          if (_item1.index==32){
              return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          }else if (_item1.index==35){
              return ItemData.enchantItem(_item0.clone(-1,false,true),1);
          }break;
        case 96://recovery
          if (_item1.index==99) return ItemData.enchantItem(_item0.clone(-1,false,true),1);
          break;
        case 97://celerity
          if (_item1.index==99) return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          break;
        case 98://turtle
          if (_item1.index==33) return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          break;
        case 99://purity
          if (_item1.index==35) return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          break;
      }

      return null;
    }

    public static function getMagicResult(_item0:ItemModel,_item1:ItemModel):ItemModel{
      switch(_item0.index){
        case 14: //Magic Bolt
          if (_item1.index==17) return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          if (_item1.index==111) return ItemData.enchantItem(_item0.clone(-1,false,true),1);
          break;
        case 15: //Fireball
          if (_item1.primary!=ItemData.HELMET && _item1.enchantIndex==10) return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          break;
        case 16: //Lightning
          if (_item1.primary!=ItemData.HELMET && _item1.enchantIndex==13) return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          break;
        case 17: //Searing Light
          if (_item1.index==16) return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          break;
        case 18: //Poison Bolt
          if (_item1.index==15) return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          if (_item1.index==35) return ItemData.enchantItem(_item0.clone(-1,false,true),1);
          if (_item1.index==111) return ItemData.enchantItem(_item0.clone(-1,false,true),2);
          break;
        case 19: //Confusion
          if (_item1.primary!=ItemData.WEAPON && _item1.enchantIndex==29) return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          break;
        case 20: //Cripple
          if (_item1.primary!=ItemData.HELMET && _item1.enchantIndex==12) return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          break;
        case 21: //Vulnerability
          if (_item1.primary!=ItemData.WEAPON && _item1.enchantIndex==15) return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          break;
        case 22: //Healing
          if (_item1.index==122) return ItemData.enchantItem(_item0.clone(-1,false,true),0); 
          break;
        case 23: //Empower
          if (_item1.primary!=ItemData.WEAPON && _item1.enchantIndex==28) return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          if (_item1.primary!=ItemData.WEAPON && _item1.enchantIndex==19) return ItemData.enchantItem(_item0.clone(-1,false,true),1);
          break;
        case 24: //Haste
          if (_item1.primary!=ItemData.HELMET && _item1.enchantIndex==11) return ItemData.enchantItem(_item0.clone(-1,false,true),0);
        case 25: //Enchant Weapon
          if (_item1.index==17) return ItemData.enchantItem(_item0.clone(-1,false,true),0);
          if (_item1.index==24) return ItemData.enchantItem(_item0.clone(-1,false,true),1);
          if (_item1.index==111) return ItemData.enchantItem(_item0.clone(-1,false,true),2);
          break;
      }

      return null;
    }
  }
}