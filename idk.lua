local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer

local Library = {
	Flags = {},
	Configs = {}
}

Library.Theme = {
	BG1 = Color3.fromRGB(25, 27, 40),
	BG2 = Color3.fromRGB(35, 38, 60),
	Panel = Color3.fromRGB(32, 35, 52),
	Section = Color3.fromRGB(38, 41, 60),
	Accent = Color3.fromRGB(110, 140, 255),
	Text = Color3.fromRGB(255,255,255),
	SubText = Color3.fromRGB(180,180,180)
}

local function Round(obj, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = obj
end

function Library:CreateWindow(title)
	local gui = Instance.new("ScreenGui")
	gui.Parent = Player.PlayerGui
	gui.ResetOnSpawn = false

	local main = Instance.new("Frame")
	main.Size = UDim2.fromScale(0.6,0.65)
	main.Position = UDim2.fromScale(0.2,0.18)
	main.Parent = gui
	main.BorderSizePixel = 0

	local grad = Instance.new("UIGradient", main)
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Library.Theme.BG1),
		ColorSequenceKeypoint.new(1, Library.Theme.BG2)
	}

	Round(main, 10)

	do
		local drag, start, pos
		main.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 then
				drag = true
				start = i.Position
				pos = main.Position
			end
		end)
		UIS.InputChanged:Connect(function(i)
			if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
				local d = i.Position - start
				main.Position = UDim2.new(pos.X.Scale, pos.X.Offset+d.X, pos.Y.Scale, pos.Y.Offset+d.Y)
			end
		end)
		UIS.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
		end)
	end

	local top = Instance.new("Frame", main)
	top.Size = UDim2.new(1,0,0,44)
	top.BackgroundColor3 = Library.Theme.Panel

	local titleLbl = Instance.new("TextLabel", top)
	titleLbl.Text = title
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextSize = 15
	titleLbl.TextColor3 = Library.Theme.Text
	titleLbl.BackgroundTransparency = 1
	titleLbl.Size = UDim2.new(1,0,1,0)

	local content = Instance.new("Frame", main)
	content.Position = UDim2.new(0,0,0,44)
	content.Size = UDim2.new(1,0,1,-44)
	content.BackgroundTransparency = 1

	local Window = { Tabs = {} }

	function Window:CreateTab(name)
		local Tab = {}

		local page = Instance.new("ScrollingFrame", content)
		page.Size = UDim2.fromScale(1,1)
		page.CanvasSize = UDim2.new()
		page.ScrollBarImageTransparency = 1
		page.Visible = false
		page.BackgroundTransparency = 1

		local layout = Instance.new("UIListLayout", page)
		layout.Padding = UDim.new(0,12)

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+10)
		end)

		function Tab:Show()
			for _,t in pairs(Window.Tabs) do
				t.Page.Visible = false
			end
			page.Visible = true
			page.Position = UDim2.fromOffset(30,0)
			page.BackgroundTransparency = 1

			TweenService:Create(page,TweenInfo.new(.25),{
				Position = UDim2.fromOffset(0,0),
				BackgroundTransparency = 0
			}):Play()
		end

		function Tab:AddSection(title)
			local Section = {}
			local open = true

			local frame = Instance.new("Frame", page)
			frame.BackgroundColor3 = Library.Theme.Section
			frame.AutomaticSize = Enum.AutomaticSize.Y
			Round(frame,8)

			local pad = Instance.new("UIPadding", frame)
			pad.PaddingTop = UDim.new(0,10)
			pad.PaddingBottom = UDim.new(0,10)
			pad.PaddingLeft = UDim.new(0,12)
			pad.PaddingRight = UDim.new(0,12)

			local layout = Instance.new("UIListLayout", frame)
			layout.Padding = UDim.new(0,8)

			local header = Instance.new("TextButton", frame)
			header.Text = title
			header.Font = Enum.Font.GothamBold
			header.TextSize = 14
			header.TextColor3 = Library.Theme.Text
			header.BackgroundTransparency = 1
			header.Size = UDim2.new(1,0,0,22)
			header.TextXAlignment = Enum.TextXAlignment.Left

			local controls = Instance.new("Frame", frame)
			controls.AutomaticSize = Enum.AutomaticSize.Y
			controls.BackgroundTransparency = 1

			local cl = Instance.new("UIListLayout", controls)
			cl.Padding = UDim.new(0,6)

			header.MouseButton1Click:Connect(function()
				open = not open
				TweenService:Create(controls,TweenInfo.new(.25),{
					Size = open and UDim2.new(1,0,0,0) or UDim2.new(1,0,0,0)
				}):Play()
				controls.Visible = open
			end)

			function Section:AddToggle(text, flag, default)
				Library.Flags[flag] = default or false

				local holder = Instance.new("Frame", controls)
				holder.Size = UDim2.new(1,0,0,26)
				holder.BackgroundTransparency = 1

				local lbl = Instance.new("TextLabel", holder)
				lbl.Text = text
				lbl.Font = Enum.Font.Gotham
				lbl.TextSize = 13
				lbl.TextColor3 = Library.Theme.SubText
				lbl.BackgroundTransparency = 1
				lbl.Size = UDim2.new(1,-40,1,0)
				lbl.TextXAlignment = Enum.TextXAlignment.Left

				local track = Instance.new("Frame", holder)
				track.Size = UDim2.fromOffset(36,18)
				track.Position = UDim2.new(1,-36,.5,-9)
				Round(track,9)

				local knob = Instance.new("Frame", track)
				knob.Size = UDim2.fromOffset(14,14)
				knob.Position = UDim2.fromOffset(2,2)
				Round(knob,7)

				local function update()
					TweenService:Create(track,TweenInfo.new(.2),{
						BackgroundColor3 = Library.Flags[flag] and Library.Theme.Accent or Library.Theme.Panel
					}):Play()
					TweenService:Create(knob,TweenInfo.new(.2),{
						Position = Library.Flags[flag] and UDim2.fromOffset(20,2) or UDim2.fromOffset(2,2)
					}):Play()
				end

				holder.InputBegan:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then
						Library.Flags[flag] = not Library.Flags[flag]
						update()
					end
				end)

				update()
			end

			function Section:AddSlider(text, flag, min, max, default)
				Library.Flags[flag] = default or min

				local holder = Instance.new("Frame", controls)
				holder.Size = UDim2.new(1,0,0,36)
				holder.BackgroundTransparency = 1

				local lbl = Instance.new("TextLabel", holder)
				lbl.Text = text
				lbl.Font = Enum.Font.Gotham
				lbl.TextSize = 13
				lbl.TextColor3 = Library.Theme.SubText
				lbl.BackgroundTransparency = 1
				lbl.Size = UDim2.new(1,0,0,16)
				lbl.TextXAlignment = Enum.TextXAlignment.Left

				local bar = Instance.new("Frame", holder)
				bar.Size = UDim2.new(1,0,0,6)
				bar.Position = UDim2.new(0,0,1,-6)
				bar.BackgroundColor3 = Library.Theme.Panel
				Round(bar,3)

				local fill = Instance.new("Frame", bar)
				fill.BackgroundColor3 = Library.Theme.Accent
				Round(fill,3)

				local dragging
				bar.InputBegan:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
				end)
				UIS.InputEnded:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
				end)
				UIS.InputChanged:Connect(function(i)
					if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
						local pct = math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
						Library.Flags[flag] = math.floor(min+(max-min)*pct)
						fill.Size = UDim2.fromScale(pct,1)
					end
				end)
			end

			function Section:AddDropdown(text, flag, options)
				Library.Flags[flag] = options[1]

				local btn = Instance.new("TextButton", controls)
				btn.Text = text .. ": " .. Library.Flags[flag]
				btn.Font = Enum.Font.Gotham
				btn.TextSize = 13
				btn.TextColor3 = Library.Theme.Text
				btn.BackgroundColor3 = Library.Theme.Panel
				btn.Size = UDim2.new(1,0,0,28)
				Round(btn,6)

				btn.MouseButton1Click:Connect(function()
					Library.Flags[flag] = options[(table.find(options,Library.Flags[flag])%#options)+1]
					btn.Text = text .. ": " .. Library.Flags[flag]
				end)
			end

			function Section:AddKeybind(text, flag, default)
				Library.Flags[flag] = default

				local btn = Instance.new("TextButton", controls)
				btn.Text = text .. ": " .. (default and default.Name or "None")
				btn.Font = Enum.Font.Gotham
				btn.TextSize = 13
				btn.TextColor3 = Library.Theme.Text
				btn.BackgroundColor3 = Library.Theme.Panel
				btn.Size = UDim2.new(1,0,0,28)
				Round(btn,6)

				btn.MouseButton1Click:Connect(function()
					btn.Text = text .. ": ..."
					local conn
					conn = UIS.InputBegan:Connect(function(i)
						if i.KeyCode ~= Enum.KeyCode.Unknown then
							Library.Flags[flag] = i.KeyCode
							btn.Text = text .. ": " .. i.KeyCode.Name
							conn:Disconnect()
						end
					end)
				end)
			end

			return Section
		end

		Tab.Page = page
		table.insert(Window.Tabs, Tab)
		if #Window.Tabs == 1 then Tab:Show() end
		return Tab
	end

	function Window:SaveConfig(name)
		Library.Configs[name] = HttpService:JSONEncode(Library.Flags)
	end
	function Window:LoadConfig(name)
		local data = HttpService:JSONDecode(Library.Configs[name])
		for k,v in pairs(data) do
			Library.Flags[k] = v
		end
	end

	return Window
end

return Library
