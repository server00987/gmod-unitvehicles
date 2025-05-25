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
    
    util.AddNetworkString( "UVHUDWanted" )
    
    hook.Add("Think", "UVCheckForCalls", function()
        for _, ent in ents.Iterator() do
            if UVPassConVarFilter(ent) and !table.HasValue(uvpotentialsuspects, ent) then
                table.insert(uvpotentialsuspects, ent)
                ent:CallOnRemove( "UVWantedPotentialSuspectRemoved", function(vehicle)
                    if table.HasValue(uvpotentialsuspects, vehicle) then
                        table.RemoveByValue(uvpotentialsuspects, vehicle)
                    end
                end)
            end
        end
        
        if GetConVar("ai_ignoreplayers"):GetBool() or !GetConVar("unitvehicle_callresponse"):GetBool() or uvtargeting or uvcallexists then
            if uvcalllocation and uvtargeting then --Remove the call, allow for new calls to come in
                uvcalllocation = nil
            end
            if uvpreinfractioncount and uvpreinfractioncount > 0 then
                uvpreinfractioncount = 0
            end
            return 
        end
        
        if !uvtimetocheckforpotentialsuspects then
            uvtimetocheckforpotentialsuspects = CurTime()
        end
        
        local timeout = 3
        local ctimeout = 1
        
        if CurTime() > uvtimetocheckforpotentialsuspects + timeout then --Check for potential suspects
            -- for _, ent in ents.Iterator() do
            --     if UVPassConVarFilter(ent) and !table.HasValue(uvpotentialsuspects, ent) then
            --         table.insert(uvpotentialsuspects, ent)
            --         ent:CallOnRemove( "UVWantedPotentialSuspectRemoved", function(vehicle)
            --             if table.HasValue(uvpotentialsuspects, vehicle) then
            --                 table.RemoveByValue(uvpotentialsuspects, vehicle)
            --             end
            --         end)
            --     end
            -- end
            UVCheckForSpeeders()
            uvtimetocheckforpotentialsuspects = CurTime()
        end
        
    end)
    
    function UVCheckForSpeeders()
        if next(uvpotentialsuspects) == nil or next(dvd.Waypoints) == nil then return end
        
        local SpeedTable = {}
        
        for k, v in pairs(uvpotentialsuspects) do
            local speed = v:GetVelocity():Length2DSqr()
            table.insert(SpeedTable, speed)
        end
        
        local fastestspeeder = table.GetWinningKey(SpeedTable)
        local suspect = uvpotentialsuspects[fastestspeeder]
        local speed = SpeedTable[fastestspeeder]
        
        if next(dvd.Waypoints) == nil then
            local Waypoint = dvd.GetNearestWaypoint(suspect:WorldSpaceCenter())
            local speedlimitmph = Waypoint["SpeedLimit"]
            speedlimit = speedlimitmph^2
        else
            speedlimit = (GetConVar("unitvehicle_speedlimit"):GetFloat()*17.6)^2
        end
        
        if speed > (speedlimit+30976) then
            uvpreinfractioncount = uvpreinfractioncount + 1
            if uvpreinfractioncount >= 10 then
                UVCallInitiate(suspect, 1)
            end
        end
        
    end
    
    function UVCallInitiate(suspectvehicle, type)
        if !GetConVar("unitvehicle_callresponse"):GetBool() or uvtargeting or uvcallexists then return end
        
        uvpreinfractioncount = 0
        
        uvcallexists = true
        
        local calllocation = suspectvehicle:GetPos()+Vector(0,0,50)
        
        if GetConVar("unitvehicle_chattertext"):GetBool() then
            Entity(1):EmitSound("ui/pursuit/spotting_start.wav", 0, 100, 0.5)
        end
        
        if #uvpotentialsuspects > 1 then --Multiple suspects
            type = 4
        end
        
        local timecheck = 5
        
        if type == 1 then --Speeding
            if GetConVar("unitvehicle_chatter"):GetBool() then
                timecheck = UVChatterDispatchCallSpeeding(uvheatlevel)
            end
        elseif type == 2 then --Damage To Property
            if GetConVar("unitvehicle_chatter"):GetBool() then
                timecheck = UVChatterDispatchCallDamageToProperty(uvheatlevel)
            end
        elseif type == 3 then --Hit and Run
            if GetConVar("unitvehicle_chatter"):GetBool() then
                timecheck = UVChatterDispatchCallHitAndRun(uvheatlevel)
            end
        elseif type == 4 then --Street Racing
            if GetConVar("unitvehicle_chatter"):GetBool() then
                timecheck = UVChatterDispatchCallStreetRacing(uvheatlevel)
            end
        end
        
        timer.Simple(0.5, function()
            UVApplyHeatLevel()
            UVUpdateHeatLevel()
            UVAutoSpawn()
            uvidlespawning = CurTime()
            uvpresencemode = true
            UVRestoreResourcePoints()
        end)
        
        timer.Simple(timecheck, function()
            if type != 4 then
                UVCallReportDescription(suspectvehicle, calllocation)
            else
                UVCallRespond(suspectvehicle, true) --No questions asked
                uvcalllocation = calllocation
            end
        end)
        
    end
    
    function UVCallReportDescription(suspectvehicle, calllocation)
        
        if uvtargeting then return end
        
        local timecheck = 5
        
        if next(ents.FindByClass("npc_uv*" )) ~= nil and GetConVar("unitvehicle_chatter"):GetBool() then
            local units = ents.FindByClass("npc_uv*" )
            local random_entry = math.random(#units)	
            local unit = units[random_entry]
            timecheck = UVChatterCallRequestDescription(unit)
        end
        
        timer.Simple(timecheck, function()
            if !IsValid(suspectvehicle) or uvtargeting then return end
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
                timer.Simple(timecheck2, function()
                    UVCallRespond(suspectvehicle)
                    uvcalllocation = calllocation
                end)
            else --Unknown description
                if next(ents.FindByClass("npc_uv*" )) ~= nil and GetConVar("unitvehicle_chatter"):GetBool() then
                    local units = ents.FindByClass("npc_uv*" )
                    local random_entry = math.random(#units)	
                    local unit = units[random_entry]
                    timecheck2 = UVChatterDispatchCallUnknownDescription(unit)
                end
                timer.Simple(timecheck2, function()
                    UVCallRespond(suspectvehicle)
                    uvcalllocation = calllocation
                end)
            end
        end)
        
    end
    
    function UVCallRespond(suspectvehicle)
        
        if uvtargeting then return end
        
        uvcallexists = nil
        
        if next(ents.FindByClass("npc_uv*" )) == nil then return end
        
        if next(ents.FindByClass("npc_uv*" )) ~= nil and GetConVar("unitvehicle_chatter"):GetBool() then
            local units = ents.FindByClass("npc_uv*" )
            local random_entry = math.random(#units)	
            local unit = units[random_entry]
            UVChatterCallResponding(unit)
        end
        
        for k, v in pairs(uvpotentialsuspects) do
            UVAddToWantedListVehicle(v)
        end
        
    end
    
else
    
    net.Receive("UVHUDWanted", function()
        local soundfiles = file.Find("sound/ui/pursuit/wanted/*", "GAME" )
        if !soundfiles or #soundfiles == 0 then return end
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