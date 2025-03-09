-- limeos uninstaller

local kernel = loadlib("Kernel")
local dtm = loadlib("DesktopManager")
local notif = loadlib("NotificationManager")
local fs = loadlib("FileSystem")

function restart_os()
  local countdown = 3
  repeat
    notif.SendNotification("ready?", tostring(countdown).." second(s) left...")
    countdown = countdown - 1
    wait(1)
  until countdown <= 0
  dtm.LogOut()
  kernel.MemAlloc("a")
end

wait(3)
print("the deletion is commencing.")
local partitions = fs.GetPartitions()
for i, v in pairs(partitions) do
  print(tostring(fs.DelPartition(v.Name)))
end
