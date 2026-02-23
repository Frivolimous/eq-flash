package utils {

    import flash.events.Event;
    import flash.net.SharedObject;
    import flash.utils.Dictionary;

    import ui.windows.ConfirmWindow;

    public class PlayfabAPI {
        public static var connected:Boolean=false;

        static var saveSO:SharedObject;

        public static var expiredMC:ExpiredW;

        // ===============================
        // INIT / LOGIN
        // ===============================

        public static function init():void {
            initLocalSave();
            simulateLogin();
        }

        static function initLocalSave():void {
            saveSO = SharedObject.getLocal("OfflineSave");
            if (saveSO.data.playerData == null)
                saveSO.data.playerData = {};
        }

        static function simulateLogin():void {
            connected = true;

            Facade.addLine("Offline Mode: Login Success");

            if (saveSO.data.displayName == null)
                finishCreation();
        }

        public static function finishCreation():void {
            var name:String = "OfflinePlayer";

            if (KongregateAPI != null)
                name = KongregateAPI.getName();

            saveSO.data.displayName = name;
            saveSO.flush();
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
            if (Facade.gameC != null)
                Facade.gameC.pauseGame(true);

            expiredMC = new ExpiredW();

            Facade.stage.addEventListener(Event.ENTER_FRAME, locked);
        }

        public static function locked(e:Event):void {

            Facade.stage.addChild(expiredMC);
        }
    }
}