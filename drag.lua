-- change parent to your element name (required)
local dragging = false
local draginput, dragstart, startpos

parent.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        startpos = parent.Position
        dragstart = input.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

parent.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        draginput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == draginput then
        local delta = input.Position - dragstart
        local newx = startpos.X.Offset + delta.X
        local newy = startpos.Y.Offset + delta.Y

        local screensize = workspace.CurrentCamera.ViewportSize
        local framesize = parent.AbsoluteSize

        newx = math.clamp(newx, 0, screensize.X - framesize.X)
        newy = math.clamp(newy, 0, screensize.Y - framesize.Y)

        parent.Position = UDim2.new(0, newx, 0, newy)
    end
end)
