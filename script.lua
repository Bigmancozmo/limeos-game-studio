-- BIGMANCOZMO'S LIMEOS GAME STUDIO --
print("Loading v0.0.8")

-- Config --
local APP_VERSION = "v0.0.8"
local GITHUB_BRANCH = "main"
local IS_BETA = GITHUB_BRANCH == "beta"
local appName = "Bigmancozmo's LimeOS Game Studio"
local topbarSize = 20
local topbarTransparency = 0
local runOnWebsite = false
local updateVersionUrl = "https://raw.githubusercontent.com/Bigmancozmo/limeos-game-studio/" .. GITHUB_BRANCH .. "/newestVersion.txt"
local promptedUpdate = false
local updateStarted = false

-- Colors --
local topbarColor = Color3.fromRGB(35,35,35)
local backgroundColor = Color3.fromRGB(45,45,45)
local borderColor = Color3.fromRGB(35,35,35)

-- Modules --
local explorer = loadlib("LimeExplorer")
local notifications = loadlib("LimeNotifications")

-- Create App --
local window
if runOnWebsite then
 window = website()
else
 window = createapp(appName, 10383211306)
 window.Parent.Size = UDim2.new(1,0,1,0)
end
local app = new("Frame", window)
app.Size = UDim2.new(1,0,1,0)
app.BackgroundColor3 = backgroundColor
app.BorderSizePixel = 0

-- Loading Screen --
local loadingscreen = new("TextLabel",window)
loadingscreen.Size = UDim2.new(1,0,1,0)
loadingscreen.BackgroundTransparency = 1
loadingscreen.Text = "Loading..."
loadingscreen.TextColor3 = Color3.new(1,1,1)
loadingscreen.TextScaled = true
loadingscreen.Position = UDim2.new(0,0,0,0)
loadingscreen.Font = Enum.Font.Gotham

-- Create Files/Folders and Repair Existing Ones --
if not (explorer.FileExists("Bigmancozmo:")) then
 explorer.CreateDrive("Bigmancozmo")
 print("Created Bigmancozmo drive")
end
if not (explorer.FileExists("Bigmancozmo:/gamestudio")) then
 mkdir("Bigmancozmo:/gamestudio")
 print("Created gamestudio folder")
end
if not (explorer.FileExists("Bigmancozmo:/gamestudio/config.txt")) then
 mkfile("Bigmancozmo:/gamestudio/config.txt")
 print("Created config file")
end
if not (explorer.FileExists("Bigmancozmo:/gamestudio/projects")) then
 mkdir("Bigmancozmo:/gamestudio/projects")
 print("Created projects folder")
end

-- Change Config --
loadingscreen:Destroy()

-- Create Objects --
local topbar
if runOnWebsite then
 topbar = new("ScrollingFrame", window)
else
 topbar = new("Frame", window)
end
local topbarList = new("UIListLayout", topbar)
local saveBtn = new("TextButton", topbar)
local saveAsBtn = new("TextButton", topbar)
local testBtn = new("TextButton", topbar)
local webExportBtn = new("TextButton", topbar)
local appExportBtn = new("TextButton", topbar)
local helpBtn = new("TextButton", topbar)
local helpDropdown = new("Frame", helpBtn)
local helpDropdownThemes = new("TextButton", helpDropdown)
local helpDropdownTutorials = new("TextButton", helpDropdown)
local helpDropdownCredits = new("TextButton", helpDropdown)
local helpDropdownAbout = new("TextButton", helpDropdown)

-- Functions --
function setupTopbarButton(text, btn, xSize)
 btn.TextSize = 15
 btn.Font = Enum.Font.Gotham
 btn.BackgroundColor3 = topbarColor
 btn.Size = UDim2.new(0,xSize,1,0)
 btn.BorderSizePixel = 0
 btn.TextColor3 = Color3.new(1,1,1)
 btn.Text = text
 new("UICorner", btn)
 return btn
end

function setupDropdown(items, shown, ddObj)
 local ddObjs = #items
 ddObj.Visible = shown
 ddObj.BackgroundColor3 = topbarColor
 ddObj.Position = UDim2.new(0,0,0,topbarSize)
 if not ddObj:FindFirstChild("List") then
  local listlayout = new("UIListLayout", ddObj)
  listlayout.Name = "List"
 end
 if not ddObj:FindFirstChild("Corner") then
  local listlayout = new("UICorner", ddObj)
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
    local corner = new("UICorner", v)
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
 notifications.CreateNotification("Info", "Bigmancozmo Game Studio is developed by Bigmancozmo, with help from PaleNoobs, designed to help unexperienced players create their own games, apps, and websites.", 1)
end)

-- Auto-Update --
if not runOnWebsite then
 while not updateStarted do -- created with help from palenoobs
  if window == uifolder() then
   updateStarted = true
   print("closing...")
  end
  local ver = HttpGet(updateVersionUrl)
  print(ver)
  if APP_VERSION.."\n" ~= ver and promptedUpdate == false then
   local str2 = string.gsub(string.gsub(ver, "%.", ""), "%v", "")
   local num2 = tonumber(str2)
   local str1 = string.gsub(string.gsub(APP_VERSION, "%.", ""), "%v", "")
   local num1 = tonumber(str1)
   if num1 < num2 then
    print("Update Available!")
    local userResponse = notifications.CreateNotification("Info","Update Found! Restart App?",2)
    promptedUpdate = true
    if userResponse == 2 then
     updateStarted = true
     loadlib("LimeAppFramework").CloseProcess(appName)
     loadlib("Loadstring")(HttpGet("https://raw.githubusercontent.com/Bigmancozmo/limeos-game-studio/"..GITHUB_BRANCH.."/script.lua"), getfenv())()
    end
   end
  end
  wait(30)
 end
 loadlib("LimeAppFramework").CloseProcess(appName)
end
