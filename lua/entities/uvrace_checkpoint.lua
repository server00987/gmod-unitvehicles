AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Editable = true

function ENT:SetupDataTables()
	self:NetworkVar("Vector", 0, "MaxPos")
	self:NetworkVar("Int", 0, "ID", {KeyName = "UVRace_CheckpointID", Edit = {type = "Generic", order = 1}})
	self:NetworkVar("Int", 1, "SpeedLimit", {KeyName = "UVRace_SpeedLimit", Edit = {type = "Generic", order = 2}})
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
                icon = "hud/MINIMAP_ICON_CIRCUIT.png",
                scale = 1.5,
                color = Color( 255, 255, 255),
				alpha = 0,
                lockIconAng = true
            } )
		end
	end

	if SERVER then
		hook.Add("SetupPlayerVisibility", "UVRace_Checkpoint" .. self:EntIndex(), function()
			AddOriginToPVS(self:GetPos())
		end)
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
		if !id then return end
		local pos = self:GetPos()

		if !UVHUDRace and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gmod_tool" then

			cam.Start3D()

			render.SetColorMaterial()

			local max = self:GetMaxPos() - pos

			if id == 0 then
				render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 255, 255))
				render.DrawBox(pos, ang0, vec0, max, Color(255, 255, 255, 100))
			elseif id == 1 then
				if self:GetFinishLine() then
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 0, 0))
					render.DrawBox(pos, ang0, vec0, max, Color(255, 0, 0, 100))
				else
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(0, 255, 0))
					render.DrawBox(pos, ang0, vec0, max, Color(0, 255, 0, 100))
				end
			else
				if self:GetFinishLine() then
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 0, 0))
					render.DrawBox(pos, ang0, vec0, max, Color(255, 0, 0, 100))
				else
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 255, 0))
					render.DrawBox(pos, ang0, vec0, max, Color(255, 255, 0, 100))
				end
			end

			cam.End3D()

			cam.Start2D()

				local point = pos + self:OBBCenter()
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
						draw.SimpleText( "#uv.racemanager.finishline", "UVFont4", data2D.x, data2D.y - 10, Color( 255, 50, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						draw.SimpleText( string.format( language.GetPhrase("uv.racemanager.speedlimit"), tostring(speedlimit) ), "UVFont4", data2D.x, data2D.y + 10, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( string.format( language.GetPhrase("uv.racemanager.checkpoint"), id ), "UVFont4", data2D.x, data2D.y - 10, Color( 255, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
						draw.SimpleText( string.format( language.GetPhrase("uv.racemanager.speedlimit"), tostring(speedlimit) ), "UVFont4", data2D.x, data2D.y + 10, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
				end

			cam.End2D()

		elseif UVHUDRace then
			
			if !UVHUDRaceCurrentCheckpoint then return end
			--Show current checkpoint and the checkpoint after that
			local currentcheckpoint = UVHUDRaceCurrentCheckpoint + 1
			local nextcheckpoint = currentcheckpoint + 1 

			if nextcheckpoint > GetGlobalInt("uvrace_checkpoints") then
				nextcheckpoint = 1
			end

			--print(nextcheckpoint)
			//print(id, currentcheckpoint, nextcheckpoint)
			if (id != currentcheckpoint and id != nextcheckpoint) or id == 0 then return end//or id == 0 then return end
			
			cam.Start3D()

			render.SetColorMaterial()

			local max = self:GetMaxPos() - pos

			if id == currentcheckpoint then
				if id == GetGlobalInt("uvrace_checkpoints") then --Finish line
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 255, 255))
				else
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(0, 255, 0))
				end
			else
				if id == GetGlobalInt("uvrace_checkpoints") then --Finish line
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 255, 255))
				elseif UVHUDRaceCurrentLap != UVHUDRaceLaps or id != 1 then --Last lap
					render.DrawWireframeBox(pos, ang0, vec0, max, Color(255, 255, 0))
				end
			end

			cam.End3D()
			
		end
	end

	function ENT:OnRemove()
		if GMinimap then
			GMinimap:RemoveBlipById( self.blip_id )
		end
	end
end

if SERVER then
	function ENT:OnRemove()
		hook.Remove("SetupPlayerVisibility", "UVRace_Checkpoint" .. self:EntIndex())
		UVRaceCheckFinishLine()
	end
end