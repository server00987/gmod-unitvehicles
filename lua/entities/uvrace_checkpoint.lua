AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Editable = true

function ENT:SetupDataTables()
	self:NetworkVar("Vector", 0, "MaxPos")
	self:NetworkVar("Int", 0, "ID", {KeyName = "UVRace_CheckpointID", Edit = {type = "Generic", order = 1}})
	self:NetworkVar("Int", 1, "SpeedLimit", {KeyName = "UVRace_SpeedLimit", Edit = {type = "Generic", order = 2}})
	self:NetworkVar("Vector", 0, "LocalPos")
	self:NetworkVar("Vector", 1, "LocalMaxPos")
	self:NetworkVar("Vector", 2, "Chunk")
	self:NetworkVar("Vector", 3, "ChunkMax")
	self:NetworkVar("Bool", 0, "FinishLine")
end

local vec0 = Vector(0, 0, 0)

function ENT:Initialize()
	self:EnableCustomCollisions(true)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionBounds(vec0, self:GetMaxPos() - self:GetPos())

	self:DrawShadow(false)

	if CLIENT then
		self:SetRenderBoundsWS(self:GetPos(), self:GetMaxPos())
		if GMinimap then
			self.blip, self.blip_id = GMinimap:AddBlip( {
                id = "Checkpoint"..self:GetID(),
                position = (self:GetPos() + self:GetMaxPos())/2,
                icon = "unitvehicles/icons/MINIMAP_ICON_CIRCUIT.png",
                scale = 1.5,
                color = Color( 255, 255, 255),
				alpha = 0,
                lockIconAng = true
            } )
		end
		local index = self:EntIndex()
		hook.Add("PostDrawOpaqueRenderables", "DrawCheckpoint_" .. index, function()
			if not IsValid(self) then hook.Remove("PostDrawOpaqueRenderables", "DrawCheckpoint_" .. index) return end
			self:Draw()
		end)
	end

	if SERVER then
		-- local basePos = self:GetPos()
		-- local maxPos = self:GetMaxPos()

		-- if maxPos.z - basePos.z < 100 then
			-- maxPos.z = basePos.z + 100
			-- self:SetMaxPos(maxPos)
		-- end

		--self:SetCollisionBounds(vec0, maxPos - basePos)
		hook.Add("SetupPlayerVisibility", "UVRace_Checkpoint" .. self:EntIndex(), function()
			AddOriginToPVS(self:GetLocalPos())
		end)
		-- function ENT:UpdateTransmitState()
		-- 	return TRANSMIT_ALWAYS
		-- end
		UVRaceCheckFinishLine()
	end

end

local allowedMasks = {
	[1107312651] = true, -- tool trace
	[1174421519] = true -- remover trace
}
function ENT:TestCollision( startpos, delta, isbox, extents, mask )
	if allowedMasks[mask] then return true end -- only traces allowed
end

