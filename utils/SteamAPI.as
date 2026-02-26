package utils {

    import flash.events.Event;
    import flash.net.SharedObject;
    import com.amanitadesign.steam.FRESteamWorks; // Using the ANE we verified
    import utils.Base64;
    import flash.utils.ByteArray;

    import ui.windows.ConfirmWindow;

    public class SteamAPI {
        public var connected:Boolean=false;

        public const ENCRYPT:Boolean=false;
        
        // Steam ANE instance
        private var steam:FRESteamWorks;
        private const SAVE_FILE_NAME:String = "savegame.json";
        private const SECRET_KEY:String = "EQ_KEY_F17eH51B";

        var saveSO:SharedObject;

        public var expiredMC:ExpiredW;

        private const ACHIEVEMENT_MAP:Array = [
            {id:"ACH_TUTORIAL",  ref:"FLAG_TUTORIAL", type:"bool"},
            {id:"ACH_TREASURE",  ref:"FLAG_TREASURE", type:"bool"},
            {id:"ACH_DEFT",      ref:"SCORE_DAMAGE",  type:"int",  min:100},
            {id:"ACH_NOBLE",     ref:"SCORE_FURTHEST",type:"int",  min:50},
            {id:"ACH_TURBO",     ref:"SCORE_FURTHEST",type:"int",  min:100},
            {id:"ACH_ASCEND_50", ref:"SCORE_ASCENDS", type:"int",  min:50}
        ];

        public function syncAllAchievements():void {
            if (!connected) return;

            var pData:Object = saveSO.data.playerData;
            var changed:Boolean = false;

            for (var i:int = 0; i < ACHIEVEMENT_MAP.length; i++) {
                var ach:Object = ACHIEVEMENT_MAP[i];
                
                // 1. Check if they already have it on Steam to save API calls
                if (!steam["getAchievement"](ach.id)) {
                    
                    var shouldUnlock:Boolean = false;
                    
                    // 2. Determine if criteria is met based on type
                    if (ach.type == "bool" && pData[ach.ref] == true) {
                        shouldUnlock = true;
                    } else if (ach.type == "int" && pData[ach.ref] >= ach.min) {
                        shouldUnlock = true;
                    }

                    // 3. Trigger Unlock
                    if (shouldUnlock) {
                        steam["setAchievement"](ach.id);
                        changed = true;
                        Facade.addLine("🏆 Steam Unlocked: " + ach.id);
                    }
                }
            }

            // 4. Only push to Steam servers if a change actually occurred
            if (changed) {
                steam["storeStats"]();
            }
        }
        
        // ===============================
        // INIT / LOGIN
        // ===============================

        public function init():void {            
            // 1. Initialize Steam first
            try {
                steam = new FRESteamWorks();
                if (steam.init()) {
                    connected = true;
                    // Facade.addLine("Steam Connected: " + steam.getPersonaName());
                }
            } catch (e:Error) {
                Facade.addLine("Steam Init Failed: " + e.message);
            }

            // 2. Load data into memory
            initLocalSave();
        }

        private function initLocalSave():void {
            var cloudExists:Boolean = false;
            if (connected) {
                cloudExists = steam.fileExists(SAVE_FILE_NAME);
                // Facade.addLine("Steam Cloud Exists: " + cloudExists);
            }

            if (cloudExists) {
                var ba:ByteArray = new ByteArray();
                var success:Boolean = steam.fileRead(SAVE_FILE_NAME, ba);

                if (success) {
                    ba.position = 0;
                    // Read the string
                    var encrypted:String = ba.readUTFBytes(ba.length);
                    
                    // 🛑 CRITICAL FIX: Trim null characters and whitespace 
                    // This prevents the "Data Corrupt" error from invisible bytes
                    encrypted = encrypted.replace(/\0/g, "").replace(/^\s+|\s+$/g, "");

                    var jsonStr: String = decrypt(encrypted);

                    try {
                        saveSO = SharedObject.getLocal("OfflineSave");
                        // Update the local SO with the fresh cloud data
                        saveSO.data.playerData = JSON.parse(jsonStr); 
                        
                        Facade.addLine("Steam Cloud Load Success");
                        return;
                    } catch (e:Error) {
                        // If it still fails, trace the string to see what's wrong
                        Facade.addLine("Data Corrupt: " + e.message);
                    }
                }
            } else {
                Facade.addLine("No Cloud Save");
            }
            
            // Default fallback
            saveSO = SharedObject.getLocal("OfflineSave");
            if (saveSO.data.playerData == null)
                saveSO.data.playerData = {};
        }

        /**
         * The Master Save Function
         * Syncs to both Local SO and Steam Cloud
         */
        private function syncAll():void {
            saveSO.flush();

            if (connected) {
                var jsonStr:String = JSON.stringify(saveSO.data.playerData);
                var encrypted:String = encrypt(jsonStr);
                
                // Prepare the ByteArray
                var ba:ByteArray = new ByteArray();
                ba.writeUTFBytes(encrypted);
                
                var success:Boolean = steam.fileWrite(SAVE_FILE_NAME, ba);
                
                if (success) {
                    Facade.addLine("STEAM ACCEPTED FILE: " + SAVE_FILE_NAME);
                } else {
                    Facade.addLine("STEAM REJECTED WRITE. Check AppID/Extension.");
                }
            }
        }
        
        private function deleteEverything(): void {
            if (connected) {
                // This tells Steam: "Delete this from the cloud and the user's disk"
                steam.fileDelete("savegame.json");
                Facade.addLine("Attempting to kill the ghost JSON...");
            }
        }

        // ===============================
        // PLAYER DATA SAVE / LOAD
        // ===============================

        public function submitPlayerData(_obj:*, _override:Boolean=false):void {
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

        public function retrievePlayerData(_vars:Array,_onComplete:Function):void {
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

        public function retrieveAllPlayerData(_onComplete:Function):void {
            var result:Object = {};
            for (var key:String in saveSO.data.playerData) {
                result[key] = {
                    Value: saveSO.data.playerData[key]
                };
            }
            Facade.addLine("retrieving player data: " + String(result));

            _onComplete(result);
        }

        public function deletePlayerData(a:Array):void {
            for each (var key:String in a)
                delete saveSO.data.playerData[key];

            syncAll();
        }

        // ===============================
        // TIME
        // ===============================

        public function getTime(_function:Function):void {
            _function(new Date());
        }

        // ===============================
        // HIGHSCORE
        // ===============================

        public function submitHighscoreScript(i:int):void {
            var current:int = 0;
            if (saveSO.data.playerData["Highscore"] != null)
                current = saveSO.data.playerData["Highscore"];

            if (i > current) {
                saveSO.data.playerData["Highscore"] = i;
                
                // If you want to trigger a Steam Achievement for a highscore
                // if (connected && i >= 1000) {
                //    steam.setAchievement("ACH_HIGH_SCORE");
                // }
            }

            syncAll();
            Facade.addLine("Highscore Synced");
        }

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
            return steam.getPersonaName();
        }

        private function encrypt(input:String):String {
            if (!ENCRYPT) return input;

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
            if (!ENCRYPT) return input;

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

        private function unlockAchievement(apiName:String):void {
            // Standard ANE call to unlock and push to server
            steam.setAchievement(apiName);
            steam.storeStats(); 
            Facade.addLine("🏆 Achievement Unlocked: " + apiName);
        }

        private function resetAchievements():void {
            if (connected) {
                steam.resetAllStats(true);
                steam.storeStats();
            }
        }

        public function hasPremiumDLC():Boolean {
            var dlcID:int = 999999; // Your future DLC ID
            if (connected) {
                return steam.isSubscribedApp(dlcID);
            }
            return false;
        }

        public function setStat(stat:String, score:int):void {
            if (!connected) return;

            steam.setStatInt(stat, score);
        }

        public function checkAchievement(apiName:String):Boolean {
            if (!connected) return;
            return steam.getAchievement(apiName);
        }

    //     steam["setStatInt"]("stat_kills", saveSO.data.playerData.SCORE_KILLS);
    // steam["setStatInt"]("stat_deaths", saveSO.data.playerData.SCORE_DEATHS);
    // steam["setStatInt"]("stat_ascends", saveSO.data.playerData.SCORE_ASCENDS);
    }
}