package {
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.events.Event;
	import utils.GameData;
	import system.buffs.BuffData;
	import system.buffs.BuffBase;
	
	public class SoundControl{
		public static const ACHIEVE:int=11,
							BUTTON:int=12,
							BUTTON_OVER:int=13,
							LEVEL:int=14,
							GOLD:int=15;
							
		public static var FADE_TICK:Number=0.05;
							
		public var _Mute:Boolean=false;
		
		var music:Array;
		var effects:Array;
						   
		var musicC:SoundChannel;
		var effectC:Vector.<SoundChannel>=new Vector.<SoundChannel>(3);
		var playing:int=-1;
		var toPlay:int=-1;
		var fade:Number=-1;
		var fadeTick:Number=0;
		
		public var hit:int;
		
		var _MusicVolume:Number=.8;
		public var soundVolume:Number=0.2;
		
		public function init(){
			Facade.stage.addEventListener(Event.ENTER_FRAME,update);
			musicVolume=GameData._Save.data.sound[0];
			soundVolume=GameData._Save.data.sound[1];
		}
		
		public function loadArrays(_music:Array,_effects:Array){
			music=_music;
			effects=_effects;
		}
		
		public function buffUpdate(_buff:BuffBase){
			if (mute) return;

			if (_buff.name==BuffData.POISONED) playEffect(8);
			else if (_buff.name==BuffData.BURNED) playEffect(5);
			else if (_buff.name==BuffData.CONFUSED) playEffect(9);
		}
		
		public function testAction(_action:String,_v:SpriteView){
			if (mute) return;
			
			switch(_action){
				case SpriteView.ATTACK: playEffect(6,0); hit=3; break;
				case SpriteView.CAST: playEffect(10,0); hit=5; break;
				case SpriteView.HURT: playEffect(hit,0); break;
				case SpriteView.BLOCK: playEffect(7,0); break;
			}
		}
		
		public function actionHit(_action:String){
			if (mute) return;
			
			//playEffect(4);
		}
		
		public function actionDefended(_defense:String){
			/*if (mute) return;
			
			switch (_action.defended){
				case SpriteView.DODGE: playEffect(2); break;
				case SpriteView.BLOCK: playEffect(7); break;
				case SpriteView.TURN: break;
				default: throw(new Error("Invalid defense type: "+_action.defended));
			}*/
		}
		
		public function testEffect(_effect:String){
			hit=5;
		}
		
		
		//===GENERIC SOUND STUFF===
		public function playEffect(i:int,_channel:int=-1,_offset:Number=0){
			if (i<0) return;
			if (mute) return;
			if (i>=ACHIEVE) return;
			if (effects[i]==null) return;
			
			if (_channel>=0){
				if (effectC[_channel]!=null) effectC[_channel].stop();
				effectC[_channel]=(new effects[i]).play(_offset);
				effectC[_channel].soundTransform=new SoundTransform(soundVolume);
			}else{
				var _effectC:SoundChannel=(new effects[i]).play(_offset);
				_effectC.soundTransform=new SoundTransform(soundVolume);
			}
		}
		
		function playSound(_sound:Sound){
			if (mute) return;
			var _effectC:SoundChannel=_sound.play();
			_effectC.soundTransform=new SoundTransform(soundVolume);
		}
		
		//====MUSIC====\\
		
		public function update(e:Event){
			if (fadeTick!=0 && musicC!=null){
				fade+=fadeTick;
				if (fade<=0){
					fade=0;
					fadeTick=0;
					stopMusic();
					if (toPlay>=0){
						startMusic(toPlay);
						toPlay=-1;
					}
				}else if (fade>=1){
					fade=1;
					fadeTick=0;
					musicC.soundTransform=new SoundTransform(musicVolume);
				}else{
					musicC.soundTransform=new SoundTransform(fade*musicVolume);
				}
			}
		}
		
		public function startMusic(i:int){
			if (musicC==null){
				playing=i;
				if (mute) return;
				
				musicC=(new music[i]).play();
				musicC.soundTransform=new SoundTransform(0);
				musicC.addEventListener(Event.SOUND_COMPLETE,repeat,false,0,true);
				
				fade=fadeTick=FADE_TICK;
			}else{
				if (mute) return;
				//if (playing==i || (playing==0 && i==1) || (playing==1 && i==0)) return;
				//toPlay=i;
				
				if (fadeTick==0){
					//music running full
					if (playing==i || (playing==0 && i==1) || (playing==1 && i==0)) return;
					toPlay=i;
					fadeTick=0-FADE_TICK;
				}else if (fadeTick<0){
					//fading out
					if (playing==i || (playing==0 && i==1) || (playing==1 && i==0)){
						fadeTick=FADE_TICK;
					}else{
						toPlay=i;
					}
				}else if (fadeTick>0){
					//fading in
					if (playing==i || (playing==0 && i==1) || (playing==1 && i==0)) return;
					fadeTick=0-FADE_TICK;
					toPlay=i;
				}
			}
		}
		
		public function fadeOut(){
			if (musicC==null){
				return;
			}else{
				if (fadeTick==0){
					//full blast
					toPlay=-1;
					fadeTick=0-FADE_TICK;
				}else if (fadeTick>0){
					toPlay=-1;
					fadeTick=0-FADE_TICK;
				}else if (fadeTick<0){
					if (toPlay>=0){
						playing=toPlay;
						toPlay=-1;
					}else{
						toPlay=-1;
					}
				}
			}
		}
		
		public function repeat(e:Event){
			if (playing==0){
				playing=1;
			}
			musicC=(new music[playing]).play();
			musicC.soundTransform=new SoundTransform(musicVolume);
			musicC.addEventListener(Event.SOUND_COMPLETE,repeat,false,0,true);
		}
		
		public function stopMusic(){
			if (musicC!=null){
				musicC.stop();
				musicC=null;
				fade=0;
				fadeTick=0;
			}
		}
		
		//=================MUTE/VOLUME===============
		
		public function set mute(b:Boolean){
			_Mute=b;
			if (mute){
				fadeOut();
			}else if (playing>=0){
				startMusic(playing);
			}
		}
		
		public function get mute():Boolean{
			if (effects==null) return true;
			
			return _Mute;
		}
		
		public function set musicVolume(n:Number){
			_MusicVolume=n;
			if (musicC!=null){
				musicC.soundTransform=new SoundTransform(musicVolume);
			}
		}
		
		public function get musicVolume():Number{
			return _MusicVolume;
		}
	}
}