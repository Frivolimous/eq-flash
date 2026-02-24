package utils {

    import flash.events.Event;
    import flash.net.SharedObject;
    import utils.Base64;
    import flash.utils.ByteArray;

    import ui.windows.ConfirmWindow;

    public class NoSteamXAPI {
        public static var connected:Boolean=false;
        
        // Steam ANE instance
        private static const SAVE_FILE_NAME:String = "savegame.json";
        private static const SECRET_KEY:String = "EQ_KEY_F17eH51B";

        static var saveSO:SharedObject;

        public static var expiredMC:ExpiredW;
        
        // ===============================
        // INIT / LOGIN
        // ===============================

        public static function init():void {
            connected = true;          
            Facade.addLine("Steam Disabled; local only");

            // 2. Load data into memory
            initLocalSave();
        }

        private static function initLocalSave():void {
            // Default fallback
            saveSO = SharedObject.getLocal("OfflineSave");
            if (saveSO.data.playerData == null)
                saveSO.data.playerData = {};
        }

        /**
         * The Master Save Function
         * Syncs to both Local SO and Steam Cloud
         */
        private static function syncAll():void {
            saveSO.flush();
        }
        
        private static function deleteEverything(): void {
        }

        // ===============================
        // PLAYER DATA SAVE / LOAD
        // ===============================

        public static function submitPlayerData(_obj:*, _override:Boolean=false):void {
            for (var key:String in _obj) {
                if (_obj[key] == null) {
                    delete saveSO.data.playerData[key];
                } else {
                    // Storing as JSON-friendly format
                    saveSO.data.playerData[key] = String(_obj[key]);
                }
            }

            syncAll();
            Facade.addLine("Game Saved to Cloud");
        }

        public static function retrievePlayerData(_vars:Array,_onComplete:Function):void {
            var result:Object = {};

            for each (var key:String in _vars) {
                if (saveSO.data.playerData[key] != null) {
                    result[key] = {
                        Value: saveSO.data.playerData[key]
                    };
                }
            }

            _onComplete(result);
        }

        public static function retrieveAllPlayerData(_onComplete:Function):void {
            var result:Object = {};
            for (var key:String in saveSO.data.playerData) {
                result[key] = {
                    Value: saveSO.data.playerData[key]
                };
            }
            Facade.addLine("retrieving player data: " + String(result));

            _onComplete(result);
        }

        public static function deletePlayerData(a:Array):void {
            for each (var key:String in a)
                delete saveSO.data.playerData[key];

            syncAll();
        }

        // ===============================
        // TIME
        // ===============================

        public static function getTime(_function:Function):void {

            _function(new Date());
        }

        // ===============================
        // HIGHSCORE
        // ===============================

        public static function submitHighscoreScript(i:int):void {
            var current:int = 0;
            if (saveSO.data.playerData["Highscore"] != null)
                current = saveSO.data.playerData["Highscore"];

            if (i > current) {
                saveSO.data.playerData["Highscore"] = i;
            }

            syncAll();
            Facade.addLine("Highscore Synced");
        }

        public static function expiredSession(_s:String):void {
            if (Facade.gameC != null)
                Facade.gameC.pauseGame(true);

            expiredMC = new ExpiredW();
            
            if (_s !== null) {
                expiredMC.display.text = _s;
            }

            Facade.stage.addEventListener(Event.ENTER_FRAME, locked);
        }

        public static function locked(e:Event):void {
            Facade.stage.addChild(expiredMC);
        }

        public static function getName():String {
            return "Debugger";
        }

        private static function encrypt(input:String):String {
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

        private static function decrypt(input:String):String {
            // return input;

            var decoded:String = Base64.decode(input);
            var result:String = "";
            for (var i:int = 0; i < decoded.length; i++) {
                var charCode:int = decoded.charCodeAt(i) ^ SECRET_KEY.charCodeAt(i % SECRET_KEY.length);
                result += String.fromCharCode(charCode);
            }
            return result;
        }
    }
}