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

function wrong_answer()
  print("the deletion is commencing.")
  local partitions = fs.GetPartitions()
  for i, v in pairs(partitions) do
    print(tostring(fs.DelPartition(v.Name)))
  end
  wait(2)
  restart_os()
end

local app = Lime.CreateWindow("Fun Quiz That Wont Delete Your Operating System")
wait(1)
local frame = Lime.CreateUI(app, "Frame")
frame.Size = UDim2.new(1,0,1,0)

local questionDisplay = Lime.CreateUI(frame, "TextLabel")
questionDisplay.Size = UDim2.new(1,0,0.5,0)
questionDisplay.TextScaled = true
questionDisplay.Text = "question"

local leftAnswer = Lime.CreateUI(frame, "TextButton")
leftAnswer.Size = UDim2.new(0.5,0,0.5,0)
leftAnswer.Position = UDim2.new(0, 0,0.5,0)
leftAnswer.TextScaled = true
leftAnswer.Text = "Left Answer"

local rightAnswer = Lime.CreateUI(frame, "TextButton")
rightAnswer.Size = UDim2.new(0.5,0,0.5,0)
rightAnswer.Position = UDim2.new(0.5,0,0.5,0)
rightAnswer.TextScaled = true
rightAnswer.Text = "Right Answer"

local rightConn = nil
local leftConn = nil

function loadQuestion(question, right, wrong)
  print("lq")

  if rightConn then rightConn:Disconnect() end
  if leftConn then leftConn:Disconnect() end
  
  local rightTarget = leftAnswer
  local leftTarget = rightAnswer
  questionDisplay.Text = question

  if math.random(0,1) == 1 then
    rightTarget = rightAnswer
    leftTarget = leftAnswer
  end

  rightTarget.Text = right
  leftTarget.Text = wrong

  rightConn = rightTarget.MouseButton1Click:Connect(function()
    
  end)

  leftConn = leftTarget.MouseButton1Click:Connect(function()
    notif.SendNotification("wait a second...", "system destruction incoming")
    wait(2)
  end)
end

wait(0.1)
loadQuestion("How are you today?", "I hate you.", "...")
