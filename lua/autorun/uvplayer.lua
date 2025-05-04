AddCSLuaFile()

local dvd = DecentVehicleDestination

local temp_keybinds = {
    [KEY_T] = 1,
    [KEY_P] = 2,
}

local keybind_requests = {}

hook.Add( "PlayerButtonDown", "PlayerButtonDownWikiExample2", function( ply, button )
    if CLIENT and not IsFirstTimePredicted() then
        return
    end
    
    if keybind_requests[ply] then
        local slot = keybind_requests[ply]
        keybind_requests[ply] = nil
        
        net.Start("UVGetNewKeybind")
        net.WriteInt(slot, 9)
        net.WriteInt(button, 9)
        net.Send(ply)
    end
end)

if SERVER then
    
    util.AddNetworkString('UVGetNewKeybind')
    util.AddNetworkString('UVPTKeybindRequest')
    
    util.AddNetworkString( "UVPTUse" )
    
    util.AddNetworkString( "UVWeaponESFEnable" )
    util.AddNetworkString( "UVWeaponESFDisable" )
    
    util.AddNetworkString( "UVWeaponJammerEnable" )
    util.AddNetworkString( "UVWeaponJammerDisable" )
    
    net.Receive( "UVPTKeybindRequest", function( len, ply )
        local slot = net.ReadInt( 3 )
        
        if !slot then return end
        keybind_requests[ply] = slot
    end)
    
    net.Receive( "UVPTUse", function( len, ply )
        local slot = net.ReadInt( 3 )
        
        if table.HasValue(uvplayerunittableplayers, ply) then --UNIT VEHICLES
            for k, car in pairs(uvplayerunittablevehicle) do
                if UVGetDriver(car) != ply or car.wrecked then continue end
                UVDeployWeapon( car, slot )
            end
        elseif next(uvrvwithpursuittech) != nil then --RACER VEHICLES
            for k, car in pairs(uvrvwithpursuittech) do
                if UVGetDriver(car) != ply or car.wrecked or car.uvbusted then continue end
                UVDeployWeapon( car, slot )
            end
        end
        
    end)
    
    function UVDeployWeapon(car, slot)
        if uvjammerdeployed and !car.jammerexempt then return end
        if !car.PursuitTech then return end
        
        local pursuit_tech = car.PursuitTech[slot]
        if !pursuit_tech then return end
        
        if pursuit_tech.Ammo <= 0 then return end
        
        local driver = car:GetDriver()
        
        if pursuit_tech.Tech == "Shockwave" then --SHOCKWAVE
            local Cooldown = pursuit_tech.Cooldown
            if CurTime() - pursuit_tech.LastUsed < Cooldown then return end
            
            if IsValid(driver) then
                driver:PrintMessage( HUD_PRINTCENTER, "Shockwave deployed!")
            end
            
            UVDeployShockwave(car)
            
            pursuit_tech.LastUsed = CurTime()
            pursuit_tech.Ammo = pursuit_tech.Ammo - 1
        elseif pursuit_tech.Tech == "ESF" then --ESF
            local Cooldown = pursuit_tech.Cooldown
            if CurTime() - pursuit_tech.LastUsed < Cooldown then return end
            car:RemoveCallOnRemove("uvesf"..car:EntIndex())
            
            UVDeployESF(car)
            
            pursuit_tech.LastUsed = CurTime()
            pursuit_tech.Ammo = pursuit_tech.Ammo - 1
            
            if IsValid(driver) then
                driver:PrintMessage( HUD_PRINTCENTER, "ESF deployed!")
            end
            
            car:EmitSound("gadgets/esf/start.wav")
            car:EmitSound("gadgets/esf/onloop.wav")
            
            timer.Simple(UVPTESFDuration:GetInt(), function()
                UVDeactivateESF(car)
            end)
            
            car:CallOnRemove("uvesf"..car:EntIndex(), function()
                UVDeactivateESF(car)
            end)
        elseif pursuit_tech.Tech == "Stunmine" then --MINE
            local Cooldown = pursuit_tech.Cooldown
            if CurTime() - pursuit_tech.LastUsed < Cooldown then return end
            
            UVDeployStunmine(car)
            
            if IsValid(driver) then
                driver:PrintMessage( HUD_PRINTCENTER, "Stunmine laid!")
            end
            
            pursuit_tech.LastUsed = CurTime()
            pursuit_tech.Ammo = pursuit_tech.Ammo - 1
        elseif pursuit_tech.Tech == "Jammer" then --JAMMER
            local Cooldown = pursuit_tech.Cooldown
            if CurTime() - pursuit_tech.LastUsed < Cooldown then return end
            
            UVDeployJammer(car)
            
            if IsValid(driver) then
                driver:PrintMessage( HUD_PRINTCENTER, "Jammer deployed!")
            end
            
            pursuit_tech.LastUsed = CurTime()
            pursuit_tech.Ammo = pursuit_tech.Ammo - 1
        elseif pursuit_tech.Tech == "Spikestrip" then --SPIKESTRIP
            local Cooldown = pursuit_tech.Cooldown
            if CurTime() - pursuit_tech.LastUsed < Cooldown then return end
            
            UVDeploySpikeStrip(car, !car.UnitVehicle)
            timer.Simple( .5, function()
                if IsValid(car) and (!uvjammerdeployed or car.exemptfromjammer) then
                    if (car.UnitVehicle and pursuit_tech.Upgraded) or (car.RacerVehicle) then
                        UVDeploySpikeStrip(car, !car.UnitVehicle)
                    end
                end
            end)
            
            pursuit_tech.LastUsed = CurTime()
            pursuit_tech.Ammo = pursuit_tech.Ammo - 1
            
            if IsValid(driver) then
                driver:PrintMessage( HUD_PRINTCENTER, "Spike strip deployed!")
            end
        elseif pursuit_tech.Tech == 'Repair Kit' then
            local Cooldown = pursuit_tech.Cooldown
            if CurTime() - pursuit_tech.LastUsed < Cooldown then return end
            
            local repaired = UVDeployRepairKit(car)
            
            if repaired then
                pursuit_tech.LastUsed = CurTime()
                pursuit_tech.Ammo = pursuit_tech.Ammo - 1
                
                if IsValid(driver) then
                    driver:PrintMessage( HUD_PRINTCENTER, "Repair Kit deployed!")
                end
            end
        elseif pursuit_tech.Tech == 'Killswitch' then
            local Cooldown = pursuit_tech.Cooldown
            if CurTime() - pursuit_tech.LastUsed < Cooldown then return end
            
            local result = UVDeployKillSwitch(car)

            if result then
                pursuit_tech.LastUsed = CurTime()
                pursuit_tech.Ammo = pursuit_tech.Ammo - 1
            end
        end
    end
    
    --SPIKESTRIP
    function UVDeploySpikeStrip(unit, racer)
        local spikes = ents.Create("entity_uvspikestrip")
        spikes.uvdeployed = true
        local timecheck
        if racer then
            timecheck = UVPTSpikeStripDuration:GetInt()
            spikes.racerdeployed = unit
        else
            timecheck = UVUnitPTSpikeStripDuration:GetInt()
        end
        local ph = unit:GetPhysicsObject()
        spikes:SetPos(unit:WorldSpaceCenter())
        if unit:GetClass() == "prop_vehicle_jeep" then
            spikes:SetAngles(ph:GetAngles())
        else
            spikes:SetAngles(ph:GetAngles()+Angle(0,90,0))
        end
        spikes:Spawn()
        spikes.PhysgunDisabled = false
        local phspikes = spikes:GetPhysicsObject()
        phspikes:EnableMotion(true)
        phspikes:SetVelocity(ph:GetVelocity())
        timer.Simple(timecheck, function() 
            if IsValid(spikes) then 
                if uvtargeting and !racer then
                    uvspikestripsdodged = uvspikestripsdodged + 1
                end
                spikes:Remove()
            end
        end)
    end
    
    --REPAIR KIT
    function UVDeployRepairKit(car)
        local is_repaired = false
        
        if car:GetClass() == "prop_vehicle_jeep" then
            if vcmod_main then
                if car:VC_getHealthMax() == car:VC_getHealth() then return end
                is_repaired = true
                car:EmitSound('ui/pursuit/repair.wav')
                car:VC_repairFull_Admin()
            else
                local mass = vehicle:GetPhysicsObject():GetMass()
			    vehicle:SetMaxHealth(mass)
			    vehicle:SetHealth(mass)
			    vehicle:StopParticles()
            end
        end
        if car.IsSimfphyscar then
            if car:GetCurHealth() == car:GetMaxHealth() then return end
            is_repaired = true
            car:EmitSound('ui/pursuit/repair.wav')
            car.simfphysoldhealth = car:GetMaxHealth()
            car:SetCurHealth(car:GetMaxHealth())
            car:SetOnFire( false )
            car:SetOnSmoke( false )
            
            net.Start( "simfphys_lightsfixall" )
            net.WriteEntity( car )
            net.Broadcast()
            
            net.Start( "uvrepairsimfphys" )
            net.WriteEntity( car )
            net.Broadcast()
            
            car:OnRepaired()
            
            if istable(car.Wheels) then
                for i = 1, table.Count( car.Wheels ) do
                    local Wheel = car.Wheels[ i ]
                    if IsValid(Wheel) then
                        Wheel:SetDamaged( false )
                    end
                end
            end
        end
        if car.IsGlideVehicle then
            local repaired = false
            
            for _, v in pairs(car.wheels) do
                if IsValid(v) and v.bursted then
                    repaired = true
                    v:_restore()
                end
            end
            
            if !repaired and car:GetChassisHealth() >= car.MaxChassisHealth then return end
            is_repaired = true
            car:EmitSound('ui/pursuit/repair.wav')
            car:Repair()
        end
        
        local driver = UVGetDriver(car)
        
        if driver then
            if driver:IsPlayer() then
                if driver:GetMaxHealth() == 100 then
                    driver:SetHealth(car:GetPhysicsObject():GetMass())
                    driver:SetMaxHealth(car:GetPhysicsObject():GetMass())
                end
            end
        end
        
        return is_repaired
    end
    
    --STUNMINE
    function UVDeployStunmine(unit)
        local mine = ents.Create("entity_uvstunmine")
        mine.uvdeployed = true
        mine.racerdeployed = unit
        local ph = unit:GetPhysicsObject()
        mine:SetPos(unit:WorldSpaceCenter())
        mine:SetAngles(ph:GetAngles())
        mine:Spawn()
        mine.PhysgunDisabled = false
        local phmine = mine:GetPhysicsObject()
        phmine:EnableMotion(true)
        phmine:SetVelocity(Vector(0,0,0))
        timer.Simple(60, function() 
            if IsValid(mine) then 
                mine:Remove()
            end
        end)
    end
    
    --ESF
    function UVDeployESF(unit)
        unit.esfon = true
        local e = EffectData()
        e:SetEntity(unit)
        util.Effect("entity_remove", e)
        net.Start("UVWeaponESFEnable")
        net.WriteEntity(unit)
        net.Broadcast()
    end
    
    function UVDeactivateESF(car)
        if !car.esfon then return end
        if IsValid(car) then
            car.esfon = nil
            net.Start("UVWeaponESFDisable")
            net.WriteEntity(car)
            net.Broadcast()
            car:StopSound("gadgets/esf/onloop.wav")
            local e = EffectData()
            e:SetEntity(car)
            util.Effect("entity_remove", e)
            car:EmitSound("gadgets/esf/off.wav")
            if !car.uvesfhit and car.uvesfdeployed and car.esfon then
                if isfunction(car.GetDriver) and IsValid(UVGetDriver(car)) and UVGetDriver(car):IsPlayer() then 
                    UVGetDriver(car):PrintMessage( HUD_PRINTCENTER, "ESF deactivated!")
                end
            end
            car.uvesfhit = nil
        end
    end
    
    function UVDeployKillSwitch(car)
        if next(uvwantedtablevehicle) != nil then
            car.uvkillswitchingtarget = nil
            
            local suspects = uvwantedtablevehicle
            local r = math.huge
            local closestdistancetosuspect, closestsuspect = r^2
            for i, w in pairs(suspects) do
                local carpos = car:WorldSpaceCenter()
                local distance = carpos:DistToSqr(w:WorldSpaceCenter())
                if distance < closestdistancetosuspect then
                    closestdistancetosuspect, closestsuspect = distance, w
                end
            end
            
            if closestdistancetosuspect < 250000 then
                car.uvkillswitchingtarget = closestsuspect
                car.uvkillswitching = true
                local MathSound = math.random(1,2)
                car:EmitSound("gadgets/killswitch/start"..MathSound..".wav")
                closestsuspect:EmitSound("gadgets/killswitch/startloop.wav")
                if isfunction(car.GetDriver) and IsValid(UVGetDriver(car)) and UVGetDriver(car):IsPlayer() then 
                    UVGetDriver(car):PrintMessage( HUD_PRINTCENTER, "Killswitch deployed!")
                end
                if isfunction(closestsuspect.GetDriver) and IsValid(closestsuspect:GetDriver()) and closestsuspect:GetDriver():IsPlayer() then 
                    closestsuspect:GetDriver():PrintMessage( HUD_PRINTCENTER, "YOU ARE GETTING KILLSWITCHED!")
                end
                timer.Simple(UVUnitPTKillSwitchLockOnTime:GetInt(), function() --HIT
                    if IsValid(car) and IsValid(car.uvkillswitchingtarget) then
                        if car.uvkillswitching and !car.uvkillswitchingtarget.enginedisabledbyuv then
                            car.uvkillswitching = nil
                            local kstime = UVUnitPTKillSwitchDisableDuration:GetInt()
                            local enemyvehicle = car.uvkillswitchingtarget
                            local enemycallsign = "Racer "..enemyvehicle:EntIndex()
                            local enemydriver = UVGetDriver(enemyvehicle)
                            
                            if enemydriver:IsPlayer() then
                                enemycallsign = enemydriver:GetName()
                            end
                            if enemyvehicle.IsSimfphyscar then
                                enemyvehicle:SetActive(false)
                            elseif enemyvehicle.IsGlideVehicle then
                                enemyvehicle:TurnOff()
                            elseif enemyvehicle:GetClass() == "prop_vehicle_jeep" then
                                enemyvehicle:StartEngine(false)
                            end
                            if isfunction(enemyvehicle.GetDriver) and IsValid(UVGetDriver(enemyvehicle)) and UVGetDriver(enemyvehicle):IsPlayer() then 
                                UVGetDriver(enemyvehicle):PrintMessage( HUD_PRINTCENTER, "YOU HAVE BEEN KILLSWITCHED!")
                            end
                            if isfunction(car.GetDriver) and IsValid(UVGetDriver(car)) and UVGetDriver(car):IsPlayer() then 
                                UVGetDriver(car):PrintMessage( HUD_PRINTCENTER, "KILLSWITCHED "..enemycallsign.."!")
                            end
                            
                            enemyvehicle.enginedisabledbyuv = true
                            car:StopSound("gadgets/killswitch/start1.wav")
                            car:StopSound("gadgets/killswitch/start2.wav")
                            enemyvehicle:StopSound("gadgets/killswitch/startloop.wav")
                            enemyvehicle:EmitSound("gadgets/killswitch/hit.wav")
                            timer.Simple(kstime, function() 
                                if IsValid(enemyvehicle) then
                                    if enemyvehicle.IsSimfphyscar then
                                        enemyvehicle:SetActive(true)
                                        enemyvehicle:StartEngine()
                                    elseif enemyvehicle.IsGlideVehicle then
                                        enemyvehicle:TurnOn()
                                    elseif enemyvehicle:GetClass() == "prop_vehicle_jeep" then
                                        enemyvehicle:StartEngine(true)
                                    end
                                    if isfunction(enemyvehicle.GetDriver) and IsValid(UVGetDriver(enemyvehicle)) and UVGetDriver(enemyvehicle):IsPlayer() then 
                                        UVGetDriver(enemyvehicle):PrintMessage( HUD_PRINTCENTER, "Engine restarted!")
                                    end
                                    enemyvehicle.enginedisabledbyuv = nil
                                end
                            end)
                            car.PursuitTechStatus = "Reloading"
                            timer.Simple(UVUnitPTDuration:GetInt(), function()
                                if IsValid(car) and car.uvkillswitchdeployed and !car.wrecked then
                                    car.uvkillswitchdeployed = nil
                                    car:EmitSound("buttons/button4.wav")
                                    car.PursuitTechStatus = "Ready"
                                end
                            end)
                            car.uvkillswitchingtarget = nil
                            if car.UnitVehicle then
                                UVChatterKillswitchHit(car.UnitVehicle)
                            end
                        end
                    end
                end)
                return true
            else
                car.uvkillswitchdeployed = nil
                car.uvkillswitchingtarget = nil
                if isfunction(car.GetDriver) and IsValid(UVGetDriver(car)) and UVGetDriver(car):IsPlayer() then 
                    UVGetDriver(car):PrintMessage( HUD_PRINTCENTER, "Get close to an enemy to killswitch them!")
                end

                return false
            end
            
        else
            car.uvkillswitchdeployed = nil
            car.uvkillswitchingtarget = nil
            if isfunction(car.GetDriver) and IsValid(UVGetDriver(car)) and UVGetDriver(car):IsPlayer() then 
                UVGetDriver(car):PrintMessage( HUD_PRINTCENTER, "There's no enemies to killswitch!")
            end

            return false
        end
    end
    
    function UVKillSwitchCheck(car)
        local enemy = car.uvkillswitchingtarget
        local AI = car.UnitVehicle
        
        if !IsValid(enemy) or (uvjammerdeployed and !car.exemptfromjammer) then
            UVDeactivateKillSwitch(car)
            return
        end
        
        local carpos = car:WorldSpaceCenter()
        local distance = carpos:DistToSqr(enemy:WorldSpaceCenter())
        
        if distance > 250000 then
            UVDeactivateKillSwitch(car)
        end
    end
    
    function UVDeactivateKillSwitch(car)
        if !car.uvkillswitching then return end
        car.uvkillswitching = nil
        local enemyvehicle = car.uvkillswitchingtarget
        if IsValid(enemyvehicle) then
            enemyvehicle:StopSound("gadgets/killswitch/startloop.wav")
            enemyvehicle:EmitSound("gadgets/killswitch/miss.wav")
            if isfunction(enemyvehicle.GetDriver) and IsValid(UVGetDriver(enemyvehicle)) and UVGetDriver(enemyvehicle):IsPlayer() then 
                UVGetDriver(enemyvehicle):PrintMessage( HUD_PRINTCENTER, "Killswitch countered!")
            end
        end
        car:StopSound("gadgets/killswitch/start1.wav")
        car:StopSound("gadgets/killswitch/start2.wav")
        if isfunction(car.GetDriver) and IsValid(UVGetDriver(car)) and UVGetDriver(car):IsPlayer() then 
            UVGetDriver(car):PrintMessage( HUD_PRINTCENTER, "Killswitch missed!")
        end
        car.PursuitTechStatus = "Reloading"
        timer.Simple(UVUnitPTDuration:GetInt(), function()
            if IsValid(car) and car.uvkillswitchdeployed and !car.wrecked then
                car.uvkillswitchdeployed = nil
                car:EmitSound("buttons/button4.wav")
                car.PursuitTechStatus = "Ready"
            end
        end)
        car.uvkillswitchingtarget = nil
        if car.UnitVehicle then
            UVChatterKillswitchMissed(car.UnitVehicle)
        end
    end
    
    --EMP
    function UVDeployEMP(car)
        
    end
    
    --SHOCKWAVE
    function UVDeployShockwave(car)
        local carchildren = car:GetChildren()
        local carconstraints = constraint.GetAllConstrainedEntities(car)
        local carpos = car:WorldSpaceCenter()
        local objects = ents.FindInSphere(carpos, 1000)
        for k, object in pairs(objects) do
            if object != car and (!table.HasValue(carchildren, object) and !table.HasValue(carconstraints, object) and IsValid(object:GetPhysicsObject()) or object.UnitVehicle or object.UVWanted or object:GetClass() == "entity_uv*" or object.uvdeployed) then
                local objectphys = object:GetPhysicsObject()
                local vectordifference = object:WorldSpaceCenter() - carpos
                local angle = vectordifference:Angle()
                local power = UVPTShockwavePower:GetFloat()
                local damage = UVPTShockwaveDamage:GetFloat()
                local force = power * (1 - (vectordifference:Length()/1000))
                objectphys:ApplyForceCenter(angle:Forward()*force)
                object.rammed = true
                timer.Simple(5, function()
                    if IsValid(object) then
                        object.rammed = nil
                    end
                end)
                if object.UnitVehicle then
                    local phmass = math.Round(objectphys:GetMass())
                    uvbounty = uvbounty+phmass
                    if object.IsSimfphyscar then
                        if object.UnitVehicle or object.UVWanted and !GetConVar("unitvehicle_autohealth"):GetBool() then
                            local MaxHealth = object:GetMaxHealth()
                            local damage = MaxHealth*damage
                            object:ApplyDamage( damage, DMG_GENERIC )
                        end
                    elseif object.IsGlideVehicle then
                        if object.UnitVehicle or (object.UVWanted and !GetConVar("unitvehicle_autohealth"):GetBool()) or !(object.UnitVehicle and object.UVWanted) then
                            object:SetEngineHealth( object:GetEngineHealth() - damage )
                            object:UpdateHealthOutputs()
                        end
                    elseif object:GetClass() == "prop_vehicle_jeep" then
                        
                    end
                end
            end
        end
        local MathSound = math.random(1,4)
        car:EmitSound( "gadgets/shockwave/"..MathSound..".wav" )
        local effect = EffectData()
        effect:SetEntity(car)
        util.Effect("entity_remove", effect)
        util.ScreenShake( carpos, 5, 5, 1, 1000 )
    end
    
    function UVDeployJammer(car)
        if uvjammerdeployed then return end
        
        uvjammerdeployed = true
        car.jammerdeployed = true
        car.jammerexempt = true
        
        if uvbackupontheway and !uvbackuptenseconds and uvresourcepointstimermax then
            uvresourcepointstimermax = uvresourcepointstimermax + 10
        end
        
        net.Start("UVWeaponJammerEnable")
        if UVGetDriver(car):IsPlayer() then
            net.WriteEntity(UVGetDriver(car))
        end
        net.Broadcast()
        
        car:EmitSound( "gadgets/jammer/loop2.wav" )
        
        car:CallOnRemove("UVJammerRemove", function()
            UVEndJammer(car)
        end)
        
        timer.Simple(UVPTJammerDuration:GetInt(), function()
            if IsValid(car) then
                UVEndJammer(car)
                car:RemoveCallOnRemove("UVJammerRemove")
            end
        end)
        
        for k, unit in pairs(ents.FindByClass("npc_uv*")) do
            if unit.v then
                UVDeactivateESF(unit.v)
                UVDeactivateKillSwitch(unit.v)
            end
        end
        
        for k, unitplayers in pairs(uvplayerunittablevehicle) do
            if IsValid(unitplayers) then
                UVDeactivateESF(uvplayerunittablevehicle)
                UVDeactivateKillSwitch(uvplayerunittablevehicle)
            end
        end
        
        for k, weapon in pairs(ents.FindByClass("entity_uv*")) do
            if weapon:GetClass() == "entity_uvrepairshop" then
                continue
            end
            if weapon:GetClass() == "entity_uvbombstrip" then
                weapon:BombExplode()
                continue
            end
            local f = EffectData()
            f:SetEntity(weapon)
            util.Effect("entity_remove", f)
            weapon:Remove()
        end
        
        UVSoundChatter(car, 1, "", 3)
        
    end
    
    function UVEndJammer(car)
        uvjammerdeployed = nil
        car.jammerexempt = nil
        net.Start("UVWeaponJammerDisable")
        if IsValid(UVGetDriver(car)) then
            net.WriteEntity(UVGetDriver(car))
        end
        net.Broadcast()
        car:StopSound( "gadgets/jammer/loop2.wav" )
        car:EmitSound( "gadgets/jammer/deactivate1.wav" )
        
        if uvtargeting then
            UVSoundChatter(car, 1, "dispatchjammerend", 8)
        end
    end
    
