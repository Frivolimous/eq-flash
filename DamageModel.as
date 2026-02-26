package{
	import ui.effects.FlyingText;
	import utils.GameData;
	import system.buffs.BuffBase;
	import system.buffs.BuffData;
	import system.buffs.BuffShield;
	import ui.effects.PopEffect;
	import system.actions.ActionBase;
	import system.effects.EffectBase;
	
	public class DamageModel{
		public static const PHYSICAL:int=13,
							MAGICAL:int=14,
							CHEMICAL:int=15,
							HOLY:int=16,
							DARK:int=17;
							
		public static const shortTypeName:Vector.<String>=new <String>[null,null,null,null,null,null,null,null,null,null,null,null,null,"PHYS","MAGI","CHEM","HOLY","DARK"];
		public static const fullTypeName:Vector.<String>=new <String>[null,null,null,null,null,null,null,null,null,null,null,null,null,"Physical","Magical","Chemical","Holy","Dark"];
		public var phys:int=0,
					magi:Number=0,
					chem:Number=0,
					holy:Number=0,
					dark:Number=0,
					physC:Boolean=false,
					magiC:Boolean=false,
					chemC:Boolean=false,
					holyC:Boolean=false,
					darkC:Boolean=false,
					
					physL:Number=0,
					magiL:Number=0,
					chemL:Number=0,
					holyL:Number=0,
					darkL:Number=0,
					
					rPen:Number=0,
					
					magiHeal:Number=0,
					
					totalMult:Number=1,
					
					buffText:String="",
					
					after:int=-1,
					numQuicks:int=0,
					
					oBuffs:Array=new Array,
					tBuffs:Array=new Array;
		
		public function addMult(i:Number){
			//totalMult*=(1+i);
			totalMult+=i;
		}
		
		public function reduceMult(i:Number){
			//totalMult/=(1+i);
			totalMult-=i;
		}
		
		public function setDmg(i:Number,_type:int,c:Boolean=false){
			//if (i<1) i=1;
			switch(_type){
				case ActionBase.PHYSICAL: phys+=i; if (c) physC=c; break;
				case ActionBase.MAGICAL: magi+=i; if (c) magiC=c; break;
				case ActionBase.CHEMICAL: chem+=i; if (c) chemC=c; break;
				case ActionBase.HOLY: holy+=i; if (c) holyC=c; break;
				case ActionBase.DARK: dark+=i; if (c) darkC=c; break;
				default:
			}
		}
		
		public function getDmg(_type:int):Number{
			switch(_type){
				case ActionBase.PHYSICAL: return phys;
				case ActionBase.MAGICAL: return magi;
				case ActionBase.CHEMICAL: return chem;
				case ActionBase.HOLY: return holy;
				case ActionBase.DARK: return dark;
			}
			return 0;
		}
		
		public function addLeech(i:Number,_type:int){
			if (isNaN(i)) return;
			switch(_type){
				case ActionBase.PHYSICAL: physL+=i; break;
				case ActionBase.MAGICAL: magiL+=i; break;
				case ActionBase.CHEMICAL: chemL+=i; break;
				case ActionBase.HOLY: holyL+=i; break;
				case ActionBase.DARK: darkL+=i; break;
				default:
			}
		}
		
		public function addHeal(i:Number){
			magiHeal+=i;
		}
		
		public function pushText(s:String){
				buffText+=" "+s;
		}
		
		public function resist(_v:SpriteModel){
			magi*=(1-_v.stats.getValue(StatModel.RMAGICAL)*(1-rPen));
			chem*=(1-_v.stats.getValue(StatModel.RCHEMICAL)*(1-rPen));
			holy*=(1-_v.stats.getValue(StatModel.RSPIRIT)*(1-rPen));
			dark*=(1-_v.stats.getValue(StatModel.RSPIRIT)*(1-rPen));
			phys*=(1-_v.stats.getValue(StatModel.RPHYS)*(1-rPen));
			
			if (physC) phys*=(1-_v.stats.getValue(StatModel.RCRIT));
			if (magiC) magi*=(1-_v.stats.getValue(StatModel.RCRIT));
			if (chemC) chem*=(1-_v.stats.getValue(StatModel.RCRIT));
			if (holyC) holy*=(1-_v.stats.getValue(StatModel.RCRIT));
			if (darkC) dark*=(1-_v.stats.getValue(StatModel.RCRIT));
		}
		
		public function reset(){
			phys=magi=chem=holy=dark=0;
			physL=magiL=chemL=holyL=darkL=0;
			rPen=0;
			physC=magiC=chemC=holyC=darkC=false;
			magiHeal=0;
			totalMult=1;
			buffText="";
			after=-1;
			numQuicks=0;
			oBuffs=new Array;
			tBuffs=new Array;
		}
		
		public function total():int{
			return totalMult*(int(phys)+int(magi)+int(chem)+int(holy)+int(dark));
		}
		
		public function totalLeech():int{
			return (totalMult*(phys*physL+magi*magiL+chem*chemL+holy*holyL+dark*darkL)+magiHeal);
		}
		
		public function applyDamage(_o:SpriteModel,_t:SpriteModel,_primaryDisplay:Boolean=false){
			if (total()>0){
				resist(_t);
				var _dmg:Number=total();
				
				var _reduction:Number=0;
				for (var i:int=0;i<_t.buffList.numBuffs();i+=1){
					var _buff:BuffBase=_t.buffList.getBuff(i);
					if (_buff is BuffShield){
						_reduction+=(_buff as BuffShield).getReduction(_t,_dmg);
						_dmg-=_reduction;
					}
					if (_dmg<=0) break;
				}
				if (_reduction>0){
					graphicEffect(POP,_t,PopEffect.CLEAR_BUBBLE);
					graphicEffect(FLYING_TEXT,_t,{text:("<font color='#ddeeff'>"+Math.floor(_reduction)+"</font>"), offX:40});
				}
				
				_t.healthDamage(_dmg);
				
				_t.stats.useEffects(EffectBase.INJURED,new DamageModel,_t,_o,null);
				
				graphicEffect(FLYING_TEXT,_t,{text:dmgText()});
				
				if (_primaryDisplay){
					if (_t.getHealth()>0 && _o.view.tweenA==SpriteView.DOUBLE_ATTACK){
						graphicEffect(ADD_T_DAMAGE,_o,total());
					}else{
						graphicEffect(ADD_DAMAGE,_o,total());
					}
						
					if (_o==Facade.gameM.playerM){
						GameData.setHigherScore(GameData.SCORE_DAMAGE,total());
					}
				}
			}
			
			if (totalLeech()>0){
				_o.healthHeal(totalLeech());
				graphicEffect(FLYING_TEXT,_o,{text:leechText()});
			}
		}
		
		public function applyBuffs(_o:SpriteModel,_t:SpriteModel){
			while (oBuffs.length>0){
				if (oBuffs[0] is BuffBase){
					_o.buffList.addBuff(oBuffs.shift());
				}else if (oBuffs[0] is String){
					_o.buffList.removeBuffCalled(oBuffs.shift());
				}
			}
			if (_t!=null){
				while (tBuffs.length>0){
					if (tBuffs[0] is BuffBase){
						_t.buffList.addBuff(tBuffs.shift());
					}else if (tBuffs[0] is String){
						_t.buffList.removeBuffCalled(tBuffs.shift());
					}
				}
			}
			if (numQuicks>0){
				_o.strike=numQuicks+1;
			}
			
			if (after!=-1){
				graphicEffect(POP,_t,after);
			}
		}
		
		public function dmgText():String{
			var m:String="";
			var _plus:Boolean=false;
			if (phys>0){
				m+="<font color='#ff4411'>"+String(int(phys*totalMult));
				if (physC) m+=FlyingText.CRITICAL;
				m+="</font>"
				_plus=true;
			}
			
			if (magi>0){
				m+="<font color='#ff00cc'>";
				if (_plus) m+="+";
				m+=String(int(magi*totalMult));
				if (magiC) m+=FlyingText.CRITICAL; 
				m+="</font>"
				_plus=true;
			}
			
			if (chem>0){
				m+="<font color='#ffcc00'>";
				if (_plus) m+="+";
				m+=String(int(chem*totalMult));
				if (chemC) m+=FlyingText.CRITICAL;
				m+="</font>"
				_plus=true;
			}
			
			if (holy>0){
				m+="<font color='#ffff00'>";
				if (_plus) m+="+";
				m+=String(int(holy*totalMult));
				if (holyC) m+=FlyingText.CRITICAL;
				m+="</font>"
				_plus=true;
				
			}
			if (dark>0){
				m+="<font color='#770077'>";
				if (_plus) m+="+";
				m+=String(int(dark*totalMult));
				if (darkC) m+=FlyingText.CRITICAL;
				m+="</font>"
				_plus=true;
			}
			m+=buffText;
			return m;
		}
		
		public function healText():String{
			var m:String="<font color='#00ffff'>"+String(total())+"</font>";
			m+=buffText;
			return m;
			/*var m:String="";
			var _plus:Boolean=false;
			if (phys>0){
				m+="<font color='#5555ff'>"+String(int(phys*totalMult));
				if (physC) m+=FlyingText.CRITICAL;
				m+="</font>"
				_plus=true;
			}
			
			if (magi>0){
				m+="<font color='#5555ff'>";
				if (_plus) m+="+";
				m+=String(int(magi*totalMult));
				if (magiC) m+=FlyingText.CRITICAL;
				m+="</font>"
				_plus=true;
			}
			
			if (chem>0){
				m+="<font color='#00ffff'>";
				if (_plus) m+="+";
				m+=String(int(chem*totalMult));
				if (chemC) m+=FlyingText.CRITICAL;
				m+="</font>"
				_plus=true;
			}
			
			if (holy>0){
				m+="<font color='#7777ff'>";
				if (_plus) m+="+";
				m+=String(int(holy*totalMult));
				if (holyC) m+=FlyingText.CRITICAL;
				m+="</font>"
				_plus=true;
			}
			
			if (dark>0){
				m+="<font color='#7777ff'>";
				if (_plus) m+="+";
				m+=String(int(dark*totalMult));
				if (darkC) m+=FlyingText.CRITICAL;
				m+="</font>"
				_plus=true;
			}
			m+=buffText;
			return m;*/
		}
		
		public function leechText():String{
			var m:String="<font color='#00ffff'>"+String(totalLeech())+"</font>";
			m+=buffText;
			return m;
			
			/*var m:String="";
			var _plus:Boolean=false;
			if (phys>0 && physL>0){
				m+="<font color='#5555ff'>"+String(int(phys*physL*totalMult));
				m+="</font>"
				_plus=true;
			}
			
			if ((magi>0 && magiL>0) || magiHeal>0){
				m+="<font color='#5555ff'>";
				if (_plus) m+="+";
				m+=String(int(magi*magiL*totalMult+magiHeal));
				m+="</font>"
				_plus=true;
			}
			
			if (chem>0 && chemL>0){
				m+="<font color='#00ffff'>";
				if (_plus) m+="+";
				m+=String(int(chem*chemL*totalMult));
				m+="</font>"
				_plus=true;
			}
			
			if (holy>0 && holyL>0){
				m+="<font color='#7777ff'>";
				if (_plus) m+="+";
				m+=String(int(holy*holyL*totalMult));
				m+="</font>"
				_plus=true;
			}
			
			if (dark>0 && darkL>0){
				m+="<font color='#7777ff'>";
				if (_plus) m+="+";
				m+=String(int(dark*darkL*totalMult));
				m+="</font>"
				_plus=true;
			}
			m+=buffText;
			return m;*/
		}
		
		public static const FLYING_TEXT:int=0,
							ADD_T_DAMAGE:int=1,
							ADD_DAMAGE:int=2,
							POP:int=3;
							
							/*ADD_ACTION:int=1,
							ADD_DEFEND:int=2,
							ADD_HEAL:int=3,
							ADD_EFFECT:int=4,
							SET_POSITIONS:int=5;*/
							
		public function graphicEffect(_type:int,_v:SpriteModel,_obj:*){
			if (GameModel.SIMULATED) return;
			
			switch(_type){
				case FLYING_TEXT: new FlyingText(_v,_obj.text,0,(_obj.offX!=null?_obj.offX:0),(_obj.offX!=null?_obj.offX:0)); break;
				case ADD_T_DAMAGE: Facade.gameUI.actionText.addTDmg(_obj); break;
				case ADD_DAMAGE: Facade.gameUI.actionText.addDmg(_obj); break;
				case POP:
					new PopEffect(_v,_obj);
					break;
			}
		}
		
	}
}