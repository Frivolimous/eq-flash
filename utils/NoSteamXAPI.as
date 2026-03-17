package utils {

    import flash.events.Event;
    import flash.net.SharedObject;
    import utils.Base64;
    import flash.utils.ByteArray;

    import ui.windows.ConfirmWindow;

    public class NoSteamXAPI {
        public var connected:Boolean=false;
        
        // Steam ANE instance
        private const SAVE_FILE_NAME:String = "savegame.json";
        private const SECRET_KEY:String = "EQ_KEY_F17eH51B";

        var saveSO:SharedObject;

        public var expiredMC:ExpiredW;
        
        // ===============================
        // INIT / LOGIN
        // ===============================

        public function init():void {
            connected = true;          
            Facade.addLine("Steam Disabled; local only");

            // 2. Load data into memory
            initLocalSave();
        }

        private function initLocalSave():void {
            // Default fallback
            saveSO = SharedObject.getLocal("OfflineSave");
        }

        /**
         * The Master Save Function
         * Syncs to both Local SO and Steam Cloud
         */
        private function syncAll():void {
            saveSO.flush();
        }
        
        public function deleteEverything(): void {
            saveSO.clear();
            syncAll();
        }

        // ===============================
        // PLAYER DATA SAVE / LOAD
        // ===============================

        public function setPlayerProperty(_key:String,_value:*):void {
            if (_value == null){
                delete saveSO.data[_key];
            }else{
                saveSO.data[_key]=valueToJSON(_value);
            }
            delay=DELAY;
        }

        public function setPlayerProperties(_queue:Array):void {
            for(var i=0;i<_queue.length;i+=1){
                 if (_queue[i][1] == null){
                    delete saveSO.data[_queue[i][0]];
                }else{
                    saveSO.data[_queue[i][0]]=valueToJSON(_queue[i][1]);
                }
            }
            delay=DELAY;
        }

        public function submitPlayerData(_obj:*):void {
            for (var key:String in _obj) {
                if (_obj[key] == null) {
                    delete saveSO.data[key];
                } else {
                    // Storing as JSON-friendly format
                    saveSO.data[key] = String(_obj[key]);
                }
            }

            delay=DELAY;
        }

        public function retrievePlayerData(_vars:Array,_onComplete:Function):void {
            var result:Object = {};

            for each (var key:String in _vars) {
                if (saveSO.data[key] != null) {
                    result[key] = stringToValue(saveSO.data[key]);
                }
            }

            _onComplete(result);
        }

        public function retrieveAllPlayerData(_onComplete:Function):void {
            var result:Object = {};
            for (var key:String in saveSO.data) {
                result[key] = stringToValue(saveSO.data[key]);
            }
            Facade.addLine("retrieving player data: " + JSON.stringify(result));

            _onComplete(result);
        }

        public function deletePlayerData(a:Array):void {
            for each (var key:String in a)
                delete saveSO.data[key];

            delay=DELAY;
        }

        // ===============================
        // TIME
        // ===============================

        public function getTime(_function:Function):void {
            var _now = new Date();
            _function(_now.time);
        }

        // ===============================
        // HIGHSCORE
        // ===============================

        public function expiredSession(_s:String):void {
            if (Facade.gameC != null)
                Facade.gameC.pauseGame(true);

            expiredMC = new ExpiredW();
            
            if (_s !== null) {
                expiredMC.display.text = _s;
            }

            Facade.stage.addEventListener(Event.ENTER_FRAME, locked);
        }

        public function locked(e:Event):void {
            Facade.stage.addChild(expiredMC);
        }

        public function getName():String {
            return "Debugger";
        }

        private function encrypt(input:String):String {
            // return input;

            var result:String = "";
            for (var i:int = 0; i < input.length; i++) {
                // XOR each character with a character from our key
                var charCode:int = input.charCodeAt(i) ^ SECRET_KEY.charCodeAt(i % SECRET_KEY.length);
                result += String.fromCharCode(charCode);
            }
            // Convert to Base64 to make it "file-friendly" and hide the XOR patterns
            return Base64.encode(result);
        }

        private function decrypt(input:String):String {
            // return input;

            var decoded:String = Base64.decode(input);
            var result:String = "";
            for (var i:int = 0; i < decoded.length; i++) {
                var charCode:int = decoded.charCodeAt(i) ^ SECRET_KEY.charCodeAt(i % SECRET_KEY.length);
                result += String.fromCharCode(charCode);
            }
            return result;
        }

        // ===========================
        // ACHIEVEMENTS
        // ===========================

        public function unlockAchievement(apiName:String,andStore:Boolean=true):void {
            Facade.addLine("Fake Achieve: "+apiName);
        }

        public function forceStore():void {

        }

        private function resetAchievements():void {
        }

        public function hasPremiumDLC(): Boolean {
            return true;
        }

        public function checkAchievement(apiName:String):Boolean {
            return false;
        }
        
        public function setStatInt(stat:String, score:int):void {
            Facade.addLine("Fake Stat: "+stat);
        }

        // === OLD SUBFUNKS === \\
		public var delay:int=0;
		public const DELAY:int=2;
		public function submitDataPerTick(){
			if (delay>0){
				delay-=1;
				return;
			}

            if (delay==0){
                delay-=1;
                syncAll();
                Facade.addLine("Game Saved to Cloud");
            }
		}
		
		public function valueToJSON(v:*):*{
			if (v is Number || v is int || v is String || v is Boolean){
				return String(v);
			}else if (v is Array){
				return arrayToString(v);
			}else{
				return null;
			}
		}
		
		public function arrayToString(a:Array,_incNull:Boolean=false):String{
			var m:String="[";
			for (var i:int=0;i<a.length;i+=1){
				if (a[i] is Array){
					m+=arrayToString(a[i],_incNull);
				}else if (_incNull){
					if (a[i]==null){
						m+="null";
					}else if (a[i] is String){
						m+='"'+String(a[i])+'"';
					}else{
						m+=String(a[i]);
					}
				}else if (a[i]!=null){
					m+=String(a[i]);
				}
				if (i<a.length-1){
					m+=",";
				}
			}
			
			m+="]";
			return m;
		}

        public function stringToValue(s:String):*{
			if (s=="true"){
				return true;
			}else if (s=="false"){
				return false;
			}else if (s.search(/\d/)==0 || s.substr(0,1)=="-"){
				return Number(s);
			}else if (s.charAt(0)=="["){
				return stringToArray(s);
			}else{
				return s;
			}
		}
				
		public function stringToArray(s:String):*{
			var m:Array=new Array;
			//var j:*=JSON.parse("{a:"+s+"}");
			s=s.substring(1);
			
			while(s.length>0){
				if (s.charAt(0)=="["){
					var i:int=1;
					char=0
					var r:int=0;
					s2=s;
					while (i>0){
						var s2:String=s2.substring(char+1);
						r+=char+1;
						char=s2.search(/(\[|\])/);
						if (s.charAt(char+r)=="["){
							i+=1;
						}else{
							i-=1;
						}
					}
					m.push(stringToArray(s.substring(0,char+r+1)));
					s=s.substring(char+r+2);
					
				}else{
					var char:int=s.indexOf(",");
					if (char==-1){
						char=s.indexOf("]");
						if (char==0){
							m.push(null);
						}else{
							m.push(stringToValue(s.substring(0,char)));
						}
						s="";
					}else{
						if (char==0){
							m.push(null);
							s=s.substring(1);
						}else{
							m.push(stringToValue(s.substring(0,char)));
							s=s.substring(char+1);
						}
					}
				}
			}
			return m;
		}

        public function get BUSY():Boolean{
			return delay>0;
		}
		
		public function set BUSY(b:Boolean){
			//null
		}
		
    }
}