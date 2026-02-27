package{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import items.ItemModel;
	import items.ItemData;
	import items.FilterData;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import ui.GameUI;
	import ui.assets.DisplayBar;
	import ui.effects.ConstantEffect;
	import system.buffs.BuffData;
	import sprites.BallHat;
	import skills.SkillData;
	import system.actions.ActionBase;
	import system.actions.ActionData;


	public class SpriteView extends MovieClip{
		public static const IDLE:String="idle",
							WALK:String="run",
							APPROACH:String="approach",
							LEAP:String="leap",
							CRIT:String="crit",
							DOUBLE_ATTACK:String="double attack",
							ATTACK:String="attack",
							CAST:String="spell",
							BLOCK:String="block",
							DODGE:String="dodge",
							DODGE_LONG:String="dodgeLong",
							IGNORED:String="ignored",
							HURT:String="hurt",
							KNOCKBACK:String="knockback",
							KNOCKBACK_REVERSED:String="knock rev",
							DIE:String="death",
							THROW:String="throwProjectile",
							DTHROW:String="defensive throw",
							TURN:String="turnSpell",
							FREEZE:String="freeze",
							UNFREEZE:String="unfreeze",
							CONFUSED:String="confused",
							AFRAID:String="afraid",
							ENTRANCED:String="entranced",
							WITHDRAW:String="withdraw",
							PAUSE:String="pause",
							UNPAUSE:String="unpause";
							
		public var display:MovieClip;
		var model:SpriteModel;
		var _Enchanted:Boolean;
		
		public var weaponFilter:ColorMatrixFilter;
		public var helmetFilter:ColorMatrixFilter;
		
		var _Filters:Array;
		var berzerkFilter:ColorMatrixFilter=new ColorMatrixFilter([.7,.2,.2,0,0,
																   0,.5,0,0,0,
																   0,0,.5,0,0,
																   0,0,0,1,0]);
										  
		var shadowFilter:ColorMatrixFilter=new ColorMatrixFilter([0,-1,-1,0,255,
																  -1,0,-1,0,255,
																  -1,-1,0,0,255,
																  -.9,-.9,-.9,1,0]);
																  
		var shadowItemFilter:ColorMatrixFilter=new ColorMatrixFilter([0.4,-0.1,-0.1,0,0,
																   -0.05,0.45,-0.05,0,0,
																   -0.05,-0.05,0.45,0,0,
																   0,0,0,1,0]);
																   
		var empoweredFilter:GlowFilter= new GlowFilter(0x44bbff,1,30,30,1,1);
		var empoweredFilter2:GlowFilter=new GlowFilter(0xff4444,1,30,30,1,1);
		var empoweredFilter3:GlowFilter=new GlowFilter(0xbbff44,1,30,30,1,1);
		
		public var healthBar:DisplayBar;
		public var manaBar:DisplayBar;
		
		public var tweenA:String;
		var tweenI:int;
		var _Inverted:int=1;
		
		public var overhead:OverheadEffect=new OverheadEffect;
		public var onfoot:OnFoot=new OnFoot;
		public var constants:ConstantEffect=new ConstantEffect;
		
		public var simpleMode:Boolean=false;
		
		public function SpriteView(m:SpriteModel=null){
			y=GameUI.FLOOR_Y;
			model=m;
			mouseChildren=false;
			addChild(overhead);
			addChild(constants);
		}
		
		public function toIdle(){
			if (tweenA==DOUBLE_ATTACK || tweenA==APPROACH || tweenA==LEAP || tweenA==AFRAID || tweenA==ENTRANCED || tweenA==WITHDRAW || tweenA==KNOCKBACK || tweenA==KNOCKBACK_REVERSED){
				action(IDLE);
			}
		}
		
		public function fromAction(_action:ActionBase,_extra:int=0){
			if (_action.isDouble()){ 
				action(DOUBLE_ATTACK,_extra);
			} else if (_action.label==ActionData.BASH){
				action(DTHROW,_extra);
			} else if (_action.source!=null){
				if (_action.source.primary==ItemData.WEAPON){
					action(ATTACK,_extra);
				}else if ((_action.source.primary==ItemData.POTION)||(_action.source.primary==ItemData.PROJECTILE)||(_action.source.primary==ItemData.GRENADE)){
					action(THROW,_extra);
				}else{
					action(CAST,_extra);
				}
			}
		}
		
		public function defended(_a:String){
			var _delay:int=0;
			//if thrown, delay 3;
			//block always delay 2;
			//turn projectile delay 3;
			switch(_a){
				case BLOCK:
					_delay=3; break;
				case DODGE:
					break;
				case DODGE_LONG:
					_a=DODGE;
					_delay=10;
					break;
				case TURN:
					_delay=10; break;
					
			}
			
			action(_a,_delay);
		}
		
		public function action(_a:String,_extra:int=0){
			if (display==null) return;
			if ((_a!=PAUSE)&&(_a!=UNPAUSE)&&(_a!=UNFREEZE)&&(_a!=FREEZE)){
				if ((tweenA==KNOCKBACK || tweenA==KNOCKBACK_REVERSED) && _a==HURT) return;
				tweenA=_a;
				tweenI=0;
			}
			Facade.soundC.testAction(_a,this);
			switch(_a){
				case BLOCK: case DODGE: case TURN:
					if (_extra>0){
						tweenI=_extra;
						tweenA=_a;
					}else{
						display.gotoAndPlay(_a);
					}
					break;
				case IGNORED: break;
				case IDLE: case CAST: case DIE: case THROW:
				case LEAP: case HURT: case WALK:
					display.gotoAndPlay(_a); break;
				case DOUBLE_ATTACK: case ATTACK: 
					if (_extra==1){
						display.gotoAndPlay(LEAP);
					}else if (_extra==2){
						display.gotoAndPlay("attack");
					}else if (_extra==3){
						display.gotoAndPlay("attack2");
					}else{
						if (Math.random()<=0.5) display.gotoAndPlay("attack"); else display.gotoAndPlay("attack2");
					}
					break;
				case PAUSE: case FREEZE: display.stop(); break;
				case UNPAUSE: if (tweenA!=FREEZE) display.play(); break;
				case UNFREEZE: if (tweenA==FREEZE) {action(IDLE);}else{display.play();} break;
				case CONFUSED: display.gotoAndStop(2); break;
				case KNOCKBACK: case KNOCKBACK_REVERSED: display.gotoAndPlay(HURT); display.stop(); break;
				case DTHROW: display.gotoAndPlay(BLOCK); break;
				case AFRAID: case WITHDRAW: display.gotoAndPlay(DODGE); break;
				case ENTRANCED: case APPROACH: display.gotoAndPlay(WALK); break;
			}
		}
		
		public function backTwo(){
			display.gotoAndPlay(display.currentFrame-2);
		}
		
		public function backThree(){
			display.gotoAndPlay(display.currentFrame-4);
		}
		
		public function tick(){
			if (tweenI==0&&((display==null)||((display.currentFrame<=3)&&(tweenA!=IDLE)&&(tweenA!=APPROACH)&&(tweenA!=WALK)))){
				tweenA=IDLE;
			}
			
			switch (tweenA){
				case IDLE: case IGNORED: break;
				case WALK: x+=_Inverted*6; break;
				case APPROACH:
					x+=_Inverted*6;
					if ((Facade.gameM.distance==GameModel.NEAR && Facade.gameUI.cDistance()<=GameUI.NEAR) || (Facade.gameM.distance==GameModel.FAR && Facade.gameUI.cDistance()<=GameUI.FAR)){
						action(IDLE);
						Facade.gameUI.setPositions();
						model.endTimer();
					}
					break;
				case ENTRANCED:
					x+=_Inverted*6;
					if ((Facade.gameM.distance==GameModel.NEAR && Facade.gameUI.cDistance()<=GameUI.NEAR) || (Facade.gameM.distance==GameModel.FAR && Facade.gameUI.cDistance()<=GameUI.FAR)){
						action(IDLE);
						Facade.gameUI.setPositions();
					}
					break;
				case AFRAID:
					x-=_Inverted*12;
					if ((Facade.gameM.distance==GameModel.FAR && Facade.gameUI.cDistance()>=GameUI.FAR) || (Facade.gameM.distance==GameModel.VERY && Facade.gameUI.cDistance()>=GameUI.VERY)){
						tweenA=IDLE;
						Facade.gameUI.setPositions();
					}
					break;
				case WITHDRAW:
					x-=_Inverted*12;
					if ((Facade.gameM.distance==GameModel.FAR && Facade.gameUI.cDistance()>=GameUI.FAR) || (Facade.gameM.distance==GameModel.VERY && Facade.gameUI.cDistance()>=GameUI.VERY)){
						tweenA=IDLE;
						Facade.gameUI.setPositions();
						model.endTimer();
					}
					break;
				case LEAP:
					x+=_Inverted*12;
					var _jDist:Number=GameUI.ENEMY_X_FAR-GameUI.ENEMY_X_NEAR;
					var _cPos:Number=Facade.gameUI.cDistance()-GameUI.ENEMY_X_NEAR+GameUI.PLAYER_X;
					
					y=GameUI.FLOOR_Y-Math.abs(_cPos-_jDist/2)/_jDist*30;
					
					//y=GameUI.FLOOR_Y-(1-Math.abs(Facade.gameUI.cDistance()-150)/50)*30;
					if (Facade.gameUI.cDistance()<=GameUI.NEAR){
						Facade.gameUI.setPositions();
						if ((model.equipment[0]==null)||(model.equipment[0].secondary==ItemData.DOUBLE)){
							tweenA=DOUBLE_ATTACK;
						}else{
							tweenA=ATTACK;
						}
					}
					break;
				case KNOCKBACK:
					x-=_Inverted*24;
					if ((Facade.gameM.distance==GameModel.FAR && Facade.gameUI.cDistance()>=GameUI.FAR) || (Facade.gameM.distance==GameModel.VERY && Facade.gameUI.cDistance()>=GameUI.VERY) || (Facade.gameM.distance==GameModel.NEAR && Facade.gameUI.cDistance()>=GameUI.NEAR)){
						Facade.gameUI.setPositions();
						tweenA=IDLE;
					}
					break;
				case KNOCKBACK_REVERSED:
					x+=_Inverted*24;
					if ((Facade.gameM.distance==GameModel.FAR && Facade.gameUI.cDistance()<=GameUI.FAR) || (Facade.gameM.distance==GameModel.NEAR && Facade.gameUI.cDistance()<=GameUI.NEAR) || (Facade.gameM.distance==GameModel.VERY && Facade.gameUI.cDistance()<=GameUI.VERY)){
						Facade.gameUI.setPositions();
						tweenA=IDLE;
					}
					break;
				case DTHROW:
					if (tweenI<2){
					}if (tweenI<=6){
						display.x+=8*_Inverted;
						if (tweenI==6){
							model.endTimer();
						}
					}else if (tweenI<=16){
						display.x-=4*_Inverted;
					}else{
						Facade.gameUI.setPositions();
						tweenA=IDLE;
					}
					tweenI+=1;
					break;
				case CONFUSED:
					if (tweenI%10==0){
						display.scaleX*=-1;
					}
					if (tweenI>30){
						Facade.gameUI.setPositions();
						action(IDLE);
					}
					tweenI+=1;
					break;
				case DODGE: case BLOCK: case TURN:
					if (tweenI>0){
						tweenI-=1;
						if (tweenI==0){
							display.gotoAndPlay(tweenA);
						}
					}
					break;
				default: null;
			}
			
			updateBuffs();
		}
		
		var cBuff:int=0;
		var buffTick:int=0;
		var fBuff:int=0;
		var footTick:int=0;
		const BUFF_DISPLAY_DURATION:int=40;
		
		function updateBuffs(){
			
			if (model.buffList.numBuffs()>0){
				if (cBuff>model.buffList.numBuffs()-1){
					cBuff=model.buffList.numBuffs()-1;
				}
				
				if (buffTick<=0){
					var _cBuff:int=cBuff;
					buffTick=BUFF_DISPLAY_DURATION;
					do{
						cBuff+=1;
						if (cBuff>=model.buffList.numBuffs()){
							cBuff=0;
						}
						if (tryDisplayBuff(cBuff)){
							_cBuff=cBuff;
						}
						
					}while(cBuff!=_cBuff);
				}else{
					buffTick-=1;
				}
			}
			
			if (model.buffList.numBuffs()>0){
				if (fBuff>model.buffList.numBuffs()-1){
					fBuff=model.buffList.numBuffs()-1;
				}
				if (footTick<=0){
					var _fBuff:int=fBuff;
					footTick=BUFF_DISPLAY_DURATION;
					if (_fBuff==-1){
						_fBuff=0;
					}
					do{
						fBuff+=1;
						if (fBuff>=model.buffList.numBuffs()){
							fBuff=0;
						}
						if (tryFootBuff(fBuff)){
							_fBuff=fBuff;
							addChildAt(onfoot,0);
						}
					}while(fBuff!=_fBuff);
				}else{
					footTick-=1;
				}
				
			}
			
			if (model.buffList.numBuffs()<=0){
				cBuff=0;
				overhead.gotoAndStop(1);
				
				fBuff=0;
				if (contains(onfoot)) removeChild(onfoot);
				onfoot.gotoAndStop(1);
			}
			
			if (display!=null){
				if (display.overhead!=null){
					overhead.scaleX=display.overhead.scaleX*display.scaleX;
					overhead.scaleY=display.overhead.scaleY*display.scaleY;
					overhead.x=display.x+display.overhead.x*display.scaleX;
					overhead.y=display.y+display.overhead.y;
					overhead.rotation=display.overhead.rotation*display.scaleX;
				}
				if (display.overhead!=null){
					constants.reposition(display.x+display.overhead.x*display.scaleX,display.y+display.overhead.y,display.scaleX);
				}
				//constants.reposition(0,0,1);
				addChild(constants);
			}
			
			
		}
		
		public function buffAdded(i:int){
			if (isDisplayBuff(i)){
				tryDisplayBuff(i);
				cBuff=i;
				buffTick=BUFF_DISPLAY_DURATION;
			}
			if (isFootBuff(i)){
				if (tryFootBuff(i)){
					addChildAt(onfoot,0);
				}
				fBuff=i;
				footTick=BUFF_DISPLAY_DURATION;
			}
			
			buffEffect(model.buffList.getBuff(i).name,true);
			
			if (model.buffList.getBuff(i).name==BuffData.STUNNED){
				action(SpriteView.FREEZE);
			}
		}
		
		public function buffRemoved(i:int,_name:String){
			buffEffect(_name,false);
		}
		
		public function isFootBuff(i:int):Boolean{
			switch (model.buffList.getBuff(i).name){
				case BuffData.BLEEDING:
				case BuffData.REND:
				case BuffData.DELAYED_DAMAGE:
				case BuffData.SILENCED:
				case BuffData.ASLEEP:
				case BuffData.PHOENIX_PROC:
				case BuffData.PHOENIX_THORNS:
				case BuffData.ROOTED:
				case BuffData.IVY:
					return true;
			}
			return false;
		}
		
		public function tryFootBuff(i:int):Boolean{
			switch (model.buffList.getBuff(i).name){
				case BuffData.BLEEDING: case BuffData.REND: case BuffData.DELAYED_DAMAGE: onfoot.gotoAndStop(4); return true;
				case BuffData.SILENCED: onfoot.gotoAndStop(2); return true;
				case BuffData.PHOENIX_PROC: 
				case BuffData.PHOENIX_THORNS: onfoot.gotoAndStop(3); return true;
				case BuffData.ROOTED: case BuffData.IVY: onfoot.gotoAndStop(5); return true;
			}
			return false;
		}
		
		public function isDisplayBuff(i:int):Boolean{
			switch (model.buffList.getBuff(i).name){
				case BuffData.STUNNED:
				case BuffData.ASLEEP:
				case BuffData.CONFUSED:
				case BuffData.DISORIENTED:
				case BuffData.BLIND:
				case BuffData.WEAKENED:
				case BuffData.VULNERABLE:
				case BuffData.WHISPERED:
				case BuffData.CURSED:
				case BuffData.AFRAID:
				case BuffData.ENTRANCED:
				case BuffData.GASSED:
				case BuffData.POISONED:
				case BuffData.BURNED:
				case BuffData.MARKED:
				case BuffData.ECCHO: return true;
			}
			return false;
		}
		
		public function tryDisplayBuff(i:int):Boolean{
			switch (model.buffList.getBuff(i).name){
				case BuffData.STUNNED: overhead.gotoAndStop(2); return true;
				case BuffData.ASLEEP: overhead.gotoAndStop(10); return true;
				case BuffData.CONFUSED: case BuffData.DISORIENTED: overhead.gotoAndStop(3); return true;
				case BuffData.BLIND:
				//case BuffData.WEAKENED: overhead.gotoAndStop(4); return true;
				case BuffData.VULNERABLE: case BuffData.WHISPERED: overhead.gotoAndStop(5); return true;
				case BuffData.CURSED: case BuffData.WEAKENED:
						overhead.gotoAndStop(6); return true;
				case BuffData.AFRAID: case BuffData.ENTRANCED: overhead.gotoAndStop(7); return true;
				case BuffData.GASSED: case BuffData.SPINES:
				case BuffData.POISONED: overhead.gotoAndStop(8); return true;
				case BuffData.BURNED: overhead.gotoAndStop(9); return true;
				case BuffData.MARKED: overhead.gotoAndStop(12); return true;
				case BuffData.ECCHO: overhead.gotoAndStop(11); return true;
				case BuffData.EMPOWERED: case BuffData.HASTENED: case BuffData.ENCHANTED:
				case BuffData.STRENGTHEN: case BuffData.BUFF_POT:
				case BuffData.BERSERK: case BuffData.TAUNT:
				default: overhead.gotoAndStop(1); break;
			}
			return false;
		}

		public function isIdle():Boolean{
			if ((tweenA==IDLE)||(tweenA==WALK)||(tweenA==FREEZE)||(!model.exists)){
				return true;
			}else{
				return false;
			}
		}

		public function newPlayer(_updateUI:Boolean){
			name=MouseControl.PLAYER;
			//y=GameUI.FLOOR_Y;
			
			_Filters=new Array;
			constants.removeAll();
			overhead.gotoAndStop(1);
			onfoot.gotoAndStop(1);
			if (contains(onfoot)) removeChild(onfoot);
			
			weaponFilter=helmetFilter=null;
			
			displayBars(!_updateUI);
			
			if (display!=null){
				display.stop();
				removeChild(display);
			}
			display=new PlayerUnarmed;
			display.head.faceFromTalent(0);
			//display.head.hatInside.fromItem(0);
			display.hat.fromItem(0);
			display.hatback.fromItem(0);
			addChildAt(display,0);
			if (simpleMode) display.visible=false;
			if (inverted){
				display.scaleX=-1;
			}
			action(IDLE);			
		}
		
		public function newFromCode(_code:int,_boss:Boolean=false){
			var _type:String;
			if (_boss){
				switch(_code){
					case 0: _type=EnemyData.CHIEF; break;
					case 1: _type=EnemyData.BOAR; break;
					case 2: _type=EnemyData.BEEZELPUFF; break;
				}
			}else{
				switch(_code){
					case 00: _type=EnemyData.FIGHTER; break;
					case 01: _type=EnemyData.BRUTE; break;
					case 02: _type=EnemyData.SHAMAN; break;
					case 03: _type=EnemyData.ALCHEMIST; break;
					case 04: _type=EnemyData.VINE; break;
					case 05: _type=EnemyData.BLOB; break;
					case 11: _type=EnemyData.RHINO; break;
					case 12: _type=EnemyData.CATMAN; break;
					case 14: _type=EnemyData.GOATMAN; break;
					case 10: _type=EnemyData.BIRDMAN; break;
					case 13: _type=EnemyData.GUARDIAN; break;
					case 20: _type=EnemyData.IMP; break;
					case 21: _type=EnemyData.HELLING; break;
					case 22: _type=EnemyData.GOLEM; break;
					case 23: _type=EnemyData.FLAMBERT; break;
					case 24: _type=EnemyData.SKELETON; break;
				}
			}
			newMonster(_type);
		}
		
		public function newMonster(_type:String){
			name=MouseControl.ENEMY;
			//y=GameUI.FLOOR_Y;
			displayBars();
			
			_Filters=new Array;
			constants.removeAll();
			
			_Enchanted=false;
			weaponFilter=helmetFilter=null;
			
			if (display!=null){
				display.stop();
				if (contains(display)){
					removeChild(display);
				}
			}
			switch(_type){
				case EnemyData.CHIEF:
					display=new PlayerShield;
					display.w1.gotoAndStop(4);
					display.scaleX=1.8;
					display.scaleY=1.8;
					display.hand1.gotoAndStop(2);
					display.hand2.gotoAndStop(2);
					break;
				case EnemyData.FIGHTER:
					display=new PlayerShield;
					display.hand1.gotoAndStop(2);
					display.hand2.gotoAndStop(2);
					break;
				case EnemyData.BRUTE:
					display=new PlayerBrute;
					display.hand1.gotoAndStop(2);
					display.hand2.gotoAndStop(2);
					display.w1.gotoAndStop(4);
					display.w2.gotoAndStop(5);
					break;
				case EnemyData.SHAMAN:
					display=new PlayerLarge;
					display.w1.gotoAndStop(4);
					display.hand1.gotoAndStop(2);
					display.hand2.gotoAndStop(2);
					break;
				case EnemyData.ALCHEMIST:
					display=new PlayerShield;
					display.hand1.gotoAndStop(2);
					display.hand2.gotoAndStop(2);
					display.w1.gotoAndStop(5);
					display.w2.gotoAndStop(2);
					break;
				case EnemyData.VINE:
					display=new MonsterVine;
					break;
				case EnemyData.BLOB:
					display=new MonsterBlob;
					break;
				case EnemyData.BEEZELPUFF:
					display=new MonsterBeezl;
					break;
				case EnemyData.SKELETON:
					display=new PlayerShield;
					display.hand1.gotoAndStop(3);
					display.hand2.gotoAndStop(3);
					break;
				case EnemyData.IMP:
					display=new MonsterImp;
					break;
				case EnemyData.BIRDMAN:
					display=new MonsterBird;
					break;
				case EnemyData.HELLING:
					display=new MonsterHell;
					break;
				case EnemyData.RHINO:
					display=new MonsterRam;
					for (var i:int=0;i<display.numChildren;i+=1){
						(display.getChildAt(i) as MovieClip).gotoAndStop(2);
					}
					break;
				case EnemyData.BOAR:
					display=new MonsterGiantRam;
					for (i=0;i<display.numChildren;i+=1){
						(display.getChildAt(i) as MovieClip).gotoAndStop(3);
					}
					break;
				case EnemyData.GOLEM:
					display=new PlayerBrute;
					display.hand1.gotoAndStop(4);
					display.hand2.gotoAndStop(4);
					display.w1.gotoAndStop(3);
					display.w2.gotoAndStop(3);
					break;
				case EnemyData.FLAMBERT:
					display=new MonsterFlambert;
					break;
				case EnemyData.GUARDIAN:
					display=new MonsterGuardian;
					break;
				case EnemyData.GOATMAN:
					display=new PlayerLarge;
					display.hand1.gotoAndStop(5);
					display.hand2.gotoAndStop(5);
					display.w1.gotoAndStop(5);
					break;
				case EnemyData.CATMAN:
					display=new PlayerDual;
					display.hand1.gotoAndStop(5);
					display.hand2.gotoAndStop(5);
					display.w1.gotoAndStop(1);
					display.w2.gotoAndStop(1);
					break;
				default: return;
			}
			display.overhead.gotoAndStop(1);
			try{
				display.head.faceFromEnemy(_type);
				//display.head.hatInside.fromItem(0);
				display.hat.fromEnemy(_type);
				display.hatback.fromEnemy(_type);
			}catch(e:Error){};
			
			addChildAt(display,0);
			action(WALK);

			if (!inverted){
				display.scaleX=Math.abs(display.scaleX)*-1;
			}
			inverted=true;
			if (simpleMode) display.visible=false;
		}
		
		public function set inverted(b:Boolean){
			if (b){
				if (display!=null){
					display.scaleX=Math.abs(display.scaleX)*-1;
				}
				_Inverted=-1;
			}else{
				if (display!=null){
					display.scaleX=Math.abs(display.scaleX);
				}
				_Inverted=1;
			}
		}
		
		public function get inverted():Boolean{
			if (_Inverted==1){
				return false;
			}else{
				return true;
			}
		}
		
		public function displayBars(b:Boolean=true){
			if (b){
				if (healthBar==null){
					healthBar=new DisplayBar("Health",0xff0000,34);
					manaBar=new DisplayBar("Mana",0x0000ff,34);
					healthBar.height=manaBar.height=4;
					healthBar.x=manaBar.x=-10;
				}
				healthBar.y=0;
				manaBar.y=4;

				addChild(healthBar);
				addChild(manaBar);
			}else{
				try{
					removeChild(healthBar);
					removeChild(manaBar);
					healthBar=manaBar=null;
				}catch(e:Error){}
			}
		}
		
		public function updateWeapon(_weapon:ItemModel=null){
			weaponFilter=null;
			var i:int=display.currentFrame;
			var _y:Number=display.y;
			if (display!=null){
				display.stop();
				removeChild(display);
			}
			
			if (_weapon==null){
				display=new PlayerUnarmed;
				display.w1.gotoAndStop(3);
				display.w2.gotoAndStop(3);
			}else{
				if (_weapon.isPremium()){
					weaponFilter=FilterData.getPremiumFilter(_weapon.index,_weapon.enchantIndex);
				}else{
					if (_weapon.enchantIndex>=15) weaponFilter=shadowItemFilter;
				}
				switch (_weapon.index){
					case 0: case 1: case 2: case 78: case 79: case 73: case 83: case 84: case 85: case 86: case 87:
					case 107: case 114: case 120:
						display=new PlayerLarge; break;
					case 3: case 5: case 72: case 81:
					case 108: case 109: case 111: case 116: case 132:
						display=new PlayerDual; break;
					case 4: case 74: case 76: case 77:
					case 106:
						display=new PlayerUnarmed; break;
					case 6: case 7: case 8: case 75: case 82: 
					case 145: case 146:
						display=new PlayerShield; break;
					case 80: case 105:
						display=new PlayerSingle; break;
					case 126: case 127: case 128: case 129:
						display=new PlayerRanged; break;
				}
				switch (_weapon.index){
					case 0: display.w1.gotoAndStop(1); break;
					case 1: display.w1.gotoAndStop(2); break;
					case 2: display.w1.gotoAndStop(3); break;
					case 3: display.w1.gotoAndStop(5); display.w2.gotoAndStop(1); break;
					case 4: display.w1.gotoAndStop(2); display.w2.gotoAndStop(1); break;
					case 5: display.w1.gotoAndStop(6); display.w2.gotoAndStop(2); break;
					case 6: display.w1.gotoAndStop(1); display.w2.gotoAndStop(1); break;
					case 7: display.w1.gotoAndStop(2); display.w2.gotoAndStop(1); break;
					case 8: display.w1.gotoAndStop(3); display.w2.gotoAndStop(1); break;
					case 72: display.w1.gotoAndStop(7); display.w2.gotoAndStop(3); break;
					case 73: display.w1.gotoAndStop(6); break;
					case 74: display.w1.gotoAndStop(8); display.w2.gotoAndStop(9); break;
					case 75: display.w1.gotoAndStop(6); display.w2.gotoAndStop(6); break;
					case 76: display.w1.gotoAndStop(6); display.w2.gotoAndStop(7); break;
					case 77: display.w1.gotoAndStop(10); display.w2.gotoAndStop(11); break;
					case 78: display.w1.gotoAndStop(7); break;
					case 79: display.w1.gotoAndStop(8); break;
					case 80: display.w1.gotoAndStop(8); break;
					case 81: display.w1.gotoAndStop(8); display.w2.gotoAndStop(4); break;
					case 82: display.w1.gotoAndStop(7); display.w2.gotoAndStop(7); break;
					case 83: display.w1.gotoAndStop(13); break;
					case 84: display.w1.gotoAndStop(12); break;
					case 85: display.w1.gotoAndStop(9); break;
					case 86: display.w1.gotoAndStop(10); break;
					case 87: display.w1.gotoAndStop(11); break;
					case 105: display.w1.gotoAndStop(9); break; //RIOT
					case 106: display.w1.gotoAndStop(12); display.w2.gotoAndStop(13); break; //HELLHANDS
					case 107: display.w1.gotoAndStop(14); break; //CHAINSAW
					case 108: display.w1.gotoAndStop(11); display.w2.gotoAndStop(10); break;//SPELLBOOK
					case 109: display.w1.gotoAndStop(12); display.w2.gotoAndStop(10); break;//BOW
					case 114: display.w1.gotoAndStop(15); break;
					case 116: display.w1.gotoAndStop(13); display.w2.gotoAndStop(13); break;
					case 111: display.w1.gotoAndStop(14); display.w2.gotoAndStop(14); break; //DARK SABER
					case 120: display.w1.gotoAndStop(16); break; //PENCIL
					case 126: display.w1.gotoAndStop(1); break; //Bow
					case 127: display.w1.gotoAndStop(2); break; //SHOTGUN TEST
					case 128: display.w1.gotoAndStop(3); break; //RIFLE TEST
					case 129: display.w1.gotoAndStop(4); break; //SPARROW BOW
					case 132: display.w1.gotoAndStop(15); display.w2.gotoAndStop(15); break; //SAIS
					case 145: display.w1.gotoAndStop(10); display.w2.gotoAndStop(9); break; //DRAGON
					case 146: display.w1.gotoAndStop(11); display.w2.gotoAndStop(10); break; //RAIDER
					default: display.w1.gotoAndStop(0); break;
				}
			}
			
			addChildAt(display,0);
			if (inverted){
				display.scaleX=-1;
			}
			display.gotoAndPlay(i);
			display.y=_y;
			
			setWeaponFilters(display.w1);
			if (display.w2!=null){
				setWeaponFilters(display.w2);
			}
			if (model!=null) {
				updateHelmet(model.equipment[1]);
				updateCosmetics(model.cosmetics,model.skillBlock.getTalentIndex());
			}
			
			if (simpleMode) display.visible=false;
		}
		
		public function updateRelic(_index:int,_enchant:int=-1){
			if (_index>=137 && _index<=144){
				model.cosmetics[8]=_index-136;
				model.cosmetics[9]=_enchant;
			}else{
				model.cosmetics[8]=-1;
				model.cosmetics[9]=-1;
			}
			/*switch(_index){
				case -1: model.cosmetics[8]=-1; break;
				case 137: model.cosmetics[8=1
				default:
					model.cosmetics[8]=1;
					break;
			}*/
			if (model!=null){
				updateCosmetics(model.cosmetics,model.skillBlock.getTalentIndex());
			}
		}
		
		public function updateHelmet(_helmet:ItemModel=null){
			display.head.clearHelmet();
			
			if (model!=null && (model.skillBlock.checkTalent(SkillData.BRAVE) || model.skillBlock.checkTalent(SkillData.IRON) || model.skillBlock.checkTalent(SkillData.SAVIOR))){
				display.hat.fromTalent(model.skillBlock.getTalentIndex());
				display.hatback.fromTalent(model.skillBlock.getTalentIndex());
			}else if (_helmet==null){
				helmetFilter=null;
				display.hat.fromItem(0);
				display.hatback.fromItem(0);
			}else{
				if (_helmet.isPremium()){
					helmetFilter=FilterData.getPremiumFilter(_helmet.index,_helmet.enchantIndex);
				}else{
					if (_helmet.enchantIndex>-1 && _helmet.enchantIndex<15) helmetFilter=shadowItemFilter;
				}
				switch(_helmet.index){
					case 122:
						display.head.addHelmetFromItem(_helmet.index,setHelmetFilters,1);
					case 9: case 71: case 90: case 91:
					case 102: case 103: case 104: case 117:
					case 123: case 124: case 133:
						display.hat.fromItem(0);
						display.hatback.fromItem(0);
						display.head.addHelmetFromItem(_helmet.index,setHelmetFilters,0);
						break;
					default:
						display.hat.fromItem(_helmet.index);
						display.hatback.fromItem(_helmet.index);
						break;
				}
			}
			setHelmetFilters(display.hat);
			setHelmetFilters(display.hatback);
		}
		
		public function updateAura(_aura:int=-1){
			if (_aura==1){
				display.head.aura.gotoAndStop(2);
				display.hand1.aura.gotoAndStop(2);
				display.hand2.aura.gotoAndStop(2);
			}else{
				display.head.aura.gotoAndStop(1);
				display.hand1.aura.gotoAndStop(1);
				display.hand2.aura.gotoAndStop(1);
			}
		}
		
		public function getBitmap():Bitmap{
			var m:BitmapData=new BitmapData(display.width*Math.abs(display.scaleX),display.height*Math.abs(display.scaleY),true,0);
			var rect:Rectangle=display.getRect(this);
			if (display.scaleX<0){
				rect.x=-rect.width-rect.x;
			}
			m.draw(display,new Matrix(Math.abs(display.scaleX),0,0,Math.abs(display.scaleY),-rect.x+display.x,-rect.y+display.y));
			var b:Bitmap=new Bitmap(m);
			b.y=rect.y+y;
			
			if (display.scaleX<0){
				b.scaleX=-1;
				b.x=x-rect.x;
			}else{
				b.x=rect.x+x;
			}
			return b;
		}
		
		public function sepia():BitmapData{
			var m:BitmapData=new BitmapData(display.width,display.height,true,0);
			display.gotoAndStop(0);
			var rect:Rectangle=display.getRect(this);
			if (display.scaleX==-1){
				rect.x=-rect.width-rect.x;
			}
			m.draw(display,new Matrix(1,0,0,1,-rect.x+display.x,-rect.y+display.y));
			m.applyFilter(m,m.rect,new Point(0,0),new ColorMatrixFilter([0.4,0.4,0.4,0,0,0.35,0.35,0.35,0,0,0.2,0.2,0.2,0,0,0,0,0,1,0]));
			return m;
		}
		
		public function buffEffect(s:String,b:Boolean){
			switch(s){
				case BuffData.ENCHANTED:
					_Enchanted=b;
					if (display.w1!=null){
						setWeaponFilters(display.w1);
					}
					if (display.w2!=null){
						setWeaponFilters(display.w2);
					}
					break;
				case BuffData.ENCHANTED2:
					_Enchanted=b;
					if (display.w1!=null){
						setWeaponFilters(display.w1,0xffff00);
					}
					if (display.w2!=null){
						setWeaponFilters(display.w2,0xffff00);
					}
					break;
				case BuffData.ENCHANTED3:
					_Enchanted=b;
					if (display.w1!=null){
						setWeaponFilters(display.w1,0xcccccc);
					}
					if (display.w2!=null){
						setWeaponFilters(display.w2,0xcccccc);
					}
					break;
				case BuffData.ENCHANTED4:
					_Enchanted=b;
					if (display.w1!=null){
						setWeaponFilters(display.w1,0x550088);
					}
					if (display.w2!=null){
						setWeaponFilters(display.w2,0x550088);
					}
					break;
				case BuffData.HASTENED:
					if (b){
						constants.addEffect(ConstantEffect.HASTE);
					}else{
						constants.removeEffect(ConstantEffect.HASTE);
					}
					break;
				case BuffData.BUFF_POT:
					if (b){
						constants.addEffect(ConstantEffect.POWER);
					}else{
						constants.removeEffect(ConstantEffect.POWER);
					}
					break;
				case BuffData.TURTLE_POT:
					if (b){
						constants.addEffect(ConstantEffect.TURTLE);
					}else{
						constants.removeEffect(ConstantEffect.TURTLE);
					}
					break;
				case BuffData.CELERITY_POT:
					if (b){
						constants.addEffect(ConstantEffect.CELERITY);
					}else{
						constants.removeEffect(ConstantEffect.CELERITY);
					}
					break;
				case BuffData.PURITY_POT:
					if (b){
						constants.addEffect(ConstantEffect.PURITY);
					}else{
						constants.removeEffect(ConstantEffect.PURITY);
					}
					break;
				case BuffData.BERSERK:  case BuffData.TAUNT: case BuffData.STRENGTHEN:
					if (b){
						_Filters.push(berzerkFilter);
						display.filters=_Filters;
					}else{
						_Filters.splice(_Filters.indexOf(berzerkFilter),1);
						display.filters=_Filters;
					}
					break;
				case BuffData.EMPOWERED:
					if (b){
						_Filters.push(empoweredFilter);
						display.filters=_Filters;
					}else{
						_Filters.splice(_Filters.indexOf(empoweredFilter),1);
						display.filters=_Filters;
					}
					break;
				case BuffData.EMPOWERED2:
					if (b){
						_Filters.push(empoweredFilter2);
						display.filters=_Filters;
					}else{
						_Filters.splice(_Filters.indexOf(empoweredFilter2),1);
						display.filters=_Filters;
					}
					break;
				case BuffData.EMPOWERED3:
					if (b){
						_Filters.push(empoweredFilter3);
						display.filters=_Filters;
					}else{
						_Filters.splice(_Filters.indexOf(empoweredFilter3),1);
						display.filters=_Filters;
					}
					break;
				case BuffData.PROTECTION:
					if (b){
						constants.addEffect(ConstantEffect.HEALING);
					}else{
						constants.removeEffect(ConstantEffect.HEALING);
					}
					break;
				case BuffData.SAYAN:
					if (b){
						display.head.helmetSub(1);
					}
					break;
				case BuffData.SUPER_SAYAN:
				case BuffData.SUPER_SAYAN2:
				case BuffData.SUPER_SAYAN3:
					if (b){
						display.head.helmetSub(2);
					}else{
						display.head.helmetSub(1);
					}
					break;
				case BuffData.STEALTH:
					if (b){
						display.alpha=0.5;
					}else{
						display.alpha=1;
					}
					break;
			}
		}
		
		function setWeaponFilters(_v:MovieClip,_glowColor:uint=0x00ffff){
			if (_v.sub!=null){
				var _array:Array=new Array();
				if (weaponFilter!=null){
					_array.push(weaponFilter);
				}
				if (_Enchanted){
					var _glow:GlowFilter=new GlowFilter(_glowColor,1,10,10,2,1);
					_array.push(_glow);
				}
				_v.sub.filters=_array;
			}
		}
		
		function setHelmetFilters(_v:MovieClip){
			if (_v.sub!=null){
				var _array:Array=new Array();
				if (helmetFilter!=null){
					_array.push(helmetFilter);
				}
				_v.sub.filters=_array;
			}
		}
		
		/*function weaponFilters(_v:MovieClip,_glowColor:uint=0x00ffff){
			if (_v.sub!=null){
				var _array:Array=new Array();
				if (_Enchanted){
					var _glow:GlowFilter=new GlowFilter(_glowColor,1,10,10,2,1);
					_array.push(_glow);
				}
				if (weaponMagic>-1){
					var _filter:ColorMatrixFilter;
					switch(weaponMagic){
						case 0: _filter=eFilter(0.3,0.3,0.3);break;
						case 1: _filter=eFilter(0,0.1,0.3);break;
						case 2: _filter=eFilter(0.1,0,0.3);break;
						case 3: _filter=eFilter(0,0.1,0);break;
						case 4: _filter=eFilter(0.2,0.2,0);break;
						case 5: _filter=eFilter(-0.05,-0.05,-0);break;
						case 6: _filter=eFilter(0.1,0.1,0.3);break;
						case 7: _filter=eFilter(0.3,0,0.05);break;
						case 8: _filter=eFilter(0.6,0.6,0.4);break;
						case 9: _filter=eFilter(0,-0.1,0);break;
						case 10: _filter=eFilter(0.5,0.1,0);break;
						case 11: _filter=eFilter(-0.1,-0.1,0);break;
						case 12: _filter=eFilter(0,-0.1,-0.1);break;
						case 13: _filter=eFilter(0.4,0.4,0);break;
						case 14: _filter=eFilter(0,0.2,0.4);break;
						default: _filter=eFilter(-0.1,-0.05,-0.05);break;
					}
					_array.push(_filter);
				}
				
				_v.sub.filters=_array;
			}
		}
												  
		function helmetFilters(_v:MovieClip,_item:ItemModel){
			if (_v.sub!=null){
				var _array:Array=new Array();
				if (helmetMagic>-1){
					var _filter:ColorMatrixFilter;
					switch(helmetMagic){
						case 15: _filter=eFilter(0.2,0.2,0.2);break;
						case 16: _filter=eFilter(0,0,0.6);break;
						case 17: _filter=eFilter(0,0.4,0);break;
						case 18: _filter=eFilter(0,0,0.6);break;
						case 19: _filter=eFilter(0.2,0.2,0);break;
						case 20: _filter=eFilter(0,0.2,0.4);break;
						case 21: _filter=eFilter(0.4,0.2,0);break;
						case 22: _filter=eFilter(0.4,0.4,0.4);break;
						case 23: _filter=eFilter(0.2,0,0.2);break;
						case 24: _filter=eFilter(0.1,0.3,0.1);break;
						case 25: _filter=eFilter(-0.1,-0.1,-0.1);break;
						case 26: _filter=eFilter(0.1,0.1,0);break;
						case 27: _filter=eFilter(0,0,0);break;
						case 28: _filter=eFilter(0.6,0,0);break;
						case 29: _filter=eFilter(-0.1,-0.2,-0.2);break;
						default: _filter=eFilter(-0.1,-0.05,-0.05);break;
					}
					_array.push(_filter);
					_v.sub.filters=_array;
				}
			}
		}*/
		
		function eFilter(_a:Number,_b:Number,_c:Number):ColorMatrixFilter{
			return new ColorMatrixFilter([0.5+_a,_a,_a,0,0,
										  _b,0.5+_b,_b,0,0,
										  _c,_c,0.5+_c,0,0,
										  0,0,0,1,0]);
			/*return new ColorMatrixFilter([1+_a,_a,_a,0,0,
										  _b,1+_b,_b,0,0,
										  _c,_c,1+_c,0,0,
										  0,0,0,1,0]);*/
		}
		
		public function recolor(a:Array,_shadow:Boolean=false){
			if (display==null) return;
			if (_shadow){
				_Filters=[shadowFilter];
				//_Filters.push(new GlowFilter(0xffffff,1,10,10,2,1));
			}else{
				_Filters=[new ColorMatrixFilter(a)];
				/*try{
					display.head.extra.filters=[new ColorMatrixFilter(invertFilter(a))];
				}catch(e:Error){}*/
			}
			display.filters=_Filters;
		}
		
		function invertFilter(a:Array){
			var m:Array=new Array();
			for (var i:int=0;i<20;i+=1){
				/*switch(i){
					case 0: case 6: case 12:
						m.push(2-a[i]);
						break;
					case 18:
						m.push(a[i]);
						break;
					default:
						m.push(0-a[i]);
				}*/
				m.push(0);
			}
			return m;
		}
		
		public function setPlayerDisplay(m:SpriteModel){
			name="";
			
			_Filters=new Array;
			constants.removeAll();
			
			weaponFilter=helmetFilter=null;
			
			displayBars(false);
			
			if (display!=null){
				display.stop();
				removeChild(display);
			}
			display=new PlayerUnarmed;
			addChildAt(display,0);
			updateWeapon(m.equipment[0]);
			updateHelmet(m.equipment[1]);
			updateCosmetics(m.cosmetics,m.skillBlock.getTalentIndex());
			
			action(IDLE);			
		}
		
		public function updateCosmetics(_cosmetics:Array,_talent:int){
			display.head.updateCosmetics(_cosmetics,_talent);
			if (_cosmetics[0]>0){
				display.hand1.gotoAndStop(_cosmetics[0]);
				display.hand2.gotoAndStop(_cosmetics[0]);
			}else{
				display.hand1.gotoAndStop(1);
				display.hand2.gotoAndStop(1);
			}
			if (_cosmetics[6]>0){
				display.foot1.gotoAndStop(_cosmetics[6]);
				display.foot2.gotoAndStop(_cosmetics[6]);
				if (display.foot1.sub!=null) display.foot1.sub.gotoAndStop(_cosmetics[0]);
				if (display.foot2.sub!=null) display.foot2.sub.gotoAndStop(_cosmetics[0]);
			}else{
				display.foot1.gotoAndStop(1);
				display.foot2.gotoAndStop(1);
			}
			updateAura(_cosmetics[5]);
		}
		
		public function makeSepia(_scale:Number=1){
			if (display==null) return;
			recolor([0.4,0.4,0.4,0,0,0.35,0.35,0.35,0,0,0.2,0.2,0.2,0,0,0,0,0,1,0]);
			display.stop();
			if (contains(healthBar)){
				removeChild(healthBar);
				removeChild(manaBar);
			}
			display.scaleX*=_scale;
			display.scaleY*=_scale;
			//scaleX=scaleY=_scale;
			alpha=.5;
		}
		
		public function setSimpleMode(b:Boolean){
			simpleMode=b;
			if (display!=null) display.visible=!b;
			overhead.visible=!b;
			onfoot.visible=!b;
			constants.visible=!b;
			if (b){
				graphics.clear();
				graphics.lineStyle(2);
				graphics.beginFill(0x0000ff);
				graphics.drawEllipse(-34,-70,68,68);
			}else{
				graphics.clear();
			}
		}
		
		public function weaponVisible (b:Boolean){
			if (display!=null && display.w1!=null && display.w1.sub!=null) display.w1.sub.visible=b;
		}
	}
}