if SERVER then return end

local PURSUIT_TECH_TYPES = {}
local UV_PT = {}

--

UV_PT.Killswitch = {
    Hit = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "You killswitched %s!"
        local targetString = "%s killswitched you!"

        UV_UI.racing.mostwanted.events.CenterNotification({
            text = string.format( (displayMe and userString) or targetString, (displayMe and tbl.Target) or tbl.User),
            textNoFall = true,
            noIcon = true,
            immediate = true
        })
    end,
    Locking = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "Locking onto %s..."
        local targetString = "%s is locking onto you!"

        UV_UI.racing.mostwanted.events.CenterNotification({
            text = string.format( (displayMe and userString) or targetString, (displayMe and tbl.Target) or tbl.User),
            textNoFall = true,
            noIcon = true,
            immediate = true
        })
    end,
    Counter = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "Killswitch failed!"
        local targetString = "You countered %s!"

        UV_UI.racing.mostwanted.events.CenterNotification({
            text = string.format( (displayMe and userString) or targetString, (displayMe and tbl.Target) or tbl.User),
            textNoFall = true,
            noIcon = true,
            immediate = true
        })
    end,
    EngineRestarting = function(tbl)
        -- local tbl = select(1, ...)

        -- local displayMe = false
        -- if tbl.User == LocalPlayer():Nick() then
        --     displayMe = true
        -- end

        local userString = "Restarting engine..."
        local targetString = "You countered %s!"

        UV_UI.racing.mostwanted.events.CenterNotification({
            text = userString,
            textNoFall = true,
            noIcon = true,
            immediate = true
        })
    end
}
UV_PT.ESF = {
    Use = function(tbl)
        local userString = "ESF Activated!"

        UV_UI.racing.mostwanted.events.CenterNotification({
            text = userString,
            textNoFall = true,
            noIcon = true,
            immediate = true
        })
    end,
    Deactivate = function(tbl)
        local userString = "ESF Deactivated!"

        UV_UI.racing.mostwanted.events.CenterNotification({
            text = userString,
            textNoFall = true,
            noIcon = true,
            immediate = true
        })
    end,
    Hit = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "You hit %s with ESF!"
        local targetString = "%s hit you with ESF!"

        UV_UI.racing.mostwanted.events.CenterNotification({
            text = string.format( (displayMe and userString) or targetString, (displayMe and tbl.Target) or tbl.User),
            textNoFall = true,
            noIcon = true,
            immediate = true
        })
    end,
    Counter = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "You ESF-countered %s!"
        local targetString = "%s countered your ESF!"

        UV_UI.racing.mostwanted.events.CenterNotification({
            text = string.format( (displayMe and userString) or targetString, (displayMe and tbl.Target) or tbl.User),
            textNoFall = true,
            noIcon = true,
            immediate = true
        })
    end
}
UV_PT.Jammer = {
    Use = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "Jammer activated!"
        local targetString = "You are being jammed!"

        UV_UI.racing.mostwanted.events.CenterNotification({
            text = string.format( (displayMe and userString) or targetString, (displayMe and tbl.Target) or tbl.User),
            textNoFall = true,
            noIcon = true,
            immediate = true
        })
    end,
    Hit = function(...)
        --not used, handled in use
        --print('Hit!', 'Jammer')
    end
}
UV_PT.Shockwave = {
    Hit = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "You hit %s with Shockwave!"
        local targetString = "You were hit with Shockwave!"

        UV_UI.racing.mostwanted.events.CenterNotification({
            text = string.format( (displayMe and userString) or targetString, table.concat(tbl.Target, ", ")),
            textNoFall = true,
            noIcon = true,
            immediate = true
        })
    end,
    Use = function(...)
        -- used but probably obsolete since shockwave is an instant effect
        --print('Use!', 'Shockwave')
    end
}
UV_PT.Spikestrip = {
    Use = function(tbl)
        local userString = "Dropped spikestrips!"

        UV_UI.racing.mostwanted.events.CenterNotification({
            text = userString,
            textNoFall = true,
            noIcon = true,
            immediate = true
        })
    end,
    Hit = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "%s hit your spikestrips!"
        local targetString = "You hit %s's spikestrips!"

        UV_UI.racing.mostwanted.events.CenterNotification({
            text = string.format( (displayMe and userString) or targetString, (displayMe and tbl.Target) or tbl.User),
            textNoFall = true,
            noIcon = true,
            immediate = true
        })
    end
}
UV_PT.StunMine = {
    Hit = function(tbl)
        --print(tbl.User, tbl.Target)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "You hit %s with Stun Mine!"
        local targetString = "%s hit you with Stun Mine!"

        UV_UI.racing.mostwanted.events.CenterNotification({
            text = string.format( (displayMe and userString) or targetString, (displayMe and tbl.Target) or tbl.User),
            textNoFall = true,
            noIcon = true,
            immediate = true
        })
    end,
    Counter = function(tbl)
        local displayMe = false
        if tbl.User ~= LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "You Stun mine-countered %s!"
        local targetString = "%s countered your stun mine!"

        UV_UI.racing.mostwanted.events.CenterNotification({
            text = string.format( (displayMe and userString) or targetString, (displayMe and tbl.Target) or tbl.User),
            textNoFall = true,
            noIcon = true,
            immediate = true
        })
    end,
    Use = function(tbl)
        local userString = "Stun mine dropped!"

        UV_UI.racing.mostwanted.events.CenterNotification({
            text = userString,
            textNoFall = true,
            noIcon = true,
            immediate = true
        })
    end,
}
UV_PT.RepairKit = {
    Use = function(...)
        local userString = "Repaired!"

        UV_UI.racing.mostwanted.events.CenterNotification({
            text = userString,
            textNoFall = true,
            noIcon = true,
            immediate = true
        })
    end
}

--

function onEvent( self, eventType, ... )
    local event = UV_PT[self] and UV_PT[self][eventType]
    if event then event( ... ) end
end

hook.Add( "onPTEvent", "PT", onEvent )