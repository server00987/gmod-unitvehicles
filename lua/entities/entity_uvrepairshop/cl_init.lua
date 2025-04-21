include('shared.lua') 
  
function ENT:Draw()   
	self.Entity:DrawModel()
	local pos = self.Entity:GetPos()

	local localPlayer = LocalPlayer()
	local box_color = Color(0, 255, 0)

	if IsValid(localPlayer) then
		local pos = pos

		local MaxX, MinX, MaxY, MinY
		local isVisible = false

		local p = pos
		local screenPos = p:ToScreen()
		isVisible = screenPos.visible
		
		if MaxX ~= nil then
			MaxX, MaxY = math.max(MaxX, screenPos.x), math.max(MaxY, screenPos.y)
			MinX, MinY = math.min(MinX, screenPos.x), math.min(MinY, screenPos.y)
		else
			MaxX, MaxY = screenPos.x, screenPos.y
			MinX, MinY = screenPos.x, screenPos.y
		end
    
		local textX = (MinX + MaxX) / 2
		local textY = MinY - 20
		cam.Start2D()
			draw.DrawText("+", "UVFont4", textX, textY - 30, box_color, TEXT_ALIGN_CENTER)
		cam.End2D()
	end
end
