include('shared.lua') 
  
function ENT:Draw()   
	local mat = Material("sprites/light_ignorez")
	local model = self.Entity:GetModel()
	local skins = self.Entity:GetSkin()

	self.Entity:DrawModel() 
	self.Entity.LightPos1 = Vector(0,0,0)
	local lightpos1 = LocalToWorld(self.Entity.LightPos1,Angle(),self.Entity:GetPos(),self.Entity:GetAngles())
	local dist = EyePos():Distance(lightpos1)
	
	if dist<10000 and math.floor(CurTime()*4)==math.Round(CurTime()*4) and util.TraceLine({start = EyePos(),endpos = lightpos1,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
		mat:SetInt("$ignorez",0)
			render.SetMaterial(mat)
			render.DrawSprite(lightpos1,128,128,Color(255,255,255,255-dist/10000*255))
		mat:SetInt("$ignorez",1)
	end

end
