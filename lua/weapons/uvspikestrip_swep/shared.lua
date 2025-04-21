if (SERVER) then
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
end
if ( CLIENT ) then
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 64
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.PrintName			= "UV Spike strip"
	SWEP.Category			= "Unit Vehicles"
	SWEP.Author				= "Roboboy"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 11
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/entities/uvspikestrip_swep")
end
SWEP.Author			= "Roboboy"
SWEP.Contact		= "Deployed by Air, Interceptors and Commanders."
SWEP.Purpose		= "To make those street punks regret their life choices."
SWEP.Instructions	= "Left click to place a 10-67, right click to pick it up."
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.ViewModel = Model("models/weapons/v_hands.mdl")
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= -1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= .1
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ""
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= -1
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.Delay		= 0.2
SWEP.Secondary.NextFire 	= 0
SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Planting = false
SWEP.Planting2 = false
SWEP.PlantStart = 0
function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end
function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawViewModel(false)
		self.Owner:DrawWorldModel(false)
	end
end
function SWEP:Reload()
end
function SWEP:Plant()
	if not SERVER then return end
	local tr = self.Owner:GetEyeTrace()
	local ANGZ = self.Owner:EyeAngles()
    local spikes = ents.Create("entity_uvspikestrip")
    spikes:SetPos(tr.HitPos+Vector(0,0,1))
	spikes:SetAngles(Angle(180,ANGZ.y+90,180))
	spikes:Spawn()
	spikes.PhysgunDisabled = false
	spikes:GetPhysicsObject():EnableMotion(true)
	spikes:CallOnRemove( "makerespawnable", function( ply ) spikes.Owner.SpikeStrip = false end )
	spikes.Owner = self.Owner
	self.Owner.SpikeStrip = true
end
function SWEP:CanPrimaryAttack()
    local tr = self.Owner:GetEyeTrace()
	local hitpos = tr.HitPos
	local dist = self.Owner:GetShootPos():Distance(hitpos)
	return dist<100
end
function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then self.Planting = false return end
	--if not self.Owner.SpikeStrip then
		if not self.Planting then
			self.Planting = true
		end
	--end
end
function SWEP:SecondaryAttack()
	if not SERVER then return end
    local tr = self.Owner:GetEyeTrace()
	if tr.Entity:GetClass() == "entity_uvspikestrip" then
		tr.Entity:Remove()
		self.Owner.SpikeStrip = false
	end
end
function SWEP:Holster()
	return true
end
function SWEP:OnRemove()
	return true
end
function SWEP:Think()
	if self.Owner:KeyDown(1) and self:CanPrimaryAttack() then
		if self.Planting then
			if not self.Planting2 then
				self.Planting2 = true
				self.Owner:SetNWBool("Planting",true)
				self.PlantStart = CurTime()
			end
			if CurTime()>self.PlantStart+1 then
				self.Planting = false
				self.Planting2 = false
				self.Owner:SetNWBool("Planting",false)
				self:Plant()
				self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
			end
		end
	else
		if self.Planting2 then
			self.Planting2 = false
			self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
			self.Owner:SetNWBool("Planting",false)
		end
		self.Planting = false
	end
end
SWEP.DrawH = 0
function SWEP:DrawHUD()
	if self.Owner:GetNWBool("Planting")==true then
		if self.DrawH == 0 then
			self.DrawH = CurTime()
		end
		local w = ScrW()
		local h = ScrH()
		surface.SetDrawColor(Color(0,0,200,150))
		surface.DrawRect(w/3,h/2,12,40)
		surface.DrawRect(w*2/3,h/2,12,40)
		surface.DrawRect(w/3+12,h/2,w/3-12,12)
		surface.DrawRect(w/3+12,h/2+28,w/3-12,12)
		surface.SetDrawColor(Color(0,0,200,150))
		local T = math.Clamp(((CurTime()-self.DrawH)/1)*(w/2.9),0,w/3-20)
		surface.DrawRect(w/3+16,h/2+16,T,8)
	else
		self.DrawH = 0
	end
end
