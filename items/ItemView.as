package items{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.filters.ColorMatrixFilter;
	
	public class ItemView extends DefaultIcon{
		public static const WIDTH:Number=35;
		public static const OFF_X:Number=1.5;
		public static const OFF_Y:Number=1.5;
		
		public var model:ItemModel;
		public var location:BaseInventoryUI;
		
		public function ItemView(_model:ItemModel){
			index=-1;
			mouseChildren=false;
			name=MouseControl.ITEM;
			buttonMode=true;
			
			//addChild(vectorIcon);
			finishView(_model);
		}
		
		function finishView(_model:ItemModel){
			model=_model;
			model.view=this;
			if (vectorIcon==null) vectorIcon=new ItemIcon;
			//stored.width=WIDTH;
			//stored.scaleY=stored.scaleX;
			switch(_model.slot){
				case ItemData.EQUIPMENT: vectorIcon.back.gotoAndStop(1); vectorIcon.border.gotoAndStop(1); break;
				case ItemData.USEABLE: vectorIcon.back.gotoAndStop(2); vectorIcon.border.gotoAndStop(2); break;
				case ItemData.TRADE: default: vectorIcon.back.gotoAndStop(3); vectorIcon.border.gotoAndStop(3); break;
			}
			
			if (model.index>=50 && model.index<64){
				if (model.index<=61){
					vectorIcon.front.gotoAndStop(model.index-35);//scroll
					vectorIcon.parchment.gotoAndStop(2);
				}else if (model.index==62){
					vectorIcon.front.gotoAndStop(51);
					vectorIcon.parchment.gotoAndStop(1);
				}
			}else{
				vectorIcon.front.gotoAndStop(model.index+1);
				vectorIcon.parchment.gotoAndStop(1);
			}
			var _glow:GlowFilter;
			var _color:ColorMatrixFilter;
			
			if (_model.suffixIndex>=0){
				_glow=glow2();
			}
			
			if (model.index==119){
				if (model.enchantIndex==1){
					_color=recolor(1.3,1.2,0.7);
				}else if (model.enchantIndex==2){
					_color=recolor(1,1,1.2);
				}else if (model.enchantIndex==3){
					_color=recolor(1,0.7,0.6);
				}else{
					_color=recolor(0.6,1,0.7);
				}
			}else if (model.index==135){
				if (model.suffixIndex>30){
					_color=FilterData.getPremiumFilter(model.suffixIndex,0);
				}else if (model.suffixIndex>=0){
					_color=enchantFilter(model.suffixIndex);
				}else if (model.enchantIndex==0){
					_color=recolor(1,1.4,0.6);
				}else if (model.enchantIndex==1){
					_color=recolor(1.4,0.6,1);
				}else if (model.enchantIndex==2){
					_color=recolor(1,0.42,0.7);
				}else if (model.enchantIndex==3){
					_color=FilterData.getEssenceFilter(3);
				}
			}else{
				if (_model.enchantIndex>=0){
					if (_model.isPremium() || _model.primary==ItemData.MAGIC || ((_model.primary==ItemData.POTION || _model.primary==ItemData.GRENADE) && _model.enchantIndex!=6)){
						if (_model.charges>=0 && _model.enchantIndex==6){
							_glow=glow();
						}else{
							_color=FilterData.getPremiumFilter(_model.index,_model.enchantIndex);
						}
					}else if (_model.isShadow()){
						_color=darken();
						if (_glow==null) _glow=darkGlow();
					}else{
						if (_model.primary==ItemData.CHARM){
							_color=enchantFilter(_model.enchantIndex);
						}else{
							if (_glow==null){
								_glow=glow();
							}
						}
					}
				}
			} 
			var _filters:Array=[];
			if (_color!=null) _filters.push(_color);
			if (_glow!=null) _filters.push(_glow);
			if (_filters.length>0){
				vectorIcon.front.filters=_filters;
			}
			
			if (model.charges>=0){
				makeCounter(30,17,0xffffff,10);
				counter.text=String(model.charges);
			}
			makeBitmap(vectorIcon,OFF_X,OFF_Y,WIDTH);
		}
		
		function recolor(r:Number,g:Number,b:Number):ColorMatrixFilter{
			return new ColorMatrixFilter([r,0,0,0,0,
											  0,g,0,0,0,
											  0,0,b,0,0,
											  0,0,0,1,0]);
		}
		
		function glow():GlowFilter{
			return new GlowFilter(0x00ffff,1,5,5,2,1);
		}
		
		function glow2():GlowFilter{
			return new GlowFilter(0xffcc00,1,5,5,2,1);
		}
		
		function darkGlow():GlowFilter{
			return new GlowFilter(0xffffff,1,5,5,2,1);
		}
		
		function darken():ColorMatrixFilter{
			return new ColorMatrixFilter([0.4,-0.1,-0.1,0,0,
										  -0.05,0.45,-0.05,0,0,
										  -0.05,-0.05,0.45,0,0,
										  0,0,0,1,0]);
		}
		
		function enchantFilter(i:int):ColorMatrixFilter{
			switch(i){
				case 0: return recolor(1.3,1.3,1.3); //Master's (NON)
				case 1: return recolor(1.2,0.6,1.5); //Focal
				case 2: return recolor(1.3,.9,.9); //Mystic
				case 3: return recolor(.9,.9,1.3); //Guided
				case 4: return recolor(0.8,.8,.8); //Keen
				case 5: return recolor(1.3,1.1,0.4); //Grenadier
				case 6: return recolor(1,1,1); //Defender
				case 7: return recolor(1.5,0.9,0.9); //Flaming
				case 8: return recolor(1.8,1.8,1.1); //Brilliant
				case 9: return recolor(0.9,1.5,0.9); //Venomous
				case 10: return recolor(1.6,1.3,0.8); //Explosive
				case 11: return recolor(.7,.7,.7); //Cursing
				case 12: return recolor(1,.6,.9); //Vampiric
				case 13: return recolor(1.4,1.4,1); //Dazzling
				case 14: return recolor(0.5,0.5,1.4); //Reflective
				case 15: return recolor(1,1,1); //Master's
				case 16: return recolor(.8,.8,1.9); //Wizard
				case 17: return recolor(0.8,1.4,0.8); //Troll's
				case 18: return recolor(.8,1.4,.8); //Channeling
				case 19: return recolor(1.5,1.5,0.6); //Light
				case 20: return recolor(0.8,1.1,1.3); //Warded
				case 21: return recolor(1.5,1.2,0.8); //Alchemist
				case 22: return recolor(1.5,1.5,1.1); //Virtuous
				case 23: return recolor(1.2,0.8,1.2); //Protective
				case 24: return recolor(0.8,0.8,1.2); //Seeking
				case 25: return recolor(.7,.7,.7); //Cloaking
				case 26: return recolor(0.9,0.7,0.9); //Utility
				case 27: return recolor(1,1,1); //Spikey
				case 28: return recolor(1.7,.9,.9); //Berserker
				case 29: return recolor(.8,.8,.6); //Fearsome
			}
			return null;
		}
		
		public function update(_model:ItemModel){
			model.view=null;
			_Desc=null;
			
			finishView(_model);
		}
		
		override public function get tooltipName():String{
			return model.name;
		}
				
		override public function get tooltipDesc():String{
			if (_Desc==null){
				_Desc=StringData.getItemDesc(model);
			}
			return _Desc;
		}
		
		/*override public function dispose(){
			//if (model.view==this){
				//model.view=null;
			//}
			//bitmap.bitmapData.dispose();
			if (parent!=null){
				parent.removeChild(this);
			}
		}*/
	}
}