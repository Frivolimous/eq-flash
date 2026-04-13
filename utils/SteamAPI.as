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
                throw new Error("No Cloud Save");
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
        override internal function syncAll():void {
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

        // ===========================
        // ACHIEVEMENTS
        // ===========================

        override public function unlockAchievement(apiName:String,andStore:Boolean=true):void {
            if (GameData.DEMO) return;

            // Standard ANE call to unlock and push to server
            steam.setAchievement(apiName);
            if (andStore) steam.storeStats();
        }

        override public function forceStore():void {
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