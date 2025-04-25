AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local AutoHealth = GetConVar("unitvehicle_autohealth")
local UpVector = Vector(0,0,100)

function ENT:Initialize()
	self.Entity:SetModel("models/unitvehiclesprops/stunmineprojectile/stunmineprojectile.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:EmitSound( "gadgets/stunmine/deploy.wav" )
	self.Entity:EmitSound( "gadgets/stunmine/active.wav" )
	local e = EffectData()
	e:SetEntity(self.Entity)
	util.Effect("entity_remove", e)
	if self.racerdeployed then
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
	end
end

function ENT:Think()
	
	local objects = ents.FindInSphere(self.Entity:WorldSpaceCenter(), 100)
	for k, object in pairs(objects) do
		if !IsValid(object) then continue end

		if object != self.racerdeployed and (object:GetClass() == "prop_vehicle_jeep" or object.IsSimfphyscar or object.IsGlideVehicle) then
			if object.esfon then
				self.Entity:Remove()
				UVDeactivateESF(object)
				if IsValid(UVGetDriver(object)) then
					UVGetDriver(object):PrintMessage( HUD_PRINTCENTER, "Stun mine countered!" )
				end
				return
			end
			if IsValid(UVGetDriver(object)) then
				UVGetDriver(object):PrintMessage( HUD_PRINTCENTER, "YOU HIT A STUN MINE!" )
			end
			self:UVStunmineHit()
		end

	end
	
end

function ENT:StartTouch( ent )
	if ent:GetClass() == "gmod_sent_vehicle_fphysics_wheel" then
		local car = ent:GetBaseEnt()
		if car.esfon then
			self.Entity:Remove()
			UVDeactivateESF(car)
			if IsValid(UVGetDriver(car)) then
				UVGetDriver(car):PrintMessage( HUD_PRINTCENTER, "Stun mine countered!" )
			end
			return
		end
		if IsValid(UVGetDriver(car)) then
			UVGetDriver(car):PrintMessage( HUD_PRINTCENTER, "YOU HIT A STUN MINE!" )
		end
		self:UVStunmineHit()
		return
	end
	if ent:IsVehicle() then
		if ent.esfon then
			self.Entity:Remove()
			UVDeactivateESF(ent)
			if IsValid(UVGetDriver(ent)) then
				UVGetDriver(ent):PrintMessage( HUD_PRINTCENTER, "Stun mine countered!" )
			end
			return
		end
		if IsValid(UVGetDriver(ent)) then
			UVGetDriver(ent):PrintMessage( HUD_PRINTCENTER, "YOU HIT A STUN MINE!" )
		end
		self:UVStunmineHit()
	end
end

function ENT:UVStunmineHit()

	local car = self.racerdeployed or self.Entity
	local carchildren = {}
	local carconstraints = {}
	if IsValid(car) then
		carchildren = car:GetChildren()
		carconstraints = constraint.GetAllConstrainedEntities(car)
	end
	local entpos = self.Entity:WorldSpaceCenter()
    local objects = ents.FindInSphere(entpos, 1000)
    for k, object in pairs(objects) do
        if object != car and (!table.HasValue(carchildren, object) and !table.HasValue(carconstraints, object) and IsValid(object:GetPhysicsObject()) or object.UnitVehicle or object.UVWanted or object:GetClass() == "entity_uv*" or object.uvdeployed) then
            local objectphys = object:GetPhysicsObject()
            local vectordifference = object:WorldSpaceCenter() - entpos
            local angle = vectordifference:Angle()
			local power = UVPTStunMinePower:GetInt()
			local damage = UVPTStunMineDamage:GetFloat()
            local force = power * (1 - (vectordifference:Length()/1000))
            objectphys:ApplyForceCenter(angle:Forward()*force)
            object.rammed = true
            timer.Simple(5, function()
                if IsValid(object) then
                    object.rammed = nil
                end
            end)
            if object.UnitVehicle or (object.UVWanted and !AutoHealth:GetBool()) or !(object.UnitVehicle and object.UVWanted) then
                if object.IsSimfphyscar then
					local MaxHealth = object:GetMaxHealth()
                    local damage = MaxHealth*damage
                    object:ApplyDamage( damage, DMG_GENERIC )
                elseif object.IsGlideVehicle then
					object:SetEngineHealth( object:GetEngineHealth() - damage )
					object:UpdateHealthOutputs()
                elseif object:GetClass() == "prop_vehicle_jeep" then

                end
            end
			local e = EffectData()
			e:SetEntity(object)
			util.Effect("phys_unfreeze", e)
        end
    end

	if self.racerdeployed then
		if UVGetDriver(self.racerdeployed) == false then return end
		if UVGetDriver(self.racerdeployed):IsPlayer() then
			UVGetDriver(self.racerdeployed):PrintMessage( HUD_PRINTCENTER, "Stun mine hit!" )
		end
	end

	local e2 = EffectData()
	e2:SetEntity(self.Entity)
	util.Effect("entity_remove", e2)
	self.Entity:EmitSound( "gadgets/stunmine/hit.wav" )
	self.Entity:Remove()

end

function ENT:OnRemove()
	self.Entity:StopSound( "gadgets/stunmine/active.wav" )
end