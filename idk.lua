local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer

local Library = {}
Library.Flags = {}
Library.Configs = {}

Library.Theme = {
	Background = Color3.fromRGB(30, 32, 45),
	Panel = Color3.fromRGB(40, 42, 60),
	Accent = Color3.fromRGB(90, 120, 255),
	Text = Color3.fromRGB(255, 255, 255),
	SubText = Color3.fromRGB(180, 180, 180)
}

function Library:CreateWindow(title, logoId)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "lib"
	ScreenGui.Parent = Player:WaitForChild("PlayerGui")
	ScreenGui.ResetOnSpawn = false

	local Main = Instance.new("Frame")
	Main.Size = UDim2.fromScale(0.55, 0.6)
	Main.Position = UDim2.fromScale(0.225, 0.2)
	Main.BackgroundColor3 = Library.Theme.Background
	Main.Parent = ScreenGui
	Main.BorderSizePixel = 0

	local UICorner = Instance.new("UICorner", Main)
	UICorner.CornerRadius = UDim.new(0, 10)

	local Top = Instance.new("Frame")
	Top.Size = UDim2.new(1, 0, 0, 40)
	Top.BackgroundColor3 = Library.Theme.Panel
	Top.Parent = Main

	local Title = Instance.new("TextLabel")
	Title.Text = title or "UI Library"
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 16
	Title.TextColor3 = Library.Theme.Text
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 50, 0, 0)
	Title.Size = UDim2.new(1, -50, 1, 0)
	Title.TextXAlignment = Left
	Title.Parent = Top

	if logoId then
		local Logo = Instance.new("ImageLabel")
		Logo.Image = "rbxassetid://" .. logoId
		Logo.Size = UDim2.fromOffset(28, 28)
		Logo.Position = UDim2.fromOffset(10, 6)
		Logo.BackgroundTransparency = 1
		Logo.Parent = Top
	end

	local Left = Instance.new("Frame")
	Left.Size = UDim2.new(0, 160, 1, -40)
	Left.Position = UDim2.new(0, 0, 0, 40)
	Left.BackgroundColor3 = Library.Theme.Panel
	Left.Parent = Main

	local UIList = Instance.new("UIListLayout", Left)
	UIList.Padding = UDim.new(0, 6)

	local Padding = Instance.new("UIPadding", Left)
	Padding.PaddingTop = UDim.new(0, 10)
	Padding.PaddingLeft = UDim.new(0, 10)
	Padding.PaddingRight = UDim.new(0, 10)

	local Content = Instance.new("Frame")
	Content.Position = UDim2.new(0, 160, 0, 40)
	Content.Size = UDim2.new(1, -160, 1, -80)
	Content.BackgroundTransparency = 1
	Content.Parent = Main

	local TabsBar = Instance.new("Frame")
	TabsBar.Size = UDim2.new(1, 0, 0, 40)
	TabsBar.Position = UDim2.new(0, 0, 1, -40)
	TabsBar.BackgroundColor3 = Library.Theme.Panel
	TabsBar.Parent = Main

	local TabsLayout = Instance.new("UIListLayout", TabsBar)
	TabsLayout.FillDirection = Horizontal
	TabsLayout.Padding = UDim.new(0, 6)
	TabsLayout.HorizontalAlignment = Center
	TabsLayout.VerticalAlignment = Center

	local Window = {}
	Window.Tabs = {}

	local function CreateLeftButton(text, callback)
		local Btn = Instance.new("TextButton")
		Btn.Text = text
		Btn.Font = Enum.Font.Gotham
		Btn.TextSize = 14
		Btn.TextColor3 = Library.Theme.Text
		Btn.BackgroundColor3 = Library.Theme.Background
		Btn.Size = UDim2.new(1, 0, 0, 32)
		Btn.Parent = Left

		local C = Instance.new("UICorner", Btn)
		C.CornerRadius = UDim.new(0, 6)

		Btn.MouseButton1Click:Connect(callback)
	end

	CreateLeftButton("Save Config", function()
		print("Config Saved (example)")
	end)

	CreateLeftButton("Load Config", function()
		print("Config Loaded (example)")
	end)

	function Window:CreateTab(name)
		local Tab = {}
		local TabButton = Instance.new("TextButton")
		TabButton.Text = name
		TabButton.Font = Enum.Font.GothamBold
		TabButton.TextSize = 14
		TabButton.TextColor3 = Library.Theme.Text
		TabButton.BackgroundColor3 = Library.Theme.Background
		TabButton.Size = UDim2.fromOffset(110, 28)
		TabButton.Parent = TabsBar

		local TC = Instance.new("UICorner", TabButton)
		TC.CornerRadius = UDim.new(0, 6)

		local Page = Instance.new("ScrollingFrame")
		Page.Size = UDim2.fromScale(1, 1)
		Page.CanvasSize = UDim2.new(0, 0, 0, 0)
		Page.ScrollBarImageTransparency = 0.8
		Page.Visible = false
		Page.Parent = Content
		Page.BackgroundTransparency = 1

		local Layout = Instance.new("UIListLayout", Page)
		Layout.Padding = UDim.new(0, 8)

		Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Page.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
		end)

		TabButton.MouseButton1Click:Connect(function()
			for _, t in pairs(Window.Tabs) do
				t.Page.Visible = false
			end
			Page.Visible = true
		end)

		function Tab:AddToggle(text, flag, default)
			Library.Flags[flag] = default or false

			local Toggle = Instance.new("TextButton")
			Toggle.Text = text
			Toggle.Size = UDim2.new(1, -10, 0, 36)
			Toggle.BackgroundColor3 = Library.Theme.Panel
			Toggle.TextColor3 = Library.Theme.Text
			Toggle.Font = Enum.Font.Gotham
			Toggle.TextSize = 14
			Toggle.Parent = Page

			local C = Instance.new("UICorner", Toggle)

			local function Update()
				Toggle.BackgroundColor3 = Library.Flags[flag] and Library.Theme.Accent or Library.Theme.Panel
			end

			Toggle.MouseButton1Click:Connect(function()
				Library.Flags[flag] = not Library.Flags[flag]
				Update()
			end)

			Update()
		end

		function Tab:AddButton(text, callback)
			local Btn = Instance.new("TextButton")
			Btn.Text = text
			Btn.Size = UDim2.new(1, -10, 0, 36)
			Btn.BackgroundColor3 = Library.Theme.Panel
			Btn.TextColor3 = Library.Theme.Text
			Btn.Font = Enum.Font.Gotham
			Btn.TextSize = 14
			Btn.Parent = Page

			local C = Instance.new("UICorner", Btn)
			Btn.MouseButton1Click:Connect(callback)
		end

		Tab.Page = Page
		table.insert(Window.Tabs, Tab)

		if #Window.Tabs == 1 then
			Page.Visible = true
		end

		return Tab
	end

	return Window
end

return Library
