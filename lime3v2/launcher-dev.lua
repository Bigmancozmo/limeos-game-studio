local e,h,a,s=loadlib("Executor"),loadlib("Http"),loadlib("ApplicationHandler"),Lime.CreateWindow("launching...")
local c = h.HttpGet("https://raw.githubusercontent.com/Bigmancozmo/limeos-game-studio/refs/heads/main/lime3v2/main.lua")
a.ExitProcess(s.Parent.Value.Value)
print(c)
