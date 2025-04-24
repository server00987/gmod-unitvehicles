AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local AutoHealth = GetConVar("unitvehicle_autohealth")

local models = {
	['models/unitvehiclesprops/policespikes/police_spike.mdl'] = 'Y',
	['models/unitvehiclesprops/prop_metalspikes_01/metalspikes.mdl'] = 'X'
}

function ENT:Initialize()
	if self.uvdeployed then
		self.Entity:SetModel("models/unitvehiclesprops/policespikes/police_spike.mdl")
		self.Entity:SetAngles(self.Entity:GetAngles()+Angle(0,90,0))
	else
		self.Entity:SetModel("models/unitvehiclesprops/prop_metalspikes_01/metalspikes.mdl")
		--self.Entity:SetModel("models/unitvehiclesprops/policespikes/police_spike.mdl")
	end
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	if IsValid(self.Entity:GetPhysicsObject()) then
		self.Entity:GetPhysicsObject():Wake()
	end
	local MathSound = math.random(1,4)
	self.Entity:EmitSound( "gadgets/spikestrip/deploy"..MathSound..".wav" )
	local e = EffectData()
	e:SetEntity(self.Entity)
	util.Effect("entity_remove", e)
	if self.racerdeployed then
		self.Entity:SetSkin(1)
		constraint.NoCollide(self.racerdeployed,self.Entity,0,0)
		if self.racerdeployed.IsSimfphyscar then
			if istable(self.racerdeployed.Wheels) then
				for i = 1, table.Count( self.racerdeployed.Wheels ) do
					local Wheel = self.racerdeployed.Wheels[ i ]
					if IsValid(Wheel) then
						constraint.NoCollide(Wheel,self.Entity,0,0)
					end
				end
			end
		end
	else
		for _, ent in ents.Iterator() do
			if ent.UnitVehicle then
				constraint.NoCollide(ent,self.Entity,0,0)
				if ent.IsSimfphyscar then
					if istable(ent.Wheels) then
						for i = 1, table.Count( ent.Wheels ) do
							local Wheel = ent.Wheels[ i ]
							if IsValid(Wheel) then
								constraint.NoCollide(Wheel,self.Entity,0,0)
							end
						end
					end
				end
			end
		end
	end

	hook.Add("Think", "UVSpikeStripThink"..self:EntIndex(), function()
		if IsValid(self) then
			self:DoUpdate()
		else
			hook.Remove("Think", "UVSpikeStripThink"..self:EntIndex())
		end
	end)
end

