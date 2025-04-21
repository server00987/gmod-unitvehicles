include("shared.lua")

local mat = Material("sprites/light_ignorez")
local matr = Matrix()
local Headlights = GetConVar("unitvehicle_enableheadlights")

function ENT:Initialize()

	local modeltable = {
		"models/nfs_mwpolhel/nfs_mwpolhel.mdl",
		"models/nfs_ucpolhel/nfs_ucpolhel.mdl",
		"models/nfs_hppolhel/nfs_hppolhel.mdl",
		"models/nfs_nlpolhel/nfs_nlpolhel.mdl",
		"models/nfs_paybackpolhel/nfs_paybackpolhel.mdl",
	}

	self.Model = modeltable[UVUHelicopterModel:GetInt()] or modeltable[1]

	if self.Model == "models/nfs_mwpolhel/nfs_mwpolhel.mdl" then
		self.SpotlightPos = Vector(85,0,25)
		self.RedLightPos = Vector(-295,0,140)
	elseif self.Model == "models/nfs_ucpolhel/nfs_ucpolhel.mdl" then
		self.SpotlightPos = Vector(-110,0,35)
		self.RedLightPos = Vector(-390,0,165)
	elseif self.Model == "models/nfs_hppolhel/nfs_hppolhel.mdl" then
		self.SpotlightPos = Vector(124,0,21.9)
		self.RedLightPos = Vector(-357.5,0,182.5)
	elseif self.Model == "models/nfs_nlpolhel/nfs_nlpolhel.mdl" then
		self.SpotlightPos = Vector(96,0,13)
		self.RedLightPos = Vector(-352,0,189)
	elseif self.Model == "models/nfs_paybackpolhel/nfs_paybackpolhel.mdl" then
		self.SpotlightPos = Vector(26,0,10)
		self.RedLightPos = Vector(-457,0,220)
	end

	self.RotorSoundPatch = "<chopper/mwheli.wav"
	self.Rotor2SoundPatch = "<chopper/mwheli2.wav"
	self.Rotor3SoundPatch = "<chopper/mwheli3.wav"
	self.Rotor4SoundPatch = "<chopper/mwheli4.wav"

	self.RotorSound = CreateSound(self,self.RotorSoundPatch)
	self.RotorSound:SetSoundLevel(85)
	self.RotorSound:Play()
	self.RotorSound2 = CreateSound(self,self.Rotor2SoundPatch)
	self.RotorSound2:SetSoundLevel(85)
	self.RotorSound2:Play()
	self.RotorSound3 = CreateSound(self,self.Rotor3SoundPatch)
	self.RotorSound3:SetSoundLevel(85)
	self.RotorSound3:Play()
	self.RotorSound4 = CreateSound(self,self.Rotor4SoundPatch)
	self.RotorSound4:SetSoundLevel(85)
	self.RotorSound4:Play()
	
	self.Spotlight = ProjectedTexture()
	self.Spotlight:SetTexture("effects/flashlight001")
	self.Spotlight:SetFarZ(2048)
	self.Spotlight:SetFOV(50)
	self.Spotlight:SetColor(color_white)
	local pos,ang = LocalToWorld(self.SpotlightPos,Angle(),self:GetPos(),self:GetAngles())
	self.Spotlight:SetPos(pos)
	self.Spotlight:SetAngles(ang)
	self.Spotlight:Update()
	
	self:DrawShadow(true)
	self.Scale = Vector(1,1,1)
end

function ENT:Draw()
	local vel = WorldToLocal(self:GetVelocity(),Angle(),Vector(),Angle(0,self:GetAngles().y,0))
	local speed = self:GetVelocity():Length2D()
	
	self.Scale = Vector(1,1,1)
	matr:SetScale(self.Scale)

	self:EnableMatrix("RenderMultiply",matr)
	self:DrawModel()
	
	local spotpos = self.Spotlight:GetPos()
	local redpos = LocalToWorld(self.RedLightPos*self.Scale,Angle(),self:GetPos(),self:GetAngles())
	local dist = EyePos():Distance(spotpos)
	local dist2 = EyePos():Distance(redpos)
	
	if dist<10000 and util.TraceLine({start = EyePos(),endpos = spotpos,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
		mat:SetInt("$ignorez",0)
		
			render.SetMaterial(mat)
			render.DrawSprite(spotpos,256,256,Color(255,255,255,255-dist/10000*255))
		
		mat:SetInt("$ignorez",1)
	end
	if dist2<10000 and math.floor(CurTime()*1.5)==math.Round(CurTime()*1.5) and util.TraceLine({start = EyePos(),endpos = redpos,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
		mat:SetInt("$ignorez",0)
		
			render.SetMaterial(mat)
			render.DrawSprite(redpos,128,128,Color(255,0,0,255-dist2/10000*255))
		
		mat:SetInt("$ignorez",1)
	end
end

function ENT:Think()
	local speed = self:GetVelocity():Length()
	
	self.RotorSound:ChangePitch(100+math.Round(math.Clamp(speed/80,0,5),1))
	self.RotorSound2:ChangePitch(self.RotorSound:GetPitch(),1)
	self.RotorSound3:ChangePitch(self.RotorSound:GetPitch(),1)
	self.RotorSound4:ChangePitch(self.RotorSound:GetPitch(),1)
	
	self.Spotlight:SetPos(LocalToWorld(self.SpotlightPos*self.Scale,Angle(),self:GetPos(),self:GetAngles()))
	if (self:GetTarMode() or IsValid(self:GetTarget())) and Headlights:GetBool() then
		self.Spotlight:SetBrightness(10)
		self.Spotlight:SetAngles((self:GetTargetPos()-self.Spotlight:GetPos()):Angle())
	else
		self.Spotlight:SetBrightness(0)
	end
	self.Spotlight:Update()
end

function ENT:OnRemove()
	self.RotorSound:Stop()
	self.RotorSound2:Stop()
	self.RotorSound3:Stop()
	self.RotorSound4:Stop()
	self.Spotlight:Remove()
end