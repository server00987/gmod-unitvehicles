AddCSLuaFile()

if CLIENT then
    
    net.Receive("UVHUDRepairCooldown", function() --Inform the player when the repair shop can be used again
        local timeleft = net.ReadInt(32)
        chat.AddText(Color(255, 0, 0), "Repair unavailable, come back in ", Color(255, 255, 255), timeleft.." s")
        surface.PlaySound("ui/pursuit/repairunavailable.wav")
    end)

    net.Receive("UVHUDRepair", function()
        chat.AddText(Color(0, 255, 0), "Vehicle repaired")
        surface.PlaySound("ui/pursuit/repair.wav")
    end)

    net.Receive("UVHUDRepairAvailable", function()
        chat.AddText(Color(0, 255, 0), "Repair Shop now available")
        surface.PlaySound("ui/pursuit/repairavailable.wav")
    end)

    net.Receive("uvrepairsimfphys", function()
        local veh = net.ReadEntity()
	    if not IsValid( veh ) then return end
	    veh:Backfire( false )
        veh.DamageSnd:Stop()
    end)

end