-- Glide support
function ENT:DoUpdate()

	local startpos = self:GetPos()
	local dir = self:GetUp()
	local len = 128

	local mins = self:OBBMins()
	local maxs = self:OBBMaxs()

	local found = {}
	local model = self.Entity:GetModel()

	if models[model] == 'X' then
		for x = mins.x, maxs.x, 10 do
			--for y = mins.y, maxs.y, 10 do 
				local offset = Vector(x, 0, 0)
				local pos = self.Entity:LocalToWorld(offset)
	
				local tr = util.TraceLine({
					start = pos,
					endpos = pos + dir * len,
					filter = self.Entity,
					ignoreworld = true
				})
	
				if tr.Hit and tr.Entity then
					if self.racerdeployed and self.racerdeployed == tr.Entity then continue end
					table.insert(found, {tr.Entity, tr.HitPos})
				end
			--end
		end
	elseif models[model] == 'Y' then
		for x = mins.y, maxs.y, 10 do
			--for y = mins.y, maxs.y, 10 do 
				local offset = Vector(0, x, 0)
				local pos = self.Entity:LocalToWorld(offset)
	
				local tr = util.TraceLine({
					start = pos,
					endpos = pos + dir * len,
					filter = self.Entity,
					ignoreworld = true
				})
	
				if tr.Hit and tr.Entity then
					if self.racerdeployed and self.racerdeployed == tr.Entity then continue end
					table.insert(found, {tr.Entity, tr.HitPos})
				end
			--end
		end
	end

	for _, array in pairs(found) do
		if !array[1].IsGlideVehicle then continue end
		if !self.racerdeployed and IsValid(array[1].UnitVehicle) then continue end

		local hit = false

		for i, j in pairs(array[1].wheels) do
			if j.bursted then continue end
			local dist = (j:GetPos() - array[2]):Length()

			local og_forwardtractionmax = j.params.forwardTractionMax
			local og_sidetractionmax = j.params.sideTractionMax

			function j:_restore() -- temp func
				j.bursted = false
				j.params.forwardTractionMax = og_forwardtractionmax
				j.params.sideTractionMax = og_sidetractionmax
				j:Repair()
				timer.Remove("uvspiked"..j:EntIndex())
			end

			if dist < 50 then
				hit = true
				j.bursted = true
				j.params.forwardTractionMax = og_forwardtractionmax * .1
				j.params.sideTractionMax = og_sidetractionmax * .1

				local e = EffectData()
				e:SetEntity(j.Entity)
				util.Effect("entity_remove", e)

				j:EmitSound("glide/wheels/blowout.wav")

				local radius = j.params.radius * 0.8

   				local size = j.params.modelScale * radius * 2
				local obbSize = j:OBBMaxs() - j:OBBMins()
    			local scale = Vector( size[1] / obbSize[1], size[2] / obbSize[2], size[3] / obbSize[3] )

				j:SetRadius( radius )
				constraint.NoCollide(j,self.Entity,0,0)

				timer.Create("uvspiked"..j:EntIndex(), GetConVar("unitvehicle_spikestripduration"):GetFloat(), 1, function() 
					if j.bursted and IsValid(j) and IsValid(array[1]) and GetConVar("unitvehicle_spikestripduration"):GetFloat() > 0 then
						if array[1].wrecked then return end
						j.bursted = false
						j.params.forwardTractionMax = og_forwardtractionmax
						j.params.sideTractionMax = og_sidetractionmax
						j:EmitSound("gadgets/spikestrip/tirereinflatesound.wav")
						j:Repair()
					end
				end)
			end
		end

		if hit then
			if !IsValid(array[1].UnitVehicle) then
				timer.Simple(1, function()
					if IsValid(self.Entity) then
						self:UVSpikeStripHit()
					end
				end)
			end
		end
	end
end

