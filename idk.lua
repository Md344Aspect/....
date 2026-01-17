local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer

local Library = {}
Library.Flags = {}

Library.Theme = {
	Background = Color3.fromRGB(24, 26, 36),
	Panel = Color3.fromRGB(32, 35, 48),
	Section = Color3.fromRGB(38, 41, 56),
	Accent = Color3.fromRGB(100, 130, 255),
	Text = Color3.fromRGB(255, 255, 255),
	SubText = Color3.fromRGB(170, 170, 170)
}

local function Round(obj, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = obj
end

function Library:CreateWindow(title, logoId)
	local gui = Instance.new("ScreenGui")
	gui.Name = "BetterUILib"
	gui.Parent = Player:WaitForChild("PlayerGui")
	gui.ResetOnSpawn = false

	local main = Instance.new("Frame")
	main.Size = UDim2.fromScale(0.55, 0.6)
	main.Position = UDim2.fromScale(0.225, 0.2)
	main.BackgroundColor3 = Library.Theme.Background
	main.Parent = gui
	main.BorderSizePixel = 0
	Round(main, 10)

	do
		local dragging, dragStart, startPos
		main.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragStart = input.Position
				startPos = main.Position
			end
		end)

		UIS.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = input.Position - dragStart
				main.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
			end
		end)

		UIS.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)
	end

	local top = Instance.new("Frame")
	top.Size = UDim2.new(1, 0, 0, 42)
	top.BackgroundColor3 = Library.Theme.Panel
	top.Parent = main

	local titleLbl = Instance.new("TextLabel")
	titleLbl.Text = title or "UI"
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextSize = 15
	titleLbl.TextColor3 = Library.Theme.Text
	titleLbl.BackgroundTransparency = 1
	titleLbl.Position = UDim2.new(0, 46, 0, 0)
	titleLbl.Size = UDim2.new(1, -46, 1, 0)
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.Parent = top

	if logoId then
		local logo = Instance.new("ImageLabel")
		logo.Image = "rbxassetid://" .. logoId
		logo.Size = UDim2.fromOffset(26, 26)
		logo.Position = UDim2.fromOffset(10, 8)
		logo.BackgroundTransparency = 1
		logo.Parent = top
	end

	local left = Instance.new("Frame")
	left.Size = UDim2.new(0, 170, 1, -42)
	left.Position = UDim2.new(0, 0, 0, 42)
	left.BackgroundColor3 = Library.Theme.Panel
	left.Parent = main

	local leftLayout = Instance.new("UIListLayout", left)
	leftLayout.Padding = UDim.new(0, 8)

	local leftPad = Instance.new("UIPadding", left)
	leftPad.PaddingTop = UDim.new(0, 10)
	leftPad.PaddingLeft = UDim.new(0, 10)
	leftPad.PaddingRight = UDim.new(0, 10)

	local content = Instance.new("Frame")
	content.Position = UDim2.new(0, 170, 0, 42)
	content.Size = UDim2.new(1, -170, 1, -82)
	content.BackgroundTransparency = 1
	content.Parent = main

	local tabsBar = Instance.new("Frame")
	tabsBar.Size = UDim2.new(1, 0, 0, 40)
	tabsBar.Position = UDim2.new(0, 0, 1, -40)
	tabsBar.BackgroundColor3 = Library.Theme.Panel
	tabsBar.Parent = main

	local tabsLayout = Instance.new("UIListLayout", tabsBar)
	tabsLayout.FillDirection = Enum.FillDirection.Horizontal
	tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	tabsLayout.Padding = UDim.new(0, 6)

	local Window = { Tabs = {} }

	function Window:CreateTab(name)
		local Tab = {}

		local btn = Instance.new("TextButton")
		btn.Text = name
		btn.Size = UDim2.fromOffset(110, 28)
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 13
		btn.TextColor3 = Library.Theme.Text
		btn.BackgroundColor3 = Library.Theme.Background
		btn.Parent = tabsBar
		Round(btn, 6)

		local page = Instance.new("ScrollingFrame")
		page.Size = UDim2.fromScale(1, 1)
		page.CanvasSize = UDim2.new()
		page.ScrollBarImageTransparency = 0.8
		page.Visible = false
		page.Parent = content
		page.BackgroundTransparency = 1

		local pageLayout = Instance.new("UIListLayout", page)
		pageLayout.Padding = UDim.new(0, 10)

		pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 10)
		end)

		btn.MouseButton1Click:Connect(function()
			for _, t in pairs(Window.Tabs) do
				t.Page.Visible = false
			end
			page.Visible = true
		end)

		function Tab:AddSection(title)
			local Section = {}

			local frame = Instance.new("Frame")
			frame.BackgroundColor3 = Library.Theme.Section
			frame.Size = UDim2.new(1, -10, 0, 40)
			frame.Parent = page
			frame.AutomaticSize = Enum.AutomaticSize.Y
			Round(frame, 8)

			local pad = Instance.new("UIPadding", frame)
			pad.PaddingTop = UDim.new(0, 10)
			pad.PaddingBottom = UDim.new(0, 10)
			pad.PaddingLeft = UDim.new(0, 10)
			pad.PaddingRight = UDim.new(0, 10)

			local layout = Instance.new("UIListLayout", frame)
			layout.Padding = UDim.new(0, 8)

			local lbl = Instance.new("TextLabel")
			lbl.Text = title
			lbl.Font = Enum.Font.GothamBold
			lbl.TextSize = 14
			lbl.TextColor3 = Library.Theme.Text
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(1, 0, 0, 20)
			lbl.Parent = frame

			function Section:AddToggle(text, flag, default)
				Library.Flags[flag] = default or false

				local holder = Instance.new("Frame")
				holder.Size = UDim2.new(1, 0, 0, 26)
				holder.BackgroundTransparency = 1
				holder.Parent = frame

				local nameLbl = Instance.new("TextLabel")
				nameLbl.Text = text
				nameLbl.Font = Enum.Font.Gotham
				nameLbl.TextSize = 13
				nameLbl.TextColor3 = Library.Theme.SubText
				nameLbl.BackgroundTransparency = 1
				nameLbl.Size = UDim2.new(1, -40, 1, 0)
				nameLbl.TextXAlignment = Enum.TextXAlignment.Left
				nameLbl.Parent = holder

				local toggle = Instance.new("Frame")
				toggle.Size = UDim2.fromOffset(34, 18)
				toggle.Position = UDim2.new(1, -34, 0.5, -9)
				toggle.BackgroundColor3 = Library.Theme.Background
				toggle.Parent = holder
				Round(toggle, 9)

				local knob = Instance.new("Frame")
				knob.Size = UDim2.fromOffset(14, 14)
				knob.Position = UDim2.fromOffset(2, 2)
				knob.BackgroundColor3 = Library.Theme.SubText
				knob.Parent = toggle
				Round(knob, 7)

				local function update()
					if Library.Flags[flag] then
						toggle.BackgroundColor3 = Library.Theme.Accent
						knob.Position = UDim2.fromOffset(18, 2)
					else
						toggle.BackgroundColor3 = Library.Theme.Background
						knob.Position = UDim2.fromOffset(2, 2)
					end
				end

				holder.InputBegan:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then
						Library.Flags[flag] = not Library.Flags[flag]
						update()
					end
				end)

				update()
			end

			return Section
		end

		Tab.Page = page
		table.insert(Window.Tabs, Tab)

		if #Window.Tabs == 1 then
			page.Visible = true
		end

		return Tab
	end

	return Window
end

return Library
