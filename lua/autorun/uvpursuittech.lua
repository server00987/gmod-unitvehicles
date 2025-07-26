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

        local userString = language.GetPhrase("uv.ptech.killswitch.hit")
        local targetString = language.GetPhrase("uv.ptech.killswitch.hit.you")

        UV_UI.general.events.CenterNotification({
            text = string.format( (displayMe and userString) or targetString, (displayMe and language.GetPhrase( tbl.Target )) or language.GetPhrase( tbl.User )),
			color = not displayMe and Color(255, 0, 0) or nil,
			immediate = not displayMe and true or nil,
			critical = not displayMe and true or nil,
		})
    end,
    Locking = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "#uv.ptech.killswitch.activated"
        local targetString = "#uv.ptech.killswitch.lockingon"

        UV_UI.general.events.CenterNotification({
            text = (displayMe and userString) or targetString,
			color = not displayMe and Color(255, 0, 0) or nil,
			immediate = not displayMe and true or nil,
        })
    end,
    Counter = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end
		local String = "#uv.ptech.killswitch.dodged"
		
        UV_UI.general.events.CenterNotification({
            text = String,
        })
    end,
    EngineRestarting = function(tbl)
        local userString = "#uv.ptech.killswitch.engine.on"

        UV_UI.general.events.CenterNotification({
            text = userString,
			immediate = true,
			critical = true,
        })
    end,
    NoTarget = function(tbl)
        local userString = "#uv.ptech.killswitch.novalid"

        UV_UI.general.events.CenterNotification({
            text = userString,
			-- immediate = true,
			-- critical = true,
        })
    end,
    TooFar = function(tbl)
        local userString = "#uv.ptech.killswitch.getclose"

        UV_UI.general.events.CenterNotification({
            text = userString,
			-- immediate = true,
			-- critical = true,
        })
    end
}
UV_PT.ESF = {
    Use = function(tbl)
        local userString = "#uv.ptech.esf.activated"

        UV_UI.general.events.CenterNotification({
            text = userString,
        })
    end,
    Deactivate = function(tbl)
        local userString = "ESF Deactivated!"

        -- UV_UI.general.events.CenterNotification({
            -- text = userString,
        -- })
    end,
    Hit = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = language.GetPhrase("uv.ptech.esf.hit")
        local targetString = language.GetPhrase("uv.ptech.esf.hit.you")

        UV_UI.general.events.CenterNotification({
            text = string.format( (displayMe and userString) or targetString, (displayMe and language.GetPhrase( tbl.Target )) or language.GetPhrase( tbl.User )),
        })
    end,
    Counter = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "You ESF-countered %s!"
        local targetString = "%s countered your ESF!"

        UV_UI.general.events.CenterNotification({
            text = string.format( (displayMe and userString) or targetString, (displayMe and language.GetPhrase( tbl.Target )) or language.GetPhrase( tbl.User )),
        })
    end
}
UV_PT.Jammer = {
    Use = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "#uv.ptech.jammer.activated"
        local targetString = "#uv.ptech.jammer.hit.you"

        UV_UI.general.events.CenterNotification({
            text = string.format( (displayMe and userString) or targetString, (displayMe and language.GetPhrase( tbl.Target )) or language.GetPhrase( tbl.User )),
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
		
		local userString = language.GetPhrase("uv.ptech.shockwave.hit")
		local targetString = language.GetPhrase("uv.ptech.shockwave.hit.you")

        local display = nil

        if displayMe then
            local targets = tbl.Target or {}
		    local firstName = targets[1] or "UNKNOWN"
		    local extraCount = #targets - 1

		-- Build name string: "Name" or "Name (+X)"
		    display = firstName
		    if extraCount > 0 then
			    display = string.format("%s (+%d)", language.GetPhrase( firstName ), extraCount)
		    end
        else
            display = language.GetPhrase( tbl.User )
        end

		-- Format text with nameDisplay
		local formattedText = string.format(
			(displayMe and userString) or targetString,
			display
		)

		-- Trigger notification
		UV_UI.general.events.CenterNotification({
			text = formattedText,
		})

    end,
    Use = function(...)
        local userString = "#uv.ptech.shockwave.activated"

        UV_UI.general.events.CenterNotification({
            text = userString,
        })
    end
}
UV_PT.Spikestrip = {
    Use = function(tbl)
        local userString = "#uv.ptech.spikes.activated"

        UV_UI.general.events.CenterNotification({
            text = userString,
        })
    end,
    Hit = function(tbl)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = "%s hit your spikestrips!"
        local targetString = "You hit %s's spikestrips!"

        -- UV_UI.general.events.CenterNotification({
            -- text = string.format( (displayMe and userString) or targetString, (displayMe and tbl.Target) or tbl.User),
        -- })
    end
}
UV_PT.StunMine = {
    Hit = function(tbl)
        --print(tbl.User, tbl.Target)
        local displayMe = false
        if tbl.User == LocalPlayer():Nick() then
            displayMe = true
        end

        local userString = language.GetPhrase("uv.ptech.stunmine.hit")
        local targetString = language.GetPhrase("uv.ptech.stunmine.hit.you")

        UV_UI.general.events.CenterNotification({
            text = string.format( (displayMe and userString) or targetString, (displayMe and language.GetPhrase( tbl.Target )) or language.GetPhrase( tbl.User ) ),
        })
    end,
    Counter = function(tbl)
        -- local displayMe = false
        -- if tbl.User ~= LocalPlayer():Nick() then
            -- displayMe = true
        -- end

        -- local userString = "You Stun mine-countered %s!"
        -- local targetString = "%s countered your stun mine!"

        -- UV_UI.general.events.CenterNotification({
            -- text = string.format( (displayMe and userString) or targetString, (displayMe and tbl.Target) or tbl.User),
        -- })
    end,
    Use = function(tbl)
        local userString = "#uv.ptech.stunmine.activated"

        UV_UI.general.events.CenterNotification({
            text = userString,
        })
    end,
}
UV_PT.RepairKit = {
    Use = function(...)
        local userString = "#uv.ptech.repairkit.activated"

        UV_UI.general.events.CenterNotification({
            text = userString,
        })
    end
}

--

function onEvent( self, eventType, ... )
    local event = UV_PT[self] and UV_PT[self][eventType]
    if event then event( ... ) end
end

hook.Add( "onPTEvent", "PT", onEvent )