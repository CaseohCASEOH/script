local uilib = {}

local uis = game:GetService("UserInputService")
local tweenservice = game:GetService("TweenService")

-- Create main window
function uilib:CreateWindow(config)
	local screengui = Instance.new("ScreenGui", game:GetService("CoreGui"))
	screengui.IgnoreGuiInset = true
	screengui.ResetOnSpawn = false
	screengui.Name = config.Name or "UILib"
	screengui.DisplayOrder = 9999

	local window = Instance.new("Frame", screengui)
	window.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	window.BorderSizePixel = 0
	window.Size = UDim2.new(0, 600, 0, 350)
	window.Position = UDim2.new(0.5, -300, 0.5, -175)
	window.AnchorPoint = Vector2.new(0.5, 0.5)
	window.Active = true
	window.Draggable = false

	local uicorner = Instance.new("UICorner", window)
	uicorner.CornerRadius = UDim.new(0, 10)

	local topbar = Instance.new("Frame", window)
	topbar.Size = UDim2.new(1, 0, 0, 35)
	topbar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	topbar.BorderSizePixel = 0
	Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, 10)

	local title = Instance.new("TextLabel", topbar)
	title.Text = config.Title or "UI Library"
	title.Font = Enum.Font.GothamBold
	title.TextColor3 = Color3.new(1,1,1)
	title.TextSize = 16
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0, 10, 0, 0)
	title.Size = UDim2.new(1, -40, 1, 0)
	title.TextXAlignment = Enum.TextXAlignment.Left

	local close = Instance.new("TextButton", topbar)
	close.Text = "X"
	close.Font = Enum.Font.GothamBold
	close.TextColor3 = Color3.new(1,1,1)
	close.TextSize = 16
	close.Size = UDim2.new(0, 35, 1, 0)
	close.Position = UDim2.new(1, -35, 0, 0)
	close.BackgroundTransparency = 1
	close.MouseButton1Click:Connect(function()
		window.Visible = false
	end)

	local dragging = false
	local dragInput, dragStart, startPos

	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = window.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	uis.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	local tabHolder = Instance.new("Frame", window)
	tabHolder.Position = UDim2.new(0, 0, 0, 35)
	tabHolder.Size = UDim2.new(0, 150, 1, -35)
	tabHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	tabHolder.BorderSizePixel = 0

	local pages = Instance.new("Folder", window)
	pages.Name = "Pages"

	local layout = Instance.new("UIListLayout", tabHolder)
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	function uilib:CreateTab(name)
		local button = Instance.new("TextButton", tabHolder)
		button.Text = name
		button.Font = Enum.Font.Gotham
		button.TextColor3 = Color3.new(1,1,1)
		button.TextSize = 14
		button.Size = UDim2.new(1, 0, 0, 30)
		button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		button.BorderSizePixel = 0

		local page = Instance.new("ScrollingFrame", pages)
		page.Name = name
		page.Size = UDim2.new(1, -150, 1, -35)
		page.Position = UDim2.new(0, 150, 0, 35)
		page.BackgroundTransparency = 1
		page.BorderSizePixel = 0
		page.Visible = false
		page.ScrollBarThickness = 4
		page.CanvasSize = UDim2.new(0, 0, 0, 0)

		local pagelayout = Instance.new("UIListLayout", page)
		pagelayout.Padding = UDim.new(0, 6)
		pagelayout.SortOrder = Enum.SortOrder.LayoutOrder

		button.MouseButton1Click:Connect(function()
			for _, p in pairs(pages:GetChildren()) do
				if p:IsA("ScrollingFrame") then
					p.Visible = false
				end
			end
			page.Visible = true
		end)

		local tabapi = {}

		function tabapi:AddLabel(text)
			local lbl = Instance.new("TextLabel", page)
			lbl.Text = text
			lbl.Font = Enum.Font.Gotham
			lbl.TextColor3 = Color3.new(1,1,1)
			lbl.TextSize = 14
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(1, -10, 0, 20)
			return lbl
		end

		function tabapi:AddButton(text, callback)
			local btn = Instance.new("TextButton", page)
			btn.Text = text
			btn.Font = Enum.Font.Gotham
			btn.TextColor3 = Color3.new(1,1,1)
			btn.TextSize = 14
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			btn.BorderSizePixel = 0
			btn.MouseButton1Click:Connect(function()
				if callback then callback() end
			end)
			return btn
		end

		function tabapi:AddToggle(text, default, callback)
			local holder = Instance.new("Frame", page)
			holder.Size = UDim2.new(1, -10, 0, 30)
			holder.BackgroundTransparency = 1

			local toggle = Instance.new("TextButton", holder)
			toggle.Size = UDim2.new(0, 30, 0, 30)
			toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
			toggle.Text = default and "✔" or ""
			toggle.Font = Enum.Font.Gotham
			toggle.TextSize = 16
			toggle.TextColor3 = Color3.new(1,1,1)

			local label = Instance.new("TextLabel", holder)
			label.Text = text
			label.Position = UDim2.new(0, 35, 0, 0)
			label.Size = UDim2.new(1, -35, 1, 0)
			label.Font = Enum.Font.Gotham
			label.TextSize = 14
			label.TextColor3 = Color3.new(1,1,1)
			label.BackgroundTransparency = 1
			label.TextXAlignment = Enum.TextXAlignment.Left

			local state = default

			toggle.MouseButton1Click:Connect(function()
				state = not state
				toggle.Text = state and "✔" or ""
				if callback then callback(state) end
			end)

			return toggle
		end

		function tabapi:AddSlider(text, min, max, default, callback)
			local sliderframe = Instance.new("Frame", page)
			sliderframe.Size = UDim2.new(1, -10, 0, 40)
			sliderframe.BackgroundTransparency = 1

			local label = Instance.new("TextLabel", sliderframe)
			label.Text = text .. ": " .. default
			label.Font = Enum.Font.Gotham
			label.TextSize = 14
			label.TextColor3 = Color3.new(1,1,1)
			label.Size = UDim2.new(1, 0, 0, 20)
			label.BackgroundTransparency = 1

			local slider = Instance.new("Frame", sliderframe)
			slider.Position = UDim2.new(0, 0, 0, 25)
			slider.Size = UDim2.new(1, 0, 0, 10)
			slider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
			slider.BorderSizePixel = 0

			local fill = Instance.new("Frame", slider)
			fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			fill.BorderSizePixel = 0

			local dragging = false

			local function update(input)
				local pos = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
				local value = math.floor((min + (max - min) * pos) + 0.5)
				fill.Size = UDim2.new(pos, 0, 1, 0)
				label.Text = text .. ": " .. value
				if callback then callback(value) end
			end

			slider.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					update(input)
				end
			end)

			uis.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					update(input)
				end
			end)

			uis.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			return slider
		end

		return tabapi
	end

	return uilib
end

-- USAGE EXAMPLE
local ui = uilib:CreateWindow({Title = "My Custom UI"})

local tab1 = ui:CreateTab("Main")
tab1:AddLabel("Welcome to the UI!")
tab1:AddButton("Click Me", function()
	print("Clicked!")
end)
tab1:AddToggle("Enable Feature", false, function(state)
	print("Toggle State:", state)
end)
tab1:AddSlider("Volume", 0, 100, 50, function(val)
	print("Volume:", val)
end)
