AddCSLuaFile()

--[[References (* = not used, yet)
TEN-CODE
10-1: Receiving poorly
10-2: Receiving well
10-3: Stop transmitting
10-4: Message received and understood
10-5: Relay message
10-6: Responding from a distance
10-7: Detailed, out of service
10-8: In service
10-9: Repeat message
10-10: Negative, standing by
10-11: Talking too rapidly
*10-12: Visitors present
10-13: Advise weather/road conditions
10-16: Urgent pickup at location
10-17: Urgent business
10-18: Anything for us?
10-19: Nothing for you, return to base
10-20: Current location
10-21: Call by landline
*10-22: Report in person to
10-23: On scene
10-24: Completed last assignment
10-25: Out of service
10-26: Going for fuel
10-27: Moving to different radio channel
10-28: Identify your station
10-29: Run for wants and warrants
10-32: Wanted suspect
10-33: Officer needs help
10-34: Requesting Pursuit/Interceptor unit
10-35: Confidential information
10-36: Police unit traffic collision
10-37: Requesting tow truck
10-38: Requesting ambulance
10-39: PIT maneuver
10-41: Self PIT
10-42: Traffic accident
10-43: Traffic jam
10-44: Requesting Special/Commander unit
10-45: Ramming suspect
10-50: Hit & Run
10-59: Herding
*10-60: What is next message number?
10-62: Unable to copy, use landline
10-63: Offset
10-65: Vehicle box
10-67: Spike strip
10-70: Requesting fire department
10-71: Requesting Air unit
10-73: Roadblock
10-75: Rolling roadblock
10-77: Negative contact
10-81: Speed Trap location
10-82: Rolling chicane
10-83: Set up quadrant
10-85: Backup
10-87: Vehicle/suspect pursuit
*10-90: Smoke screen
10-93: Check my frequency on this channel
10-96: Traffic stop
10-100: 5-minute break
UNIT REQUEST CODES
Air Support: Police Helicopter
PURSUIT STAGE CODES
Code 1: Situation under control
Code 2: ASAP, no lights or sirens(on)
Code 3: Emergency, lights and sirens(on)
Code 4: Suspect under arrest
Code 5: More units needed
Code 6: High-risk racer
Code 7: Change in Condition
Code 8: Suspect found
Code 10: Confidential information
PURSUIT CONDITIONS
*Condition 1: Heat level 1
Condition 2: Heat level 2
Condition 3: Heat level 3
Condition 4: Heat level 4
Condition 5: Heat level 5
Condition 6: Heat level 6
OTHER CODES
28/29: Run suspect for wants/warrants
51-50: Possible mental disorder
"Positive hit": Ran suspect has a criminal record
APB: All-points bulletin
*ACCI: Accident investigator
ASAP: As soon as possible
Assault PO: Assault on a police officer
DUI: Driving under the influence
EMS: Emergency medical services
ETA: Estimated time of arrival
*GD: General duty
*HAZMAT: Hazardous materials unit
HVT: High value target
KS: Kill switch
*MHA: Mental Health Act
MVA: Motor vehicle accident
NCIC: National Criminal Information Center
PC: Police car/cruiser
PDT: Portable data transmitter/terminal
PID: Positive identification
Primary: Unit behind suspect
RTB: Return to base
Secondary: Unit behind primary
TAC: Tactical radio channel
TC: Traffic collision
VCB: Visual contact broken
Wrecker: Tow truck
]]

