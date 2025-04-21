[!!! NOTE !!!] This addon is NOT finished. Expect unoptimized coding and bugs. Simfphys is currently 100% supported, other vehicle bases have limited support for now.

--Unit Vehicles [Build 2025-04-25] (FREE EARLY ACCESS)

///Unit Vehicles (UV) - Police chase addon///

"I want every single unit, after the guy." ~ Sergeant Cross

Don't have friends to chase you? No worries! You can now have car chases with AI-controlled vehicles!

This composes of different Police AIs called "Units", with each one of them having its own set of tactics/pursuit tech to chase down each target!

***It is highly recommended that your map has Navmesh and Decent Vehicle waypoints for them to patrol/navigate!***

Units:
	• Patrol
		- Base Unit. Nothing special!
		- Least aggressive.
		- Best used with low-tier/everyday vehicles.
	• Support
		- Nothing special!
		- Least aggressive.
		- Best used with SUVs/off-road vehicles.
	• Pursuit
		- Can be equipped with pursuit tech!
		- Mildly aggressive.
		- Best used with sports cars.
	• Air
		- Aerial Unit. Can deploy spike strips or explosive barrels!
		- Tells other Units where you are.
		- Has unlimited visual range.
	• Interceptor
		- Can be equipped with pursuit tech!
		- Mildly aggressive.
		- Best used with supercars.
	• Special
		- Can be equipped with UPGRADED pursuit tech!
		- Very aggressive!
		- Best used with SWAT vehicles.
	• Commander
		- Top Unit. Can be equipped with UPGRADED pursuit tech!
		- Very aggressive!
		- Best used with Sergeant Cross.
	• RHINO (Unit Manager Tool required)
		- A Unit like no other. Specializes in head-on collisions. Nothing else.
		- Can disable your vehicle temporarily! Don't even touch it!
		- Best used with SWAT vehicles (heavier and faster vehicles works best).

Racers:
	• Ain't a Unit at all, this is the complete opposite!
	• Racer Vehicles (RV) race at full pace on DV placed waypoints.
	• Racer Vehicles are NOT Decent Vehicles. They don't give way, don't use signals and are generally pests that UVs must quell.

Features:
	• Spike strip weapon.
	• Pursuit system (works similarly to NFS games). You can't exit your vehicle whilst being chased!
	• Units that can team up and use pursuit tactics to stop you! They can talk to each other in the chatbox or the radio chatter!
	• Pursuit Breakers! Create your own structure anywhere on the map and save it! During pursuits, smash into them to disable Units!
	• HUD to keep track of pursuit statistics.
	• simfphys, Photon and Decent Vehicles support (more support features to come).
	• Tons of customization options via ConVars to tweak most of the above features.
	
Normal Usage:
	1. Spawn any vehicle(s).
	2. Spawn any Unit(s) under NPCs\Unit Vehicles on the vehicle.
	3. Grab a vehicle of your own. Speed past them OR ram them hard enough!
	4. If they start chasing you, have fun!

Heat Levels:
	• Get Units to spawn automatically and have lengthy pursuits!
	• Unit Manager Tool is required which allows you chose which Units can chase you at different Heat Levels (YOU CAN ADJUST MANY OTHER VARIABLES SUCH AS MAX UNITS AND HELICOPTER AVAILABILITY).
	• Enabled when "unitvehicle_heatlevels" is set to 1 in the console and that the map has Decent Vehicle waypoints.
	• Build Bounty by spending time in pursuit or attacking Units. The more Bounty, the more Heat, the more Units.
		- Heat Level 1 (0 Bounty)
		- Heat Level 2 (10,000 Bounty)
		- Heat Level 3 (100,000 Bounty)
		- Heat Level 4 (500,000 Bounty)
		- Heat Level 5 (1,000,000 Bounty)
		- Heat Level 6 (5,000,000 Bounty)
	
Things to try out:
	• Record your best car chases!
	• Create your very own Unit!
	• Have Units chase you in Decent Vehicle noded maps! They can spawn from pretty much anywhere!
	• Cause a massive pile up!
	• Escape!
	• Reach Heat Level 6!
	• Hit a spike strip!
	• Get busted!
	• Have Units chase Decent Vehicles in Decent Vehicle noded maps!
	• Get into car chases on maps filled with traffic!
	
Suitable for:
	• Car chases/action
	• Cinematic scenes
	
