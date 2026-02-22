package utils {

    import flash.events.Event;
    import flash.net.SharedObject;
    import flash.utils.Dictionary;

    import ui.windows.ConfirmWindow;

    public class PlayfabAPI {

        public static const ID:String="OFFLINE";

        public static var connected:Boolean=false;
        public static var disabled:Boolean=false;

        static var authKey:String="OFFLINE_SESSION";
        public static var loginCount:int=0;
        public static var expired:Boolean=false;

        public static var SUBMITTING:int=0;
        public static var FAILED:int=0;

        static var saveSO:SharedObject;

        public static var expiredMC:ExpiredW;

        // ===============================
        // INIT / LOGIN
        // ===============================

        public static function init():void {
            if (disabled) return;
            initLocalSave();
            simulateLogin();
        }

        public static function initNoKong():void {
            init();
        }

        static function initLocalSave():void {
            saveSO = SharedObject.getLocal("OfflineSave");
            if (saveSO.data.playerData == null)
                saveSO.data.playerData = {};
        }

        static function simulateLogin():void {

            connected = true;
            authKey = "OFFLINE_" + new Date().time;
            loginCount++;

            Facade.addLine("Offline Mode: Login Success");

            if (saveSO.data.displayName == null)
                finishCreation();
        }

        public static function tryLogin():void {
            simulateLogin();
        }

        public static function tryLoginCustom():void {
            simulateLogin();
        }

        public static function onPostComplete(resultData:Object):void {
            // Not needed offline
        }

        public static function finishCreation():void {

            var name:String = "OfflinePlayer";

            if (KongregateAPI != null)
                name = KongregateAPI.getName();

            saveSO.data.displayName = name;
            saveSO.flush();

            finishLoginComplete(null);
        }

        public static function finishLoginComplete(result:*):void {
            Facade.addLine("Offline Username Ready");
        }

        // ===============================
        // OLD SAVE SUPPORT
        // ===============================

        public static function clearOldSave(_complete:Function):void {

            delete saveSO.data.playerData["OldSave"];
            saveSO.flush();

            Facade.addLine("Offline Save Cleared");

            if (_complete != null)
                _complete();
        }

        public static function submitOldSave(s:String, _complete:Function):void {

            Facade.addLine("Submitting Offline Save...");

            saveSO.data.playerData["OldSave"] = s;
            saveSO.flush();

            Facade.addLine("Offline Save Complete");

            if (_complete != null)
                _complete();
        }

        public static function getOldSave(_complete:Function):void {

            var value:String = null;

            if (saveSO.data.playerData["OldSave"] != null)
                value = saveSO.data.playerData["OldSave"];

            _complete(value);
        }

        // ===============================
        // PLAYER DATA SAVE / LOAD
        // ===============================

        public static function submitPlayerData(_obj:*, _override:Boolean=false):void {

            for (var key:String in _obj) {

                if (_obj[key] == null) {
                    delete saveSO.data.playerData[key];
                } else {
                    saveSO.data.playerData[key] = String(_obj[key]);
                }
            }

            saveSO.flush();

            onFinishSubmitComplete(null);
        }

        public static function authenticateThenSubmit(_obj:*):void {

            submitPlayerData(_obj, true);
        }

        public static function onFinishSubmitComplete(result:Object):void {

            Facade.addLine("Offline Save Successful");
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

            _onComplete(result);
        }

        public static function deletePlayerData(a:Array):void {

            for each (var key:String in a)
                delete saveSO.data.playerData[key];

            saveSO.flush();
        }

        public static function onFinishDeleteComplete(result:Object):void {

            Facade.addLine("Offline Delete Successful");
        }

        // ===============================
        // ARENA (LOCAL ONLY)
        // ===============================

        public static function submitArena(s:String):void {

            if (saveSO.data.playerData["T1Submit"] == "true") {

                new ConfirmWindow(
                    "You already submitted an arena character."
                );

                return;
            }

            saveSO.data.playerData["ArenaChar"] = s;
            saveSO.data.playerData["T1Submit"] = "true";

            saveSO.flush();

            Facade.addLine("Arena Submitted Offline");
        }

        public static function getArenaCharacters():void {

            var a:Array = [];

            if (saveSO.data.playerData["ArenaChar"] != null) {

                a.push([
                    saveSO.data.displayName,
                    "OFFLINE_ID",
                    saveSO.data.playerData["ArenaChar"]
                ]);
            }

            trace(a);
        }

        public static function finishSubmitArena(s:String):void {}

        public static function onSubmitComplete(result:Object):void {}

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

            if (i > current)
                saveSO.data.playerData["Highscore"] = i;

            saveSO.flush();

            Facade.addLine("Offline Highscore Saved");
        }

        // ===============================
        // SESSION EXPIRE (NOT USED OFFLINE)
        // ===============================

        public static function expiredSession():void {

            expired = true;

            if (Facade.gameC != null)
                Facade.gameC.pauseGame(true);

            expiredMC = new ExpiredW();

            Facade.stage.addEventListener(Event.ENTER_FRAME, locked);
        }

        public static function locked(e:Event):void {

            Facade.stage.addChild(expiredMC);
        }

        // ===============================
        // HTTP STUB (DO NOTHING)
        // ===============================

        public static function goHTTP(
            s:String,
            j:*,
            f:Function,
            authorize:Boolean=true):void {

            // Offline mode: immediately return empty result

            if (f != null)
                f({});
        }
    }
}