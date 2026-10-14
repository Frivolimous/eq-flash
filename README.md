EQ Flash - continuation of flash project to deploy to steam

# SETUP
1. Install Flash Professional CS6
2. Install AIRSDK_32
3. Install missing fonts
4. update jvm.ini to 256
5. check publish settings -> as3 -> library folders linking GRAPHICS and STEAMWORKS to correct folders


# DEPLOY
1. toggle demo on or off, edit code, bla bla bla
2. CTRL + SHIFT + ENTER inside Flash CS6 to compile
3. run 'airdeploy' to deploy files to dist/
4. download steam sdk
5. run SteamSDK\tools\ContentBuilder\builder\steamcmd.exe
6. log in with deploy account
7. update .vdf and .bat files to deploy DEMO and MAIN builds correctly
8. run bat files to deploy
9. log in to steamworks and update build to latest
