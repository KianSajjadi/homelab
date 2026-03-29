SetUsePerfThreads="-useperfthreads "
if [[ $UsePerfThreads == "false" ]]; then
    SetUsePerfThreads=""
fi

SetNoAsyncLoadingThread="-NoAsyncLoadingThread "
if [[ $NoAsyncLoadingThread == "false" ]]; then
    SetNoAsyncLoadingThread=""
fi

MaxServerPlayers="${MaxServerPlayers:-6}"
Port="${Port:-7777}"
QueryPort="${QueryPort:-27015}"
ServerPassword="${ServerPassword:-password}"
SteamServerName="${SteamServerName:-LinuxServer}"
WorldSaveName="${WorldSaveName:-Cascade}"
AdditionalArgs="${AdditionalArgs:-}"

# Check for updates/perform initial installation
SERVER_EXE="/server-data/AbioticFactor/Binaries/Win64/AbioticFactorServer-Win64-Shipping.exe"
if [ ! -f "$SERVER_EXE" ] || [[ $AutoUpdate == "true" ]]; then
    steamcmd \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir /server-data \
    +login anonymous \
    +app_update 2857200 validate \
    +quit
fi

cd /server-data/AbioticFactor/Binaries/Win64

# Start Xvfb for headless Wine
Xvfb :99 -screen 0 1024x768x16 &
export DISPLAY=:99

wine AbioticFactorServer-Win64-Shipping.exe $SetUsePerfThreads$SetNoAsyncLoadingThread-MaxServerPlayers=$MaxServerPlayers \
    -PORT=$Port -QueryPort=$QueryPort -ServerPassword=$ServerPassword \
    -SteamServerName="$SteamServerName" -WorldSaveName="$WorldSaveName" -MULTIHOME=0.0.0.0 -tcp $AdditionalArgs