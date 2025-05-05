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
		
		local pos1 = self:GetPos1()
		local pos2 = self:GetPos2()

		local lowest_y = math.min(pos1.y, pos2.y)

		local target = (pos2 + pos1) / 2

		self.target_point = target

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
		if vehicle.uvbusted then return end

		local driver = vehicle:GetDriver()//vehicle.racedriver
	
		self:SetupGlobals(vehicle, vehicle)

		if !UVRaceTable or !UVRaceTable['Participants'] then return end
		if !UVRaceTable['Participants'][vehicle] then return end

		local vehicle_array = UVRaceTable['Participants'][vehicle]

		if vehicle_array.Disqualified or vehicle_array.Busted then return end

		local last_checkpoint = #vehicle_array['Checkpoints']
		local next_checkpoint = last_checkpoint + 1

		local checkp_id = self:GetID()

		if next_checkpoint == checkp_id then --Checkpoint passed

			vehicle_array['Checkpoints'][checkp_id] = CurTime()

			net.Start("uvrace_checkpointcomplete")
			net.WriteEntity(vehicle)
			net.WriteInt(checkp_id, 11)
			net.WriteFloat(vehicle_array['Checkpoints'][checkp_id])
			net.Broadcast()
			
			-- local participant = net.ReadEntity()
			-- local checkpoint = net.ReadInt(11)
			-- local time = net.ReadInt(32)

			if #vehicle_array['Checkpoints'] >= GetGlobalInt("uvrace_checkpoints") then -- Lap completed

				local laptime = CurTime() - vehicle_array['LastLapTime']
				vehicle_array['LastLapTime'] = CurTime()

				table.Empty(vehicle_array['Checkpoints'])
				--vehicle.currentcheckpoint = 1

				//if IsValid(driver) and driver:IsPlayer() then
				net.Start("uvrace_lapcomplete")
				net.WriteEntity(vehicle)
				net.WriteFloat(laptime)
				net.Broadcast()
				//end
				UVCheckLapTime( vehicle, vehicle_array.Name, laptime )
				
				if vehicle_array['Lap'] == UVRaceLaps:GetInt() then --Completed race
					vehicle_array['Lap'] = 1
					vehicle_array['Finished'] = true

					vehicle.racefinished = true
					vehicle.uvraceparticipant = false

					local place = 1

					for veh, array in pairs(UVRaceTable['Participants']) do
						if vehicle == veh then continue end
						if array.Finished then
							place = place +1
						end
					end

					net.Start("uvrace_racecomplete")
					net.WriteEntity(vehicle)
					//net.WriteString(vehicle_array.Name)
					net.WriteInt(place, 32)
					net.WriteFloat(CurTime() - vehicle.racestart)
					net.Broadcast()
					
					UVRaceRemoveParticipant( vehicle, 'Finished' )
				else
					vehicle_array['Lap'] = vehicle_array['Lap'] +1
					--vehicle.currentlap = vehicle.currentlap + 1
				end

			end

			-- if IsValid(driver) and driver:IsPlayer() then
			-- 	net.Start("uvrace_checkpointcomplete")
			-- 	net.Send(driver)
			-- end

		end

		self:KillGlobals()
	end
end