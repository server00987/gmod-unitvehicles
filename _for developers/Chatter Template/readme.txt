- Extract and place this under sound/chatter2
- Rename and/or duplicate 'example_pd' folder if you like
- You can also rename and/or duplicate 'airunit' and 'groundunit' folders if you like for added variety
- 'dispatch' and 'misc' folders are already handled by the chatter system, DO NOT RENAME THEM

--- DISPATCH ---

*no voice restriction, so it's not just dispatch themself who is talking...

*during a call, these folders will play in order: 
addressgroup > dispatchcalldamagetoproperty/dispatchcallhitandrun/dispatchcallspeeding/dispatchcallstreetracing > d_location > unitrequest

*when cooldown starts, these folders will play in order: 
dispbreakaway > d_location > quadrant

addressgroup = "Attention all Units ..."
airinitalize = "Air Unit has been deployed"
arrestacknowledge = "Copy that, suspect is in custody"
backuponscene = "Backup is on scene"
backupontheway = "Backup is on its way"
callrequestdescription = "Do you have the make and model of the suspect's vehicle?"
chirpgeneric = *beep boop*
d_location = "... near the *location* ..."
dispatchacknowledgerequest = "Roger that"
dispatchcalldamagetoproperty = "... we got reports of a driver doing a lot of damage, they were last seen ..."
dispatchcallhitandrun = "... we got reports of a hit and run driver, they were last seen ..."
dispatchcallspeeding = "... we got reports of a speeding driver, they were last seen ..."
dispatchcallstreetracing = "... we got reports of a group of street racers, they were last seen ..."
dispatchcallunknowndescription = "Caller did not get a good look at the vehicle, standby"
dispatchcallvehicledescription = (TO BE IMPLEMENTED WITH UVGetVehicleMakeAndModel SCRIPT)
dispatchdenyrequest = "Negative"
dispatchidletalk = *random conversation between dispatch and unit*
dispatchjammerend = "All radio communications restored, resume call on Channel *number*"
dispatchmultipleunitsdownacknowledge = "Roger that, EMS are on their way"
dispbreakaway = "All Units, suspect was last seen ..."
heat2 = "Condition 2"
heat3 = "Condition 3"
heat4 = "Condition 4"
heat5 = "Condition 5/Special Units taking over the pursuit soon"
heat5reassure = "Not much I can do"
heat6 = "Condition 6"
heat7 = "Condition 7"
heat8 = "Condition 8"
heat9 = "Condition 9"
heat10 = "CONDITION 10"
idletalk = *random conversation between units*
losingupdate = "We got a possible match"
lost = "Dispatch, we should clear this call"
lostacknowledge = "All Units, clear this call and resume patrols"
pursuitbreakergas = "Suspect has hit the gas pumps"
pursuitstartacknowledge = "All Units, we got a pursuit in progress"
pursuitstartacknowledgehigh = "All Units, we have found our Most Wanted suspect"
pursuitstartacknowledgemed = "All Units, we have found a high-risk street racer"
pursuitstartacknowledgemultipleenemies = "Be advised, Units are in pursuit of multiple vehicles"
quadrant = "... quadrant to be set up near their last known location"
requestsitrep = "Units on pursuit, please update status" 
responding = "Unit here, show me responding to the pursuit"
roadblockdeployed = "Roadblock deployed"
roadblockhit = "Suspect has hit the roadblock"
roadblockmissed = "Suspect has gone around the roadblock"
spikestriphit = "Suspect hit the spikes"
unitrequest = "... I need Units to respond"