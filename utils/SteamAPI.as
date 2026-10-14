package utils {

    import flash.events.Event;
    import flash.net.SharedObject;
    import com.amanitadesign.steam.FRESteamWorks; // Using the ANE we verified
    import utils.Base64;
    import flash.utils.ByteArray;

    import ui.windows.ConfirmWindow;

    public class SteamAPI  extends NoSteamXAPI {
        // Steam ANE instance
        internal var steam:FRESteamWorks;
        private var cloudLoaded:Boolean = false;
        private var cloudCorrupt:Boolean = false;
        private var cloudMissing:Boolean = false;
        private var cloudData:Object;

        // ===============================
        // INIT / LOGIN
        // ===============================

        override public function init():void {
            // 1. Initialize Steam first
            steam = new FRESteamWorks();
            if (!steam.init()) {
                // Facade.initialize catches this and falls back to NoSteamXAPI
                throw new Error("Steam Init Failed");
            }
            connected = true;
            Facade.addLine("Steam Connected: " + steam.getPersonaName());

            // 2. Load data into memory
            initLocalSave();
        }

        internal function initLocalSave():void {
            // don't let the first tick push the local save to the cloud before we've compared them
            delay = -1;
            saveSO = SharedObject.getLocal("OfflineSave");
            if (saveSO.data.playerData == null)
                saveSO.data.playerData = {};

            loadCloudSave();
        }

        private function loadCloudSave():void {
            cloudLoaded = false;
            cloudCorrupt = false;
            cloudMissing = false;
            cloudData = null;

            if (!steam.fileExists(SAVE_FILE_NAME)) {
                cloudMissing = true;
                Facade.addLine("No Steam Cloud save.");
                return;
            }

            var ba:ByteArray = new ByteArray();
            if (!steam.fileRead(SAVE_FILE_NAME, ba)) {
                cloudCorrupt = true;
                Facade.addLine("Steam Cloud Read Failed.");
                return;
            }

            try {
                ba.position = 0;
                var encrypted:String = ba.readUTFBytes(ba.bytesAvailable);
                encrypted = encrypted.replace(/\0/g, "").replace(/^\s+|\s+$/g, "");

                var parsed:* = JSON.parse(decrypt(encrypted));
                if (parsed == null || typeof parsed != "object" || parsed is Array)
                    throw new Error("Cloud save must contain a player data object.");

                cloudData = parsed;
                cloudLoaded = true;
                Facade.addLine("Steam Cloud Load Success");
            } catch (e:Error) {
                cloudCorrupt = true;
                Facade.addLine("Steam Cloud Data Corrupt: " + e.message);
            }
        }

        override public function retrieveAllPlayerData(_onComplete:Function):void {
            var localData:Object = saveSO.data.playerData;
            var hasLocal:Boolean = hasSaveData(localData);

            if (cloudCorrupt) {
                if (hasLocal) {
                    new ConfirmWindow(
                        "The Steam Cloud save could not be read.\n\nYES: Use this computer's save (" + describeSaveTime(localData) + ") and replace the cloud save\nNO: Quit without changing either save",
                        50, 50,
                        function(i:int = 0):void { useLocalSave(_onComplete); },
                        0,
                        quitGame,
                        3
                    );
                } else {
                    new ConfirmWindow(
                        "The Steam Cloud save could not be read and there is no save on this computer.\n\nYES: Start a new game and replace the cloud save\nNO: Quit without changing anything",
                        50, 50,
                        function(i:int = 0):void { startNewGame(_onComplete); },
                        0,
                        quitGame,
                        3
                    );
                }
                return;
            }

            if (cloudLoaded && hasSaveData(cloudData)) {
                if (hasLocal && !playerDataMatches(localData, cloudData)) {
                    new ConfirmWindow(
                        "Your Steam Cloud save and this computer's save are different.\n\nCloud: " + describeSaveTime(cloudData) + "\nThis computer: " + describeSaveTime(localData) + "\n\nYES: Use the Steam Cloud save\nNO: Use this computer's save",
                        50, 50,
                        function(i:int = 0):void { useCloudSave(_onComplete); },
                        0,
                        function():void { useLocalSave(_onComplete); },
                        3
                    );
                    return;
                }

                useCloudSave(_onComplete);
                return;
            }

            // cloud is missing or empty: whatever is on this computer (possibly nothing) wins
            if (hasLocal)
                useLocalSave(_onComplete);
            else
                startNewGame(_onComplete);
        }

        private function hasSaveData(data:Object):Boolean {
            for (var key:String in data)
                if (key != SAVED_AT) return true;
            return false;
        }

        // compares save contents only; the save time can differ if a cloud write failed
        private function playerDataMatches(localData:Object, remoteData:Object):Boolean {
            var keyCount:int = 0;
            for (var key:String in localData) {
                if (key == SAVED_AT) continue;
                keyCount++;
                if (!remoteData.hasOwnProperty(key) ||
                    JSON.stringify(localData[key]) != JSON.stringify(remoteData[key]))
                    return false;
            }

            var remoteKeyCount:int = 0;
            for (key in remoteData)
                if (key != SAVED_AT) remoteKeyCount++;

            return keyCount == remoteKeyCount;
        }

        private function describeSaveTime(data:Object):String {
            var time:Number = Number(data[SAVED_AT]);
            if (isNaN(time) || time <= 0)
                return "save time unknown";
            return "saved " + new Date(time).toLocaleString();
        }

        private function useCloudSave(onComplete:Function):void {
            Facade.addLine("Using Steam Cloud save.");
            saveSO.data.playerData = cloudData;
            saveSO.flush();
            super.retrieveAllPlayerData(onComplete);
        }

        private function useLocalSave(onComplete:Function):void {
            Facade.addLine("Using local save; Steam Cloud will be updated.");
            delay = DELAY;
            super.retrieveAllPlayerData(onComplete);
        }

        private function startNewGame(onComplete:Function):void {
            Facade.addLine("Starting a new game.");
            saveSO.data.playerData = {};
            delay = DELAY;
            super.retrieveAllPlayerData(onComplete);
        }

        /**
         * The Master Save Function
         * Syncs to both Local SO and Steam Cloud
         */
        override internal function syncAll():void {
            stampSaveTime();
            saveSO.flush();

            if (connected) {
                var jsonStr:String = JSON.stringify(saveSO.data.playerData);
                var encrypted:String = encrypt(jsonStr);
                
                // Prepare the ByteArray
                var ba:ByteArray = new ByteArray();
                ba.writeUTFBytes(encrypted);
                ba.position = 0;
                
                var success:Boolean = steam.fileWrite(SAVE_FILE_NAME, ba);
                
                if (success) {
                    Facade.addLine("STEAM ACCEPTED FILE: " + SAVE_FILE_NAME);
                } else {
                    Facade.addLine("STEAM REJECTED WRITE. Check AppID/Extension.");
                }
            }
        }

        // ===========================
        // ACHIEVEMENTS
        // ===========================

        override public function unlockAchievement(apiName:String,andStore:Boolean=true):void {
            if (GameData.DEMO || !connected) return;

            // Standard ANE call to unlock and push to server
            steam.setAchievement(apiName);
            if (andStore) steam.storeStats();
        }

        override public function forceStore():void {
            if (!connected) return;
            steam.storeStats();
        }

        override internal function resetAchievements():void {
            if (connected) {
                steam.resetAllStats(true);
                steam.storeStats();
            }
        }

        override public function hasPremiumDLC():Boolean {
            if (GameData.DEMO) return false;

            if (connected) {
                if (steam.isSubscribedApp(4512700) || steam.isDLCInstalled(4512700)){
                    return true;
                }
            }
            return false;
        }

        override public function checkAchievement(apiName:String):Boolean {
            if (GameData.DEMO) return false;

            if (!connected) return false;
            return false;
            // return steam.getAchievement(apiName);
        }

        override public function setStatInt(stat:String,score:int):void {
            if (!connected) return;
            Facade.addLine("Attempt Stat: "+stat);
            steam.setStatInt(stat, score);
            Facade.addLine("Stat: "+stat);
        }

        // === OLD SUBFUNKS === \\
    }
}