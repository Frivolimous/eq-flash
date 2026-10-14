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
            if (steam.init()) {
                connected = true;
                Facade.addLine("Steam Connected: " + steam.getPersonaName());
            }
            
            // 2. Load data into memory
            initLocalSave();
        }

        internal function initLocalSave():void {
            delay = connected ? -1 : DELAY;
            saveSO = SharedObject.getLocal("OfflineSave");
            if (saveSO.data.playerData == null)
                saveSO.data.playerData = {};

            loadCloudSave();
        }

        private function loadCloudSave():void {
            if (!connected)
                return;

            if (!steam.fileExists(SAVE_FILE_NAME)) {
                cloudMissing = true;
                Facade.addLine("Steam Cloud save is not currently available.");
                return;
            }

            cloudMissing = false;
            var ba:ByteArray = new ByteArray();
            if (!steam.fileRead(SAVE_FILE_NAME, ba)) {
                cloudCorrupt = true;
                Facade.addLine("Steam Cloud Read Failed; using local save.");
                return;
            }

            try {
                ba.position = 0;
                var encrypted:String = ba.readUTFBytes(ba.bytesAvailable);
                encrypted = encrypted.replace(/\0/g, "").replace(/^\s+|\s+$/g, "");

                var jsonStr:String = decrypt(encrypted);
                var cloudData:* = JSON.parse(jsonStr);
                if (cloudData == null || typeof cloudData != "object" || cloudData is Array)
                    throw new Error("Cloud save must contain a player data object.");

                this.cloudData = cloudData;
                cloudLoaded = true;
                Facade.addLine("Steam Cloud Load Success");
            } catch (e:Error) {
                cloudCorrupt = true;
                Facade.addLine("Data Corrupt; using local save: " + e.message);
            }
        }

        override public function retrieveAllPlayerData(_onComplete:Function):void {
            if (connected && !cloudLoaded)
                loadCloudSave();

            if (cloudMissing) {
                if (hasSaveData(saveSO.data.playerData)) {
                    new ConfirmWindow(
                        "A Steam Cloud save is not currently available. If this is a new or recently synced device, cancel and try again later.\n\nYES: Use this computer's local save and sync it to Steam Cloud\nNO: Cancel startup",
                        50, 50,
                        function():void { useLocalSave(_onComplete); },
                        0,
                        function():void { Facade.addLine("Startup cancelled; saves were not changed."); },
                        3
                    );
                } else {
                    new ConfirmWindow(
                        "No Steam Cloud or local save is currently available. Start a new game only if you're sure there is no save to recover.\n\nYES: Start a new game and create a save\nNO: Cancel startup",
                        50, 50,
                        function():void { startNewGame(_onComplete); },
                        0,
                        function():void { Facade.addLine("Startup cancelled; no save was created."); },
                        3
                    );
                }
                return;
            }

            if (cloudLoaded) {
                var localData:Object = saveSO.data.playerData;
                if (hasSaveData(localData) && hasSaveData(cloudData) &&
                    !playerDataMatches(localData, cloudData)) {
                    new ConfirmWindow(
                        "Your local save and Steam Cloud save are different.\n\nYES: Use Steam Cloud save\nNO: Use this computer's local save",
                        50, 50,
                        function():void { useCloudSave(_onComplete); },
                        0,
                        function():void { useLocalSave(_onComplete); },
                        3
                    );
                    return;
                }

                useCloudSave(_onComplete);
                return;
            }

            if (cloudCorrupt) {
                if (hasSaveData(saveSO.data.playerData)) {
                    new ConfirmWindow(
                        "The Steam Cloud save could not be read.\n\nYES: Use this computer's local save\nNO: Cancel startup without changing either save",
                        50, 50,
                        function():void { useLocalSave(_onComplete); },
                        0,
                        function():void { Facade.addLine("Startup cancelled; saves were not changed."); },
                        3
                    );
                } else {
                    new ConfirmWindow(
                        "The Steam Cloud save is unreadable and no local save is available. Startup is cancelled; no save was changed.",
                        50, 50, null, 0, null, 3
                    );
                }
                return;
            }

            super.retrieveAllPlayerData(_onComplete);
        }

        private function hasSaveData(data:Object):Boolean {
            for (var key:String in data)
                return true;
            return false;
        }

        private function playerDataMatches(localData:Object, remoteData:Object):Boolean {
            var keyCount:int = 0;
            for (var key:String in localData) {
                keyCount++;
                if (!remoteData.hasOwnProperty(key) ||
                    JSON.stringify(localData[key]) != JSON.stringify(remoteData[key]))
                    return false;
            }

            var remoteKeyCount:int = 0;
            for (key in remoteData)
                remoteKeyCount++;

            return keyCount == remoteKeyCount;
        }

        private function useCloudSave(onComplete:Function):void {
            saveSO.data.playerData = cloudData;
            saveSO.flush();
            super.retrieveAllPlayerData(onComplete);
        }

        private function useLocalSave(onComplete:Function):void {
            Facade.addLine("Using local save; Steam Cloud will be updated on the next save.");
            delay = DELAY;
            super.retrieveAllPlayerData(onComplete);
        }

        private function startNewGame(onComplete:Function):void {
            Facade.addLine("Starting a new game after user confirmation.");
            delay = DELAY;
            super.retrieveAllPlayerData(onComplete);
        }

        /**
         * The Master Save Function
         * Syncs to both Local SO and Steam Cloud
         */
        override internal function syncAll():void {
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