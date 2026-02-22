package {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import ui.effects.PopEffect;
	import system.actions.ActionBase;
	import system.actions.ActionData;
	import system.effects.EffectData;
	import items.FilterData;
	
	public class ProjectileObject extends Sprite{
		public static const STRAIGHT:String="straight";
		public static const ARC:String="arc";
		public static const REVERSE_ARC:String="reverse arc";
		public static const STATIC:String="static";
		public static const STATIC_ORIGIN:String="static origin";
		public static const RETURN:String="return";
		
		static const DONE:int=10;
		static const HALF:int=5;
		
		var projectileVector:MovieClip=new ProjectileVector;
		var staticVector:MovieClip=new StaticVector;
		var direction:int;
		var after:int;
		
		
		public var vX:Number;
		public var tX:Number;
		//public var hX:Number;
		
		
		public var vY:Number;
		public var tY:Number;
		//public var hY:Number;
		
		public var counter:int;
		
		public var type:String;
		
		public var tFunction:Function;
		public var tTarget:SpriteModel;
		public var tAction:ActionBase;
		public var tOrigin:SpriteModel;
		
		public var exists:Boolean;
		public var simpleMode:Boolean;
		
		//public var numProj:int=0;

		public function ProjectileObject(_action:ActionBase=null,_v:SpriteModel=null,_t:SpriteModel=null){
			addChild(projectileVector);
			if (_action!=null){
				makeEffect(_action,_v,_t);
			}
		}
		
		public function makeEffect(_action:ActionBase,_v:SpriteModel,_t:SpriteModel){
			if (tFunction!=null){
				endTimer();
			}
			switch(_action.label){
				case ActionData.ALCH_POT: 	update(1,1,ARC); break;
				case ActionData.POISON_POT: update(2,0,ARC); break;
				case ActionData.HOLY_POT: 	update(3,0,ARC); break;
				
				case ActionData.SHOOT: 		update(4,-1); break;
				case ActionData.THROW_D: 	update(5,-1); break;
				case ActionData.THROW_A: 	update(6,-1); break;
				case ActionData.THROW_BATARANG: update(11,-1); break;
				case ActionData.SHURIKEN: update(16,-1); break;
				case ActionData.THROW_CHAKRAM: update(10,-1,RETURN); break;
				
				case ActionData.MULTI_BOLT: 
				case ActionData.MISSILE: 	update(7,0); break;
				case ActionData.FIREBALL: 	update(8,1); break;
				case ActionData.POISON: 	update(9,1); break;
				
				case ActionData.THROW_BOMB:	update(12,-1,ARC); break;
				case ActionData.THROW_ROSE2:
				case ActionData.THROW_ROSE: update(13,-1,ARC); break;
				
				case ActionData.LIGHTNING: update(1,-1,STATIC); break;
				case ActionData.SEARING: update(2,-1,STATIC); break;
				case ActionData.DARK_BLAST: update(3,-1,STATIC); break;
				case ActionData.HEALING: case ActionData.HEALING_POT: case ActionData.MANA_POT: case ActionData.ENERGIZE: 
					update(4,-1,STATIC); break;
				case ActionData.BASH: _v.endTimer(); return;
				
				case ActionData.SPINES: update(3,-1,STATIC); break;
				case ActionData.CYCLOPS: update(6,-1,STATIC_ORIGIN); break;
				case ActionData.SCREAMER: update(7,-1,STATIC_ORIGIN); break;
				case ActionData.ATTACK:
					switch(_action.source.index){
						case 126: update(4,-1); //Shortbow
							break;
						case 127: case 128: //SHOTGUN TEST / RIFLE TEST
							update(5,-1,STATIC);
							break;
						case 80: //Captain's Shield
							update(14,-1,RETURN);
							_v.view.weaponVisible(false);
							break;
						case 79: //Mjolnir
							update(19,-1,RETURN);
							_v.view.weaponVisible(false);
							break;
						case 83: //Trident
							update(18,-1);
							_v.view.weaponVisible(false);
							break;
						case 105: //Riot Shield
							update (17,-1,RETURN);
							_v.view.weaponVisible(false);
							break;
						case 75: update(15,0); break;// Hylian Sword
						default: update(4,-1); break;
					}
					break;
				default: 
					if (_v.tTarget==_v){
						_action.postAnim(_v,_t); return;
					}else{
						update(4,-1,STATIC); break;
					}
			}
			if (_action.hasTag(EffectData.RETURN)){
				type=RETURN;
			}
			
			Facade.soundC.testEffect(_v.label);
			tFunction=_action.postAnim;
			tTarget=_t;
			tAction=_action;
			tOrigin=_v;
			_v.clearTimer();
			
			if (tOrigin==Facade.gameM.enemyM){
				invert();
			}
			if (type==STATIC){
				var _filter:*=FilterData.getPremiumFilter(_action.source.index,_action.source.enchantIndex)
				if (_filter!=null){
					staticVector.filters=[_filter];
				}
				x=tTarget.view.display.hitPoint.x+tTarget.view.x;
				//hX=x+.3;
				tX=x+.5;
				y=_v.view.y+_v.view.display.y;
			}else if (type==STATIC_ORIGIN){
				_filter=FilterData.getPremiumFilter(_action.source.index,_action.source.enchantIndex)
				if (_filter!=null){
					staticVector.filters=[_filter];
				}
				x=_v.view.display.throwPoint.x+_v.view.x;
				//hX=x+.3;
				tX=x+.5;
				y=_v.view.display.throwPoint.y+_v.view.display.y+_v.view.y;
			}else{
				_filter=FilterData.getPremiumFilter(_action.source.index,_action.source.enchantIndex)
				if (_filter!=null){
					projectileVector.filters=[_filter];
				}
				x=_v.view.display.throwPoint.x+_v.view.x;
				tX=_t.view.display.hitPoint.x+_t.view.x;
				//hX=(tX+x)/2;
				
				y=_v.view.display.throwPoint.y+_v.view.display.y+_v.view.y;
				tY=_t.view.display.hitPoint.y+_t.view.y;
				//hY=(tY+y)/2;
			}
			
			vX=(tX-x)/10;
			vY=(tY-y)/10;
			if (type==RETURN){
				vX*=2.5;
				vY*=2.5;
			}
			Facade.gameUI.gameV.addChild(this);
		}
		
		public function update(_frame:int,_after:int,_type:String="straight"){
			if (_type==STATIC || _type==STATIC_ORIGIN){
				if (_frame==staticVector.currentFrame){
					staticVector.effect.gotoAndPlay(1);
				}else{
					staticVector.gotoAndStop(_frame);
				}
				if (contains(projectileVector)){
					removeChild(projectileVector);
					addChild(staticVector);
				}
			}else{
				projectileVector.gotoAndStop(_frame);
				if (contains(staticVector)){
					removeChild(staticVector);
					addChild(projectileVector);
				}
			}
			counter=0;
			
			exists=true;
			type=_type;
			
			after=_after;
			projectileVector.scaleX=direction=1;
		}
		
		public function tick(){
			if (!exists) return;
			counter+=1;
			
			if (type==STATIC || type==STATIC_ORIGIN){
				if (counter==HALF){
					endTimer();
				}else if(counter==DONE){
					remove();
				}
			}else{
				if (type==RETURN){
					x+=vX;
					y+=vY;
					if (counter==(HALF-3)){
						var _tA:ActionBase=tAction.source.action.modify(tOrigin);
						var _tO:SpriteModel=tOrigin;
						var _tT:SpriteModel=tTarget;
						endTimer();	/***/
						_tA.setDefense(_tO,_tT);
						resetTimer(_tA.postAnim,_tA,_tT,_tO);
						//tOrigin.strike=1;
					}else if (counter==HALF){
						vX=-vX;
						vY=-vY;
					}else if (counter==(HALF+3)){
						endTimer();
					}else if (counter==DONE){
						remove();
					}
				}else{
					if (type==ARC){
						if (counter>=HALF){
							y+=10;
						}else{
							y-=10;
						}
					}else if (type==REVERSE_ARC){
						if (counter>=HALF){
							y-=10;
						}else{
							y+=10;
						}
					}
					x+=vX;
					y+=vY;
					if (counter>=DONE){
						switch(projectileVector.currentFrame){
							case 1: case 8: new PopEffect(tTarget,PopEffect.FIRE); break; //FIRE
							case 7: new PopEffect(tTarget,PopEffect.MAGIC); break;//MAGIC
							case 2: case 9: new PopEffect(tTarget,PopEffect.TOXIC); break;//TOXIC
							case 3: new PopEffect(tTarget,PopEffect.HOLY); break; //HOLY
						}
						endTimer();
						remove();
					}
				}
			}
		}
		
		public function invert(){
			projectileVector.scaleX=direction=-1;
		}
		
		public function resetTimer(_tF:Function,_tA:ActionBase,_tT:SpriteModel,_tO:SpriteModel){
			tFunction=_tF;
			tAction=_tA;
			tOrigin=_tO;
			tTarget=_tT;
		}
		
		public function endTimer(){
			var _tF:Function=tFunction;
			var _tA:ActionBase=tAction;
			var _tT:SpriteModel=tTarget;
			var _tO:SpriteModel=tOrigin;
			tFunction=null;
			tAction=null;
			tTarget=null;
			//tOrigin=null;
			_tF(_tO,_tT);
		}
		
		public function clearTimer(){
			tFunction=null;
			tAction=null;
			tTarget=null;
			remove();
		}
		
		public function remove(){
			if (tOrigin!=null) tOrigin.view.weaponVisible(true);
			/*if (projectileVector.currentFrame==14 && tOrigin!=null){
				tOrigin.view.weaponVisible(true);
			}*/
			exists=false;
			if (parent!=null) parent.removeChild(this);
		}
		
		public function setSimpleMode(b:Boolean){
			simpleMode=b;
			projectileVector.visible=!b;
			staticVector.visible=!b;
		}
	}
}