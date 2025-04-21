include('shared.lua') 

local models = {
	['models/unitvehiclesprops/policespikes/police_spike.mdl'] = 'Y',
	['models/unitvehiclesprops/prop_metalspikes_01/metalspikes.mdl'] = 'X'
}
  
function ENT:Draw()   
	local mat = Material("sprites/light_ignorez")
	local model = self.Entity:GetModel()
	local skins = self.Entity:GetSkin()

	self:DrawModel()

	-- local mins = self:OBBMins()
	-- local maxs = self:OBBMaxs()

	-- local startpos = self:GetPos()
	-- local dir = self:GetUp()
	-- local len = 128

	-- if models[model] == 'X' then
	-- 	for x = mins.x, maxs.x, 10 do
	-- 		--for y = mins.y, maxs.y, 10 do 
	-- 			local offset = Vector(x, 0, 0)
	-- 			local pos = self.Entity:LocalToWorld(offset)
	
	-- 			local tr = util.TraceLine({
	-- 				start = pos,
	-- 				endpos = pos + dir * len,
	-- 				filter = self,
	-- 				ignoreworld = true
	-- 			})
	
	-- 			render.DrawLine(tr.HitPos, pos + dir * len, color_white, true)
	-- 			render.DrawLine(pos, tr.HitPos, Color(0, 0, 255), true)
	-- 		--end
	-- 	end
	-- elseif models[model] == 'Y' then
	-- 	for x = mins.y, maxs.y, 10 do
	-- 		--for y = mins.y, maxs.y, 10 do 
	-- 			local offset = Vector(0, x, 0)
	-- 			local pos = self.Entity:LocalToWorld(offset)
	
	-- 			local tr = util.TraceLine({
	-- 				start = pos,
	-- 				endpos = pos + dir * len,
	-- 				filter = self,
	-- 				ignoreworld = true
	-- 			})
	
	-- 			render.DrawLine(tr.HitPos, pos + dir * len, color_white, true)
	-- 			render.DrawLine(pos, tr.HitPos, Color(0, 0, 255), true)
	-- 		--end
	-- 	end
	-- end

	-- for x = mins.x, maxs.x, 10 do
	-- 	--for y = mins.y, maxs.y, 10 do 
	-- 		local offset = Vector(x, 0, 0)
	-- 		local pos = self.Entity:LocalToWorld(offset)

	-- 		local tr = util.TraceLine({
	-- 			start = pos,
	-- 			endpos = pos + dir * len,
	-- 			filter = self
	-- 		})

	-- 		render.DrawLine(tr.HitPos, pos + dir * len, color_white, true)
	-- 		render.DrawLine(pos, tr.HitPos, Color(0, 0, 255), true)
	-- 	--end
	-- end

	-- -- Perform the trace
	-- local tr = util.TraceHull( {
	-- 	start = startpos,
	-- 	endpos = startpos + dir * len,
	-- 	maxs = maxs,
	-- 	mins = mins,
	-- 	filter = self
	-- } )

	-- -- Draw a line between start and end of the performed trace
	-- render.DrawLine( tr.HitPos, startpos + dir * len, color_white, true )
	-- render.DrawLine( startpos, tr.HitPos, Color( 0, 0, 255 ), true )

	-- -- Choose a color, if the trace hit - make the color red
	-- local clr = color_white
	-- if ( tr.Hit ) then clr = Color( 255, 0, 0 ) end

	-- -- Draw the trace bounds at the start and end positions
	-- render.DrawWireframeBox( startpos, Angle( 0, 0, 0 ), mins, maxs, Color( 255, 255, 255 ), true )
	-- render.DrawWireframeBox( tr.HitPos, Angle( 0, 0, 0 ), mins, maxs, clr, true )

	self.Entity:DrawModel() 
	if model != "models/unitvehiclesprops/policespikes/police_spike.mdl" then
		self.Entity.YellowLightPos1 = Vector(87,0,1)
		self.Entity.YellowLightPos2 = Vector(-87,0,1)
		local yellowpos1 = LocalToWorld(self.Entity.YellowLightPos1,Angle(),self.Entity:GetPos(),self.Entity:GetAngles())
		local yellowpos2 = LocalToWorld(self.Entity.YellowLightPos2,Angle(),self.Entity:GetPos(),self.Entity:GetAngles())
		local dist = EyePos():Distance(yellowpos1)
		local dist2 = EyePos():Distance(yellowpos2)
		
		if dist<10000 and math.floor(CurTime()*2)==math.Round(CurTime()*2) and util.TraceLine({start = EyePos(),endpos = yellowpos1,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
			mat:SetInt("$ignorez",0)
				render.SetMaterial(mat)
				render.DrawSprite(yellowpos1,128,128,Color(255,255,0,255-dist/10000*255))
			mat:SetInt("$ignorez",1)
		end

		if dist2<10000 and math.floor(CurTime()*2)==math.Round(CurTime()*2) and util.TraceLine({start = EyePos(),endpos = yellowpos2,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
			mat:SetInt("$ignorez",0)
				render.SetMaterial(mat)
				render.DrawSprite(yellowpos2,128,128,Color(255,255,0,255-dist2/10000*255))
			mat:SetInt("$ignorez",1)
		end
	else
		self.Entity.YellowLightPos1 = Vector(0,141.5,1)
		self.Entity.YellowLightPos2 = Vector(0,-7,1)
		self.Entity.YellowLightPos3 = Vector(0,7,1)
		self.Entity.YellowLightPos4= Vector(0,-141.5,1)
		local yellowpos1 = LocalToWorld(self.Entity.YellowLightPos1,Angle(),self.Entity:GetPos(),self.Entity:GetAngles())
		local yellowpos2 = LocalToWorld(self.Entity.YellowLightPos2,Angle(),self.Entity:GetPos(),self.Entity:GetAngles())
		local dist = EyePos():Distance(yellowpos1)
		local dist2 = EyePos():Distance(yellowpos2)
		local yellowpos3 = LocalToWorld(self.Entity.YellowLightPos3,Angle(),self.Entity:GetPos(),self.Entity:GetAngles())
		local yellowpos4 = LocalToWorld(self.Entity.YellowLightPos4,Angle(),self.Entity:GetPos(),self.Entity:GetAngles())
		local dist3 = EyePos():Distance(yellowpos1)
		local dist4 = EyePos():Distance(yellowpos2)

		local color1 = Color(0,161,255,255-dist/10000*255)
		local color2 = Color(0,161,255,255-dist2/10000*255)
		local color3 = Color(0,161,255,255-dist3/10000*255)
		local color4 = Color(0,161,255,255-dist4/10000*255)

		if skins == 1 then
			color1 = Color(255,0,0,255-dist/10000*255)
			color2 = Color(255,0,0,255-dist2/10000*255)
			color3 = Color(255,0,0,255-dist3/10000*255)
			color4 = Color(255,0,0,255-dist4/10000*255)
		end
		
		if dist<10000 and math.floor(CurTime()*2)==math.Round(CurTime()*2) and util.TraceLine({start = EyePos(),endpos = yellowpos1,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
			mat:SetInt("$ignorez",0)
				render.SetMaterial(mat)
				render.DrawSprite(yellowpos1,128,128,color1)
			mat:SetInt("$ignorez",1)
		end

		if dist2<10000 and math.floor(CurTime()*2)==math.Round(CurTime()*2) and util.TraceLine({start = EyePos(),endpos = yellowpos2,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
			mat:SetInt("$ignorez",0)
				render.SetMaterial(mat)
				render.DrawSprite(yellowpos2,128,128,color2)
			mat:SetInt("$ignorez",1)
		end

		if dist3<10000 and math.floor(CurTime()*2)==math.Round(CurTime()*2) and util.TraceLine({start = EyePos(),endpos = yellowpos3,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
			mat:SetInt("$ignorez",0)
				render.SetMaterial(mat)
				render.DrawSprite(yellowpos3,128,128,color3)
			mat:SetInt("$ignorez",1)
		end

		if dist4<10000 and math.floor(CurTime()*2)==math.Round(CurTime()*2) and util.TraceLine({start = EyePos(),endpos = yellowpos4,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
			mat:SetInt("$ignorez",0)
				render.SetMaterial(mat)
				render.DrawSprite(yellowpos4,128,128,color4)
			mat:SetInt("$ignorez",1)
		end
	end

end  