if CLIENT then
	local ang0 = Angle(0, 0, 0)
	function ENT:Draw()
		local id = self:GetID()
		local speedlimit = self:GetSpeedLimit() or math.huge
		if not id then return end
		local pos = self:GetPos()

		if not UVHUDRace and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gmod_tool" then

			cam.Start3D()

			render.SetColorMaterial()
			if InfMap then render.OverrideDepthEnable(true, true) end
			--print(InfMap.unlocalize_vector(self:InfMap_GetPos()), self.CHUNK_OFFSET)
			--print(self:GetPos(), self.CHUNK_OFFSET)

			--print("pos", pos, "max", self:GetMaxPos())

			--print(InfMap.localize_vector( self:GetMaxPos() ))

			--local max, chunk_offset = (InfMap and InfMap.localize_vector( self:GetMaxPos() )) - pos

			--local sMax = InfMap.localize_vector( self:GetMaxPos() )
			-- print(sMax)
			-- 5725.752441 -5108.517090 -12799.968750	5880.725586 -5046.941406 -12395.643555

			--print(self:GetMaxPos(), pos)

			local pos = (InfMap and self:GetLocalPos()) or self:GetPos()
			local max = (InfMap and self:GetLocalMaxPos()) or self:GetMaxPos()

			local chunk = (InfMap and self:GetChunk()) or nil
			local maxChunk = (InfMap and self:GetChunkMax()) or nil

			--print(pos, max, chunk, maxChunk)

			local max = max - pos

			if InfMap then
				local lpChunk = LocalPlayer().CHUNK_OFFSET
				if lpChunk ~= chunk and lpChunk ~= maxChunk then
					if InfMap then render.OverrideDepthEnable(false, false) end
					cam.End3D()
					return
				end
			end
			if id == 0 then
				--print(max, pos)
				render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 255, 255))
				if not InfMap then
					render.DrawBox(pos, ang0, vec0, max, Color(255, 255, 255, 100))
				end
			elseif id == 1 then
				if self:GetFinishLine() then
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 0, 0))
					if not InfMap then
						render.DrawBox(pos, ang0, vec0, max, Color(255, 0, 0, 100))
					end
				else
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(0, 255, 0))
					if not InfMap then
						render.DrawBox(pos, ang0, vec0, max, Color(0, 255, 0, 100))
					end
				end
			else
				if self:GetFinishLine() then
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 0, 0))
					if not InfMap then
						render.DrawBox(pos, ang0, vec0, max, Color(255, 0, 0, 100))
					end
				else
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 255, 0))
					if not InfMap then
						render.DrawBox(pos, ang0, vec0, max, Color(255, 255, 0, 100))
					end
				end
			end

			if InfMap then render.OverrideDepthEnable(false, false) end
			cam.End3D()

			cam.Start2D()
			if InfMap then render.OverrideDepthEnable(true, true) end

				--local point = pos + self:OBBCenter()
				local point = (InfMap and ((self:GetLocalPos() + self:GetLocalMaxPos()) / 2)) or (pos + self:OBBCenter())
				local data2D = point:ToScreen()

				if id == 0 then
					local blink = 255 * math.abs(math.sin(RealTime() * 4))
					draw.SimpleText( "#uv.racemanager.invalid", "UVFont4", data2D.x, data2D.y - 10, Color( 255, blink, blink), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					draw.SimpleText( string.format( language.GetPhrase("uv.racemanager.speedlimit"), tostring(speedlimit) ), "UVFont4", data2D.x, data2D.y + 10, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				elseif id == 1 then
					if self:GetFinishLine() then
						draw.SimpleText( "#uv.racemanager.finishline", "UVFont4", data2D.x, data2D.y - 10, Color( 255, 50, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						draw.SimpleText( string.format( language.GetPhrase("uv.racemanager.speedlimit"), tostring(speedlimit) ), "UVFont4", data2D.x, data2D.y + 10, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( "#uv.racemanager.startline", "UVFont4", data2D.x, data2D.y - 10, Color( 50, 255, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						draw.SimpleText( string.format( language.GetPhrase("uv.racemanager.speedlimit"), tostring(speedlimit) ), "UVFont4", data2D.x, data2D.y + 10, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
				else
					if self:GetFinishLine() then
						draw.SimpleText( language.GetPhrase("uv.racemanager.finishline") .. ": " .. id, "UVFont4", data2D.x, data2D.y - 10, Color( 255, 50, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						draw.SimpleText( string.format( language.GetPhrase("uv.racemanager.speedlimit"), tostring(speedlimit) ), "UVFont4", data2D.x, data2D.y + 10, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( string.format( language.GetPhrase("uv.racemanager.checkpoint"), id ), "UVFont4", data2D.x, data2D.y - 10, Color( 255, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						draw.SimpleText( string.format( language.GetPhrase("uv.racemanager.speedlimit"), tostring(speedlimit) ), "UVFont4", data2D.x, data2D.y + 10, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
				end

			if InfMap then render.OverrideDepthEnable(false, false) end
			cam.End2D()

		elseif UVHUDRace then
			
			if not UVHUDDisplayRacing then return end
			if not UVHUDRaceCurrentCheckpoint then return end
			--Show current checkpoint and the checkpoint after that
			local currentcheckpoint = UVHUDRaceCurrentCheckpoint + 1
			local nextcheckpoint = currentcheckpoint + 1 

			if nextcheckpoint > GetGlobalInt("uvrace_checkpoints") then
				nextcheckpoint = 1
			end

			if (id ~= currentcheckpoint and id ~= nextcheckpoint) or id == 0 then return end//or id == 0 then return end

			local pos = (InfMap and self:GetLocalPos()) or self:GetPos()
			local max = (InfMap and self:GetLocalMaxPos()) or self:GetMaxPos()

			local chunk = (InfMap and self:GetChunk()) or nil
			local maxChunk = (InfMap and self:GetChunkMax()) or nil

			if InfMap then
				local lpChunk = LocalPlayer().CHUNK_OFFSET
				if lpChunk ~= chunk then return end
			end
			
			cam.Start3D()
			if InfMap then render.OverrideDepthEnable(true, true) end
			render.SetColorMaterial()

			local max = max - pos

			if id == currentcheckpoint then
				if id == GetGlobalInt("uvrace_checkpoints") then --Finish line
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 255, 255))
				else
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(0, 255, 0))
				end
			else
				if id == GetGlobalInt("uvrace_checkpoints") then --Finish line
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 255, 255))
				elseif UVHUDRaceCurrentLap ~= UVHUDRaceLaps or id ~= 1 then --Last lap
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 255, 0))
				end
			end

			if InfMap then render.OverrideDepthEnable(false, false) end
			cam.End3D()
			
		end
	end

	function ENT:TestCollision(startpos, delta, isbox, extents, mask)
    	return false  -- Will never be hit by traces
	end

	function ENT:OnRemove()
		if GMinimap then
			GMinimap:RemoveBlipById( self.blip_id )
		end
	end
end

if SERVER then
	-- function ENT:StartTouch(vehicle)
	-- 	print("StartTouch")
	-- end
	function ENT:OnRemove()
		hook.Remove("SetupPlayerVisibility", "UVRace_Checkpoint" .. self:EntIndex())
		UVRaceCheckFinishLine()
	end
end