if SERVER then
	
	util.AddNetworkString('UV_Chatter')
	util.AddNetworkString('UV_Sound')
	util.AddNetworkString('UV_Text')
	
	if !uvclassname then
		uvclassname = {"POLICE"}
	end
	
	file.AsyncRead('chatter/chatter.json', 'GAME', function( _, _, status, data )
		_uvchatterarray = util.JSONToTable(data)
	end, true)
	
	--Spam check--
	
	function UVRelayToClients( sound_name, param, can_skip )
		local array = {
			['FileName'] = sound_name,
			['Parameter'] = param,
			['CanSkip'] = can_skip
		}
		net.Start('UV_Chatter')
		net.WriteTable(array)
		--net.WriteBool(can_skip)
		--net.WriteInt(tonumber(param))
		net.Broadcast()
	end
	
	function UVRelaySoundToClients( sound_name, can_skip )
		local array = {
			['FileName'] = sound_name,
			['CanSkip'] = can_skip
		}
		net.Start('UV_Sound')
		net.WriteTable(array)
		--net.WriteBool(can_skip)
		--net.WriteInt(tonumber(param))
		net.Broadcast()
	end
	
	function UVDelayChatter(seconds)
		if UVChatterDelayed then return 5 end
		UVChatterDelayed = true
		if !seconds then
			seconds = 2
		end
		timer.Simple(seconds, function()
			UVChatterDelayed = false
		end)
		return seconds
	end
	
	--return 5 = no sound chatter
	function UVSoundChatter(self, voice, chattertype, parameters)
		
		--[[Voice Type
		1 = Undercover Dispatch
		2 = Undercover Helicopter (Air)
		3-8 = Undercover Local (Patrol, Support)
		9-10 = Undercover Federal (Special, Commander(one commander disabled))
		11 = Payback/Heat Rhino
		12 = Most Wanted Cross (Commander(one commander enabled))
		13-18 = Most Wanted Local (Pursuit, Interceptor)
		19 = Most Wanted Helicopter (Air)
		*Others are non-engaging support units. If both are included in the same folder(chattertype), it'd be a 50/50 chance.
		]]
		
		if !self or !voice or !chattertype or !(GetConVar("unitvehicle_chatter"):GetBool() and !GetConVar("unitvehicle_chattertext"):GetBool()) then return 5 end
		
		local soundtable
		voice = tostring(voice)
		
		if uvjammerdeployed then --Jammer deployed
			local soundtable2 = file.Find( "sound/chatter/!static/*", "GAME" )
			if next(soundtable2) == nil then return 5 end
			local soundfile2 = "chatter/!static/"..soundtable2[math.random(1, #soundtable2)]
			local soundduration2 = SoundDuration(soundfile2)
			
			-- if uvchatterplaying and parameters != 2 then
			-- 	Entity(1):StopSound(uvchatterplaying)
			-- end
			
			-- Entity(1):EmitSound(soundfile2, 75, 100, 1, CHAN_STATIC)
			-- uvchatterplaying = soundfile2
			UVRelayToClients(soundfile2, parameters, true)
			
			return 5
		end
		
		--[[Parameters
		1 = No voice restriction
		2 = Bullhorn
		3 = Static
		4 = Emergency
		5 = Identify
		6 = Call
		7 = Losing
		8 = Emergency (No voice restriction)
		]]
		
		if parameters == 1 then --No voice restriction

			local basedfiles, basedirectories = file.Find( "sound/chatter/!call/*", "GAME" )

			if next(basedirectories) == nil then return 5 end
			local basedirectory = basedirectories[math.random(1, #basedirectories)]
			
			soundtable = file.Find( "sound/chatter/"..chattertype.."/*", "GAME" )
			if next(soundtable) == nil then return 5 end
			local soundfile = "chatter/"..chattertype.."/"..soundtable[math.random(1, #soundtable)]
			
			local soundtable2 = file.Find( "sound/chatter/!call/"..basedirectory.."/chirpgeneric/*", "GAME" )
			if next(soundtable2) == nil then return 5 end
			local soundfile2 = "chatter/!call/"..basedirectory.."/chirpgeneric/"..soundtable2[math.random(1, #soundtable2)]
			
			-- if uvchatterplaying and parameters != 2 then
			-- 	Entity(1):StopSound(uvchatterplaying)
			-- end
			
			-- Entity(1):EmitSound(soundfile2, 75, 100, 1, CHAN_STATIC)
			-- Entity(1):EmitSound(soundfile, 75, 100, 1, CHAN_STATIC)
			UVRelayToClients(soundfile2, parameters, true)
			UVRelayToClients(soundfile, parameters, false)
			
			--uvchatterplaying = soundfile
			
			return UVDelayChatter((SoundDuration(soundfile)+math.random(1,2)))
			
		elseif parameters == 2 then --Bullhorn
			
			soundtable = file.Find( "sound/chatter/!bullhorn/"..chattertype.."/"..voice.."/*", "GAME" )
			if next(soundtable) == nil then return 5 end
			local soundfile = "chatter/!bullhorn/"..chattertype.."/"..voice.."/"..soundtable[math.random(1, #soundtable)]
			
			self:EmitSound(soundfile, 5000, 100, 1, CHAN_STATIC)
			
			return UVDelayChatter((SoundDuration(soundfile)+math.random(1,2)))
			
		elseif parameters == 3 then --Static
			
			soundtable = file.Find( "sound/chatter/"..chattertype.."/"..voice.."/*", "GAME" )
			if next(soundtable) == nil then return 5 end
			local soundfile = "chatter/"..chattertype.."/"..voice.."/"..soundtable[math.random(1, #soundtable)]
			local soundduration = SoundDuration(soundfile)
			
			local soundtable2 = file.Find( "sound/chatter/!static/*", "GAME" )
			if next(soundtable2) == nil then return 5 end
			local soundfile2 = "chatter/!static/"..soundtable2[math.random(1, #soundtable2)]
			local soundduration2 = SoundDuration(soundfile2)
			
			-- if uvchatterplaying and parameters != 2 then
			-- 	Entity(1):StopSound(uvchatterplaying)
			-- end
			
			-- Entity(1):EmitSound(soundfile2, 75, 100, 1, CHAN_STATIC)
			-- uvchatterplaying = soundfile2
			UVRelayToClients(soundfile2, parameters, true)
			
			timer.Simple(soundduration2, function()
				-- if uvchatterplaying and parameters != 2 then
				-- 	Entity(1):StopSound(uvchatterplaying)
				-- end
				-- Entity(1):EmitSound(soundfile, 75, 100, 1, CHAN_STATIC)
				-- uvchatterplaying = soundfile
				UVRelayToClients(soundfile, parameters, true)
			end)
			
			return UVDelayChatter((soundduration+soundduration2+math.random(1,2)))
			
		elseif parameters == 4 then --Emergency
			
			soundtable = file.Find( "sound/chatter/"..chattertype.."/"..voice.."/*", "GAME" )
			if next(soundtable) == nil then return 5 end
			local soundfile = "chatter/"..chattertype.."/"..voice.."/"..soundtable[math.random(1, #soundtable)]
			local soundduration = SoundDuration(soundfile)
			
			local soundfile2 = "chatter/!emergency/copresponse.mp3"
			local soundduration2 = SoundDuration(soundfile2)
			
			-- if uvchatterplaying and parameters != 2 then
			-- 	Entity(1):StopSound(uvchatterplaying)
			-- end
			
			-- Entity(1):EmitSound(soundfile2, 75, 100, 1, CHAN_STATIC)
			-- uvchatterplaying = soundfile2
			UVRelayToClients(soundfile2, parameters, true)
			
			timer.Simple(soundduration2, function()
				-- if uvchatterplaying and parameters != 2 then
				-- 	Entity(1):StopSound(uvchatterplaying)
				-- end
				-- Entity(1):EmitSound(soundfile, 75, 100, 1, CHAN_STATIC)
				-- uvchatterplaying = soundfile
				UVRelayToClients(soundfile, parameters, true)
			end)
			
			return UVDelayChatter((soundduration+soundduration2+math.random(1,2)))
			
		elseif parameters == 5 then --Identify
			
			soundtable = file.Find( "sound/chatter/"..chattertype.."/"..voice.."/*", "GAME" )
			if next(soundtable) == nil then return 5 end
			local soundfile = "chatter/"..chattertype.."/"..voice.."/"..soundtable[math.random(1, #soundtable)]
			local soundduration = SoundDuration(soundfile)
			
			local soundtable2 = file.Find( "sound/chatter/!identify/"..voice.."/*", "GAME" )
			if next(soundtable2) == nil then return 5 end
			local soundfile2 = "chatter/!identify/"..voice.."/"..soundtable2[math.random(1, #soundtable2)]
			local soundduration2 = SoundDuration(soundfile2)
			
			-- if uvchatterplaying and parameters != 2 then
			-- 	Entity(1):StopSound(uvchatterplaying)
			-- end
			
			-- Entity(1):EmitSound(soundfile2, 75, 100, 1, CHAN_STATIC)
			-- uvchatterplaying = soundfile2
			UVRelayToClients(soundfile2, parameters, true)
			
			timer.Simple(soundduration2, function()
				-- if uvchatterplaying and parameters != 2 then
				-- 	Entity(1):StopSound(uvchatterplaying)
				-- end
				-- Entity(1):EmitSound(soundfile, 75, 100, 1, CHAN_STATIC)
				-- uvchatterplaying = soundfile
				UVRelayToClients(soundfile, parameters, true)
				
			end)
			
			return UVDelayChatter((soundduration+soundduration2+math.random(1,2)))
			
		elseif parameters == 6 then --Call

			local basedfiles, basedirectories = file.Find( "sound/chatter/!call/*", "GAME" )

			if next(basedirectories) == nil then return 5 end
			local basedirectory = basedirectories[math.random(1, #basedirectories)]
			
			soundtable = file.Find( "sound/chatter/!call/"..basedirectory.."/"..chattertype.."/*", "GAME" )
			if next(soundtable) == nil then return 5 end
			local soundfile = "chatter/!call/"..basedirectory.."/"..chattertype.."/"..soundtable[math.random(1, #soundtable)]
			local soundduration = SoundDuration(soundfile)
			
			local soundfile2 = "chatter/!emergency/copresponse.mp3"
			local soundduration2 = SoundDuration(soundfile2)
			
			local soundtable3 = file.Find( "sound/chatter/!call/"..basedirectory.."/addressgroup/*", "GAME" )
			if next(soundtable3) == nil then return 5 end
			local soundfile3 = "chatter/!call/"..basedirectory.."/addressgroup/"..soundtable3[math.random(1, #soundtable3)]
			local soundduration3 = SoundDuration(soundfile3)
			
			local soundtable4 = file.Find( "sound/chatter/!call/"..basedirectory.."/d_location/*", "GAME" )
			if next(soundtable4) == nil then return 5 end
			local soundfile4 = "chatter/!call/"..basedirectory.."/d_location/"..soundtable4[math.random(1, #soundtable4)]
			local soundduration4 = SoundDuration(soundfile4)
			
			local soundtable5 = file.Find( "sound/chatter/!call/"..basedirectory.."/unitrequest/*", "GAME" )
			if next(soundtable5) == nil then return 5 end
			local soundfile5 = "chatter/!call/"..basedirectory.."/unitrequest/"..soundtable5[math.random(1, #soundtable5)]
			local soundduration5 = SoundDuration(soundfile5)
			
			-- if uvchatterplaying and parameters != 2 then
			-- 	Entity(1):StopSound(uvchatterplaying)
			-- end
			
			-- Entity(1):EmitSound(soundfile2, 75, 100, 1, CHAN_STATIC)
			-- uvchatterplaying = soundfile2
			UVRelayToClients(soundfile2, parameters, true)
			
			timer.Simple(soundduration2, function()
				-- if uvchatterplaying and parameters != 2 then
				-- 	Entity(1):StopSound(uvchatterplaying)
				-- end
				-- Entity(1):EmitSound(soundfile3, 75, 100, 1, CHAN_STATIC)
				-- uvchatterplaying = soundfile3
				UVRelayToClients(soundfile3, parameters, true)
				
				timer.Simple(soundduration3, function()
					-- if uvchatterplaying and parameters != 2 then
					-- 	Entity(1):StopSound(uvchatterplaying)
					-- end
					-- Entity(1):EmitSound(soundfile, 75, 100, 1, CHAN_STATIC)
					-- uvchatterplaying = soundfile
					UVRelayToClients(soundfile, parameters, true)
					
					timer.Simple(soundduration, function()
						-- if uvchatterplaying and parameters != 2 then
						-- 	Entity(1):StopSound(uvchatterplaying)
						-- end
						-- Entity(1):EmitSound(soundfile4, 75, 100, 1, CHAN_STATIC)
						-- uvchatterplaying = soundfile4
						UVRelayToClients(soundfile4, parameters, true)
						
						timer.Simple(soundduration4, function()
							-- if uvchatterplaying and parameters != 2 then
							-- 	Entity(1):StopSound(uvchatterplaying)
							-- end
							-- Entity(1):EmitSound(soundfile5, 75, 100, 1, CHAN_STATIC)
							-- uvchatterplaying = soundfile5
							UVRelayToClients(soundfile5, parameters, true)
							
						end)
					end)
				end)
			end)
			
			return UVDelayChatter((soundduration+soundduration2+soundduration3+soundduration4+soundduration5+math.random(1,2)))
			
		elseif parameters == 7 then --Losing

			local basedfiles, basedirectories = file.Find( "sound/chatter/!call/*", "GAME" )

			if next(basedirectories) == nil then return 5 end
			local basedirectory = basedirectories[math.random(1, #basedirectories)]
			
			local soundfile2 = "chatter/!emergency/copresponse.mp3"
			local soundduration2 = SoundDuration(soundfile2)
			
			local soundtable3 = file.Find( "sound/chatter/!call/"..basedirectory.."/dispbreakaway/*", "GAME" )
			if next(soundtable3) == nil then return 5 end
			local soundfile3 = "chatter/!call/"..basedirectory.."/dispbreakaway/"..soundtable3[math.random(1, #soundtable3)]
			local soundduration3 = SoundDuration(soundfile3)
			
			local soundtable4 = file.Find( "sound/chatter/!call/"..basedirectory.."/d_location/*", "GAME" )
			if next(soundtable4) == nil then return 5 end
			local soundfile4 = "chatter/!call/"..basedirectory.."/d_location/"..soundtable4[math.random(1, #soundtable4)]
			local soundduration4 = SoundDuration(soundfile4)
			
			local soundtable5 = file.Find( "sound/chatter/!call/"..basedirectory.."/quadrant/*", "GAME" )
			if next(soundtable5) == nil then return 5 end
			local soundfile5 = "chatter/!call/"..basedirectory.."/quadrant/"..soundtable5[math.random(1, #soundtable5)]
			local soundduration5 = SoundDuration(soundfile5)
			
			if !uvenemyescaping then return end
			-- if uvchatterplaying and parameters != 2 then
			-- 	Entity(1):StopSound(uvchatterplaying)
			-- end
			-- Entity(1):EmitSound(soundfile2, 75, 100, 1, CHAN_STATIC)
			-- uvchatterplaying = soundfile2
			UVRelayToClients(soundfile2, parameters, true)
			
			timer.Simple(soundduration2, function()
				if !uvenemyescaping then return end
				-- if uvchatterplaying and parameters != 2 then
				-- 	Entity(1):StopSound(uvchatterplaying)
				-- end
				-- Entity(1):EmitSound(soundfile3, 75, 100, 1, CHAN_STATIC)
				-- uvchatterplaying = soundfile3
				UVRelayToClients(soundfile3, parameters, true)
				
				timer.Simple(soundduration3, function()
					if !uvenemyescaping then return end
					-- if uvchatterplaying and parameters != 2 then
					-- 	Entity(1):StopSound(uvchatterplaying)
					-- end
					-- Entity(1):EmitSound(soundfile4, 75, 100, 1, CHAN_STATIC)
					-- uvchatterplaying = soundfile4
					UVRelayToClients(soundfile4, parameters, true)
					
					timer.Simple(soundduration4, function()
						if !uvenemyescaping then return end
						-- if uvchatterplaying and parameters != 2 then
						-- 	Entity(1):StopSound(uvchatterplaying)
						-- end
						-- Entity(1):EmitSound(soundfile5, 75, 100, 1, CHAN_STATIC)
						-- uvchatterplaying = soundfile5
						UVRelayToClients(soundfile5, parameters, true)
						
					end)
				end)
			end)
			
			return UVDelayChatter((soundduration2+soundduration3+soundduration4+soundduration5+math.random(1,2)))
			
		elseif parameters == 8 then --Emergency (No voice restriction)
			
			soundtable = file.Find( "sound/chatter/"..chattertype.."/*", "GAME" )
			if next(soundtable) == nil then return 5 end
			local soundfile = "chatter/"..chattertype.."/"..soundtable[math.random(1, #soundtable)]
			local soundduration = SoundDuration(soundfile)
			
			local soundfile2 = "chatter/!emergency/copresponse.mp3"
			local soundduration2 = SoundDuration(soundfile2)
			
			-- uvchatterplaying = soundfile
			
			-- if uvchatterplaying and parameters != 2 then
			-- 	Entity(1):StopSound(uvchatterplaying)
			-- end
			
			-- Entity(1):EmitSound(soundfile2, 75, 100, 1, CHAN_STATIC)
			-- uvchatterplaying = soundfile2
			UVRelayToClients(soundfile2, parameters, true)
			
			timer.Simple(soundduration2, function()
				-- if uvchatterplaying and parameters != 2 then
				-- 	Entity(1):StopSound(uvchatterplaying)
				-- end
				-- Entity(1):EmitSound(soundfile, 75, 100, 1, CHAN_STATIC)
				-- uvchatterplaying = soundfile
				UVRelayToClients(soundfile, parameters, true)
				
			end)
			
			return UVDelayChatter((soundduration+soundduration2+math.random(1,2)))
			
		end

		local basedfiles, basedirectories = file.Find( "sound/chatter/!call/*", "GAME" )

		if next(basedirectories) == nil then return 5 end
		local basedirectory = basedirectories[math.random(1, #basedirectories)]
		
		soundtable = file.Find( "sound/chatter/"..chattertype.."/"..voice.."/*", "GAME" )
		if next(soundtable) == nil then return 5 end
		local soundfile = "chatter/"..chattertype.."/"..voice.."/"..soundtable[math.random(1, #soundtable)]
		local soundtable2 = file.Find( "sound/chatter/!call/"..basedirectory.."/chirpgeneric/*", "GAME" )
		if next(soundtable2) == nil then return 5 end
		local soundfile2 = "chatter/!call/"..basedirectory.."/chirpgeneric/"..soundtable2[math.random(1, #soundtable2)]
		-- if uvchatterplaying and parameters != 2 then
		-- 	Entity(1):StopSound(uvchatterplaying)
		-- end
		-- Entity(1):EmitSound(soundfile2, 75, 100, 1, CHAN_STATIC)
		-- Entity(1):EmitSound(soundfile, 75, 100, 1, CHAN_STATIC)
		
		-- uvchatterplaying = soundfile
		UVRelayToClients(soundfile2, parameters, true)
		UVRelayToClients(soundfile, parameters, false)
		
		
		return UVDelayChatter((SoundDuration(soundfile)+math.random(1,2)))
		
	end
	
	-- 	List of variables:
	-- 	self.callsign = UNIT_CALLSIGN
	-- 	e = UNIT_SUSPECTMODEL
	-- 	uvclassname[math.random(1, #uvclassname)] = UNIT_CLASSES
	-- 	game.GetMap() = MAP_GET
	-- 	math.random(1,9) = MATH_RANDOM19
	-- 	math.random(1,1000) = MATH_RANDOMUNIT
	-- 	backuptimeleft = MATH_BACKUPTIMELEFT
	-- 	unit.callsign = UNIT_SECONDARYCALLSIGN
	-- 	color = UNIT_SUSPECTCOLOR
	-- 	model = UNIT_SUSPECTMAKE
	function _getFormatParam(param, unit, args)
		
		-- local variable_list = {
		-- 	['UNIT_CALLSIGN'] = (unit and unit.callsign) or nil,
		-- 	['UNIT_SUSPECTMODEL'] = args.suspectmodel,
		-- 	['UNIT_CLASSES'] = uvclassname[math.random(1, #uvclassname)],
		-- 	['MAP_GET'] = game.GetMap(),
		-- 	['MATH_RANDOM19'] = math.random(1,9),
		-- 	['MATH_RANDOMUNIT'] = math.random(1,1000),
		-- 	['MATH_BACKUPTIMELEFT'] = string.NiceTime(uvresourcepointstimerleft),
		-- 	['UNIT_SECONDARYCALLSIGN'] = args.altcallsign,
		-- 	['UNIT_SUSPECTCOLOR'] = args.suspectcolor,
		-- 	['UNIT_SUSPECTMAKE'] = args.suspectmake,
		-- }

		local variable_list = {
			['UNIT_CALLSIGN'] = {(unit and unit.callsign) or 'Unit', Color(53, 134, 255)},
			['UNIT_SUSPECTMODEL'] = {args.suspectmodel, Color(255, 54, 54)},
			['UNIT_CLASSES'] = {uvclassname[math.random(1, #uvclassname)], Color(255,255,255)},
			['MAP_GET'] = {game.GetMap(), Color(255,238,0)},
			['MATH_RANDOM19'] = {math.random(1,9), Color(255,255,255)},
			['MATH_RANDOMUNIT'] = {math.random(1,1000), Color(53, 134, 255)},
			['MATH_BACKUPTIMELEFT'] = {string.NiceTime(uvresourcepointstimerleft), Color(255,255,255)},
			['UNIT_SECONDARYCALLSIGN'] = {args.altcallsign, Color(53, 134, 255)},
			['UNIT_SUSPECTCOLOR'] = {args.suspectcolor, Color(255, 54, 54)},
			['UNIT_SUSPECTMAKE'] = {args.suspectmake, Color(255, 54, 54)},
		}
		
		return variable_list[param]
		
		--local sub_dir_count = select('#', ...)
	end
	
	function UVTextChatter(unit, args, ...) -- ... = directory to array with text/variables, since some entries are dictionaries
		if !GetConVar("unitvehicle_chattertext"):GetBool() then return end

		local format_arg_list = {}
		
		local sub_dir_count = select('#', ...)
		local array_pointer = _uvchatterarray
		
		for i = 1, sub_dir_count, 1 do
			local _target = array_pointer[select(i, ...)]
			
			if type(_target) == 'table' then
				array_pointer = _target
			else break end
		end
		if type(array_pointer) != 'table' then error('Improperly formatted JSON') return end
		
		--
		
		local option = array_pointer[math.random(1, #array_pointer)]
		local format_var_list = {}

		if !option then return end
		
		-- for _, var in pairs(option.variables) do
		-- 	table.insert(format_var_list, _getFormatParam(var, unit, args))
		-- end
		
		local txt = string.Split(option.text, "%s")
		local array = {}
		
		for i, v in pairs(option.variables) do
			if i == 1 then
				table.insert(array, Color(255,255,255))
			end

			local entry = _getFormatParam(v, unit, args)

			local color = entry[2]
			--local text = string.Replace(entry.text, v, var_list[v][1])
			for _, v in pairs({txt[i], color, entry[1], Color(242,242,242)}) do
				table.insert(array, v)
			end
			
			if i == #option.variables then
				for _, v in pairs({txt[#txt], color}) do
					table.insert(array, v)
				end
				-- table.insert(array, {txt[#txt], Color(255,255,255), txt[#txt], Color(255,255,255)})
			end
			--table.insert(array, {txt[i], color, var_list[v][1], Color(255,255,255)})
		end

		if #option.variables <  1 then
			for _, v in pairs({Color(189,189,189), option.text}) do
				table.insert(array, v)
			end
		end
		
		net.Start('UV_Text')
		net.WriteTable(array)
		net.Broadcast()
		--PrintMessage(HUD_PRINTTALK, string.format(option.text, unpack( format_var_list )))
	end
	
	--UV old chatter goes here--
	
	function UVChatterOnRemove(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "onremove")
		end
		if UVChatterDelayed then return end
		UVDelayChatter()
		if self.v.UVPatrol then
			UVTextChatter(self, {}, 'OnRemove', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, {}, 'OnRemove', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, {}, 'OnRemove', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, {}, 'OnRemove', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, {}, 'OnRemove', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, {}, 'OnRemove', 'UVCommander')
		end
	end
	
	function UVChatterArrest(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "arrest")
		end
		UVDelayChatter()
		if !IsValid(self.e) then return end
		local e = UVGetVehicleMakeAndModel(self.e)

		if self.v then
			if self.v.UVPatrol then
				UVTextChatter(self, {['suspectmodel'] = e}, 'Arrest', 'UVPatrol')
			elseif self.v.UVSupport then
				UVTextChatter(self, {['suspectmodel'] = e}, 'Arrest', 'UVSupport')
			elseif self.v.UVPursuit then
				UVTextChatter(self, {['suspectmodel'] = e}, 'Arrest', 'UVPursuit')
			elseif self.v.UVSpecial then
				UVTextChatter(self, {['suspectmodel'] = e}, 'Arrest', 'UVSpecial')
			elseif self.v.UVCommander then
				UVTextChatter(self, {['suspectmodel'] = e}, 'Arrest', 'UVCommander')
			end
		else
			UVTextChatter(self, {['suspectmodel'] = e}, 'Arrest', 'UVPatrol')
		end
	end
	
	function UVChatterArrestAcknowledge(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "arrestacknowledge", 1)
		end
		if !IsValid(self.v) then return end
		UVDelayChatter()
		if self.v.UVPatrol then
			UVTextChatter(self, {}, 'ArrestAcknowledge', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, {}, 'ArrestAcknowledge', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, {}, 'ArrestAcknowledge', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, {}, 'ArrestAcknowledge', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, {}, 'ArrestAcknowledge', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, {}, 'ArrestAcknowledge', 'UVCommander')
		end
	end
	
	function UVChatterFine(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "fine")
		end
		UVDelayChatter()
		if !IsValid(self.e) then return end
		local e = UVGetVehicleMakeAndModel(self.e)
		if self.v.UVPatrol then
			UVTextChatter(self, {['suspectmodel'] = e}, 'Fine', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, {['suspectmodel'] = e}, 'Fine', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, {['suspectmodel'] = e}, 'Fine', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, {['suspectmodel'] = e}, 'Fine', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, {['suspectmodel'] = e}, 'Fine', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, {['suspectmodel'] = e}, 'Fine', 'UVCommander')
		end
	end
	
	function UVChatterWreck(self)
		if UVChatterDelayed or !uvtargeting then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "wreck", 3)
		end
		UVDelayChatter()
		local wrecksound = {
			"physics/metal/metal_large_debris1.wav",
			"physics/metal/metal_large_debris2.wav",
			"vehicles/v8/vehicle_impact_heavy1.wav",
			"vehicles/v8/vehicle_impact_heavy2.wav",
			"vehicles/v8/vehicle_impact_heavy3.wav",
			"vehicles/v8/vehicle_impact_heavy4.wav",
			"vehicles/v8/vehicle_rollover1.wav",
			"vehicles/v8/vehicle_rollover2.wav",
			"npc/metropolice/die1.wav",
			"npc/metropolice/die2.wav",
			"npc/metropolice/die3.wav",
			"npc/metropolice/die4.wav",
			"npc/metropolice/knockout2.wav",
			"npc/metropolice/pain1.wav",
			"npc/metropolice/pain2.wav",
			"npc/metropolice/pain3.wav",
			"npc/metropolice/pain4.wav",
			"npc/metropolice/vo/off2.wav",
			"npc/combine_soldier/die1.wav",
			"npc/combine_soldier/die2.wav",
			"npc/combine_soldier/die3.wav",
			"npc/combine_soldier/pain1.wav",
			"npc/combine_soldier/pain2.wav",
			"npc/combine_soldier/pain3.wav",
			"npc/combine_gunship/gunship_explode2.wav",
			"vo/citadel/br_failing11.wav",
			"vo/citadel/br_youfool.wav",
			"vo/citadel/br_no.wav",
		}
		if self.v then
			self.v:EmitSound(wrecksound[math.random(#wrecksound)])
		end
		if self.v.UVPatrol then
			UVTextChatter(self, {}, 'Wreck', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, {}, 'Wreck', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, {}, 'Wreck', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, {}, 'Wreck', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, {}, 'Wreck', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, {}, 'Wreck', 'UVCommander')
		end
	end
	
	function UVChatterRoadblockMissed(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local randomno = math.random(1,2)
			if randomno == 1 then
				return UVSoundChatter(self, self.voice, "roadblockmissed")
			else
				return UVSoundChatter(self, self.voice, "roadblockmissed", 1)
			end
		end
		UVDelayChatter()
		if self.v.UVSupport then
			UVTextChatter(self, {}, 'RoadblockMissed', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, {}, 'RoadblockMissed', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, {}, 'RoadblockMissed', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, {}, 'RoadblockMissed', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, {}, 'RoadblockMissed', 'UVCommander')
		end
	end
	
	function UVChatterRoadblockHit(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local randomno = math.random(1,2)
			if randomno == 1 then
				return UVSoundChatter(self, self.voice, "roadblockhit")
			else
				return UVSoundChatter(self, self.voice, "roadblockhit", 1)
			end
		end
		UVDelayChatter()
		if self.v.UVSupport then
			UVTextChatter(self, {}, 'RoadblockHit', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, {}, 'RoadblockHit', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, {}, 'RoadblockHit', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, {}, 'RoadblockHit', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, {}, 'RoadblockHit', 'UVCommander')
		end
	end
	
	function UVChatterRoadblockDeployed(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local airrandomno = math.random(1,2)
			local airunits = ents.FindByClass("uvair")
			if next(airunits) ~= nil then
				local random_entry = math.random(#airunits)	
				local unit = airunits[random_entry]
				if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
					return UVSoundChatter(unit, unit.voice, "roadblockdeployed")
				end
			end
			local randomno = math.random(1,2)
			if randomno == 1 then
				return UVSoundChatter(self, self.voice, "roadblockdeployed")
			else
				return UVSoundChatter(self, self.voice, "roadblockdeployed", 1)
			end
		end
		UVDelayChatter()
		if self.v.UVSupport then
			UVTextChatter(self, {}, 'RoadblockDeployed', 'UVSupport')		
		elseif self.v.UVPursuit then
			UVTextChatter(self, {}, 'RoadblockDeployed', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, {}, 'RoadblockDeployed', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, {}, 'RoadblockDeployed', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, {}, 'RoadblockDeployed', 'UVCommander')
		end
	end
	
	function UVChatterHeatTwo(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local timecheck = 5
			local randomno = math.random(1,2)
			if randomno == 1 then
				local airrandomno = math.random(1,2)
				local airunits = ents.FindByClass("uvair")
				if next(airunits) ~= nil then
					local random_entry = math.random(#airunits)	
					local unit = airunits[random_entry]
					if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
						timecheck = UVSoundChatter(unit, unit.voice, "heattwo", 4)
					else
						timecheck = UVSoundChatter(self, self.voice, "heattwo", 4)
					end
				else
					timecheck = UVSoundChatter(self, self.voice, "heattwo", 4)
				end
			else
				timecheck = UVSoundChatter(self, self.voice, "heattwo", 8)
			end
			timer.Simple(timecheck, function()
				if next(ents.FindByClass("npc_uv*")) ~= nil then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					if unit == self then return end
					UVChatterAcknowledgeGeneral(unit)
				end
			end)
			return
		end
		UVDelayChatter()
		timer.Simple(math.random(3,5), function()
			if next(ents.FindByClass("npc_uv*")) ~= nil then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				if unit == self then return end
				UVChatterAcknowledgeGeneral(unit)
			end
		end)
		UVTextChatter(self, {}, 'HeatTwo')
	end
	
	function UVChatterHeatThree(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local timecheck = 5
			local randomno = math.random(1,2)
			if randomno == 1 then
				local airrandomno = math.random(1,2)
				local airunits = ents.FindByClass("uvair")
				if next(airunits) ~= nil then
					local random_entry = math.random(#airunits)	
					local unit = airunits[random_entry]
					if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
						timecheck = UVSoundChatter(unit, unit.voice, "heatthree", 4)
					else
						timecheck = UVSoundChatter(self, self.voice, "heatthree", 4)
					end
				else
					timecheck = UVSoundChatter(self, self.voice, "heatthree", 4)
				end
			else
				timecheck = UVSoundChatter(self, self.voice, "heatthree", 8)
			end
			timer.Simple(timecheck, function()
				if next(ents.FindByClass("npc_uv*")) ~= nil then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					if unit == self then return end
					UVChatterAcknowledgeGeneral(unit)
				end
			end)
			return
		end
		UVDelayChatter()
		timer.Simple(math.random(3,5), function()
			if next(ents.FindByClass("npc_uv*")) ~= nil then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				if unit == self then return end
				UVChatterAcknowledgeGeneral(unit)
			end
		end)
		
		UVTextChatter(self, {}, 'HeatThree')
	end
	
	function UVChatterHeatFour(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local timecheck = 5
			local randomno = math.random(1,2)
			if randomno == 1 then
				local airrandomno = math.random(1,2)
				local airunits = ents.FindByClass("uvair")
				if next(airunits) ~= nil then
					local random_entry = math.random(#airunits)	
					local unit = airunits[random_entry]
					if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
						timecheck = UVSoundChatter(unit, unit.voice, "heatfour", 4)
					else
						timecheck = UVSoundChatter(self, self.voice, "heatfour", 4)
					end
				else
					timecheck = UVSoundChatter(self, self.voice, "heatfour", 4)
				end
			else
				timecheck = UVSoundChatter(self, self.voice, "heatfour", 8)
			end
			timer.Simple(timecheck, function()
				if next(ents.FindByClass("npc_uv*")) ~= nil then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					if unit == self then return end
					UVChatterAcknowledgeGeneral(unit)
				end
			end)
			return
		end
		UVDelayChatter()
		timer.Simple(math.random(3,5), function()
			if next(ents.FindByClass("npc_uv*")) ~= nil then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				if unit == self then return end
				UVChatterAcknowledgeGeneral(unit)
			end
		end)
		UVTextChatter(self, {}, 'HeatFour')
	end
	
	function UVChatterHeatFive(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local timecheck = 5
			local randomno = math.random(1,2)
			if randomno == 1 then
				local airrandomno = math.random(1,2)
				local airunits = ents.FindByClass("uvair")
				if next(airunits) ~= nil then
					local random_entry = math.random(#airunits)	
					local unit = airunits[random_entry]
					if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
						timecheck = UVSoundChatter(unit, unit.voice, "heatfive", 4)
					else
						timecheck = UVSoundChatter(self, self.voice, "heatfive", 4)
					end
				else
					timecheck = UVSoundChatter(self, self.voice, "heatfive", 4)
				end
			else
				timecheck = UVSoundChatter(self, self.voice, "heatfive", 8)
			end
			timer.Simple(timecheck, function()
				if next(ents.FindByClass("npc_uv*")) ~= nil then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					local timecheck = 5
					local randomno = math.random(1,2)
					if randomno == 1 then
						timecheck = UVSoundChatter(self, self.voice, "heatfiveacknowledge")
					else
						timecheck = UVSoundChatter(self, self.voice, "heatfiveargue")
						timer.Simple(timecheck, function()
							if next(ents.FindByClass("npc_uv*")) ~= nil then
								local units = ents.FindByClass("npc_uv*")
								local random_entry = math.random(#units)	
								local unit = units[random_entry]
								UVSoundChatter(self, self.voice, "heatfivereassure", 1)
							end
						end)
					end
				end
			end)
			return
		end
		UVDelayChatter()
		timer.Simple(math.random(3,5), function()
			if next(ents.FindByClass("npc_uv*")) ~= nil then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				if unit == self then return end
				UVChatterAcknowledgeGeneral(unit)
			end
		end)
		UVTextChatter(self, {}, 'HeatFive')
	end
	
	function UVChatterHeatSix(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local timecheck = 5
			local randomno = math.random(1,2)
			if randomno == 1 then
				local airrandomno = math.random(1,2)
				local airunits = ents.FindByClass("uvair")
				if next(airunits) ~= nil then
					local random_entry = math.random(#airunits)	
					local unit = airunits[random_entry]
					if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
						timecheck = UVSoundChatter(unit, unit.voice, "heatsix", 4)
					else
						timecheck = UVSoundChatter(self, self.voice, "heatsix", 4)
					end
				else
					timecheck = UVSoundChatter(self, self.voice, "heatsix", 4)
				end
			else
				timecheck = UVSoundChatter(self, self.voice, "heatsix", 8)
			end
			timer.Simple(timecheck, function()
				if next(ents.FindByClass("npc_uv*")) ~= nil then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					if unit == self then return end
					UVChatterAcknowledgeGeneral(unit)
				end
			end)
			return
		end
		UVDelayChatter()
		timer.Simple(math.random(3,5), function()
			if next(ents.FindByClass("npc_uv*")) ~= nil then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				if unit == self then return end
				UVChatterAcknowledgeGeneral(unit)
			end
		end)
		UVTextChatter(self, {}, 'HeatSix')
		
	end
	
	function UVChatterPursuitStartRanAway(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local timecheck = 5
			timecheck = UVSoundChatter(self, self.voice, "pursuitstartranaway", 4)
			timer.Simple(timecheck, function()
				if IsValid(self) then
					UVChatterPursuitStartAcknowledge(self)
				end
			end)
			return
		end
		UVDelayChatter()
		timer.Simple(math.random(3,4), function()
			if IsValid(self) then
				UVChatterPursuitStartAcknowledge(self)
			end
		end)
		if !IsValid(self.e) then return end
		local e = UVGetVehicleMakeAndModel(self.e)
		if self.v.UVPatrol then
			UVTextChatter(self, {['suspectmodel'] = e}, 'PursuitStartRanAway', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, {['suspectmodel'] = e}, 'PursuitStartRanAway', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, {['suspectmodel'] = e}, 'PursuitStartRanAway', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, {['suspectmodel'] = e}, 'PursuitStartRanAway', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, {['suspectmodel'] = e}, 'PursuitStartRanAway', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, {['suspectmodel'] = e}, 'PursuitStartRanAway', 'UVCommander')
		end
	end
	
	function UVChatterPursuitStartAcknowledge(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			if #uvwantedtablevehicle > 1 then
				return UVSoundChatter(self, self.voice, "pursuitstartacknowledgemultipleenemies", 8)
			else
				if uvheatlevel < 2 then
					return UVSoundChatter(self, self.voice, "pursuitstartacknowledge", 8)
				elseif uvheatlevel < 5 then
					return UVSoundChatter(self, self.voice, "pursuitstartacknowledgemed", 8)
				else
					return UVSoundChatter(self, self.voice, "pursuitstartacknowledgehigh", 8)
				end
			end
		end
		UVDelayChatter()
		if !IsValid(self.e) then return end
		local e = UVGetVehicleMakeAndModel(self.e)
		if self.v.UVPatrol then
			UVTextChatter(self, {['suspectmodel'] = e}, 'PursuitStartAcknowledge', 'UVPatrol')	
		elseif self.v.UVSupport then
			UVTextChatter(self, {['suspectmodel'] = e}, 'PursuitStartAcknowledge', 'UVSupport')	
		elseif self.v.UVPursuit then
			UVTextChatter(self, {['suspectmodel'] = e}, 'PursuitStartAcknowledge', 'UVPursuit')	
		elseif self.v.UVInterceptor then
			UVTextChatter(self, {['suspectmodel'] = e}, 'PursuitStartAcknowledge', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, {['suspectmodel'] = e}, 'PursuitStartAcknowledge', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, {['suspectmodel'] = e}, 'PursuitStartAcknowledge', 'UVCommander')
		end
	end
	
	function UVChatterTrafficStopSpeeding(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local timecheck = UVSoundChatter(self, self.voice, "trafficstopspeeding")
			timer.Simple(timecheck, function()
				if IsValid(self) then
					UVChatterDispatchAcknowledgeRequest(self)
				end
			end)
			return
		end
		if UVChatterDelayed then return end
		UVDelayChatter()
		if !IsValid(self.e) then return end
		local e = UVGetVehicleMakeAndModel(self.e)
		if self.v.UVPatrol then
			UVTextChatter(self, {['suspectmodel'] = e}, 'TrafficStopSpeeding', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, {['suspectmodel'] = e}, 'TrafficStopSpeeding', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, {['suspectmodel'] = e}, 'TrafficStopSpeeding', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, {['suspectmodel'] = e}, 'TrafficStopSpeeding', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, {['suspectmodel'] = e}, 'TrafficStopSpeeding', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, {['suspectmodel'] = e}, 'TrafficStopSpeeding', 'UVCommander')
		end
	end
	
	function UVChatterTrafficStopRammed(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local timecheck = UVSoundChatter(self, self.voice, "trafficstoprammed", 3)
			timer.Simple(timecheck, function()
				if IsValid(self) then
					UVChatterDispatchAcknowledgeRequest(self)
				end
			end)
			return
		end
		UVDelayChatter()
		if !IsValid(self.e) then return end
		local e = UVGetVehicleMakeAndModel(self.e)
		if self.v.UVPatrol then
			UVTextChatter(self, {}, 'TrafficStopRammed', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, {}, 'TrafficStopRammed', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, {}, 'TrafficStopRammed', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, {}, 'TrafficStopRammed', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, {}, 'TrafficStopRammed', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, {}, 'TrafficStopRammed', 'UVCommander')
		end
	end
	
	function UVChatterLeftPursuit(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "leftpursuit")
		end
		UVDelayChatter()
		if self.v.UVPatrol then
			UVTextChatter(self, {}, 'LeftPursuit', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, {}, 'LeftPursuit', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, {}, 'LeftPursuit', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, {}, 'LeftPursuit', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, {}, 'LeftPursuit', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, {}, 'LeftPursuit', 'UVCommander')
		end
	end
	
	function UVChatterResponding(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			if self.v.rhino then
				return UVSoundChatter(self, self.voice, "responding")
			end
			local randomno = math.random(1,10)
			if randomno == 1 then
				return UVSoundChatter(self, self.voice, "responding", 5)
			elseif randomno == 2 then
				return UVSoundChatter(self, self.voice, "responding", 1)
			else
				return
			end
		end
		UVDelayChatter()
		if !IsValid(self.e) then return end
		local e = UVGetVehicleMakeAndModel(self.e)
		if self.v.UVPatrol then
			UVTextChatter(self, {['suspectmodel'] = e}, 'Responding', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, {['suspectmodel'] = e}, 'Responding', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, {['suspectmodel'] = e}, 'Responding', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, {['suspectmodel'] = e}, 'Responding', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, {['suspectmodel'] = e}, 'Responding', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, {['suspectmodel'] = e}, 'Responding', 'UVCommander')
		end
	end
	
	function UVChatterKillswitchStart(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "killswitchstart")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end

		if !self.v then return end
		
		if self.v.UVPursuit then
			UVTextChatter(self, args, 'KillswitchStart', 'UVPursuit')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'KillswitchStart', 'UVSpecial')
		end
	end
	
	function UVChatterKillswitchMissed(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "killswitchmissed")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end

		if !self.v then return end
		
		if self.v.UVPursuit then
			UVTextChatter(self, args, 'KillswitchMissed', 'UVPursuit')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'KillswitchMissed', 'UVSpecial')
		end
	end
	
	function UVChatterKillswitchHit(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "killswitchhit")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end

		if !self.v then return end
		
		if self.v.UVPursuit then
			UVTextChatter(self, args, 'KillswitchHit', 'UVPursuit')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'KillswitchHit', 'UVSpecial')
		end
	end
	
	function UVChatterSpikeStripDeployed(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "spikestripdeployed")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end

		if !self.v then return end
		
		if self.v.UVInterceptor then
			UVTextChatter(self, args, 'SpikeStripDeployed', 'UVInterceptor')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'SpikeStripDeployed', 'UVCommander')
		end
	end
	
	function UVChatterBusting(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "busting")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end

		if !self.v then return end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'Busting', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'Busting', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'Busting', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'Busting', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'Busting', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'Busting', 'UVCommander')
		end
	end
	
	function UVChatterBustEvaded(self)
		if UVChatterDelayed or !IsValid(self.v) then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "bustevaded")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end

		if !self.v then return end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'BustEvaded', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'BustEvaded', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'BustEvaded', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'BustEvaded', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'BustEvaded', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'BustEvaded', 'UVCommander')
		end
	end
	
	function UVChatterEnemyInfront(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "enemyinfront")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVInterceptor then
			UVTextChatter(self, args, 'EnemyInfront', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'EnemyInfront', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'EnemyInfront', 'UVCommander')
		end
	end
	
	function UVChatterAggressive(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local timecheck = 5
			timecheck = UVSoundChatter(self, self.voice, "aggressive")
			timer.Simple(timecheck, function()
				if next(ents.FindByClass("npc_uv*")) ~= nil then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					if unit == self then return end
					UVChatterAcknowledgeRequest(unit)
				end
			end)
			return
		end
		UVDelayChatter()
		timer.Simple(math.random(3,5), function()
			if next(ents.FindByClass("npc_uv*")) ~= nil then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				if unit == self then return end
				UVChatterAcknowledgeRequest(unit)
			end
		end)
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'Aggressive', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'Aggressive', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'Aggressive', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'Aggressive', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'Aggressive', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'Aggressive', 'UVCommander')
		end
	end
	
	function UVChatterPassive(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local timecheck = 5
			timecheck = UVSoundChatter(self, self.voice, "passive")
			timer.Simple(timecheck, function()
				if next(ents.FindByClass("npc_uv*")) ~= nil then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					if unit == self then return end
					UVChatterAcknowledgeGeneral(unit)
				end
			end)
			return
		end
		UVDelayChatter()
		timer.Simple(math.random(3,5), function()
			if next(ents.FindByClass("npc_uv*")) ~= nil then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				if unit == self then return end
				UVChatterAcknowledgeGeneral(unit)
			end
		end)
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'Passive', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'Passive', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'Passive', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'Passive', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'Passive', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'Passive', 'UVCommander')
		end
	end
	
	function UVChatterCloseToEnemy(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local randomno = math.random(1,2)
			if randomno == 1 then
				return UVSoundChatter(self, self.voice, "closetoenemy")
			else
				return UVSoundChatter(self, self.voice, "closetoenemy", 2)
			end
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'CloseToEnemy', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'CloseToEnemy', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'CloseToEnemy', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'CloseToEnemy', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'CloseToEnemy', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'CloseToEnemy', 'UVCommander')
		end
	end
	
	function UVChatterFoundEnemy(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "foundenemy", 4)
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'FoundEnemy', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'FoundEnemy', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'FoundEnemy', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'FoundEnemy', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'FoundEnemy', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'FoundEnemy', 'UVCommander')
		end
	end
	
	function UVChatterFoundMultipleEnemies(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local airrandomno = math.random(1,2)
			local airunits = ents.FindByClass("uvair")
			if next(airunits) ~= nil then
				local random_entry = math.random(#airunits)	
				local unit = airunits[random_entry]
				if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
					return UVSoundChatter(unit, unit.voice, "foundmultipleenemies")
				end
			end
			return UVSoundChatter(self, self.voice, "foundmultipleenemies")
		end
		if UVChatterDelayed then return end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'FoundMultipleEnemies', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'FoundMultipleEnemies', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'FoundMultipleEnemies', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'FoundMultipleEnemies', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'FoundMultipleEnemies', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'FoundMultipleEnemies', 'UVCommander')
		end
	end
	
	function UVChatterLosing(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local timecheck = 5
			local airrandomno = math.random(1,2)
			local airunits = ents.FindByClass("uvair")
			if next(airunits) ~= nil then
				local random_entry = math.random(#airunits)	
				local unit = airunits[random_entry]
				if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
					timecheck = UVSoundChatter(unit, unit.voice, "losing")
				else
					timecheck = UVSoundChatter(self, self.voice, "losing")
				end
			else
				timecheck = UVSoundChatter(self, self.voice, "losing")
			end
			timer.Simple(timecheck, function()
				if next(ents.FindByClass("npc_uv*")) ~= nil and uvenemyescaping then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					UVChatterLosingAcknowledge(unit)
				end
			end)
			return
		end
		timer.Simple(math.random(3,5), function()
			if next(ents.FindByClass("npc_uv*")) ~= nil and uvenemyescaping then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				UVChatterLosingAcknowledge(unit)
			end
		end)
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'Losing', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'Losing', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'Losing', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'Losing', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'Losing', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'Losing', 'UVCommander')
		end
	end
	
	function UVChatterLosingAcknowledge(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "losingacknowledge", 7)
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'LosingAcknowledge', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'LosingAcknowledge', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'LosingAcknowledge', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'LosingAcknowledge', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'LosingAcknowledge', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'LosingAcknowledge', 'UVCommander')
		end
	end
	
	function UVChatterLosingUpdate(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local randomno = math.random(1,2)
			local airunits = ents.FindByClass("uvair")
			if next(airunits) ~= nil and randomno == 1 then
				local random_entry = math.random(#airunits)	
				local unit = airunits[random_entry]
				if !(unit.crashing or unit.disengaging) then
					UVSoundChatter(unit, unit.voice, "losingupdate")
				else
					UVSoundChatter(self, self.voice, "losingupdate")
				end
			else
				UVSoundChatter(self, self.voice, "losingupdate")
			end
			return
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'LosingUpdate', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'LosingUpdate', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'LosingUpdate', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'LosingUpdate', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'LosingUpdate', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'LosingUpdate', 'UVCommander')
		end
	end
	
	function UVChatterLost(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local timecheck = 5
			timecheck = UVSoundChatter(self, self.voice, "lost", 1)
			timer.Simple(timecheck, function()
				UVSoundChatter(Entity(0), 1, "lostacknowledge", 1)
			end)
			return
		end
		timer.Simple(5, function()
			UVChatterLostAcknowledge(self)
		end)
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'Lost', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'Lost', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'Lost', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'Lost', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'Lost', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'Lost', 'UVCommander')
		end
	end
	
	function UVChatterLostAcknowledge(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "lostacknowledge", 1)
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'LostAcknowledge', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'LostAcknowledge', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'LostAcknowledge', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'LostAcknowledge', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'LostAcknowledge', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'LostAcknowledge', 'UVCommander')
		end
	end
	
	function UVChatterInitialize(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "initialize")
		end
		if UVChatterDelayed then return end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'Initialize', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'Initialize', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'Initialize', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'Initialize', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'Initialize', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'Initialize', 'UVCommander')
		end
	end
	
	--UV mid chatter goes here--
	
	function UVChatterAirOnRemove(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "aironremove")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		UVTextChatter(self, args, 'AirOnRemove')
	end
	
	function UVChatterAirArrest(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "airarrest")
		end
		UVDelayChatter()
		
		local e = UVGetVehicleMakeAndModel(self:GetTarget())
		
		UVTextChatter(self, {['suspectmodel'] = e}, 'AirArrest')
	end
	
	function UVChatterAirArrestAcknowledge(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "airarrestacknowledge")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		UVTextChatter(self, args, 'AirArrestAcknowledge')
	end
	
	function UVChatterAirWreck(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "airwreck")
		end
		if UVChatterDelayed then return end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		UVTextChatter(self, args, 'AirWreck')
	end
	
	function UVChatterAirSpikeStripDeployed(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "airspikestripdeployed")
		end
		if UVChatterDelayed then return end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		UVTextChatter(self, args, 'AirSpikeStripDeployed')
	end
	
	function UVChatterAirBusting(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "airbusting")
		end
		if UVChatterDelayed then return end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		UVTextChatter(self, args, 'AirBusting')
	end
	
	function UVChatterAirBustEvadedUpdate(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "airbustevadedupdate")
		end
		if UVChatterDelayed then return end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		UVTextChatter(self, args, 'AirBustEvadedUpdate')
	end
	
	function UVChatterAirBustEvaded(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "airbustevaded")
		end
		if UVChatterDelayed then return end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		UVTextChatter(self, args, 'AirBustEvaded')
	end
	
	function UVChatterAirAggressive(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "airaggressive")
		end
		if UVChatterDelayed then return end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		UVTextChatter(self, args, 'AirAggressive')
	end
	
	function UVChatterAirPassive(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "airpassive")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		UVTextChatter(self, args, 'AirPassive')
	end
	
	function UVChatterAirCloseToEnemy(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "airclosetoenemy", 2)
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self:GetTarget()) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self:GetTarget())
		end
		
		UVTextChatter(self, args, 'AirCloseToEnemy')
	end
	
	function UVChatterAirFoundEnemy(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "airfoundenemy", 4)
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		UVTextChatter(self, args, 'AirFoundEnemy')
	end
	
	function UVChatterAirInitialize(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local randomno = math.random(1,2)
			if randomno == 1 then
				UVSoundChatter(self, self.voice, "airinitialize")
			else
				UVSoundChatter(self, self.voice, "airinitialize", 1)
			end
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		UVTextChatter(self, args, 'AirInitialize')
	end
	
	function UVChatterAirSpottedEnemy(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "airspottedenemy")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		UVTextChatter(self, args, 'AirSpottedEnemy')
	end
	
	function UVChatterAirLowOnFuel(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "airlowonfuel")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		UVTextChatter(self, args, 'AirLowOnFuel')
	end
	
	function UVChatterAirDisengaging(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "airdisengaging")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		UVTextChatter(self, args, 'AirDisengaging')
	end
	
	function UVChatterAirSpikeStripMiss(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "airspikestripmiss")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		UVTextChatter(self, args, 'AirSpikeStripMiss')
	end
	
	function UVChatterAirSpikeStripHit(unit)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(unit, unit.voice, "airspikestriphit")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(unit.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(unit.e)
		end
		
		UVTextChatter(unit, args, 'AirSpikeStripHit')
	end
	
	function UVChatterAirExplosiveBarrelDeployed(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "airexplosivebarreldeployed")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		UVTextChatter(self, args, 'AirExplosiveBarrelDeployed')
	end
	
	function UVChatterAirExplosiveBarrelHit(unit)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(unit, unit.voice, "airexplosivebarrelhit")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(unit.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(unit.e)
		end
		
		UVTextChatter(unit, args, 'AirExplosiveBarrelHit')
	end
	
	function UVChatterSpikeStripHit(unit)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local airrandomno = math.random(1,2)
			local airunits = ents.FindByClass("uvair")
			if next(airunits) ~= nil then
				local random_entry = math.random(#airunits)	
				local unit = airunits[random_entry]
				if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
					return UVSoundChatter(unit, unit.voice, "spikestriphit")
				end
			end
			local randomno = math.random(1,2)
			if randomno == 1 then
				return UVSoundChatter(unit, unit.voice, "spikestriphit")
			else
				return UVSoundChatter(unit, unit.voice, "spikestriphit", 1)
			end
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(unit.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(unit.e)
		end
		
		if unit.v.UVInterceptor then
			UVTextChatter(unit, args, 'SpikeStripHit', 'UVInterceptor')
		elseif unit.v.UVCommander then
			UVTextChatter(unit, args, 'SpikeStripHit', 'UVCommander')
		end
	end
	
	function UVChatterExplosiveBarrelHit(unit)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(unit, unit.voice, "explosivebarrelhit")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(unit.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(unit.e)
		end
		
		if unit.v.UVSpecial then
			UVTextChatter(unit, args, 'ExplosiveBarrelHit', 'UVSpecial')
		elseif unit.v.UVCommander then
			UVTextChatter(unit, args, 'ExplosiveBarrelHit', 'UVCommander')
		end
	end
	
	function UVChatterEnemyCrashed(unit)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local airrandomno = math.random(1, 2)
			local airunits = ents.FindByClass("uvair")
			if next(airunits) ~= nil then
				local random_entry = math.random(#airunits)
				local unit = airunits[random_entry]
				if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
					return UVSoundChatter(unit, unit.voice, "enemycrashed")
				end
			end
			return UVSoundChatter(unit, unit.voice, "enemycrashed")
		end
		
		local args = {}
		if IsValid(unit.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(unit.e)
		end
		
		if unit.v.UVPatrol then
			UVTextChatter(unit, args, 'EnemyCrashed', 'UVPatrol')
		elseif unit.v.UVSupport then
			UVTextChatter(unit, args, 'EnemyCrashed', 'UVSupport')
		elseif unit.v.UVPursuit then
			UVTextChatter(unit, args, 'EnemyCrashed', 'UVPursuit')
		elseif unit.v.UVInterceptor then
			UVTextChatter(unit, args, 'EnemyCrashed', 'UVInterceptor')
		elseif unit.v.UVSpecial then
			UVTextChatter(unit, args, 'EnemyCrashed', 'UVSpecial')
		elseif unit.v.UVCommander then
			UVTextChatter(unit, args, 'EnemyCrashed', 'UVCommander')
		end
	end
	
	--UV new chatter goes here--
	
	function UVChatterDispatchAcknowledgeRequest(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "dispatchacknowledgerequest", 1)
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol or self.v.UVSupport then
			UVTextChatter(self, args, 'DispatchAcknowledgeRequest', 'UVPatrol_UVSupport')
		elseif self.v.UVPursuit or self.v.UVInterceptor then
			UVTextChatter(self, args, 'DispatchAcknowledgeRequest', 'UVPursuit_UVInterceptor')
		elseif self.v.UVSpecial or self.v.UVCommander then
			UVTextChatter(self, args, 'DispatchAcknowledgeRequest', 'UVSpecial_UVCommander')
		end
	end
	
	function UVChatterDispatchDenyRequest(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local airrandomno = math.random(1,2)
			local airunits = ents.FindByClass("uvair")
			if next(airunits) ~= nil then
				local random_entry = math.random(#airunits)	
				local unit = airunits[random_entry]
				if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
					return UVSoundChatter(unit, unit.voice, "denyrequest")
				end
			end
			return UVSoundChatter(self, self.voice, "denyrequest")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol or self.v.UVSupport then
			UVTextChatter(self, args, 'DispatchDenyRequest', 'UVPatrol_UVSupport')
		elseif self.v.UVPursuit or self.v.UVInterceptor then
			UVTextChatter(self, args, 'DispatchDenyRequest', 'UVPursuit_UVInterceptor')
		elseif self.v.UVSpecial or self.v.UVCommander then
			UVTextChatter(self, args, 'DispatchDenyRequest', 'UVSpecial_UVCommander')
		end
	end
	
	function UVChatterDispatchIdleTalk(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "dispatchidletalk", 1)
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol or self.v.UVSupport then
			UVTextChatter(self, args, 'DispatchIdleTalk', 'UVPatrol_UVSupport')
		elseif self.v.UVPursuit or self.v.UVInterceptor then
			UVTextChatter(self, args, 'DispatchIdleTalk', 'UVPursuit_UVInterceptor')
		elseif self.v.UVSpecial or self.v.UVCommander then
			UVTextChatter(self, args, 'DispatchIdleTalk', 'UVSpecial_UVCommander')
		end
	end
	
	function UVChatterAcknowledgeGeneral(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local airrandomno = math.random(1,2)
			local airunits = ents.FindByClass("uvair")
			if next(airunits) ~= nil then
				local random_entry = math.random(#airunits)	
				local unit = airunits[random_entry]
				if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
					return UVSoundChatter(unit, unit.voice, "acknowledgegeneral")
				end
			end
			return UVSoundChatter(self, self.voice, "acknowledgegeneral")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		UVTextChatter(self, args, 'AcknowledgeGeneral')
	end
	
	function UVChatterAcknowledgeRequest(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "acknowledgerequest")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then 
			UVTextChatter(self, args, 'AcknowledgeRequest', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'AcknowledgeRequest', 'UVSupport')
		elseif self.v.UVPursuit then 
			UVTextChatter(self, args, 'AcknowledgeRequest', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'AcknowledgeRequest', 'UVInterceptor')
		elseif self.v.UVSpecial then 
			UVTextChatter(self, args, 'AcknowledgeRequest', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'AcknowledgeRequest', 'UVCommander')
		end
	end
	
	function UVChatterDenyRequest(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "denyrequest")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then 
			UVTextChatter(self, args, 'DenyRequest', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'DenyRequest', 'UVSupport')
		elseif self.v.UVPursuit then 
			UVTextChatter(self, args, 'DenyRequest', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'DenyRequest', 'UVInterceptor')
		elseif self.v.UVSpecial then 
			UVTextChatter(self, args, 'DenyRequest', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'DenyRequest', 'UVCommander')
		end
	end
	
	function UVChatterIdleTalk(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "idletalk", 1)
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then 
			UVTextChatter(self, args, 'IdleTalk', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'IdleTalk', 'UVSupport')
		elseif self.v.UVPursuit then 
			UVTextChatter(self, args, 'IdleTalk', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'IdleTalk', 'UVInterceptor')
		elseif self.v.UVSpecial then 
			UVTextChatter(self, args, 'IdleTalk', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'IdleTalk', 'UVCommander')
		end
	end
	
	function UVChatterDamaged(self)
		if UVChatterDelayed or !uvtargeting then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local function ChatterChopperUnavailable()
				if next(ents.FindByClass("npc_uv*")) ~= nil then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					if unit == self then return end
					timecheck = UVSoundChatter(unit, unit.voice, "damagedcheckin")
					timer.Simple(timecheck, function()
						if IsValid(self) then
							UVSoundChatter(self, self.voice, "damaged") 
						end
					end)
				end
			end
			local randomno = math.random(1,2)
			local timecheck = 5
			local airunits = ents.FindByClass("uvair")
			if next(airunits) ~= nil and randomno == 1 then
				local random_entry = math.random(#airunits)	
				local unit = airunits[random_entry]
				if !(unit.crashing or unit.disengaging) then
					timecheck = UVSoundChatter(unit, unit.voice, "damagedcheckin")
					timer.Simple(timecheck, function()
						if IsValid(self) then
							UVSoundChatter(self, self.voice, "damaged") 
						end
					end)
				else
					ChatterChopperUnavailable()
				end
			else
				ChatterChopperUnavailable()
			end
			return
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then 
			UVTextChatter(self, args, 'Damaged', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'Damaged', 'UVSupport')
		elseif self.v.UVPursuit then 
			UVTextChatter(self, args, 'Damaged', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'Damaged', 'UVInterceptor')
		elseif self.v.UVSpecial then 
			UVTextChatter(self, args, 'Damaged', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'Damaged', 'UVCommander')
		end
	end
	
	function UVChatterRammed(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "rammed")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then 
			UVTextChatter(self, args, 'Rammed', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'Rammed', 'UVSupport')
		elseif self.v.UVPursuit then 
			UVTextChatter(self, args, 'Rammed', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'Rammed', 'UVInterceptor')
		elseif self.v.UVSpecial then 
			UVTextChatter(self, args, 'Rammed', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'Rammed', 'UVCommander')
		end
	end
	
	function UVChatterRammedEnemy(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local airrandomno = math.random(1,2)
			local airunits = ents.FindByClass("uvair")
			if next(airunits) ~= nil then
				local random_entry = math.random(#airunits)	
				local unit = airunits[random_entry]
				if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
					return UVSoundChatter(unit, unit.voice, "rammedenemy")
				end
			end
			return UVSoundChatter(self, self.voice, "rammedenemy")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'RammedEnemy', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'RammedEnemy', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'RammedEnemy', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'RammedEnemy', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'RammedEnemy', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'RammedEnemy', 'UVCommander')
		end
	end
	
	function UVChatterRequestBackup(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local timecheck = 5
			local airrandomno = math.random(1,2)
			local airunits = ents.FindByClass("uvair")
			if next(airunits) ~= nil then
				local random_entry = math.random(#airunits)	
				local unit = airunits[random_entry]
				if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
					timecheck = UVSoundChatter(unit, unit.voice, "requestbackup")
				else
					timecheck = UVSoundChatter(self, self.voice, "requestbackup")
				end
			else
				timecheck = UVSoundChatter(self, self.voice, "requestbackup")
			end
			timer.Simple(timecheck, function()
				if IsValid(self) then
					UVChatterBackupOnTheWay(self)
				end
			end)
			return
		end
		UVDelayChatter()
		timer.Simple(math.random(3,5), function()
			if IsValid(self) then
				UVChatterBackupOnTheWay(self)
			end
		end)
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'RequestBackup', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'RequestBackup', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'RequestBackup', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'RequestBackup', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'RequestBackup', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'RequestBackup', 'UVCommander')
		end
	end
	
	function UVChatterOnScene(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "onscene")
		end
		local seconds = UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'OnScene', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'OnScene', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'OnScene', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'OnScene', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'OnScene', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'OnScene', 'UVCommander')
		end
		
		return seconds
	end
	
	function UVChatterBackupOnTheWay(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local timecheck = 5
			local randomno = math.random(1,2)
			if randomno == 1 then
				timecheck = UVSoundChatter(self, self.voice, "backupontheway")
			else
				timecheck = UVSoundChatter(self, self.voice, "backupontheway", 1)
			end
			timer.Simple(timecheck, function()
				if next(ents.FindByClass("npc_uv*")) ~= nil then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					if unit == self then return end
					UVChatterAcknowledgeGeneral(unit)
				end
			end)
			return
		end
		local seconds = UVDelayChatter()
		timer.Simple(math.random(3,5), function()
			if next(ents.FindByClass("npc_uv*")) ~= nil then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				UVChatterAcknowledgeGeneral(unit)
			end
		end)
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol or self.v.UVSupport then
			UVTextChatter(self, args, 'BackupOnTheWay', 'UVPatrol_UVSupport')
		elseif self.v.UVPursuit or self.v.UVInterceptor then
			UVTextChatter(self, args, 'BackupOnTheWay', 'UVPursuit_UVInterceptor')
		elseif self.v.UVSpecial or self.v.UVCommander then
			UVTextChatter(self, args, 'BackupOnTheWay', 'UVSpecial_UVCommander')
		end
		
		return seconds
	end
	
	function UVChatterBackupOnScene(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local timecheck = 5
			local randomno = math.random(1,2)
			if randomno == 1 then
				local airrandomno = math.random(1,2)
				local airunits = ents.FindByClass("uvair")
				if next(airunits) ~= nil then
					local random_entry = math.random(#airunits)	
					local unit = airunits[random_entry]
					if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
						timecheck = UVSoundChatter(unit, unit.voice, "backuponscene")
					else
						timecheck = UVSoundChatter(self, self.voice, "backuponscene")
					end
				else
					timecheck = UVSoundChatter(self, self.voice, "backuponscene")
				end
			else
				timecheck = UVSoundChatter(self, self.voice, "backuponscene", 1)
			end
			timer.Simple(timecheck, function()
				if next(ents.FindByClass("npc_uv*")) ~= nil then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					if unit == self then return end
					UVChatterAcknowledgeGeneral(unit)
				end
			end)
			return
		end
		local seconds = UVDelayChatter()
		timer.Simple(math.random(3,5), function()
			if next(ents.FindByClass("npc_uv*")) ~= nil then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				UVChatterAcknowledgeGeneral(unit)
			end
		end)
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol or self.v.UVSupport then
			UVTextChatter(self, args, 'BackupOnScene', 'UVPatrol_UVSupport')
		elseif self.v.UVPursuit or self.v.UVInterceptor then
			UVTextChatter(self, args, 'BackupOnScene', 'UVPursuit_UVInterceptor')
		elseif self.v.UVSpecial or self.v.UVCommander then
			UVTextChatter(self, args, 'BackupOnScene', 'UVSpecial_UVCommander')
		end
		
		return seconds
	end
	
	function UVChatterHitTraffic(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local airrandomno = math.random(1,2)
			local airunits = ents.FindByClass("uvair")
			if next(airunits) ~= nil then
				local random_entry = math.random(#airunits)	
				local unit = airunits[random_entry]
				if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
					return UVSoundChatter(unit, unit.voice, "hittraffic")
				end
			end
			return UVSoundChatter(self, self.voice, "hittraffic")
		end
		local seconds = UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'HitTraffic', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'HitTraffic', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'HitTraffic', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'HitTraffic', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'HitTraffic', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'HitTraffic', 'UVCommander')
		end
		
		return seconds
	end
	
	function UVChatterMultipleUnitsDown(self)
		if UVChatterDelayed or !uvtargeting then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local randomno = math.random(1,2)
			local timecheck = 5
			local airunits = ents.FindByClass("uvair")
			if next(airunits) ~= nil and randomno == 1 then
				local random_entry = math.random(#airunits)	
				local unit = airunits[random_entry]
				if !(unit.crashing or unit.disengaging) then
					timecheck = UVSoundChatter(unit, unit.voice, "multipleunitsdown", 4)
				else
					timecheck = UVSoundChatter(self, self.voice, "multipleunitsdown", 4)
				end
			else
				timecheck = UVSoundChatter(self, self.voice, "multipleunitsdown", 4)
			end
			timer.Simple(timecheck, function()
				if IsValid(self) then
					return UVSoundChatter(self, self.voice, "dispatchmultipleunitsdownacknowledge", 1)
				end
			end)
			return
		end
		local seconds = UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'MultipleUnitsDown', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'MultipleUnitsDown', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'MultipleUnitsDown', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'MultipleUnitsDown', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'MultipleUnitsDown', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'MultipleUnitsDown', 'UVCommander')
		end
		
		return seconds
	end
	
	function UVChatterAirDown(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "airdown", 4)
		end
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		UVTextChatter(self, args, 'AirDown')
	end
	
	function UVChatterRequestSitrep(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local MathAsk = math.random(1,2)
			if MathAsk == 2 then
				if uvenemyescaping then --During cooldown
					UVChatterLosingUpdate(self)
				else
					local MathReply = math.random(1,2)
					if MathReply == 1 then
						UVChatterSitrep(self)
					else
						UVChatterUpdateHeading(self)
					end
				end
				return
			end
			local timecheck = 5
			timecheck = UVSoundChatter(self, self.voice, "requestsitrep", 1)
			timer.Simple(timecheck, function()
				if IsValid(self) then
					if uvenemyescaping then --During cooldown
						UVChatterLosingUpdate(self)
					else
						local MathReply = math.random(1,2)
						if MathReply == 1 then
							UVChatterSitrep(self)
						else
							UVChatterUpdateHeading(self)
						end
					end
				end
			end)
			return
		end
		UVDelayChatter()
		local MathAsk = math.random(1,2)
		if MathAsk == 2 then
			if uvenemyescaping then --During cooldown
				UVChatterLosingUpdate(self)
			else
				local MathReply = math.random(1,2)
				if MathReply == 1 then
					UVChatterSitrep(self)
				else
					UVChatterUpdateHeading(self)
				end
			end
			return
		end
		timer.Simple(math.random(3,5), function()
			if IsValid(self) then
				if uvenemyescaping then --During cooldown
					UVChatterLosingUpdate(self)
				else
					local MathReply = math.random(1,2)
					if MathReply == 1 then
						UVChatterSitrep(self)
					else
						UVChatterUpdateHeading(self)
					end
				end
			end
		end)
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol or self.v.UVSupport then
			UVTextChatter(self, args, 'RequestSitrep', 'UVPatrol_UVSupport')
		elseif self.v.UVPursuit or self.v.UVInterceptor then
			UVTextChatter(self, args, 'RequestSitrep', 'UVPursuit_UVInterceptor')
		elseif self.v.UVSpecial or self.v.UVCommander then
			UVTextChatter(self, args, 'RequestSitrep', 'UVSpecial_UVCommander')
		end
	end
	
	function UVChatterSitrep(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local airrandomno = math.random(1,2)
			local airunits = ents.FindByClass("uvair")
			if next(airunits) ~= nil then
				local random_entry = math.random(#airunits)	
				local unit = airunits[random_entry]
				if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
					return UVSoundChatter(unit, unit.voice, "sitrep")
				end
			end
			return UVSoundChatter(self, self.voice, "sitrep")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'Sitrep', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'Sitrep', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'Sitrep', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'Sitrep', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'Sitrep', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'Sitrep', 'UVCommander')
		end
	end
	
	function UVChatterUpdateHeading(self)
		if !IsValid(self.e) then return end
		local Heading = self.e:GetVelocity():Angle().y
		local args = {}
		
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.e:GetVelocity():Length2DSqr() < 50000 then --Stopped
			if !GetConVar("unitvehicle_chattertext"):GetBool() then
				return UVSoundChatter(self, self.voice, "headingstopped")
			end
			UVDelayChatter()
			if self.v.UVPatrol or self.v.UVSupport then
				UVTextChatter(self, args, 'UpdateHeading', 'Stopped', 'UVPatrol_UVSupport')
			elseif self.v.UVPursuit then
				UVTextChatter(self, args, 'UpdateHeading', 'Stopped', 'UVPursuit')
			elseif self.v.UVSpecial or self.v.UVCommander then
				UVTextChatter(self, args, 'UpdateHeading', 'Stopped', 'UVSpecial_UVCommander')
			end
		elseif Heading > 45 and Heading < 135 then --North
			if !GetConVar("unitvehicle_chattertext"):GetBool() then
				local airrandomno = math.random(1,2)
				local airunits = ents.FindByClass("uvair")
				if next(airunits) ~= nil then
					local random_entry = math.random(#airunits)	
					local unit = airunits[random_entry]
					if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
						return UVSoundChatter(unit, unit.voice, "headingnorth")
					end
				end
				return UVSoundChatter(self, self.voice, "headingnorth")
			end
			UVDelayChatter()
			UVTextChatter(self, args, 'UpdateHeading', 'North')
		elseif Heading > 315 and Heading < 45 then --East
			if !GetConVar("unitvehicle_chattertext"):GetBool() then
				local airrandomno = math.random(1,2)
				local airunits = ents.FindByClass("uvair")
				if next(airunits) ~= nil then
					local random_entry = math.random(#airunits)	
					local unit = airunits[random_entry]
					if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
						return UVSoundChatter(unit, unit.voice, "headingeast")
					end
				end
				return UVSoundChatter(self, self.voice, "headingeast")
			end
			UVDelayChatter()
			UVTextChatter(self, args, 'UpdateHeading', 'East')
		elseif Heading > 225 and Heading < 315 then --South
			if !GetConVar("unitvehicle_chattertext"):GetBool() then
				local airrandomno = math.random(1,2)
				local airunits = ents.FindByClass("uvair")
				if next(airunits) ~= nil then
					local random_entry = math.random(#airunits)	
					local unit = airunits[random_entry]
					if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
						return UVSoundChatter(unit, unit.voice, "headingsouth")
					end
				end
				return UVSoundChatter(self, self.voice, "headingsouth")
			end
			UVDelayChatter()
			UVTextChatter(self, args, 'UpdateHeading', 'South')
		elseif Heading > 135 and Heading < 225 then --West
			if !GetConVar("unitvehicle_chattertext"):GetBool() then
				local airrandomno = math.random(1,2)
				local airunits = ents.FindByClass("uvair")
				if next(airunits) ~= nil then
					local random_entry = math.random(#airunits)	
					local unit = airunits[random_entry]
					if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
						return UVSoundChatter(unit, unit.voice, "headingwest")
					end
				end
				return UVSoundChatter(self, self.voice, "headingwest")
			end
			UVDelayChatter()
			UVTextChatter(self, args, 'UpdateHeading', 'West')
		end
	end
	
	function UVChatterRequestDisengage(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local timecheck = 5
			local airrandomno = math.random(1,2)
			local airunits = ents.FindByClass("uvair")
			if next(airunits) ~= nil then
				local random_entry = math.random(#airunits)	
				local unit = airunits[random_entry]
				if !(unit.crashing or unit.disengaging) and airrandomno == 1 then
					timecheck = UVSoundChatter(unit, unit.voice, "requestdisengage")
				else
					timecheck = UVSoundChatter(self, self.voice, "requestdisengage")
				end
			else
				timecheck = UVSoundChatter(self, self.voice, "requestdisengage")
			end
			timer.Simple(timecheck, function()
				if next(ents.FindByClass("npc_uv*")) ~= nil then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					if unit == self then return end
					UVChatterDoNotDisengage(unit, self)
				end
			end)
			return
		end
		UVDelayChatter()
		timer.Simple(math.random(3,5), function()
			if next(ents.FindByClass("npc_uv*")) ~= nil then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				if unit == self then return end
				UVChatterDoNotDisengage(unit, self)
			end
		end)
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'RequestDisengage', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'RequestDisengage', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'RequestDisengage', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'RequestDisengage', 'UVInterceptor')
		end
	end
	
	function UVChatterDoNotDisengage(self, unit)
		if UVChatterDelayed or !unit.callsign then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "donotdisengage")
		end
		UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		if unit.callsign then
			args['altcallsign'] = unit.callsign
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'DoNotDisengage', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'DoNotDisengage', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'DoNotDisengage', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'DoNotDisengage', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'DoNotDisengage', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'DoNotDisengage', 'UVCommander')
		end
	end
	
	function UVChatterDispatchCallDamageToProperty(heatlevel)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(Entity(1), 1, "dispatchcalldamagetoproperty", 6)
		end
		local seconds = UVDelayChatter()
		
		local args = {}
		-- if IsValid(self.e) then
		-- 	args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		-- end
		
		if heatlevel < 3 then
			UVTextChatter(self, args, 'DispatchCallDamageToProperty', 'Low')
		elseif heatlevel < 5 then
			UVTextChatter(self, args, 'DispatchCallDamageToProperty', 'Medium')
		else
			UVTextChatter(self, args, 'DispatchCallDamageToProperty', 'High')
		end
		
		return seconds
	end
	
	function UVChatterDispatchCallHitAndRun(heatlevel)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(Entity(1), 1, "dispatchcallhitandrun", 6)
		end
		local seconds = UVDelayChatter()
		
		local args = {}
		-- if IsValid(self.e) then
		-- 	args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		-- end
		
		if heatlevel < 3 then
			UVTextChatter(self, args, 'DispatchCallHitAndRun', 'Low')
		elseif heatlevel < 5 then
			UVTextChatter(self, args, 'DispatchCallHitAndRun', 'Medium')
		else
			UVTextChatter(self, args, 'DispatchCallHitAndRun', 'High')
		end
		
		return seconds
	end
	
	function UVChatterDispatchCallSpeeding(heatlevel)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(Entity(1), 1, "dispatchcallspeeding", 6)
		end
		local seconds = UVDelayChatter()
		
		local args = {}
		-- if IsValid(self.e) then
		-- 	args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		-- end
		
		if heatlevel < 3 then
			UVTextChatter(self, args, 'DispatchCallSpeeding', 'Low')
		elseif heatlevel < 5 then
			UVTextChatter(self, args, 'DispatchCallSpeeding', 'Medium')
		else
			UVTextChatter(self, args, 'DispatchCallSpeeding', 'High')
		end
		
		return seconds
	end
	
	function UVChatterDispatchCallStreetRacing(heatlevel)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(Entity(1), 1, "dispatchcallstreetracing", 6)
		end
		local seconds = UVDelayChatter()
		
		local args = {}
		-- if IsValid(self.e) then
		-- 	args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		-- end
		
		if heatlevel < 3 then
			UVTextChatter(self, args, 'DispatchCallStreetRacing', 'Low')
		elseif heatlevel < 5 then
			UVTextChatter(self, args, 'DispatchCallStreetRacing', 'Medium')
		else
			UVTextChatter(self, args, 'DispatchCallStreetRacing', 'High')
		end
		return seconds
	end
	
	function UVChatterDispatchCallVehicleDescription(self, make, model)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "dispatchcallunknowndescription", 1)
		end
		if uvtargeting or !self or !make then return end
		local color = UVColorName(make)
		local seconds = UVDelayChatter()
		if self.v.UVPatrol or self.v.UVSupport then
			UVTextChatter(self, {['suspectmodel'] = model, ['suspectcolor'] = color}, 'DispatchCallVehicleDescription', 'UVPatrol_UVSupport')
		elseif self.v.UVPursuit or self.v.UVInterceptor then
			UVTextChatter(self, {['suspectmodel'] = model, ['suspectcolor'] = color}, 'DispatchCallVehicleDescription', 'UVPursuit_UVInterceptor')
		elseif self.v.UVSpecial or self.v.UVCommander then
			UVTextChatter(self, {['suspectmodel'] = model, ['suspectcolor'] = color}, 'DispatchCallVehicleDescription', 'UVSpecial_UVCommander')
		end
		return seconds
	end
	
	function UVChatterDispatchCallUnknownDescription(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "dispatchcallunknowndescription", 1)
		end
		if uvtargeting then return end
		local seconds = UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol or self.v.UVSupport then
			UVTextChatter(self, args, 'DispatchCallUnknownDescription', 'UVPatrol_UVSupport')
		elseif self.v.UVPursuit or self.v.UVInterceptor then
			UVTextChatter(self, args, 'DispatchCallUnknownDescription', 'UVPursuit_UVInterceptor')
		elseif self.v.UVSpecial or self.v.UVCommander then
			UVTextChatter(self, args, 'DispatchCallUnknownDescription', 'UVSpecial_UVCommander')
		end
		return seconds
	end
	
	function UVChatterCallRequestDescription(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "callrequestdescription", 1)
		end
		if uvtargeting then return end
		
		local seconds = UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'CallRequestDescription', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'CallRequestDescription', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'CallRequestDescription', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'CallRequestDescription', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'CallRequestDescription', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'CallRequestDescription', 'UVCommander')
		end
		
		return seconds
	end
	
	function UVChatterCallResponding(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "callresponding", 5)
		end
		if uvtargeting then return end
		local seconds = UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'CallResponding', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'CallResponding', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'CallResponding', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'CallResponding', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'CallResponding', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'CallResponding', 'UVCommander')
		end
		
		return seconds
	end
	
	function UVChatterCallResponded(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "callresponded")
		end
		local seconds = UVDelayChatter()
		
		local args = {}
		if IsValid(self.e) then
			args['suspectmodel'] = UVGetVehicleMakeAndModel(self.e)
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'CallResponded', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'CallResponded', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'CallResponded', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'CallResponded', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'CallResponded', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'CallResponded', 'UVCommander')
		end
		
		return seconds
	end
	
	function UVChatterPursuitStartWanted(self)
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			local timecheck = 5
			timecheck = UVSoundChatter(self, self.voice, "pursuitstartwanted", 4)
			timer.Simple(timecheck, function()
				if IsValid(self) then
					UVChatterPursuitStartAcknowledge(self)
				end
			end)
			return
		end
		UVDelayChatter()
		timer.Simple(math.random(3,4), function()
			if IsValid(self) then
				UVChatterPursuitStartAcknowledge(self)
			end
		end)
		if !IsValid(self.e) then return end
		local e = UVGetVehicleMakeAndModel(self.e)
		local args = {}
		if e then
			args['suspectmodel'] = e
		end
		
		if self.v.UVPatrol then
			UVTextChatter(self, args, 'PursuitStartWanted', 'UVPatrol')
		elseif self.v.UVSupport then
			UVTextChatter(self, args, 'PursuitStartWanted', 'UVSupport')
		elseif self.v.UVPursuit then
			UVTextChatter(self, args, 'PursuitStartWanted', 'UVPursuit')
		elseif self.v.UVInterceptor then
			UVTextChatter(self, args, 'PursuitStartWanted', 'UVInterceptor')
		elseif self.v.UVSpecial then
			UVTextChatter(self, args, 'PursuitStartWanted', 'UVSpecial')
		elseif self.v.UVCommander then
			UVTextChatter(self, args, 'PursuitStartWanted', 'UVCommander')
		end
	end

	function UVChatterStuntJump(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "stuntjump")
		end
	end

	function UVChatterStuntRoll(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "stuntroll")
		end
	end

	function UVChatterStuntSpin(self)
		if UVChatterDelayed then return end
		if !GetConVar("unitvehicle_chattertext"):GetBool() then
			return UVSoundChatter(self, self.voice, "stuntspin")
		end
	end
	
end
if CLIENT then
	net.Receive("UV_Text", function()
		chat.AddText( unpack(net.ReadTable()) )
	end)
end