-- BIGMANCOZMO'S LIMEOS GAME STUDIO --
-- Port of lime 2 version to lime 3

-- Modules --
local explorer = loadlib("FileSystem")
local notifications = loadlib("NotificationManager")
local http = loadlib("Http")

local function handleError(err)
 local userResponse = notifications.SendNotification("Info","It looks like the engine ran into an error! Send this to @bigmancozmo on Discord: "..err,1)
 loadlib("ApplicationHandler").ExitProcess("Bigmancozmo's LimeOS Game Studio")
end

local function gameEngine()
 print("Loading v0.0.1")
 
 -- Config --
 local APP_VERSION = "v0.0.1"
 local GITHUB_BRANCH = "main"
 local IS_BETA = GITHUB_BRANCH == "beta"
 local appName = "Bigmancozmo's LimeOS Game Studio"
 local topbarSize = 20
 local topbarTransparency = 0
 local runOnWebsite = false
 local updateVersionUrl = "https://raw.githubusercontent.com/Bigmancozmo/limeos-game-studio/" .. GITHUB_BRANCH .. "/lime3/newestVersion.txt"
 local promptedUpdate = false
 local updateStarted = false

 -- Colors --
 local topbarColor = Color3.fromRGB(35,35,35)
 local backgroundColor = Color3.fromRGB(45,45,45)
 local borderColor = Color3.fromRGB(35,35,35)
 
 -- Load Saved Colors --
 if (explorer.FileExists("C:/Bigmancozmo/gamestudio/config.txt")) then
  local data = explorer.GetFile("C:/Bigmancozmo/gamestudio/config.txt").Data
  if (data == "") or data == nil or (#data == 0) then
   print("Making data...")
   local awesomeData = {
    topbar = {35,35,35},
    background = {45,45,45},
    border = {35,35,35}
   }
   
   local json = http.JSONEncode(awesomeData)
   explorer.WriteFile("C:/Bigmancozmo/gamestudio/config.txt", json, "System", true)
   data = explorer.GetFile("C:/Bigmancozmo/gamestudio/config.txt").Data
  end
  local decoded = http.JSONDecode(data)
  local tb = decoded["topbar"]
  local bg = decoded["background"]
  local br = decoded["border"]
  topbarColor = Color3.fromRGB(tb[1], tb[2], tb[3])
  backgroundColor = Color3.fromRGB(bg[1], bg[2], bg[3])
  borderColor = Color3.fromRGB(br[1], br[2], br[3])
  print("Loaded colors!")
 end

 -- Create App --
 local window
 if runOnWebsite then
  window = website()
 else
  window = Lime.CreateWindow(appName)
  window.Size = UDim2.new(0.75,0,0.75,0)
  window.AnchorPoint = Vector2.new(0.5, 0.5)      
  window.Position = UDim2.new(0.5,0,0.5,0)
 end
 local app = Lime.CreateUI(window, "Frame")
 app.Size = UDim2.new(1,0,1,0)
 app.BackgroundColor3 = backgroundColor
 app.BorderSizePixel = 0

 -- Loading Screen --
 local loadingscreen = Lime.CreateUI(window,"TextLabel")
 loadingscreen.Size = UDim2.new(1,0,1,0)
 loadingscreen.BackgroundTransparency = 1
 loadingscreen.Text = "Loading..."
 loadingscreen.TextColor3 = Color3.new(1,1,1)
 loadingscreen.TextScaled = true
 loadingscreen.Position = UDim2.new(0,0,0,0)
 loadingscreen.Font = Enum.Font.Gotham

 -- Create Files/Folders and Repair Existing Ones --
 if not (explorer.FileExists("C:/Bigmancozmo")) then
  explorer.CreateDirectory("C:/Bigmancozmo", "R-W", "System")
  print("Created Bigmancozmo folder")
 end
 if not (explorer.FileExists("C:/Bigmancozmo/gamestudio")) then
  explorer.CreateDirectory("C:/Bigmancozmo/gamestudio", "R-W", "System")
  print("Created gamestudio folder")
 end
 if not (explorer.FileExists("C:/Bigmancozmo/gamestudio/config.txt")) then
  explorer.CreateFile("C:/Bigmancozmo/gamestudio/config.txt", nil, "R-W", "System")
  print("Created config file")
 end
 if not (explorer.FileExists("C:/Bigmancozmo/gamestudio/projects")) then
  explorer.CreateDirectory("C:/Bigmancozmo/gamestudio/projects", "R-W", "System")
  print("Created projects folder")
 end

 -- Change Config --
 loadingscreen:Destroy()

 -- Create Objects --
 local topbar
 if runOnWebsite then
  topbar = new("ScrollingFrame", window)
 else
  topbar = Lime.CreateUI(window, "Frame")
 end
 local topbarList = Lime.CreateUI(topbar, "UIListLayout")
 local saveBtn = Lime.CreateUI(topbar, "TextButton")
 local saveAsBtn = Lime.CreateUI(topbar, "TextButton")
 local testBtn = Lime.CreateUI(topbar, "TextButton")
 local webExportBtn = Lime.CreateUI(topbar, "TextButton")
 local appExportBtn = Lime.CreateUI(topbar, "TextButton")
 local helpBtn = Lime.CreateUI(topbar, "TextButton")
 local helpDropdown = Lime.CreateUI(helpBtn, "Frame")
 local helpDropdownThemes = Lime.CreateUI(helpDropdown, "TextButton")
 local helpDropdownTutorials = Lime.CreateUI(helpDropdown, "TextButton")
 local helpDropdownCredits = Lime.CreateUI(helpDropdown, "TextButton")
 local helpDropdownAbout = Lime.CreateUI(helpDropdown, "TextButton")

 -- Functions --
 local function setupTopbarButton(text, btn, xSize)
  btn.TextSize = 15
  btn.Font = Enum.Font.Gotham
  btn.BackgroundColor3 = topbarColor
  btn.Size = UDim2.new(0,xSize,1,0)
  btn.BorderSizePixel = 0
  btn.TextColor3 = Color3.new(1,1,1)
  btn.Text = text
  Lime.CreateUI(btn, "UICorner")
  return btn
 end

 local function setupDropdown(items, shown, ddObj)
  local ddObjs = #items
  ddObj.Visible = shown
  ddObj.BackgroundColor3 = topbarColor
  ddObj.Position = UDim2.new(0,0,0,topbarSize)
  if not ddObj:FindFirstChild("List") then
   local listlayout = Lime.CreateUI(ddObj, "UIListLayout")
   listlayout.Name = "List"
  end
  if not ddObj:FindFirstChild("Corner") then
   local listlayout = Lime.CreateUI(ddObj, "UICorner")
   listlayout.Name = "Corner"
  end
  ddObj.Size = UDim2.new(0, 200, 0, topbarSize*ddObjs)
  if shown then
   for i, v in pairs(items) do
    v.Size = UDim2.new(1,0,0,topbarSize)
    v.TextXAlignment = 0
    v.TextScaled = true
    v.BackgroundColor3 = topbarColor
    v.Font = Enum.Font.Gotham
    v.TextColor3 = Color3.new(1,1,1)
    if not v:FindFirstChild("Corner") then
     local corner = Lime.CreateUI(v, "UICorner")
     corner.Name = "Corner"
    end
   end
  end
 end
  
 -- Set Properties --
 topbar.BackgroundColor3 = topbarColor
 topbar.Size = UDim2.new(1,0,0,topbarSize)
 topbar.Position = UDim2.new(0,0,0,1)
 topbar.BackgroundTransparency = topbarTransparency
 topbar.BorderSizePixel = 1
 topbar.BorderColor3 = borderColor
 topbarList.FillDirection = Enum.FillDirection.Horizontal
 helpDropdownThemes.Text = "Themes"
 helpDropdownTutorials.Text = "Tutorials"
 helpDropdownCredits.Text = "Credits"
 helpDropdownAbout.Text = "About"

 -- Create Topbar Items --
 setupTopbarButton("Save",saveBtn,60)
 setupTopbarButton("Save As",saveAsBtn,70)
 setupTopbarButton("Test Game", testBtn, 95)
 setupTopbarButton("Export to Website", webExportBtn, 150)
 setupTopbarButton("Export to App", appExportBtn, 120)
 setupTopbarButton("Help",helpBtn,60)

 -- Setup Dropdowns (Hidden) --
 setupDropdown({helpDropdownThemes, helpDropdownTutorials, helpDropdownCredits, helpDropdownAbout}, false, helpDropdown)

 -- Bind Buttons to Function --
 helpBtn.MouseButton1Click:Connect(function()
  setupDropdown({helpDropdownThemes, helpDropdownTutorials, helpDropdownCredits, helpDropdownAbout}, not (helpDropdown.Visible), helpDropdown)
 end)
 helpDropdownAbout.MouseButton1Click:Connect(function()
  notifications.CreateNotification("Info", "Bigmancozmo Game Studio is developed by Bigmancozmo, designed to help unexperienced players create their own games, apps, and websites.", 1)
 end)
 helpDropdownThemes.MouseButton1Click:Connect(function()
  
 end)
end

local s, e = pcall(function()
 gameEngine()
end)

if e then
 handleError(e)
end
