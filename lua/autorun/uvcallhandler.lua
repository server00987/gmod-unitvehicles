AddCSLuaFile()

--[[
Type 1 = Speeding
• Exceeding posted speed limits
Type 2 = Damage To Property
• Colliding with non-world entities
Type 3 = Hit And Run
• Colliding with vehicles
Type 4 = Street Racing
• Commiting either of the crimes above with multiple potential suspects
]]

local dvd = DecentVehicleDestination

if SERVER then

    UVTimeToCheckForPotentialSuspects = CurTime()
    
    --hook.Add("Think", "UVCheckForCalls", function()
    timer.Create("UVCheckForCalls", 2, 0, function()
        for _, ent in ents.Iterator() do
            if UVPassConVarFilter(ent) and not table.HasValue(UVPotentialSuspects, ent) then
                table.insert(UVPotentialSuspects, ent)
                ent:CallOnRemove( "UVWantedPotentialSuspectRemoved", function(vehicle)
                    if table.HasValue(UVPotentialSuspects, vehicle) then
                        table.RemoveByValue(UVPotentialSuspects, vehicle)
                    end
                end)
            end
        end

        local timeout = 3
        local ctimeout = 1
        
        if CurTime() > UVTimeToCheckForPotentialSuspects + timeout then --Check for potential suspects
            if #ents.FindByClass("npc_trafficvehicle") < UVTMaxTraffic:GetInt() then
                if UVTSpawnCondition:GetInt() == 3 then
                    UVAutoSpawnTraffic()
                elseif UVTSpawnCondition:GetInt() == 2 and next(UVPotentialSuspects) ~= nil then
                    UVAutoSpawnTraffic()
                end
            end

            UVCheckForSpeeders()
            UVTimeToCheckForPotentialSuspects = CurTime()
        end
        
        if GetConVar("ai_ignoreplayers"):GetBool() or not GetConVar("unitvehicle_callresponse"):GetBool() or UVTargeting or uvcallexists then
            if UVCallLocation and UVTargeting then --Remove the call, allow for new calls to come in
                UVCallLocation = nil
            end
            if UVPreInfractionCount and UVPreInfractionCount > 0 then
                UVPreInfractionCount = 0
            end
        end
        
    end)
    
    function UVCheckForSpeeders()
        if next(UVPotentialSuspects) == nil or next(dvd.Waypoints) == nil then return end
        
        local SpeedTable = {}
        
        for k, v in pairs(UVPotentialSuspects) do
            local speed = v:GetVelocity():Length2DSqr()
            table.insert(SpeedTable, speed)
        end
        
        local fastestSpeeder = table.GetWinningKey(SpeedTable)
        local suspect = UVPotentialSuspects[fastestSpeeder]
        local speed = SpeedTable[fastestSpeeder]
        
        if next(dvd.Waypoints) == nil then
            local Waypoint = dvd.GetNearestWaypoint(suspect:WorldSpaceCenter())
            local speedLimitMph = Waypoint["SpeedLimit"]
            SpeedLimit = speedLimitMph^2
        else
            SpeedLimit = (GetConVar("unitvehicle_speedlimit"):GetFloat()*17.6)^2
        end
        
        if speed > (SpeedLimit+30976) then
            UVPreInfractionCount = UVPreInfractionCount + 1
            if UVPreInfractionCount >= 10 then
                UVCallInitiate(suspect, 1)
            end
        end
        
    end
    
    function UVCallInitiate(suspectvehicle, type)
        if not GetConVar("unitvehicle_callresponse"):GetBool() or UVTargeting or uvcallexists then return end
        
        UVPreInfractionCount = 0
        
        uvcallexists = true
        
        local calllocation = suspectvehicle:GetPos()+(vector_up * 50)
        
        if GetConVar("unitvehicle_chattertext"):GetBool() then
            Entity(1):EmitSound("ui/pursuit/spotting_start.wav", 0, 100, 0.5)
        end
        
        if #UVPotentialSuspects > 1 then --Multiple suspects
            type = 4
        end
        
        local timecheck = 5
        
        if type == 1 then --Speeding
            if GetConVar("unitvehicle_chatter"):GetBool() then
                timecheck = UVChatterDispatchCallSpeeding(UVHeatLevel)
            end
        elseif type == 2 then --Damage To Property
            if GetConVar("unitvehicle_chatter"):GetBool() then
                timecheck = UVChatterDispatchCallDamageToProperty(UVHeatLevel)
            end
        elseif type == 3 then --Hit and Run
            if GetConVar("unitvehicle_chatter"):GetBool() then
                timecheck = UVChatterDispatchCallHitAndRun(UVHeatLevel)
            end
        elseif type == 4 then --Street Racing
            if GetConVar("unitvehicle_chatter"):GetBool() then
                timecheck = UVChatterDispatchCallStreetRacing(UVHeatLevel)
            end
        end
        
        timer.Simple(0.5, function()
            UVApplyHeatLevel()
            UVUpdateHeatLevel()
            UVAutoSpawn()
            uvIdleSpawning = CurTime()
            UVPresenceMode = true
            UVRestoreResourcePoints()
        end)
        
        timer.Simple(timecheck, function()
            if type ~= 4 then
                UVCallReportDescription(suspectvehicle, calllocation)
            else
                UVCallRespond(suspectvehicle, true) --No questions asked
                UVCallLocation = calllocation
            end
        end)
        
    end
    
    function UVCallReportDescription(suspectvehicle, calllocation)
        
        if UVTargeting then return end
        
        local timecheck = 5

        
        if next(ents.FindByClass("npc_uv*" )) ~= nil and GetConVar("unitvehicle_chatter"):GetBool() then
            local units = ents.FindByClass("npc_uv*" )
            local random_entry = math.random(#units)	
            local unit = units[random_entry]
            timecheck = UVChatterCallRequestDescription(unit)
            timer.Simple(timecheck, function()
                if not IsValid(suspectvehicle) or UVTargeting then return end
                local timecheck2 = 5
                local mathdescription = math.random(1,2)
                if mathdescription == 1 then --Known description
                    if next(ents.FindByClass("npc_uv*" )) ~= nil and GetConVar("unitvehicle_chatter"):GetBool() then
                        local e = UVGetVehicleMakeAndModel(suspectvehicle)
                        local units = ents.FindByClass("npc_uv*" )
                        local random_entry = math.random(#units)	
                        local unit = units[random_entry]
                        timecheck2 = UVChatterDispatchCallVehicleDescription(unit, suspectvehicle, e)
                    end
                    timer.Simple(timecheck2 or 5, function()
                        UVCallRespond(suspectvehicle)
                        UVCallLocation = calllocation
                    end)
                else --Unknown description
                    if next(ents.FindByClass("npc_uv*" )) ~= nil and GetConVar("unitvehicle_chatter"):GetBool() then
                        local units = ents.FindByClass("npc_uv*" )
                        local random_entry = math.random(#units)	
                        local unit = units[random_entry]
                        timecheck2 = UVChatterDispatchCallUnknownDescription(unit)
                    end
                    timer.Simple(timecheck2 or 5, function()
                        UVCallRespond(suspectvehicle)
                        UVCallLocation = calllocation
                    end)
                end
            end)
        end
        
    end
    
    function UVCallRespond(suspectvehicle)

        uvcallexists = nil
        
        if UVTargeting then return end
        
        if next(ents.FindByClass("npc_uv*" )) == nil then return end
        
        if GetConVar("unitvehicle_chatter"):GetBool() then
            local units = ents.FindByClass("npc_uv*" )
            local random_entry = math.random(#units)	
            local unit = units[random_entry]
            UVChatterCallResponding(unit)
        end
        
        for k, v in pairs(UVPotentialSuspects) do
            UVAddToWantedListVehicle(v)
        end
        
    end
    
else
    
    net.Receive("UVHUDWanted", function()
        local soundfiles = file.Find("sound/ui/pursuit/wanted/*", "GAME" )
        if not soundfiles or #soundfiles == 0 then return end
        surface.PlaySound("ui/pursuit/wanted/"..soundfiles[math.random(1, #soundfiles)])
        
        if Glide then
            Glide.Notify( {
                text = "#uv.hud.popup.wanted",
                icon = "unitvehicles/icons/MILESTONE_PURSUIT.png",
                sound = "glide/ui/phone_notify.wav",
                lifetime = 5
            } )
        else
            chat.AddText(Color(255,0,0), language.GetPhrase("uv.hud.popup.wanted"))
        end
        
    end)
    
end