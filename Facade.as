package{
	import flash.display.Stage;
	import flash.text.TextFormat;
	import ui.*;
	import ui.main.MenuUI;
	import ui.main.HallUI;
	import flash.display.StageQuality;
	import flash.text.TextField;
	import ui.assets.AchievementDisplay;
	import ui.assets.InstantTransition;
	import ui.assets.FadeTransition;
	import ui.main.BaseUI;
	import flash.display.Sprite;
	import utils.GameData;
	import ui.assets.Tooltip;
	import utils.SpriteSheets;
	import gameEvents.*;
	import flash.events.FocusEvent;
	import flash.events.Event;
	import ui.main.HomeUI;
	import ui.windows.ConfirmWindow;
	
	public class Facade{
		public static const YELLOW:uint=0xFFF43F,
							DARK_RED:uint=0x9F400D,
							RED:uint=0xFF6F23,
							BLACK:uint=0x210D02,
							SEPIA:uint=0x0000AA,
							
							WIDTH:int=640,
							HEIGHT:int=420,
							SCALE:int=1,
							FRAMERATE:int=24;

		public static var stage:Stage,
						gameM:GameModel=new GameModel(),
						menuUI:MenuUI=new MenuUI(),
						gameC:GameControl,
						gameUI:GameUI,
						effectC:EffectControl=new EffectControl(),
						mouseC:MouseControl=new MouseControl(),
						soundC:SoundControl=new SoundControl(),
						saveC:SaveControl=new SaveControl();
						
		public static const DEBUG:Boolean=true;
		
		public static var currentUI:*;
		static var popV:Tooltip=new Tooltip;
				
		public static function initialize(_s:Stage){
			stage=_s;
			stage.frameRate=FRAMERATE;

			GameData.init();
			SpriteSheets.init();
		}

		public static function postAuthenticate(){
			gameUI=new GameUI();
			
			gameM.init();
			
			gameUI.init();
			menuUI.init();
			
			mouseC.init();
			soundC.init();
			
			GameEventManager.init();
			
			addOverlay();
			stage.addEventListener(Event.DEACTIVATE,unfocus);
			stage.addEventListener(Event.ACTIVATE,refocus);
		}
		
		public static function postRender(_muted:Boolean=false){
			postAuthenticate();
			if (_muted){
				soundC.mute=true;
			}else{
				soundC.mute=false;
				soundC.startMusic(0);
			}
		}
		
		public static function startGame(v:*){
			if (DEBUG) {
				GameData.setFlag(GameData.FLAG_TUTORIAL, true);
			}
			//***in order to go straight to the exhibition, comment the following line and uncomment the next one***
			new FadeTransition(v,new HomeUI);
			//new InstantTransition(null,menuUI.homeUI);			
			//transition.finishTransition(menuUI.exhibitionUI,true);
			//transition.finishTransition(menuUI.libraryUI,false);
		}
		
		public static function diminish(a:Number,_level:int):Number{
			return 1-Math.pow(1-a,_level);
		}
		
		public static function linearItem(_level:int):Number{
			if (_level>20) _level=20;
			if (_level<0) _level=0;
			return _level/20;
		}
		
		public static function toggleQuality(){
			switch(stage.quality){
				case "LOW": stage.quality="MEDIUM"; break;
				case "MEDIUM": stage.quality="BEST"; break;
				default: stage.quality="LOW"; break;
			}
		}
		
		public static function setQuality(i:int,_save:Boolean=true){
			if (_save) GameData._Save.data.quality=i;
			switch(i){
				case 0: stage.quality="LOW"; break;
				case 1: stage.quality="MEDIUM"; break;
				case 2: stage.quality="BEST"; break;
			}
		}
		
		static var overlay:TextField;
		public static function addOverlay(){
			overlay=new TextField();
			overlay.y=-50;
			stage.addChild(overlay);
		}
		
		static var time:Number;		
		public static function traceMoment(){
			var _time2:Number=(new Date).time;
			//if (gameUI!=null) overlay.text=String(_time2-time);
			var _toAdd:Number=(_time2-time)/1000;
			if (!isNaN(time)){
				GameData.addScore(GameData.SCORE_TIME,_toAdd);
			}
			time=_time2;
		}
		
		public static function popOver(_label:String=null,_description:String=null,_o:*=null,instant:Boolean=false,_type:int=0,_level:int=-1){
			popV.update(_label,_description,_o,instant,_type,_level);
		}
		
		public static var traceCW:ConfirmWindow;
		public static function addLine(s:String){
			if (DEBUG) {
				if (traceCW) {
					traceCW.display.appendText("\n" + s);
				} else {
					traceCW = new ConfirmWindow(s, 50, 50, removeTraceWindow);
				}
			}
			//if (DEBUG && stage!=null) trace(s);
			//trace(s);
		}

		public static function removeTraceWindow(i: int) {
			traceCW = null;
		}
		
		public static function unfocus(e:Event){
			if (GameData._Save.data.pause[GameData.FOCUS_CINEMATIC]){
				gameUI.setCinematicMode(true);
			}
			if (GameData._Save.data.pause[GameData.FOCUS_SIMPLE]){
				gameUI.setSimpleMode(true);
			}
			if (GameData._Save.data.pause[GameData.CURSOR]){
				mouseC.setMouseMode(false);
			}
		}
		
		public static function refocus(e:Event){
			if (GameData._Save.data.pause[GameData.FOCUS_CINEMATIC]){
				gameUI.setCinematicMode(false);
			}
			if (GameData._Save.data.pause[GameData.FOCUS_SIMPLE]){
				gameUI.setSimpleMode(false);
			}
			if (GameData._Save.data.pause[GameData.CURSOR]){
				mouseC.setMouseMode(true);
			}
		}
	}
}