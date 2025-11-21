AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Spike Strip"
ENT.Author = "UVChief"
ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
    local AutoHealth = GetConVar("unitvehicle_autohealth")

	local models = {
		['models/unitvehiclesprops/policespikes/police_spike.mdl'] = 'Y',
		['models/unitvehiclesprops/prop_metalspikes_01/metalspikes.mdl'] = 'X'
	}

	function ENT:Initialize()
		if self.uvdeployed then
			self:SetModel("models/unitvehiclesprops/policespikes/police_spike.mdl")
			self:SetAngles(self:GetAngles()+Angle(0,90,0))
		else
			self:SetModel("models/unitvehiclesprops/prop_metalspikes_01/metalspikes.mdl")
		end
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		if IsValid(self:GetPhysicsObject()) then
			self:GetPhysicsObject():Wake()
		end
		local MathSound = math.random(1,4)
		self:EmitSound( "gadgets/spikestrip/deploy"..MathSound..".wav" )
		local e = EffectData()
		e:SetEntity(self)
		util.Effect("entity_remove", e)
		if self.racerdeployed then
			self:SetSkin(1)
			constraint.NoCollide(self.racerdeployed,self,0,0)
			if self.racerdeployed.IsSimfphyscar then
				if istable(self.racerdeployed.Wheels) then
					for i = 1, table.Count( self.racerdeployed.Wheels ) do
						local Wheel = self.racerdeployed.Wheels[ i ]
						if IsValid(Wheel) then
							constraint.NoCollide(Wheel,self,0,0)
						end
					end
				end
			end
		else
			for _, ent in ents.Iterator() do
				if ent.UnitVehicle then
					constraint.NoCollide(ent,self,0,0)
					if ent.IsSimfphyscar then
						if istable(ent.Wheels) then
							for i = 1, table.Count( ent.Wheels ) do
								local Wheel = ent.Wheels[ i ]
								if IsValid(Wheel) then
									constraint.NoCollide(Wheel,self,0,0)
								end
							end
						end
					end
				end
			end
		end

		-- fuck you all
		timer.Simple(.4, function()
			if IsValid(self) then
				hook.Add("Think", "UVSpikeStripThink"..self:EntIndex(), function()
					if IsValid(self) then
						self:DoUpdate()
					else
						hook.Remove("Think", "UVSpikeStripThink"..self:EntIndex())
					end
				end)
			end
		end)
	end

	-- Glide support
	function ENT:DoUpdate()

		local startpos = self:GetPos()
		local dir = self:GetUp()
		local len = 20

		local mins = self:OBBMins()
		local maxs = self:OBBMaxs()

		local found = {}
		local model = self:GetModel()

		if models[model] == 'X' then
			for x = mins.x, maxs.x, 10 do
				--for y = mins.y, maxs.y, 10 do 
				local offset = Vector(x, 0, 0)
				local pos = self:LocalToWorld(offset)

				local tr = util.TraceLine({
					start = pos,
					endpos = pos + dir * len,
					filter = self,
					ignoreworld = true
				})

				if tr.Hit and tr.Entity then
					if not (self.racerdeployed and self.racerdeployed == tr.Entity) then
						table.insert(found, {tr.Entity, tr.HitPos})
					end
				end
				--end
			end
		elseif models[model] == 'Y' then
			for x = mins.y, maxs.y, 10 do
				--for y = mins.y, maxs.y, 10 do 
				local offset = Vector(0, x, 0)
				local pos = self:LocalToWorld(offset)

				local tr = util.TraceLine({
					start = pos,
					endpos = pos + dir * len,
					filter = self,
					ignoreworld = true
				})

				if tr.Hit and tr.Entity then
					if not (self.racerdeployed and self.racerdeployed == tr.Entity) then
						table.insert(found, {tr.Entity, tr.HitPos})
					end
				end
				--end
			end
		end

		local reported = false

		for _, array in pairs(found) do
			if array[1].IsGlideVehicle then
				if array[1].UnitVehicle then
					if self.UVRoadblock then
						if not UVUnitPTSpikeStripRoadblockFriendlyFire:GetBool() then continue end
					else
						if not self.racerdeployed then continue end
					end
				else
					if self.racerdeployed and not RacerFriendlyFire:GetBool() then continue end
				end
				--if not (not self.racerdeployed and IsValid(array[1].UnitVehicle)) then
					--if not (self.racerdeployed and not array[1].UnitVehicle and not RacerFriendlyFire:GetBool()) then
						local hit = false

						for i, j in pairs(array[1].wheels) do
							if not j.bursted and not j.params.isBulletProof then
								local dist = (j:GetPos() - array[2]):Length()

								function j:_restore() -- temp func
									j.bursted = false
									j:Repair()
									timer.Remove("uvspiked"..j:EntIndex())
								end

								if dist < 50 then
									hit = true
									j.bursted = true
									j:Blow()

									timer.Create("uvspiked"..j:EntIndex(), GetConVar("unitvehicle_spikestripduration"):GetFloat(), 1, function() 
										if j.bursted and IsValid(j) and IsValid(array[1]) and GetConVar("unitvehicle_spikestripduration"):GetFloat() > 0 then
											if array[1].wrecked then return end
											j:EmitSound("gadgets/spikestrip/tirereinflatesound.wav")
											j:_restore()
										end
									end)
								end
							end
						end

						if hit and not self.reported then
							-- local attacker = UVGetDriver(array[1])
							-- local attackerName = UVGetDriverName(array[1])

							-- local victim = UVGetDriver(self.unitdeployed or self.racerdeployed)
							-- local victimName = UVGetDriverName(self.unitdeployed or self.racerdeployed)

							-- local args = {
							-- 	['User'] = attackerName,
							-- 	['Hit'] = victimName
							-- }

							-- local playersToSend = {}

							-- if attacker then
							-- 	table.insert( playersToSend, attacker )
							-- end

							-- if victim then
							-- 	table.insert( playersToSend, victim )
							-- end
							self.reported = true
							ReportPTEvent( self.unitdeployed or self.racerdeployed, array[1], 'Spikestrip', 'Hit' )

							timer.Simple(1, function()
								self.reported = false
								if IsValid(self) and not array[1].UnitVehicle and table.HasValue(UVWantedTableVehicle, array[1]) then
									self.reported = false
									self:UVSpikeStripHit()
								end
							end)
						end
					--end
				--end
			end
		end
	end

	function ENT:StartTouch( ent )
		if self.racerdeployed then
			if ent:GetClass() == "gmod_sent_vehicle_fphysics_wheel" then
				if ent:GetDamaged() then return end
				local car = ent:GetBaseEnt()
				if car.UnitVehicle or car.UVWanted and not AutoHealth:GetBool() then
					if self.racerdeployed and car.UVWanted then
						if not RacerFriendlyFire:GetBool() then return end
					end
					local MaxHealth = car:GetMaxHealth()
					local damage = MaxHealth*0.1
					car:ApplyDamage( damage, DMG_GENERIC )
					car.rammed = true
					timer.Simple(3, function()
						if IsValid(car) then
							car.rammed = nil
						end
					end)
				end
				local ogwheelpos = ent.GhostEnt:GetLocalPos()
				ent:SetDamaged(true)
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
				if self.racerdeployed and ent.UVWanted then
					if not RacerFriendlyFire:GetBool() then return end
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
					else
						return
					end 
				end)
				ent.cnWheelHealth = true
				ent:EmitSound("spikestrip/tiredeflatesound.wav")
				ent:EmitSound("weapons/357_fire2.wav")
			end
		end

		local car = (isfunction(ent.GetBaseEnt) and ent:GetBaseEnt()) or ent

		if not IsValid(car.UnitVehicle) or (IsValid(car.UnitVehicle) and (self.UVRoadblock and UVUnitPTSpikeStripRoadblockFriendlyFire:GetBool())) then
			if ent.cnWheelHealth then
				ent:EmitSound("spikestrip/tiredeflatesound.wav")
				ent:EmitSound("weapons/357_fire2.wav")
				self:UVSpikeStripHit()
			elseif ent:GetClass() == "gmod_sent_vehicle_fphysics_wheel" then
				local car = ent:GetBaseEnt()
				if ent:GetDamaged() then return end
				if car.UnitVehicle or (car.UVWanted and not AutoHealth:GetBool()) then
					local MaxHealth = car:GetMaxHealth()
					local damage = MaxHealth*0.1
					car:ApplyDamage( damage, DMG_GENERIC )
					car.rammed = true
					timer.Simple(3, function()
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
				constraint.NoCollide(ent,self,0,0)
				timer.Simple(1, function()
					if IsValid(self) then
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
				if isfunction(ent.GetDriver) and IsValid(ent:GetDriver()) and not IsValid(ent.DecentVehicle) and ent:GetDriver():IsPlayer() then 
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
						if ent:IsVehicle() and isfunction(ent.GetDriver) and IsValid(ent:GetDriver()) and not IsValid(ent.DecentVehicle) and ent:GetDriver():IsPlayer() then 
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
		e:SetEntity(self)
		util.Effect("entity_remove", e)
		self:Remove() --Remove spike strip

		if self.racerdeployed then return end
		if #ents.FindByClass("uvair") > 0 then
			local unitss = table.Add(units, ents.FindByClass("uvair"))
			local random_entry = math.random(#unitss)	
			local unit = unitss[random_entry]
			if GetConVar("unitvehicle_chatter"):GetBool() and UVTargeting then
				UVChatterSpikeStripHit(unit)
			end
		elseif #ents.FindByClass("npc_uv*") > 0 then
			local units = ents.FindByClass("npc_uv*")
			local random_entry = math.random(#units)	
			local unit = units[random_entry]
			if GetConVar("unitvehicle_chatter"):GetBool() and UVTargeting then
				UVChatterSpikeStripHit(unit)
			end
		end

	end

	function ENT:Think()
		if UVJammerDeployed then
			self:Remove()
		end
	end

else
	local models = {
		['models/unitvehiclesprops/policespikes/police_spike.mdl'] = 'Y',
		['models/unitvehiclesprops/prop_metalspikes_01/metalspikes.mdl'] = 'X'
	}
	
	function ENT:Draw()   
		local mat = Material("sprites/light_ignorez")
		local model = self:GetModel()
		local skins = self:GetSkin()

		self:DrawModel()

		self:DrawModel() 
		if model ~= "models/unitvehiclesprops/policespikes/police_spike.mdl" then
			self.YellowLightPos1 = Vector(87,0,1)
			self.YellowLightPos2 = Vector(-87,0,1)
			local yellowpos1 = LocalToWorld(self.YellowLightPos1,Angle(),self:GetPos(),self:GetAngles())
			local yellowpos2 = LocalToWorld(self.YellowLightPos2,Angle(),self:GetPos(),self:GetAngles())
			local dist = EyePos():Distance(yellowpos1)
			local dist2 = EyePos():Distance(yellowpos2)

			if dist<10000 and math.floor(CurTime()*2)==math.Round(CurTime()*2) and util.TraceLine({start = EyePos(),endpos = yellowpos1,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
				mat:SetInt("$ignorez",0)
					render.SetMaterial(mat)
					render.DrawSprite(yellowpos1,128,128,Color(255,255,0,255-dist/10000*255))
				mat:SetInt("$ignorez",1)
			end

			if dist2<10000 and math.floor(CurTime()*2)==math.Round(CurTime()*2) and util.TraceLine({start = EyePos(),endpos = yellowpos2,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
				mat:SetInt("$ignorez",0)
					render.SetMaterial(mat)
					render.DrawSprite(yellowpos2,128,128,Color(255,255,0,255-dist2/10000*255))
				mat:SetInt("$ignorez",1)
			end
		else
			self.YellowLightPos1 = Vector(0,141.5,1)
			self.YellowLightPos2 = Vector(0,-7,1)
			self.YellowLightPos3 = Vector(0,7,1)
			self.YellowLightPos4= Vector(0,-141.5,1)
			local yellowpos1 = LocalToWorld(self.YellowLightPos1,Angle(),self:GetPos(),self:GetAngles())
			local yellowpos2 = LocalToWorld(self.YellowLightPos2,Angle(),self:GetPos(),self:GetAngles())
			local dist = EyePos():Distance(yellowpos1)
			local dist2 = EyePos():Distance(yellowpos2)
			local yellowpos3 = LocalToWorld(self.YellowLightPos3,Angle(),self:GetPos(),self:GetAngles())
			local yellowpos4 = LocalToWorld(self.YellowLightPos4,Angle(),self:GetPos(),self:GetAngles())
			local dist3 = EyePos():Distance(yellowpos1)
			local dist4 = EyePos():Distance(yellowpos2)

			local color1 = Color(0,161,255,255-dist/10000*255)
			local color2 = Color(0,161,255,255-dist2/10000*255)
			local color3 = Color(0,161,255,255-dist3/10000*255)
			local color4 = Color(0,161,255,255-dist4/10000*255)

			if skins == 1 then
				color1 = Color(255,0,0,255-dist/10000*255)
				color2 = Color(255,0,0,255-dist2/10000*255)
				color3 = Color(255,0,0,255-dist3/10000*255)
				color4 = Color(255,0,0,255-dist4/10000*255)
			end

			if dist<10000 and math.floor(CurTime()*2)==math.Round(CurTime()*2) and util.TraceLine({start = EyePos(),endpos = yellowpos1,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
				mat:SetInt("$ignorez",0)
					render.SetMaterial(mat)
					render.DrawSprite(yellowpos1,128,128,color1)
				mat:SetInt("$ignorez",1)
			end

			if dist2<10000 and math.floor(CurTime()*2)==math.Round(CurTime()*2) and util.TraceLine({start = EyePos(),endpos = yellowpos2,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
				mat:SetInt("$ignorez",0)
					render.SetMaterial(mat)
					render.DrawSprite(yellowpos2,128,128,color2)
				mat:SetInt("$ignorez",1)
			end

			if dist3<10000 and math.floor(CurTime()*2)==math.Round(CurTime()*2) and util.TraceLine({start = EyePos(),endpos = yellowpos3,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
				mat:SetInt("$ignorez",0)
					render.SetMaterial(mat)
					render.DrawSprite(yellowpos3,128,128,color3)
				mat:SetInt("$ignorez",1)
			end

			if dist4<10000 and math.floor(CurTime()*2)==math.Round(CurTime()*2) and util.TraceLine({start = EyePos(),endpos = yellowpos4,filter = LocalPlayer(),mask = MASK_OPAQUE}).Fraction==1 then
				mat:SetInt("$ignorez",0)
					render.SetMaterial(mat)
					render.DrawSprite(yellowpos4,128,128,color4)
				mat:SetInt("$ignorez",1)
			end
		end

	end  

end