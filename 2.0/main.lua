local latestTxt = "https://raw.githubusercontent.com/Bigmancozmo/limeos-game-studio/main/2.0/newestVersion.txt"
local latestVersion = HttpGet(latestTxt)
local localVersion = "2.0.0"
local needsUpdate = latestVersion == localVersion
print(tostring(needsUpdate))
