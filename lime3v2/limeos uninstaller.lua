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

function commence_the_deletion()
  print("the deletion is commencing.")
  local partitions = fs.GetPartitions()
  for i, v in pairs(partitions) do
    print(tostring(fs.DelPartition(v.Name)))
  end
  wait(2)
  restart_os()
end

local window = Lime.CreateWindow("Professional LimeOS Uninstaller")
local textlabel = Lime.CreateUI(window, "TextLabel")
textlabel.Text = "Are you sure you want to uninstall LimeOS? (this is not a joke)"
textlabel.Size = UDim2.new(1,0,0.1,0)
textlabel.TextScaled = truelocal textlabel = Lime.CreateUI(window, "TextLabel")


local btn = Lime.CreateUI(window, "TextButton")
btn.Text = "Uninstall my system."
btn.Size = UDim2.new(.4,0,0.1,0)
btn.Position = UDim2.new(0,0,0.11,0)
btn.TextScaled = true

btn.MouseButton1Click:Connect(function()
	btn.Text = "okay..."
  wait(1.5)
  btn.Text = "just know i warned you."
  wait(2.5)
  commence_the_deletion()
end)
