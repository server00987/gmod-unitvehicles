AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
function ENT:Initialize()
	self.Entity:SetModel("models/props_phx/oildrum001.mdl")
	--self.Entity:SetMaterial("models/wireframe.vmt")
	--self.Entity:SetColor( Color(255, 191, 0, 255) )
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local e = EffectData()
	e:SetEntity(self.Entity)
	util.Effect("entity_remove", e)
	local selfphy = self.Entity:GetPhysicsObject()
	selfphy:SetMass(selfphy:GetMass()*2)
end
function OyFekOff( ply, ent )
if ent:GetClass() == "entity_uvbombstrip" then return false end
end

function ENT:BombExplode()
	local effect = EffectData()
	effect:SetOrigin(self.Entity:GetPos())
	effect:SetScale(2)
	util.Effect("Explosion",effect)
	util.BlastDamage(self.Entity,self.Entity,self.Entity:GetPos(),1000,50)
	local entpos = self.Entity:WorldSpaceCenter()
    local objects = ents.FindInSphere(entpos, 1000)
    for k, object in pairs(objects) do
        if IsValid(object:GetPhysicsObject()) then
            local objectphys = object:GetPhysicsObject()
            local vectordifference = object:WorldSpaceCenter() - entpos
            local angle = vectordifference:Angle()
			local power = 1000000
            local force = power * (1 - (vectordifference:Length()/1000))
            objectphys:ApplyForceCenter(angle:Forward()*force)
            object.rammed = true
            timer.Simple(5, function()
                if IsValid(object) then
                    object.rammed = nil
                end
            end)
        end
	end
	self:Remove()
end

function ENT:StartTouch( ent )
	if IsValid(ent:GetPhysicsObject()) and (ent:GetVelocity():LengthSqr()+self.Entity:GetVelocity():LengthSqr()) >= 250000 then
		self:BombExplode() --Remove explosive barrel
		if ent.UVWanted and !IsValid(ent.UVPatrol) and !IsValid(ent.UVSupport) and !IsValid(ent.UVPursuit) and !IsValid(ent.UVInterceptor) and !IsValid(ent.UVCommander) and !IsValid(ent.UVSpecial) then
			if #ents.FindByClass("uvair") > 0 then
				local unitss = table.Add(units, ents.FindByClass("uvair"))
				local random_entry = math.random(#unitss)	
				local unit = unitss[random_entry]
				if GetConVar("unitvehicle_chatter"):GetBool() and uvtargeting then
					UVChatterAirExplosiveBarrelHit(unit)
				end
			elseif #ents.FindByClass("npc_uv*") > 0 then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				if GetConVar("unitvehicle_chatter"):GetBool() and uvtargeting then
					UVChatterExplosiveBarrelHit(unit)
				end
			end
		end
	end
end