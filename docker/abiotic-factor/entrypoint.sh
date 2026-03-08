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
if [ ! -f "/server-data/AbioticFactorServer.exe" ] || [[ $AutoUpdate == "true" ]]; then
    steamcmd \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir /server-data \
    +login anonymous \
    +app_update 2857200 validate \
    +quit
fi

cd /server-data

# Start Xvfb for headless Wine
Xvfb :99 -screen 0 1024x768x16 &
export DISPLAY=:99

wine AbioticFactorServer.exe $SetUsePerfThreads$SetNoAsyncLoadingThread-MaxServerPlayers=$MaxServerPlayers \
    -PORT=$Port -QueryPort=$QueryPort -ServerPassword=$ServerPassword \
    -SteamServerName="$SteamServerName" -WorldSaveName="$WorldSaveName" -tcp $AdditionalArgs