ConVars (YOU CAN GO TO SETTINGS UNDER THE OPTIONS TAB FOR EASIER CONFIGURATION):
	• unitvehicle_heatlevels (Default value: 1, "If set to 1, Unit Vehicles spawns backup using the auto spawn system based on Heat Levels." )
	• unitvehicle_targetvehicletype (Default value: 1, "1 = All vehicles are targeted. 2 = Decent Vehicles are targeted only. 3 = Other vehicles besides Decent Vehicles are targeted.")
	• unitvehicle_detectionrange (Default value: 30, "Minimum spawning distance to the vehicle in studs when manually spawning Units. Use greater values if you have trouble spawning Units.")
	• unitvehicle_playmusic (Default value: 1, "If set to 1, Pursuit themes will play.")
	• unitvehicle_neverevade (Default value: 0, "If set to 1, you won't be able to evade the Unit Vehicles. Good luck.")
	• unitvehicle_bustedtimer (Default value: 5, "Time in seconds before the enemy gets busted. Set this to 0 to disable.")
	• unitvehicle_killswitchtimer (Default value: 3, "Time in seconds for Units to killswitch enemy vehicles when close. Set this to 0 to disable.")
	• unitvehicle_canwreck (Default value: 1, "If set to 1, Unit Vehicles can crash out. Set this to 0 to disable.")
	• unitvehicle_helicopter (Default value: 1, "If set to 1, Units can deploy helicopters which engages targets.")
	• unitvehicle_chatter (Default value: 1, "If set to 1, Units' radio chatter can be heard.")
	• unitvehicle_speedlimit (Default value: 60, "Speed limit in MPH for idle Units to enforce. Patrolling Units still enforces speed limits set on DV Waypoints. Set this to 0 to disable.")
	• unitvehicle_roadblock (Default value: 1, "If set to 1, Units can deploy roadblocks/spike strips ahead of their target.")
	• unitvehicle_autohealth (Default value: 1, "If set to 1, all suspects will have unlimited vehicle health and your health as a suspect will be set according to your vehicle's mass.")
	• unitvehicle_minheatlevel (Default value: 1, "Sets the minimum Heat Level achievable during pursuits (1-6). Use high Heat Levels for more aggressive Units on your tail and vice versa.")
	• unitvehicle_maxheatlevel (Default value: 6, "Sets the maximum Heat Level achievable during pursuits (1-6). Use low Heat Levels for less aggressive Units on your tail and vice versa.")
	• unitvehicle_spikestripduration (Default value: 20, "Unit Vehicle: Time in seconds before the tires gets reinflated after hitting the spikes. Set this to 0 to disable reinflating tires.")
	• unitvehicle_pathfinding (Default value: 1, "If set to 1, Units uses A* pathfinding algorithm on navmesh/Decent Vehicle Waypoints to navigate. Impacts computer performance.")
	• unitvehicle_vcmodelspriority (Default value: 0, "If set to 1, Units using base HL2 vehicles will attempt to use VCMod ELS over Photon if both are installed.")
	• unitvehicle_callresponse (Default value: 1, "If set to 1, Units will spawn and respond to the location regarding various calls.")
	• unitvehicle_chattertext (Default value: 0, "If set to 1, Units' radio chatter will be displayed in the chatbox instead.")
	• unitvehicle_pursuittheme (Default value: nfsmostwanted, "Type either one of these two pursuit themes to play from: 'nfsmostwanted' 'nfsundercover'.")
	• unitvehicle_enableheadlights (Default value: 0, "If set to 1, Units and Racer Vehicles will shine their headlights.")
	• unitvehicle_relentless (Default value: 1, "If set to 1, Units will ram the target more frequently.")
	• unitvehicle_spawnmainunits (Default value: 1, "If set to 1, main AI Units (Patrol, Support, etc.) will spawn to patrol/chase.")
	• unitvehicle_dvwaypointspriority (Default value: 0, "If set to 1, Units will attempt to navigate on Decent Vehicle Waypoints FIRST instead of navmesh (if both are installed).")
	• unitvehicle_pursuitthemeplayrandomheat (Default value: 0, "If set to 1, random Heat Level songs will play during pursuits.")

	
ConCommands (YOU CAN GO TO THE PURSUIT MANAGER UNDER THE OPTIONS TAB FOR EASIER EXECUTION):
	• uv_spawnvehicles ("Automatically spawns idle/patrolling Unit Vehicles on the road.")
	• uv_despawnvehicles ("Despawns all Unit Vehicles.")
	• uv_startpursuit ("Starts a pursuit with Unit Vehicles chasing you. Be prepared!")
	
Confirmed Bug(s):
	• UVs/equipments used in roadblocks can clip through surface/walls, especially in uneven/tight areas.
	• UVs using Photon will constantly loop the siren prematurely (this can be fixed by typing "photon_emv_stayon 1" into the console).
	• UVs may get stuck when automatically spawned sometimes with world, vehicles, props, etc.
	• Air Support can get stuck inside some places in some maps (ex. above the tunnel in gm_canyon_circuit).
	• Air Support can despawn when flown out of bounds (by crazy physics detection).
	• UVs/roadblocks may automatically spawn relatively close to the target(s).
	• UV's radio chatter may spam out at times.
	• UV's navigation is not always perfect! Some maps may have badly designed navmesh/DV Waypoints which can hinder their pathfinding.