else
    
    net.Receive("UVWeaponJammerEnable", function()
        local ply = net.ReadEntity()
        if ply != LocalPlayer() then --VICTIM
            uvclientjammed = true
            surface.PlaySound( "gadgets/jammer/activate2.wav" )
            LocalPlayer():EmitSound("gadgets/jammer/loop1.wav", 100, 100, 1, CHAN_STATIC)
            hook.Add("RenderScreenspaceEffects", "UVJammedScreen", function()
                DrawMaterialOverlay( "effects/tvscreen_noise003a", 1 )
            end )
            notification.AddLegacy( "YOU'RE BEING JAMMED!", NOTIFY_ERROR, 10 )
        else --ATTACKER
            surface.PlaySound( "gadgets/jammer/activate1.wav" )
            notification.AddLegacy( "Jammer is now active!", NOTIFY_GENERIC, 10 )
        end
    end)
    
    net.Receive("UVWeaponJammerDisable", function()
        local ply = net.ReadEntity()
        if ply != LocalPlayer() then --VICTIM
            uvclientjammed = nil
            LocalPlayer():StopSound( "gadgets/jammer/loop1.wav" )
            surface.PlaySound( "gadgets/jammer/deactivate1.wav" )
        else --ATTACKER
            surface.PlaySound( "gadgets/jammer/deactivate2.wav" )
        end
        hook.Remove("RenderScreenspaceEffects", "UVJammedScreen")
    end)
    
    hook.Add("Think", "UVClientWeaponThink", function()
        if !UVWithESF then
            UVWithESF = {}
        end
    end)
    
    net.Receive("UVWeaponESFEnable", function()
        local unit = net.ReadEntity()
        table.insert(UVWithESF, unit)
    end)
    
    net.Receive("UVWeaponESFDisable", function()
        local unit = net.ReadEntity()
        table.RemoveByValue(UVWithESF, unit)
    end)
    
    hook.Add("PreDrawHalos", "UVWeaponESFShow", function()
        if !UVWithESF then UVWithESF = {} end
        if next(UVWithESF) == nil then return end
        halo.Add( UVWithESF, Color(255,255,255), 10, 10, 1 )
    end)
    
end