function ENT:StartTouch( ent )
	if self.racerdeployed then
		if ent:GetClass() == "gmod_sent_vehicle_fphysics_wheel" then
			if ent:GetDamaged() then return end
			local car = ent:GetBaseEnt()
			if car.UnitVehicle or car.UVWanted and !AutoHealth:GetBool() then
				local MaxHealth = car:GetMaxHealth()
				local damage = MaxHealth*0.1
				car:ApplyDamage( damage, DMG_GENERIC )
				car.rammed = true
                timer.Simple(5, function()
                    if IsValid(car) then
                        car.rammed = nil
                    end
                end)
			end
			local ogwheelpos = ent.GhostEnt:GetLocalPos()
			ent:SetDamaged(true)
			local phmass = math.Round(ent:GetPhysicsObject():GetMass())
			uvbounty = uvbounty+phmass
			timer.Simple(GetConVar("unitvehicle_spikestripduration"):GetFloat(), function() 
				if IsValid(car) and IsValid(ent) and GetConVar("unitvehicle_spikestripduration"):GetFloat() > 0 then
					if car.wrecked then return end
					ent:SetDamaged(false)
					ent:EmitSound("gadgets/spikestrip/tirereinflatesound.wav")
					ent.GhostEnt:SetParent( nil )
					ent.GhostEnt:GetPhysicsObject():EnableMotion( false )
					ent.GhostEnt:SetPos( ent:LocalToWorld(ogwheelpos) )
					ent.GhostEnt:SetParent( ent )
				end
			end)
		elseif ent:GetClass() == "prop_vehicle_jeep" then
			local ogmaterial0 = ent:GetWheel(0):GetMaterial()
			local ogmaterial1 = ent:GetWheel(1):GetMaterial()
			local ogmaterial2 = ent:GetWheel(2):GetMaterial()
			local ogmaterial3 = ent:GetWheel(3):GetMaterial()
			if GetConVar("unitvehicle_spikestripduration"):GetFloat() > 0 then
				timer.Create( "uvspiked"..ent:EntIndex(), 0.1, (GetConVar("unitvehicle_spikestripduration"):GetFloat()*10-1), function() 
					if IsValid(ent) then
						ent:GetWheel(0):SetMaterial("slidingrubbertire")
						ent:GetWheel(1):SetMaterial("slidingrubbertire")
						ent:GetWheel(2):SetMaterial("slidingrubbertire")
						ent:GetWheel(3):SetMaterial("slidingrubbertire")
					end
				end)
			else
				timer.Create( "uvspiked"..ent:EntIndex(), 0.1, 0, function() 
					if IsValid(ent) then
						ent:GetWheel(0):SetMaterial("slidingrubbertire")
						ent:GetWheel(1):SetMaterial("slidingrubbertire")
						ent:GetWheel(2):SetMaterial("slidingrubbertire")
						ent:GetWheel(3):SetMaterial("slidingrubbertire")
					end
				end)
			end
			timer.Simple(GetConVar("unitvehicle_spikestripduration"):GetFloat(), function() 
				if IsValid(ent) and GetConVar("unitvehicle_spikestripduration"):GetFloat() > 0 then 
					ent:EmitSound("gadgets/spikestrip/tirereinflatesound.wav")
					ent:GetWheel(0):SetMaterial(ogmaterial0)
					ent:GetWheel(1):SetMaterial(ogmaterial1)
					ent:GetWheel(2):SetMaterial(ogmaterial2)
					ent:GetWheel(3):SetMaterial(ogmaterial3)
					ent.cnWheelHealth = nil
				else
					return
				end 
			end)
			ent.cnWheelHealth = true
			ent:EmitSound("spikestrip/tiredeflatesound.wav")
			ent:EmitSound("weapons/357_fire2.wav")
		end
	end
	if !IsValid(ent.UnitVehicle) then
		if ent.cnWheelHealth then
			ent:EmitSound("spikestrip/tiredeflatesound.wav")
			ent:EmitSound("weapons/357_fire2.wav")
			self:UVSpikeStripHit()
		elseif ent:GetClass() == "gmod_sent_vehicle_fphysics_wheel" then
			local car = ent:GetBaseEnt()
			if ent:GetDamaged() or car.UnitVehicle then return end
			if car.UnitVehicle or (car.UVWanted and !AutoHealth:GetBool()) then
				local MaxHealth = car:GetMaxHealth()
				local damage = MaxHealth*0.1
				car:ApplyDamage( damage, DMG_GENERIC )
				car.rammed = true
                timer.Simple(5, function()
                    if IsValid(car) then
                        car.rammed = nil
                    end
                end)
			end
			local ogwheelpos
			if ent.GhostEnt then
				ogwheelpos = ent.GhostEnt:GetLocalPos()
			end
			ent:SetDamaged(true)
			constraint.NoCollide(ent,self.Entity,0,0)
			timer.Simple(1, function()
				if IsValid(self.Entity) then
					self:UVSpikeStripHit()
				end
			end)
			timer.Simple(GetConVar("unitvehicle_spikestripduration"):GetFloat(), function() 
				if IsValid(car) and IsValid(ent) and GetConVar("unitvehicle_spikestripduration"):GetFloat() > 0 then
					if car.wrecked then return end
					ent:SetDamaged(false)
					ent:EmitSound("gadgets/spikestrip/tirereinflatesound.wav")
					if ent.GhostEnt then
						ent.GhostEnt:SetParent( nil )
						ent.GhostEnt:GetPhysicsObject():EnableMotion( false )
						ent.GhostEnt:SetPos( ent:LocalToWorld(ogwheelpos) )
						ent.GhostEnt:SetParent( ent )
					end
				end
			end)
		elseif ent:GetClass() == "prop_vehicle_jeep" then
			if isfunction(ent.GetDriver) and IsValid(ent:GetDriver()) and !IsValid(ent.DecentVehicle) and ent:GetDriver():IsPlayer() then 
				ent:GetDriver():PrintMessage( HUD_PRINTCENTER, "YOU HIT A SPIKE STRIP!")
			end	
			local ogmaterial0 = ent:GetWheel(0):GetMaterial()
			local ogmaterial1 = ent:GetWheel(1):GetMaterial()
			local ogmaterial2 = ent:GetWheel(2):GetMaterial()
			local ogmaterial3 = ent:GetWheel(3):GetMaterial()
			if GetConVar("unitvehicle_spikestripduration"):GetFloat() > 0 then
				timer.Create( "uvspiked"..ent:EntIndex(), 0.1, (GetConVar("unitvehicle_spikestripduration"):GetFloat()*10-1), function() 
					if IsValid(ent) then
						ent:GetWheel(0):SetMaterial("slidingrubbertire")
						ent:GetWheel(1):SetMaterial("slidingrubbertire")
						ent:GetWheel(2):SetMaterial("slidingrubbertire")
						ent:GetWheel(3):SetMaterial("slidingrubbertire")
					end
				end)
			else
				timer.Create( "uvspiked"..ent:EntIndex(), 0.1, 0, function() 
					if IsValid(ent) then
						ent:GetWheel(0):SetMaterial("slidingrubbertire")
						ent:GetWheel(1):SetMaterial("slidingrubbertire")
						ent:GetWheel(2):SetMaterial("slidingrubbertire")
						ent:GetWheel(3):SetMaterial("slidingrubbertire")
					end
				end)
			end
			timer.Simple(GetConVar("unitvehicle_spikestripduration"):GetFloat(), function() 
				if IsValid(ent) and GetConVar("unitvehicle_spikestripduration"):GetFloat() > 0 then 
					ent:EmitSound("gadgets/spikestrip/tirereinflatesound.wav")
					ent:GetWheel(0):SetMaterial(ogmaterial0)
					ent:GetWheel(1):SetMaterial(ogmaterial1)
					ent:GetWheel(2):SetMaterial(ogmaterial2)
					ent:GetWheel(3):SetMaterial(ogmaterial3)
					ent.cnWheelHealth = nil 
					if ent:IsVehicle() and isfunction(ent.GetDriver) and IsValid(ent:GetDriver()) and !IsValid(ent.DecentVehicle) and ent:GetDriver():IsPlayer() then 
						ent:GetDriver():PrintMessage( HUD_PRINTCENTER, "Tires reinflated!")
					end
				else
					return
				end 
			end)
			ent.cnWheelHealth = true
			ent:EmitSound("spikestrip/tiredeflatesound.wav")
			ent:EmitSound("weapons/357_fire2.wav")
			self:UVSpikeStripHit()
		end
	end
end

function ENT:UVSpikeStripHit()

	local e = EffectData()
	e:SetEntity(self.Entity)
	util.Effect("entity_remove", e)
	self.Entity:Remove() --Remove spike strip

	if self.racerdeployed then return end
	if #ents.FindByClass("uvair") > 0 then
		local unitss = table.Add(units, ents.FindByClass("uvair"))
		local random_entry = math.random(#unitss)	
		local unit = unitss[random_entry]
		if GetConVar("unitvehicle_chatter"):GetBool() and uvtargeting then
			UVChatterAirSpikeStripHit(unit)
		end
	elseif #ents.FindByClass("npc_uv*") > 0 then
		local units = ents.FindByClass("npc_uv*")
		local random_entry = math.random(#units)	
		local unit = units[random_entry]
		if GetConVar("unitvehicle_chatter"):GetBool() and uvtargeting then
			UVChatterSpikeStripHit(unit)
		end
	end

end