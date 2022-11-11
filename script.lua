-- BIGMANCOZMO'S LIMEOS GAME STUDIO --
print("Loading v0.0.3")

-- Config --
local appName = "Bigmancozmo's LimeOS Game Studio"
local topbarSize = 20
local topbarTransparency = 0
local runOnWebsite = false

-- Colors --
local topbarColor = Color3.fromRGB(35,35,35)
local backgroundColor = Color3.fromRGB(45,45,45)
local borderColor = Color3.fromRGB(35,35,35)

-- Modules --
local explorer = loadlib("LimeExplorer")

-- Create App --
local window
if runOnWebsite then
 window = website()
else
 window = createapp(appName, 10383211306)
 loadlib("LimeAppFramework").MaximizeApp("Bigmancozmo's LimeOS Game Studio")
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
local topbar = new("Frame", window)
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

function setupDropdown(items, shown, ddObj, ddObjs)
 ddObj.Visible = shown
 ddObj.Transparency = 1
 ddObj.Position = UDim2.new(0,0,0,topbarSize)
 if not ddObj:FindFirstChild("List") then
  local listlayout = new("UIListLayout", ddObj)
  listlayout.Name = "List"
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

-- Create Topbar Items --
setupTopbarButton("Save",saveBtn,60)
setupTopbarButton("Save As",saveAsBtn,70)
setupTopbarButton("Test Game", testBtn, 95)
setupTopbarButton("Export to Website", webExportBtn, 150)
setupTopbarButton("Export to App", appExportBtn, 120)
setupTopbarButton("Help",helpBtn,60)

-- Setup Dropdowns (Hidden) --
setupDropdown({helpDropdownThemes, helpDropdownTutorials, helpDropdownCredits}, false, helpDropdown, 2)

-- Bind Buttons to Function --
helpBtn.MouseButton1Click:Connect(function()
    setupDropdown({helpDropdownThemes, helpDropdownTutorials, helpDropdownCredits}, not (helpDropdown.Visible), helpDropdown, 2)
end)
