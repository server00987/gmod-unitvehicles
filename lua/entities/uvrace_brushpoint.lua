ENT.Base = "base_brush"
ENT.Type = "brush"

AccessorFunc( ENT, "pos1", "Pos1")
AccessorFunc( ENT, "pos2", "Pos2")

if SERVER then
	function ENT:SetupDataTables()
		self:NetworkVar("Int", 0, "ID")
		self:NetworkVar("Bool", 0, "FinishLine")
	end

	function ENT:Initialize()
		self:SetSolid(SOLID_BBOX)
		self:SetCollisionBoundsWS(self:GetPos1(), self:GetPos2())
		self:DrawShadow(false)
	end

	function ENT:SetupGlobals( activator, caller )
		ACTIVATOR = activator
		CALLER = caller

		if ( IsValid( activator ) and activator:IsPlayer() ) then
			TRIGGER_PLAYER = activator
		end
	end

	function ENT:KillGlobals()
		ACTIVATOR = nil
		CALLER = nil
		TRIGGER_PLAYER = nil
	end

	function ENT:StartTouch(vehicle)

		if !vehicle.uvraceparticipant then return end

		local driver = vehicle.racedriver

		self:SetupGlobals(vehicle, vehicle)

		if vehicle.currentcheckpoint == self:GetID() then --Checkpoint passed

			vehicle.currentcheckpoint = vehicle.currentcheckpoint + 1

			if vehicle.currentcheckpoint > GetGlobalInt("uvrace_checkpoints") then -- Lap completed

				local laptime = CurTime() - vehicle.lastlaptime
				vehicle.lastlaptime = CurTime()
				vehicle.currentcheckpoint = 1

				if driver:IsPlayer() then
					net.Start("uvrace_lapcomplete")
					net.WriteFloat(laptime)
					net.Send(driver)
				end
				UVCheckLapTime( driver, laptime )
				
				if vehicle.currentlap == UVRaceLaps:GetInt() then --Completed race
					vehicle.currentlap = 1
					UVRaceRemoveParticipant( vehicle )
				else
					vehicle.currentlap = vehicle.currentlap + 1
				end

			end

			if driver:IsPlayer() then
				net.Start("uvrace_checkpointcomplete")
				net.Send(driver)
			end

		end

		self:KillGlobals()
	end
end